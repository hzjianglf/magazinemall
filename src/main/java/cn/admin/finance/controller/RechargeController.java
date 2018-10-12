package cn.admin.finance.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.finance.service.RechargeService;
import cn.core.Authorize;
import cn.util.Page;

/**
 * @2018年5月17日上午9:40:33
 * @Title:交易
 */

@Controller
@RequestMapping(value = "/admin/finance/Recharge")
public class RechargeController {
	@Autowired
	RechargeService rechargeService;
	/**
	 * 
	 * @Title:充值记录列表
	 */
	@RequestMapping(value = "/rechargeList")
	@Authorize(setting = "财务-充值表记录")
	public ModelAndView rechargeList() {
		return new ModelAndView("/admin/finance/recharge/recharge");
	}
	/**
	 * @title 充值记录列表数据
	 */
	@RequestMapping(value = "/rechargeListData")
	@ResponseBody
	public Map RechargeListData(HttpServletRequest request,
			@RequestParam Map search, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		long totalCount = rechargeService.selTotalCount(search);
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = rechargeService.getrechargeList(search);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	@RequestMapping(value="purchaseDataUp")
	public ModelAndView purchaseDataUp(Integer paylogid){
		Map result = rechargeService.getContentById(paylogid);
		System.out.println(result);
		return new ModelAndView("/admin/finance/recharge/purchaseUp",result);
	}

}
