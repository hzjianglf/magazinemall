package cn.Pay.service;


import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.alibaba.druid.util.StringUtils;

import cn.Pay.provider.PayExtension;
import cn.Pay.provider.PayParamEntity;
import cn.Pay.provider.PayResult;
import cn.api.service.NewsService;
import cn.api.service.OrderService;
import cn.api.service.ProductService;
import cn.api.service.NewsService.NewsType;
import cn.core.WxSessionInterceptor;
import cn.util.DataConvert;
import cn.util.JPushUtil;
import cn.util.StringHelper;


@Service
@Transactional
public class payService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession SqlSession;
	@Autowired
	HttpSession session;
	@Autowired
	ProductService productService; 
	@Autowired
	OrderService orderService;
	@Autowired
	PayExtension payExtension;
	@Autowired
	NewsService newsService;
	public Map<String, Object> selPaylog(String orderNo) {
		return SqlSession.selectOne("payDao.selPaylog", orderNo);
	}
	/**
	 * 更新支付记录状态
	 * @param paylogId
	 */
	public void updatePaylogStatus(Map<String, Object> paraMap){
		SqlSession.update("productDao.updPayLogStatus", paraMap);
	}
	/**
	 * 根据订单和订单子项是否有发货商品来更改订单以及订单子项的状态
	 * @param sourceInfoMap
	 * @return
	 */
	public boolean updOrderByProduct(Map<String, Object> sourceInfoMap) {
		boolean flag =false;
		try {
			//根据订单查询订单子项包括赠送的商品
			List<Map<String,Object>> allList = SqlSession.selectList("payDao.selOrderitemId",sourceInfoMap);
			//查找出需要发货的子项id
			List sendList = allList.stream()
					.filter(f->{return (f.get("producttype")+"").equals("2");})
					.collect(Collectors.toList());
			
			int deliverstatus=0;
			int orderstatus=2;
			if(sendList.size()==0){
				deliverstatus=1;
				orderstatus=5;
			}else{
				if(allList.size()!=sendList.size()){
					deliverstatus=2;
				}
			}
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("deliverstatus", deliverstatus);
			map.put("orderstatus", orderstatus);
			map.put("id", sourceInfoMap.get("id"));
			flag = SqlSession.update("payDao.updOrderItemStatus",map)>0;
		} catch (Exception e) {
			e.printStackTrace();
			flag=false;
		}
		return flag;
	}
	/**
	 * 根据订单id更改订单支付状态以及优惠券状态 期刊库存 课程购买数
	 * @return
	 */
	public int updateOrderStatus(Map<String, Object> map) {
		int row = 0;
		try {
			//修改订单支付状态
			row = SqlSession.update("payDao.updateOrderStatus", map);
			/*if(null!=DataConvert.ToInteger(map.get("couponId"))){
				//修改优惠券状态
				int num = SqlSession.update("payDao.updateCoupon", map);
				if(num<0){
					return -1;
				}
			}
			if(null!=DataConvert.ToInteger(map.get("updateVoucher"))){
				//修改代金券状态
				int num = SqlSession.update("payDao.updateVoucher", map);
				if(num<0){
					return -1;
				}
			}*/
			if(row<0){
				return -1;
			}
			if((map.get("ordertype")+"").equals("2") || (map.get("ordertype")+"").equals("16") || (map.get("ordertype")+"").equals("18")){
				//查询期刊购买的期次和购买数量
				List<Map<String,Object>> list = SqlSession.selectList("payDao.selTotalDesc",map);
				if(null!=list && list.size()>0){
					for (Map<String, Object> orderitem : list) {
						int buyCount =DataConvert.ToInteger(orderitem.get("count"));
						String productId = DataConvert.ToString(orderitem.get("productId"));
						if(!StringHelper.IsNullOrEmpty(productId)) {
							Map bookInfo = SqlSession.selectOne("payDao.selBookState", productId);
							if(bookInfo==null||bookInfo.isEmpty()) {
								return -1;
							}
							int stock =DataConvert.ToInteger(bookInfo.get("stock")); 
							int state =DataConvert.ToInteger(bookInfo.get("state"));
							//没有库存（先不进行判断）
							if(stock==0||buyCount>stock){
								//return -1;
							}
							//下架
							if(state==1){
								return -1;
							}
							
							Map<String,Object> paramap = new HashMap<String, Object>();
							paramap.put("count", buyCount);
							paramap.put("productId", productId);
							SqlSession.update("payDao.updBookstockById",paramap);
						}
					}
				}
			}else if("4".equals(map.get("ordertype")+"")){
				//查询购买对象id
				Map m=SqlSession.selectOne("payDao.selOrdrItem", map);
				SqlSession.update("payDao.updateOndemand", m);
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			return -1;
		}
		return 1;
	}
	
	/**
	 * 订单支付--根据payLog 进行支付
	 * @param payLogId 支付记录Id
	 * @param payMethodId  支付方式Id
	 * @return
	 */
	public synchronized Map<String,Object> orderPay(int payLogId,int payMethodId){
		
		Map<String, Object> result=new HashMap<String, Object>(){
			{
				put("success", false);
				put("msg","支付失败");
			}
		};
		
		try {
			
			Map<String, Object>paramMap=new HashMap<String,Object>();
			paramMap.put("paylogId", payLogId);
			
			//根据paylogId查询支付记录信息
			Map<String, Object> paymsg = orderService.selectPaylogMsg(paramMap);
			
			if(paymsg==null||paymsg.isEmpty()){
				throw new Exception("获取支付记录失败！");
			}
			
			//判断支付记录是否已经支付
			boolean isPay=DataConvert.ToBoolean(paymsg.get("status"));
			if(isPay){
				result.put("success", true);
				result.put("msg","支付成功！");
				result.put("payResult",new PayResult(){
					{
						setSuccess(true);
						setOnline(false);
					}
				});
				
				return result;
			}
			
			//根据payMethodId 获取 payMethodInfo
			Map<String,Object> paymethod = SqlSession.selectOne("payDao.selectpayMeth", payMethodId);
			if(!"1".equals(paymethod.get("isfreeze")+"")){
				throw new Exception("支付方式不可用!");
			}
			
			//更新 paylog 的 payMethodId 、name
			paymethod.put("paylogId", payLogId);
			paymethod.put("payMethodId", payMethodId);
			int row = SqlSession.update("payDao.updatePaytype", paymethod);
			if(row<=0){
				throw new Exception("更新paylog失败！");
			}
			paramMap.put("orderNo", paymsg.get("orderNo")+"");
			PayParamEntity payParam = new PayParamEntity();
			payParam.setOrderId(payLogId);
			payParam.setOrderNo(paymsg.get("orderNo")+"");
			payParam.setPayMoney(DataConvert.ToDouble(paymsg.get("price")+""));
			payParam.setPayMoney(DataConvert.ToDouble(paymsg.get("price")));
			payParam.setPayMehtodId(payMethodId);
			payParam.setPayMethodInfo(paymethod);
			System.out.println(payParam);
			//支付逻辑方法
			PayResult payResult=payExtension.Pay(payParam);
			result.put("payResult", payResult);
			//支付成功
			if(payResult.isSuccess()){
				if(payResult.isOnline()) {
					result.put("success",true);
					result.put("msg", "请确认支付");
				}else {//线下支付
					Map<String, Object> handelResult = handelPaySuccess(paymsg);
					if(DataConvert.ToBoolean(handelResult.get("result"))){
						result.put("success", true);
						result.put("msg", "支付成功！");
					}else{
						throw new Exception("");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "支付失败！"+e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		
		return result;
	}
	


	/**
	 * 支付成功逻辑处理--根据支付记录分类型进行订单处理
	 * @param payLog
	 * @return result--true/false, model--支付的订单信息
	 * @throws Exception 
	 */
	public  Map<String, Object> handelPaySuccess(Map<String,Object> payLog) throws Exception {
		Map<String, Object> result=new HashMap<String, Object>(){
			{
				put("result", false);
			}
		};
		
		try {
			//相应记录
			Map<String, Object> sourceInfoMap=new HashMap<String, Object>();
			
			int source=DataConvert.ToInteger(payLog.get("source"));
			int sourceId=DataConvert.ToInteger(payLog.get("sourceId"));
			String orderNo=DataConvert.ToString(payLog.get("orderNo"));
			
			boolean flag=false;
			
			//根据 source 来分别处理 1--订单支付，2--充值，3--提问，4--旁听，5--打赏
			 switch (source) {
			 	case 1://订单支付
			 		//获取订单信息
			 		sourceInfoMap = SqlSession.selectOne("payDao.selectOrderMsg", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的订单信息");
			 		}
			 		
			 		int orderPayStatus=DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		
			 		if(orderPayStatus!=1){
			 			int paylogId = DataConvert.ToInteger(payLog.get("id"));
			 			//查询支付方式
			 			String payMethodId = SqlSession.selectOne("payDao.selectPaymethodId", paylogId);
			 			sourceInfoMap.put("payMethodId", payMethodId);
			 			sourceInfoMap.put("paystatus", 1);
			 			flag =updateOrderStatus(sourceInfoMap)>0;
			 			if(!flag) {
			 				throw new Exception();
			 			}
			 			//根据订单和订单子项是否有发货商品来更改订单以及订单子项的状态
			 			flag = updOrderByProduct(sourceInfoMap);
			 			if(!flag) {
			 				throw new Exception();
			 			}
			 		}
			 		break;
			 	case 2://充值
			 		sourceInfoMap = SqlSession.selectOne("accountLogDao.selectUseraccountlogMsg", sourceId);
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的充值信息");
			 		}
			 		int paystatus=DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		if(paystatus!=1){
			 			flag = SqlSession.update("accountLogDao.updPaystatus",sourceId)>0;
			 			if(!flag){
			 				throw new Exception();
			 			}
			 			flag = SqlSession.update("accountLogDao.updAddMoney",sourceInfoMap)>0;
			 			if(!flag){
			 				throw new Exception();
			 			}
			 		}
					break;
			 	case 3://提问
					
			 		sourceInfoMap = SqlSession.selectOne("payDao.selQuesTionInfo", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的提问信息");
			 		}
			 		
			 		// 支付状态判断
			 		int quesPayStatus=DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		//增加提问消息
			 		newsService.addUserNews(DataConvert.ToInteger(sourceInfoMap.get("questioner")), DataConvert.ToInteger(sourceInfoMap.get("lecturer")), DataConvert.ToInteger(sourceInfoMap.get("id")), NewsType.question, DataConvert.ToDouble(sourceInfoMap.get("money")));
			 		if(quesPayStatus!=1){
			 			int row = SqlSession.update("payDao.updQuestionStatus", sourceId);
			 			
			 			if(row>0){
			 				flag = true;
			 				
			 			}else{
			 				throw new Exception();
			 			}
			 		}
					break;
			 	case 4://旁听
					
			 		sourceInfoMap = SqlSession.selectOne("payDao.selAuditInfo", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的订单信息");
			 		}
			 		
			 		// 支付状态判断
			 		int auditPayStatus = DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		
			 		if(auditPayStatus!=1){
			 			int rw = SqlSession.update("payDao.updAuditStatus", sourceId);
			 			if(rw>0){
			 				flag = true;
			 			}else{
			 				throw new Exception();
			 			}
			 		}
					break;
			 	case 5://打赏
			 		//获取打赏信息
			 		sourceInfoMap = SqlSession.selectOne("payDao.selectRewardMsg", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			System.out.println("没有要支付的打赏记录信息");
			 			throw new Exception("没有要支付的打赏记录信息");
			 		}
			 		
			 		int rewardStatus=DataConvert.ToInteger(sourceInfoMap.get("state"));
			 		
			 		if(rewardStatus!=1){
			 			sourceInfoMap.put("paystatus", 1);
			 			flag =SqlSession.update("payDao.updateRewardStatus", sourceInfoMap)>0;
			 			SqlSession.update("payDao.updRewardNum",sourceInfoMap);//修改专家记录表里面的打赏人数
			 			// 添加打赏消息
			 			newsService.addUserNews(DataConvert.ToInteger(sourceInfoMap.get("rewardPeople")), DataConvert.ToInteger(sourceInfoMap.get("beRewarding")), DataConvert.ToInteger(sourceInfoMap.get("beRewarding")), NewsType.reward, DataConvert.ToDouble(sourceInfoMap.get("money")));
			 			if(!flag) {
			 				throw new Exception();
			 			}
			 		}
					break;
			 }
			 result.put("result", true);
			 result.put("model", sourceInfoMap);
			 
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			throw e;
		}
		return result;
	}


	/**
	 * 获取支付状态
	 */
	public  Map<String, Object> getPayState(String orderNo){
		Map<String, Object> result=new HashMap<String, Object>(){
			{
				put("result", false);
			}
		};
		try {
			
			Map<String,Object> payLogMap =selPaylog(orderNo);
			if(payLogMap==null||payLogMap.isEmpty()) {
				throw new Exception("没有对应的支付记录信息！");
			}
			boolean payStatus=DataConvert.ToBoolean(payLogMap.get("status"));
			if(!payStatus) {
				throw new Exception("");
			}
			
			Map<String, Object> sourceInfoMap=new HashMap<String, Object>();
			
			int source=DataConvert.ToInteger(payLogMap.get("source"));
			int sourceId=DataConvert.ToInteger(payLogMap.get("sourceId"));
			
			boolean flag=false;
			
			//根据 source 来查看
			 switch (source) {
			 	case 1://订单支付
			 		//获取订单信息
			 		sourceInfoMap = SqlSession.selectOne("payDao.selectOrderMsg", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的订单信息");
			 		}
			 		
			 		int orderPayStatus=DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		
			 		if(orderPayStatus==1){
			 			flag=true;
			 		}
			 		break;
			 	case 2://充值
			 		sourceInfoMap = SqlSession.selectOne("accountLogDao.selectUseraccountlogMsg", sourceId);
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的充值信息");
			 		}
			 		int paystatus=DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		if(paystatus==1){
			 			flag=true;
			 		}
					break;
			 	case 3://提问
					
			 		sourceInfoMap = SqlSession.selectOne("payDao.selQuesTionInfo", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的提问信息");
			 		}
			 		
			 		int quesPayStatus=DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		
			 		if(quesPayStatus==1){
			 			flag=true;
			 		}
					break;
			 	case 4://旁听
					
			 		sourceInfoMap = SqlSession.selectOne("payDao.selAuditInfo", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的订单信息");
			 		}
			 		
			 		// 支付状态判断
			 		int auditPayStatus = DataConvert.ToInteger(sourceInfoMap.get("paystatus"));
			 		if(auditPayStatus==1){
			 			flag=true;
			 		}
			 		
					break;
			 	case 5://打赏
			 		//获取打赏信息
			 		sourceInfoMap = SqlSession.selectOne("payDao.selectRewardMsg", sourceId);
			 		
			 		if(sourceInfoMap==null||sourceInfoMap.isEmpty()){
			 			throw new Exception("没有要支付的打赏记录信息");
			 		}
			 		
			 		int rewardStatus=DataConvert.ToInteger(sourceInfoMap.get("state"));
			 		
			 		if(rewardStatus==1){
			 			flag=true;
			 		}
					break;
			 }
			 result.put("result", flag);
			 result.put("model", sourceInfoMap);
		} catch (Exception e) {
			result.put("result", false);
			result.put("msg", e.getMessage());
		}
		
		return result;
	}
		
	
}
