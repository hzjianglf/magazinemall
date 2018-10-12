package cn.phone.userreward.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.AccountService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.util.DataConvert;

/**
 * 打赏
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping(value="/phone/reward")
public class UserRewardController {

	@Autowired
	AccountService accountService;
	@Autowired
	SettingService settingService;
	@Autowired
	HttpSession session;
	
	/**
	 * 打赏支付页面
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/payReward")
	@UserValidate//未登录状态不允许访问此页面
	public ModelAndView payReward(@RequestParam Map<String, Object> map){
		Map<String, Object> maps = new HashMap<String, Object>();
		maps.put("teacherId", map.get("teacherId")+"");
		maps.put("money", Double.parseDouble(map.get("money")+""));
		maps.put("rewardMsg", map.get("rewardMsg")+"");
		//教师名称
		Map reqMap = accountService.selectUserMsg(map.get("teacherId")+"");
		Map data = (Map) reqMap.get("data");
		String userName = DataConvert.ToString(data.get("nickName"));
		if(userName==null||userName=="") {
			userName = DataConvert.ToString(data.get("userName"));
		}
		if(userName==null||userName=="") {
			userName = "XXX";
		}
		maps.put("realname", userName);
		//查询账户余额
		Map balance = accountService.selectBalance(session.getAttribute("userId")+"");
		maps.put("balance", Double.parseDouble(balance.get("balance")+""));
		//获取支付方式列表
		map.put("platformType", 3);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> list = settingService.getPayMethods(map);
		maps.put("paylist", list);
		maps.put("footer", false);
		return new ModelAndView("/phone/reward/payReward",maps);
	}
	
}
