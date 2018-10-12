package cn.admin.interlocution.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.interlocution.service.MeetProfessorService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.Page;

/**
 * 专家答疑
 * @author 
 *
 */
@Controller
@RequestMapping(value="/admin/meetprofessor")
public class MeetProfessorController {

	@Autowired
	MeetProfessorService meetProfessorService;
	
	
	/**
	 * 专家答疑列表
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="百科-百科列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/meetprofessor/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>();
		long count = meetProfessorService.selectCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = meetProfessorService.selectList(reqMap);
		
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 添加修弹窗
	 * @return
	 */
	@RequestMapping(value="/toaddOrUp")
	public ModelAndView toaddOrUp(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String id = request.getParameter("id");
		if(!StringUtils.isEmpty(id) && !"null".equals(id)){
			reqMap = meetProfessorService.findById(id);
		}
		//查询所有教师
		List teacher=meetProfessorService.selectTeacherAll();
		reqMap.put("teacher", teacher);
		//查询答疑分类
		List label=meetProfessorService.selectlabels();
		reqMap.put("label", label);
		return new ModelAndView("/admin/meetprofessor/addorUp",reqMap);
	}
	/**
	 * 保存/修改
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/addOrUp")
	@ResponseBody
	@Authorize(setting="百科-新增百科,百科-编辑百科",type=AuthorizeType.ONE)
	public Map<String, Object> addOrUp(@RequestParam Map map){
		Map<String, Object> reqMap = meetProfessorService.addOrUp(map);
		return reqMap;
	}
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="百科-删除百科")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = meetProfessorService.delteMeet(map);
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
