package cn.core;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Priority;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import cn.phone.wechat.service.wechatConfig;
import cn.phone.wechat.service.wechatService;
import cn.util.DataConvert;
import cn.util.StringHelper;
import cn.util.wechat.wechatHelper;

/**
 * 微信端登录拦截
 * @author xiaoxueling
 *
 */
public class WxSessionInterceptor extends HandlerInterceptorAdapter {
	
	
	private static final Logger log = LoggerFactory
			.getLogger(WxSessionInterceptor.class);
	
	private wechatService service;
	private wechatConfig config;
	
	public WxSessionInterceptor(){}
	
	public WxSessionInterceptor(wechatService service,wechatConfig config){
		this.service = service;
		this.config=config;
	}
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response, Object handler) throws Exception {
			HttpSession session=request.getSession();
			request.setCharacterEncoding("UTF-8"); 
			
			String code=request.getParameter("code");
			if (StringHelper.IsNullOrEmpty(code)) {
				return true;
			}
			
			String openId=DataConvert.ToString(session.getAttribute("openId"));
			if(!StringHelper.IsNullOrEmpty(openId)) {
				boolean isThrough= service.isTurnRegisterOrLogin(code,request,response);
				return isThrough;
			}
			
			Integer userId=DataConvert.ToInteger(session.getAttribute("userId"));
			if(userId!=null&&userId>0){
				boolean isThrough= service.isTurnRegisterOrLogin(code,request,response);
				return isThrough;
			}
			//获取openId
			boolean flag=service.checkUser(code,request);
			if(!flag){
				//重新进行微信用户验证
				String uri = request.getRequestURL().toString();
				String query =request.getQueryString();
				if (!StringUtils.isEmpty(query)) {
					uri += "?" + query;
				}
				String appId=config.getAppId();
				String wechatUrl=wechatHelper.creatWechatUrl(uri,appId);
				
				log.info("微信重新验证的地址："+wechatUrl);
				response.sendRedirect(wechatUrl);
				
				return false;
			}else {
				boolean isThrough= service.isTurnRegisterOrLogin(code,request,response);
				if(!isThrough) {
					return false;
				}
			}
			return true;
    }
}
