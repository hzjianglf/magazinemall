package cn.phone.usercenter.coupon.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.aspectj.internal.lang.annotation.ajcDeclareAnnotation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.AccountService;
import cn.util.DataConvert;
import cn.util.Page;

@RequestMapping("/phone/usercenter/coupon")
@Controller
public class PhoneCouponController {
	@Autowired
	private AccountService accountService;
	@Autowired
	private HttpSession session;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	
	@RequestMapping("/turnCoupon")
	public ModelAndView turnCoupon(){
		return new ModelAndView("/phone/usercenter/coupon/index");
	}
	@RequestMapping("/partialList")
	public  ModelAndView showOrders(HttpServletRequest request){
		String type = request.getParameter("type");
		Integer pageNow = 1;
		if(request.getParameter("pageNow")!=null && request.getParameter("pageNow")!=""){
			pageNow = Integer.parseInt(request.getParameter("pageNow"));
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("type", type);
		map.put("start", (pageNow-1)*9);
		map.put("userId", getUserId());
		List<Object> list = new ArrayList<Object>();
		long pageTotal = accountService.getCouponsCount(map);
		Page page =new Page(pageTotal, pageNow, 9);
		map.put("pageTotal", page.getTotalPageCount());
		map.put("pageSize", 9);
		list = accountService.getCoupons(map);
		map.put("list", list);
		map.put("pageNow", pageNow);
		return new ModelAndView("/phone/usercenter/coupon/partlist",map);
	}
}
