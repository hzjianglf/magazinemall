package cn.api.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@Service
@Transactional
public class OrderService {
	@Autowired
	SqlSession sqlSession;
	@Autowired
	ActivityService activityService;
	@Autowired
	PathService pathService;
	@Autowired
	ProductService productService;
	@Autowired
	private AccountService accountService;
	@Autowired
	private HttpSession session;
	@Autowired
	PostageService postageService;
	@Autowired
	private SearcheDiscountService searcheDiscountService;
	//加入购物车
	public Map createCardShop(Map paramMap) {
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("result", 0);
		result.put("msg", "操作失败");
		boolean isAdd =false;
		try {
			//查询纸质期刊是否有库存
			if(paramMap.get("producttype").toString().equals("2")){
				List<Integer> list = StringHelper.ToIntegerList(paramMap.get("desc")+"");
				//判断库存 暂时不要了。。。
				paramMap.put("list", list);
				List<Integer> stocks = sqlSession.selectList("shopCartDao.isStock",paramMap);
				for (Integer stock : stocks) {
					if(stock< Integer.parseInt((paramMap.get("count")).toString())){
						result.put("msg", "库存不足");
						return result;
					}
				}
				List<Integer> states = sqlSession.selectList("shopCartDao.isState",paramMap);
				if(!(null==states && states.isEmpty())){
					
					for (Integer state : states) {
						if(state==1){
							result.put("msg", "有下架商品");
							return result;
						}
					}
				}else{
					result.put("msg","商品信息错误" );
				}
				String buyprice = sqlSession.selectOne("shopCartDao.selTotalprice", paramMap);
				String price = sqlSession.selectOne("shopCartDao.seloriginalPrice", paramMap);
				paramMap.put("price", Double.parseDouble(price));
				paramMap.put("buyprice",Double.parseDouble(buyprice));
			}
			//电子书加入购物车
			if(paramMap.get("producttype").toString().equals("16")){
				if(paramMap.get("type").toString().equals("0")) {
					//先查询是否已经加入购物车
					Integer count = sqlSession.selectOne("shopCartDao.isCardShop",paramMap);
					if( null!=count && count>0){
						result.put("msg", "当前电子书已加入购物车！");
						return result;
					}
				}
				//查询是否已经购买此电子书
				int row = sqlSession.selectOne("shopCartDao.isByEbook",paramMap);
				if(row>0){
					result.put("msg", "您已购买了此电子书！");
					return result;
				}
				List<Integer> list = StringHelper.ToIntegerList(paramMap.get("desc")+"");
				String price = sqlSession.selectOne("shopCartDao.selEbookprice", paramMap);
				paramMap.put("price", Double.parseDouble(price));
				paramMap.put("buyprice",Double.parseDouble(price));
			}
			
			//查看是否限时特价
			int type = DataConvert.ToInteger(paramMap.get("producttype"));
			Map<String,Object> disMap = new HashMap<String, Object>();
			disMap.put("productId",paramMap.get("productid"));
			if(type==2) {
				disMap.put("type", 1);
			}else if(type==16) {
				disMap.put("type", 2);
			}
			Double discountPrice = searcheDiscountService.searchDiscountPrice(disMap);
			paramMap.put("buyprice", discountPrice);
			//如果是直接购买
			if((DataConvert.ToInteger(paramMap.get("type"))==1)){
				//清除直接购买没付款的
				sqlSession.delete("shopCartDao.delNotPay",paramMap);
				boolean flag = sqlSession.insert("shopCartDao.createCardShop",paramMap)>0;
				if(!flag){
					return result;
				}
				
			}else {
				//查询购物车中是否已经添加
				Integer shopCartId = sqlSession.selectOne("shopCartDao.isCardShop",paramMap);
				Integer yperiod = sqlSession.selectOne("shopCartDao.isYuanperiod",shopCartId);
				Integer period =  sqlSession.selectOne("shopCartDao.isPeriod",paramMap);
				if(null!=shopCartId && shopCartId>0 && yperiod==period){
					isAdd=true;
					paramMap.put("shopCartId", shopCartId);
					paramMap.put("id", shopCartId);
					Integer num = sqlSession.update("shopCartDao.updCardShop",paramMap);
					if(num<=0){
						return result;
					}
				}else{
					boolean flag = sqlSession.insert("shopCartDao.createCardShop",paramMap)>0;
					if(!flag){
						return result;
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			result.put("msg", "操作失败");
			return result;
		}
		
		try {
			int shopCartId=DataConvert.ToInteger(paramMap.get("id"));
			if(shopCartId>0) {
				//买即送活动判断
				int productId=DataConvert.ToInteger(paramMap.get("productid"));
				int productType=DataConvert.ToInteger(paramMap.get("producttype"));
				switch (productType) {
					case 1:
						productType=5;
						break;
					case 2:
						productType=1;
						break;
					case 4:
						productType=3;
						break;
					case 8:
						productType=4;
						break;
					case 16:
						productType=2;
						break;
					default:
						break;
				}
				//获取期刊对应的买即送活动列表
				List<Map>buyJiSongList=activityService.getBuyJiSongList(productId,productType);
				if(buyJiSongList!=null && !buyJiSongList.isEmpty()) {
					
					List<Integer> buyJiSongIds=buyJiSongList.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
					
					//获取活动赠送的商品列表
					List<Map>productList=activityService.getSendListForBuyJiSong(buyJiSongIds);
					if(productList!=null&&!productList.isEmpty()) {
						
						productList.forEach(i->{
							//1:纸质期刊 2:电子期刊 3:点播课程 4:直播课程 5:商品
							int type=DataConvert.ToInteger(i.get("productType"));
							switch (type) {
								case 1:
									type=2;
									break;
								case 2:
									type=16;
									break;
								case 3:
									type=4;
									break;
								case 4:
									type=8;
									break;
								case 5:
									type=1;
									break;
							}
							i.put("productType", type);
						});
						
						//添加赠送的商品到购物车
						Map<String,Object>param=new HashMap<String,Object>();
						param.putAll(paramMap);
						param.put("desc", shopCartId);
						param.put("type", paramMap.get("type"));
						param.put("subType", 5);
						param.put("userId", paramMap.get("userId"));
						param.put("list", productList);  
						//判断之前是否已经添加 如果已经添加则更改赠送商品数量
						boolean flag=true;
						if(isAdd){
							flag=sqlSession.update("shopCartDao.updSong",param)>0;
						}else{
							flag=sqlSession.insert("shopCartDao.bathInsertShopCart",param)>0;
						}
						if(!flag) {
							throw new Exception("添加对应的买即送赠品商品失败");
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			result.put("msg", "操作失败");
			return result;
		}
		result.put("data", paramMap.get("id"));
		result.put("result",  1);
		result.put("msg", "操作成功");
		return result;
	}
	//获取用户购物车列表
	public List getShopCartList(Map<String, Object> paramap) {
		paramap.put("type", 0);
		List<Map<String,Object>> list = sqlSession.selectList("shopCartDao.getShopCartList",paramap);
		
		if(list==null||list.isEmpty()) {
			return list;
		}
		pathService.getAbsolutePath(list, "productpic");
		
		List<Integer> itemIdList=list.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
		paramap.put("idList", itemIdList);
		//获取活动赠送的商品列表
		Map<Integer, List<Map>> groupMap=new HashMap<Integer,List<Map>>();
		List<Map<String,Object>>productList=sqlSession.selectList("shopCartDao.selShopCartListForZs",paramap);
		pathService.getAbsolutePath(productList, "productpic");
		if(productList!=null&&!productList.isEmpty()) {
			groupMap=productList.stream().collect(Collectors.groupingBy(f->DataConvert.ToInteger(f.get("desc")),Collectors.toList()));
		}
		Map<String,Object> disMap = new HashMap<String, Object>();
		for (Map<String, Object> map : list) {
				int type = DataConvert.ToInteger(map.get("producttype"));
				if(type==2) {
					disMap.put("type", 1);
				}else if(type==16) {
					disMap.put("type", 2);
				}
				disMap.put("productId", map.get("productid"));
				//查询限时特价
				Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
				map.put("buyprice", disPrice);
				//库存暂时不判断
				//List<Integer> lists = StringHelper.ToIntegerList(map.get("desc")+"");
				/*List<Integer> stocks = sqlSession.selectList("shopCartDao.isStock",paramap);
				int min = 0;
				if(!(stocks==null || stocks.isEmpty())){
					min=stocks.stream().min((i1,i2)->i1-i2).get();
				}
				map.put("maxStock", min);
				*/
			//	paramap.put("list", lists);
			//	List<String> name = sqlSession.selectList("shopCartDao.isName",paramap);
			//	String years = sqlSession.selectOne("shopCartDao.isYear",lists.get(0));
			//	years = (map.get("productname")+" ")+years;
				//map.put("productname", years);
			//	String names =StringHelper.Join(",", name.toArray());
			//	map.put("names", names);
				
				//添加对应的赠送的商品
				map.put("buySendList",groupMap.get(DataConvert.ToInteger(map.get("id"))));
		}
		return list;
	}
	
	//通过ids获取用户购物车列表
	public Map<String,Object> getShopCartListById(Map<String, Object> paramap) {
		Map<String,Object> result = new HashMap<String, Object>();
		List<Map<String,Object>> list = sqlSession.selectList("shopCartDao.getShopCartListById",paramap);
		//判断是否有纸质版的商品需要发货
		int isAddress = 0;
		if(list==null||list.isEmpty()) {
			return null;
		}
		List isHasaddress = list.stream().filter(f->{return DataConvert.ToInteger(f.get("producttype"))==2;}).collect(Collectors.toList());
		if(null!=isHasaddress && isHasaddress.size()>0){
			isAddress=1;
		}
		pathService.getAbsolutePath(list, "productpic");
		List<Integer> itemIdList=list.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
		paramap.put("idList", itemIdList);
		//获取活动赠送的商品列表
		Map<Integer, List<Map>> groupMap=new HashMap<Integer,List<Map>>();
		List<Map<String,Object>> productList=sqlSession.selectList("shopCartDao.selShopCartListForZs",paramap);
		if(isAddress==0){
			//判断赠品是否有要发货的商品
			isHasaddress = productList.stream().filter(f->{return DataConvert.ToInteger(f.get("producttype"))==2;}).collect(Collectors.toList());
			if(null!=isHasaddress && isHasaddress.size()>0){
				isAddress=1;
			}
		}
		
		pathService.getAbsolutePath(list, "productpic");
		if(productList!=null&&!productList.isEmpty()) {
			groupMap=productList.stream().collect(Collectors.groupingBy(f->DataConvert.ToInteger(f.get("desc")),Collectors.toList()));
		}
		Map<String,Object> disMap = new HashMap<String, Object>();
		for (Map<String, Object> map : list) {
			//	List<Integer> lists = StringHelper.ToIntegerList(map.get("desc")+"");
			//	paramap.put("list", lists);
				//库存暂时不判断
				/*List<Integer> stocks = sqlSession.selectList("shopCartDao.isStock",paramap);
				int min = 0;
				if(!(stocks==null || stocks.isEmpty())){
					min=stocks.stream().min((i1,i2)->i1-i2).get();
				}
				map.put("maxStock", min);*/
			//	paramap.put("list", lists);
			//	List<String> name = sqlSession.selectList("shopCartDao.isName",paramap);
				//String years = sqlSession.selectOne("shopCartDao.isYear",lists.get(0));
				//years = (map.get("productname")+" ")+years;
			//	map.put("productname", years);
				//String names =StringHelper.Join(",", name.toArray());
				//map.put("names", names);
			int type = DataConvert.ToInteger(map.get("producttype"));
			if(type==2) {
				disMap.put("type", 1);
			}else if(type==16) {
				disMap.put("type", 2);
			}
			disMap.put("productId", map.get("productid"));
			//查询限时特价
			Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
			map.put("buyprice", disPrice);
				//添加对应的赠送的商品
				map.put("buySendList",groupMap.get(DataConvert.ToInteger(map.get("id"))));
		}
		result.put("list", list);
		result.put("isAddress", isAddress);
		return result;
	}
	public long getShopCartCount(Integer userId) {
		return sqlSession.selectOne("shopCartDao.getShopCartCount",userId);
	}
	//改变购物车商品的数量和价格
	public Map changeShopCart(Map<String, Object> paramap) {
		Map result = new HashMap();
		try {
			String desc = sqlSession.selectOne("shopCartDao.selDesc",paramap.get("shopCartId")+"");
			String producttype = sqlSession.selectOne("shopCartDao.selShopCartById",paramap);
			if(producttype.equals("2")){//纸质期刊
				
				List<Integer> list = StringHelper.ToIntegerList(desc);
				//判断库存 暂时不要了。。。
				paramap.put("list", list);
					List<Integer> stocks = sqlSession.selectList("shopCartDao.isStock",paramap);
					for (Integer stock : stocks) {
						if(stock< Integer.parseInt((paramap.get("ncount")).toString())||stock==0){
							result.put("msg", "库存不足");
							result.put("result", 0);
							return result;
						}
					}
				sqlSession.update("shopCartDao.updCountAndPrice",paramap);
				result.put("shopCartId", paramap.get("shopCartId"));
				result.put("result", 1);
			}else{
				//电子书
				sqlSession.update("shopCartDao.updCountAndPrice",paramap);
				result.put("shopCartId", paramap.get("shopCartId"));
				result.put("result", 1);
			}
			
			//同步更改赠品的数量
			sqlSession.update("shopCartDao.updateZsItemCount",paramap);
			
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			result.put("result", 0);
			result.put("msg",e.getMessage());
			return result;
		}
		return result;
	}
	//通过购物车ids获取信息
	public Map<String,Object> getShopCartByIds(Map<String, Object> maps) {
		return getShopCartListById(maps);
	}
	//获取已购列表
	public List getOrders(Map<String, Object> parmap) {
		List<Map<String,Object>> list=sqlSession.selectList("orderCartDao.getOrders",parmap);
		//查看是否是赠品
		for(int i=0;list !=null && list.size()>0 && i<list.size();i++) {
//			Map<String,Object> isPresentMap = new HashMap<String,Object>();
			if((Integer.parseInt(list.get(i).get("subType").toString()))==5) {//是赠品
				//查看是否是合集
				if((Integer.parseInt(list.get(i).get("producttype").toString()))==2 ||
                    Integer.parseInt(list.get(i).get("producttype").toString())==16) {//去book表查询是否是合集
                    Map<String,Object> isPresent = sqlSession.selectOne("productDao.getBookRecord",list.get(i).get("productid").toString());
					if(isPresent !=null) {
						if(Integer.parseInt(isPresent.get("sumType").toString())>0) {//是合集
							//1为赠品下的合集标识
							list.get(i).put("isPresentSign", 1);
						}
					}
				}else if((Integer.parseInt(list.get(i).get("producttype").toString()))==4 ||
						(Integer.parseInt(list.get(i).get("producttype").toString()))==8) {//去ondemand表查询是否是合集
					//查看是否是合集
					Map<String,Object> isPresent = sqlSession.selectOne("productDao.getOndemandRecord",list.get(i).get("productid").toString());
					if(Integer.parseInt(isPresent.get("isSum").toString())>0) {//是合集
						//1为赠品下的合集标识
						list.get(i).put("isPresentSign", 1);
					}
				}
			}
		}
		return list;
	}
	//已购列表count
	public long getOrderCount(Map<String, Object> parmap) {
		return sqlSession.selectOne("orderCartDao.getOrderCount", parmap);
	}
	//修改购物车价格
	public int upCartPrice(Map<String,Object> map) {
		int num = 0;
		num = sqlSession.selectOne("orderCartDao.upCartPrice",map);
		return num;
	}
	/**
	 * 删除购物车子项
	 * @param userId
	 * @param orderId
	 * @param itemId
	 * @return
	 */
	public Map<String, Object> deleteCarItem(Integer userId,String ids) {
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> reqMap = new HashMap<String, Object>(){
			{
				put("result",0);
				put("msg","参数错误!");
			}
		};
		if(userId==null || ids==null || ids.length()==0){
			return reqMap;
		}
		map.put("userId", userId);
		List<Integer> list = StringHelper.ToIntegerList(ids);
		map.put("list", list);
		int row = sqlSession.delete("shopCartDao.deleteCarItem", map);
		if(row > 0){
			reqMap.put("result", 1);
			reqMap.put("msg", "删除成功!");
			try {
				 sqlSession.delete("shopCartDao.deleteZsCarItem", map);
			} catch (Exception e) {
			}
			
		}else{
			reqMap.put("result", 0);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
	/**
	 * 生成订单
	 * @param info
	 * @return
	 */
	@Transactional
	public int generateOrder(Map<String, Object> info) {
		//生成订单之前，先找到当前用户的订单，删除
		sqlSession.delete("orderCartDao.deleteUserOrder", info);
		double payPrice = DataConvert.ToDouble(info.get("payPrice"));
		
		if(Double.doubleToLongBits(payPrice) <=Double.doubleToLongBits(0.0) ) {//付款金额为负数或等于0直接代表支付成功
			info.put("paystatus", 1);
			info.put("orderstatus", 2);
		}
		int row = sqlSession.insert("orderCartDao.saveOrder", info);
		
		//如使用了代金券则更改用户使用状态
		if(null!=info.get("voucherId") && DataConvert.ToInteger(info.get("voucherId"))>0){
			sqlSession.update("payDao.updateVoucher",info);
			
		}
		//如使用了优惠券则更改用户使用状态
		if(null!=info.get("couponId") && DataConvert.ToInteger(info.get("couponId"))>0){
			sqlSession.update("payDao.updateCoupon",info);
		}
		if(row > 0){
			//添加订单子项
			sqlSession.insert("orderCartDao.saveOrderItem", info);
			if(payPrice>0) {
				//添加paylog记录
				info.put("totalprice", payPrice);
				sqlSession.insert("orderCartDao.insertPaylog", info);
			}else {//金额为0则无需插入paylog记录
				info.put("paylogId", 0);
			}
			//判断有无买即送活动
			int orderitemId=DataConvert.ToInteger(info.get("orderitemId"));
			if(orderitemId>0) {
				//买即送活动判断
				int productId=DataConvert.ToInteger(info.get("productId"));
				
				//产品类型 1实物，2期刊，4点播，8直播，16电子书
				int productType=DataConvert.ToInteger(info.get("ordertype"));
				
				
				//买即送对应的商品类型 type类型  1--期刊 2-电子  3--点播  4--直播 5--商品
				switch (productType) {
					case 1:
						productType=5;
						break;
					case 2:
						productType=1;
						break;
					case 4:
						productType=3;
						break;
					case 8:
						productType=4;
						break;
					case 16:
						productType=2;
						break;
					default:
						break;
				}
				//获取期刊对应的买即送活动列表
				List<Map>buyJiSongList=activityService.getBuyJiSongList(productId,productType);
				if(buyJiSongList!=null && !buyJiSongList.isEmpty()) {
						
					List<Integer> buyJiSongIds=buyJiSongList.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
						
					//获取活动赠送的商品列表
					List<Map>productList=activityService.getSendListForBuyJiSong(buyJiSongIds);
					
					if(productList!=null&&!productList.isEmpty()) {
							
						productList.forEach(i->{
							//1:纸质期刊 2:电子期刊 3:点播课程 4:直播课程 5:商品
							int type=DataConvert.ToInteger(i.get("productType"));
							switch (type) {
								case 1:
									type=2;
									break;
								case 2:
									type=16;
									break;
								case 3:
									type=4;
									break;
								case 4:
									type=8;
									break;
								case 5:
									type=1;
									break;
							}
							i.put("productType", type);
						});
						
						//添加赠送的商品到订单子项
						Map<String,Object>param=new HashMap<String,Object>();
						param.putAll(info);
						param.put("desc", orderitemId);
						param.put("type", 1);
						param.put("subType", 5);
						param.put("list", productList);
							
						boolean flag=sqlSession.insert("orderCartDao.bathInsertOrderItem",param)>0;
						if(!flag) {
								return -1;
						}
					}
				}
			}
		}
		return row;
	}
	/**
	 * 根据订单id查询订单信息
	 * @param map
	 * @return
	 */
	public Map<String, Object> selectPaylogMsg(Map<String, Object> map) {
		return sqlSession.selectOne("orderCartDao.selectPaylogMsg", map);
	}
	
	
	//查询用户的订单列表
	public Map selOrderList(Integer userId,Integer orderStatus,Integer page, Integer pageSize) {
		Map<String,Object> data = new HashMap<String, Object>();
		Map search = new HashMap();
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
			search.put("start", start);
			search.put("pageSize", pageSize);
		}
		search.put("userId", userId);
		search.put("orderStatus", orderStatus);
		try {
			List<Map<String,Object>> list = sqlSession.selectList("orderCartDao.selOrderList", search);
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
						for (Map<String,Object> item : itemList) {
							if(orderstatus==1 && DataConvert.ToInteger(item.get("subType"))!=5) {//代付款的看是否参与了限时特价
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
								sqlSession.update("orderCartDao.updOrdertotalPriceByPostage",item);
							}
							//添加对应的赠送的商品
							item.put("buySendList",groupMap.get(DataConvert.ToInteger(item.get("itemId"))));
						}
						//修改paylog应支付金额
						sqlSession.update("orderCartDao.updPaylogDisPrice",orderId);
					}
					orderInfo.put("itemList", itemList);
				}
				
				data.put("result", 1);
				data.put("msg", "获取数据成功！");
			}else{
				data.put("result", 1);
				data.put("msg", "获取数据失败,暂无订单！");
			}
			data.put("data", list);
			/*data.put("result", 1);
			data.put("msg", "获取数据成功！");*/
			if(flag){
				long count = sqlSession.selectOne("orderCartDao.selOrderCount", search);
	        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
	        	data.put("totalPage", totalPage);
	        	data.put("currentPage", page);
	        	//手机站需要
	        	Page pages = new Page(count, page, pageSize);
	        	data.put("pageTotal", pages.getTotalPageCount());
	        }
		} catch (Exception e) {
			e.printStackTrace();
			data.put("result", 0);
			data.put("msg", "获取数据失败！");
		}
		
		return data;
	}
	
	public Map<String,Object> selOrderListAdmin(Integer userId,Integer orderStatus,Integer page, Integer pageSize){
		Map<String,Object> result = selOrderList(userId,orderStatus,page,pageSize);
		List<Map<String,Object>> lm = new ArrayList<Map<String,Object>>();
		if(result!=null && result.get("data")!=null && result.get("data").toString() != "") {
			List<Map<String,Object>> orders = (List<Map<String, Object>>) result.get("data");
			for (Map<String, Object> map : orders) {
				Map<String,Object> map2 = new HashMap<String,Object>();
				if(map!=null) {
					map2.put("orderno", map.get("orderno"));
					map2.put("orderId", map.get("orderId"));
					if(map.get("itemList") != null) {
						List<Map<String,Object>> list2 = (List<Map<String, Object>>) map.get("itemList");
						for (Map<String, Object> map3 : list2) {
							map2.put("count", map3.get("count"));
							map2.put("buyprice", map3.get("buyprice"));
							map2.put("productname", map3.get("productname"));
							map2.put("subType", map3.get("subType"));
							lm.add(map2);
							if(map3.get("buySendList") != null) {
								List<Map<String,Object>> list3= (List<Map<String, Object>>) map3.get("buySendList");
								for (Map<String, Object> map4 : list3) {
									Map<String,Object> map5 = new HashMap<String,Object>();
									map5.put("orderno", map.get("orderno"));
									map5.put("orderId", map.get("orderId"));
									map5.put("count", map4.get("count"));
									map5.put("buyprice", map4.get("buyprice"));
									map5.put("productname", map4.get("productname"));
									map5.put("subType", map4.get("subType"));
									lm.add(map5);
								}
							}
						}
					}
				}
			}
		}
		int count = lm.size();
		Map<String,Object> data = new HashMap<String,Object>();
		data.put("data", lm);
		data.put("code", 0);
		data.put("msg", "");
		data.put("count", count);
		return data;
	}
	
	//删除订单
	public int delUserOrder(Map<String, Object> map) {
		return sqlSession.update("orderCartDao.delUserOrder",map);
	}
	/**
	 * 订单详情
	 * @param userId
	 * @param orderId
	 * @return
	 */
	public Map<String, Object> selectOrderDetail(Integer userId, Integer orderId) {
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId==null||orderId==null){
			return reqMap;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("orderId", orderId);
		map.put("orderStatus", -1);
		try {
				List<Map> list = sqlSession.selectList("orderCartDao.selectOrderDetail", map);
				if(list.size()>0){
					Map<String,Object> paramap=new HashMap<String, Object>();
					for (int i = 0; i < list.size(); i++) {
						Map orderInfo = list.get(i);
						List<Map<String,Object>> itemList = sqlSession.selectList("orderCartDao.selOrderItem", orderId+"");
						int orderstatus = DataConvert.ToInteger(orderInfo.get("orderstatus"));
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
								if(orderstatus==1 && DataConvert.ToInteger(item.get("subType"))!=5) {//代付款的看是否参与了限时特价
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
									sqlSession.update("orderCartDao.updOrdertotalPriceByPostage",item);
								}
								
								//添加对应的赠送的商品
								item.put("buySendList",groupMap.get(DataConvert.ToInteger(item.get("itemId"))));
							}
							//修改paylog应支付金额
							sqlSession.update("orderCartDao.updPaylogDisPrice",orderId+"");
						}
						orderInfo.put("itemList", itemList);
					}
					reqMap.put("result", 1);
					reqMap.put("msg", "获取数据成功！");
				}else{
					reqMap.put("result", 1);
					reqMap.put("msg", "获取数据失败,暂无订单！");
					return reqMap;
				}
			reqMap.put("data", list);
			reqMap.put("result", 1);
			reqMap.put("msg", "获取成功!");
			
			
		} catch (Exception e) {
			e.printStackTrace();
			reqMap.put("msg", "获取失败！");
		}
		return reqMap;
	}
	//通过期刊订单查找订单详情
	public List payBookOrder(String orderId) {
		return sqlSession.selectList("orderCartDao.selectItembyOrderId",orderId);
	}
	/*//查询期次
	public String selDesc(Map<String, Object> search) {
		return sqlSession.selectOne("shopCartDao.selDesc",search);

	}
	//查询库存
	public Map selKuCun(Map<String, Object> search) {
		Map<String,Object> result = new HashMap<String, Object>();
		List<Integer> stocks = sqlSession.selectList("shopCartDao.isStock",search);
		for (Integer stock : stocks) {
			if(stock<Integer.parseInt((paramMap.get("count")).toString())){
				result.put("result", 0);
				result.put("msg", "库存不足");
				return result;
			}
		}
	}*/
	public int sureReceived(Map<String, Object> map) {
		int row = 1;
		try {
			
			row = sqlSession.update("orderCartDao.sureReceived",map);
			if(row>0) {
				//查询订单是否使用代金券或优惠券
				Map<String,Object> orderMap = sqlSession.selectOne("orderCartDao.selHasCoupon",map);
				if(orderMap!=null) {
					if(DataConvert.ToInteger(orderMap.get("voucherId"))>0) {
						//修改代金券为未使用
						boolean flag = sqlSession.update("orderCartDao.updVoucher",DataConvert.ToInteger(orderMap.get("voucherId")))>0;
						if(!flag) {
							throw new Exception();
						}
					}
					if(DataConvert.ToInteger(orderMap.get("couponId"))>0) {
						//修改优惠券券为未使用
						boolean flag = sqlSession.update("orderCartDao.updCoupon",DataConvert.ToInteger(orderMap.get("couponId")))>0;
						if(!flag) {
							throw new Exception();
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("修改优惠券状态失败");
			row=-1;
		}
		return row;
	}
	//查询期次和购买数量
	public Map selQiciAndCount(String str) {
		return sqlSession.selectOne("orderCartDao.selQiciAndCount", str);
	}
	//查询book中的库存
	public Map selQiciKucun(String qiciIds) {
		return sqlSession.selectOne("orderCartDao.selQiciKucun", qiciIds);
	}
	//通过订单项的id获取多期电子书列表
	public List getEbookListById(Integer itemId) {
		return sqlSession.selectList("orderCartDao.getEbookListById",itemId);
	}
	//确认收货
	public Map orderConfirm(Integer userId, String invoiceId,Integer orderId) {
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("reuslt", 0);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("invoiceId", invoiceId);
		map.put("orderId", orderId);
		boolean flag = true;
		try {
			//更改oderitem里指定期次的运单状态为已收货
			flag = sqlSession.update("orderCartDao.updOrderQici",map)>0;
			if(!flag){
				throw new Exception();
			}
			//查看当前的子订单orderitem里所有期次对应的运单是否都已收货
			List<Integer> orderitemIds = sqlSession.selectList("orderCartDao.selOrderItemByInvoiceId",map);
			for (Integer id : orderitemIds) {
				map.put("orderitemId", id);
				int count = sqlSession.selectOne("orderCartDao.isAllOrderitem", map);
				if(count==1){//当前的子订单orderitem中所有商品都已收货修改其状态为已完成
					flag = sqlSession.update("orderCartDao.updOrderitemStatus",map)>0;
					if(!flag){
						throw new Exception();
					}
				}
			}
			//查询当前订单下所有的子订单是否是都已收货
			int row = sqlSession.selectOne("orderCartDao.isNotAllOrder",map);
			if(row==0){//当前的订单下所有子订单都已收货 修改订单状态为已完成
				flag = sqlSession.update("orderCartDao.updOrderStatus",map)>0;
				if(!flag){
					throw new Exception();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			result.put("msg", "操作失败");
			return result;
		}
		result.put("result", 1);
		result.put("msg", "确认收货成功");
		return result;
	}
	//获取收货列表
	public Map getInvoiceList(Integer userId,Integer orderId,Integer status) {
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("reuslt", 0);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("status", status);
		map.put("orderId", orderId);
		try {
			List<Map<String,Object>> list = sqlSession.selectList("orderCartDao.getInvoiceList",map);
			pathService.getAbsolutePath(list, "picture");
			if(status==0){
				//合并发货单
				if(list!=null &&!list.isEmpty()){
				
					
					Map<Map,List<Map>> groupMap=list.stream().collect(Collectors.groupingBy(f->{ return new HashMap(){
						{
							put("invoiceId", f.get("invoiceId"));
							put("expressname", f.get("expressname"));
							put("expressNum", f.get("expressNum"));
						}
					};},Collectors.toList()));
					
					List<Map<String,Object>> groupList=new ArrayList<Map<String,Object>>();
					
					for (Map.Entry<Map, List<Map>>item : groupMap.entrySet()) {
						
						Map itemMap=new HashMap();
						
						itemMap.put("invoicInfo",item.getKey());
						itemMap.put("list", item.getValue());
						
						groupList.add(itemMap);
					}
					
					list=groupList;
				}
				
			}
			result.put("orderId", orderId);
			
			result.put("data", list);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取数据失败");
			return result;
		}
		result.put("result", 1);
		result.put("msg", "获取数据成功");
		return result;
	}
	//查看运单详情
	public Map getInvoiceById(Integer userId, Integer invoiceId) {
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("result", 1);
		map.put("userId", userId);
		map.put("invoiceId", invoiceId);
		try {
			List list = sqlSession.selectList("orderCartDao.getInvoiceById",map);
			
			pathService.getAbsolutePath(list, "picture");
			
			result.put("data", list);
			result.put("result", 1);
			result.put("msg", "获取数据成功");
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取数据失败");
		}
		return result;
	}
	
	/**
	 * 通过商品和地址信息查询运费
	 * @param shopCartIds
	 * @param addressId
	 * @param userId
	 * @return
	 */
	public Map<String, Object> getPostage(String shopCartIds, Integer addressId,Integer userId) {
		//通过地址id获取用户的地址信息
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("result", 0);
		Map<String,Object> addressInfo = sqlSession.selectOne("productDao.selAddressInfo",addressId.toString());
		if(addressInfo==null){
			result.put("msg", "获取地址信息错误");
			return result;
		}
		//获取用户选择的城市  city=北京
		String city = DataConvert.ToString(addressInfo.get("city"));
		//获取用户购物车信息
		Map<String,Object> paramap = new HashMap<String, Object>();
		paramap.put("userId", userId);
		paramap.put("list", StringHelper.ToIntegerList(shopCartIds));
		paramap.put("producttype", 2);//暂时先获取纸质期刊的（暂时只有纸质期刊需要运费）
		List<Map<String,Object>> list = sqlSession.selectList("shopCartDao.getShopCartListById",paramap);
		
		BigDecimal freight = new BigDecimal(0.0);//运费
		BigDecimal totalFreight1 = new BigDecimal(0.0);//模版类型为1运费
		BigDecimal totalFreight0 = new BigDecimal(0.0);//模版类型为0运费
		Map<String,Object> bookIdMap = new HashMap<String,Object>();
		bookIdMap.put("userId", userId);
		List<Object> bookIdList = new ArrayList<Object>();
		List<Object> shopCartIdList = new ArrayList<Object>();
		List<Map<String,Object>> province = new ArrayList<Map<String,Object>>();
		List<Integer> cityIdList = new ArrayList<>();
		if(list!=null && list.size()>0) {
			for(int i = 0; i<list.size();i++) {
				bookIdList.add(list.get(i).get("productid"));
				shopCartIdList.add(list.get(i).get("id"));
			}
			//购物车表-productid(关联book表主键)
			bookIdMap.put("bookIdList", bookIdList);
			//购物车表-id
			bookIdMap.put("shopCartIdList", shopCartIdList);
			
			//模版类型-0,计算运费
			Map<String,Object> postageTypeForZero = sqlSession.selectOne("cn.dao.bookDao.selectpostageTypeForZero",bookIdMap);
			if(postageTypeForZero !=null) {
				totalFreight0 = (BigDecimal)postageTypeForZero.get("postage");
			}
			
			//模版类型-1,计算运费
			// 根据购物车id--查询 1.模版类型,模版id 2.数量
			List<Map<String,Object>> bookRecordList = sqlSession.selectList("cn.dao.bookDao.selectTemplateType",bookIdMap);
			for(int j = 0;bookRecordList !=null && bookRecordList.size()>0 && j<bookRecordList.size();j++) {
				// 根据模版id查询 logisticstemplateitem表
				int postageTempId=  (int)bookRecordList.get(j).get("postageTempId");
				List<Map<String,Object>> templateDetailList = sqlSession.selectList("cn.dao.logisticsTemplateDao.selectlogisticsTemplat",postageTempId);
				for(int cityId = 0;templateDetailList !=null && templateDetailList.size()>0 && cityId <templateDetailList.size();cityId++) {
					if(templateDetailList.get(cityId).get("cityIds") !=null && !"".equals(templateDetailList.get(cityId).get("cityIds"))) {
						//比较:收货地址和logisticstemplateitem表 地址是否匹配
						if(postageService.addressIsMatch(province,cityIdList,templateDetailList,cityId,city)) {
							freight = postageService.caculateFreight(bookRecordList,templateDetailList,cityId,j,freight);
							break;
						}
					}else {
						freight = postageService.caculateFreight(bookRecordList,templateDetailList,cityId,j,freight);
					}
				}
			    totalFreight1 = totalFreight1.add(freight);
			}
		}else {
			result.put("msg", "购物车中没有需要发货的商品");
			result.put("data", 0);
			return result;
		}
		result.put("result", 1);
		result.put("data", totalFreight1.add(totalFreight0));
		return result;
	}
	/**
	 * 比较:收货地址和logisticstemplateitem表 地址是否匹配
	 */
	/*public boolean addressIsMatch(List<Map<String,Object>> province,List<Integer> cityIdList,
			List<Map<String,Object>> templateDetailList,int cityId,String city) {
		//根据city查询provinces 的codeid
		List<Integer> codeid = new ArrayList<>();
		if(city !=null && city.endsWith("省")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("市")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("区")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("州")) {
			city = city.substring(0, city.length()-1);
		}	
		province = sqlSession.selectList("provinceDao.selectCodeid",city);
		if(province !=null && province.size()>0) {
			for(int i = 0;i<province.size();i++) {
				codeid.add(Integer.parseInt((province.get(i).get("codeid")).toString()));
			}
		}
		cityIdList = StringHelper.ToIntegerList(templateDetailList.get(cityId).get("cityIds")+"");
		//boolean isCity = cityIdList.containsAll(codeid);
		boolean isCity = false;
		if(cityIdList !=null && cityIdList.size()>0) {
			if(codeid !=null && codeid.size()>0) {
				for(int i=0;i<cityIdList.size();i++) {
					for(int j=0;j<codeid.size();j++) {
						if(cityIdList.get(i).intValue()==codeid.get(j).intValue()) {
							isCity = true;
							return isCity;
						}
					}
				}
			}
		}
		return isCity;
	}
	*/
	/**
	 * 计算运费
	 */
	/*public BigDecimal caculateFreight(List<Map<String,Object>> bookRecordList,
			List<Map<String,Object>> templateDetailList,int cityId,int j,BigDecimal freight) {
		double count = DataConvert.ToDouble(bookRecordList.get(j).get("count"));
		double firstGoods = 0.0;
		BigDecimal firstFreight = new BigDecimal(0.0);
		double secondGoods = 0.0;
		BigDecimal secondFreight = new BigDecimal(0.0);
		if(count<=((BigDecimal)(templateDetailList.get(cityId).get("firstGoods"))).doubleValue()) {
			freight = (BigDecimal) templateDetailList.get(cityId).get("firstFreight");
		}else{
			firstGoods = ((BigDecimal)(templateDetailList.get(cityId).get("firstGoods"))).doubleValue();
			secondGoods = ((BigDecimal)(templateDetailList.get(cityId).get("secondGoods"))).doubleValue();
			secondFreight = (BigDecimal)(templateDetailList.get(cityId).get("secondFreight"));
			if(secondGoods>0) {
				firstFreight = (BigDecimal) templateDetailList.get(cityId).get("firstFreight");
				double ceil = Math.ceil((count - firstGoods)/secondGoods);
				BigDecimal ceilBigdecimal = new BigDecimal(ceil);
				freight = firstFreight.add((ceilBigdecimal.multiply(secondFreight)));
			}
		}
		return freight;
	}*/
	//通过购物车ids和代金券获取应减免的代金金额
	public Map<String, Object> getVoucherprice(String shopCartIds, Integer voucherId, Integer userId,double postprice) {
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("result", 0);
		try {
			List<Map<String,Object>>shopCartList=sqlSession.selectList("productDao.selCartItemListNotZeng",shopCartIds);
			if(shopCartList==null||shopCartList.isEmpty()) {
				result.put("msg", "购物车空的,赶紧购买吧...");
				return result;
			}
			if(voucherId >0){
				Map<String,Object> info = new HashMap<String, Object>();
				info.put("userId", userId);
				info.put("voucherId", voucherId);
				Double price = sqlSession.selectOne("productDao.selPriceByVoucherId",info);
				//应减免的价格
				double shouldPrice = 0;
				//查看购物车中是否有适合此类代金券的商品
				boolean isHas=false;
				//记录是否有全品类的代金券
				double totalprice = 0;
				int  pinlei = sqlSession.selectOne("productDao.selPriceByVoucherIdQuan",info);
				for (Map<String,Object> subShopCart : shopCartList) {
					Map<String,Object> voucherParamMap = new HashMap<String,Object>();
					voucherParamMap.put("userId", userId);
					voucherParamMap.put("productId", subShopCart.get("id"));
					int type = DataConvert.ToInteger(subShopCart.get("producttype"));
					if(type==16) {
						type=5;
					}
					voucherParamMap.put("type", type);
					Map<String,Object> voucherMap = accountService.getVoucherByType(voucherParamMap);
				
					if(voucherMap!=null) {
						List<Map<String,Object>> subList = (List<Map<String, Object>>) voucherMap.get("lists");
						for (Map<String, Object> map : subList) {
							int selvoucherId = DataConvert.ToInteger(map.get("Id"));
							double subPrice = DataConvert.ToDouble(subShopCart.get("subprice"));
							totalprice+=subPrice;
							if(selvoucherId==voucherId) {
								isHas = true;
								if(subPrice>shouldPrice) {
									shouldPrice=subPrice;
								}
							}
						}
					}
				}
				shouldPrice+=postprice;
				//如果是全品类
				if(pinlei>0) {
					totalprice+=postprice;
					if(price>totalprice){
						price=totalprice;
					}
					result.put("result", 1);
					result.put("data",DataConvert.ToDouble(price));
					return result;
				}
				if(isHas) {
					if(price>shouldPrice) {
						price = shouldPrice;
					}
					result.put("result", 1);
					result.put("data",DataConvert.ToDouble(price));
				}else {
					result.put("msg","没有适合此代金券的商品");
				}
			}
		} catch (Exception e) {
			result.put("msg", "获取数据失败");
		}
		return result;
	}
}
