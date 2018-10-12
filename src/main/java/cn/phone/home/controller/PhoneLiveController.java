package cn.phone.home.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import cn.api.controller.ProductController;
import cn.api.service.AccountService;
import cn.api.service.ProductService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Page;

/**
 *  
 * 直播
 */
@Controller
@RequestMapping("/phone/live")
public class PhoneLiveController {
	@Autowired
	private ProductService productService;
	@Autowired
	HttpSession session;
	@Autowired
	ProductController productController;
	@Autowired
	AccountService accountService;
	@Autowired
	private SettingService settingService;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	
	
	/**
	 * 获取直播列表页面
	 * @return
	 */
	@RequestMapping(value="/liveList")
	public ModelAndView classList(@RequestParam Map map){
		map.put("footer", false);
		return new ModelAndView("/phone/live/list",map);
	}
	
	
	/**
	 * 获取直播部分视图
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/selectLive")
	public ModelAndView selectClass(@RequestParam int page,@RequestParam int pageSize,@RequestParam String type){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("classtype", 1);
		map.put("userId", getUserId());
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
		return new ModelAndView("/phone/live/partlist",reqMap);
	}
	
	
	/**
	 * 直播详情页面
	 */
	@RequestMapping(value="/liveDetail")
	public ModelAndView classDetail(@RequestParam Map map){
		int userId=getUserId();
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Map<String, Object> details = productController.courseDetails(userId, ondemandId);
		details.put("footer", false);
		return new ModelAndView("/phone/live/detail/livedetail",details);
	}
	
	/**
	 * 直播订阅
	 */
	@RequestMapping(value="/payOndemand")
	@UserValidate//未登录状态不允许访问此页面
	public ModelAndView payOndemand(@RequestParam Map map){
		int userId=getUserId();
		int ondemandId=Integer.parseInt(map.get("ondemandId")+"");
		Map<String, Object> details = productController.courseDetails(userId, ondemandId);
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
		details.put("paylist", list);
		//支付记录id
		details.put("paylogId", map.get("paylogId")+"");
		details.put("footer", false);
		return new ModelAndView("/phone/live/pay/payondemand",details);
	}
}
