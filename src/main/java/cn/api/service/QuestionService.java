package cn.api.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.api.service.NewsService.NewsType;
import cn.util.DataConvert;
import cn.util.JPushUtil;
import cn.util.UtilDate;


@Service
@Transactional(rollbackFor = Exception.class)
public class QuestionService {
	
	@Autowired
	SqlSession sqlSession;
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	NewsService newsService;
	
	//添加提问
	public Map<String,Object> addQuestions(Map map) {
		Map<String,Object> result = new HashMap<String, Object>(); 
		
		//专栏作家不可以向自己提问
		if(DataConvert.ToInteger(map.get("type"))==2 && DataConvert.ToInteger(map.get("userId"))==DataConvert.ToInteger(map.get("teacherId"))) {
			result.put("result", 0);
			result.put("msg", "专栏作家不可以向自己提问!");
			return result;
		}
		int resultStatus = 0;
		String payLogId = "";
		try {
			int row = sqlSession.insert("questionDao.addQuestions",map);
			String questionId = map.get("questionId")+"";
			
			//添加payLog
			String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
			String threeRandom = UtilDate.getThree();//三维随机数
			String sixRandom = ((int)((Math.random()*9+1)*100000))+"";//六位随机数
			map.put("questionId", questionId);
			map.put("source", 3);
			map.put("orderNo", ymds+sixRandom);
			
			int rw = sqlSession.insert("questionDao.addPayLogInfo",map);
			payLogId = map.get("payLogId")+"";
			
			resultStatus = 1;
			
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		
		if(resultStatus==1){
			result.put("payLogId", payLogId);
			result.put("result", 1);
			result.put("msg", "提问成功！");
		}else{
			result.put("result", 0);
			result.put("msg", "提问失败！");
		}
		return result;
	}
	/**
	 * 问答列表
	 * @param teacherId
	 * @return
	 */
	public List selQuestionList(Map map) {
		return sqlSession.selectList("teacherDao.selectTeacherAudit", map);
	}
	/**
	 * 问答列表count
	 * @param map
	 * @return
	 */
	public long selQuestionCount(Map<String, Object> map) {
		return sqlSession.selectOne("teacherDao.selQuestionCount", map);
	}
	/**
	 * 获取专家答疑分类
	 * @return
	 */
	public List selectMeetType() {
		return sqlSession.selectList("teacherDao.selectMeetType");
	}
	
	//添加旁听支付信息
	public int addListenQuestion(Map<String, Object> map) {
		
		String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
		String threeRandom = UtilDate.getThree();//三维随机数
		String sixRandom = ((int)((Math.random()*9+1)*100000))+"";//六位随机数
		map.put("source", 4);
		map.put("orderNo", ymds+sixRandom);
		
		int rw = sqlSession.insert("questionDao.addListenInfo",map);//添加旁听记录
		map.put("questionId", map.get("auditId")+"");
		int row = sqlSession.insert("questionDao.addPayLogInfo",map);//添加payLog记录
		int payLogId = 0;
		if(row>0){
			payLogId = Integer.parseInt(map.get("payLogId")+"");
		}
		return payLogId;
		
	}
	//查询问题内容
	public Map selQuestionInfo(Integer questionId) {
		return sqlSession.selectOne("questionDao.selQuestionInfo", questionId);
	}
	/**
	 * 通过后台去回答提问
	 * @param map
	 * @return
	 */
	@Transactional
	public Map findQuestionDetails(Map<String, Object> map) {
		return sqlSession.selectOne("questionDao.findByQuestion", map);
	}
	
	//回答提问
	@Transactional
	public int answerQuestion(Map<String, Object> map) {
		//先去查询是否已经退款
		Map<String,Object> interlocutionMap = new HashMap<String,Object>();
		interlocutionMap = sqlSession.selectOne("interlocutionDao.selInterlocutionSingleRecord", map.get("id").toString());
		if(interlocutionMap !=null) {
			String refundIsSuccess = interlocutionMap.get("refundIsSuccess").toString();//余额退款是否成功: 0-未成功(默认) , 1-退款成功
			if(Integer.parseInt(refundIsSuccess) == 1) {
				return -1;
			}
		}
		int row = sqlSession.update("questionDao.answerQuestion", map);
		if(row > 0) {
			//查询问题详情
			Map ma = sqlSession.selectOne("questionDao.findByQuestion", map);
			//增加回答消息
			newsService.addUserNews(DataConvert.ToInteger(ma.get("lecturer")), DataConvert.ToInteger(ma.get("questioner")), DataConvert.ToInteger(ma.get("id")), NewsType.answer, null);
			//查询设备信息
			String phoneId = sqlSession.selectOne("JPushDao.selPhoneIdByQuestionId",map);
			if(null!=phoneId && !phoneId.equals("")) {
				List<String> list = new ArrayList();
				list.add(phoneId);
				JPushUtil.sendRegistrationId("您有一个新消息", list);
			}
		}
		return row;
	}

}
