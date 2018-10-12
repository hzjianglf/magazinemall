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

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import cn.api.service.ActivityService;
import cn.api.service.OrderService;
import cn.api.service.PathService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@Api(tags={"订单操作的接口"})
@RestController
//@Sign
@RequestMapping("/api/order")
public class OrderController {

	@Autowired
	private OrderService orderService;
	@Autowired
	PathService pathService;
	@Autowired
	private ActivityService activityService;
	@Autowired
	SqlSession sqlSession;
	/**
	 * 通过勾选代金券获取当前购物车项的价格
	 */
	@RequestMapping(value="/getVoucherprice")
	@ApiOperation(value="通过购物车项ids和代金券id获取应减金额的接口",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="shopCartIds",value="购物车id多个用,号间隔",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="voucherId",value="代金券id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="addressId",value="如果有发货的商品需传入地址id",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data='应减免的金额'}")
	})
	public Map<String,Object> getVoucherprice(String shopCartIds,Integer userId, Integer voucherId,Integer addressId){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", 0);
		if(shopCartIds==null || voucherId==null ||userId==null){
			result.put("msg", "参数错误");
			return result;
		}
		try {
			//查询是否有发货的商品
			double postagePrice = 0;
			if(!StringUtils.isEmpty(addressId)){
				Map addressInfo = sqlSession.selectOne("productDao.selAddressInfo",addressId+"");
				if(addressInfo!=null) {
					Map<String, Object> postage = orderService.getPostage(shopCartIds,addressId, userId);
					postagePrice = DataConvert.ToDouble(postage.get("data"));
				}
			}
			result = orderService.getVoucherprice(shopCartIds,voucherId,userId,postagePrice);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取数据失败");
		}
		return result;
	}
	/**
	 * 通过商品获取运费
	 */
	@RequestMapping(value="/getPostage")
	@ApiOperation(value="通过购物车项ids和地址获取运费的接口",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="shopCartIds",value="购物车id多个用,号间隔.注意如果有赠送的购物车项的id也要加进去",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="addressId",value="地址的id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data='运费'}")
	})
	public Map<String,Object> getPostage(String shopCartIds,Integer userId, Integer addressId){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", 0);
		if(shopCartIds==null || addressId==null ||userId==null){
			result.put("msg", "参数错误");
			return result;
		}
		try {
			 result = orderService.getPostage(shopCartIds,addressId,userId);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取运费失败");
		}
		return result;
	}
	
	/**
	 * 查询是否有买赠的商品
	 */
	@RequestMapping(value="/isHasMaizeng")
	@ApiOperation(value="查询买赠商品列表 ",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="productId",value="商品id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="productType",value="商品类型 1:纸质期刊 3:点播课程 4:直播课程 5:商品",dataType="int",required=true,paramType="query"),
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data='list[productname='赠送商品名称',price'赠送商品的原价',productType='赠送商品类型1:纸质期刊 3:点播课程 4:直播课程 5:商品']'}")
	})
	public Map<String,Object> isHasMaizeng(Integer productId,Integer productType){
		Map<String,Object> result = new HashMap<String, Object>();
		if(productId==null|| productType==null){
			result.put("result", 0);
			result.put("msg", "传入参数错误");
			return result;
		}
		try {
			List<Map>buyJiSongList=activityService.getBuyJiSongList(productId,productType);
			List<Integer> buyJiSongIds=buyJiSongList.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
			//获取活动赠送的商品列表
			List<Map>productList=activityService.getSendListForBuyJiSong(buyJiSongIds);
			result.put("data",productList);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取数据失败");
		}
		return result;
	}
	/**
	 * 加入购物车
	 * @param 商品id productid 
	 * @param 用户id userId
	 * @param 商品数量 count 
	 * @param 商品类型 producttype 实物1，期刊2
	 * @param 商品图片 productpic
	 * @param 商品名称 productname
	 * @param 期次 用“，”间隔  desc
	 * @return
	 */
	@RequestMapping(value="/createCardShop")
	@ApiOperation(value="加入购物车 ",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="productid",value="商品id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="count",value="商品数量",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="producttype",value="商品类型实物1，期刊2,电子书16",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="productpic",value="商品图片",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="productname",value="商品名称",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="desc",value="期次 用“，”间隔",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="购买方式 0加入购物车 1直接购买",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="subType",value="购买类型1单期2上半年3下半年4全年",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data='加入购物车后的id'}")
	})
	public Map createCardShop(Integer productid ,Integer userId,Integer count,String productpic,String productname,
			Integer producttype,String desc,Integer type,Integer subType){
		Map paramMap = new HashMap();
		Map result = new HashMap();
		if(null == productid){
			result.put("result", 0);
			result.put("msg", "传入商品信息错误");
		}
		if(null == userId){
			result.put("result", 0);
			result.put("msg", "传入用户信息错误");
		}
		if(type==null){
			result.put("result", 0);
			result.put("msg", "请输入购买方式");
		}
		if(subType==null){
			result.put("result", 0);
			result.put("msg", "请输入购买类型");
		}
		if(null == count){
			result.put("result", 0);
			result.put("msg", "传入商品数量错误");
		}
		if(null == producttype){
			result.put("result", 0);
			result.put("msg", "传入商品类型错误");
		}
		//只有纸质书可以加入购物车
		if(producttype==4 || producttype==8){
			result.put("result", 0);
			result.put("msg", "类型错误!");
			return result;
		}
		if(null==type || subType==null || desc==null || productpic==null || productname==null){
			result.put("result", 0);
			result.put("msg", "参数错误!");
			return result;
		}
		paramMap.put("productid", productid);
		paramMap.put("producttype", producttype);
		paramMap.put("productpic", productpic);
		paramMap.put("productname", productname);
		paramMap.put("userId", userId);
		paramMap.put("count", count);
		paramMap.put("price", 0);
		paramMap.put("buyprice", 0);
		paramMap.put("desc", desc);
		paramMap.put("type", type);
		paramMap.put("subType", subType);
		return orderService.createCardShop(paramMap);
	}
	/**
	 * 获取用户的购物车列表
	 * @param userId 用户id
	 * @param pageNow 当前页数
	 * @param pageSize 一页显示的记录数 
	 * return
	 * 购物车id  id,
	 * 商品id  productid,
	 * 商品名字 productname,
	 * 商品图片 productpic,
	 * 购买的期次   names, 展示格式(第一期,第二期,)
	 * 数量  count,
	 * 价格  price,
	 * 购买价格  buyprice 
	 * 类型 producttype,
	 */
	@RequestMapping(value="/getShopCart")
	@ApiOperation(value="获取用户购物车列表 ",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="每页显示记录数",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='购物项id',productid='商品id',productname='商品名字',productpic='商品图片'"
				+ ",names='购买的期次展示格式(第一期,第二期)',count='数量',price='价格',buyprice='购买价格',subType='1单期2上半年3下半年4全年5赠品',producttype='类型实物1，期刊2，电子书16'"
				+ "buySendList=[{productid='商品id',productpic='商品图片',price='商品价格',producttype='商品类型2期刊4课程',count='数量'}]}}")
	})
	public Map<String,Object> getShopCart(Integer userId,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("result", 0);
		try {
			if(null==userId){
				map.put("msg", "请输入客户id");
				return map;
			}
			if(null==pageNow || pageNow<1){
				pageNow=1;
			}
			if(null==pageSize|| pageSize<0){
				pageSize=10;
			}
			long count = orderService.getShopCartCount(userId);
			Page page = new Page(count,pageNow,pageSize);
			int startPos = page.getStartPos();
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			paramap.put("start", startPos);
			paramap.put("pageSize", pageSize);
			List list = orderService.getShopCartList(paramap);
			map.put("totalPage", page.getTotalPageCount());
			map.put("pageNow", pageNow);
			map.put("data", list);
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg",e.getMessage()+ "获取列表失败");
		}
		return map;
	}
	/**
	 * 购物车更改数量和价格
	 * @param 购物车id shopCartId
	 * @param 修改后的数量 ncount
	 * return
	 * price 改变后的价格
	 * shopCartId 改变的购物车项id
	 */
	@RequestMapping("changeShopCart")
	@ResponseBody
	@ApiOperation(value="购物车更改数量和价格",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="shopCartId",value="购物车子项的id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="ncount",value="改变后的数量",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={price='改变后的价格',shopCartId='改变的购物车项id'}}")
	})
	public Map<String,Object> changShopCart(Integer shopCartId,Integer ncount){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("result", 0);
		if(null==shopCartId || ncount==null){
			map.put("msg", "传入参数错误");
			return map;
		}
		Map<String,Object> paramap = new HashMap<>();
		paramap.put("shopCartId", shopCartId);
		paramap.put("ncount", ncount);
		return orderService.changeShopCart(paramap);
	}
	/**
	 * 通过购物车ids获取购物车的详细信息
	 * 
	 */
	@RequestMapping("getShopCartByIds")
	@ResponseBody
	@ApiOperation(value="通过购物车ids获取信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="ids",value="购物车项的id多个用,间隔",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={isAddress='是否需要添加地址0否1是',list = [id='购物项id',productid='商品id',productname='商品名字',productpic='商品图片'"
				+ ",names='购买的期次展示格式(第一期,第二期)',count='数量',price='价格',buyprice='购买价格',subType='1单期2上半年3下半年4全年5赠品',producttype='类型实物1，期刊2，电子书16'}]}")
	})
	public Map<String,Object> getShopCartByIds(String ids,Integer userId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(ids==null || null==userId){
				map.put("msg", "传入参数错误");
				return map;
			}
			Map<String,Object> maps = new HashMap<String, Object>();
			List<Integer> id = StringHelper.ToIntegerList(ids);
			maps.put("list", id);
			maps.put("userId", userId);
			Map<String,Object> result = orderService.getShopCartByIds(maps);
			map.put("data", result);
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg", "获取失败"+e.getMessage());
		}
		return map;
	}
	/**
	 * 通过已购电子书订单项的id查询多期的电子书列表
	 * 
	 */
	@RequestMapping("getEbookListById")
	@ResponseBody
	@ApiOperation(value="通过已购电子书订单项的id查询多期的电子书列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="itemId",value="订单项的id",dataType="int",required=true,paramType="query"),
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='期次的id',name='期刊名字',year='年份',describes='描述第几期'"
				+ ",productpic='图片地址',status='当前期次有无电子书0无。大于0有'}}")
	})
	public Map<String,Object> getEbookListById(Integer itemId){
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("result", 0);
		if(null==itemId){
			result.put("msg", "参数错误");
			return result;
		}
		try {
			List list = orderService.getEbookListById(itemId);
			pathService.getAbsolutePath(list, "productpic");
			result.put("result", 1);
			result.put("data", list);
			result.put("msg", "获取成功");
		} catch (Exception e) {
			result.put("msg", "获取失败");
		}
		return result;
	}
	/**
	 * 获取用户已购列表
	 * @param producttype 实物1，期刊2，点播4，直播8
	 * @param userId
	 * return 
	 * orderId 总订单的Id
	 * id   订单项的id
	 * productid 商品的id
	 * producttype 商品类型 实物1，期刊2，点播4，直播8，电子书16
	 * productpic 商品的图片地址
	 * productname 商品的名字
	 * buyprice 购买价格
	 * price 价格
	 * deliverstatus 运单的状态（0未发货1已发货2部分发货3已完成）
	 * 点播会有专家信息  userName专家姓名 userUrl专家头像
	 * desc 期次的id(期刊详情或期刊电子书查看时用到的id)
	 * subType 期刊的分类（纸质和电子）1单期2上半年3下半年4全年
	 * pname 如果是期刊的而且是单期的  期刊名字
	 */
	@RequestMapping("getOrders")
	@ResponseBody
	@ApiOperation(value="获取用户已购列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="producttype",value="实物1，期刊2，点播4，直播8，电子书16",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='子订单的id',orderId='总订单的id',productid='商品的id',producttype='商品的类型实物1，期刊2，点播4，直播8，电子书16'"
				+ ",productpic='图片地址',productname='商品名称',count='数量',desc='期次的id(期刊详情或期刊电子书查看时用到的id)',subType='期刊的分类（纸质和电子）1单期2上半年（也代表课程合集）3下半年4全年5则是赠品(isPresentSign 1为赠品下合集标识,不等于1,就是赠品下的单期)'}}")
	})
	public Map<String,Object> getOrders(Integer producttype,Integer userId,Integer page,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> parmap = new HashMap<String, Object>();
		map.put("result", 0);
		if(producttype==null||null==userId){
			map.put("msg", "参数错误");
			return map;
		}
		
		boolean flag=false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			
			flag=true;
			parmap.put("start", start);
			parmap.put("pageSize", pageSize);
		}
		parmap.put("producttype", producttype);
		parmap.put("userId", userId);
		List<Map<String,Object>> list = orderService.getOrders(parmap);
		
		pathService.getAbsolutePath(list, "productpic");
		map.put("result", 1);
		map.put("data", list);
		map.put("msg", "获取成功!");
		if(flag){
			long count = orderService.getOrderCount(parmap);
			int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
			map.put("totalPage", totalPage);
			map.put("currentPage", page);
		}
		return map;
	}
	
	/**
	 * 购物车删除子项
	 */
	@RequestMapping(value="/deleteCarItem")
	@ApiOperation(value="购物车删除子项",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户ID",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="ids",value="要删除的订单子项id 用，间隔",dataType="string",required=true,paramType="query")
	})
	public Map<String, Object> deleteCarItem(Integer userId,String ids){
		Map<String,Object> reqMap = new HashMap<String, Object>();
		reqMap = orderService.deleteCarItem(userId,ids);
		return reqMap;
	}
	
	/**
	 * @author LiTonghui
	 * 获取用户的订单列表
	 */
	@RequestMapping(value="/getUserOrderList")
	@ApiOperation(value="获取用户的订单列表(个人中心)",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户ID",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="orderStatus",value="订单状态（-1全部 1待付款 5已完成 6已取消）",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={orderId='订单id',itemId='订单项id',orderno='订单编号',productname='商品名称',"
				+ "productpic='商品图片',totalprice='订单总价格包含运费',payprice='支付金额',isHasInvoice='是否有收货0没有，其他有',count='购买数量',goodsType='商品分类名称',postage='运费',orderstatus='订单状态（1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中）',"
				+ "paystatus='支付状态(0未支付 1已支付)',deliverstatus='发货状态(0未发货 1已发货 2部分发货3当前订单子项用户收货已完成),"
				+ "itemCount='大订单下的订单项的数量',productImg='订单项的图片（当大订单下存在多个订单项时，调用此字段，只展示订单项的图片）',payLogId='支付记录id（0表示没有支付记录）',itemImg='订单子项的图片',itemList='订单子项list（字段已在前面标明）',isHasInvoice='是否有收货0没有，其他有',subType='期刊类型1单期2上半年3下半年4全年'"
				+ "buySendList=[{productid='商品id',productpic='商品图片',productname='商品名称',price='商品价格',producttype='商品类型2期刊4课程',count='数量'}]}}")
	})
	public Map<String, Object> getUserOrderList(Integer userId,Integer orderStatus,Integer page,Integer pageSize){
		Map data = orderService.selOrderList(userId,orderStatus,page,pageSize);
		return data;
	}
	/**
	 * @author LiTonghui
	 * @param orderstatus(1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价(确认收货)；5，已完成；6，已取消 7.退款中)

	 */
	@RequestMapping(value="/sureReceived")
	@ApiOperation(value="取消订单",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="orderId",value="订单id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="orderstatus",value="要修改的订单状态取消6",dataType="int",required=true,paramType="query"),
	})
	public Map<String, Object> sureReceived(Integer userId,Integer orderId,Integer orderstatus){
		Map<String,Object> result = new HashMap<String, Object>();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("orderId", orderId);
		map.put("orderstatus", orderstatus);
		int row = orderService.sureReceived(map);
		if(row>0){
			result.put("result", 1);
			result.put("msg", "操作成功！");
		}else{
			result.put("result", 0);
			result.put("msg", "操作失败！");
		}
		return result;
	}
	/**
	 * 
	 * @author LiTonghui
	 * 订单删除
	 * 
	 */
	@RequestMapping(value="/delUserOrder")
	@ApiOperation(value="删除订单",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="orderId",value="订单id",dataType="int",required=true,paramType="query")
	})
	public Map<String, Object> delUserOrder(Integer userId,Integer orderId){
		Map<String,Object> result = new HashMap<String, Object>();
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("orderId", orderId);
		int row = orderService.delUserOrder(map);
		if(row>0){
			result.put("result", 1);
			result.put("msg", "删除成功！");
		}else{
			result.put("result", 0);
			result.put("msg", "删除失败！");
		}
		return result;
	}
	
	/**
	 * @author LiTonghui
	 * 订单详情
	 * 
	 */
	@RequestMapping(value="/orderDetail")
	@ApiOperation(value="订单详情",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="orderId",value="订单id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='订单id',orderno='订单编号',addtime='下单时间',"
				+ "methodName='支付方式名称',period='电子书期次id',payTime='支付时间',payLogId='支付记录id',receivername='收货人',receiverphone='收货人电话',receiverAddress='详细地址',delivername='快递公司',"
				+ "delivercode='快递单号',totalprice='订单总价格包含运费',name='优惠券名称如无使用则为空',jianprice='减去的价格如无使用则为空',postage='运费',payprice='支付金额',"
				+ "voucherName='代金券名称如无使用则为空',voucherPrice='代金券的面额',list='订单子项[id='订单子项id',productname='商品名称',productpic='商品图片',count='数量',subType='期刊类型1单期2上半年3下半年4全年',productid='商品id',price='订单子项价格'"
				+ "buySendList=[{productid='商品id',productpic='商品图片',productname='商品名称',price='商品价格',producttype='商品类型2期刊4课程',count='数量'}]]'}}")
	})
	public Map<String, Object> orderDetail(Integer userId,Integer orderId){
		Map<String,Object> result = new HashMap<String, Object>();
		result = orderService.selectOrderDetail(userId,orderId);
		return result;
	}
	//订单确认
	@RequestMapping(value="/orderConfirm")
	@ApiOperation(value="确认收货",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="invoiceId",value="发货项id多个,号间隔",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="orderId",value="订单id",dataType="int",required=true,paramType="query")
	})
	public Map<String,Object> orderConfirm(Integer userId,String invoiceId,Integer orderId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null == userId || userId<=0 || null==invoiceId || invoiceId==""
				|| null==orderId || orderId<=0){
			map.put("msg", "参数错误");
			return map;
		}
		Map result = orderService.orderConfirm(userId,invoiceId,orderId);
		return result;
	}
	//获取收货列表
	@RequestMapping(value="/getInvoiceList")
	@ApiOperation(value="获取用户收货列表(目前只有纸制期刊有此列表)",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="orderId",value="订单id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="status",value="0待确认1已确认2待发货",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,orderId='订单id',data={name='期刊名称',"
				+ "picture='商品图片',count='数量',状态不是2的有以下发货单信息='以下为发货单信息',expressNum='快递单号',expressname='快递名称'invoiceId='运单的id','如果状态是确认收货的data={invoicInfo={expressNum='快递单号',expressname='快递名称'invoiceId='运单的id'}"
				+ "'list'=[{expressNum='快递单号',expressname='快递名称'invoiceId='运单的id',name='期刊名称',time='发货时间',picture='商品图片',count='数量'}]}}}")
	})//,expressNum='快递单号',expressname='快递名称'invoiceId='运单的id'
	public Map<String,Object> getInvoiceList(Integer userId ,Integer status,Integer orderId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null == userId || userId<=0 || null==orderId || orderId<=0 || null==status){
			map.put("msg", "参数错误");
			return map;
		}
		Map result = orderService.getInvoiceList(userId,orderId,status);
		return result;
	}
	
	@ApiOperation(value="查看运单详情",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="invoiceId",value="运单id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={name='期刊名称',picture='商品图片',"
				+ "count='数量',expressNum='快递单号',time='发货时间'}}")
	})
	@RequestMapping(value="/getInvoiceById")
	public Map<String,Object> getInvoiceById(Integer userId ,Integer invoiceId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null == userId || userId<=0 || null==invoiceId || invoiceId<=0){
			map.put("msg", "参数错误");
			return map;
		}
		Map result = orderService.getInvoiceById(userId,invoiceId);
		return result;
	}
	
}
