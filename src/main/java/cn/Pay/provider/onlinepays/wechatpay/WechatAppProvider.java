package cn.Pay.provider.onlinepays.wechatpay;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.binarywang.wxpay.bean.order.WxPayAppOrderResult;
import com.github.binarywang.wxpay.bean.request.WxPayUnifiedOrderRequest;
import com.github.binarywang.wxpay.bean.result.WxPayUnifiedOrderResult;
import com.github.binarywang.wxpay.config.WxPayConfig;
import com.github.binarywang.wxpay.service.WxPayService;
import com.github.binarywang.wxpay.service.impl.WxPayServiceImpl;
import com.github.binarywang.wxpay.util.SignUtils;


import cn.Pay.provider.IOnlinePayProvider;
import cn.Pay.provider.OnlinePayNotifyResult;
import cn.Pay.provider.Pay;
import cn.Pay.provider.PayParamEntity;
import cn.Pay.provider.PayResult;
import cn.Pay.provider.paycallback.IPayCallBack;
import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.core.WxSessionInterceptor;
import cn.util.DataConvert;
import cn.util.StringHelper;

@Pay(name="微信App支付")
@Service
public class WechatAppProvider  implements IOnlinePayProvider  {

	@Autowired
	Setting setting;
	WxPayService payService;

	public WechatAppProvider(){
		payService=new WxPayServiceImpl();
	}

	@Override
	public PayResult Pay(PayParamEntity param) {
		PayResult payResult=new PayResult(){
			{
				setOnline(true);
			}
		};
		
		try {
			
			SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
			
			//商户号
			String mch_id=DataConvert.ToString(param.getPayMethodInfo().get("accountId"));
			if(StringHelper.IsNullOrEmpty(mch_id)){
				throw new Exception("账户（商户号）配置错误！");
			}
			String key="";
			String appId="";
			String ip="";
			try{
				String encryptionKey=DataConvert.ToString(param.getPayMethodInfo().get("encryptionKey"));
				String[] arr=encryptionKey.split("\\|");
				
				appId=arr[0];
				key=arr[1];
				ip=arr[2];
				
			}catch(Exception e){
				e.printStackTrace();
				throw new Exception("密钥（APPID|KEY|IP）配置错误！");
			}
			
			 double totalMoney=param.getPayMoney();
			
			double rate=DataConvert.ToDouble(param.getPayMethodInfo().get("rate"));
			
			if(rate>0){
				totalMoney+=totalMoney*rate/100;
			}
			int payMoney= new BigDecimal(totalMoney).setScale(2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100)).intValue(); 
			HashMap<String, String> data = new HashMap<String, String>();
	        data.put("body", param.getOrderNo());
	        data.put("out_trade_no",param.getOrderNo());
	        data.put("fee_type", "CNY");
	        data.put("total_fee", payMoney+"");
	        data.put("spbill_create_ip", ip);
	        data.put("notify_url", siteInfo.getSiteUrl()+"/pay/notify/wechatPay");
	        data.put("trade_type", "APP");
	        try {

				WxPayUnifiedOrderRequest request=WxPayUnifiedOrderRequest.newBuilder().body(param.getOrderNo())
				.feeType("CNY").outTradeNo(param.getOrderNo()).notifyUrl(siteInfo.getSiteUrl()+"/pay/notify/wechatPay")
				.totalFee(payMoney).tradeType("APP").spbillCreateIp(ip).build();

				WxPayConfig payConfig = new WxPayConfig();
				payConfig.setAppId(appId);
				payConfig.setMchId(mch_id);
				payConfig.setMchKey(key);
			
				payService.setConfig(payConfig);
		
				Map<String, String> payInfo = payService.getPayInfo(request);
				String timeStamp = payInfo.get("timeStamp");
				String sign = payInfo.get("sign");
				String aPackage = payInfo.get("package");
				String nonceStr = payInfo.get("nonceStr");
				String prepayId=payInfo.get("prepayId");
				Map<String, String> dataMap=new TreeMap<String, String>();
	            dataMap.put("appid", appId);
	            dataMap.put("partnerid", mch_id);
	            dataMap.put("prepayid", prepayId);
				dataMap.put("package", aPackage);
	            dataMap.put("noncestr", nonceStr);
	            dataMap.put("timestamp", timeStamp);
	            dataMap.put("sign", sign);
	            
	            JSONObject jsonObject=new JSONObject(dataMap); 
	            
	            payResult.setSuccess(true);
	            payResult.setRequestData(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	            payResult.setError(e.getLocalizedMessage());
	        }
			
		} catch (Exception e) {
			e.printStackTrace();
			payResult.setError(e.getMessage());
		}
		finally{
			IPayCallBack callBack=param.getCallBack();
			if(callBack!=null){
				callBack.OrderPay(param, payResult);
			}
		}
		return payResult;
	}

	@Override
	public OnlinePayNotifyResult VerifyResult(PayParamEntity entity,Map<String, String> param) {
		String key="";
			String appId="";
			String ip="";
			String mch_id="";
		try{
			Map<String,Object> method=entity.getPayMethodInfo();
			mch_id=DataConvert.ToString(method.get("accountId"));
			String encryptionKey=DataConvert.ToString(method.get("encryptionKey"));
			String[] arr=encryptionKey.split("\\|");
			
			appId=arr[0];
			key=arr[1];
			ip=arr[2];
			
		}catch(Exception e){
			e.printStackTrace();
			OnlinePayNotifyResult result=new OnlinePayNotifyResult();
			result.setError("密钥（APPID|KEY|IP）配置错误！");
			result.setSuccess(false);
			result.setMessage("<xml><return_code><![CDATA[FAIL]]></return_code><return_msg><![CDATA[密钥（APPID|KEY|IP）配置错误！]]></return_msg></xml>");
			return result;
		}
		WxPayConfig payConfig = new WxPayConfig();
		payConfig.setAppId(appId);
		payConfig.setMchId(mch_id);
		payConfig.setMchKey(key);
		payService.setConfig(payConfig);
		return WechatCore.verifyPayResult(payService,entity, param);
	}

	@Override
	public OnlinePayNotifyResult VerifyRefundResult(PayParamEntity entity,
			Map<String, String> param) {
		// TODO Auto-generated method stub
		return null;
	}

}
