package cn.admin.marketing.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.apache.http.protocol.HTTP;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.druid.util.StringUtils;

import cn.admin.marketing.service.CouponService;
import cn.admin.marketing.service.ShareSalesService;
import cn.admin.order.service.BackstageOrderService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;

@Controller
@RequestMapping(value="/admin/coupon")
public class CouponController {
	
	@Autowired
	CouponService couponService;
	@Autowired
	BackstageOrderService orderService;
	@Autowired
	ShareSalesService shareSalesService;
	@Autowired
	HttpSession session;
	
	@RequestMapping(value="/couponListFace")
	@Authorize(setting="优惠券-查看列表")
	public ModelAndView couponListFace(){
		Map<String,Object> map = new HashMap<String, Object>();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date now = new Date();
		String nowTime = df.format(now);
		map.put("nowTime", nowTime);
		return new ModelAndView("/admin/marketing/coupon/list",map);
	}
	
	//优惠券列表数据
	@RequestMapping(value="/couponListData")
	@ResponseBody
	public Map couponListData(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		long totalCount = couponService.selTotalCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = couponService.selCouponList(search);//商品、直播、点播
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	
	//添加优惠券界面
//	@RequestMapping(value="/addCouponFace")
//	public ModelAndView addCouponFace(HttpServletRequest request){
//		Map<String,Object> map = new HashMap<String, Object>();
//		String userName = session.getAttribute("adminRealName")+"";
//		String type = request.getParameter("type");
//		String couponId = request.getParameter("couponId");
//		Map data = new HashMap();
//		if(!StringUtils.isEmpty(couponId)){
//			data = couponService.selDetail(couponId);
//		}
//		int listCount = 0;
//		//关联商品方法
//		if(!StringUtils.isEmpty(couponId)){
//			//查询关联商品
//			map.put("id", couponId);
//			map.put("activityType", 1);
//			List list = shareSalesService.selectRelationProduct(map);
//			if(list!=null && list.size()>0){
//				map.put("list", list);
//				listCount = list.size();
//			}
//			//点击的是详细
//			map.put("detail", map.get("detail")+"");
//		}
//		map.put("listCount",listCount);
//		map.put("userName", userName);
//		map.put("type", type);
//		map.put("data", data);
//		
//		return new ModelAndView("/admin/marketing/coupon/addCoupon",map);
//	}
	@RequestMapping(value="/addCouponFace")
	public ModelAndView addCouponFace(HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");
		String couponId = request.getParameter("couponId");
		Map data = new HashMap();
		if(!StringUtils.isEmpty(couponId)){
			data = couponService.selDetail(couponId);
		}
		map.put("type", type);
		map.put("data", data);
		return new ModelAndView("/admin/marketing/coupon/newAdd",map);
	}
	
	//期刊/点播/直播/专家搜索页面
	@RequestMapping(value="/getAllGoods")
	public ModelAndView getAllGoods(@RequestParam("type") int type,@RequestParam("searchText") String searchText){//1期刊 2点播 3直播 4专家
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("searchText", searchText);
		String jspName = "qikan";
		if(type==2){
			jspName = "qikan";
		}else if(type==3){
			jspName = "dianbo";
		}else if(type==4){
			jspName = "zhibo";
		}else{
			jspName = "zhuanjia";
		}
		return new ModelAndView("/admin/marketing/coupon/searchFace/"+jspName,map);
	}
	//搜索页面数据
	@RequestMapping(value="/getAllGoodsData")
	@ResponseBody
	public Map getAllGoodsData(HttpServletRequest request,@RequestParam("type") int type,@RequestParam("searchText") String searchText,int page, int limit){//1期刊 2点播 3直播 4专家
		
		Map<String,Object> map = new HashMap<String, Object>();
		String numbers = request.getParameter("numbers");
		String names = request.getParameter("names");
		map.put("numbers", numbers);
		map.put("names", names);
		map.put("type", type);
		map.put("searchText", searchText);
		long totalCount = 0;
		if(type==2){
			totalCount = couponService.selQikanCount(map);
		}else if(type==3 || type==4){
			totalCount = couponService.selClassCount(map);
		}else{
			totalCount = couponService.selTeacherCount(map);
		}
		
		Page page2 = new Page(totalCount, page, limit);
		List<Map> list = new ArrayList<Map>();
		map.put("start", page2.getStartPos());
		map.put("pageSize", limit);
		if(type==2){
			list = couponService.getQikanlist(map);
		}else if(type==3 || type==4){
			list = couponService.getClassList(map);
		}else{
			list = couponService.getTeacherList(map);
		}
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	//添加/修改 优惠券
	@RequestMapping(value="/addCoupon")
	@ResponseBody
	public Map addCoupon(HttpServletRequest request,@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		String userName = session.getAttribute("adminRealName")+"";
		String userId = session.getAttribute("userId")+"";
		map.put("userName", userName);
		map.put("userId", userId);
		int row = 0;
		String type = map.get("type")+"";
		if(type.equals("1")){
			row = couponService.addCoupon(map);
		}else if(type.equals("2")){
			row = couponService.updCoupon(map);
		}
		if(row>0){
			result.put("result", true);
			result.put("msg", "操作成功！");
		}else{
			result.put("result", false);
			result.put("msg", "操作失败！");
		}
		return result;
	}
	
	//删除优惠券
	@RequestMapping(value="/delCouponInfo")
	@ResponseBody
	public Map delCouponInfo(@RequestParam("couponId") int couponId) {
		Map<String,Object> result = new HashMap<String, Object>();
		int row = couponService.delCouponInfo(couponId);
		if(row>0){
			result.put("result", true);
			result.put("msg", "删除成功！");
		}else{
			result.put("result", false);
			result.put("msg", "删除失败！");
		}
		return result;
	}
	
	//优惠券发放页面
	@RequestMapping(value="/grantCouponFace")
	public ModelAndView grantCouponFace(@RequestParam("couponId") int couponId){
		Map<String,Object> map = new HashMap<String, Object>();
		int couponCount = couponService.selCouponCount(couponId);//查询该优惠券剩余的数量
		map.put("couponId", couponId);
		map.put("couponCount", couponCount);
		return new ModelAndView("/admin/marketing/coupon/grantList",map);
	}
	
	//优惠券可发放的用户列表
	@RequestMapping(value="/userinfoList")
	@ResponseBody
	public Map userinfoList(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		String couponId = request.getParameter("couponId");
		search.put("couponId", couponId);
		long totalCount = couponService.selUserTotalCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = couponService.selUserInfo(search);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		
		return map;
	}
	
	//发放优惠券
	@RequestMapping(value="/grantCoupon")
	@ResponseBody
	public Map grantCoupon(HttpServletRequest request,@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		//发放优惠券。并且修改优惠券剩余数量
		int totalCount = couponService.selCouponCount(DataConvert.ToInteger(map.get("couponId")));
		String[] userId = map.get("userIds").toString().split(",");
		if(userId.length>totalCount || totalCount<=0){
			result.put("result", false);
			result.put("msg", "库存不足");
			return result;
		}
		int row = couponService.grantCoupon(map);
 		if(row>0){
 			result.put("result", true);
 			result.put("msg", "发放成功！");
 		}else{
 			result.put("result", false);
 			result.put("msg", "发放失败！");
 		}
		return result;
	}
	
	//已发优惠券列表
	@RequestMapping(value="/alreadyGrant")
	public ModelAndView alreadyGrant(HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");
		String couponId = request.getParameter("couponId");
		map.put("type", type);
		map.put("couponId", couponId);
		return new ModelAndView("/admin/marketing/coupon/alreadyGrant",map);
	}
	//已发优惠券数据列表
	@RequestMapping(value="/alreadyGrantList")
	@ResponseBody
	public Map alreadyGrantList(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		String couponId = request.getParameter("couponId");
		String type = request.getParameter("type");
		search.put("couponId", couponId);
		search.put("type", type);
		long totalCount = couponService.alreadyGrantCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = couponService.selAlreadyGrantList(search);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		
		return map;
	}
	
}
