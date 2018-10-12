package cn.phone.home.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.druid.util.StringUtils;

import cn.api.service.ProductService;
import cn.api.service.QuestionService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.phone.home.service.PhoneQuestionService;
import cn.util.DataConvert;
import cn.util.Page;

@Controller
@RequestMapping(value="/phone/question")
public class PhoneQuestionController {
	
	@Autowired
	PhoneQuestionService pqService;
	@Autowired
	QuestionService questionService;
	@Autowired
	SettingService settingService;
	@Autowired
	HttpSession session;
	
	public Integer getUserId() {
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	
	//问答列表页面
	@RequestMapping(value="/questionFace")
	public ModelAndView questionFace(@RequestParam("teacherId") int teacherId){//专家id
		Map<String,Object> map = new HashMap<String, Object>();
		String price = pqService.selQuestionInfo(teacherId);
		if(StringUtils.isEmpty(price) || price.equals("null")){
			map.put("price", 0);
		}else{
			map.put("price", price);
		}
		map.put("teacherId", teacherId);
		map.put("footer", false);
		return new ModelAndView("/phone/question/questionList",map);
	}
	//列表数据
	@RequestMapping(value="/questionList")
	public ModelAndView questionList(@RequestParam int teacherId,@RequestParam int page,@RequestParam int pageSize){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", teacherId);
		map.put("myUserId", session.getAttribute("userId")+"");
		//查询记录count
		long count = questionService.selQuestionCount(map);
		
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list=questionService.selQuestionList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("totalCount", count);
		reqMap.put("footer", false);
		reqMap.put("teacherId", teacherId);
		return new ModelAndView("/phone/question/flowLoading",reqMap);
	}
	
	//添加提问信息
	@RequestMapping(value="/addQuestionInfo")
	@ResponseBody
	public Map addQuestionInfo(@RequestParam Map map){
		String userId = session.getAttribute("userId")+"";
		map.put("questioner", userId);
		Map<String,Object> result = questionService.addQuestions(map); 
		return result;
	}
	
	//跳转支付页面  quesOrAnswer 1提问支付  2旁听支付
	@RequestMapping(value="/questionPay")
	public ModelAndView questionPay(HttpServletRequest result,@RequestParam("payLogId") int payLogId,@RequestParam("price") String price,@RequestParam("quesOrAnswer") int quesOrAnswer){
		Integer userIds = getUserId();
		if(userIds < 1) {
			return new ModelAndView("/phone/usercenter/account/index");
		}
		Map<String,Object> map = new HashMap<String, Object>();
		String userId = session.getAttribute("userId")+"";
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
		return new ModelAndView("/phone/question/payReward",map);
	}
	
	//首页问答列表跳转
	@RequestMapping(value="/indexQuestion")
	public ModelAndView indexQuestion(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("footer", false);
		return new ModelAndView("/phone/home/question/list",map);
	}
	
	//首页问答列表数据
	@RequestMapping(value="/phoneQuestionList")
	public ModelAndView phoneQuestionList(@RequestParam int page,@RequestParam int pageSize,@RequestParam("type") int type , @RequestParam("nType") String nType){
		Map<String, Object> map = new HashMap<String, Object>();
		//查询记录count
		
		map.put("type", type);
		map.put("meetType", nType);
		map.put("myUserId", session.getAttribute("userId")+"");
		long count = questionService.selQuestionCount(map);
		
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list=questionService.selQuestionList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("totalCount", count);
		reqMap.put("footer", false);
		reqMap.put("type", type);
		return new ModelAndView("/phone/home/question/flowLoading",reqMap);
	}
	
	//手机站旁听支付跳转
	@RequestMapping(value="/phoneListenQuestion")
	@ResponseBody
	public Map phoneListenQuestion(@RequestParam("money") double money,@RequestParam("questionId") int questionId,@RequestParam("auditType") int auditType){
		Map<String,Object> result = new HashMap<String, Object>();
		Map<String,Object> map = new HashMap<String, Object>();
		String userId = DataConvert.ToString(session.getAttribute("userId"));
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
	

}
