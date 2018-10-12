package cn.Pay.provider.onlinepays.wechatpay;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import com.github.binarywang.wxpay.bean.request.WxPayUnifiedOrderRequest;
import com.github.binarywang.wxpay.config.WxPayConfig;
import com.github.binarywang.wxpay.service.WxPayService;
import com.github.binarywang.wxpay.service.impl.WxPayServiceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



import cn.Pay.provider.IOnlinePayProvider;
import cn.Pay.provider.OnlinePayNotifyResult;
import cn.Pay.provider.PayParamEntity;
import cn.Pay.provider.PayResult;
import cn.Pay.provider.Pay;
import cn.Pay.provider.paycallback.IPayCallBack;
import cn.Pay.service.payService;
import cn.Pay.setting.WxPaySetting;
import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.util.DataConvert;
import cn.util.StringHelper;



@Pay(name="微信扫码支付")
@Service
public class WechatProvider implements IOnlinePayProvider {
	/*@Autowired
	Setting setting;*/
	@Autowired
	WxPaySetting setting;
	WxPayService payService;

	public WechatProvider(){
		payService=new WxPayServiceImpl();
	}

	/*@Override
	public PayResult Pay(PayParamEntity param) {
		System.out.println("进入Pay 方法");
		PayResult payResult=new PayResult(){
			{
				setOnline(true);
			}
		};
		
		try {
			
			SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
			System.out.println("siteInfo :"+siteInfo);
			//商户号
			String mch_id=DataConvert.ToString(param.getPayMethodInfo().get("accountId"));
			System.out.println("mch_id :"+mch_id);
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
				System.out.println("key :"+key);
				System.out.println("appId :"+appId);
				System.out.println("ip :"+ip);
			}catch(Exception e){
				throw new Exception("密钥（APPID|KEY|IP）配置错误！");
			}
			
			//WXPayConfigImpl config=new WXPayConfigImpl(appId, mch_id, key);
			
			//WXPay wxPay=new WXPay(config,SignType.MD5);
			
			double totalMoney=param.getPayMoney();
			System.out.println("totalMoney :"+totalMoney);
			if(totalMoney<=0){
				throw new Exception("支付金额错误！");
			}
			
			double rate=DataConvert.ToDouble(param.getPayMethodInfo().get("rate"));
			
			if(rate>0){
				totalMoney+=totalMoney*rate/100;
			}
			int payMoney= new BigDecimal(totalMoney).setScale(2, BigDecimal.ROUND_HALF_UP).multiply(new BigDecimal(100)).intValue(); 
			
			WxPayUnifiedOrderRequest request=WxPayUnifiedOrderRequest.newBuilder().body(param.getOrderNo())
				.feeType("CNY").outTradeNo(param.getOrderNo()).notifyUrl(siteInfo.getSiteUrl()+"/pay/notify/wechatPay")
				.totalFee(payMoney).tradeType("NATIVE").spbillCreateIp(ip).build();

				WxPayConfig payConfig = new WxPayConfig();
				payConfig.setAppId(appId);
				payConfig.setMchId(mch_id);
				payConfig.setMchKey(key);
			
				payService.setConfig(payConfig);
		
				Map<String, String> payInfo = payService.getPayInfo(request);

			// HashMap<String, String> data = new HashMap<String, String>();
	        // data.put("body", param.getBody());
	        // data.put("out_trade_no",param.getOrderNo());
	        // data.put("fee_type", "CNY");
	        // data.put("total_fee", payMoney+"");
	        // data.put("spbill_create_ip", ip);
	        // data.put("notify_url", siteInfo.getSiteUrl()+"/pay/notify/wechatPay");
	        // data.put("trade_type", "NATIVE");
	        // data.put("product_id", param.getOrderId()+"");
	        
	        try {
	           
	            //二维码地址
	            String code_url=payInfo.get("codeUrl");
	            System.out.println("code_url :"+code_url);
	            if(StringHelper.IsNullOrEmpty(code_url)){
	            	throw new Exception(payInfo.get("err_code_des"));
	            }
	            
	            String  dataStr="<div id='wxpayqrcode' data-code='"+code_url+"'></div>"
	            		+"<script type='text/javascript' src='/manage/public/js/jquery.qrcode.min.js'></script>"
	            		+"<script type='text/javascript'>"
	            			+"$('#wxpayqrcode').qrcode($('#wxpayqrcode').data('code')); "
	            			+"setInterval(getOrderState,1000);"
	            			+"function getOrderState(){"
	            				+"$.get('/pay/payState',{"
	            					+ "orderNo:'" +param.getOrderNo() + "',"
	            					+ "r:Math.random()"
	            					+ "},function(json){"
	            						+ "if(json.result){"
	            							+ "window.location.href='/pay/result/wechatPay?orderNo=" + param.getOrderNo()+"';"
	            							+"}"
	            				+"},'json');"
	            			+"}"
	            		+"</script>";
	            System.out.println("dataStr :"+dataStr);
	            payResult.setSuccess(true);
	            payResult.setRequestData(dataStr);
	            System.out.println("结束Pay方法");
	            
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
	}*/
	
	
	@Override
	public PayResult Pay(PayParamEntity param) {
		System.out.println(setting.getEncryptionKey().split("\\|")[3]);
		PayResult payResult = new PayResult() {
			{
				setOnline(true);
			}
		};

		if (setting == null) {
			payResult.setError("支付配置不能为空");
			return payResult;
		}
		

		try {

			// 商户号
			String mch_id = DataConvert.ToString(setting.getAccountId());
			if (StringHelper.IsNullOrEmpty(mch_id)) {
				throw new Exception("账户（商户号）配置错误！");
			}
			String key = "";
			String appId = "";
			String ip = "";
			try {
				String encryptionKey = DataConvert.ToString(setting.getEncryptionKey());
				String[] arr = encryptionKey.split("\\|");

				appId = arr[0];
				key = arr[1];
				ip = arr[2];
				if (ip == null) {
					payResult.setError("host不能为空");
					return payResult;
				}
			} catch (Exception e) {
				throw new Exception("密钥（APPID|KEY|IP）配置错误！");
			}

			// WXPayConfigImpl config=new WXPayConfigImpl(appId, mch_id, key);

			// WXPay wxPay=new WXPay(config,SignType.MD5);

			double totalMoney = param.getPayMoney();
			if (totalMoney <= 0) {
				throw new Exception("支付金额错误！");
			}

			int payMoney = new BigDecimal(totalMoney).setScale(2, BigDecimal.ROUND_HALF_UP)
					.multiply(new BigDecimal(100)).intValue();
			WxPayUnifiedOrderRequest request = WxPayUnifiedOrderRequest.newBuilder().body(param.getBody())
					.feeType("CNY").outTradeNo(param.getOrderNo()).notifyUrl(setting.getEncryptionKey().split("\\|")[3] + "/pay/notify/wechatPay")
					.totalFee(payMoney).tradeType("NATIVE").spbillCreateIp(ip).productId(param.getOrderNo()).build();

			WxPayConfig payConfig = new WxPayConfig();
			payConfig.setAppId(appId);
			payConfig.setMchId(mch_id);
			payConfig.setMchKey(key);

			payService.setConfig(payConfig);

			Map<String, String> payInfo = payService.getPayInfo(request);

			try {

				// 二维码地址
				String code_url = payInfo.get("codeUrl");

				payResult.setSuccess(true);
				payResult.setRequestData(code_url);
			} catch (Exception e) {
				e.printStackTrace();
				payResult.setError(e.getLocalizedMessage());
			}

		} catch (Exception e) {
			e.printStackTrace();
			payResult.setError(e.getMessage());
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
	public OnlinePayNotifyResult VerifyRefundResult(PayParamEntity entity,Map<String, String> inputParam) {
		// TODO Auto-generated method stub
		return null;
	}

}
