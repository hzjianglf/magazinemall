package cn.web.home.controller;

import java.util.ArrayList;
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

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.admin.adzone.service.AdvertisementService;
import cn.admin.column.service.ColumnManageService;
import cn.admin.friendLink.service.FriendService;
import cn.api.controller.ProductController;
import cn.api.service.AccountService;
import cn.api.service.ProductService;
import cn.api.service.QuestionService;
import cn.api.service.TeacherService;
import cn.util.DataConvert;
import cn.util.Tools;
import cn.web.home.service.WebHomeService;

/**
 * pc 首页
 */
@Controller
@RequestMapping("/web/home")
public class WebHomeController {
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
	WebHomeService webHomeService;
	@Autowired
	AccountService accountService;
	@Autowired
	Setting setting;
	@Autowired
	ColumnManageService columnManageService;
	@Autowired
	FriendService friendService;
	
	@RequestMapping("index")
	public ModelAndView turnIndex() {
		List<Map<String,Object>> adzoneList = new ArrayList<Map<String,Object>>();
		Map<String,Object> map = new HashMap<String,Object>();
		//模块1:轮播图展示
		List<Map<String,Object>> list = advertisementService.selBannerByZoneID(5);
		list = advertisementService.changeUrl(list,1);
		//顶部广告位
		map.put("zone", list);
		//查询adzone表有效的广告位active 是否有效：0，无效；1，有效
		adzoneList = advertisementService.selAdzoneListTotal();
		if(adzoneList !=null && adzoneList.size()>0) {
			for (int i = 0; i < adzoneList.size(); i++) {
				list = advertisementService.selBannerByZoneID(Integer.parseInt(adzoneList.get(i).get("zoneID").toString()));
				list = advertisementService.changeUrl(list,1);
				map.put("zoneR0"+(i+1), list);
			}
		}
		
		//广告位右一
//		list = advertisementService.selBannerByZoneID(6);
//		list = advertisementService.changeUrl(list,1);
//		map.put("zoneR01", list);
		//广告位右二
//		list = advertisementService.selBannerByZoneID(7);
//		list = advertisementService.changeUrl(list,1);
//		map.put("zoneR02", list);
		//广告位右三
//		list = advertisementService.selBannerByZoneID(8);
//		list = advertisementService.changeUrl(list,1);
//		map.put("zoneR03", list);
		//广告位右四
//		list = advertisementService.selBannerByZoneID(9);
//		list = advertisementService.changeUrl(list,1);
//		map.put("zoneR04", list);
		
		
		//模块2:期刊
		Map<String,Object> bookmap = new HashMap<String,Object>();
		bookmap.put("isTop", 1);
		bookmap.put("start", 0);
		bookmap.put("pageSize", 4);
		//List bookList = productService.getMoreMagazines(bookmap);
		//获取推荐的最近的前三个期刊,重新写一个方法
		List bookList = productService.getLatestTopMagazines(bookmap);
		map.put("bookList", bookList);
		//模块3:专家课程,白马营微课,听刊
		Map<String,Object> ondemandmap = new HashMap<String,Object>();
		ondemandmap.put("type", 1);
		/*ondemandmap.put("classtype", 0);*/
		ondemandmap.put("start",0);
		ondemandmap.put("pageSize",4);
		/*ondemandmap.put("IsRecommend",1);*/
		//专家课程列表
		List ondemand1list = productService.selCurriculum(ondemandmap);
		map.put("ondemand1list", ondemand1list);
		//白马营微课列表
		ondemandmap.put("type", 2);
		List ondemand2list = productService.selCurriculum(ondemandmap);
		map.put("ondemand2list", ondemand2list);
		//听刊列表
		ondemandmap.put("type", 3);
		List ondemand3list = productService.selCurriculum(ondemandmap);
		map.put("ondemand3list", ondemand3list);
		//模块4:营销书院
		ondemandmap.put("type", 4);
		List ondemand4list = productService.selCurriculum(ondemandmap);
		map.put("ondemand4list", ondemand4list);
		//模块5:专栏作家
		Map<String,Object> teachermap = new HashMap<String,Object>();
		teachermap.put("IsRecommend", 1);//1-推荐
		teachermap.put("start",0);
		teachermap.put("pageSize",4);
		List teacherList = teacherService.selExpertList(teachermap);
		map.put("teacherList", teacherList);
		//模块6:问答列表
		Map<String,Object> interlocutionMap = new HashMap<String,Object>();
		interlocutionMap.put("type", 0);
		interlocutionMap.put("start",0);
		interlocutionMap.put("pageSize",4);
//		String userId = session.getAttribute("userId")+"";
//		interlocutionMap.put("myUserId",userId);
		interlocutionMap.put("myUserId",getUserId());
		List interlocutionList = questionService.selQuestionList(interlocutionMap);
		map.put("interlocutionList", interlocutionList);
		//模块7:专家答疑
		interlocutionMap.put("type", 1);
		List teacherAnswerList = questionService.selQuestionList(interlocutionMap);
		map.put("teacherAnswerList", teacherAnswerList);
		
		//获取快课
		map.put("type", 8);
		List fastCourseList = productService.selCurriculum(map);
		map.put("fastCourseList", fastCourseList);
		map.put("displayYou", true);
		
		//查询二维码标题
		SiteInfo siteInfo = setting.getSetting(SiteInfo.class, null);
		map.put("siteInfo", siteInfo);
		return new ModelAndView("web/home/index",map);
	}
	/**
	 * 点击课程,跳转课程合集列表页面
	 */
	@RequestMapping(value="/ondemandCollections")
	public ModelAndView ondemandCollections(@RequestParam Map map){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		//根据课程合集id 查询合集详情
		Map<String, Object> details = productController.courseDetails(getUserId(), ondemandId);
		resultMap.put("details", details);
		//根据课程合集id 查询合集下的列表
		Map<String, Object> collectionList = productController.getSumById(ondemandId,0,1,100);
		resultMap.put("collectionList", collectionList);
		int userId=getUserId();
		resultMap.put("userId", userId);
		return new ModelAndView("/web/class/detail/ondemandItems",resultMap);
	}
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	
	//搜索内容
	@RequestMapping(value="/searchContentByName")
	public ModelAndView searchContentByName (@RequestParam String name) {
		Map<String, Object> data = new HashMap<String, Object>();
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		//期刊 2 点播课程0 直播课程1	专家3	商品4
		//获取搜索期刊列表
		list = webHomeService.searchContentByName(2, name);
		data.put("qikan", list);
		//搜索点播课程列表
		list = webHomeService.searchContentByName(0, name);
		data.put("dianbo", list);
		//直播课程列表
		list = webHomeService.searchContentByName(1, name);
		data.put("zhibo",list);
		//专家列表
		list = webHomeService.searchContentByName(3, name);
		data.put("zhuanjia", list);
		//商品列表
		list = webHomeService.searchContentByName(4, name);
		data.put("shoping",list);
		
		data.put("name", name);
		
		return new ModelAndView("/web/home/searchIndex",data);
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
	
	@RequestMapping(value="/setModel")
	@ResponseBody
	public Map<String,Object> setModel(@RequestParam Map<String,Object> map, HttpServletRequest request, HttpServletResponse response) {
		// 查询参数设置
		SiteInfo siteInfo = setting.getSetting(SiteInfo.class, null);
		map.put("siteInfo", siteInfo);
		
		return map;
	}
	
	/**
	 * 主页下面的栏目
	 */
	@RequestMapping(value = "/columnList")
	@ResponseBody
	public Map<String, Object> ColumnList() {
		Map<String, Object> columnMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = columnManageService.selColumnLists();
		columnMap.put("list", list);
		return columnMap;
	}
	
	/**
	 * 主页下面的栏目详情
	 */
	@RequestMapping(value = "/selcolumn")
	public ModelAndView selColumn(String catId) {
		return new ModelAndView("web/index", columnManageService.selColumn(catId));
	}
	
	/**
	 * 友情链接类表
	 */
	@RequestMapping(value = "/linkFriendData")
	@ResponseBody
	public Map<String,Object> linkFriendData(){
		Map<String,Object> result = new HashMap<String,Object>();
		List<Map<String,Object>> list = friendService.selectLink(null);
		result.put("list", list);
		return result;
	}
	
	//跳转期刊页
	@RequestMapping("toQikan")
	public ModelAndView toQikan(@RequestParam Map<String,Object> map){
		List years = productService.getYears();
		map.put("years", years);
		map.put("SEO2", "期刊-");
		return new ModelAndView("web/qikan/index",map);
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
}
