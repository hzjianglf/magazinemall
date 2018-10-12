package cn.admin.dictionary.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.dictionary.service.LogisticsService;
import cn.core.Authorize;
import cn.util.Page;

@Controller
@RequestMapping("/admin/logistics")
public class LogisticsController {
	@Autowired
	private LogisticsService logisticsService;
	@Autowired
	private HttpSession session;
	
	@RequestMapping(value="/logisticsIndex")
	public ModelAndView logisticsIndex(){
		return new ModelAndView("/admin/dictionary/logistics/list"); 
	}
		
	@RequestMapping("/list")
	public  ModelAndView turnIndex(){
		return new ModelAndView("/admin/dictionary/logistics/list");
	}
	@RequestMapping("listData")
	@ResponseBody
	public Map<String,Object> listData(Integer  page, Integer limit){
		
		
		Map<String,Object> result = new HashMap();
		long totalCount = logisticsService.selCount();
		Page pages = new Page(totalCount, page, limit);
		Map<String,Object> paramap = new HashMap();
		paramap.put("start", pages.getStartPos());
		paramap.put("pageSize", limit);
		List list = logisticsService.selectContent(paramap);
		result.put("data", list);
		result.put("code", 0);
		result.put("count", totalCount);
		return result;
		
	}
	@RequestMapping("turnAdd")
	public ModelAndView turnAdd(HttpServletRequest request){
		String id = request.getParameter("id");
		if(StringUtils.isNullOrEmpty(id)){
			return new ModelAndView("/admin/dictionary/logistics/addorUp");
		}
		Map reqMap = logisticsService.selById(id);
		return new ModelAndView("/admin/dictionary/logistics/addorUp",reqMap);

	}
	@RequestMapping("addOrUp")
	@ResponseBody
	public Map<String,Object> addOrUp(@RequestParam Map paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String Id = request.getParameter("Id");
		String userId = session.getAttribute("userId")+"";
		paramap.put("userId", userId);
		if(StringUtils.isNullOrEmpty(Id)){
			int num = logisticsService.add(paramap);
			if(num<0){
				map.put("msg", "添加失败");
				map.put("success", false);
				return map;
			}
		}else{
			int num = logisticsService.edit(paramap);
			if(num<0){
				map.put("msg", "编辑失败");
				map.put("success", false);
				return map;
			}
		}
		map.put("msg", "操作成功");
		map.put("success", true);
		return map;
	}
	
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="物流地址-删除")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = logisticsService.delete(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
}
