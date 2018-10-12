package cn.admin.divisionAccounts.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.bill.service.BillService;
import cn.admin.divisionAccounts.service.DivisionExamineService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.Tools;

/**
 * 分成审核
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping(value="/admin/cents")
public class DivisionExamineController {

	@Autowired
	DivisionExamineService divisionExamineService;
	@Autowired
	BillService billService;
	@Autowired
	private HttpSession session;
	
	/**
	 * 审核列表
	 * @return
	 */
	@RequestMapping(value="/centsExamine")
	@Authorize(setting="财务-分账审核")
	public ModelAndView centsExamine() {
		return new ModelAndView("/admin/centsExamine/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		//状态
		int status = DataConvert.ToInteger(request.getParameter("status"));
		String xh = DataConvert.ToString(request.getParameter("name"));
		if(xh==""){
			xh=null;
		}
		//提交时间
		String submitTime = request.getParameter("submitTime");
		//提交人
		String inputer = request.getParameter("inputer");
		if(inputer==""){
			inputer = null;
		}
		//批次
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String startDate = null;
		String endDate =null;
		if(Tools.isNotEmpty(submitTime)){
			String[] split = submitTime.split(" - ");
			startDate = split[0];
			endDate = split[1];
			reqMap.put("startDate", startDate);
			reqMap.put("endDate", endDate);
		}
		long count = billService.getBillReckonCount(status, startDate, endDate, xh, inputer);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		
		List<Map<String, Object>> list = billService.getBillReckonList(status, startDate, endDate, xh, inputer, pages.getStartPos(), limit);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 审核
	 */
	@RequestMapping(value="/examineResult")
	@ResponseBody
	public Map<String, Object> examineResult(@RequestParam Map<String, Object> map){
		String userId = (String) session.getAttribute("userId");
		if(userId!=null&&!userId.equals("")){
			map.put("userId", userId);
		}
		Map<String, Object> reqMap = new HashMap<String,Object>();
		int row = divisionExamineService.updateExamineResult(map);
		if(row > 0) {
			reqMap.put("msg","审核成功!");
		}else {
			reqMap.put("msg","审核失败!");
		}
		return reqMap;
	}
	
	@RequestMapping(value="/opinion")
	public ModelAndView opinion(@RequestParam Map<String,Object> map){
		map=divisionExamineService.selOpinion(map);
		return new ModelAndView("/admin/centsExamine/opinion",map);
	}
	
	
}
