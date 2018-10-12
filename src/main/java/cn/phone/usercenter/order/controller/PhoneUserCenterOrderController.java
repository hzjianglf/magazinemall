package cn.phone.usercenter.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpRequest;
import org.bouncycastle.ocsp.Req;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.ApiResult;
import cn.api.service.OrderService;
import cn.api.service.ProductService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Page;

/**
 * 已购列表
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping("/phone/usercenter/order")
public class PhoneUserCenterOrderController {
	
	
	@Autowired
	OrderService orderService;
	@Autowired
	HttpSession session;
	@Autowired
	ProductService productService;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	/**
	 * 已购列表
	 * @return
	 */
	@UserValidate
	@RequestMapping(value="/buglog")
	public ModelAndView buglog(){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("footer", false);
		return new ModelAndView("/phone/purchase/list",reqMap);
	}
	/**
	 * 电子书多期时通过订单项id查询电子书列表
	 */
	@UserValidate
	@RequestMapping("getEbookListById")
	public ModelAndView getEbookListById(Integer id){
		Map<String, Object> map = new HashMap<String, Object>();
		List list = orderService.getEbookListById(id);
		map.put("list", list);
		return  new ModelAndView("/phone/purchase/Ebook/ebooklist",map);
	}
	/**
	 * 期刊商品列表
	 * @return
	 */
	@UserValidate
	@RequestMapping(value="/selectProduct")
	public ModelAndView selectProduct(Integer page,Integer pageSize){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("producttype", 2);
		//查询count
		long count = orderService.getOrderCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = orderService.getOrders(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		return new ModelAndView("/phone/purchase/product/periodical",reqMap);
	}
	/**
	 * 已购电子书
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@UserValidate
	@RequestMapping(value="/selectEbook")
	public ModelAndView selectEbook(Integer page,Integer pageSize){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("producttype", 16);
		//查询count
		long count = orderService.getOrderCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = orderService.getOrders(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		return new ModelAndView("/phone/purchase/Ebook/partBook",reqMap);
	}
	/**
	 * @author LiTonghui
	 * @title 已购电子书内容列表
	 * 
	 */
	@RequestMapping(value="/getEBookContent")
	public ModelAndView getEBookContent(Integer type,Integer pubId , Integer geren) {
		Map<String,Object> result = new HashMap();
		if(getUserId()<1||getUserId()==null) {
			result.put("error", "请先登录");
		}
		try {
			List<Map<String,Object>> list = productService.selEbookByPubId(pubId);
			result.put("data", list);

		} catch (Exception e) {
			result.put("msg","获取失败" + e.getMessage());
		}
		if(type==1){
			result.put("footer", false);
			if(geren!=null) {
				result.put("footer", true);
				result.put("type", true);
			}
			return new ModelAndView("/phone/purchase/Ebook/EBookContent",result);
		}
		return new ModelAndView("/phone/qikan/ebookpartlist",result);
	}
	
	/**
	 * @author LiTonghui
	 * @title 查看已购电子书文章内容
	 * 
	 */
	@UserValidate
	@RequestMapping(value="/lookArticle")
	public ModelAndView lookArticle(@RequestParam("articleId") int articleId){
		Map<String,Object> data = productService.getArticleById(articleId);
		return new ModelAndView("/phone/purchase/Ebook/article",data);
	}
	
	
	/**
	 * 已购课程
	 * @param page
	 * @param pageSize
	 * @param type
	 * @return
	 */
	@UserValidate
	@RequestMapping(value="/selectOndemand")
	public ModelAndView selectOndemand(Integer page,Integer pageSize,String type){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		if("0".equals(type)){
			map.put("producttype", 4);
		}else if("1".equals(type)){
			map.put("producttype", 8);
		}
		//查询count
		long count = orderService.getOrderCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = orderService.getOrders(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		return new ModelAndView("/phone/purchase/class/partClass",reqMap);
	}
	
	
}
