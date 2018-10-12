package cn.phone.home.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.http.HttpRequest;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;

import cn.Setting.Setting;
import cn.Setting.Model.SearchSetting;
import cn.admin.adzone.service.AdvertisementService;
import cn.api.service.AccountService;
import cn.api.service.ProductService;
import cn.api.service.TeacherService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.DeHtml;
import cn.util.Page;
import cn.util.Tools;
import net.sf.json.JSONArray;
/**
 * 手机站首页
 */
@Controller
@RequestMapping("/phone/home")
public class PhoneHomeController {
	
	@Autowired
	private AdvertisementService advertisementService;
	@Autowired
	private ProductService productService;
	@Autowired
	private TeacherService teacherService;
	@Autowired
	AccountService accountService;
	@Autowired
	Setting setting;
	@Autowired
	HttpSession session;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	@RequestMapping("index")
	public ModelAndView index() {
		//获取首页信息 轮播广告·推荐教师·推荐报刊。。。
		List<Map<String,Object>> list = advertisementService.selBannerByZoneID(4);
		Map<String,Object> map = new HashMap<String,Object>();
		for (Map<String, Object> adverMap : list) {
//			Map maps = JSON.parseObject(adverMap.get("linkUrl").toString());
			String linkUrl = adverMap.get("linkUrl").toString();
			Map<String, Object> maps = Tools.JsonToMap(linkUrl);
			if(maps !=null && maps.size()>0) {
//				for (Object  obj : maps.entrySet()){
					
					
					if(Integer.parseInt(maps.get("itemType").toString())==1) {//期刊
						//判断是否是合集 0-非合集    不等于0-是合集
//						if(Integer.parseInt(maps.get("itemType").toString())==0) {
//						}else if(Integer.parseInt(maps.get("itemType").toString())!=0) {
//						}
						linkUrl = "/phone/product/turnPublicationDetail?id="+maps.get("itemId");
						adverMap.put("linkUrl", linkUrl);
					}else if(Integer.parseInt(maps.get("itemType").toString())==2) {//课程
						//判断是否是合集 0-非合集    不等于0-是合集
//						if(Integer.parseInt(maps.get("itemType").toString())==0) {
//						}else if(Integer.parseInt(maps.get("itemType").toString())!=0) {
//						}
						linkUrl = "/phone/product/classDetail?ondemandId="+maps.get("itemId");
						adverMap.put("linkUrl", linkUrl);
					}else if(Integer.parseInt(maps.get("itemType").toString())==3) {//专家
						linkUrl = "/phone/home/teacherDetail?userId="+maps.get("itemId");
						adverMap.put("linkUrl", linkUrl);
					}
					
//				}
			}
			
			
			//1:/phone/product/turnPublicationDetail?id=99 非合集
			//3:/phone/home/teacherDetail?userId=27
			//2:/phone/product/classDetail?ondemandId=8 非合集
			//type 2 
			//subType 0  
			
		}
		map.put("zone", list);
		List zazhi = productService.selectZazhiList();
		map.put("zazhi", zazhi);
		List<Map> kecheng = productService.selKechengList();
		for (Map map2 : kecheng) {
			map2.put("introduce", DeHtml.delHTMLTag(DataConvert.ToString(map2.get("introduce"))));
		}
		map.put("kecheng", kecheng);
		//获取白马营课程
		Map<String, Object> ma = new HashMap<String, Object>();
		ma.put("type", 2);
		ma.put("start", 0);
		ma.put("pageSize", 3);
		ma.put("IsRecommend", 1);
		//课程
		List<Map<String,Object>> teacher = teacherService.selExpertList(ma);
		map.put("teacher", teacher);
		ma.remove("IsRecommend");
		//白马营
		List bailist = productService.selCurriculum(ma);
		map.put("bailist", bailist);
		//获取快课
		ma.put("type", 8);
		List fastCourseList = productService.selCurriculum(ma);
		map.put("fastCourseList", fastCourseList);
		ma.put("pageSize", 5);
		//获取营销书院课程
		ma.put("type", 4);
		List booklist = productService.selCurriculum(ma);
		map.put("booklist", booklist);
		//获取听刊课程
		ma.put("type", 3);
		List hearingList = productService.selCurriculum(ma);
		map.put("hearList", hearingList);
		

		return new ModelAndView("/phone/home/index",map);
	}
	//跳转搜索页
	@RequestMapping("turnSearche")
	public ModelAndView turnSearch(){
		SearchSetting searchSetting=setting.getSetting(SearchSetting.class);
		List<String> list = searchSetting.getHotSearchWords();
		Map result = new HashMap();
		result.put("list", list);
		return new ModelAndView("/phone/home/search/index",result);
	}
	//根据类型和名称搜所内容
	@RequestMapping("searchContentByName")
	public ModelAndView searchContentByName(Integer type,String name,Integer page){
		Map<String,Object> parmap = new HashMap<String, Object>();
		long count = 0;
		List list = new ArrayList();
		parmap.put("searchName", name);
		parmap.put("userId", getUserId());
		parmap.put("start",(page-1)*6);
		parmap.put("pageSize", 6);
		if(type==2){
			count = productService.selectMagazineCount(parmap);
			list = productService.selectMagazineList(parmap);
		}else if(type==0 || type==1){
			parmap.put("classtype", type);
			list = productService.selCurriculum(parmap);
			count=productService.selCurriculumCount(parmap);
		}else if(type==3){
			list = teacherService.selExpertList(parmap);
	        count = teacherService.selectExpertCont(parmap);
		}else{
			
		}
		Page pages = new Page(count, page, 6);
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("pageTotal", pages.getTotalPageCount());
		result.put("list", list);
		result.put("type", type);
		result.put("count", count);
		return new ModelAndView("/phone/home/search/partlist",result);
	}
	/**
	 * 获取推荐课程列表
	 * @return
	 */
	@RequestMapping(value="/getRecommend")
	public ModelAndView getRecommend(@RequestParam Map map){
		map.put("footer", false);
		return new ModelAndView("/phone/recommendClass/list",map);
	}
	/**
	 * 推荐课程部分视图
	 * @return
	 */
	@RequestMapping(value="/recommendData")
	public ModelAndView recommendData(Integer page,Integer pageSize,Integer recommend,Integer teacherId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("recommend", recommend);
		map.put("teacherId", teacherId);
		//查询count
		long count=productService.selRecommendCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = productService.selRecommendList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		return new ModelAndView("/phone/recommendClass/partlist",reqMap);
	}
	//跳转营销书院
	@RequestMapping("returnShuYuan")
	public ModelAndView retrunShuYuan(){
		return new ModelAndView("/phone/shuyuan/index");
	}
	//跳转听刊
	@RequestMapping("returnTingkan")
	public ModelAndView returnKuaiKe(){
		return new ModelAndView("/phone/tingkan/index");
	}
	//查找营销书院的课程列表
	@RequestMapping("getShuYuanList")
	public ModelAndView getShuYuanList(Integer pageNow){
		if(null==pageNow){
			pageNow=1;
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("type", 4);
		long totalCount=productService.selCurriculumCount(map);
		Page page = new Page(totalCount, pageNow, 9);
		map.put("start", page.getStartPos());
		map.put("pageSize", 9);
		map.put("pageTotal", page.getTotalPageCount());
		List list = productService.selCurriculum(map);
		map.put("list", list);
		return new ModelAndView("/phone/shuyuan/partlist",map);
	}
	//查找营销书院的课程列表
	@RequestMapping("getTingkanList")
	public ModelAndView getKuaiKeList(Integer pageNow){
		if(null==pageNow){
			pageNow=1;
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("type", 3);
		long totalCount=productService.selCurriculumCount(map);
		Page page = new Page(totalCount, pageNow, 9);
		map.put("start", page.getStartPos());
		map.put("pageSize", 9);
		map.put("pageTotal", page.getTotalPageCount());
		List list = productService.selCurriculum(map);
		map.put("list", list);
		return new ModelAndView("/phone/tingkan/partlist",map);
	}
	
	/**
	 * 精选杂志列表
	 * @return
	 */
	@RequestMapping(value="/getMoveZine")
	public ModelAndView getMoveZine(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("footer", false);
		return new ModelAndView("/phone/zine/list",map);
	}
	/**
	 * 获取精选杂志列表部分视图
	 * @return
	 */
	@RequestMapping(value="/selectZine")
	public ModelAndView selectZine(Integer page,Integer pageSize,Integer orderType,String search){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isTop", 1);
		if(search!= null && search!="") {
			map.put("searchName", search);
		}
		map.put("orderType", orderType);
		
		long count = productService.selectMagazineCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		
		List list = productService.selectMagazineList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		return new ModelAndView("/phone/zine/partlist",reqMap);
	}
	
	/**
	 * 专家列表
	 * @return
	 */
	@RequestMapping(value="/getMoveWriter")
	public ModelAndView getMoveWriter(@RequestParam Map map){
		map.put("footer", false);
		return new ModelAndView("/phone/teacher/list",map);
	}
	//专家列表部分视图
	@RequestMapping(value="/selTeacherList")
	public ModelAndView selTeacherList(Integer page,Integer pageSize,Integer IsRecommend,String returnR){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("IsRecommend", IsRecommend);
		long count = teacherService.selectExpertCont(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		
		List list = teacherService.selExpertList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("returnR", returnR);
		return new ModelAndView("/phone/teacher/partteacher",reqMap);
	}
	
	/**
	 * 专栏作家主页
	 * @return
	 */
	@RequestMapping(value="/teacherDetail")
	public ModelAndView teacherDetail(int userId,HttpServletRequest request,
			HttpServletResponse response){
		//当前用户id
		Integer myUserId=DataConvert.ToInteger(session.getAttribute("userId"));
		/*if(myUserId==null || myUserId==0) {
			try {
				response.sendRedirect("/phone/allow/login");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}*/
		Map<String, Object> content = teacherService.selTeacherContent(userId,myUserId);
		content.put("myUserId", myUserId);
		content.put("footer", false);
		return new ModelAndView("/phone/teacher/detail/teadetail",content);
	}
	/**
	 * 添加关注
	 * @return
	 */
	@RequestMapping(value="/addFoolow")
	@ResponseBody
	public Map<String, Object> addORcancelFoolow(String teacherId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String myUserId=DataConvert.ToString(session.getAttribute("userId"));
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
		String myUserId=DataConvert.ToString(session.getAttribute("userId"));
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
	
}