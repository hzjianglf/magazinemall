package cn.admin.dictionary.controller;


import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpRequest;
import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.dictionary.service.ExpressService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.ExcelUntil;
import cn.util.Page;
import cn.util.StringHelper;
@Controller
@RequestMapping("/admin/express")
public class ExpressCompanyController{
	
	@Autowired
	private ExpressService expressService;
	
	@RequestMapping("/index")
	public ModelAndView returnExpress(){
		
		return new ModelAndView("/admin/dictionary/express/index");
	}
	@RequestMapping("listData")
	@ResponseBody
	public Map<String,Object> seachList(HttpServletRequest request,String num,
			String name,String userName,Integer status,Integer  page, Integer limit){
		Map<String,Object> paramap = new HashMap<String, Object>();
		paramap.put("num", num);
		paramap.put("name", name);
		paramap.put("userName", userName);
		paramap.put("status", status);
		long totalCount = expressService.selectCount(paramap);
		Page pages = new Page(totalCount, page, limit);
		paramap.put("start", pages.getStartPos());
		paramap.put("pageSize", limit);
		List list = expressService.selectContent(paramap);
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("data", list);
		result.put("code", 0);
		result.put("count", totalCount);
		return result;
	}
	@RequestMapping("turnAdd")
	public ModelAndView turnAdd(HttpServletRequest request){
		String id = request.getParameter("id");
		if(StringUtils.isNullOrEmpty(id)){
			return new ModelAndView("/admin/dictionary/express/addorUp");
		}
		Map reqMap = expressService.selById(id);
		return new ModelAndView("/admin/dictionary/express/addorUp",reqMap);

	}
	@RequestMapping("addOrUp")
	@ResponseBody
	public Map<String,Object> addOrUp(@RequestParam Map paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String id = request.getParameter("id");
		if(StringUtils.isNullOrEmpty(request.getParameter("id"))){
			int num = expressService.add(paramap);
			if(num<0){
				map.put("msg", "添加失败");
				map.put("success", false);
				return map;
			}
		}else{
			int num = expressService.edit(paramap);
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
	 * 批量删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deleteids")
	@ResponseBody
	public Map<String, Object> deleteids(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		int row = expressService.deleteAll(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
	/**
	 * 状态更改(禁用、启用)
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/updateStatus")
	@ResponseBody
	public Map<String, Object> updateStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//禁用启用
		int row = expressService.updateStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "更改成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "更改失败!");
		}
		return reqMap;
	}
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="快递-删除")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = expressService.delete(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
	/**
	 * 批量启用禁用
	 * @return
	 */
	@RequestMapping(value="/batchUpStatus")
	@Authorize(setting="快递-批量启用禁用")
	@ResponseBody
	public Map<String, Object> batchUpStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ids = map.get("ids")+"";
		List id = StringHelper.ToIntegerList(ids);
		map.put("id", id);
		int row = expressService.batchUpStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "更改成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "更改失败!");
		}
		return reqMap;
	}
	/**
	 * 批量导出
	 */
	@RequestMapping(value="/download")
	public void batchPlex(HttpServletRequest request,HttpServletResponse response,@RequestParam Map map) throws UnsupportedEncodingException {
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		List list = expressService.selectContent(map);
		String[] excelHeader={"编号","快递公司名称","联系人","联系电话","地址","备注","状态"};
		String[] mapKey={"Id","name","userName","telenumber","address","remark","statu"};
	    ExcelUntil.excelToFile(list,excelHeader,mapKey,response,"快递公司列表");
	}
}
