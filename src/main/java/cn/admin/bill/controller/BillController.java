package cn.admin.bill.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.executor.loader.ResultLoader;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.ObjectMapper;

import cn.admin.bill.model.BillRule;
import cn.admin.bill.model.CalcRuleSetting;
import cn.admin.bill.model.OndemandRuleSetting;
import cn.admin.bill.model.PersonalTaxItem;
import cn.admin.bill.model.PersonalTaxItem.RelationOperator;
import cn.admin.bill.model.UserRuleSetting;
import cn.admin.bill.service.BillRuleService;
import cn.admin.bill.service.BillService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;

/**
 * 分账
 * @author xiaoxueling
 *
 */
@RequestMapping("/admin/bill")
@Controller
public class BillController {

	@Autowired
	private BillService billService;
	@Autowired
	private BillRuleService billRuleService;
	
	//获取计算分成的月份
	@RequestMapping(value = "/monthList")
	public ModelAndView monthList(){
		List yearList = new ArrayList();
		Map monthMap = new HashMap();
		List<String> listMonth = new ArrayList<String>();
		//获取上一年的数据
		String upyear = DataConvert.ToString(Calendar.getInstance().get(Calendar.YEAR)-1);
		listMonth = billService.getMonthList(upyear);
		yearList.add(upyear);
		monthMap.put("upmonth",listMonth);
		//获取本年的数据
		String newyear = DataConvert.ToString(Calendar.getInstance().get(Calendar.YEAR));
		listMonth = billService.getMonthList(newyear);
		yearList.add(newyear);
		monthMap.put("newmonth",listMonth);
		monthMap.put("year", yearList);
		
		return new ModelAndView("/admin/division/calculation/reckon",monthMap);
	}
	
	//分成计算
	@RequestMapping(value = "/SetUpFormula")
	public ModelAndView SetUpFormula(@RequestParam Map<String, Object> map){
		
		String year=DataConvert.ToString(map.get("year"));
		String month=DataConvert.ToString(map.get("month"));
		
		if(StringHelper.IsNullOrEmpty(year)) {
			year=DataConvert.ToString(Calendar.getInstance().get(Calendar.YEAR));
		}
		if(StringHelper.IsNullOrEmpty(month)) {
			month=billService.getMonthList(year).get(0);
		}
		
		CalcRuleSetting ruleSetting=billRuleService.getBillRule(year, month).getRuleSetting();
		
		map.put("setting", ruleSetting);
		map.put("year",year);
		map.put("month",month);
		
		return new ModelAndView("admin/division/calculation/setupformula",map);
	}
	
	//分成保存
	@RequestMapping(value = "/saveCalcRuleSetting")
	@ResponseBody
	public Map<String,Object> saveCalcRuleSetting( @RequestParam Map<String,Object> map ) {
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", false);
		result.put("msg","保存失败");
		
		CalcRuleSetting calcRuleSetting = new CalcRuleSetting();
		calcRuleSetting.setActualPayment((String) map.get("actualPayment"));
		if(calcRuleSetting.getActualPayment()==null||calcRuleSetting.getActualPayment().isEmpty()){
			result.put("msg", "实发总金额公式错误！！");
			return result;
		}
		calcRuleSetting.setOndemandSalesIncome((String) map.get("ondemandSalesIncome"));
		if(calcRuleSetting.getOndemandSalesIncome()==null||calcRuleSetting.getOndemandSalesIncome().isEmpty()){
			result.put("msg", "课销收入计算公式错误！！");
			return result;
		}
		calcRuleSetting.setQuestionSalesIncome((String) map.get("questionSalesIncome"));
		if(calcRuleSetting.getQuestionSalesIncome()==null||calcRuleSetting.getQuestionSalesIncome().isEmpty()){
			result.put("msg", "问答收入计算公式错误！");
			return result;
		}
		calcRuleSetting.setRewardSalesIncome((String) map.get("rewardSalesIncome"));
		if(calcRuleSetting.getRewardSalesIncome()==null||calcRuleSetting.getRewardSalesIncome().isEmpty()){
			result.put("msg", "打赏收入计算公式错误!");
			return result;
		}
		calcRuleSetting.setOndemandSalesTax((String) map.get("ondemandSalesTax"));
		if(calcRuleSetting.getOndemandSalesTax()==null||calcRuleSetting.getOndemandSalesTax().isEmpty()){
			result.put("msg", "课销营业税计算公式错误!");
			return result;
		}
		calcRuleSetting.setRewardSalesTax((String) map.get("rewardSalesTax"));
		if(calcRuleSetting.getRewardSalesTax()==null||calcRuleSetting.getRewardSalesTax().isEmpty()){
			result.put("msg", "打赏营业税计算公式错误!");
			return result;
		}
		calcRuleSetting.setQuestionSalesTax((String) map.get("questionSalesTax"));
		if(calcRuleSetting.getQuestionSalesTax()==null||calcRuleSetting.getQuestionSalesTax().isEmpty()){
			result.put("msg", "问答营业税计算公式错误!");
			return result;
		}
		calcRuleSetting.setShouldPayment((String) map.get("shouldPayment"));
		if(calcRuleSetting.getShouldPayment()==null||calcRuleSetting.getShouldPayment().isEmpty()){
			result.put("msg", "应发总金额公式错误!");
			return result;
		}
		calcRuleSetting.setOndemandSalesSeparate((String) map.get("ondemandSalesSeparate"));
		if(calcRuleSetting.getOndemandSalesSeparate()==null||calcRuleSetting.getOndemandSalesSeparate().isEmpty()){
			result.put("msg", "课销分成计算公式错误!");
			return result;
		}
		calcRuleSetting.setQuestionSalesSeparate((String) map.get("questionSalesSeparate"));
		if(calcRuleSetting.getQuestionSalesSeparate()==null||calcRuleSetting.getQuestionSalesSeparate().isEmpty()){
			result.put("msg", "问答分成计算公式错误!");
			return result;
		}
		calcRuleSetting.setRewardSalesSeparate((String) map.get("rewardSalesSeparate"));
		if(calcRuleSetting.getRewardSalesSeparate()==null||calcRuleSetting.getRewardSalesSeparate().isEmpty()){
			result.put("msg", "打赏分成计算公式错误!");
			return result;
		}
		
		List<PersonalTaxItem> personalTaxList =new ArrayList<PersonalTaxItem>();
		
		String  personalTaxListStr =DataConvert.ToString(map.get("personalTaxList"));
		if(StringHelper.IsNullOrEmpty(personalTaxListStr)) {
			result.put("msg","请配置个税计算公式！");
			return result;
		}
		
		List<Map<String,Object>> listMap=Tools.JsonTolist(personalTaxListStr);
		
		for(Map<String, Object> item : listMap) {

			String operatorStr=DataConvert.ToString(item.get("operator"));
			double money=DataConvert.ToDouble(item.get("money"),-100d);
			String formula=DataConvert.ToString(item.get("formula"));
			
			if(StringHelper.IsNullOrEmpty(operatorStr)) {
				result.put("msg","大小于选择错误！");
				return result;
			}
			if(money==-100d) {
				result.put("msg","个税数配置错误！");
				return result;
			}
			if(StringHelper.IsNullOrEmpty(formula)) {
				result.put("msg","个税计算公式配置错误！");
				return result;
			}
			
			//比较
			RelationOperator operator = null;
			switch (operatorStr.trim()) {
				case "大于等于":
					operator = RelationOperator.GreaterThanEqual;
					break;
				case "大于":
					operator = RelationOperator.GreaterThan;
					break;
				case "等于":
					operator = RelationOperator.Equal;
					break;
				case "小于等于":
					operator = RelationOperator.LessThanEqual;
					break;
				case "小于":
					operator = RelationOperator.LessThan;
					break;
				default:
					operator = RelationOperator.GreaterThanEqual;
					break;
			}
			
			PersonalTaxItem personalTaxItem=new PersonalTaxItem();
			personalTaxItem.setOperator(operator);
			personalTaxItem.setMoney(money);
			personalTaxItem.setFormula(formula);
			personalTaxList.add(personalTaxItem);
		}
		calcRuleSetting.setPersonalTaxList(personalTaxList);
		if(calcRuleSetting.getPersonalTaxList()==null||calcRuleSetting.getPersonalTaxList().isEmpty()){
			result.put("msg", "个税计算公式错误!");
			return result;
		}
		
		boolean bool = billRuleService.changeCalcRuleSetting(map.get("year").toString(),map.get("month").toString(), calcRuleSetting , true);
		
		if(bool){
			result.put("success", true);
			result.put("msg", "保存成功");
		}
		return result;
	}
	
	//to设置分成比例
	@RequestMapping(value = "/toProportions")
	public ModelAndView toProportions( @RequestParam Map<String,Object> map ) {
		
		return new ModelAndView("/admin/division/calculation/upProportions",map);
	}
	
	//分成比例data
	@RequestMapping(value = "/proportionDataList")
	@ResponseBody
	public Map<String,Object>  proportionDataList( @RequestParam Map<String,Object> map , int page, int limit) {
		Map<String,Object> dataList = new HashMap<String,Object>();
		long count = billService.getUsersCountForShow(map.get("year").toString(),map.get("month").toString());
		Page page2 = new Page(count, page, limit);
		List<Map<String,Object>> list = billService.getUserListForShow(map.get("year").toString(),map.get("month").toString(), page2.getStartPos(), limit);
		dataList.put("data", list);
		dataList.put("count", count);
		dataList.put("msg", "");
		dataList.put("code", 0);
		
		return dataList;
	}
	
	@RequestMapping(value="/upUpPro")
	public ModelAndView upUpPro(@RequestParam Map<String,Object> map){
		Map<String,Object> userinfo = billService.selUserinfoById(map);
		map.putAll(userinfo);
		String year = DataConvert.ToString(map.get("year"));
		String month = DataConvert.ToString(map.get("month"));
		int userId = DataConvert.ToInteger(map.get("userId"));
		UserRuleSetting userRuleSetting = billRuleService.getUserRuleSetting(year, month, userId);
		
		map.put("rewardRate", userRuleSetting.getRewardRate());
		map.put("questionRate", userRuleSetting.getQuestionRate());
		return new ModelAndView ( "/admin/division/calculation/upUpProportions" , map );
	}
	//设置分成data
	@RequestMapping(value = "/upUpProList")
	@ResponseBody
	public Map<String,Object>  upUpProList( @RequestParam Map<String,Object> map) {
		String year = DataConvert.ToString(map.get("year"));
		String month = DataConvert.ToString(map.get("month"));
		int userId = DataConvert.ToInteger(map.get("userId"));
		Map<String,Object> dataList = new HashMap<String,Object>();
		List<Map<String,Object>> list = billService.getOndemandListForShow(year, month, userId);
		
		dataList.put("data", list);
		dataList.put("count", 1);
		dataList.put("msg", "");
		dataList.put("code", 0);
		return dataList;
	}
	
	
	/**
	 * 更改专家分成状态
	 */
	@RequestMapping(value="/changeUserRuleState")
	public @ResponseBody Map<String, Object> changeUserRuleState(@RequestParam Map<String, Object>paramMap){
		
		Map<String, Object> result=new HashMap<String,Object>();
		result.put("result", false);
		result.put("msg", "操作失败");
		
		int userId=DataConvert.ToInteger(paramMap.get("userId"));
		int status=DataConvert.ToInteger(paramMap.get("status"),1);
		String year=DataConvert.ToString(paramMap.get("year"));
		String month=DataConvert.ToString(paramMap.get("month"));
		if(userId<=0||StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)) {
			result.put("msg", "请求错误,请联系管理员！");
			return result;
		}
		
		boolean flag=billService.changeUserRuleState(year, month, userId, status);
		if(flag) {
			result.put("result", true);
			result.put("msg", "操作成功");
		}
		return result;
	}
	
	//保存分成
	@RequestMapping(value = "/saveOndemand")
	public @ResponseBody Map<String,Object> saveOndemand(@RequestParam Map<String,Object> map){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("successs", false);
		result.put("msg", "保存失败");
		
		if(!DataConvert.ToString(map.get("rewardRate")).matches("^\\d+(\\.\\d+)?$")){
			result.put("msg", "问答分成不是数字");
			return result;
		}
		
		if(!DataConvert.ToString(map.get("questionRate")).matches("^\\d+(\\.\\d+)?$")){
			result.put("msg", "打赏分成不是数字");
			return result;
		}
		
		List<OndemandRuleSetting> ondemandRuleSettings =new ArrayList<OndemandRuleSetting>();
		
		String  dataStr =DataConvert.ToString(map.get("list"));
		
		if(!StringHelper.IsNullOrEmpty(dataStr)){
			
			List<Map<String,Object>> listMap=Tools.JsonTolist(dataStr);
			
			for(Map<String, Object> item : listMap) {

				int ondemandId=DataConvert.ToInteger(item.get("ondemandId"));
				double rate=DataConvert.ToDouble(item.get("rate"),-100d);
				int status = DataConvert.ToInteger(item.get("status"));
				
				if(rate==-100d) {
					result.put("msg","分成比例错误！");
					return result;
				}
				
				OndemandRuleSetting ondemandRuleSetting = new OndemandRuleSetting();
				ondemandRuleSetting.setOndemandId(ondemandId);
				ondemandRuleSetting.setRate(rate);
				ondemandRuleSetting.setStatus(status);
				
				ondemandRuleSettings.add(ondemandRuleSetting);
			}
		}
		
		boolean row = billService.changeUserRuleSetting(map.get("year").toString(), map.get("month").toString(), DataConvert.ToInteger(map.get("userId")) , DataConvert.ToDouble(map.get("questionRate")), DataConvert.ToDouble(map.get("rewardRate")), ondemandRuleSettings);
		if(row){
			result.put("msg","添加成功！");
			result.put("success", true);
		}
		return result;
	}
	
	@RequestMapping(value="/startcalc")
	@ResponseBody
	public Map<String,Object> startcalc(@RequestParam Map<String,Object> map){
		String year = DataConvert.ToString(map.get("year"));
		String month = DataConvert.ToString(map.get("month"));
		Map<String,Object> data =  billService.calculation(year, month);
		return data;
	}
	
	//跳转到确认页面
	@RequestMapping(value="/toConfirmYE")
	public ModelAndView toConfirmYE(@RequestParam Map<String,Object> map){
		return new ModelAndView("/admin/division/calculation/confirm",map);
	}
	
	//确认列表
	@RequestMapping(value="/dataList")
	@ResponseBody
	public Map<String,Object> dataList(@RequestParam Map<String,Object> map , int page, int limit){
		Map<String,Object> result = new HashMap<String,Object>();
		int id = DataConvert.ToInteger(map.get("id"));
		String userName=DataConvert.ToString(map.get("userName"));
		long count = billService.getReckonItemCountById(id,userName);
		Page page2 = new Page(count, page, limit);
		List<Map<String,Object>> list = billService.getReckonItemListById(id,userName,page2.getStartPos(), limit);
		result.put("data", list);
		result.put("count", count);
		result.put("msg", "");
		result.put("code", 0);
		return result;
	}
	
	//to作家扣款
	@RequestMapping(value="/toWithdrawing")
	public ModelAndView toWithdrawing(@RequestParam Map<String, Object> map) {
		return new ModelAndView("/admin/division/calculation/withdrawing",map);
	}
	//作家扣款
	@RequestMapping(value="/withDrawing")
	@ResponseBody
	public Map<String, Object> withDrawing(@RequestParam Map<String, Object> map , HttpServletRequest request) throws Exception{
		
		Map<String, Object> result = billService.selBillreckonitem(map, request);
		
		return result;
	}
	
	//作家扣款并重新计算
	@RequestMapping(value="/updBillReckonItem")
	@ResponseBody
	public Map<String, Object> updBillReckonItem(@RequestParam Map<String,Object> map ,HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		Map<String,Object> sessionData = (Map<String, Object>) session.getAttribute("billreckonitemData");
		if(sessionData==null) {
			return null;
		}
		sessionData.put("cutRemark", DataConvert.ToString(map.get("cutRemark")));
		map.putAll(sessionData);
		Map<String, Object> result = billService.updateBillReckonItem(map);
		session.setAttribute("billreckonitemData", null);

		return result;
	}
	
	//清除专家缓存
	@RequestMapping(value="/clearBillReckonItem")
	@ResponseBody
	public void clearBillReckonItem(HttpServletRequest request){
		
		HttpSession session = request.getSession();
		Map<String,Object> sessionData = (Map<String, Object>) session.getAttribute("billreckonitemData");
		if(sessionData==null) {
			return ;
		}
		session.setAttribute("billreckonitemData", null);

	}
	
	//to分成详情页
	@RequestMapping(value="/sourceListForReckon")
	public ModelAndView sourceListForReckon(@RequestParam Map<String,Object> map){
		return new ModelAndView("/admin/division/calculation/sourceListForReckon",map);
	}
	
	//课程、问答、打赏分成详情
	@RequestMapping(value="/ruestionListData")
	@ResponseBody
	public Map<String,Object> ruestionListData(@RequestParam Map<String,Object> map , int page , int limit){
		Map<String,Object> result = DataList(map,page,limit);
		return result;
	}
	
	//分成datalist
	private Map<String,Object> DataList(Map<String,Object> map , int page , int limit){
		Map<String,Object> result = new HashMap<String,Object>();
		int sourceType = DataConvert.ToInteger(map.get("sourceType"));
		int id = DataConvert.ToInteger(map.get("id"));
		String startDate = DataConvert.ToString(map.get("dateStart"));
		if(startDate==null||startDate.isEmpty()){
			startDate=null;
		}
		String endDate = DataConvert.ToString(map.get("dateEnd"));
		if(endDate==null||endDate.isEmpty()){
			endDate=null;
		}
		String key = DataConvert.ToString(map.get("key"));
		if(key==null||key.isEmpty()){
			key=null;
		}
		String userName = DataConvert.ToString(map.get("userName"));
		if(userName==null||userName.isEmpty()){
			userName=null;
		}
		Integer status =null;
		String statusStr=DataConvert.ToString(map.get("status"));
		if(!StringHelper.IsNullOrEmpty(statusStr)){
			status = DataConvert.ToInteger(map.get("status"));
		}
		long count = billService.getSourceCountForReckonItem(sourceType, id, startDate, endDate, key, userName, status);
		Page page2 = new Page(count, page, limit);
		List<Map<String,Object>> list = billService.getSourceListForReckonItem(sourceType, id, startDate, endDate, key, userName, status, page2.getStartPos(), limit);
		result.put("data", list);
		result.put("count", count);
		result.put("msg", "");
		result.put("code", 0);
		return result;
	}
}
