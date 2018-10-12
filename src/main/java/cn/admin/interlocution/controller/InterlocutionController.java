package cn.admin.interlocution.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.interlocution.service.InterlocutionService;
import cn.api.service.QuestionService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.Page;
import cn.util.Tools;

@Controller
@RequestMapping(value="/admin/interlocution")
public class InterlocutionController {

	@Autowired
	InterlocutionService interlocutionService;
	@Autowired
	QuestionService questionService;
	@Autowired
	private HttpSession session;
	@Autowired
	SqlSession sqlSession;
	
	@RequestMapping(value="/list")
	@Authorize(setting="问答-问答列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/interlocution/list");
	}
	
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		String questionState = request.getParameter("questionState");
		String answerState = request.getParameter("answerState");
		String content = request.getParameter("content");
		String teacher = request.getParameter("teacher");
		String questioner = request.getParameter("questioner");
		String registrationDate = request.getParameter("registrationDate");
		
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(StringUtils.isEmpty(questionState) || "null".equals(questionState)){
			reqMap.put("questionState", 0);
		}else{
			reqMap.put("questionState", questionState);
		}
		reqMap.put("answerState", answerState);
		reqMap.put("content", content);
		reqMap.put("teacher", teacher);
		reqMap.put("questioner", questioner);
		if(Tools.isNotEmpty(registrationDate)){
			String[] split = registrationDate.split(" - ");
			String startDate = split[0];
			String endDate = split[1];
			reqMap.put("startDate", startDate);
			reqMap.put("endDate", endDate);
		}
		long count = interlocutionService.selInterlocutionCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = interlocutionService.selInterlocutionList(reqMap);
		
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 审核
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/toExamine")
	@ResponseBody
	@Authorize(setting="问答-问答审核")
	public Map<String, Object> toExamine(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = interlocutionService.updateStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else if(row==-1) {
			reqMap.put("success", false);
			reqMap.put("msg", "该记录已退款！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
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
	@Authorize(setting="问答-取消审核")
	public Map<String, Object> cancels(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = interlocutionService.cancelStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else if(row == -1) {
			reqMap.put("success", false);
			reqMap.put("msg", "该记录已退款！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 删除问答
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="问答-删除问答")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = interlocutionService.deleteInterlocution(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败！");
		}
		return reqMap;
	}
	/**
	 * 通过后台去回答提问
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/toQuestionBySystem")
	public ModelAndView toQuestionBySystem(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String id = request.getParameter("id");
		if(id !=null && !"".equals(id)){
			reqMap.put("id", id);
			reqMap = questionService.findQuestionDetails(reqMap);
		}
		return new ModelAndView("/admin/interlocution/answerQustion",reqMap);
	}
	/**
	 * 回答弹框点击确定保存
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/answerContentToSave")
	@ResponseBody
	public Map<String, Object> answerContentToSave(@RequestParam Map map){
		String userId = (String) session.getAttribute("userId");
		Map<String, Object> reqMap = new HashMap<String,Object>();
		map.put("userId", userId);
		map.put("answertype", 2);
		map.put("answerState", 2);
		int row = questionService.answerQuestion(map);
		if(row > 0) {
			
			reqMap.put("success", true);
			reqMap.put("msg", "回答成功!");
		}else if(row == -1) {
			reqMap.put("success", false);
			reqMap.put("msg", "该记录已退款!");
		}
		return reqMap;
	}
	/**
	 * 查询是否退款
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/selIsRefund")
	@ResponseBody
	public Map<String, Object> selIsRefund(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String,Object>();
		reqMap = sqlSession.selectOne("interlocutionDao.selInterlocutionSingleRecord", map.get("id").toString());
		return reqMap;
	}
	
}
