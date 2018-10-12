package cn.phone.wechat.controller;

import java.io.PrintWriter;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.Setting.Model.WechatSetting;
import cn.core.WxSessionInterceptor;
import cn.phone.wechat.service.wechatService;
import cn.util.DataConvert;
import cn.util.StringHelper;
import cn.util.wechat.WxMessage;
import cn.util.wechat.wechatHelper;


@Controller
@RequestMapping("/wechat")
public class wechatController {
	private static final org.slf4j.Logger log = LoggerFactory
			.getLogger(WxSessionInterceptor.class);
	@Autowired
	wechatService wechatService;
	@Autowired
	Setting setting;
	
	/**
	 * 微信token验证及事件推送
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/eventHandle", method = { RequestMethod.GET,RequestMethod.POST })
	public void EventHandle(HttpServletRequest request,HttpServletResponse response) {
		String result="";
		try {
			
			WechatSetting wechatSetting=setting.getSetting(WechatSetting.class);
			SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
			
			String token=wechatSetting.getToken();
			log.debug("token:"+token);
			request.setCharacterEncoding("UTF-8");  
		    response.setCharacterEncoding("UTF-8"); 
		    
		    String requestMethod=request.getMethod().toLowerCase();

		    System.out.println("wechat--requestMethod:"+requestMethod);
		    
		    if(requestMethod.equals("get")){//token 验证
		    	String signature= request.getParameter("signature");
		    	String timestamp= request.getParameter("timestamp");
		    	String nonce= request.getParameter("nonce");
		    	String echostr= request.getParameter("echostr");
		    	log.debug("signature:"+signature);
		    	log.debug("timestamp:"+timestamp);
		    	log.debug("nonce:"+nonce);
		    	log.debug("echostr:"+echostr);
		    	if(!StringHelper.IsNullOrEmpty(echostr)){
		    		String arr[]={token,timestamp,nonce};
			    	
			    	Arrays.sort(arr);
			    	
			    	String queryStr=StringHelper.Join("", arr);
			    	
			    	System.out.println("请求的参数："+queryStr);
			    	
			    	String signStr="";
			    	MessageDigest md=null;
			    	try {
			    		md=MessageDigest.getInstance("SHA-1");
			    		byte[] bytes=md.digest(queryStr.getBytes());
			    		signStr=DataConvert.byteToStr(bytes);
					} catch (Exception e) {
						e.printStackTrace();
					}
			    	log.debug("signStr:"+signStr);
			    	System.out.println("SHA-1："+signStr+"    signature:"+signature);
			    	if(signStr.equalsIgnoreCase(signature)){
			    		result=echostr;
			    	}
			    	//result=echostr;
		    	}
		    }else{ //事件处理
		    	
		    	WxMessage message=wechatHelper.getWxMessage(request);
		    	
		    	try {
		    		JSONObject jsonObject=new JSONObject(message);
		    		System.out.println(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
		    	
		    	String event=message.getEvent();
		    	String msgType=message.getMsgType();
		    	
		    	String fromUser=message.getFromUserName();
		    	String toUser=message.getToUserName();
		    	
		    	if(!StringHelper.IsNullOrEmpty(event)){
		    		
		    		switch (event.toLowerCase()) {
						case "subscribe"://关注
							String content="您好！欢迎关注"+siteInfo.getSiteName()+"！";
							result=wechatHelper.creatMessage(fromUser, toUser,"text",content );
							break;
						case "scan"://扫码
							int userId=DataConvert.ToInteger(message.getEventKey());
							
							break;
						default:
							break;
					}
		    	}
		    	if(msgType.equalsIgnoreCase("text")){//用户消息
					result=wechatHelper.creatMessage(fromUser, toUser,"transfer_customer_service","");
		    	}
		    }
		    
			 PrintWriter out = response.getWriter();
	         out.print(result);
	         out.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 生成菜单
	 * @return
	 */
	@RequestMapping(value="/creatMenu",method={RequestMethod.GET,RequestMethod.POST})
	public @ResponseBody Map<String, Object>CreatMenu(){
		return	wechatService.createMenu();
	}
}
