package cn.web.home.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import cn.admin.adzone.service.AdvertisementService;
import cn.api.controller.ProductController;
import cn.api.service.AccountService;
import cn.api.service.ProductService;
import cn.api.service.QuestionService;
import cn.api.service.SettingService;
import cn.api.service.TeacherService;
import cn.core.UserValidate;
import cn.phone.home.service.PhoneQuestionService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.Tools;
import cn.util.page.PageInfo;

/**
 * pc 首页
 */
@Controller
@RequestMapping("/web/home/expert")
public class WebExpertController {
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
	@Autowired
	AccountService accountService;
	/**
	 * 跳转专家列表页面
	 * @return
	 */
	@RequestMapping("toExpert")
	public ModelAndView toExpert(){
		Map<String,Object> map = new HashMap<String,Object>(){
			{
				put("SEO2", "专家-");
			}
		};
		return new ModelAndView("web/expert/index",map);
	}
	/**
	 * 专家列表
	 * @return
	 */
	@RequestMapping("expertList")
	public ModelAndView expertList(int page, int pageSize,int IsRecommend){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("IsRecommend", IsRecommend);
		long count = teacherService.selectExpertCont(map);
		PageInfo pageInfo = new PageInfo(DataConvert.ToInteger(count),page,pageSize);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		
		List list = teacherService.selExpertList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("pageInfo", pageInfo);
		reqMap.put("IsRecommend", IsRecommend);
		return new ModelAndView("/web/expert/expertList",reqMap);
	}
	
	/**
	 * 打赏支付页面
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/payReward")
	public ModelAndView payReward(@RequestParam Map<String, Object> map){
		int userId=getUserId();
		if(userId==0) {
			return null;
		}
		Map<String, Object> maps = new HashMap<String, Object>();
		maps.put("teacherId", map.get("teacherId")+"");
		maps.put("money", Double.parseDouble(map.get("money")+""));
		maps.put("rewardMsg", map.get("rewardMsg")+"");
		//教师名称
		Map reqMap = accountService.selectUserMsg(map.get("teacherId")+"");
		Map data = (Map) reqMap.get("data");
		String userName = DataConvert.ToString(data.get("nickName"));
		
		maps.put("realname", userName);
		//查询账户余额
		Map balance = accountService.selectBalance(session.getAttribute("PCuserId")+"");
		maps.put("balance", Double.parseDouble(balance.get("balance")+""));
		//比较大小
		boolean pricePVbalan = true;
		Double pricedisplay = DataConvert.ToDouble(map.get("money")+"");
		Double balancedisplay = DataConvert.ToDouble(balance.get("balance"));
		if(pricedisplay>balancedisplay) {
			pricePVbalan = false;
		}
		//获取支付方式列表
		map.put("platformType", 2);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> list = settingService.getPayMethods(map);
		maps.put("paylist", list);
		maps.put("pricePVbalan", pricePVbalan);
		maps.put("footer", false);
		return new ModelAndView("/web/expert/rewardzhifu",maps);
	}
	
	/**
	 * 打赏，创建打赏记录
	 * @param contentId 打赏的教师id
	 * @param money	打赏金额
	 * @param remark 备注
	 * @return
	 */
	@RequestMapping(value="/RewardTeacher")
	@ResponseBody
	public Map<String, Object> RewardTeacher(String contentId,double money,String rewardMsg){
		Map<String, Object> map = new HashMap<String, Object>();//reqMap.put("success", true);
		String userId = session.getAttribute("PCuserId")+"";
		map = accountService.addRewardLog(contentId,money,rewardMsg,userId);
		return map;
	}
	
	
	/**
	 * 跳转作家详情
	 * @return
	 */
	@RequestMapping(value="/toExpertDetail")
	public ModelAndView toExpertDetail(int userId){
		//当前用户id
		Integer myUserId=DataConvert.ToInteger(session.getAttribute("PCuserId"));
		Map<String, Object> content = new HashMap<String, Object>();
		content.put("myUserId", myUserId);
		//专家id
		content.put("userId", userId);
		content.put("footer", false);
		return new ModelAndView("/web/expert/expertDetailsIndex",content);
	}
	/**
	 * 作家详情
	 * @return
	 */
	@RequestMapping(value="/expertDetail")
	public ModelAndView expertDetail(int userId,HttpServletRequest request,HttpServletResponse response){
		//当前用户id
		Integer myUserId=DataConvert.ToInteger(session.getAttribute("PCuserId"));
		Map<String, Object> content = teacherService.selTeacherContentByPC(userId,myUserId);
		content.put("myUserId", myUserId);
		content.put("footer", false);
		return new ModelAndView("/web/expert/expertDetails",content);
	}
	
	/**
	 * 添加关注
	 * @return
	 */
	@RequestMapping(value="/addFoolow")
	@ResponseBody
	public Map<String, Object> addORcancelFoolow(String teacherId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String myUserId=DataConvert.ToString(session.getAttribute("PCuserId"));
		if(StringUtils.isEmpty(myUserId)) {
			reqMap.put("success", false);
			reqMap.put("msg", "请先登录!");
			return reqMap;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", myUserId);
		map.put("dataId", teacherId);
		map.put("dataType", 5);
		map.put("favoriteType", 2);
		if(myUserId.equals(teacherId)) {
			reqMap.put("success", false);
			reqMap.put("msg", "不可以关注自己");
			return reqMap;
		}
		Map ma = accountService.selIsfavorites(map);
		if(!StringUtils.isEmpty(ma)){
			reqMap.put("success", false);
			reqMap.put("msg", "已经关注了!");
			return reqMap;
		}
		//添加收藏
		int row = accountService.addCollect(map);
		if(row>0){
			reqMap.put("success", true);
			reqMap.put("msg", "关注成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "关注失败!");
		}
		return reqMap;
	}
	/**
	 * 取消关注
	 * @return
	 */
	@RequestMapping(value="/cancelFoolow")
	@ResponseBody
	public Map<String, Object> cancelFoolow(String teacherId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String myUserId=DataConvert.ToString(session.getAttribute("PCuserId"));
		if(StringUtils.isEmpty(myUserId)) {
			reqMap.put("success", false);
			reqMap.put("msg", "请先登录!");
			return reqMap;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", myUserId);
		map.put("dataId", teacherId);
		map.put("dataType", 5);
		map.put("favoriteType", 2);
		//取消关注
		int row = accountService.cancelCollect(map);
		if(row>0){
			reqMap.put("success", true);
			reqMap.put("msg", "取消成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "取消失败!");
		}
		return reqMap;
	}
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	/**
	 * 判断用户是否登陆
	 */
	@RequestMapping(value="/Islogin")
	@ResponseBody
	public Map<String, Object> Islogin(){
		Map<String, Object> map = new HashMap<String,Object>();
		String userId = DataConvert.ToString(session.getAttribute("PCuserId"));
		if(StringUtils.isEmpty(userId)) {
			map.put("success", false);
			map.put("msg", "请先登录!");
		}else {
			map.put("success", true);
		}
		return map;
	}
	
}
