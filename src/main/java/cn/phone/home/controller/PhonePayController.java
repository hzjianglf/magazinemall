package cn.phone.home.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.converters.DateConverter;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.Pay.provider.PayResult;
import cn.Pay.service.payService;
import cn.api.service.AccountService;
import cn.api.service.OrderService;
import cn.api.service.ProductService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.UtilDate;

@UserValidate
@Controller
@RequestMapping(value="/phone/pay")
public class PhonePayController {

	
	@Autowired
	ProductService productService;
	@Autowired
	AccountService accountService;
	@Autowired
	HttpSession session;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	OrderService orderService;
	@Autowired
	payService payService;
	
	/**
	 * 生成订单接口
	 * @return
	 */
	@RequestMapping(value="/generateOrder")
	@ResponseBody
	public Map<String, Object> generateOrder(@RequestParam Map<String, Object> map){
		Map<String, Object> orderMap = new HashMap<String, Object>();
		
		String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
		String threeRandom = UtilDate.getThree();//三维随机数
		
		//判断商品类型	实物1，期刊2，点播4，直播8
		if("1".equals(map.get("producttype")+"")){//实物
			//查询实物商品
			
		}else if("16".equals(map.get("producttype")+"")){
			
		}else if("4".equals(map.get("producttype")+"")){//点播 
			//查询课程价格
			orderMap = productService.selectOndemandPrice(map.get("productId")+"");
		}else if("8".equals(map.get("producttype")+"")){
			//直播
			orderMap = productService.selectOndemandPrice(map.get("productId")+"");
		}
		
		
		Map<String, Object> info = new HashMap<String, Object>();
		info.put("addressId", map.get("addressId"));//标识后面是否需要计算运费
		int isSum = sqlSession.selectOne("productDao.selSubTypeByid",map);
		if(isSum==1){
			info.put("subType",2);
		}else{
			info.put("subType", 1);
		}
		//判断是否需要添加收货地址
		if(null!=DataConvert.ToInteger(map.get("addressId")) && 0!=DataConvert.ToInteger(map.get("addressId"))){
			Map addressInfo = sqlSession.selectOne("productDao.selAddressInfo",map.get("addressId")+"");
			if(addressInfo!=null) {
				info.put("receivername", DataConvert.ToString(addressInfo.get("receiver")));
				info.put("receiverphone", DataConvert.ToString(addressInfo.get("phone")));
				info.put("receiverProvince", DataConvert.ToString(addressInfo.get("province")));
				info.put("receiverCity", DataConvert.ToString(addressInfo.get("city")));
				info.put("receiverCounty", DataConvert.ToString(addressInfo.get("county")));
				info.put("receiverAddress", DataConvert.ToString(addressInfo.get("detailedAddress")));
			}
		}
		//商品名称、商品图片
		info.put("productname", orderMap.get("name")+"");
		info.put("productpic", orderMap.get("picUrl")+"");
		//商品数量
		info.put("count", 1);
		//订单信息
		info.put("productId", map.get("productId")+"");
		info.put("orderno", ymds+threeRandom);
		info.put("price", orderMap.get("originalPrice")+"");
		info.put("buyprice", orderMap.get("presentPrice")+"");
		double totalPrice=DataConvert.ToDouble(orderMap.get("presentPrice"));
		if(DataConvert.ToInteger(info.get("addressId"))>0){
			Map<String, Object> postageByOndemand = productService.getPostageByOndemand(DataConvert.ToInteger(info.get("userId")), DataConvert.ToInteger(info.get("productId")),DataConvert.ToInteger(info.get("producttype")),DataConvert.ToInteger(info.get("addressId")));
			info.put("postage", postageByOndemand.get("data"));
			totalPrice+=DataConvert.ToDouble(postageByOndemand.get("data"));
		}
		double payPrice=totalPrice;
		//判断是否使用优惠券
		if(null!=map.get("couponId") && DataConvert.ToInteger(map.get("couponId"))>0){
			Double price = sqlSession.selectOne("productDao.selPriceByCid",map);
			payPrice = totalPrice-DataConvert.ToDouble(price);
			info.put("couponId", map.get("couponId"));
			info.put("couponprice", price);
		}
		//判断是否使用代金券
		if(null!=map.get("voucherId") && DataConvert.ToInteger(map.get("voucherId"))>0){
			Double price = sqlSession.selectOne("productDao.selPriceByVoucherId",map);
			payPrice = payPrice-DataConvert.ToDouble(price);
			info.put("voucherId", map.get("voucherId"));
			info.put("voucherprice", price);
		}
		info.put("totalprice", totalPrice);
		info.put("payPrice", payPrice);
		if(payPrice<=0) {
			payPrice=0;
		}
		orderMap.put("totalPrice", payPrice);
		// 需要修改userId
		String userId = "";
		if(!StringUtils.isEmpty(map.get("userId"))){
			userId=map.get("userId")+"";
		}else{
			userId=session.getAttribute("userId")+"";
		}
		info.put("userId", userId);
		info.put("ordertype", map.get("producttype")+"");
		int row = orderService.generateOrder(info);
		if(row > 0){
			orderMap.put("success", true);
			orderMap.put("paylogId", info.get("paylogId")+"");
		}else{
			orderMap.put("success", false);
		}
		return orderMap;
	}
	/**
	 * 支付等待页面
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/waittingPay")
	public ModelAndView waittingPay(@RequestParam Map map){
		int payLogId=DataConvert.ToInteger(map.get("paylogId"));
		int payMethodId=DataConvert.ToInteger(map.get("paytype"));
		Map result=payService.orderPay(payLogId, payMethodId);
		
		result.put("footer", false);
		
		return new ModelAndView("/phone/waitForpay/index",result);
	}
	
	/**
	 * 打赏，创建打赏记录
	 * @param contentId 打赏的教师id
	 * @param money	打赏金额
	 * @param remark 备注
	 * @return
	 */
	@RequestMapping(value="/RewardTeacher")
	@ResponseBody
	public Map<String, Object> RewardTeacher(String contentId,double money,String rewardMsg){
		Map<String, Object> map = new HashMap<String, Object>();//reqMap.put("success", true);
		String userId = session.getAttribute("userId")+"";
		map = accountService.addRewardLog(contentId,money,rewardMsg,userId);
		return map;
	}
	
	
}
