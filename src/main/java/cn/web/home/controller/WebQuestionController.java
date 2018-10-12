package cn.web.home.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.druid.util.StringUtils;

import cn.admin.adzone.service.AdvertisementService;
import cn.api.controller.ProductController;
import cn.api.service.ProductService;
import cn.api.service.QuestionService;
import cn.api.service.SettingService;
import cn.api.service.TeacherService;
import cn.phone.home.service.PhoneQuestionService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.Tools;
import cn.util.page.PageInfo;

/**
 * pc 首页
 */
@Controller
@RequestMapping("/web/home/question")
public class WebQuestionController {
	@Autowired
	private AdvertisementService advertisementService;
	@Autowired
	private ProductService productService;
	@Autowired
	private TeacherService teacherService;
	@Autowired
	QuestionService questionService;
	@Autowired
	HttpSession session;
	@Autowired
	ProductController productController;
	@Autowired
	PhoneQuestionService pqService;
	@Autowired
	SettingService settingService;
	/**
	 * 跳转问答列表页面
	 * @return
	 */
	@RequestMapping("toInterlocution")
	public ModelAndView toInterlocution(Integer type){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", type);
		return new ModelAndView("web/interlocution/index",map);
	}
	/**
	 * 问答列表
	 * @return
	 */
	@RequestMapping("interlucationList")
	public ModelAndView interlucationList(int page, int pageSize,int type){
		Map<String, Object> map = new HashMap<String, Object>();
		//查询记录count
		map.put("type", type);
		//map.put("meetType", nType);
		map.put("myUserId", session.getAttribute("PCuserId")+"");
		long count = questionService.selQuestionCount(map);
		PageInfo pageInfo = new PageInfo(DataConvert.ToInteger(count),page,pageSize);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list=questionService.selQuestionList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("totalCount", count);
		reqMap.put("pageInfo", pageInfo);
		reqMap.put("footer", false);
		reqMap.put("type", type);
		reqMap.put("userId", session.getAttribute("PCuserId")+"");
		return new ModelAndView("web/interlocution/interlocutonList",reqMap);
	}
	
	/**
	 * PC端旁听支付跳转
	 * @param money
	 * @param questionId
	 * @param auditType
	 * @return
	 */
		@RequestMapping(value="/webListenQuestion")
		@ResponseBody
		public Map phoneListenQuestion(@RequestParam("money") double money,@RequestParam("questionId") int questionId,@RequestParam("auditType") int auditType){
			Map<String,Object> result = new HashMap<String, Object>();
			Map<String,Object> map = new HashMap<String, Object>();
			String userId = DataConvert.ToString(session.getAttribute("PCuserId"));
			if(StringUtils.isEmpty(userId)) {
				result.put("result", 0);
				result.put("msg", "请先登录!");
				return result;
			}
			map.put("questionId", questionId);
			map.put("questioner", userId);
			map.put("money", money);
			map.put("auditType", auditType);
			int payLogId = questionService.addListenQuestion(map);
			Map data = questionService.selQuestionInfo(questionId);
			if(payLogId>0 && data.size()>0){
				result.put("content", data.get("content")+"");
				result.put("money", money);
				result.put("payLogId", payLogId);
				result.put("result", 1);
			}else{
				result.put("result", 0);
			}
			return result;
		} 
		/**
		 * 跳转支付页面  quesOrAnswer 1提问支付  2旁听支付
		 * @param result
		 * @param payLogId
		 * @param price
		 * @param quesOrAnswer
		 * @return
		 */
		@RequestMapping(value="/questionPay")
		public ModelAndView questionPay(HttpServletRequest result,@RequestParam("payLogId") int payLogId,@RequestParam("price") String price,@RequestParam("quesOrAnswer") int quesOrAnswer){
			Integer userIds = getUserId();
			if(userIds < 1) {
				return new ModelAndView("/web/home/index");
			}
			Map<String,Object> map = new HashMap<String, Object>();
			String userId = session.getAttribute("PCuserId")+"";
			Map info = pqService.selTeacherName(payLogId,userId,quesOrAnswer);//查询教师名称和用余额
			map.put("platformType", 3);
			String openId=DataConvert.ToString(session.getAttribute("openId"));
			if(!StringUtils.isEmpty(openId)){
				map.put("platformType", 5);
			}
			List payType = settingService.getPayMethods(map);//查询支付方式
			map.put("payType", payType);
			map.put("footer", false);
			map.put("price", DataConvert.ToDouble(price));
			map.put("payLogId", payLogId);
			map.put("teacherName", info.get("teacherName")+"");
			map.put("balance", DataConvert.ToDouble(info.get("balance")));
			map.put("quesOrAnswer", quesOrAnswer);
			if(quesOrAnswer==2){
				String coontent = result.getParameter("content");
				map.put("content", coontent);
			}
			//比较大小
			boolean pricePVbalan = true;
			Double pricedisplay = DataConvert.ToDouble(price);
			Double balancedisplay = DataConvert.ToDouble(info.get("balance"));
			if(pricedisplay>balancedisplay) {
				pricePVbalan = false;
			}
			map.put("pricePVbalan", pricePVbalan);
			return new ModelAndView("/web/interlocution/payCenter",map);
		}
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	
	
}
