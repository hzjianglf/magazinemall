package cn.api.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpSession;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import cn.Pay.service.payService;
import cn.api.service.PathService;
import cn.api.service.QuestionService;
import cn.api.service.SettingService;
import cn.phone.home.service.PhoneQuestionService;

/**
 * @author LiTonghui
 * @2018年4月19日上午8:51:45 
 * @Title: 问答列表的接口
 */
@Api(tags={"问答列表的接口"})
@RestController
//@Sign
@RequestMapping("/api/question")
public class QuestionController {
	
	@Autowired
	HttpSession session;
	@Autowired
	QuestionService questionService;
	@Autowired
	payService payservice;
	@Autowired
	PhoneQuestionService pqService;
	@Autowired
	SettingService settingService;
	@Autowired
	PathService pathService;
	
	/**
	 * 【APP接口】添加提问
	 * @Author LiTonghui
	 * @param 
	 * lecturer	提问讲师id
	 * ondemandId 课程id
	 * type 1--课程  2--专家
	 * money ：如向专家提问需要交纳费用
	 * 
	 * @return
	 * result 0提问失败  1提问成功
	 * msg ：提问失败/提问成功
	 * questionId 提问成功之后的问题id
	 * 
	 */
	@RequestMapping(value="/addQuestions")
	@ApiOperation(value="添加提问",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="content",value="提问内容",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="被提问类型",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="提问者id(用户id)",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="classId",value="课程id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="teacherId",value="教师id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="isAnonymity",value="是否匿名 0-否1-是",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="money",value="提问费用",dataType="double",required=false,paramType="query")
	})
	public Map<String, Object> addQuestions(String content,Integer type,Integer userId,Integer classId,Integer teacherId,Integer isAnonymity,Double money){
		
		Map<String,Object> search = new HashMap<String, Object>();
		
		search.put("content", content);
		search.put("questioner", userId);
		search.put("classId", classId);//课程id
		search.put("teacherId", teacherId);//教师id
		search.put("type", type);
		search.put("money", money);
		search.put("isAnonymity", isAnonymity);
		
		Map<String,Object> result = questionService.addQuestions(search);
		String payLogId = result.get("payLogId")+"";
		
		return result;
	}
	
	/**
	 * @Author LiTonghui
	 * @Title 提问支付页面
	 * 
	 * @param  payLogId 支付记录id   price 价格
	 * 
	 */
	@RequestMapping(value="/questionsPayFace")
	@ApiOperation(value="提问支付页面",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="payLogId",value="支付记录id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="price",value="价格",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="quesOrAnswer",value="支付类型（1提问支付 2旁听支付）",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={teacherName='课程/专家名称',price='提问价格',balance='账户余额',payType='支付方式',payLogId='支付记录id"+ "'}}")
	})
	public Map questionsPayFace(Integer payLogId,Integer price,Integer quesOrAnswer){
		Map<String,Object> map = new HashMap<String, Object>();
		String userId = session.getAttribute("userId")+"";
		
		Map info = pqService.selTeacherName(payLogId,userId,quesOrAnswer);//查询教师名称和用余额
		map.put("platformType", 3);
		List payType = settingService.getPayMethods(map);//查询支付方式
		map.put("payType", payType);
		map.put("price", price);
		map.put("payLogId", payLogId);
		map.put("teacherName", info.get("teacherName")+"");
		map.put("balance", info.get("balance")+"");
		
		Map<String,Object> data = new HashMap<String,Object>();
		if(map!=null){
			data.put("data", map);
			data.put("result", 1);
			data.put("msg", "查询成功！");
		}else{
			data.put("result", 0);
			data.put("msg", "查询失败！");
		}
		return data;
	}
	/**
	 * @Author LiTonghui
	 * @Title 提问确认支付接口
	 * 
	 * @param  
	 * payLogId 支付记录id
	 * payType 支付类型
	 * 
	 */
	@RequestMapping(value="/questionsSurePay")
	@ApiOperation(value="提问确认支付",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="payLogId",value="支付记录id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="payMethodId",value="支付类型",dataType="int",required=false,paramType="query")
	})
	public Map questionsSurePay(Integer payLogId,Integer payMethodId){
		Map result = payservice.orderPay(payLogId, payMethodId);
		return result;
	}
	
	/**
	 * @title 问答列表
	 * 
	 */
	@RequestMapping(value="/questionList")
	@ApiOperation(value="问答列表",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="teacherId",value="专家id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="type",value="问答0--专家答疑1",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="meetType",value="答疑分类(只有查询专家答疑列表时才需要)",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={nickName='提问者姓名',time='提问时间',content='提问内容',auditCount='旁听次数'"
				+ "answertype='答案类型   1音频 2文字',isBugAudit='是否购买(大于0，以购买旁听过，反之则没有旁听过)',musicurl='音频地址',count='问答总数'}}")
	})
	public Map questionList(Integer userId,Integer teacherId,Integer type,Integer meetType,Integer page,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		
		boolean flag = false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			
			flag=true;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		map.put("myUserId", userId);//用户id
		map.put("userId", teacherId);//教师id
		map.put("type", type);
		map.put("meetType", meetType);
		
		List<Map<String,Object>> list=questionService.selQuestionList(map);
		
		pathService.getAbsolutePath(list, "userUrl","musicurl");
		if(type==1) {
			for (Map map2 : list) {
				map2.remove("price");
				map2.put("price", map.get("money")+"");
			}
		}
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
        long count = questionService.selQuestionCount(map);
        if(flag){
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalCount", count);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
        reqMap.put("count", count);
		reqMap.put("data", list);
		return reqMap;
		
	}
	
	/**
	 * 获取专家答疑类型接口
	 */
	@RequestMapping(value="/getMeetTypeList")
	@ApiOperation(value="获取专家答疑类型接口",httpMethod="POST")
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={[name='类型名称']}}")
	})
	public Map<String, Object> getMeetTypeList(){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "获取数据失败!");
			}
		};
		
		try {
			List list = questionService.selectMeetType();
			reqMap.put("data", list);
			reqMap.put("result", 1);
			reqMap.put("msg", "获取成功!");
		} catch (Exception e) {
			reqMap.put("msg", "请求失败!"+e.getMessage());
		}
		
		return reqMap;
	}

	/**
	 * @author LiTonghui
	 * @title 旁听接口
	 * 
	 */
	@RequestMapping(value="/listenQuestion")
	@ApiOperation(value="旁听支付接口",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="questionId",value="旁听问题的id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="userId",value="支付者id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="money",value="旁听费用（先写死）",dataType="double",required=true,paramType="query"),
		@ApiImplicitParam(name="auditType",value="旁听类型（1问答 2专家答疑）",dataType="double",required=true,paramType="query")
		
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,msg='添加支付记录成功/失败！',data={payLogId='支付记录id',content='问题内容',money='旁听费用'}}")
	})
	public Map listenQuestion(Integer questionId,Integer userId,double money,Integer auditType){
		Map<String,Object> result = new HashMap<String, Object>();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("questionId", questionId);
		map.put("questioner", userId);
		map.put("money", money);
		map.put("auditType", auditType);
		int payLogId = questionService.addListenQuestion(map);
		Map data = questionService.selQuestionInfo(questionId);
		data.put("payLogId", payLogId);
		data.put("money", money);
		if(payLogId>0 && data.size()>0){
			result.put("data", data);
			result.put("result", 1);
			result.put("msg", "添加支付记录成功！");
		}else{
			result.put("result", 0);
			result.put("msg", "添加支付记录失败！");
		}
		return result;
	} 
	
	
	/**
	 * 回答问题接口
	 */
	@RequestMapping(value="/answerQuestion")
	@ApiOperation(value="回答问题接口",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="id",value="问题的id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="answer",value="答案(答案类型为2时传入)",dataType="String",required=false,paramType="query"),
		@ApiImplicitParam(name="answertype",value="答案类型   1音频 2文字",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="musicurl",value="音频文件上传地址(答案类型为1时传入)",dataType="String",required=false,paramType="query"),
		@ApiImplicitParam(name="userId",value="回答者id",dataType="int",required=true,paramType="query")
	})
	public Map<String, Object> answerQuestion(Integer id,String answer,Integer answertype,String musicurl,Integer userId){
		Map<String, Object> reqMap = new HashMap<String,Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		
		if(id==null || answertype==null || userId==null) {
			return reqMap;
		}
		
		try {
			
			Map<String, Object> map = new HashMap<String,Object>();
			map.put("id", id);
			map.put("answer", answer);
			map.put("answertype", answertype);
			map.put("musicurl", musicurl);
			map.put("answerState", 2);
			map.put("userId", userId);
			//保存回答内容
			int row = questionService.answerQuestion(map);
			if(row > 0) {
				reqMap.put("result", 1);
				reqMap.put("msg", "回答成功!");
			}
			
		} catch (Exception e) {
			reqMap.put("msg", "请求失败,"+e.getMessage());
		}
		
		return reqMap;
	}
	
}
