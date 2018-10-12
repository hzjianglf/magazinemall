package cn.admin.interlocution.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.util.DataConvert;
import cn.util.JPushUtil;
import cn.util.UtilDate;

@Service
public class InterlocutionService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;

	
	/**
	 * 列表记录数量
	 * @param reqMap
	 * @return
	 */
	public long selInterlocutionCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("interlocutionDao.selInterlocutionCount", reqMap);
	}
	/**
	 * 列表查询
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selInterlocutionList(Map<String, Object> reqMap) {
		return sqlSession.selectList("interlocutionDao.selInterlocutionList", reqMap);
	}
	//审核
	@Transactional
	public int updateStatus(Map map) {
		//根据id去问答表查询是否存在这条记录
		Map<String,Object> interlocutionMap = new HashMap<String,Object>();
		interlocutionMap = sqlSession.selectOne("interlocutionDao.selInterlocutionSingleRecord", map.get("id").toString());
		if(interlocutionMap !=null) {
			String refundIsSuccess = interlocutionMap.get("refundIsSuccess").toString();//余额退款是否成功: 0-未成功(默认) , 1-退款成功
			if(Integer.parseInt(refundIsSuccess) == 1) {
				return -1;
			}
		}
		
		String questionState = map.get("status").toString();//审核状态: 0待审核 1审核通过 2审核驳回
		int row = 0;
		BigDecimal askMoney = new BigDecimal("0");//interlocution表-提问价格money
		String userId = "";//interlocution表-提问者id
		Map<String, Object> paramMap = new HashMap<String, Object>();
		BigDecimal balance = new BigDecimal("0");
		BigDecimal totalMoney = new BigDecimal("0");
		Map<String, Object> paramMap1 = new HashMap<String, Object>();
		
		if(Integer.parseInt(questionState)==2) {//2审核驳回
			String id = map.get("id").toString();//interlocution表主键id
			try {
				//根据主键id查询interlocution表单条记录
				interlocutionMap = sqlSession.selectOne("interlocutionDao.selInterlocutionSingleRecord", id);
				if(interlocutionMap !=null) {
					askMoney = new BigDecimal(interlocutionMap.get("money").toString());//interlocution表-提问价格money
					userId = interlocutionMap.get("questioner").toString();//interlocution表-提问者id
					//1.获取useraccount表balance字段
					Map<String, Object> balanceMap = new HashMap<String, Object>();
					balanceMap = sqlSession.selectOne("interlocutionDao.selBalance",userId);
					if(balanceMap !=null) {
						balance = new BigDecimal(balanceMap.get("balance").toString());
						totalMoney = balance.add(askMoney);
						paramMap.put("userId", userId);
						paramMap.put("totalMoney", totalMoney);
						//2.更新useraccount表balance字段
						boolean flag = sqlSession.update("interlocutionDao.updateBalance",paramMap)>0;
						if(!flag) {
							throw new Exception("更新useraccount表余额账户失败！");
						}
						//3.插入useraccountlog表记录
						paramMap.put("type", 6);
						paramMap.put("money", askMoney);
						paramMap.put("balance", totalMoney);
						String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
						String sixRandom = ((int)((Math.random()*9+1)*100000))+"";//六位随机数
						paramMap.put("num", ymds+sixRandom);
						paramMap.put("status", 1);
						Calendar cal = Calendar.getInstance();
						int month = cal.get(Calendar.MONTH) + 1;// 当前月份
						paramMap.put("month", month);
						boolean flagAdd = sqlSession.insert("interlocutionDao.inertAccountLogRecord",paramMap)>0;
						if(!flagAdd) {
							throw new Exception("插入useraccountlog表失败！");
						}
						//4.修改interlocution表refundIsSuccess为1(1-为退款成功)
						paramMap1.put("id", id);
						paramMap1.put("questionState", map.get("status").toString());
						paramMap1.put("remark", map.get("remark").toString());
						row = sqlSession.update("interlocutionDao.updateRefundIsSuccess",paramMap1);
						if(row<=0) {
							throw new Exception("更新interlocution表审核状态失败！");
						}
					}
				}
			} catch (Exception e) {
				System.out.println(e.getMessage());
				try {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				} catch (Exception e2) {
				}
			}
		}else if(Integer.parseInt(questionState)==1) {
			//极光推送通过问题id查找专家设备号
			String phoneId = sqlSession.selectOne("JPushDao.selTeacherIdByQuestionId",DataConvert.ToInteger(map.get("id")));
			if(null!=phoneId && !phoneId.equals("")) {
				List<String> list = new ArrayList();
				list.add(phoneId);
				JPushUtil.sendRegistrationId("您有一个新消息", list);
			}
			row = sqlSession.update("interlocutionDao.updateStatus", map);
		}
		return row;
	}
	//取消审核
	@Transactional
	public int cancelStatus(Map map) {
		//先去查询是否已经退款
		Map<String,Object> interlocutionMap = new HashMap<String,Object>();
		interlocutionMap = sqlSession.selectOne("interlocutionDao.selInterlocutionSingleRecord", map.get("id").toString());
		if(interlocutionMap !=null) {
			String refundIsSuccess = interlocutionMap.get("refundIsSuccess").toString();//余额退款是否成功: 0-未成功(默认) , 1-退款成功
			if(Integer.parseInt(refundIsSuccess) == 1) {
				return -1;
			}
		}
		return sqlSession.update("interlocutionDao.cancelStatus", map);
	}
	//删除问答
	public int deleteInterlocution(Map map) {
		return sqlSession.delete("interlocutionDao.deleteInterlocution", map);
	}
	@Scheduled(cron = "0 */10 * * * ?")
	public void test() {
		interlocutionByRefund();
	}
	
	/**
	 * 问答退款
	 */
	@Transactional
	public void interlocutionByRefund() {
		BigDecimal askMoney = new BigDecimal("0");//interlocution表-提问价格money
		String userId = "";//interlocution表-提问者id
		BigDecimal balance = new BigDecimal("0");
		BigDecimal totalMoney = new BigDecimal("0");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Map<String, Object> paramMap1 = new HashMap<String, Object>();
		try {
			//查询满足退款条件的interlocution表记录
			List<Map<String, Object>> interlocutionList = sqlSession.selectList("interlocutionDao.selRefundCondition");
			if(interlocutionList !=null && interlocutionList.size()>0) {
				for (Map<String, Object> refundMap : interlocutionList) {
					askMoney = new BigDecimal(refundMap.get("money").toString());//interlocution表-提问价格money
					userId = refundMap.get("questioner").toString();//interlocution表-提问者id
					//1.获取useraccount表balance字段
					Map<String, Object> balanceMap = new HashMap<String, Object>();
					balanceMap = sqlSession.selectOne("interlocutionDao.selBalance",userId);
					if(balanceMap !=null) {
						balance = new BigDecimal(balanceMap.get("balance").toString());
						totalMoney = balance.add(askMoney);
						paramMap.put("userId", userId);
						paramMap.put("totalMoney", totalMoney);
						//2.更新useraccount表balance字段
						boolean flag = sqlSession.update("interlocutionDao.updateBalance",paramMap)>0;
						if(!flag) {
							throw new Exception("更新useraccount表balance字段失败！");
						}
						//3.插入useraccountlog表记录
						paramMap.put("type", 6);
						paramMap.put("money", askMoney);
						paramMap.put("balance", totalMoney);
						String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
						String sixRandom = ((int)((Math.random()*9+1)*100000))+"";//六位随机数
						paramMap.put("num", ymds+sixRandom);
						paramMap.put("status", 1);
						Calendar cal = Calendar.getInstance();
						int month = cal.get(Calendar.MONTH) + 1;// 当前月份
						paramMap.put("month", month);
						boolean flagAdd = sqlSession.insert("interlocutionDao.inertAccountLogRecord",paramMap)>0;
						if(!flagAdd) {
							throw new Exception("插入useraccountlog表记录失败！");
						}
						//4.修改interlocution表refundIsSuccess为1(1-为退款成功)
						paramMap1.put("id", refundMap.get("id").toString());
						boolean flagChange = sqlSession.update("interlocutionDao.updateRefundIsSuccess",paramMap1)>0;
						if(!flagChange) {
							throw new Exception("修改interlocution表审核状态失败！");
						}
					}
				}
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
			try {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			} catch (Exception e2) {
			}
		}
		
	}
	
	
	
}
