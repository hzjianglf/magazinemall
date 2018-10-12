package cn.admin.finance.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.finance.service.CentsSetUpService;
import cn.core.Authorize;
import cn.util.Page;

/**
 */
@Controller
@RequestMapping(value="/admin/finance/cents")
public class CentsSetUpController {
	
	@Autowired
	CentsSetUpService centsSetUpService;
	
	/**
	 * @title 分账设置列表页面
	 */
	@RequestMapping(value="/centsSetUpList")
	@Authorize(setting="财务-分账设置")
	public ModelAndView centsSetUpList(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}
	
	/**
	 * @title 分账设置列表数据
	 */
	@RequestMapping(value="/centsSetUpListData")
	@ResponseBody
	public Map centsSetUpListData(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		long totalCount = centsSetUpService.selTotalCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = centsSetUpService.getcentsSetUpList(search);//商品、直播、点播
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	
	/**
	 * @title 设置分成页面
	 */
	@RequestMapping(value="/setUpRate")
	public ModelAndView setUpRate(@RequestParam("userId") int userId){
		//查询专家的信息
		Map data = centsSetUpService.getuserinfoById(userId);
		data.put("userId", userId);
		//查询专家的所有课程
		List<Map> list = centsSetUpService.selTeachersClass(userId);
		data.put("list", list);
		return new ModelAndView("/admin/finance/centsSetUp/setup",data);
		
	}
	
	//保存分账设置信息
	@RequestMapping(value="/saveSetUpInfo")
	@ResponseBody
	public Map saveSetUpInfo(@RequestParam Map<String,Object> map){
		Map<String,Object> result = new HashMap<String, Object>();
		int info = centsSetUpService.selInfoIsHave(map.get("userId")+"");
		if(info>0){
			map.put("isHave", 1);//存在
		}else{
			map.put("isHave", 0);//不存在
		}
		int row = centsSetUpService.updSetUpInfo(map);
		if(row>0){
			result.put("result", true);
			result.put("msg", "保存成功！");
		}else{
			result.put("result", false);
			result.put("msg", "保存失败！");
		}
		return result;
		
	}
	//修改分成设置的状态
	@RequestMapping(value="/setUpStatus")
	@ResponseBody
	public Map setUpStatus(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = centsSetUpService.setUpStatus(map);
		if(row>0){
			result.put("result", true);
			result.put("msg", "操作成功！");
		}else{
			result.put("result", false);
			result.put("msg", "操作失败，暂未设置该专家分成信息！");
		}
		return result;
	}
	//批量导出
//	@RequestMapping(value="/batchExport")
//	public void batchExport(){
//		
//	}
	
	
// -------------------------------------------------------------------------  	
	
	/**
	 * @title 分账计算列表页面
	 */
	/*@RequestMapping(value="/centsCalculation")
	@Authorize(setting="财务-分账计算")
	public ModelAndView centsCalculation(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}*/
	
	
	/**
	 * @title 分账审核列表页面
	 */
	/*@RequestMapping(value="/centsExamine")
	@Authorize(setting="财务-分账审核")
	public ModelAndView centsExamine(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}*/
	
	
	/**
	 * @title 代付列表页面
	 */
	/*@RequestMapping(value="/substituteList")
	@Authorize(setting="财务-代付列表")
	public ModelAndView substituteList(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}*/
	
}
