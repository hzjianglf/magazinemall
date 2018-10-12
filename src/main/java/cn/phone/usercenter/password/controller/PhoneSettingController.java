package cn.phone.usercenter.password.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.AccountService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Tools;

/**
 * 修改密码
 * @author Administrator
 *
 */
@UserValidate
@Controller
@RequestMapping(value="/phone/setting")
public class PhoneSettingController {

	@Autowired
	HttpSession session;
	@Autowired
	AccountService accountService;
	@Autowired
	SettingService settingService;
	
	/**
	 * 修改密码
	 * @return
	 */
	@RequestMapping(value="/UpPassword")
	public ModelAndView UpPassword(){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("footer", false);
		return new ModelAndView("/phone/userPwd/upPwd",reqMap);
	}
	@RequestMapping(value="/updatePwdUser")
	@ResponseBody
	public Map<String, Object> updatePwdUser(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", DataConvert.ToInteger(session.getAttribute("userId")));
		//判断旧密码是否正确
		//查询旧密码
		String password = accountService.selPwd(map);
		if(!password.equals(Tools.md5(map.get("oldPwd")+""))){
			reqMap.put("result", 0);
			reqMap.put("msg", "旧密码不正确!");
			return reqMap;
		}
		//判断两次输入的密码是否一致
		if(!Tools.md5(map.get("newPwd")+"").equals(Tools.md5(map.get("confirmNewPwd")+""))){
			reqMap.put("result", 0);
			reqMap.put("msg", "两次输入的密码不一致!");
			return reqMap;
		}
		//判断修改密码是否与原密码一样
		if(!password.equals(Tools.md5(map.get("newPwd")+""))){
			reqMap.put("result", 0);
			reqMap.put("msg", "旧密码与原密码不能相同!");
			return reqMap;
		}
		//修改密码
		map.put("password", Tools.md5(map.get("newPwd")+""));
		int row = accountService.updatePwd(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "修改成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "修改失败!");
		}
		return reqMap;
	}
	/**
	 * 专栏设置页面
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/SpecialSet")
	public ModelAndView SpecialSet(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", DataConvert.ToInteger(session.getAttribute("userId")));
		reqMap=settingService.getSpecialSetMsg(map);
		reqMap.put("footer", false);
		return new ModelAndView("/phone/specialSet/setlist",reqMap);
	}
	/**
	 * 专栏设置信息保存
	 * @return
	 */
	@RequestMapping(value="/addSet")
	@ResponseBody
	public Map<String, Object> addSet(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", DataConvert.ToInteger(session.getAttribute("userId")));
		int row = settingService.addSpecialSetMsg(map);
		if(row>0){
			reqMap.put("success", true);
			reqMap.put("msg", "设置成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "设置失败!");
		}
		return reqMap;
	}
	
	
}
