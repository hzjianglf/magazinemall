package cn.admin.divisionAccounts.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.configuration.DatabaseConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.bill.service.BillService;
import cn.admin.divisionAccounts.service.DivisionService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;

/**
 * 分账计算
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping(value="/admin/division")
public class DivisionAccountsController {

	
	@Autowired 
	DivisionService divisionService;
	@Autowired
	BillService billService;
	
	
	
	/**
	 * 批次列表
	 */
	@RequestMapping(value="/batchlist")
	@Authorize(setting="分账计算-分账计算列表")
	public ModelAndView batchlist() {
		return new ModelAndView("/admin/division/batchlist");
	}
	
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>();
		
		long count = billService.getBillReckonCount(1, null, null, null, null);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		
		List<Map<String, Object>> list = billService.getBillReckonList(1, null, null, null, null, pages.getStartPos(), limit);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	
	/**
	 * 作废操作
	 */
	@RequestMapping(value="/updateStatus")
	@ResponseBody
	@Authorize(setting="分账计算-作废分账计算")
	public Map<String, Object> updateStatus(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		int id = DataConvert.ToInteger(map.get("id")); 
		int statu =DataConvert.ToInteger(map.get("status")); 
		boolean status = false;
		if(statu>0){
			status = true;
		}
		
		boolean row = billService.deleteBillReckon(id, status);
		if(row) {
			reqMap.put("success", true);
			reqMap.put("msg", "作废成功!");
		}else {
			reqMap.put("success", false);
			reqMap.put("msg", "作废失败!");
		}
		
		return reqMap;
		
	}
	
	/**
	 * 提交分成记录
	 */
	@RequestMapping(value="/handInDivisonlog")
	@ResponseBody
	@Authorize(setting="分账计算-提交分账计算")
	public Map<String, Object> handInDivisonlog(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		String idStr=DataConvert.ToString(map.get("id"));
		List<Integer> idList=StringHelper.ToIntegerList(idStr);
		boolean row = billService.submitBillReckon(idList);
		if(row) {
			reqMap.put("success", true);
			reqMap.put("msg", "提交成功!");
		}else {
			reqMap.put("success", false);
			reqMap.put("msg", "提交失败!");
		}
		return reqMap;
	}
	
	/**
	 * 分成计算弹窗
	 */
	@RequestMapping(value="/calculation")
	@Authorize(setting="分账计算-分成计算弹窗")
	public ModelAndView calculation(){
		Map<String, Object> map = new HashMap<String,Object>();
		List yearlist=new ArrayList();
		//获取当前年份
		Calendar time = Calendar.getInstance();
		int year = time.get(Calendar.YEAR);
		for(int i=0;i<3;i++) {
			Map<String, Object> ma=new HashMap<String,Object>();
			ma.put("year", year+i);
			yearlist.add(ma);
		}
		map.put("yearlist", yearlist);
		//获取当前月份
		int month=time.get(Calendar.MONTH)+1;
		List<Map> monthlist = new ArrayList();
		for(int k=0;k<=12-month;k++) {
			Map<String, Object> m = new HashMap<String,Object>();
			m.put("month", month+k);
			monthlist.add(m);
		}
		//查询已经计算的月份
		Map ma = new HashMap();
		ma.put("year", year);
		List<Map> mlist = divisionService.selYearByMonth(ma);
		for (int i=0;i<monthlist.size();i++) {
			for (int k=0;k<mlist.size();k++) {
				if(DataConvert.ToString(monthlist.get(i)).equals(DataConvert.ToString(mlist.get(k)))) {
					monthlist.remove(i);
				}
			}
		}
		
		map.put("monthlist", monthlist);
		return new ModelAndView("/admin/division/calculation/reckon",map);
	}
	/**
	 * 剔除已经计算分成的月份
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/changeMonth")
	@ResponseBody
	public Map<String, Object> changeMonth(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		
		Calendar time = Calendar.getInstance();
		//获取当前月份
		int month=time.get(Calendar.MONTH)+1;
		List<Map> monthlist = new ArrayList();
		for(int k=0;k<=12-month;k++) {
			Map<String, Object> m = new HashMap<String,Object>();
			m.put("month", month+k);
			monthlist.add(m);
		}
		//查询已经计算的月份
		List<Map> mlist = divisionService.selYearByMonth(map);
		for (int i=0;i<monthlist.size();i++) {
			for (int k=0;k<mlist.size();k++) {
				if(DataConvert.ToString(monthlist.get(i)).equals(DataConvert.ToString(mlist.get(k)))) {
					monthlist.remove(i);
				}
			}
		}
		reqMap.put("list", monthlist);
		return reqMap;
	}
	
	/**
	 * 开始计算
	 */
	@RequestMapping(value="/startCalculation")
	@ResponseBody
	@Authorize(setting="分账计算-开始计算分账")
	public Map<String, Object> startCalculation(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		reqMap=divisionService.startCalculation(map);
		return reqMap;
	}
	
	/**
	 * 分成详情
	 */
	@RequestMapping(value="/divisionDetail")
	@Authorize(setting="分账计算-分账详情")
	public ModelAndView divisionDetail(@RequestParam Map<String, Object> map){
		return new ModelAndView("/admin/division/detail/divisionDetail",map);
	} 
	@RequestMapping(value="/divisionDetail/listData")
	@ResponseBody
	public Map<String, Object> detailData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		String batchId=request.getParameter("batchId");
		String realname=request.getParameter("realname");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("batchId", batchId);
		reqMap.put("realname", realname);
		
		long count = divisionService.selectDivisionDetailCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = divisionService.selectDivisionDetailList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	/**
	 * 扣款
	 */
	@RequestMapping(value="/toCutMoney")
	@Authorize(setting="分账计算-扣款操作")
	public ModelAndView cutMonty(@RequestParam Map<String, Object> map) {
		return new ModelAndView("/admin/division/cutMoney/index",map);
	}
	@RequestMapping(value="/cutMoney")
	@ResponseBody
	public Map<String, Object> cutMoney(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		int row = divisionService.upCutMoney(map);
		if(row>0) {
			reqMap.put("success", true);
			reqMap.put("msg", "扣款成功!");
		}else {
			reqMap.put("success", false);
			reqMap.put("msg", "扣款失败!");
		}
		return reqMap;
	}
	
	/**
	 * 专栏作家分成详细
	 */
	@RequestMapping(value="/toTeacherDetail")
	@Authorize(setting="分成计算-专栏作家分成详细")
	public ModelAndView toTeacherDetail(@RequestParam Map<String, Object> map) {
		return new ModelAndView("/admin/division/teacher/index",map);
	}
	/**
	 * 课程销售记录
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/teacherOndemand")
	public ModelAndView teacherOndemand(@RequestParam Map<String, Object> map) {
		return new ModelAndView("/admin/division/teacher/iframe/classlog",map);
	}
	@RequestMapping(value="/teacherOndemand/listData")
	@ResponseBody
	public Map<String, Object> classlogData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		String userId=request.getParameter("userId");
		String year=request.getParameter("year");
		String month=request.getParameter("month");
		//课程名称
		String name=request.getParameter("name");
		//支付日期
		String payTime=request.getParameter("payTime");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("userId", userId);
		reqMap.put("time", year+"-"+month+"-01");
		//课程名称
		reqMap.put("name", name);
		//支付日期
		if(Tools.isNotEmpty(payTime)){
			String[] split = payTime.split(" - ");
			String startDate = split[0];
			String endDate = split[1];
			reqMap.put("startDate", startDate);
			reqMap.put("endDate", endDate);
		}
		
		long count = divisionService.selClassSaleLogCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = divisionService.selClassSaleLogList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	/**
	 * 问答记录
	 */
	@RequestMapping(value="/teacherQueslog")
	public ModelAndView teacherQueslog(@RequestParam Map<String, Object> map) {
		return new ModelAndView("/admin/division/teacher/iframe/questionlog",map);
	}
	@RequestMapping(value="/questionlog/listData")
	@ResponseBody
	public Map<String, Object> QuestionData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		String userId=request.getParameter("userId");
		String year=request.getParameter("year");
		String month=request.getParameter("month");
		//问答内容
		String content = request.getParameter("content");
		//支付日期
		String payTime = request.getParameter("payTime");
		//分成状态
		String divideStatus = request.getParameter("divideStatus");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("userId", userId);
		reqMap.put("time", year+"-"+month+"-01");
		reqMap.put("content", content);
		reqMap.put("divideStatus", divideStatus);
		if(Tools.isNotEmpty(payTime)){
			String[] split = payTime.split(" - ");
			String startDate = split[0];
			String endDate = split[1];
			reqMap.put("startDate", startDate);
			reqMap.put("endDate", endDate);
		}
		
		long count = divisionService.selQuestionlogCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = divisionService.selQuestionlogList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	/**
	 * 打赏记录
	 */
	@RequestMapping(value="/teacherRewardlog")
	public ModelAndView teacherRewardlog(@RequestParam Map<String, Object> map){
		return new ModelAndView("/admin/division/teacher/iframe/rewardlog",map);
	}
	@RequestMapping(value="/rewardlog/listData")
	@ResponseBody
	public Map<String, Object> RewardLogData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		String userId=request.getParameter("userId");
		String year=request.getParameter("year");
		String month=request.getParameter("month");
		//打赏描述
		String remark = request.getParameter("remark");
		//支付时间
		String payTime = request.getParameter("remark");
		//分成状态
		String status = request.getParameter("status");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("userId", userId);
		reqMap.put("time", year+"-"+month+"-01");
		reqMap.put("remark", remark);
		reqMap.put("status", status);
		if(Tools.isNotEmpty(payTime)){
			String[] split = payTime.split(" - ");
			String startDate = split[0];
			String endDate = split[1];
			reqMap.put("startDate", startDate);
			reqMap.put("endDate", endDate);
		}
		
		long count = divisionService.selRewardlogCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = divisionService.selRewardlogList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	
	/**
	 * 无效
	 */
	@RequestMapping(value="/invalid")
	@ResponseBody
	public Map<String, Object> invalid(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		reqMap = divisionService.invalid(map);
		return reqMap;
	}
	/**
	 * 有效
	 */
	@RequestMapping(value="/effective")
	@ResponseBody
	public Map<String, Object> effective(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		reqMap = divisionService.effective(map);
		return reqMap;
	}
	
}
