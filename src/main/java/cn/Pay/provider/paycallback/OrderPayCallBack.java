package cn.Pay.provider.paycallback;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.Pay.provider.PayParamEntity;
import cn.Pay.provider.PayResult;
import cn.core.WxSessionInterceptor;
import cn.util.CalendarUntil;
import cn.util.DataConvert;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


@Service
public class OrderPayCallBack implements IPayCallBack  {

	@Autowired
	SqlSession sqlSession;

	private static final Logger log = LoggerFactory
			.getLogger(WxSessionInterceptor.class);
	@Override
	public synchronized void OrderPay(PayParamEntity param, PayResult payResult) {
		try {
			log.info("支付成功回调");
			int orderId = param.getOrderId();// 订单id
			log.info("订单id"+orderId);			
			// 查询账户余额和用户id
			Map userInfo = sqlSession.selectOne("productDao.selUserBalance",orderId);
			// 需要支付价格
			double price = param.getPayMoney()/1000;
			//判断
			boolean flag=false;
			int source = DataConvert.ToInteger(userInfo.get("source"));
			int type = 0;
			if(source==1){
				type = 3;
			}else if(source==2){
				type = 1;
			}else if(source==3){
				type = 2;
			}else if(source==4){
				type = 4;
			}else if(source==5){
				type = 5;
			}
			Map debit = new HashMap();
			debit.put("userId", userInfo.get("userId"));// 用户id
			debit.put("price", price);
			debit.put("type", type);
			debit.put("orderNum", param.getOrderNo());

			Calendar cal = Calendar.getInstance();
			int month = cal.get(Calendar.MONTH) + 1;// 当前月份
			debit.put("month", month);
			// 添加用户消费记录表
			if(type==1) {
				debit.put("balance", Double.valueOf(userInfo.get("balance")+"")+price);
			}else {
				debit.put("balance", Double.valueOf(userInfo.get("balance")+""));
			}
			flag=sqlSession.insert("productDao.addUseraccountlog", debit)>0;

			if(!flag){
				throw new Exception();
			}
			System.out.println("支付回调:"+payResult.toString()+",Time:"+CalendarUntil.ToDateString());
			
		} catch (Exception e) {
			e.printStackTrace();
			log.info("错误信息"+e.getMessage());
		}
	}

	@Override
	public synchronized void OrderRefund(PayParamEntity paramEntity, PayResult payResult) {
		try {
			// TODO 退款完成，后续操作
				
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
