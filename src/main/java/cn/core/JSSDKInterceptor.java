package cn.core;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import cn.phone.wechat.service.wechatConfig;
import cn.util.StringHelper;
import cn.util.wechat.wechatHelper;

public class JSSDKInterceptor  extends HandlerInterceptorAdapter{

	wechatConfig wechatConfig;
	public JSSDKInterceptor(){
		
	}
	public JSSDKInterceptor(wechatConfig wechatConfig){
		this.wechatConfig=wechatConfig;
	}
	private static final org.slf4j.Logger log = LoggerFactory
			.getLogger(WxSessionInterceptor.class);
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		request.setCharacterEncoding("UTF-8");  
		log.info("微信拦截器...");
		//获取jssdk config 参数放到session中
		String url = request.getRequestURL().toString();
		String query=request.getQueryString();
		if (!StringUtils.isEmpty(query)) {
			url+="?"+query;
		}
		
		HttpSession session=request.getSession();
		String ticket=wechatConfig.getJsApi_Ticket();
		if(StringHelper.IsNullOrEmpty(ticket)){
			return true;
		}
		session.setAttribute("appId", wechatConfig.getAppId());
		
		Map<String, String>map=wechatHelper.sign(ticket, url);
	
		if(map!=null&&!map.isEmpty()){
			for (Map.Entry<String, String> item : map.entrySet()) {
				session.setAttribute(item.getKey(), item.getValue());
			}
		}
		
		return true;
	}
}
