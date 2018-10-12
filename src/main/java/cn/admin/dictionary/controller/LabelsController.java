package cn.admin.dictionary.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.dictionary.service.LabelsService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.ExcelUntil;
import cn.util.Page;
import cn.util.Tools;

/**
 * 标签管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/admin/labels")
public class LabelsController {
	
	
	@Autowired
	LabelsService labelsService;
	
	
	/**
	 * 标签列表
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="标签管理-标签列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/dictionary/label/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		String name = request.getParameter("name");
		String status = request.getParameter("status");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("name", name);
		reqMap.put("status", status);
		
		long count = labelsService.selLabelsCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = labelsService.selectLabelsList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="标签管理-删除标签")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//删除
		int row = labelsService.deleteLabel(map);
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
	@Authorize(setting="标签管理-批量删除标签")
	public Map<String, Object> deleteids(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		int row = labelsService.deleteLabelByids(map);
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
	 * 启用禁用标签
	 * @param map
	 * @return
	 */
	@RequestMapping(value="updateStatus")
	@ResponseBody
	@Authorize(setting="标签管理-启用标签,标签管理-禁用标签",type=AuthorizeType.ONE)
	public Map<String, Object> updateStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = labelsService.updateStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败!");
		}
		return reqMap;
	}
	/**
	 * 批量启用禁用
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/batchUpStatus")
	@ResponseBody
	@Authorize(setting="标签管理-批量启用标签,标签管理-批量禁用标签",type=AuthorizeType.ONE)
	public Map<String, Object> batchUpStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		int row = labelsService.batchUpStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败!");
		}
		return reqMap;
	}
	/**
	 * 添加/编辑弹窗
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/toaddOrUp")
	public ModelAndView toaddOrUp(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(map.get("id"))){
			//查询标签详情
			reqMap = labelsService.findById(map);
		}
		return new ModelAndView("/admin/dictionary/label/addorUp",reqMap);
	}
	/**
	 * 添加编辑标签
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/addOrUp")
	@ResponseBody
	@Authorize(setting="标签管理-添加标签,标签管理-编辑标签",type=AuthorizeType.ONE)
	public Map<String, Object> addOrUp(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = 0;
		if(!StringUtils.isEmpty(map.get("id"))){
			//编辑
			row = labelsService.updateLabel(map);
		}else{
			//新增
			row = labelsService.addLabel(map);
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
	 * 批量导出
	 * @param request
	 * @param response
	 * @param map
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="/download")
	@Authorize(setting="标签管理-批量导出标签")
	public void batchPlex(HttpServletRequest request,HttpServletResponse response,@RequestParam Map map) throws UnsupportedEncodingException {
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		//查询导出数据
		List list = labelsService.selectDownLoad(map);
		String[] excelHeader={"标签编号","标签名称","适用类型","使用次数","状态"};
		String[] mapKey={"id","name","classification","number","status"};
	    ExcelUntil.excelToFile(list,excelHeader,mapKey,response,"标签列表");
	}
}
