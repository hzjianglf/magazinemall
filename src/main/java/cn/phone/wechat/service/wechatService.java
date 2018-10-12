package cn.phone.wechat.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections4.list.TreeList;
import org.apache.http.HttpResponse;
import org.apache.log4j.Logger;
import org.apache.log4j.Priority;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.phone.login.service.PhoneLoginService;
import cn.phone.login.service.WechatUserService;
import cn.util.wechat.WxUserInfo;
import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.admin.system.service.UserService;
import cn.util.DataConvert;
import cn.util.StringHelper;
import cn.util.wechat.HttpClictUtil;
import cn.util.wechat.WxMenu;
import cn.util.wechat.WxMenuItem;
import cn.util.wechat.wechatHelper;


@SuppressWarnings("unused")
@Service
public class wechatService {
	
	@Autowired
	wechatConfig wechatConfig;
	@Autowired
	HttpClictUtil httpClictUtil;
	@Autowired
	Setting setting;
	@Autowired
	UserService userService;
	@Autowired
	PhoneLoginService phoneLoginService;
	@Autowired
	WechatUserService wechatUserService;
	/**
	 * 生成微信菜单
	 * @param menuJsonStr
	 * @return
	 */
	public Map<String, Object> createMenu(){
		
		String menuJsonStr=getWxMenuJsonStr();
		String token=wechatConfig.getAccess_Token();
		return wechatHelper.createMenu(menuJsonStr, token);
	}
	
	/**
	 * 获取微信菜单
	 * @return
	 */
	public String getWxMenuJsonStr(){
		
		//TODO 根据后台配置读取
		//现在先固定
		String appId=wechatConfig.getAppId();
		
		String homeUrl=getSiteUrl()+"/home/index";
		String registerUrl=getSiteUrl()+"/usercenter/account/index";
		String orderUrl=getSiteUrl()+"/product/turnPublication";
		
		WxMenu menu=new WxMenu(){
			{
				setButton(new TreeList<WxMenuItem>(){
					{
						add(new WxMenuItem(){
							{
								setName("首页");
								setUrl(wechatHelper.creatWechatUrl(homeUrl,appId));
								setType("view");
							}
						});
						add(new WxMenuItem(){
							{
								setName("期刊");
								setUrl(wechatHelper.creatWechatUrl(orderUrl,appId));
								setType("view");
							}
						});
						add(new WxMenuItem(){
							{
								setName("我的");
								setUrl(wechatHelper.creatWechatUrl(registerUrl,appId));
								setType("view");
							}
						});
					}
				});
			}
		};
		
		JSONObject jsonObject=new JSONObject(menu);
		
		return jsonObject.toString();
	}
	
	/**
	 * 获取请求的域名
	 * @return
	 */
	public String getSiteUrl(){
		String siteUrl="";
		SiteInfo info=setting.getSetting(SiteInfo.class);
		if(info!=null){
			siteUrl=info.getSiteUrl();
		}
		return siteUrl;
	}
	
	/**
	 * 根据获取Id获取二维码地址
	 * @param id
	 * @return
	 */
	public Map<String,Object> getQrcodeUrl(int id){
		String token=wechatConfig.getAccess_Token();
		Map<String, Object>resultMap=wechatHelper.creatQrCode(token,id);
		return resultMap;
	}
	
	/**
	 * 用户信息检测
	 * @param code
	 * @param request
	 * @return  返回 是否关注
	 */
	public boolean checkUser(String code,HttpServletRequest request){
		boolean result=true;
		
		try {
			HttpSession session=request.getSession();
			
			String appId=wechatConfig.getAppId();
			String secret=wechatConfig.getAppSecret();
			String token=wechatConfig.getAccess_Token();
			
			//根据code获取openId
			String openId=wechatHelper.getOpenIdByCode(code, appId, secret);
			if(StringHelper.IsNullOrEmpty(openId)){
				throw new NullPointerException("通过code获取微信用户openId失败！");
			}
			session.setAttribute("openId",openId);
			WxUserInfo wxUserInfo=wechatHelper.getUserInfo(openId, token);
			if(wxUserInfo.getSubscribe()==0){ //用户是否关注
				throw new Exception("用户没有关注！");
			}
			//根据openId判断用户是否存在
			/*Map<String, Object>userInfo=userService.getUserInfoByOpenId(openId);
			if(userInfo!=null&&!userInfo.isEmpty()){
				int userId=DataConvert.ToInteger(userInfo.get("userId"));
				if(userId>0){
					result=true;
					session.setAttribute("userId", userId);
					return result;
				}
			}
			//获取微信用户信息 放 session 中,当用户注册时使用
			WxUserInfo wxUserInfo=wechatHelper.getUserInfo(openId, token);
			if(wxUserInfo.getSubscribe()==0){ //用户是否关注
				throw new Exception("用户没有关注！");
			}
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("address", wxUserInfo.getCountry()+wxUserInfo.getProvince()+wxUserInfo.getCity());
			paramMap.put("userUrl", wxUserInfo.getHeadimgurl());
			paramMap.put("nickName", wxUserInfo.getNickname());
			paramMap.put("openId", wxUserInfo.getOpenid());
			String sex = wxUserInfo.getSex();
			if("男".equals(sex)){
				paramMap.put("sex", 0);
			}else if("女".equals(sex)){
				paramMap.put("sex", 1);
			}else{
				paramMap.put("sex", 2);
			}
			int row = phoneLoginService.UserRegister(paramMap);
			if(row>0){
				result=true;
				session.setAttribute("userId", paramMap.get("userId")+"");
				session.setAttribute("userType",1);//微信注册，角色为普通用户
				return result;
			}
			session.setAttribute("WxUserInfo", wxUserInfo);*/
		} catch (Exception e) {
			result=false;
		}
		
		return result;
	}
	public boolean isTurnRegisterOrLogin(String code,HttpServletRequest request,HttpServletResponse response) {
		    boolean result=true;
			HttpSession session=request.getSession();
		try {
			String openId = (session.getAttribute("openId")).toString();
			String token=wechatConfig.getAccess_Token();
			//根据openId判断用户是否存在---------------
			Map<String, Object>wechatUserInfo=wechatUserService.getWechatUserInfoByOpenId(openId);
			if(wechatUserInfo!=null&&!wechatUserInfo.isEmpty()){
				if(wechatUserInfo.get("userId") ==null || "".equals(wechatUserInfo.get("userId"))) {
					//获取微信用户信息 放 session 中,当用户注册时使用
					WxUserInfo wxUserInfo=wechatHelper.getUserInfo(openId, token);
					session.setAttribute("WxUserInfo", wxUserInfo);
					String network = request.getScheme();
					String ip = request.getServerName();
					int port = request.getServerPort();
					//项目发布名称
					//String webApp = request.getContextPath();
					response.sendRedirect(network+"://"+ip+":"+port+"/allow/login");
					result=false;
				
				}else {
					session.setAttribute("userId", wechatUserInfo.get("userId"));
					result=true;
				}
			}else {//跳转到登录页面
				//获取微信用户信息 放 session 中,当用户注册时使用
				WxUserInfo wxUserInfo=wechatHelper.getUserInfo(openId, token);
				session.setAttribute("WxUserInfo", wxUserInfo);
				String network = request.getScheme();
				String ip = request.getServerName();
				int port = request.getServerPort();
				//项目发布名称
				//String webApp = request.getContextPath();
				response.sendRedirect(network+"://"+ip+":"+port+"/allow/login");
				result=false;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}

