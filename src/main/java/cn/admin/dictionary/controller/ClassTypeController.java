package cn.admin.dictionary.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import net.sf.json.JSONArray;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.dictionary.service.ClassTypeService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.ExcelUntil;
import cn.util.Page;

/**
 * 课程类别
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/admin/classtype")
public class ClassTypeController {

	
	@Autowired
	ClassTypeService classTypeService;
	@Autowired
	HttpSession session;
	
	
	/**
	 * 列表查询
	 * @return
	 */
	@RequestMapping(value="list")
	@Authorize(setting="课程类别-课程类别列表,商品类别-类别列表,文章分类-分类列表",type=AuthorizeType.ONE)
	public ModelAndView list(HttpServletRequest request){
		Map<String, Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");
		map.put("type", type);
		return new ModelAndView("/admin/dictionary/classtype/list",map);
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		//类型
		String type = request.getParameter("type");
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		String userName = request.getParameter("userName");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("type", type);
		reqMap.put("name", name);
		reqMap.put("status", status);
		reqMap.put("userName", userName);
		
		long count = classTypeService.selectClasstypeCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = classTypeService.selectClasstypeList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 状态更改(禁用、启用)
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/updateStatus")
	@ResponseBody
	@Authorize(setting="课程类别-禁用启用,商品类别-禁用启用,文章分类-禁用启用",type=AuthorizeType.ONE)
	public Map<String, Object> updateStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//禁用启用
		int row = classTypeService.updateStatus(map);
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
	 * 批量禁用
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/batchUpStatus")
	@ResponseBody
	@Authorize(type=AuthorizeType.ONE,setting="课程类别-批量启用禁用,商品类别-批量启用禁用,文章分类-批量启用禁用")
	public Map<String, Object> batchUpStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		int row = classTypeService.batchUpStatus(map);
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
	@Authorize(type=AuthorizeType.ONE,setting="课程类别-删除课程类别,商品类别-删除类别,文章分类-删除类别")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = classTypeService.delete(map);
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
	 * 批量删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deleteids")
	@ResponseBody
	@Authorize(type=AuthorizeType.ONE,setting="课程类别-批量删除,商品类别-批量删除,文章分类-批量删除")
	public Map<String, Object> deleteids(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		int row = classTypeService.deleteAll(map);
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
	 * 新增编辑弹窗
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/toaddOrUp")
	public ModelAndView toaddOrUp(@RequestParam Map map){
		if(!StringUtils.isEmpty(map.get("id"))){
			//根据id查询详情
			Map reqMap = classTypeService.findById(map);
			map.put("reqMap", reqMap);
		}
		//根据分类查询不同的上级列表
		List list = classTypeService.selectTypelist(map);
		JSONArray jsonList = JSONArray.fromObject(list);
		map.put("list", jsonList);
		return new ModelAndView("/admin/dictionary/classtype/addorUp",map);
	}
	/**
	 * 新增、编辑
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/addOrUp")
	@ResponseBody
	@Authorize(type=AuthorizeType.ONE,setting="课程类别-新增类别,课程类别-编辑类别,商品类别-新增类别,文章分类-新增类别,商品类别-编辑类别,文章分类-编辑类别")
	public Map addOrUp(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if("on".equals(map.get("Isdisplay")+"")){
			map.put("Isdisplay", 1);
		}else{
			map.put("Isdisplay", 0);
		}
		int row = 0;
		if(!StringUtils.isEmpty(map.get("id"))){
			//编辑
			row = classTypeService.updateMsg(map);
		}else{
			map.put("userId", session.getAttribute("userId")+"");
			//新增
			row = classTypeService.addMsg(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "保存失败!");
		}
		return reqMap;
	}
	/**
	 * 批量倒出
	 * @param request
	 * @param response
	 * @param map
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="/download")
	@Authorize(type=AuthorizeType.ONE,setting="课程类别-批量导出,商品类别-批量导出,文章分类-批量导出")
	public void batchPlex(HttpServletRequest request,HttpServletResponse response,@RequestParam Map map) throws UnsupportedEncodingException {
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		String excelName = "";
		if("1".equals(map.get("type")+"")){
			excelName = "课程";
		}else if("2".equals(map.get("type")+"")){
			excelName = "商品";
		}else{
			excelName = "文章";
		}
		//查询导出数据
		List list = classTypeService.selectDownLoad(map);
		String[] excelHeader={"编号","分类名称","上级分类","层级","首页展示","状态","创建者","创建时间"};
		String[] mapKey={"id","name","parentName","hierarchy","Isdisplay","status","realname","inputDate"};
	    ExcelUntil.excelToFile(list,excelHeader,mapKey,response,excelName+"分类列表");
	}
	
}
