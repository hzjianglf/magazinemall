package cn.web.usercenter.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.http.HttpRequest;
import org.apache.ibatis.session.SqlSession;
import org.bouncycastle.ocsp.Req;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.Setting.Model.SiteInfo;
import cn.api.service.ApiResult;
import cn.api.service.OrderService;
import cn.api.service.PathService;
import cn.api.service.ProductService;
import cn.api.service.SearcheDiscountService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.page.PageInfo;

/**
 * 已购列表
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping("/web/usercenter/order")
public class WebUserCenterOrderController {
	
	
	@Autowired
	OrderService orderService;
	@Autowired
	HttpSession session;
	@Autowired
	ProductService productService;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	PathService pathService;
	@Autowired
	private SearcheDiscountService searcheDiscountService;
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	/**
	 * 已购列表
	 * @return
	 */
	@RequestMapping(value="/buglog")
	public ModelAndView buglog(){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("footer", false);
		return new ModelAndView("/phone/purchase/list",reqMap);
	}
	/**
	 * 电子书多期时通过订单项id查询电子书列表
	 */
	@RequestMapping("getEbookListById")
	public ModelAndView getEbookListById(Integer id){
		Map<String, Object> map = new HashMap<String, Object>();
		List list = orderService.getEbookListById(id);
		map.put("list", list);
		return  new ModelAndView("/web/usercenter/personalCenter/ebookList",map);
	}
	/**
	 * 期刊商品列表
	 * @return
	 */
	@RequestMapping(value="/selectProduct")
	public ModelAndView selectProduct(Integer page,Integer pageSize){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("producttype", 2);
		//查询count
		long count = orderService.getOrderCount(map);
		Page pages = new Page(count, page, pageSize);
		PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = orderService.getOrders(map);
		reqMap.put("list", list);
		reqMap.put("pageInfo", pageInfo);
		return new ModelAndView("/web/usercenter/personalCenter/commodity",reqMap);
	}
	/**
	 * 已购电子书
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value="/selectEbook")
	public ModelAndView selectEbook(Integer page,Integer pageSize){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("producttype", 16);
		//查询count
		long count = orderService.getOrderCount(map);
		Page pages = new Page(count, page, pageSize);
		PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = orderService.getOrders(map);
		reqMap.put("list", list);
		reqMap.put("pageInfo", pageInfo);
		return new ModelAndView("/web/usercenter/personalCenter/ebook",reqMap);
	}
	/**
	 * @author LiTonghui
	 * @title 已购电子书内容列表
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
	//@UserValidate
	@RequestMapping(value="/lookArticle")
	@ResponseBody
	public Map<String,Object> lookArticle(int articleId){
		Map<String,Object> data = productService.getArticleById(articleId);
		return data;
	}
	
	
	/**
	 * 已购课程
	 * @param page
	 * @param pageSize
	 * @param type
	 * @return
	 */
	@RequestMapping(value="/selectOndemand")
	public ModelAndView selectOndemand(Integer page,Integer pageSize){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("producttype", 4);
		//查询count
		long count = orderService.getOrderCount(map);
		Page pages = new Page(count, page, pageSize);
		PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List list = orderService.getOrders(map);
		reqMap.put("list", list);
		reqMap.put("pageInfo", pageInfo);
		return new ModelAndView("/web/usercenter/personalCenter/ondemand",reqMap);
	}
	
	
	/**
	 * 个人中心-我的订单列表
	 * @param page
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value="/selectPersonalOrders")
	public ModelAndView selectPersonalOrders(Integer page,Integer pageSize,Integer orderStatus){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("orderStatus", orderStatus);
		//查询count
		long count = sqlSession.selectOne("orderCartDao.selOrderCount", map);
		Page pages = new Page(count, page, pageSize);
		PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		//列表
		List<Map<String,Object>> list = sqlSession.selectList("orderCartDao.selOrderList", map);
		try {
			if(list.size()>0){
				Map<String,Object> paramap=new HashMap<String, Object>();
				for (int i = 0; i < list.size(); i++) {
					Map orderInfo = list.get(i);
					String orderId = orderInfo.get("orderId")+"";
					int orderstatus = DataConvert.ToInteger(orderInfo.get("orderstatus"));
					List<Map<String,Object>> itemList = sqlSession.selectList("orderCartDao.selOrderItem", orderId);

					pathService.getAbsolutePath(itemList, "productpic","itemImg");
					
					if(itemList!=null&&!itemList.isEmpty()){
						
						List<Integer> itemIdList=itemList.stream().map(f->{ return DataConvert.ToInteger(f.get("itemId"));}).distinct().collect(Collectors.toList());
						paramap.put("idList", itemIdList);
						//获取活动赠送的商品列表
						Map<Integer, List<Map>> groupMap=new HashMap<Integer,List<Map>>();
						List<Map<String,Object>>productList=sqlSession.selectList("orderCartDao.selOrderItemListForZs",paramap);
						pathService.getAbsolutePath(productList, "productpic");
						if(productList!=null&&!productList.isEmpty()) {
							groupMap=productList.stream().collect(Collectors.groupingBy(f->DataConvert.ToInteger(f.get("desc")),Collectors.toList()));
						}
						Map<String,Object> disMap =new HashMap<String, Object>();
						for (Map item : itemList) {
							if(orderstatus==1) {//代付款的看是否参与了限时特价
								disMap.put("productId", item.get("productid"));
								Integer type = DataConvert.ToInteger(item.get("producttypes"));
								if(type==2) {
									disMap.put("type", 1);
								}else if(type==4) {
									disMap.put("type", 3);
								}else if(type==8) {
									disMap.put("type", 4);
								}else if(type==16) {
									disMap.put("type", 2);
								}
								/*Double yuanPrice=0.00;
								if(type==2 || type==16){//查询原价
									yuanPrice = sqlSession.selectOne("discountPriceDao.selBookYuanPrice",disMap);
								}else if(type==4 || type==8){
									yuanPrice = sqlSession.selectOne("discountPriceDao.selOndemandPrice",disMap);
								}*/
								Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
								//修改订单子项价格
								item.put("buyprice", disPrice);
								sqlSession.update("orderCartDao.updOrderitemPrice",item);
								item.put("orderId", orderId);
								sqlSession.update("orderCartDao.updOrdertotalPrice",item);
							}
							//添加对应的赠送的商品
							item.put("buySendList",groupMap.get(DataConvert.ToInteger(item.get("itemId"))));
						}
					}
					orderInfo.put("itemList", itemList);
				}
				
				reqMap.put("result", 1);
				reqMap.put("msg", "获取数据成功！");
			}else{
				reqMap.put("result", 1);
				reqMap.put("msg", "获取数据失败,暂无订单！");
			}
		}catch (Exception e) {
			reqMap.put("result", 0);
			reqMap.put("msg", "获取数据失败！");
		}
		reqMap.put("data", list);
		reqMap.put("pageInfo", pageInfo);
		reqMap.put("orderType", orderStatus);
		return new ModelAndView("/web/usercenter/orders/partOrders",reqMap);
	}
	
	/**
	 * 个人中心 - 订单详情
	 */
	@RequestMapping(value = "/orderDetail")
	public ModelAndView orderDetail(Integer orderId, String status) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		// 查询订单详情
		int userId = DataConvert.ToInteger(session.getAttribute("PCuserId"));
		reqMap = orderService.selectOrderDetail(userId, orderId);
		reqMap.put("status", status);
		return new ModelAndView("/web/usercenter/orders/orderDetails", reqMap);
	}
	/**
	 * 点击跳转确认收货
	 * @param orderId
	 * @param type
	 * @return
	 */
	@RequestMapping(value = "oDetail")
	@ResponseBody
	public ModelAndView oDetail(Integer orderId, Integer type) {
		Integer userid = (Integer) session.getAttribute("PCuserId");
		Map map = new HashMap();
		map.put("orderId", orderId);
		map.put("type", type);
		map.put("data", orderService.getInvoiceList(userid, orderId, type - 1));
		return new ModelAndView("web/usercenter/orders/confirmReceipt", map);
	}
	
	/**
	 * 点击确认发货
	 * @param orderId
	 * @param invoiceId
	 * @return
	 */
	@RequestMapping(value = "upOStatus")
	@ResponseBody
	public Map<String,Object> upOStatus(int orderId, String invoiceId) {
		Integer userId = (Integer) session.getAttribute("PCuserId");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("orderId", orderId);
		map = orderService.orderConfirm(userId, invoiceId, orderId);
		return map;
	}
	
}
