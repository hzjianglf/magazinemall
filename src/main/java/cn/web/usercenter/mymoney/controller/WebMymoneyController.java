package cn.web.usercenter.mymoney.controller;

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
@RequestMapping("/web/usercenter/mymoney")
public class WebMymoneyController {
	@Autowired
	private HttpSession session;
	@Autowired
	private AccountService accountService;
	@Autowired
	private SettingService settingService;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	//查询用户流水记录
	@RequestMapping("partialList")
	@ResponseBody
	public Map<String,Object> selUserAccount(@RequestParam Map<String,Object> map , int page, int limit ){
		Map<String,Object> result = new HashMap<String, Object>();
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		if(map!=null&&map.get("status")!=null) {
			String status = DataConvert.ToString(map.get("status"));
			if(status.equals("2")) {
				map.put("status", 0);
			}
		}
		int userId = getUserId();
		if(userId == 0) {
			return null;
		}
		map.put("userId", userId);
		map.put("pageSize", limit);
		long count = accountService.getRecordCount(map);
		Page page2 =new Page(count, page, limit);
		map.put("start", page2.getStartPos());
		list = accountService.getRecordList(map);
		
		result.put("data", list);
		result.put("count", count);
		result.put("msg", "");
		result.put("code", 0);
		return result;
	}
}
