package cn.admin.bill.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.admin.bill.model.CalcRuleSetting;
import cn.admin.bill.model.OndemandRuleSetting;
import cn.admin.bill.model.UserRuleSetting;
import cn.admin.bill.service.BillCalcService.BILL_CALC_RULE_VARS;
import cn.admin.bill.service.BillCalcService.BILL_CALC_TYPE;
import cn.util.CalendarUntil;
import cn.util.DataConvert;
import cn.util.StringHelper;

/**
 * 分账
 * @author xiaoxueling
 *
 */
@Service
public class BillService {

	@Autowired
	SqlSession sqlSession;
	@Autowired
	BillRuleService billRuleService;
	@Autowired
	HttpSession httpSession;
	@Autowired
	BillCalcService billCalcService;
	
	/**
	 * 获取 年、月 有课程销售记录、问答记录、打赏记录的专家列表
	 * @return
	 */
	private List<Map<String, Object>>getUserList(Map<String,Object> paramMap){
		return sqlSession.selectList("billDao.selectUsersForMonth", paramMap);
	}
	
	/**
	 * 获取指定专家、年、月的课程销售记录
	 * @param paramMap
	 * @return
	 */
	private List<Map<String, Object>>getOndemandListForUser(Map<String, Object> paramMap){
		return sqlSession.selectList("billDao.selectSaledOndemandListForUser", paramMap);
	}

	/**
	 * 更新分账记录表
	 * @param paramMap
	 * @return
	 */
	private boolean updateBillReckon(Map<String, Object> paramMap) {
		return  sqlSession.update("billDao.updateBillReckon", paramMap)>0;
	}
	
	/**
	 * 获取分账记录列表
	 * @param status 1未提交(默认) 2审核中 3审核失败  4审核成功
	 * @param startDate 提交开始日期 yyyy-MM-dd
	 * @param endDate 提交结束日期
	 * @param xh 展示的序号
	 * @param userName 提交人
	 * @param start
	 * @param pageSize
	 * @return
	 */
	public List<Map<String, Object>>getBillReckonList(Integer status, String startDate,String endDate,String xh,String userName,int start,int pageSize){
		List<Map<String, Object>> result=new ArrayList<Map<String, Object>>();
		
		try {
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			
			if(status!=null) {
				paramMap.put("status", status);
			}
			if(!StringHelper.IsNullOrEmpty(startDate)) {
				paramMap.put("startDate", startDate);
			}
			if(!StringHelper.IsNullOrEmpty(endDate)) {
				paramMap.put("endDate", endDate);
			}
			if(!StringHelper.IsNullOrEmpty(xh)) {
				paramMap.put("xh", xh);
			}
			if(!StringHelper.IsNullOrEmpty(xh)) {
				paramMap.put("xh", xh);
			}
			if(!StringHelper.IsNullOrEmpty(userName)) {
				paramMap.put("userName", userName);
			}
			
			if(start>=0&&pageSize>0) {
				paramMap.put("start", start);
				paramMap.put("pageSize", pageSize);
			}
			
			result=sqlSession.selectList("billDao.selectBillReckonList", paramMap);
			
		} catch (Exception e) {
			
		}
		
		return result;
	}
	
	/**
	 * 获取分账记录数量
	 * @param status 1未提交(默认) 2审核中 3审核失败  4审核成功
	 * @param startDate 提交开始日期 yyyy-MM-dd
	 * @param endDate 提交结束日期
	 * @param xh 展示的序号
	 * @param userName 提交人
	 * @param start
	 * @param pageSize
	 * @return
	 */
	public  long getBillReckonCount(Integer status, String startDate,String endDate,String xh,String userName){
		long count=0;
		
		try {
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			
			if(status!=null) {
				paramMap.put("status", status);
			}
			if(!StringHelper.IsNullOrEmpty(startDate)) {
				paramMap.put("startDate", startDate);
			}
			if(!StringHelper.IsNullOrEmpty(endDate)) {
				paramMap.put("endDate", endDate);
			}
			if(!StringHelper.IsNullOrEmpty(xh)) {
				paramMap.put("xh", xh);
			}
			if(!StringHelper.IsNullOrEmpty(xh)) {
				paramMap.put("xh", xh);
			}
			if(!StringHelper.IsNullOrEmpty(userName)) {
				paramMap.put("userName", userName);
			}
			
			count=sqlSession.selectOne("billDao.selectBillReckonCount", paramMap);
			
		} catch (Exception e) {
			
		}
		
		return count;
	}
	
	/**
	 * 作废分账记录
	 * @param id 记录Id
	 * @param isRealDelete 是否真实删除
	 * @return
	 */
	public boolean deleteBillReckon(int id,boolean isRealDelete) {
		
		boolean result=false;
		
		try {
			
			if(id<=0) {
				return result;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			
			if(isRealDelete) {
				result=sqlSession.delete("billDao.deleteBillReckon", paramMap)>0;
			}else {
				paramMap.put("status",0);
				result=updateBillReckon(paramMap);
			}
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 提交分账记录
	 * @param id 记录Id
	 * @return
	 */
	public boolean submitBillReckon(int id) {
		boolean result=false;
		try {
			
			if(id<=0) {
				return result;
			}
			
			int userId=DataConvert.ToInteger(httpSession.getAttribute("userId"));
			String time=CalendarUntil.ToDateString();
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			paramMap.put("status",2);
			paramMap.put("trialStatus", 1);
			paramMap.put("submitUserId", userId);
			paramMap.put("submitTime", time);
			
			result=updateBillReckon(paramMap);
			
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 批量提交分账记录
	 * @param idList 记录Id列表
	 * @return
	 */
	public boolean submitBillReckon(List<Integer> idList) {
		boolean result=false;
		try {
			
			if(idList==null||idList.isEmpty()) {
				return result;
			}
			
			int userId=DataConvert.ToInteger(httpSession.getAttribute("userId"));
			String time=CalendarUntil.ToDateString();
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("idList", idList);
			paramMap.put("status",2);
			paramMap.put("trialStatus", 1);
			paramMap.put("submitUserId", userId);
			paramMap.put("submitTime", time);
			
			result=updateBillReckon(paramMap);
			
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	
	
	/**
	 * 获取没有分账计算的月份
	 * @param year 指定年 为空则是本年
	 * @return
	 */
	public List<String>getMonthList(String year){
		
		List<String> months=new ArrayList<String>();
		
		String nowYear=DataConvert.ToString(Calendar.getInstance().get(Calendar.YEAR));
		
		if(StringHelper.IsNullOrEmpty(year)) {
			year=nowYear;
		}
		int max_Month=12;
		if(nowYear.equals(year)) {
			max_Month=Calendar.getInstance().get(Calendar.MONTH)+1;
		}
		
		//获取已经计算分账的月份
		Map<String, String>paramMap=new HashMap<String, String>();
		paramMap.put("year",year);
		List<String>oldList=sqlSession.selectList("billDao.selectMonthsByYear",paramMap);
		
		if(oldList==null) {
			oldList=new ArrayList<String>();
		}
		
		for (int i = 1; i <=max_Month; i++) {
			int month=i;
			if(oldList.stream().anyMatch(s->DataConvert.ToInteger(s)==month)) {
				continue;
			}
			months.add(StringHelper.PadLeft(DataConvert.ToString(i), 2, '0'));
		}
		
		return months;
	}
	
	
	/**
	 * 获取 年、月需要分帐的专家列表
	 * @param year 年
	 * @param month 月
	 * @param start
	 * @param pageSize
	 * @return
	 */
	public List<Map<String, Object>> getUserListForShow(String year,String month,int start,int pageSize){
		
		if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)) {
			return null;
		}
		month=StringHelper.PadLeft(month, 2, '0');
		
		Map<String, Object> paramMap=new HashMap<String,Object>();
		paramMap.put("year", year);
		paramMap.put("month", month);
		if(start>=0&&pageSize>0) {
			paramMap.put("start", start);
			paramMap.put("pageSize", pageSize);
		}
		
		List<Map<String, Object>> result=new ArrayList<Map<String, Object>>();
		
		try {
			
			result=getUserList(paramMap);
			
			//添加对应专家的问答分成、打赏分成、状态
			if(result!=null&&!result.isEmpty()) {
				
				for (Map<String, Object> item : result) {
					
					int userId=DataConvert.ToInteger(item.get("userId"));
					
					UserRuleSetting userRuleSetting=billRuleService.getUserRuleSetting(year, month, userId);
					
					item.put("questionRate", userRuleSetting.getQuestionRate());
					item.put("rewardRate", userRuleSetting.getRewardRate());
					item.put("status",userRuleSetting.getStatus());
				}
			}
		} catch (Exception e) {

		}
		return result;
	}
	
	/**
	 * 获取 年、月需要分帐的专家数量
	 * @param year 年
	 * @param month 月
	 * @return
	 */
	public long getUsersCountForShow(String year,String month){
		long count=0;
		try {
			
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)) {
				return count;
			}
			month=StringHelper.PadLeft(month, 2, '0');
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("year", year);
			paramMap.put("month", month);
			count=sqlSession.selectOne("billDao.selectUsersCountForMonth", paramMap);
		} catch (Exception e) {
		}
		
		return count;
	}
	
	/**
	 * 更改专家的分成状态
	 * @param year 年
	 * @param month 月
	 * @param userId 专家Id
	 * @param status 0--禁用 1--启用
	 * @return
	 */
	public synchronized boolean changeUserRuleState(String year,String month,int userId,int status) {
		boolean result=false;
		
		try {
			month=StringHelper.PadLeft(month, 2, '0');
			result=billRuleService.changeUserRuleSetting(year, month, userId, status, false);
			
		} catch (Exception e) {
			result=false;
		}
		return result;
	}

	/**
	 * 获取指定专家、年、月的课程销售记录
	 * @param year 年
	 * @param month 月
	 * @param userId 专家id
	 * @return
	 */
	public  List<Map<String, Object>>getOndemandListForShow(String year,String month,int userId){
		List<Map<String, Object>> result=new ArrayList<Map<String, Object>>();
		
		if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)||userId<=0) {
			return null;
		}
		try {
			month=StringHelper.PadLeft(month, 2, '0');
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("year", year);
			paramMap.put("month", month);
			paramMap.put("userId", userId);
			
			result=getOndemandListForUser(paramMap);
			
			//添加课程对应的分成比例、状态
			if(result!=null&&!result.isEmpty()) {
				
				for (Map<String, Object> item : result) {
					
					int ondemandId=DataConvert.ToInteger(item.get("ondemandId"));
					
					OndemandRuleSetting ondemandRuleSetting=billRuleService.getOndemandRuleSetting(year, month, userId, ondemandId);
					item.put("rate",ondemandRuleSetting.getRate());
					item.put("status",ondemandRuleSetting.getStatus());
				}
			}
			
		} catch (Exception e) {
		
		}
		
		return result;
	}

	/**
	 * 更新专家分成比例配置
	 * @param year 年
	 * @param month 月
	 * @param userId 专家id
	 * @param questionRate 问答分成比例
	 * @param rewardRate 打赏分成比例
	 * @param ondemandRuleSettings 课程分成比例配置
	 * @return
	 */
	public synchronized boolean changeUserRuleSetting(String year,String month,int userId,Double questionRate,Double rewardRate,List<OndemandRuleSetting> ondemandRuleSettings) {
		
		boolean result=false;
		if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)||userId<=0) {
			return false;
		}
		try {
			result=billRuleService.changeUserRuleSetting(year, month, userId, questionRate, rewardRate, ondemandRuleSettings,true);
			
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 分成计算
	 * @param year 年
	 * @param month 月
	 */
	@Transactional
	public  synchronized Map<String, Object> calculation(String year,String month) {
		
		/*
		 * 分成计算流程:
		 * 1.获取要分成的专家列表
		 * 		1.1 获取每个专家对应年月的销售记录
		 * 			1.1.1 根据分成比例及分成状态来获取可以进行分成的订单
		 * 			1.1.2 进行分成计算
		 * 			1.1.3 添加 bill_orderitem 关联
		 * 			1.1.4 获取总销售课程分成金额
		 * 		1.2 获取每个专家对应年月的问答记录
		 * 			1.2.1 根据问答比例来判断是否进行分成计算
		 * 			1.2.2 进行分成计算
		 * 			1.2.3 添加 bill_question 关联
		 * 			1.2.4 获取总问答分成金额
		 * 		1.3 获取专家对应年月的旁听记录
		 * 			1.3.1 根据旁听比例来判断是否进行分成计算
		 * 			1.3.2 进行分成计算
		 * 			1.3.3 添加 bill_reward 关联
		 * 			1.3.4 获取总旁听分成金额
		 * 2.添加各个专家分帐汇总信息 billreckonitem
		 * 3.汇总各个专家分成信息添加分帐批次数据 billreckon
		 * 4.同步年月对应的缓存数据到billrule
		 * 5.清除年、月对应的分成配置缓存
		*/
		
		
		Map<String, Object> result=new HashMap<String,Object>();
		result.put("result",false);
		result.put("msg", "计算失败！");
		
		try {
			
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)){
				return result;
			}
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("year", year);
			paramMap.put("month", month);
			
			CalcRuleSetting calcRuleSetting=billRuleService.getBillRule(year, month).getRuleSetting();
			if(calcRuleSetting==null) {
				throw new Exception("获取分润配置失败！");
			}
			
			//分账批次
			Map<String, Object>billReckonMap=new HashMap<String,Object>();
			//分账批次子项
			List<Map<String, Object>>billReckonItemList=new ArrayList<Map<String,Object>>();
			
			//1 获取要分帐的专家列表
			List<Map<String, Object>> userList=getUserList(paramMap);
			
			if(userList==null||userList.isEmpty()) {
				throw new Exception("没有获取到要分账的专家！");
			}
			
			/**
			 * 分成添加人userId
			 */
			int addUserId=DataConvert.ToInteger(httpSession.getAttribute("userId"));
			
			/**
			 *分成时间 
			 */
			String addTime=CalendarUntil.ToDateString();
			
			
			for (Map<String, Object> userItem : userList) {
				
				/**
				 * 专家用户Id
				 */
				int userId=DataConvert.ToInteger(userItem.get("userId"));
				
				//判断专家分成状态,如果是禁用状态则不参与分账
				UserRuleSetting userRuleSetting=billRuleService.getUserRuleSetting(year, month, userId);
				if(userRuleSetting.getStatus()==0) {
					continue;
				}
				
				/**
				 * 课销分成记录表
				 */
				List<Map<String, Object>>bill_OrderItemList=new ArrayList<Map<String,Object>>();
				
				/**
				 * 问答分成记录表
				 */
				List<Map<String, Object>>bill_QuestionList=new ArrayList<Map<String,Object>>();
				
				/**
				 * 打赏分成记录表
				 */
				List<Map<String, Object>>bill_RewardList=new ArrayList<Map<String,Object>>();
				
				paramMap.put("userId",userId);
				
				//1.1 获取每个专家对应年月的销售记录
				List<Map<String, Object>> orderItemList=sqlSession.selectList("billDao.selectOrderItemsForUser",paramMap);
				
				if(orderItemList!=null&&!orderItemList.isEmpty()) {
					
					List<OndemandRuleSetting> ondemandRuleSettings=userRuleSetting.getOndemandRuleList();
					
					if(ondemandRuleSettings!=null&&!ondemandRuleSettings.isEmpty()) {
						
						
						for(Map<String, Object>orderItem:orderItemList) {
							
							//1.1.1 根据分成比例及分成状态来获取可以进行分成的订单
							int ondemandId=DataConvert.ToInteger(orderItem.get("productid"));
							
							OndemandRuleSetting ondemandRuleSetting=null;
							
							if(ondemandRuleSettings.stream().anyMatch(f->f.getOndemandId()==ondemandId)) {
								ondemandRuleSetting=ondemandRuleSettings.stream().filter(f->f.getOndemandId()==ondemandId).findFirst().get();
							}
							
							if(ondemandRuleSetting==null||ondemandRuleSetting.getStatus()==0||
							   ondemandRuleSetting.getRate()==null){
								continue;
							}
							
							double rate=ondemandRuleSetting.getRate().doubleValue();
							if(rate<=0) {
								continue;
							}
							
							//1.1.2 进行分成计算
							
							//课销收入
							double money=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.ONDEMAND_SALES_INCOME,calcRuleSetting,rate,orderItem);
							orderItem.put(BILL_CALC_RULE_VARS.ONDEMAND_SALES_INCOME.getValue(), money);
							//课销营业税
							double salesTax=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.ONDEMAND_SALES_TAX,calcRuleSetting,rate,orderItem);
							orderItem.put(BILL_CALC_RULE_VARS.ONDEMAND_SALES_TAX.getValue(),salesTax);
							//课销分成
							double separate=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.ONDEMAND_SALES_SEPARATE,calcRuleSetting,rate,orderItem);
							
							//1.1.3 添加 bill_orderitem 关联
							Map<String, Object>bill_orderItem=new HashMap<String,Object>();
							bill_orderItem.put("orderItemId",orderItem.get("id"));
							bill_orderItem.put("rate",rate);
							bill_orderItem.put("money", separate);
							bill_orderItem.put("salesTax", salesTax);
							bill_orderItem.put("status", 1);
							bill_orderItem.put("addTime",addTime);
							
							bill_OrderItemList.add(bill_orderItem);
						}
					}
					
				}
				
				//1.2 获取每个专家对应年月的问答记录
				List<Map<String, Object>> questionList=sqlSession.selectList("billDao.selectQuestionsForUser",paramMap);
				if(questionList!=null&&!questionList.isEmpty()) {
					//1.2.1 根据问答比例来判断是否进行分成计算
					
					Double questionRate=userRuleSetting.getQuestionRate();
					if(questionRate!=null) {
						
						double rate=questionRate.doubleValue();
						if(rate>0) {
							
							for (Map<String, Object> questionItem : questionList) {
								
								//1.2.2 进行分成计算
								//问答收入
								double money=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.QUESTION_SALES_INCOME,calcRuleSetting,rate,questionItem);
								questionItem.put(BILL_CALC_RULE_VARS.QUESTION_SALES_INCOME.getValue(), money);
								//问答营业税
								double salesTax=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.QUESTION_SALES_TAX,calcRuleSetting,rate,questionItem);
								questionItem.put(BILL_CALC_RULE_VARS.QUESTION_SALES_TAX.getValue(),salesTax);
								//问答分成
								double separate=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.QUESTION_SALES_SEPARATE,calcRuleSetting,rate,questionItem);
								
								//1.2.3 添加 bill_question 关联
								Map<String, Object>bill_question=new HashMap<String,Object>();
								bill_question.put("questionId",questionItem.get("id"));
								bill_question.put("rate",rate);
								bill_question.put("money", separate);
								bill_question.put("salesTax", salesTax);
								bill_question.put("status", 1);
								bill_question.put("addTime",addTime);
								
								bill_QuestionList.add(bill_question);
								
							}
							
						}
					}
				}
				
				//1.3 获取专家对应年月的旁听记录
				List<Map<String, Object>> rewardList=sqlSession.selectList("billDao.selectRewardsForUser",paramMap);
				if(rewardList!=null&&!rewardList.isEmpty()) {
					
					//1.3.1  根据旁听比例来判断是否进行分成计算
					
					Double rewardRate=userRuleSetting.getRewardRate();
					if(rewardRate!=null) {
						
						double rate=rewardRate.doubleValue();
						if(rate>0) {
							
							for (Map<String, Object> rewardItem : rewardList) {
								
								//1.3.2 进行分成计算
								
								//打赏收入
								double money=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.REWARD_SALES_INCOME,calcRuleSetting,rate,rewardItem);
								rewardItem.put(BILL_CALC_RULE_VARS.REWARD_SALES_INCOME.getValue(), money);
								//打赏营业税
								double salesTax=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.REWARD_SALES_TAX,calcRuleSetting,rate,rewardItem);
								rewardItem.put(BILL_CALC_RULE_VARS.REWARD_SALES_TAX.getValue(),salesTax);
								//打赏分成
								double separate=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.REWARD_SALES_SEPARATE,calcRuleSetting,rate,rewardItem);
								
								//1.3.3 添加 bill_reward 关联
								Map<String, Object>bill_reward=new HashMap<String,Object>();
								bill_reward.put("rewardId",rewardItem.get("id"));
								bill_reward.put("rate",rate);
								bill_reward.put("money", separate);
								bill_reward.put("salesTax", salesTax);
								bill_reward.put("status", 1);
								bill_reward.put("addTime",addTime);
								
								bill_RewardList.add(bill_reward);
							}
						}
					}
				}
				
				//2.添加各个专家分帐汇总信息 billreckonitem
				
				//2.1汇总分成金额
				double ondemandMoney=bill_OrderItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("money"))).sum();
				double questionMoney=bill_QuestionList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("money"))).sum();
				double rewardMoney=bill_RewardList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("money"))).sum();
				double ondemandSalesTax=bill_OrderItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("salesTax"))).sum();
				double questionSalesTax=bill_QuestionList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("salesTax"))).sum();
				double rewardSalesTax=bill_RewardList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("salesTax"))).sum();
				
				Map<String, Object> billReckonItem=new HashMap<String,Object>();
				billReckonItem.put("userId", userId);
				billReckonItem.put("ondemandMoney",ondemandMoney);
				billReckonItem.put("questionMoney",questionMoney);
				billReckonItem.put("rewardMoney",rewardMoney);
				billReckonItem.put("salesTax",ondemandSalesTax+questionSalesTax+rewardSalesTax);
				billReckonItem.put("addUserId", addUserId);
				billReckonItem.put("addTime", addTime);
				
				//添加关联
				billReckonItem.put("bill_orderitem", bill_OrderItemList);
				billReckonItem.put("bill_question", bill_QuestionList);
				billReckonItem.put("bill_reward", bill_RewardList);
				
				//应发金额
				double shouldMoney=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.SHOULD_PAYMENT, calcRuleSetting,billReckonItem);
				billReckonItem.put("shouldMoney", shouldMoney);
				
				//个人所得税
				double personalTax=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.PERSIONAL_TAX, calcRuleSetting,billReckonItem);
				billReckonItem.put("personalTax", personalTax);
				
				//实发金额
				double  actualMoney=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.ACTUAL_PAYMENT, calcRuleSetting,billReckonItem);
				billReckonItem.put("actualMoney", actualMoney);
				
				billReckonItemList.add(billReckonItem);
			}
			
			//3.汇总各个专家分成信息添加分帐批次数据 billreckon
			
			int userCount=billReckonItemList.size();
			double totalOndemandMoney=billReckonItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("ondemandMoney"))).sum();
			double totalQuestionMoney=billReckonItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("questionMoney"))).sum();
			double totalRewardMoney=billReckonItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("rewardMoney"))).sum();
			double totalSalesTax=billReckonItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("salesTax"))).sum();
			double totalPersonalTax=billReckonItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("personalTax"))).sum();
			double totalShouldMoney=billReckonItemList.stream().mapToDouble(m->DataConvert.ToDouble(m.get("shouldMoney"))).sum();
			
			Map<String, Object>billReckon=new HashMap<String,Object>();
			billReckon.put("name", year+"年度"+month+"月份");
			billReckon.put("year", year);
			billReckon.put("month",month);
			billReckon.put("userCount", userCount);
			billReckon.put("totalOndemandMoney", totalOndemandMoney);
			billReckon.put("totalQuestionMoney", totalQuestionMoney);
			billReckon.put("totalRewardMoney", totalRewardMoney);
			billReckon.put("totalSalesTax", totalSalesTax);
			billReckon.put("totalPersonalTax", totalPersonalTax);
			billReckon.put("totalShouldMoney", totalShouldMoney);
			billReckon.put("status", 1);
			billReckon.put("trialStatus",0);
			billReckon.put("addUserId", addUserId);
			billReckon.put("addTime", addTime);
			
			boolean flag=sqlSession.insert("billDao.insertBillReckon", billReckon)>0;
			if(!flag) {
				throw new Exception("添加分账批次表失败！");
			}
			
			int reckonId=DataConvert.ToInteger(billReckon.get("id"));
			if(reckonId<=0) {
				throw new Exception("添加分账批次表失败！");
			}
			
			//添加子项
			for (Map<String, Object> item : billReckonItemList) {
				
				item.put("reckonId", reckonId);
				flag=sqlSession.insert("billDao.insertBillReckonItem", item)>0;
				if(!flag) {
					throw new Exception("添加分账批次子表失败！");
				}
				
				int reckonItemId=DataConvert.ToInteger(item.get("id"));
				if(reckonItemId<=0) {
					throw new Exception("添加分账批次子表失败！");
				}
				
				//添加订单分成记录表关联表
				List<Map<String, Object>>bill_OrderItemList=(List<Map<String, Object>>)item.get("bill_orderitem");
				if(bill_OrderItemList!=null&&!bill_OrderItemList.isEmpty()){
					bill_OrderItemList.forEach(f->{
						f.put("reckonItemId", reckonItemId);
					});
					
					item.put("list",bill_OrderItemList);
					
					flag=sqlSession.insert("billDao.batchInsertBillOrderItem", item)>0;
					if(!flag) {
						throw new Exception("添加订单分成记录表失败！");
					}
				}
				
				//添加问答分成记录表关联表
				List<Map<String, Object>>bill_QuestionList=(List<Map<String, Object>>)item.get("bill_question");
				
				if(bill_QuestionList!=null&&!bill_QuestionList.isEmpty()){
					bill_QuestionList.forEach(f->{
						f.put("reckonItemId", reckonItemId);
					});
					
					item.put("list",bill_QuestionList);
					
					flag=sqlSession.insert("billDao.batchInsertBillQuestion", item)>0;
					if(!flag) {
						throw new Exception("添加问答分成记录表失败！");
					}
				}
				
				
				//添加打赏分成记录表关联表
				List<Map<String, Object>>bill_RewardList=(List<Map<String, Object>>)item.get("bill_reward");
				
				if(bill_RewardList!=null&&!bill_RewardList.isEmpty()){
					bill_RewardList.forEach(f->{
						f.put("reckonItemId", reckonItemId);
					});
					
					item.put("list",bill_RewardList);
					
					flag=sqlSession.insert("billDao.batchInsertBillReward", item)>0;
					if(!flag) {
						throw new Exception("添加打赏分成记录表失败！");
					}
					
				}
			}
			
			 // 4.同步年月对应的缓存数据到billrule
			
			flag=billRuleService.saveBillRuleToDb(year, month);
			if(!flag) {
				throw new Exception("保持用户分润配置失败！");
			}
			
			 // 5.清除年、月对应的分成配置缓存
			billRuleService.clearCache(year, month);
			
			result.put("result",true);
			result.put("msg", "计算成功！");
			result.put("id", reckonId);
			
		} catch (Exception e) {
			result.put("result",false);
			result.put("msg", "计算失败:"+e.getMessage());
			try {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			} catch (Exception e2) {
			}
		}
		
		return result;
	}
	
	
	/**
	 * 根据分账记录Id获取对应的专家分成列表
	 * @param id 分账记录Id
	 * @param start
	 * @param pageSize
	 * @return
	 */
	public List<Map<String,Object>> getReckonItemListById(int id,String userName,int start,int pageSize){
		
		List<Map<String, Object>> result=new ArrayList<Map<String, Object>>();
		
		try {
			
			if(id<=0) {
				return result;
			}

			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			
			if(!StringHelper.IsNullOrEmpty(userName)){
				paramMap.put("userName", userName);
			}
			
			if(start>=0&&pageSize>0) {
				paramMap.put("start", start);
				paramMap.put("pageSize", pageSize);
			}
			
			result=sqlSession.selectList("billDao.selectBillReckonItemListById", paramMap);
			
		} catch (Exception e) {

		}
		return result;
	}
	
	/**
	 * 根据分账记录Id获取对应的专家分成列表数量
	 * @param id 分账记录Id
	 * @return
	 */
	public long getReckonItemCountById(int id,String userName){
		long count=0;
		try {
			if(id<=0) {
				return count;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			if(!StringHelper.IsNullOrEmpty(userName)){
				paramMap.put("userName", userName);
			}
			
			count=sqlSession.selectOne("billDao.selectBillReckonItemCountById", paramMap);
			
		} catch (Exception e) {
		}
		return count;
	}
	
	/**
	 * 获取专家对应点分帐详情
	 * @param id 分账子项Id
	 * @return
	 */
	public Map<String, Object> getReckonItemDetailById(int id){
		Map<String, Object> result=new HashMap<String,Object>();
		
		try {
			
			result=sqlSession.selectOne("billDao.selectBillReckonItemDetailById",id);
			
		} catch (Exception e) {
		}
		
		return result;
	}
	
	/**
	 * 获取专家分成对应的课程销售、问答、打赏记录
	 * @param sourceType 1--课程 2--问答 3--打赏
	 * @param id reckonItemId
	 * @param startDate 支付开始时间
	 * @param endDate 支付结束时间
	 * @param productName 课程名称
	 * @param userName 买家账号
	 * @param status 分成状态：0--无效 1--有效  为空则是全部
	 * @param start 
	 * @param pageSize
	 * @return
	 */
	public List<Map<String, Object>>getSourceListForReckonItem(int sourceType,int id,String startDate,String endDate,String key,String userName,Integer status,int start,int pageSize){

		List<Map<String, Object>> result=new ArrayList<Map<String, Object>>();
		
		try {
			
			if(id<=0) {
				return result;
			}
			
			String sqlName="";
			switch (sourceType) {
				case 1:
					sqlName="billDao.selectOrderItemListForReckonItem";
					break;
				case 2:
					sqlName="billDao.selectQuestionListForReckonItem";
					break;
				case 3:
					sqlName="billDao.selectRewardListForReckonItem";
					break;
			}
			if(StringHelper.IsNullOrEmpty(sqlName)) {
				return result;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			
			if(!StringHelper.IsNullOrEmpty(startDate)) {
				paramMap.put("startDate",startDate);
			}
			if(!StringHelper.IsNullOrEmpty(endDate)) {
				paramMap.put("endDate",endDate);
			}
			if(!StringHelper.IsNullOrEmpty(key)) {
				paramMap.put("key",key);
			}
			if(!StringHelper.IsNullOrEmpty(userName)) {
				paramMap.put("userName",userName);
			}
			if(status!=null) {
				paramMap.put("status",status);
			}
			
			if(start>=0&&pageSize>0) {
				paramMap.put("start", start);
				paramMap.put("pageSize", pageSize);
			}
			
			result=sqlSession.selectList(sqlName, paramMap);
			
		} catch (Exception e) {

		}
		return result;
	}
	
	/**
	 * 获取专家分成对应的课程销售、问答、打赏数量
	 * @param sourceType 1--课程 2--问答 3--打赏
	 * @param id reckonItemId
	 * @param startDate 支付开始时间
	 * @param endDate 支付结束时间
	 * @param key 课程名称、问答内容、打赏内容
	 * @param userName 买家账号
	 * @param status 分成状态：0--无效 1--有效  为空则是全部
	 * @return
	 */
	public long getSourceCountForReckonItem(int sourceType,int id,String startDate,String endDate,String key,String userName,Integer status){

		long count=0;
		
		try {
			
			if(id<=0) {
				return count;
			}
			
			String sqlName="";
			switch (sourceType) {
				case 1:
					sqlName="billDao.selectOrderItemCountForReckonItem";
					break;
				case 2:
					sqlName="billDao.selectQuestionCountForReckonItem";
					break;
				case 3:
					sqlName="billDao.selectRewardCountForReckonItem";
					break;
			}
			if(StringHelper.IsNullOrEmpty(sqlName)) {
				return count;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			
			if(!StringHelper.IsNullOrEmpty(startDate)) {
				paramMap.put("startDate",startDate);
			}
			if(!StringHelper.IsNullOrEmpty(endDate)) {
				paramMap.put("endDate",endDate);
			}
			if(!StringHelper.IsNullOrEmpty(key)) {
				paramMap.put("key",key);
			}
			if(!StringHelper.IsNullOrEmpty(userName)) {
				paramMap.put("userName",userName);
			}
			if(status!=null) {
				paramMap.put("status",status);
			}
			
			count=sqlSession.selectOne(sqlName, paramMap);
			
		} catch (Exception e) {

		}
		return count;
	}

	//通过id查找用户信息
	public Map<String,Object> selUserinfoById(Map<String, Object> map) {
		return sqlSession.selectOne("billDao.selUserByID",map);
	}
	
	//获取指定专家的分成结果
	public Map<String, Object> selBillreckonitem(Map<String, Object> map , HttpServletRequest request) throws Exception{
		
		//定义两位小数的double
		double cutMoney = DataConvert.ToDouble(map.get("cutMoney"));
		double shouldMoney1 = 0d;
		double shouldMoney = 0d;
		
		String month = DataConvert.ToString(map.get("month"));
		String year = DataConvert.ToString(map.get("year"));
		
		month=StringHelper.PadLeft(month, 2, '0');
		
		java.text.DecimalFormat   df  =new  java.text.DecimalFormat("#.00");
		
		Map<String, Object> result = new HashMap<>();
		result.put("success", false);
		result.put("msg", "修改失败");
		HttpSession session = request.getSession();
		Map<String, Object> data = (Map<String, Object>) session.getAttribute("billreckonitemData");
		
		if(data!=null) {
			String should1 = DataConvert.ToString(data.get("shouldMoney1"));
			String should = DataConvert.ToString(data.get("shouldMoney"));
			if(should1!=null) {
				shouldMoney1 = DataConvert.ToDouble(should1);
			}
			if(should!=null) {
				shouldMoney = DataConvert.ToDouble(should);
			}
		}
		
		map.put("month", month+"");
		
		if(data==null) {
			//拿取专家数据
			data = sqlSession.selectOne("billDao.selBillreckonitemByID",map);
			
			data.put("shouldMoney1", DataConvert.ToDouble(data.get("shouldMoney")));
			shouldMoney1 = DataConvert.ToDouble(data.get("shouldMoney1"));
			shouldMoney = DataConvert.ToDouble(data.get("shouldMoney"));
			
			if(data.equals("null")) {
				return result;
			}
			
			session.setAttribute("billreckonitemData", data);
			
		}
		
		CalcRuleSetting calcRuleSetting=billRuleService.getBillRule(year, month).getRuleSetting();
		if(calcRuleSetting==null) {
			throw new Exception("获取分润配置失败！");
		}
		
		//扣款
		data.put("cutMoney", df.format(cutMoney<=0?0.00:cutMoney).toString());
		
		//应发金额 
		data.put("shouldMoney", df.format((shouldMoney1-cutMoney)<=0?0.00:(shouldMoney1-cutMoney)).toString());
		
		//个人所得税
		double personalTax=billCalcService.getBillCalcTypeValue(BILL_CALC_TYPE.PERSIONAL_TAX, calcRuleSetting,data);
		data.put("personalTax", df.format(personalTax).toString());
		
		//实发金额
		data.put("actualMoney", df.format(DataConvert.ToDouble(data.get("shouldMoney"))-DataConvert.ToDouble(data.get("personalTax"))).toString());
		
		result.put("success", true);
		result.put("msg", "修改成功");
		
		result.put("data", data);
		 
		return result;
	}
	
	//更新专家信息
	public Map<String,Object> updateBillReckonItem(Map<String,Object> map){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", false);
		result.put("msg", "更新失败");
		double num = sqlSession.update("billDao.updateBillReckonItem",map);
		if(num>0) {
			result.put("success", true);
			result.put("msg", "更新成功");
		}
		return result;
	}
	
	//查询有无记录
	public Map<String,Object> selBillReckonItemByIdASID(Map<String,Object> map){
		map = sqlSession.selectOne("",map);
		return map;
	}
	
}
