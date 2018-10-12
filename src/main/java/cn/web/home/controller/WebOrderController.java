package cn.web.home.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
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

import cn.api.controller.OrderController;
import cn.api.controller.ProductController;
import cn.api.service.AccountService;
import cn.api.service.OrderService;
import cn.api.service.ProductService;
import cn.api.service.SettingService;
import cn.core.UserValidate;
import cn.phone.usercenter.account.controller.PhoneUserCenterAccountController;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@Controller
@RequestMapping("/web/order")
public class WebOrderController {
	@Autowired
	private OrderController orderController;
	@Autowired
	private ProductController phoneOrderController;
	@Autowired
	private OrderService orderService;
	@Autowired
	private AccountService accountService;
	@Autowired
	private ProductService productService;
	@Autowired
	private SettingService settingService;
	@Autowired
	private HttpSession session;
	@Autowired
	SqlSession sqlSession;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	//期刊直接支付
	@RequestMapping("payBookOrder")
	@UserValidate
	public ModelAndView payBookOrder(String orderId,Integer paylogId){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("isDefault", 1);
		map.put("userId", getUserId());
		Map<String, Object> address = accountService.selectIsDefaultAddress(map);
		if(address==null){
			map.put("footer",false);
			return new ModelAndView("/phone/usercenter/addAddress",map);
		}
		Map balance = accountService.selectBalance(getUserId()+"");
		map.put("platformType", 3);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> payMethods = settingService.getPayMethods(map);
		List<Map> list = orderService.payBookOrder(orderId);
		String balan = balance.get("balance")+"";
		address.put("list", list);
		address.put("payMethods", payMethods);
		address.put("balan", balan);
		address.put("price", list.get(0).get("totalprice"));
		address.put("paylogId", paylogId);
		address.put("footer", false);
		return new ModelAndView("phone/home/order/jiesuan",address);
	}
	
	//判断支是否为0支付页面
	@RequestMapping("/judgeCreateOrder")
	@ResponseBody
	public Map<String,Object> judgeCreateOrder (@RequestParam Map<String,Object> map){
		String userId = DataConvert.ToString(getUserId());
		
		Map<String,Object> result = new HashMap<String,Object>();
		
		result.put("success", 0);
		result.put("msg", "支付失败");
		
		if(userId==null) {
			return result;
		}
		
		String addressId = DataConvert.ToString(map.get("addressId"));
		String shopCartIds = DataConvert.ToString(map.get("shopCartIds"));
		Integer couponId = DataConvert.ToInteger(map.get("couponId"));
		Integer voucherId =DataConvert.ToInteger(map.get("voucherId"));
		
		result = phoneOrderController.addOrderInfo(userId, addressId, shopCartIds, couponId, voucherId);
		return result;
	}
	
	//去支付页面
	@RequestMapping(value="/toCreateOrder")
	public ModelAndView toCreateOrder (@RequestParam Map<String,Object> map) {
		
		String url = DataConvert.ToString(map.get("url"));
		
		if(url==null||url=="") {
			url = "/phone/home/index";
		}
		
		Integer orderId = DataConvert.ToInteger(map.get("orderId"));
		int userId = getUserId();
		if(userId==0) {
			return new ModelAndView("/web/usercenter/account/index");
		}
		String mapPrice = DataConvert.ToString(map.get("totalPrice"));
		if(mapPrice!=null&&mapPrice!="") {
			map.put("price", mapPrice+"");
		}
		
		if(orderId!=0&&orderId!=null) {
		
			Map<String, Object> reqMap = new HashMap<String, Object>();
			// 查询订单详情
			reqMap = orderService.selectOrderDetail(userId, orderId);
			
			if(reqMap==null) {
				return null;
			}
			List<Map<String,Object>> list = (List<Map<String, Object>>) reqMap.get("data");
			if(list!=null) {
				for (Map<String, Object> map2 : list) {
					Double price = DataConvert.ToDouble(DataConvert.ToString(map2.get("payprice")));
					map.put("price", price+"");
				}
				
			}
		}
		
		Map balance = accountService.selectBalance(userId+"");
		map.put("platformType", 3);
		String openId=DataConvert.ToString(session.getAttribute("openId"));
		if(!StringUtils.isEmpty(openId)){
			map.put("platformType", 5);
		}
		List<Map<String,Object>> payMethods = settingService.getPayMethods(map);
		String balan = DataConvert.ToString(balance.get("balance"));
		//比较大小
		boolean pricePVbalan = true;
		Double pricedisplay = DataConvert.ToDouble(DataConvert.ToString(map.get("price")));
		Double balancedisplay = DataConvert.ToDouble(balan);
		if(pricedisplay>balancedisplay) {
			pricePVbalan = false;
		}
		map.put("pricePVbalan", pricePVbalan);
		map.put("payMethods", payMethods);
		map.put("balan", balan+"");
		return new ModelAndView("web/home/order/zhifu",map);
	}
	
	//支付生成paylogId
	@RequestMapping("createOrder")
	@ResponseBody
	public Map<String,Object> createOrder(@RequestParam Map map){
		Map<String,Object> result =new HashMap<String, Object>();
		map.put("userId", session.getAttribute("PCuserId"));
		//筛选出是期刊的购物车项
		List<Map> list = productService.selBookIds(map.get("shopCartIds")+"");
		if(null!=list && list.size()>0){
			String ids = "";
			for (Map maps : list) {
				String id = DataConvert.ToString(maps.get("id"));
				id+=",";
				ids+=id;
			}
			int count = productService.selIsState(ids);
			if(count==0){
				result.put("result", 0);
				result.put("msg", "有已下架的商品！");
				return result;
			}
		}
		Map maps = productService.addOrderInfo(map);
		if(DataConvert.ToInteger(maps.get("paylogId"))==0){
			result.put("result", 0);
			result.put("msg", "生成订单失败");
			return result;
		}
		result.put("paylogId", maps.get("paylogId"));
		result.put("paytype",map.get("paytype"));
		result.put("result", 1);
		return result;
	}
	//跳转结算页
	@RequestMapping("turnJieSuan")
	public ModelAndView turnJieSuan(@RequestParam Map<String,Object> map2){
		int userId = getUserId();
		String shoppingIds = DataConvert.ToString(map2.get("shoppingIds"));
		Integer addressId = 0;
		//返回页面的数据
		Map<String, Object> result = new HashMap<String ,Object>();
		
		Map<String,Object> map =new HashMap<String, Object>();
		map.put("userId", userId);
		List<Integer> id = StringHelper.ToIntegerList(shoppingIds);
		map.put("list", id);
		//TODO
		Map<String,Object> listMap = orderService.getShopCartByIds(map);
		List<Map<String,Object>> list = (List<Map<String, Object>>) listMap.get("list");
		/*double price = 0;
		boolean flag = false;
		
		if(list.size()>0) {
			for (Map<String, Object> subShopCart : list) {
				price+=(DataConvert.ToDouble(subShopCart.get("buyprice"))*DataConvert.ToInteger(subShopCart.get("count")));
				if(DataConvert.ToString(subShopCart.get("producttype")).equals("2")){
					flag=true;
				}
			}
		}*/
		BigDecimal price = new BigDecimal("0");
		BigDecimal buyprice = new BigDecimal("0");
		BigDecimal count = new BigDecimal("0");
		boolean flag = false;
		if(list.size()>0) {
			for (Map<String, Object> subShopCart : list) {
				buyprice = new BigDecimal(subShopCart.get("buyprice").toString());
				count = new BigDecimal(subShopCart.get("count").toString());
				price = price.add(buyprice.multiply(count));
				if(DataConvert.ToString(subShopCart.get("producttype")).equals("2")){
					flag=true;
				}
			}
		}
		
		
		List<Map<String, Object>> address = new ArrayList<Map<String, Object>>();
		if(flag){
			address = accountService.selAddressList(userId);
			for (Map<String, Object> map3 : address) {
				if(map3.get("isDefault").equals(1)) {
					addressId = DataConvert.ToInteger(map3.get("Id"));
				}
			}
		}
		Map<String,Object> yunfei = new HashMap<String, Object>();
		if(addressId > 0) {
			//获取运费(购物车id shoppingIds, 用户 id userId, 地址id addressId,)
			yunfei = orderService.getPostage(shoppingIds,addressId,userId);
		}
		/**
		 * 获取优惠券列表  
		 * 	type 商品类型2期刊 3点播 4直播
		 * 	productId 商品id期刊是购物车项的id多个,号间隔 
		 */
		Map<String,Object> couponsDataList = getCouponsByType(2,shoppingIds);
		
		/**
		 * 获取代金券列表  
		 * 	type 商品类型2期刊 3点播 4直播
		 * 	productId 商品id期刊是购物车项的id多个,号间隔 
		 */
		Map<String,Object> voucherDataList = getVoucherByType(2,shoppingIds);
		
		result.put("yunfei", yunfei.get("data"));
		result.put("id", addressId);
		result.put("address", address);
		result.put("list", list);
		result.put("price", price);
		result.put("ids", shoppingIds);
		result.put("couponsDataList",couponsDataList);
		result.put("voucherDataList", voucherDataList);
		return new ModelAndView("web/home/order/placeOrder",result);
	}
	
	//动态计算运费
	@RequestMapping("calculationYunfei")
	@ResponseBody
	public Map<String, Object> calculationYunfei(String ids , Integer addressId){
		Integer userId = getUserId();
		Map<String, Object> result = new HashMap<String, Object>();
		result = orderService.getPostage(ids,addressId,userId);
		return result;
	}
	
	//跳转购物车列表
	@RequestMapping("turnShopcart")
	public ModelAndView turnaddCart(){
		Map<String,Object> result=new HashMap<String, Object>();
		return new ModelAndView("/web/home/order/shopCart",result);
	}
	
	//代金券减
	@RequestMapping(value="/getVoucherByType")
	@ResponseBody
	public Map<String,Object> getVoucherByType(Integer type , String productId){
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> map = new HashMap<String,Object>();
		
		Integer userId = getUserId();
		if(userId<1) {
			return result;
		}
		
		map.put("userId", userId);
		map.put("type", type);
		map.put("productId", productId);
		result=accountService.getVoucherByType(map);
		
		return result;
	}
	//通过商品类型和id获取对应的优惠券
	@RequestMapping("/getCouponsByType")
	public Map<String,Object> getCouponsByType(Integer type , String productId){
		Map<String,Object> parmap = new HashMap<String,Object>();
		parmap.put("userId", getUserId());
		parmap.put("type", type);
		parmap.put("productId", productId);
		return accountService.getCouponsByType(parmap);
	}
	//通过（购物车id，用户id，代金券id）获取减免的价格
	@RequestMapping(value="/catPrice")
	@ResponseBody
	public Map<String,Object> catPrice(@RequestParam String shopCartIds, Integer voucherId , Integer addressId){
		Integer userId = getUserId();
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("success", false);
		if(shopCartIds==""||shopCartIds==null) {
			result.put("msg", "购物车错误");
			return result;
		}
		if(userId==0||userId==null) {
			result.put("msg", "该用户未登录");
			return result;
		}
		if(voucherId==0||voucherId==null) {
			result.put("msg", "地址获取错误");
			return result;
		}
		if(addressId==null) {
			addressId = 0;
		}
		result.put("success", true);
		result.putAll(orderController.getVoucherprice(shopCartIds, userId, voucherId , addressId));
		result.put("msg", "获取成功");
		
		return result;
	}
	
	//分页查询购物车
	@RequestMapping("/shopcartList")
	@ResponseBody
	public  Map<String,Object> shopcartList(@RequestParam Map<String,Object> map , int page, int limit){
		Integer userId = getUserId();
		List<Object> list = new ArrayList<Object>();
		long count = orderService.getShopCartCount(userId);
		Page page2 = new Page(count, page, limit);
		map.put("start", page2.getStartPos());
		map.put("pageSize", limit);
		map.put("userId", userId);
		list = orderService.getShopCartList(map);
		map.put("data", list);
		map.put("count", count);
		map.put("msg", "");
		map.put("code", 0);
		return map;
	}
	//修改购物车数量和价格
	@RequestMapping("/changeShopCart")
	@ResponseBody
	public Map<String,Object> changeShopCart(Integer id,Integer count){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("shopCartId", id);
		map.put("ncount", count);
		return orderService.changeShopCart(map);
	}
	//删除购物车
	@RequestMapping("delShopCartItem")
	@ResponseBody
	public Map<String,Object> delShopCartItem(String ids){
		Map<String,Object> map = new HashMap<String,Object>();
		int userId=getUserId();
		return orderService.deleteCarItem(userId,ids);
	}

}
