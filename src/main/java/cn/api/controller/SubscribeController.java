package cn.api.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.Pay.service.payService;
import cn.api.service.ActivityService;
import cn.api.service.ProductService;
import cn.phone.home.controller.PhonePayController;
import cn.util.DataConvert;

/**
 * 课程订阅接口
 *
 */
//@Sign
@Api(tags={"课程订阅的接口"})
@RestController
@RequestMapping("/api/ondemand")
public class SubscribeController {
	
	@Autowired
	PhonePayController phonePayController;
	@Autowired
	payService payService;
	@Autowired
	private ActivityService activityService;
	@Autowired
	private ProductService productService;
	/**
	 * 课程查询运费的接口
	 */
	@RequestMapping(value="/getPostageByOndemand")
	@ApiOperation(value="通过课程id和地址id获取运费",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="productId",value="课程id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="producttype",value="商品类型(产品类型：点播4，直播8)",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="addressId",value="地址id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data=运费}")
	})
	public Map<String,Object> getPostageByOndemand(Integer userId,Integer productId,Integer producttype,Integer addressId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null==userId||null==productId||null==producttype||addressId==null){
			map.put("msg", "参数错误");
			return map;
		}
		return productService.getPostageByOndemand(userId,productId,producttype,addressId);
	}
	/**
	 * 课程订阅接口
	 * @param productId
	 * @param producttype
	 * @param paytype
	 * @param payMethodName
	 * @return
	 */
	@RequestMapping(value="/buyOndemand")
	@ApiOperation(value="课时订阅生成订单接口",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="productId",value="商品id(根据购买的类型区分id,)",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="producttype",value="商品类型(产品类型：点播4，直播8)",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="couponId",value="优惠券id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="voucherId",value="代金券id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="addressId",value="地址id",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={paylogId='支付记录id，为0则代表支付成功无需再进行支付',totalPrice='价格'}}")
	})
	public Map<String, Object> buyOndemand(Integer userId,Integer productId,Integer producttype,Integer voucherId,Integer couponId,Integer addressId){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		
		try {
			if(userId==null || productId==null || producttype==null){
				return reqMap;
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("productId", productId);
			map.put("producttype", producttype);
			map.put("voucherId", voucherId);
			map.put("couponId", couponId);
			//判断此商品是否需要添加地址
			int classtype=3;
			if(producttype==8){
				classtype=4;
			}
			if(addressId==null) {
				List<Map>buySiSongList=activityService.getBuyJiSongList(productId,classtype);
				int isAddress=0;
				//查询赠送商品是否包含需要发货的赠品
				if(buySiSongList!=null && !buySiSongList.isEmpty()) {
					
					List<Integer> buyJiSongIds=buySiSongList.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
					
					//获取活动赠送的商品列表
					List<Map>productList=activityService.getSendListForBuyJiSong(buyJiSongIds);
					if(productList!=null&&!productList.isEmpty()) {
						for (Map sub : productList) {
							if(1==DataConvert.ToInteger(sub.get("productType"))){
								isAddress=1;
								break;
							}
						}
						
					}
				}
				if(isAddress==1&&addressId==null){
					reqMap.put("msg", "赠品有需要发货的商品,请添加收货地址");
					return reqMap;
				}
			}
			map.put("addressId", addressId);
			Map<String, Object> order = phonePayController.generateOrder(map);
			reqMap.put("result", 1);
			reqMap.put("msg", "订阅成功!");
			reqMap.put("data", order);
		} catch (Exception e) {
			e.printStackTrace();
			reqMap.put("msg", "请求失败");
		}
		
		return reqMap;
	}
	
	/**
	 * 确认支付接口
	 */
	@RequestMapping(value="/confirmPay")
	@ApiOperation(value="课时订阅确认支付接口",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="paylogId",value="支付记录id",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="paytype",value="支付方式id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={payResult='支付结果'}}")
	})
	public Map<String, Object> confirmPay(String paylogId,String paytype){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		try {
			Map<String, Object> data =payService.orderPay(DataConvert.ToInteger(paylogId), DataConvert.ToInteger(paytype));
			
			if(DataConvert.ToBoolean(data.get("success"))) {
				reqMap.put("data", data);
				reqMap.put("result", 1);
				reqMap.put("msg", "支付成功!");
			}else{
				reqMap.put("data", data);	
				reqMap.put("result", 0);
				reqMap.put("msg", "支付失败");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败,"+e.getMessage());
		}
		return reqMap;
	}
	

}
