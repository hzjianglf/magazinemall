package cn.web.home.controller;

import java.util.ArrayList;
import java.util.Calendar;
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

import com.alibaba.fastjson.JSONObject;

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.api.controller.AccountController;
import cn.api.controller.ProductController;
import cn.api.controller.SubscribeController;
import cn.api.service.AccountService;
import cn.api.service.ActivityService;
import cn.api.service.OrderService;
import cn.api.service.PathService;
import cn.api.service.ProductService;
import cn.api.service.QuestionService;
import cn.api.service.SearcheDiscountService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.phone.home.service.PhoneQuestionService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.page.PageInfo;

@Controller
@RequestMapping("/web/product")
public class WebProductController {
	
	@Autowired
	PhoneQuestionService pqService;
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
	@Autowired
	Setting setting;
	@Autowired
	PathService pathService;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	OrderService orderService;
	@Autowired
	SearcheDiscountService searcheDiscountService;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	
	//跳转期刊页
	@RequestMapping("toQikan")
	public ModelAndView toQikan(@RequestParam Map<String,Object> map){
		List years = productService.getYears();
		map.put("years", years);
		map.put("SEO2", "期刊-");
		return new ModelAndView("web/qikan/index",map);
	}
	//期刊列表
	@RequestMapping("/qikanListData")
	public ModelAndView qikanListData( int page, int pageSize,@RequestParam String type){
		if(type.equals(null)) {
			Calendar date = Calendar.getInstance();
			String year = String.valueOf(date.get(Calendar.YEAR));
			type = year;
		}
		
		Map<String, Object> map = new HashMap<String , Object>();
		//查询记录count
		long count = productService.getMoreMagazinesCount(Integer.parseInt(type));
		PageInfo pageInfo = new PageInfo(DataConvert.ToInteger(count),page,pageSize);
		
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		
		map.put("userId", getUserId());
		map.put("type",type);
		List<Map> list = productService.getMoreMagazines(map);
		
		Map<String,Object> reqMap = new HashMap<String,Object>();
		reqMap.put("list", list);
		reqMap.put("pageInfo", pageInfo);
		reqMap.put("year", type);
		
		return new ModelAndView("/web/qikan/dataList",reqMap);
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
		
		return new ModelAndView("/web/qikan/detail/qikanDetail",result);
	}
	
	//跳转期刊合集详情页
	@RequestMapping("/turnPublicaDisplay")
	public  ModelAndView turnPublicaDisplay(Integer id){
		Map<String,Object> map = new HashMap<String,Object>();
		int userId = getUserId();
		map.put("userId", userId);
		map.put("id", id);
		Map <String, Object> result = productService.getMagazinesContent(map);
		
		//获取期刊对应的买即送活动列表
		List<Map>buySiSongList=activityService.getBuyJiSongList(id,1);
		result.put("isBuySend", buySiSongList.isEmpty()?0:1);
		result.put("buySendList", buySiSongList);
		
		//获取合集详情列表
		List<Map<String,Object>> list  = productService.getMagazinesById(map);
		result.put("hejiData", list);
		
		return new ModelAndView("/web/qikan/detail/qikanHeJiDetail",result);
	}
	
	/**
	 * @author LiTonghui
	 * @title 已购电子书内容列表
	 * 
	 */
	@RequestMapping(value="/getEBookContent")
	public ModelAndView getEBookContent(Integer bookId,Integer period) {
		Map<String,Object> result = new HashMap<String, Object>();
		if(getUserId()<1||getUserId()==null) {
			result.put("needLogin", "1");
			return new ModelAndView("redirect:/web/home/index");
		}
		try {
			List<Map<String,Object>> list = productService.selEbookByPubIdPC(period);
			
			Map<String, Object> docName = new HashMap<String, Object>();
			List<Map<String,Object>> colList1 = new ArrayList<>();
			for (Map<String,Object> map3 : list) {
				Map<String,Object> columnMap2 = new HashMap<>();
				List<Map<String, Object>> list02 = (List) map3.get("list");
				List<Map<String, Object>> colList2 = new ArrayList<>();
				for (Map<String,Object> map4 : list02) {
					Map<String,Object> columnMap3 = new HashMap<>();
					columnMap3.put("Title", map4.get("Title"));
					columnMap3.put("DocID", map4.get("DocID"));
					columnMap3.put("level", 2);
					colList2.add(columnMap3);
				}
				columnMap2.put("docList", colList2);
				columnMap2.put("ColumnName", map3.get("CategoryName"));
				columnMap2.put("level", 1);
				colList1.add(columnMap2);
			}
			docName.put("itemlist", colList1);
			//Map转换成json
			JSONObject jsonDocName = new JSONObject(docName);
			result.put("columnData", jsonDocName);
			//获取文章列表和文章详情
			List<Map<String, Object>> DocData = new ArrayList<Map<String, Object>>();
			DocData = productService.selDocumentDataByPubId(period);
			for (Map<String, Object> map2 : DocData) {
				//获取文章内容
				String Doc = DataConvert.ToString(map2.get("MainText"));
				Doc = Doc.replaceAll("'", "\"");
				map2.put("MainText", Doc);
			}
			Map<String,Object> listDocData = new HashMap<String,Object>();
			listDocData.put("data", DocData);
			JSONObject jsonDocData = new JSONObject(listDocData);
			result.put("DocData", jsonDocData);
			//获取rul图片的路劲
			String urlImg = pathService.getAbsolutePath("DocPic");
			result.put("urlImg", urlImg+"/"+period+"/");
			//添加book id 跳转纸质
			result.put("id", bookId);
		} catch (Exception e) {
			result.put("msg","获取失败" + e.getMessage());
		}
		
		return new ModelAndView("/web/qikan/detail/ebookdetail",result);
	}
	
	//添加期刊收藏
	@RequestMapping("addCollection")
	@ResponseBody
	public Map<String,Object> addCollection(Integer dataId,Integer dataType,Integer favoriteType,Integer type){
		int userId = getUserId();
		Map<String, Object> result = new HashMap();
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
	 * @return map.type null,1.专家课程 2.白马营 3.听刊  4.营销书院  8.快课
	 */
	@RequestMapping(value="/toClass")
	public ModelAndView classList(@RequestParam Map<String,Object> map){
		String type = DataConvert.ToString(map.get("type"));
		if(type==null||type=="") {
			map.put("type", 0);
		}
		
		map.put("SEO2", "课程-");
		
		return new ModelAndView("/web/class/class",map);
	}
	/**
	 * 获取部分视图
	 * @param page
	 * @param pageSize
	 * @param type 1.专家课程 2.白马营 3.听刊  4.营销书院  8.快课
	 * @return
	 */
	@RequestMapping(value="/classDataList")
	public ModelAndView selectClass( Integer page, Integer pageSize, String type , String serialState){
		Map<String, Object> map = new HashMap<String, Object>();
		if(null == type) {
			type="1";
		}
		map.put("type", type);
		map.put("userId", getUserId());
		map.put("classtype", 0);
		map.put("serialState", serialState);
		//查询记录count
		int count = (int) productService.selCurriculumCount(map);
		PageInfo pageInfo = new PageInfo(count,page,pageSize);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list = productService.selCurriculum(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageInfo", pageInfo);
		reqMap.put("type", type);
		reqMap.put("serialState", serialState);
		
		return new ModelAndView("/web/class/dataList",reqMap);
	}
	
	/**
	 * 课程详情页面
	 */
	@RequestMapping(value="/classDetail")
	public ModelAndView classDetail(@RequestParam Map<String,Object> map){
		int userId=getUserId();
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Map<String, Object> details = productController.courseDetails(userId, ondemandId);
		details.put("userId", userId);
		return new ModelAndView("/web/class/detail/classdetail",details);
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
			return new ModelAndView("/web/home/index");
		}
		
		//查询订单
		Map<String,Object> orderDisplay = orderService.selectOrderDetail(userId, orderId);
		
		Map<String,Object> result = new HashMap<String,Object>();
		String mapPrice = DataConvert.ToString(map.get("totalPrice"));
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
		//订单详情
		result.put("orderDisplay", orderDisplay);
		result.put("pricePVbalan", pricePVbalan);
		result.put("price", mapPrice);
		return new ModelAndView("/web/class/pay/zhifu",result);
	}
	
	/**
	 * 课程订阅
	 */
	@RequestMapping(value="/payOndemand")
	public ModelAndView payOndemand(@RequestParam Map<String,Object> map){
		int userId=getUserId();
		if(userId==0) {
			return null;
		}
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Integer addressId = 0;
		
		//返回页面的数据
		Map<String, Object> result = new HashMap<String ,Object>();
		
		map.put("userId", userId);
		//获取地址
		List<Map<String, Object>> address = new ArrayList<Map<String, Object>>();
		address = accountService.selAddressList(userId);
		for (Map<String, Object> map3 : address) {
			if(map3.get("isDefault").equals(1)) {
				addressId = DataConvert.ToInteger(map3.get("Id"));
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
		Map<String,Object> yunfei = new HashMap<String, Object>();
		if(addressId > 0) {
			yunfei = subscribeController.getPostageByOndemand(userId, ondemandId, producttype, addressId);
			result.put("yunfei", yunfei.get("data"));
			result.put("addressId", addressId);
		}
		//地址id
		result.put("addressId", addressId);
		
		//获取优惠券代金券的参数
		Map<String, Object> paramap = new HashMap<String, Object>();
		paramap.put("userId", userId);
		Map<String, Object> data = (Map<String, Object>) details.get("data");
		//获取课程的类型type
		Integer type = 4;
		if(DataConvert.ToInteger(data.get("classtype"))==0) {
			type = 3;
		}
		int productId = DataConvert.ToInteger(data.get("ondemandId"));
		double price = DataConvert.ToDouble(data.get("presentPrice")) + DataConvert.ToDouble(yunfei);
		paramap.put("type", type);
		paramap.put("productId", productId);
		paramap.put("price", price);
		
		/**
		 * 获取优惠券类表
		 */
		Map<String, Object> couponsDataList = accountService.getCouponsByType(paramap);
		/**
		 * 获取代金券列表
		 */
		Map<String, Object> voucherDataList = accountService.getVoucherByType(paramap);
		//添加地址
		result.put("address", address);
		//添加优惠券
		result.put("couponsDataList", couponsDataList);
		//添加代金券
		result.put("voucherDataList", voucherDataList);
		//添加数据
		result.put("data", details);
		result.put("ondemandId", ondemandId);
		//支付记录id
		result.put("paylogId", map.get("paylogId")+"");
		return new ModelAndView("/web/class/pay/payondemand",result);
	}
	
	/**
	 * 获取课程下的课时列表
	 * @param page 第几页
	 * @param pageSize	每页的数量
	 * @param ondemandId	课时ID
	 * @return
	 */
	@RequestMapping(value="/selClassHour")
	public ModelAndView selClassHour(int page,int pageSize,int ondemandId){
		int userId=getUserId();
		Map<String, Object> hourList = productController.getClassHourList(ondemandId, userId, page, pageSize ,null);
		hourList.put("ondemandId", ondemandId);
		hourList.put("userId", userId);
		return new ModelAndView("/web/class/detail/dataList",hourList);
	}
	
	/**
	 * 获取课程下的课时列表
	 * @param page 第几页
	 * @param pageSize	每页的数量
	 * @param ondemandId	课时ID
	 * @return
	 */
	@RequestMapping(value="/selClassHour2")
	public ModelAndView selClassHour2(int page,int pageSize,int ondemandId){
		int userId=getUserId();
		Map<String, Object> hourList = productController.getClassHourList(ondemandId, userId, page, pageSize ,null);
		hourList.put("ondemandId", ondemandId);
		hourList.put("userId", userId);
		return new ModelAndView("/web/class/detail/classHourDetail/dataList",hourList);
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
	public ModelAndView hourDetail(@RequestParam Map<String, Object> map){
		Map<String, Object> content = productController.getHourContent(Integer.parseInt(map.get("hourId")+""));
		Map<String, Object> data = productService.getClassHourPicurl(Integer.parseInt(map.get("hourId")+""));
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Integer userId = getUserId();
		if(ondemandId>1) {
			Map<String, Object> details = productController.courseDetails(userId, ondemandId);
			content.put("details", details);
		}
		content.put("dataPPT", data);
		return new ModelAndView("/web/class/detail/classHourDetail/detail",content);
	}
	/**
	 * 历史播放课时详情页面
	 * @return
	 */
	@RequestMapping(value="/localHourDetail")
	public ModelAndView localHourDetail(@RequestParam Map<String, Object> map){
		Map<String, Object> content = productController.getHourContent(Integer.parseInt(map.get("hourId")+""));
		Map<String, Object> data = productService.getClassHourPicurl(Integer.parseInt(map.get("hourId")+""));
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Integer userId = getUserId();
		if(ondemandId>1) {
			Map<String, Object> details = productController.courseDetails(userId, ondemandId);
			content.put("details", details);
		}
		content.put("dataPPT", data);
		return new ModelAndView("/web/usercenter/history/dataList",content);
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
		PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list = productService.selectCommentList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("hourId", hourId);
		reqMap.put("pageInfo", pageInfo);
		
		return new ModelAndView("/web/class/detail/classHourDetail/pingLunDataList",reqMap);
	}
	/**
	 * 问答列表
	 * @param teacherId
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value="/questionList")
	public ModelAndView questionList(@RequestParam int teacherId,@RequestParam int page,@RequestParam int pageSize,String teacherName){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", teacherId);
		map.put("myUserId", session.getAttribute("PCuserId")+"");
		//查询记录count
		long count = questionService.selQuestionCount(map);
		
		Page pages = new Page(count, page, pageSize);
		PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//查询数据
		List list=questionService.selQuestionList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("teacherId", teacherId);
		reqMap.put("pageInfo", pageInfo);
		reqMap.put("teacherName", teacherName);
		return new ModelAndView("/web/class/detail/classHourDetail/questionDataList",reqMap);
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
		String userId = session.getAttribute("PCuserId")+"";
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
		String userId = session.getAttribute("PCuserId")+"";
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
		map.put("questioner", session.getAttribute("PCuserId")+"");
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
		map.put("start",1);
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
