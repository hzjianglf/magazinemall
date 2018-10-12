package cn.Pay.provider.onlinepays.wechatpay;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpSession;

import com.github.binarywang.wxpay.bean.request.WxPayUnifiedOrderRequest;
import com.github.binarywang.wxpay.config.WxPayConfig;
import com.github.binarywang.wxpay.service.WxPayService;
import com.github.binarywang.wxpay.service.impl.WxPayServiceImpl;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import cn.Pay.provider.IOnlinePayProvider;
import cn.Pay.provider.OnlinePayNotifyResult;
import cn.Pay.provider.Pay;
import cn.Pay.provider.PayParamEntity;
import cn.Pay.provider.PayResult;
import cn.Pay.provider.ServiceHelper;
import cn.Pay.provider.paycallback.IPayCallBack;
import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.util.DataConvert;
import cn.util.StringHelper;

@Pay(name="微信公众号支付")
@Service
public class WechatJsApiPay implements IOnlinePayProvider {

	@Autowired
	Setting setting;
	@Autowired
	HttpSession session;
	@Autowired
	WechatProvider wechatProvider;

	WxPayService payService;

	public WechatJsApiPay(){
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
			
			String openId=DataConvert.ToString(session.getAttribute("openId"));
			if(StringHelper.IsNullOrEmpty(openId)){
				
				payResult.setError("没有找到OPENID!");
				return payResult;
			}
			
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
				throw new Exception("密钥（APPID|KEY|IP）配置错误！");
			}
			
			//WXPayConfigImpl config=new WXPayConfigImpl(appId, mch_id, key);
			
			//WXPay wxPay=new WXPay(config,SignType.MD5);
			
			double totalMoney=param.getPayMoney();
			if(totalMoney<=0){
				throw new Exception("支付金额错误！");
			}
			
			double rate=DataConvert.ToDouble(param.getPayMethodInfo().get("rate"));
			
			if(rate>0){
				totalMoney+=totalMoney*rate/100;
			}
			int payMoney= new BigDecimal(totalMoney).setScale(2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100)).intValue(); 
			
			
			// HashMap<String, String> data = new HashMap<String, String>();
	        // data.put("body", param.getBody());
	        // data.put("out_trade_no",param.getOrderNo());
	        // data.put("fee_type", "CNY");
	        // data.put("total_fee", payMoney+"");
	        // data.put("spbill_create_ip", ip);
	        // data.put("notify_url", siteInfo.getSiteUrl()+"/pay/notify/wechatPay");
	        // data.put("trade_type", "JSAPI");
	        // data.put("openid",openId);
	        // data.put("product_id", param.getOrderId()+"");
	        
	        try {
	            //Map<String, String> result = wxPay.unifiedOrder(data);
	            
	            // String  prepay_id=result.get("prepay_id");
	            // if(StringHelper.IsNullOrEmpty(prepay_id)){
	            // 	throw new Exception(result.get("err_code_des"));
	            // }
	            
	            // Map<String, String> dataMap=new TreeMap<String, String>();
	            // dataMap.put("appId", appId);
	            // dataMap.put("timeStamp", System.currentTimeMillis()+"");
	            // dataMap.put("nonceStr", WXPayUtil.generateNonceStr());
	            // dataMap.put("package", "prepay_id="+prepay_id);
	            // dataMap.put("signType",WXPayConstants.MD5);
	            
	            
	            // String sign=WXPayUtil.generateSignature(dataMap, key,SignType.MD5);
	            
	            // dataMap.put("paySign", sign);
	            WxPayUnifiedOrderRequest request=WxPayUnifiedOrderRequest.newBuilder().body(param.getOrderNo())
				.feeType("CNY").outTradeNo(param.getOrderNo()).notifyUrl(siteInfo.getSiteUrl()+"/pay/notify/wechatPay")
				.totalFee(payMoney).tradeType("JSAPI").spbillCreateIp(ip).build();

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
	           
				dataMap.put("package", payInfo.get("package"));
				dataMap.put("signType",payInfo.get("signType"));
	            dataMap.put("noncestr", nonceStr);
				dataMap.put("timestamp", timeStamp);
				dataMap.put("paySign", sign);

	            JSONObject jsonObject=new JSONObject(dataMap); 
	            
	            String dataStr=String.format(""
	            		+ "function onBridgeReady(){"
		            		+"WeixinJSBridge.invoke('getBrandWCPayRequest',%s,function(res){"
		            			+ "if(res.err_msg =='get_brand_wcpay_request:ok') {"
		            				+ "window.location.href='/pay/result/wechatPay?orderNo=%s';"
		            			+ "}else{"
		            				+ "alert('支付失败'+res.err_msg);"
		            			+ "}"
		            		+ "});"
		            	+ "}"
		            		
		            	+ "if (typeof WeixinJSBridge =='undefined'){"
	            			+ "if( document.addEventListener ){"
	            				+ "document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);"
	            			+ "}else if (document.attachEvent){"
	            				+"document.attachEvent('WeixinJSBridgeReady', onBridgeReady);" 
	            				+"document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);"
	            			+ "}"
		            	+ "}else{"
		            			+ "onBridgeReady();"
		            	+ "};",jsonObject.toString(),param.getOrderNo());
	            
	            payResult.setSuccess(true);
	            payResult.setRequestData("<script>"+dataStr+"</script>");
	            
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
