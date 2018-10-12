package cn.phone.usercenter.mymoney.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
import cn.util.Page;
import cn.util.DataConvert;

@Controller
@RequestMapping("/phone/usercenter/mymoney")
public class PhoneMymoneyController {
	@Autowired
	private HttpSession session;
	@Autowired
	private AccountService accountService;
	@Autowired
	private SettingService settingService;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	//跳转包的流水记录页面
	@RequestMapping("turnLog")
	public ModelAndView turnLog(){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("footer",false);
		return new ModelAndView("/phone/usercenter/mymoney/userlog",map);
	}
	//查询用户流水记录
	@RequestMapping("partialList")
	@ResponseBody
	public ModelAndView selUserAccount(Integer pageNow){
		Map<String,Object> map = new HashMap<String, Object>();
		if(pageNow==null){
			pageNow=1;
		}
		map.put("start", (pageNow-1)*2);
		List<Object> list = new ArrayList<Object>();
		int userId = getUserId();
		List<Map<String,Object>> length = accountService.getYearsAndmonthCount(userId);
		if(null==length || length.size()==0){
			map.put("result", 1);
			map.put("pageTotal", 1);
			map.put("pageNow", 1);
			map.put("data", new ArrayList());
			return new ModelAndView("/phone/usercenter/mymoney/partlist",map);
		}
		long totalCount = length.size();
		Page page = new Page(totalCount, pageNow, 2);
		list = accountService.getYearsAndmonth(page.getStartPos(),2,userId);
		map.put("pageTotal", page.getTotalPageCount());
		map.put("list", list);
		map.put("pageNow", pageNow);
		return new ModelAndView("/phone/usercenter/mymoney/partlist",map);
	}
	//跳转我的钱包首页
	@RequestMapping("turnMymoney")
	@ResponseBody
	public ModelAndView turnMymoney(){
		int userId = getUserId();
		Map map = accountService.selectBalance(userId+"");
		return new ModelAndView("/phone/usercenter/mymoney/index",map);
	}
	//跳转充值中心
	@RequestMapping("/trunRecharge")
	@ResponseBody
	public ModelAndView trunRecharge(){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("platformType", 3);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> payMethods = settingService.getPayMethods(map);
		map.put("payMethods", payMethods);
		map.put("footer",false);
		return new ModelAndView("/phone/usercenter/mymoney/chong",map);
	}
	//充值操作
	@RequestMapping("/createOrder")
	@ResponseBody
	public Map<String,Object> createOrder(@RequestParam Map<String,Object> paramap){
		Map<String,Object> map = new HashMap<String, Object>();
		//创建paylog
		int userId = getUserId();
		paramap.put("money",paramap.get("price"));
		paramap.put("questioner", userId);
		paramap.put("userId", userId);
		int paylogId = accountService.addMoney(paramap);
		if(paylogId>0){
			map.put("result", 1);
			map.put("paylogId", paylogId);
			map.put("paytype", paramap.get("paytype"));
			return map;
		}
		map.put("msg", "生成订单错误");
		map.put("result", 0);
		return map;
	}
}
