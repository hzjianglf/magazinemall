package cn.phone.home.controller;

import java.util.ArrayList;
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

import cn.api.controller.AccountController;
import cn.api.controller.ClassHourController;
import cn.api.controller.ProductController;
import cn.api.controller.SubscribeController;
import cn.api.service.AccountService;
import cn.api.service.ActivityService;
import cn.api.service.OrderService;
import cn.api.service.ProductService;
import cn.api.service.QuestionService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@Controller
@RequestMapping("/phone/product")
public class PhoneProductController {
	
	@Autowired
	private OrderService orderService;
	@Autowired
	private SubscribeController subscribeController;
	@Autowired
	private ProductService productService;
	@Autowired
	private AccountController accountController;
	@Autowired
	private SettingService settingService;
	@Autowired
	ProductController productController;
	@Autowired
	AccountService accountService;
	@Autowired
	HttpSession session;
	@Autowired
	ActivityService activityService;
	@Autowired
	QuestionService questionService;
	
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	//跳转文稿的方法
	@RequestMapping("presentation")
	public ModelAndView turnPresentation(Integer hourId){
		Map map = productService.getHourContentById(hourId);
		map.put("footer", false);
		return new ModelAndView("/phone/home/presentation",map);
	}
	//跳转期刊页
	@RequestMapping("turnPublication")
	public ModelAndView turnPublication(){
		Map<String,Object> map = new HashMap<String,Object>();
		List years = productService.getYears();
		map.put("years", years);
		return new ModelAndView("phone/qikan/qikanlist",map);
	}
	//期刊列表
	@RequestMapping("/partialList")
	public synchronized  ModelAndView showOrders(HttpServletRequest request){
		String type = request.getParameter("type");
		Integer pageNow = 1;
		if(request.getParameter("pageNow")!=null && request.getParameter("pageNow")!=""){
			pageNow = Integer.parseInt(request.getParameter("pageNow"));
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("type", type);
		map.put("start", (pageNow-1)*9);
		long pageTotal = productService.getMoreMagazinesCount(Integer.parseInt(type));
		Page page =new Page(pageTotal, pageNow, 9);
		map.put("pageTotal", page.getTotalPageCount());
		map.put("pageSize", 9);
		map.put("userId", getUserId());
		List list = productService.getMoreMagazines(map);
		map.put("list", list);
		map.put("pageNow", pageNow);
		return new ModelAndView("/phone/qikan/partlist",map);
	}
	//跳转期刊详情页
	@RequestMapping("/turnPublicationDetail")
	public  ModelAndView turnPublicationDetail(Integer id){
		Map<String,Object> map = new HashMap<String,Object>();
		int userId = getUserId();
		map.put("userId", userId);
		map.put("id", id);
		Map <String, Object> result = productService.getMagazinesContent(map);

		//获取期刊对应的买即送活动列表
		List<Map>buySiSongList=activityService.getBuyJiSongList(id,1);
		result.put("isBuySend", buySiSongList.isEmpty()?0:1);
		result.put("buySendList", buySiSongList);
		
		result.put("footer", false);
		return new ModelAndView("/phone/qikan/qikanDetail",result);
	}
	//添加期刊收藏
	@RequestMapping("addCollection")
	@ResponseBody
	public Map<String,Object> addCollection(Integer dataId,Integer dataType,Integer favoriteType,Integer type){
		int userId = getUserId();
		Map<String, Object> result = new HashMap();
		result.put("msg", "请先登录");
		if(userId<1) {
			return result;
		}
		//type 1 添加 2 取消
		if(type==1){
			 result = accountController.addCollect(userId, dataId, dataType, favoriteType);
		}else{
			 result = accountController.cancelCollect(userId, dataId, dataType, favoriteType);
		}
		result.put("type", type);
		return result;
	}
	/**
	 * 获取课程列表页面
	 * @return
	 */
	@RequestMapping(value="/classList")
	public ModelAndView classList(@RequestParam Map map){
		map.put("footer", false);
		return new ModelAndView("/phone/class/list",map);
	}
	/**
	 * 获取部分视图
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/selectClass")
	public ModelAndView selectClass(@RequestParam int page,@RequestParam int pageSize,@RequestParam String type,String r){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("userId", getUserId());
		map.put("classtype", 0);
		//查询记录count
		int count = (int) productService.selCurriculumCount(map);
		
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list = productService.selCurriculum(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("returnR", r);
		return new ModelAndView("/phone/class/partlist",reqMap);
	}
	
	/**
	 * 课程详情页面
	 */
	@RequestMapping(value="/classDetail")
	public ModelAndView classDetail(@RequestParam Map map){
		int userId=getUserId();
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Map<String, Object> details = productController.courseDetails(userId, ondemandId);
		details.put("footer", false);
		//如果是合集，并且已购，直接到合集课程类表
		Map<String,Object> data = (Map<String, Object>) details.get("data");
		//Integer isbuy = DataConvert.ToInteger(data.get("isbuy"));
		Integer isSum = DataConvert.ToInteger(data.get("isSum"));
		if(isSum>0) {
			Map search = new HashMap();
			search.put("userId", userId);
			search.put("ondemandId", ondemandId);
			List sumList = productService.getSumById(search);
			details.put("sumList", sumList);
			return new ModelAndView("/phone/class/detail/sumclassdetail",details);
		}
		return new ModelAndView("/phone/class/detail/classdetail",details);
	}
	
	//判断支是否为0支付页面
	@RequestMapping(value="/judgePayOndemand")
	@ResponseBody
	public Map<String,Object> judgePayOndemand(@RequestParam Map<String,Object> map){
		Integer userId = getUserId();
		
		Map<String,Object> result = new HashMap<String,Object>();
		
		result.put("success", 0);
		result.put("msg", "支付失败");
		
		if(userId==null) {
			return result;
		}
		
		Integer productId = DataConvert.ToInteger(map.get("productId"));
		Integer producttype = DataConvert.ToInteger(map.get("producttype"));
		Integer couponId = DataConvert.ToInteger(map.get("couponId"));
		Integer voucherId =DataConvert.ToInteger(map.get("voucherId"));
		Integer addressId = DataConvert.ToInteger(map.get("addressId"));
		
		result = subscribeController.buyOndemand(userId, productId, producttype, voucherId, couponId, addressId);
		
		return result;
	}
	
	//跳转支付
	@RequestMapping(value="/toPayOndemand")
	public ModelAndView toPayOndemand(@RequestParam Map<String,Object> map) {
		
		Integer orderId = DataConvert.ToInteger(map.get("orderId"));
		int userId = getUserId();
		if(userId==0) {
			return new ModelAndView("/phone/usercenter/account/index");
		}
		
		Map<String,Object> result = new HashMap<String,Object>();
		String mapPrice = DataConvert.ToString(map.get("money"));
		if(mapPrice!=null&&mapPrice!="") {
			result.put("price", mapPrice+"");
		}
		
		//查询账户余额
		Map balance = accountService.selectBalance(userId+"");
		result.put("balance", balance.get("balance")+"");
		
		//比较大小
		boolean pricePVbalan = true;
		Double pricedisplay = DataConvert.ToDouble(mapPrice);
		Double balancedisplay = DataConvert.ToDouble(balance.get("balance"));
		if(pricedisplay>balancedisplay) {
			pricePVbalan = false;
		}
		
		//获取支付方式列表
		map.put("platformType", 3);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> payMethods = settingService.getPayMethods(map);
		result.put("payMethods", payMethods);
		//支付记录id
		result.put("paylogId", map.get("paylogId")+"");
		result.put("footer", false);
		result.putAll(map);
		result.put("pricePVbalan", pricePVbalan);
		return new ModelAndView("/phone/class/pay/zhifu",result);
	}
	
	/**
	 * 课程订阅
	 */
	@RequestMapping(value="/payOndemand")
	@UserValidate//未登录状态不允许访问此页面
	public ModelAndView payOndemand(@RequestParam Map<String,Object> map){
		int userId=getUserId();
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Integer addressId = DataConvert.ToInteger(map.get("addressId"));
		
		map.put("userId", userId);
		//获取地址
		Map<String, Object> address = new HashMap<String, Object>();
		if(addressId==0 || addressId==null) {
			//默认地址
			map.put("isDefault", 1);
			address = accountService.selectIsDefaultAddress(map);
			if(address==null){
				map.put("footer",false);
				return new ModelAndView("/phone/usercenter/addAddress",map);
			}
			addressId = DataConvert.ToInteger(address.get("Id"));
		}else {
			//指定地址
			map.put("id", addressId);
			address = accountService.selectIsDefaultAddress(map);
			if(address==null){
				map.put("footer",false);
				return new ModelAndView("/phone/usercenter/addAddress",map);
			}
		}
		
		Map<String, Object> details = productController.courseDetails(userId, ondemandId);
		//获取课程类型
		Integer classType = DataConvert.ToInteger(details.get("classtype"));
		Integer producttype = 0;
		if(classType == 0) {
			producttype = 4;
		}else {
			producttype = 8;
		}
		//获取运费
		Map<String,Object> yunfeiMap = subscribeController.getPostageByOndemand(userId, ondemandId, producttype, addressId);
		if(yunfeiMap!=null) {
			details.put("yunfei", DataConvert.ToString(yunfeiMap.get("data")));
		}
		//地址id
		details.put("addressId", addressId);
		//查询账户余额
		Map balance = accountService.selectBalance(userId+"");
		details.put("balance", balance.get("balance")+"");
		//获取支付方式列表
		map.put("platformType", 3);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> list = settingService.getPayMethods(map);
		//添加地址
		details.put("address", address);
		details.put("paylist", list);
		details.put("ondemandId", ondemandId);
		//支付记录id
		details.put("paylogId", map.get("paylogId")+"");
		details.put("footer", false);
		return new ModelAndView("/phone/class/pay/payondemand",details);
	}
	
	/**
	 * 获取课程下的课时列表
	 * @param page
	 * @param pageSize
	 * @param ondemandId
	 * @param userId
	 * @return
	 */
	@RequestMapping(value="/selClassHour")
	public ModelAndView selClassHour(@RequestParam int page,@RequestParam int pageSize,
			@RequestParam int ondemandId ,@RequestParam  String paixu){
			int userId=getUserId();
		Map<String, Object> hourList = productController.getClassHourList(ondemandId, userId, page, pageSize , paixu);
		return new ModelAndView("/phone/class/detail/partclass",hourList);
	}
	/**
	 * 课时文稿
	 * @return
	 */
	@RequestMapping(value="/classPresentation")
	public ModelAndView classPresentation(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap = productService.selClassPresentation(map);
		return new ModelAndView("/phone/class/presentation/pre",reqMap);
	}
	/**
	 * 课时详情页面
	 * @return
	 */
	@RequestMapping(value="/hourDetail")
	@UserValidate
	public ModelAndView hourDetail(@RequestParam Map<String, Object> map){
		Map<String, Object> content = productController.getHourContent(Integer.parseInt(map.get("hourId")+""));
		Map<String, Object> data = productService.getClassHourPicurl(Integer.parseInt(map.get("hourId")+""));
		content.put("footer", false);
		content.put("dataPPT", data);
		return new ModelAndView("/phone/class/hour/detail",content);
	}
	/**
	 * 获取评论列表部分视图
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/commentList")
	public ModelAndView commentList(Integer hourId,Integer commentType,Integer page,Integer pageSize){
		//TODO 待优化
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("contentId", hourId);
		map.put("commentType", commentType);
		
		long count = productService.selectCommentCount(map);
		
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list = productService.selectCommentList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		
		return new ModelAndView("/phone/class/hour/partcomment",reqMap);
	}
	/**
	 * 课时详情页面，展示课时列表
	 * @return
	 */
	@RequestMapping(value="/commentHourlist")
	public ModelAndView commentHourlist(int page,int pageSize,int ondemandId,int hourId){
		int userId = getUserId();
		Map<String, Object> hourList = productController.getClassHourList(ondemandId, userId, page, pageSize , null);
		hourList.put("classhourId", hourId);
		return new ModelAndView("/phone/class/hour/parthour",hourList);
	}
	/**
	 * 添加回复评论
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/saveComment")
	@ResponseBody
	public Map<String, Object> saveComment(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//用户id
		String userId = session.getAttribute("userId")+"";
		if("on".equals(map.get("anonymous")+"")){
			map.put("isAnonymity", 1);
		}else{
			map.put("isAnonymity", 0);
		}
		map.put("userId", userId);
		int row = productService.addComment(map);
		if(row>0){
			reqMap.put("success", true);
			reqMap.put("msg", "评论成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "评论失败！");
		}
		return reqMap;
	}
	/**
	 * 添加笔记
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/saveNode")
	@ResponseBody
	public Map<String, Object> saveNode(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//用户id
		String userId = session.getAttribute("userId")+"";
		map.put("userId", userId);
		boolean flag = accountService.createNode(map);
		if(flag){
			reqMap.put("success", true);
			reqMap.put("msg", "添加成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "添加失败!");
		}
		return reqMap;
	}
	/**
	 * 添加提问
	 * @return
	 */
	@RequestMapping(value="/addQuiz")
	@ResponseBody
	public Map<String, Object> addQuiz(String content,Integer type,Integer isAnonymity,double money,Integer teacherId,Integer ondemandId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("questioner", session.getAttribute("userId")+"");
		map.put("content", content);
		map.put("type", type);
		map.put("isAnonymity", isAnonymity);
		map.put("money", money);
		map.put("teacherId", teacherId);
		map.put("ondemandId", ondemandId);
		reqMap = questionService.addQuestions(map);
		//TODO 添加提问支付
		
		return reqMap;
	}
	/**
	 * 通过课程合集id查看合集列表
	 * @param page
	 * @param pageSize
	 * @param ondemandId
	 * @return
	 */
	@RequestMapping(value="/selectSumList")
	public ModelAndView selectSumList(Integer page,Integer pageSize,Integer ondemandId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("ondemandId", ondemandId);
		//查询count
//		long count = productService.getSumCount(map);
//		Page pages = new Page(count, page, pageSize);
		map.put("start", 1);
		map.put("pageSize", 1000);
		//列表
		List list = productService.getSumById(map);
		reqMap.put("list", list);
//		reqMap.put("pageTotal", pages.getTotalPageCount());
//		reqMap.put("count", count);
//		reqMap.put("pageTotal", pages.getTotalPageCount());
		return new ModelAndView("/phone/purchase/sum/sumProduct",reqMap);
	}
	/**
	 * 通过期刊合集id查看合集下的商品列表
	 * @param page
	 * @param pageSize
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/selectProudctListByCollection")
	public ModelAndView selectProudctListByCollection(Integer page,Integer pageSize,String id){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", id);
		List<Map<String,Object>> list  = productService.getMagazinesById(map);
		reqMap.put("list", list);
		return new ModelAndView("/phone/purchase/sum/sumPeriodical",reqMap);
	}
	
	
	
}
