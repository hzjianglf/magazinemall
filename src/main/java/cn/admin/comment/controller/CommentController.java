package cn.admin.comment.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.comment.service.CommentService;
import cn.admin.system.service.DictionaryService;
import cn.core.Authorize;
import cn.util.Page;
import cn.util.Tools;
/**
 * 评论管理
 * @author lwy
 *
 */
@Controller
@RequestMapping(value="/admin/comment")
public class CommentController {
	@Autowired
	CommentService commentService;
	@Autowired
	HttpSession session;
	@Autowired
	DictionaryService dictService;
	
	
	
	
	@RequestMapping(value="/list")
	@Authorize(setting="评论-评论列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/comment/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		String status = request.getParameter("status");
		String content = request.getParameter("content");
		String poster = request.getParameter("poster");
		String dateTime = request.getParameter("dateTime");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(StringUtils.isEmpty(status) || "null".equals(status)){
			reqMap.put("status", "0");
		}else{
			reqMap.put("status", status);
		}
		reqMap.put("content", content);
		reqMap.put("poster", poster);
		if(Tools.isNotEmpty(dateTime)){
			String[] split = dateTime.split(" - ");
			String startDate = split[0];
			String endDate = split[1];
			reqMap.put("startDate", startDate);
			reqMap.put("endDate", endDate);
		}
		long count = commentService.selCommentCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = commentService.selOndemandList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	
	/**
	 * 修改状态
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/upStatus")
	@ResponseBody
	@Authorize(setting="评论-评论列表")
	public Map upStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = commentService.updateStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 删除评论
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="评论-删除评论")
	public Map Deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = commentService.deleteComment(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 批量删除评论
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deleteids")
	@ResponseBody
	@Authorize(setting="评论-批量删除评论")
	public Map<String, Object> Deleteids(HttpServletRequest request){
		Map<String, Object> map = new HashMap<String, Object>();
		String ids = request.getParameter("ids");
		String[] id = ids.split(",");
		map.put("id", id);
		long row = commentService.deleteids(map);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败");
		}
		return map;
	}
	/**
	 * 审核
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/toExamine")
	@ResponseBody
	@Authorize(setting="评论-评论审核")
	public Map<String, Object> toExamine(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = commentService.toExamine(map);
		if (row > 0) {
			reqMap.put("success", true);
			reqMap.put("msg", "审核成功");
		} else {
			reqMap.put("success", false);
			reqMap.put("msg", "审核失败");
		}
		return reqMap;
	}
	/**
	 * 取消审核
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/cancels")
	@ResponseBody
	@Authorize(setting="评论-取消审核")
	public Map<String, Object> cancels(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = commentService.cancelExamine(map);
		if (row > 0) {
			reqMap.put("success", true);
			reqMap.put("msg", "取消成功");
		} else {
			reqMap.put("success", false);
			reqMap.put("msg", "取消失败");
		}
		return reqMap;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * 批量修改启用或禁用
	 */
	@RequestMapping(value = "/modifyStatus")
	@ResponseBody
	@Authorize(setting="评论-评论列表")
	public Map<String, Object> modifyStatus(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String ids = request.getParameter("ids");
		String status = request.getParameter("status");
		String[] id = ids.split(",");
		map.put("id", id);
		map.put("status", status);
		long row = commentService.modifyStatus(map);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败");
		}
		return map;
	}
}
