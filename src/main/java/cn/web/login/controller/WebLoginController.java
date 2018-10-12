package cn.web.login.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.log4j.Priority;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.SMS.SmsService;
import cn.api.service.AccountService;
import cn.phone.login.service.PhoneLoginService;
import cn.phone.login.service.WechatUserService;
import cn.util.DataConvert;
import cn.util.StringHelper;
import cn.util.Tools;
import cn.util.wechat.WxUserInfo;
import cn.util.wechat.wechatHelper;

/**
 * pc  用户登录、注册
 */
@Controller
@RequestMapping("/web/login")
public class WebLoginController {
	@Autowired
	private HttpSession session;
	@Autowired
	private AccountService accountService;
	@Autowired
	WechatUserService wechatUserService;
	@Autowired
	SmsService smsService;
	@Autowired
	PhoneLoginService phoneLoginService;
	/**
	 * 忘记密码
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/findPassword")
	@ResponseBody
	public Map<String,Object> findPassword(@RequestParam Map<String,Object> map, HttpServletRequest request){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", 0);
		result.put("msg", "修改失败");
		
		String telenumber = DataConvert.ToString(map.get("telenumber"));
		String code = DataConvert.ToString(map.get("code"));
		String password = DataConvert.ToString(map.get("password"));
		String newPwd = DataConvert.ToString(map.get("newPwd"));
		
		String pwd = accountService.selPwd(map);
		if(pwd==null) {
			result.put("success", 2);
			result.put("msg", "该手机号还未注册，请先注册！");
			return result;
		}
		if(StringUtils.isEmpty(telenumber)){
			result.put("msg", "请输入手机号");
			return result;
		}
		if(StringUtils.isEmpty(code)){
			result.put("msg", "请输入验证码");
			return result;
		}
		boolean flags = isChinaPhoneLegal(telenumber);
		if(!flags){
			result.put("msg", "手机号码有误");
			return result;
		}
		boolean validCode=smsService.Verify(telenumber,code,request);
		if(!validCode) {
			result.put("msg","短信验证码错误！");
			return result;
		}
		
		if(!password.equals(newPwd)) {
			result.put("msg", "两次密码不正确");
			return result;
		}
		map.put("password", Tools.md5(DataConvert.ToString(map.get("newPwd"))));
		int row = accountService.updatePwd(map);
		if(row > 0){
			result.put("success", 1);
			result.put("msg", "修改成功!");
		}
		
		return result;
	}
	
	
	/**
	 * 用户登录验证
	 * 
	 */
	@RequestMapping(value="/loginCheck")
	@ResponseBody
	public Map loginCheck(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		String userPass = map.get("userPass")+"";
		String newPass = Tools.md5(userPass);
		map.put("userPwd", newPass);
		Map userinfo = accountService.login(map);
		if(userinfo!=null){
			if(userinfo.get("isFreeze").toString().equals("0")){
				result.put("result", 0);
				result.put("msg", "该账户已被冻结！");
				return result;
			}
			
			Map<String,Object> wechatParam=new HashMap<String,Object>();
			WxUserInfo wxUserInfo = (WxUserInfo) session.getAttribute("WxUserInfo");
			if(wxUserInfo!=null){//说明是微信登录
				//根据openId判断用户是否存在---------------
				String openId = wxUserInfo.getOpenid();
				if(openId !=null && !"".equals(openId)) {
					wechatParam.put("openId", openId);
					wechatParam.put("userId", userinfo.get("userId"));
					Map<String, Object>wechatUserInfo=wechatUserService.getWechatUserInfoByOpenId(openId);
					if(wechatUserInfo !=null) {//更新wechat_userinfo表
						wechatUserService.updateWeChatUserId(wechatParam);
					}else {//插入wechat_userinfo表
						wechatParam.put("nickName", wxUserInfo.getNickname());
						wechatParam.put("userUrl", wxUserInfo.getHeadimgurl());
						wechatUserService.insertWeChatUserRecord(wechatParam);
					}
				}
			}
			
			result.put("msg", "登录成功");
			result.put("result", 1);
			session.setAttribute("PCuserId", userinfo.get("userId"));
			session.setAttribute("userType", userinfo.get("userType").toString());
			session.setAttribute("nickName", userinfo.get("telenumber").toString());
			return result;
		}else{
			result.put("result", 0);
			result.put("msg", "手机号或密码错误");
		}
		return result;
	}
	/**
	 * 用户快捷登录
	 * @return
	 */
	@RequestMapping("/quickLoginRegister")
	@ResponseBody
	public Map<String,Object> quickLoginRegister(String telenumber,String code,HttpServletRequest request){
		Map map =new HashMap();
		if(StringUtils.isEmpty(telenumber)){
			map.put("result", 0);
			map.put("msg", "请输入手机号");
			return map;
		}
		if(StringUtils.isEmpty(code)){
			map.put("result", 0);
			map.put("msg", "请输入验证码");
			return map;
		}
		boolean flags = isChinaPhoneLegal(telenumber);
		if(!flags){
			map.put("result", 0);
			map.put("msg", "手机号码有误");
			return map;
		}
		boolean validCode=smsService.Verify(telenumber,code,request);
		if(!validCode) {
			map.put("msg","短信验证码错误！");
			return map;
		}
		Map user = new HashMap();
		user.put("telenumber", telenumber);
		Map userinfo = accountService.login(user);
		if(userinfo!=null){
			
			Map<String,Object> wechatParam=new HashMap<String,Object>();
			WxUserInfo wxUserInfo = (WxUserInfo) session.getAttribute("WxUserInfo");
			if(wxUserInfo!=null){//说明是微信登录
				//根据openId判断用户是否存在---------------
				String openId = wxUserInfo.getOpenid();
				if(openId !=null && !"".equals(openId)) {
					wechatParam.put("openId", openId);
					wechatParam.put("userId", userinfo.get("userId"));
					Map<String, Object>wechatUserInfo=wechatUserService.getWechatUserInfoByOpenId(openId);
					if(wechatUserInfo !=null) {//更新wechat_userinfo表
						wechatUserService.updateWeChatUserId(wechatParam);
					}else {//插入wechat_userinfo表
						wechatParam.put("nickName", wxUserInfo.getNickname());
						wechatParam.put("userUrl", wxUserInfo.getHeadimgurl());
						wechatUserService.insertWeChatUserRecord(wechatParam);
					}
				}
			}
			
			map.put("result", 1);
			session.setAttribute("nickName", userinfo.get("telenumber").toString());
			session.setAttribute("userId", userinfo.get("userId"));
			session.setAttribute("userType", userinfo.get("userType").toString());
		}else{
			user.put("isAdmin", 0);
			user.put("userType", 1);
			String userId = accountService.register(user);
			if(userId.equals("0")||userId==null){
				map.put("result", 0);
				return map;
			}
			Logger logger=Logger.getLogger(wechatHelper.class);
			logger.log(Priority.DEBUG, "用户快捷登陆userId"+userId);
			Map<String,Object> wechatParam=new HashMap<String,Object>();
			WxUserInfo wxUserInfo = (WxUserInfo) session.getAttribute("WxUserInfo");
			if(wxUserInfo!=null){//说明是微信注册
				//根据openId判断用户是否存在---------------
				String openId = wxUserInfo.getOpenid();
				if(openId !=null && !"".equals(openId)) {
					wechatParam.put("openId", openId);
					wechatParam.put("userId", userId);
					Map<String, Object>wechatUserInfo=wechatUserService.getWechatUserInfoByOpenId(openId);
					if(wechatUserInfo !=null) {//更新wechat_userinfo表
						wechatUserService.updateWeChatUserId(wechatParam);
					}else {//插入wechat_userinfo表
						wechatParam.put("nickName", wxUserInfo.getNickname());
						wechatParam.put("userUrl", wxUserInfo.getHeadimgurl());
						wechatUserService.insertWeChatUserRecord(wechatParam);
					}
					session.setAttribute("userId", userId);
				}
			}
			
			
			
			map.put("result", 1);
			map.put("data", userId);
			session.setAttribute("userId", userId);
			session.setAttribute("userType", 1);
		}
		return map;
	}
	
	/**
	 * 用户注册保存
	 */
	@RequestMapping("/registerSave")
	public @ResponseBody Map<String,Object> registerSave(@RequestParam Map<String, Object> paramMap,HttpServletRequest request,HttpServletResponse response){
		Map<String,Object> result=new HashMap<String,Object>();
		result.put("result", false);
		result.put("msg", "注册失败！");
		
		try {
			
			String phone=DataConvert.ToString(paramMap.get("phone"));
			if(StringHelper.IsNullOrEmpty(phone)){
				result.put("msg","请输入手机号");
				return result;
			}
			
			String code=DataConvert.ToString(paramMap.get("code"));
			if(StringHelper.IsNullOrEmpty(code)){
				result.put("msg","请输入短信验证码");
				return result;
			}
			
			boolean validCode=smsService.Verify(phone,code,request);
			if(!validCode) {
				result.put("msg","短信验证码错误！");
				return result;
			}
			
			//判断两次输入的密码是否一致
			String pwd=Tools.md5(DataConvert.ToString(paramMap.get("pwd")));
			String pwdConfirm=Tools.md5(DataConvert.ToString(paramMap.get("pwdConfirm")));
			if(!pwd.equals(pwdConfirm)){
				result.put("msg","两次输入密码不一致！");
				return result;
			}
			//
			//注册逻辑
			paramMap.put("pwd", pwd);
			//先判断该手机号是否已经注册
			Map<String,Object> userMap = phoneLoginService.selectUserIsExistence(paramMap);
			if(!StringUtils.isEmpty(userMap)){
				result.put("msg","该手机号已经注册!");
				return result;
			}
			WxUserInfo wxUserInfo = (WxUserInfo) session.getAttribute("WxUserInfo");
			int row = phoneLoginService.UserRegister(paramMap);
			Map<String,Object> wechatParam=new HashMap<String,Object>();
			if(row > 0){
				if(wxUserInfo!=null){//说明是微信注册
					//根据openId判断用户是否存在---------------
					String openId = wxUserInfo.getOpenid();
					if(openId !=null && !"".equals(openId)) {
						wechatParam.put("openId", openId);
						wechatParam.put("userId", paramMap.get("userId"));
						Map<String, Object>wechatUserInfo=wechatUserService.getWechatUserInfoByOpenId(openId);
						if(wechatUserInfo !=null) {//更新wechat_userinfo表
							wechatUserService.updateWeChatUserId(wechatParam);
						}else {//插入wechat_userinfo表
							wechatParam.put("nickName", wxUserInfo.getNickname());
							wechatParam.put("userUrl", wxUserInfo.getHeadimgurl());
							wechatUserService.insertWeChatUserRecord(wechatParam);
						}
						session.setAttribute("userId", paramMap.get("userId"));
					}
				}
				result.put("result", true);
				result.put("msg", "注册成功！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "注册失败！");
			
		}
		return result;	
	}
	/**
	 * 退出登陆
	 */
	@RequestMapping(value="/outLogin")
	public String outLogin(@RequestParam Map<String,Object> map) {
		session.invalidate();
		map.put("footer", false);
		return "redirect:/web/home/index";
	}
	
	
	//判断手机号
	public boolean isChinaPhoneLegal(String phoneNum){
		 String regExp = "^((1[38]\\d)|(15[^4])|(1[67][^9])|(19[89]))\\d{8}$"; 
		 
	     Pattern p = Pattern.compile(regExp);  
	     Matcher m = p.matcher(phoneNum);  
	     return m.matches();  
	}
}
