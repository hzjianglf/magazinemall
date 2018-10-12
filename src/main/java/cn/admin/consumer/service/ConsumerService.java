package cn.admin.consumer.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import cn.api.service.PathService;
import cn.api.service.ProductService;
import cn.api.service.SearcheDiscountService;
import cn.util.DataConvert;
import cn.util.Page;

@Service
public class ConsumerService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	SearcheDiscountService searcheDiscountService;
	@Autowired
	ProductService productService;
	@Autowired
	PathService pathService;
	
	
	//查询普通用户数量
	public long selConsumerCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("consumerDao.selConsumerCount", reqMap);
	}
	//查询普通用户列表
	public List<Map<String, Object>> selConsumerList(Map<String, Object> reqMap) {
		return sqlSession.selectList("consumerDao.selConsumerList", reqMap);
	}
	//删除用户
	public int deletes(Map map) {
		return sqlSession.update("consumerDao.deletes", map);
	}
	//查询扩展信息
	public Map<String, Object> selExtends(String userId) {
		return sqlSession.selectOne("consumerDao.selExtends", userId);
	}
	//添加扩展信息
	public int addExtends(Map map) {
		return sqlSession.insert("consumerDao.addExtends", map);
	}
	//修改扩展信息
	public int upExtends(Map map) {
		return sqlSession.update("consumerDao.upExtends", map);
	}
	//批量删除
	public long deleteids(Map<String, Object> map) {
		return sqlSession.delete("consumerDao.deleteids", map);
	}
	//查询用户信息
	public Map<String, Object> selectUserInfoById(String userId) {
		return sqlSession.selectOne("consumerDao.selectUserInfoById", userId);
	}
	//修改用户信息
	@Transactional
	public int editUser(Map map) {
		if(!StringUtils.isEmpty(map.get("approve")) && "1".equals(DataConvert.ToString(map.get("approve")))){
			map.put("userType", 2);
		}
		int row = sqlSession.update("consumerDao.editUser", map);
		int r = 0;
		if(row > 0){
			r = sqlSession.update("consumerDao.updateBalance", map);
		}
		//判断是否是专家
		if("2".equals(map.get("userType")+"")){
			//修改专家扩展信息
			sqlSession.update("consumerDao.updateMsg", map);
		}
		return row+r;
	}
	//查询用户密码
	public String selUserPwd(Map map) {
		return sqlSession.selectOne("consumerDao.selUserPwd", map);
	}
	//查询用户余额
	public Map selBalance(String userId) {
		return sqlSession.selectOne("consumerDao.selBalance", userId);
	}
	//查询消费记录
	public List selAccountLog(String userId) {
		return sqlSession.selectList("consumerDao.selAccountLog", userId);
	}
	//查询用的打赏记录
	public List findByUserRewardLog(String userId) {
		return sqlSession.selectList("consumerDao.findByUserRewardLog", userId);
	}
	//查询该用户共打赏了多少钱
	public double selSumMoney(String userId) {
		return sqlSession.selectOne("consumerDao.selSumMoney", userId);
	}
	//查询用户评论列表
	public List selectCommenUser(String userId) {
		return sqlSession.selectList("consumerDao.selectCommenUser", userId);
	}
	//查询导出数据
	public List selectDownload(Map map) {
		return sqlSession.selectList("consumerDao.selectDownload", map);
	}
	//查询用户订单
	public List selectUserOrderList(String userId) {
		return sqlSession.selectList("consumerDao.selectUserOrderList", userId);
	}
	//查询用户积分
	public Map selectJF(String userId) {
		return sqlSession.selectOne("consumerDao.selectJF", userId);
	}
	//积分记录
	public List selectJFlog(String userId) {
		return sqlSession.selectList("consumerDao.selectJFlog", userId);
	}
	//我的提问记录
	public List selectInterlocutionList(String userId) {
		return sqlSession.selectList("consumerDao.selectInterlocutionList", userId);
	}
	//提问我的
	public List selectQuestionList(String userId) {
		return sqlSession.selectList("consumerDao.selectQuestionList", userId);
	}
	//查询我得旁听
	public List selMyaudit(String userId) {
		return sqlSession.selectList("consumerDao.selMyaudit", userId);
	}
	//查询旁听我得
	public List selAuditMy(String userId) {
		return sqlSession.selectList("consumerDao.selAuditMy", userId);
	}
	//查询用户角色
	public String selectUserType(String userId) {
		return sqlSession.selectOne("consumerDao.selectUserType", userId);
	}
	//查询用户地址的数量
	public long selOrderAddressCount(Map<String,Object> map) {
		return sqlSession.selectOne("consumerDao.selOrderAddressCount",map);
	}
	//查询用户地址的数据
	public List<Map<String,Object>> selOrderAddressList(Map<String,Object> map){
		return sqlSession.selectList("consumerDao.selOrderAddressList",map);
	}
	
	//查询用户的订单列表
	public Map selOrderList(String userId, String openId ,Integer orderStatus,Integer page, Integer pageSize) {
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
		search.put("openId",openId);
		search.put("orderStatus", orderStatus);
		try {
			List<Map<String,Object>> list = sqlSession.selectList("consumerDao.selOrderList", search);
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
				long count = sqlSession.selectOne("consumerDao.selOrderCount", search);
	        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
	        	data.put("totalPage", totalPage);
	        	data.put("totalCount", count);
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
		
	public Map<String,Object> selOrderListAdmin(String userId,String openId,Integer orderStatus,Integer page, Integer pageSize){
		Map<String,Object> result = selOrderList(userId,openId,orderStatus,page,pageSize);
		List<Map<String,Object>> lm = new ArrayList<Map<String,Object>>();
		if(result!=null && result.get("data")!=null && result.get("data").toString() != "") {
			List<Map<String,Object>> orders = (List<Map<String, Object>>) result.get("data");
			for (Map<String, Object> map : orders) {
				int rowspan = 0;
				double orderPrice = 0d;
				if(map!=null) {
					if(map.get("itemList") != null) {
						List<Map<String,Object>> list2 = (List<Map<String, Object>>) map.get("itemList");
						for (Map<String, Object> map3 : list2) {
							rowspan += 1;
							orderPrice += DataConvert.ToDouble(map3.get("count")) * DataConvert.ToDouble(map3.get("buyprice"));
							Map<String,Object> map2 = new HashMap<String,Object>();
							map2.put("paystatus", map.get("paystatus"));
							map2.put("orderno", map.get("orderno"));
							map2.put("orderId", map.get("orderId"));
							map2.put("count", map3.get("count"));
							map2.put("buyprice", map3.get("buyprice"));
							map2.put("productname", map3.get("productname"));
							map2.put("subType", map3.get("subType"));
							map2.put("postage", map.get("postage"));
							lm.add(map2);
							if(map3.get("buySendList") != null) {
								List<Map<String,Object>> list3= (List<Map<String, Object>>) map3.get("buySendList");
								for (Map<String, Object> map4 : list3) {
									rowspan += 1;
									//orderPrice += DataConvert.ToDouble(map4.get("count")) * DataConvert.ToDouble(map4.get("buyprice"));
									Map<String,Object> map5 = new HashMap<String,Object>();
									map5.put("paystatus", map.get("paystatus"));
									map5.put("orderno", map.get("orderno"));
									map5.put("orderId", map.get("orderId"));
									map5.put("count", map4.get("count"));
									map5.put("buyprice", map4.get("buyprice"));
									map5.put("productname", map4.get("productname"));
									map5.put("subType", map4.get("subType"));
									map5.put("postage", map.get("postage"));
									lm.add(map5);
								}
							}
						}
					}
					for (Map<String, Object> map2 : lm) {
						if(map2.get("orderno").equals(map.get("orderno"))){
							map2.put("rowspan", rowspan);
							map2.put("orderPrice", orderPrice+"");
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
		data.put("count", result.get("totalCount"));
		return data;
	}
	
	//获取用户历史购买地址列表
	public Map<String,Object> selOrderAddressAdmin(Map<String,Object> map){
		Map<String,Object> result = new HashMap<String,Object>();
		
		//获取count
		long count = selOrderAddressCount(map);
		
		if(map.get("page")!=null&&map.get("limit")!=null){
			int page = DataConvert.ToInteger(map.get("page"));
			int pageSize = DataConvert.ToInteger(map.get("limit"));
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		//获取数据data
		List<Map<String,Object>> data = selOrderAddressList(map);
		result.put("data", data);
		result.put("code", 0);
		result.put("msg", "");
		result.put("count", count);
		return result;
	}
	
	/**
	 * 注册专家 去保存
	 * @param map
	 * @return
	 */
	@Transactional
	public Map<String, Object> expertRegisterToSave(Map map) {
		try {
			//1.注册
			int num = sqlSession.insert("userDao.addAdminUserInfo",map);
			int count = sqlSession.insert("userDao.addUserAccount",map.get("userId")+"");
			if(num<0||count<0){
				return null;
			}
			String userId = map.get("userId")+"";
			if(userId.equals("0")||userId==null){
				map.put("result", 0);
				map.put("msg","注册失败");
				return map;
			}
			//2.查询专家扩展信息表是否有该用户数据，若无则初始化一条记录
			map.put("userId", userId);
			Map<String,Object> extend=sqlSession.selectOne("accountDao.selectExtends", map);
			if(StringUtils.isEmpty(extend)) {
				//初始化扩展信息表
				sqlSession.insert("accountDao.addExtends", map);
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		map.put("msg", "操作成功");
		map.put("success", true);
		return map;
	}
	

}
