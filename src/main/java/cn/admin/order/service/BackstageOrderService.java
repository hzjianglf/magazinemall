package cn.admin.order.service;

import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.alibaba.druid.util.StringUtils;
import com.mysql.fabric.xmlrpc.base.Param;

import cn.util.DataConvert;
import cn.util.NewExcelUtil;
import cn.util.StringHelper;

@Service
@Transactional(rollbackFor = Exception.class)
public class BackstageOrderService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	NewExcelUtil excelUtil; 
	
//	查询订单总条数
	public long selOrderCount(Map search) {
		return sqlSession.selectOne("orderDao.selOrderCount", search);
	}
//	查询所有订单列表
	public List<Map<String, Object>> selOrderList(Map search) {
		List<Map<String,Object>> list  = sqlSession.selectList("orderDao.selOrderList", search);
		for (Map map : list) {
			if(DataConvert.ToString(map.get("nickName"))==null || DataConvert.ToString(map.get("nickName")).equals("")) {
				String nickName = sqlSession.selectOne("orderDao.selNickName",map.get("orderno").toString());
				map.put("nickName", nickName);
			}
		}
		return list;
	}

	/**
	 * 查询期刊订单
	 * @param search
	 * @return
	 */
	public List<Map<String, Object>> selQiKanList(Map search) {
		List<Map<String,Object>> list = sqlSession.selectList("orderDao.selQiKanList",search);
		for (Map map : list) {
			if(DataConvert.ToString(map.get("nickName"))==null || DataConvert.ToString(map.get("nickName")).equals("")) {
				String nickName = sqlSession.selectOne("orderDao.selNickName",map.get("orderno").toString());
				map.put("nickName", nickName);
			}
		}
		return list;
	}
	/**
	 * 获取期刊订单数量
	 * @param paramMap
	 * @return
	 */
	public  long getQiKanCount(Map paramMap) {
		return sqlSession.selectOne("orderDao.selectQikanCount", paramMap);
	}
	public  long selectBathSendQikanCount(Map paramMap) {
		return sqlSession.selectOne("orderDao.selectBathSendQikanCount", paramMap);
	}
	/**
	 *  获取点播直播订单详情
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> getOrderDetailForOndemand(Map paramMap){
		Map<String,Object> map = sqlSession.selectOne("orderDao.selectOrderDetailForOndemand", paramMap);
		if(DataConvert.ToString(map.get("userName"))==null || DataConvert.ToString(map.get("userName")).equals("")) {
			String nickName = sqlSession.selectOne("orderDao.selNickNameByorderId",paramMap.get("orderId").toString());
			map.put("userName", nickName);
		}
		return map;
	}
	
//	删除订单
	public int delOrderInfo(String orderId) {
		return sqlSession.update("orderDao.delOrderInfo",orderId);
	}
//	查询商品发货详情左上角的商品列表
	public List<Map> selShopList(Map map) {
		return sqlSession.selectList("orderDao.selShopList", map);
	}
//	查询商品订单详情
	public Map selOrderDetail(Map map) {
		return sqlSession.selectOne("orderDao.selOrderDetail", map);
	}
//	查询发货人的信息
	public List<Map> selSenderInfo(Map<String, Object> search) {
		return sqlSession.selectList("orderDao.selSenderInfo", search);
	}
//	查询物流公司
	public List selWuliuCompany() {
		return sqlSession.selectList("orderDao.selWuliuCompany");
	}
//	修改收货人的信息
	public int updReceivInfo(Map map) {
		return sqlSession.update("orderDao.updReceivInfo",map);
	}
//	保存商品的发货单信息
	public int saveShopOrderInfo(Map map) {
		
		int result = 0;
		try {
			//流水号
			Date now = new Date();  
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmssSSS");  
			String serialNumber = formatter.format(now);
			map.put("serialNumber", serialNumber);
			map.put("goodsType", 1);
			
			int row = sqlSession.insert("orderDao.saveShopOrderInfo",map);//新增商品发货单信息
			if(row<=0){
				throw new Exception("新增商品发货单信息");
			}
			
			String[] orderItemId =  map.get("orderItem").toString().split(",");
			for (String str : orderItemId) {
				map.put("orderItemId", str);
				int buyCount = sqlSession.selectOne("orderDao.selBuyCount", map);
				map.put("buyCount", buyCount);
				int ro = sqlSession.insert("orderDao.addInvoiceAOrderInfo",map);//添加发货单关系表invoiceAndOrder
				int rw = sqlSession.update("orderDao.updOrderItemDeliverstatus",map);//修改子订单发货状态
				
				if(ro<=0 || rw<=0){
					throw new Exception("添加发货单关系表，修改订单项发货状态！");
				}
			}
			//查询大订单下是否还有小订单未发货
			int noDeliversOrderItem = sqlSession.selectOne("orderDao.noDeliversOrderItem", map);
			if(noDeliversOrderItem>0){//还有未发货的订单
				map.put("deliverstatus", 2);//发货状态为部分发货
				map.put("orderstatus", 2);//订单状态为已付款，未发货
			}else{//已经全部发货
				map.put("deliverstatus", 1);//已发货
				map.put("orderstatus", 3);//已发货
			}
			int ro = sqlSession.update("orderDao.updOrderDeliverstatus",map);//修改订单发货状态
			if(ro<=0){
				throw new Exception("添加发货单关系表，修改订单项发货状态！");
			}
			
			result=1;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		
		return result;
	}
	//查询需要发货的期刊订单详情
	public Map<String, Object> sqlDeliverQiKanFece(Map<String, Object> search) {
		return sqlSession.selectOne("orderDao.sqlDeliverQiKanFece", search);
	}
	//查询待发货的期刊
	public List<Map> selDaifaQikan(Map map) {
		return sqlSession.selectList("orderDao.selDaifaQikan",map);
	}
	//查询已发货的期刊列表
	public List<Map> selYifaQikan(Map<String, Object> search) {
		return sqlSession.selectList("orderDao.selYifaQikan", search);
	}
	//添加期刊发货单信息
	public int saveQikanOrderInfo(Map map,int type) {
		
		int result = 0;
		try {
			
			//流水号                                                                                                                                                                                                                                                                                                              
			Date now = new Date();  
	        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmssSSS");  
			String serialNumber = formatter.format(now);
			map.put("serialNumber", serialNumber);
			map.put("type", type);
			//先存储发货单
			int row = sqlSession.insert("orderDao.addInvoice",map);
			if(row<=0){
				throw new Exception("添加发货单");
			}
			
			String[] qiciId = map.get("publishPlanId").toString().split(",");
			if(type==2) {//批量发货需要注意查询当前订单子项期次
				List<Integer> qiciIds = new ArrayList<>();
				String desc = sqlSession.selectOne("orderDao.selBathQiciByitemId",map);
				List<Integer> list = StringHelper.ToIntegerList(desc);
				for (Integer subQici : list) {
					for (String searchQiciId : qiciId) {
						int parseInt = Integer.parseInt(searchQiciId);
						if(parseInt==subQici) {
							qiciIds.add(parseInt);
						}
						
					}
				}
				for (Integer subId : qiciIds) {
					map.put("qiciId", subId);
					int rw = sqlSession.insert("orderDao.addInvoiceAndOrder",map);//添加发货单关系表
					if(rw<=0){
						throw new Exception("添加发货单关系表！");
					}
				}
			}
			if(type==1) {
				for (String arr : qiciId) {
					map.put("qiciId", arr);
					int rw = sqlSession.insert("orderDao.addInvoiceAndOrder",map);//添加发货单关系表
					if(rw<=0){
						throw new Exception("添加发货单关系表！");
					}
				}
			}
			//发货单均添加成功后，修改订单子项的发货状态
			int fahuoType = 0;
			//已发货的数量
			int ioCount = sqlSession.selectOne("orderDao.selQiciCount", map);
			//应发货的数量
			int planCount = sqlSession.selectOne("orderDao.selPlanCount", map);
			if(ioCount==planCount){
				fahuoType=1;//已经发完了
			}else if(ioCount>0&&ioCount<planCount){
				fahuoType=2;//部分发货
			}
			map.put("fahuoType", fahuoType);
			//修改orderItem表中的发货状态
			int updItemFHType = sqlSession.update("orderDao.updItemFHType",map);
			if(updItemFHType<=0){
				throw new Exception("修改orderItem订单状态");
			}
			
			//查询大订单下未发货的数量
			int orderWeiFaCount = sqlSession.selectOne("orderDao.noDeliversOrderItem", map);
			if(orderWeiFaCount>0){//还有未发货的订单
				map.put("deliverstatus", 2);
				map.put("orderstatus", 2);
			}else{
				map.put("deliverstatus", 1);
				map.put("orderstatus", 3);
			}
			//修改大订单发货状态order
			int ro = sqlSession.update("orderDao.updOrderDeliverstatus",map);//修改订单发货状态	
			if(ro<=0){
				throw new Exception("修改order表状态");
			}
			
			result=1;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return result;
	}
	
	//excel导出-先查询待发货期刊订单
	public List<Map> daiFHQKlist(Map map) {
		return sqlSession.selectList("orderDao.daiFHQKlist", map);
	}
	//查询发货单数量
	public long selInvoiceCount(Map search) {
		return sqlSession.selectOne("orderDao.selInvoiceCount", search);
	}
	//查询发货单列表
	public List<Map<String,Object>> selInvoiceList(Map search) {
		return sqlSession.selectList("orderDao.selInvoiceList", search);
	}
	//标记为丢件
	public int loseGoods(int invoiceId) {
		return sqlSession.update("orderDao.loseGoods",invoiceId);
	}
	
	//查询发货人默认发货地址
	public String sqlSendAddressId(String senderId) {
		return sqlSession.selectOne("orderDao.sqlSendAddressId", senderId);
	}
	
	//excel批量上传
	public Map<String, Object> importResult(InputStream is, String pre, String senderId, String sendAddressId) {
		Map<String,Object> result = new HashMap<String, Object>();
		Map<String,Object> EngName = new HashMap<String, Object>(){
			{
				put("订单编号", "orderNo");
				put("期刊名称", "qikanName");
				put("衣物名称", "cloName");
				put("收货人", "receivedName");
				put("手机号", "receivedPhone");
				put("地址", "address");
				put("数量", "buyCount");
				put("单价", "price");
				put("金额", "totalPrice");
				put("快递公司", "expressId");
				put("快递单号", "expressNum");
			}
			
		};
		List<Map> infoList = excelUtil.isXlsOrXlsx(is, pre, EngName);//读取excel中的内容
		String lastOrderNo = "1";//上一条订单的订单编号
		for (int i = 0; i < infoList.size(); i++) {
			Map<String,Object> data = new HashMap<String, Object>(); 
			//excel表中的每一行信息
			Map info = infoList.get(i);
			String orderNo = info.get("orderNo")+"";
			if(orderNo.equals(lastOrderNo)){//如果当前行信息订单编号与上一条的订单编号相同时，则跳过当前循环
				continue;
			}else{
			
				lastOrderNo = orderNo;
				data.put("orderNo", orderNo);//订单编号
				
				//查询orderId和orderItemId 和期刊id
				Map orderAndItemId = sqlSession.selectOne("orderDao.selOrderAndItemId", info);
				data.put("orderId", orderAndItemId.get("orderId")+"");//orderId
				data.put("orderItem", orderAndItemId.get("orderItemId")+"");//orderItemId
				data.put("senderId", senderId);//发货人id
				data.put("sendAddressId", sendAddressId);//发货人地址id
				
				//查询物流公司id
				String expressName = info.get("expressId")+"";
				if(StringUtils.isEmpty(expressName)){
					result.put("result", false);
					result.put("msg", "请在excel中的第"+info.get("rowNum")+""+"行填写快递公司!");
					return result;
				}else{
					String expressId = sqlSession.selectOne("orderDao.selExpressId", expressName);
					data.put("expressId", expressId);
				}
				
				//快递单号
				String expressNum = info.get("expressNum")+"";
				if(StringUtils.isEmpty(expressNum)){
					result.put("result", false);
					result.put("msg", "请在excel中的第"+info.get("rowNum")+""+"行填写快递单号!");
					return result;
				}else{
					data.put("expressNum", expressNum);
				}
				data.put("receivedName", info.get("receivedName")+"");//收件人
				data.put("receivedPhone", info.get("receivedPhone")+"");//收件人电话
				
				//查询需发货的期次id
				String publishPlanId = "";
				List<Map> qiciInfo = sqlSession.selectList("orderDao.selQiciInfo", orderNo); 
				for (int j = 0; j < qiciInfo.size(); j++) {
					String qiciId = qiciInfo.get(j).get("planId")+"";
					publishPlanId += qiciId+",";
				}
				publishPlanId = publishPlanId.substring(0,publishPlanId.length()-1); 
				data.put("publishPlanId", publishPlanId);
				
				//收货地址
				String[] address = info.get("address").toString().split("-");
				data.put("province", address[0]);
				data.put("city", address[1]);
				data.put("county", address[2]);
				data.put("detailAddress", address[3]);
				
				//购买数量
				data.put("buyCount", info.get("buyCount")+"");
				//期刊id
				data.put("qikanId", orderAndItemId.get("productid")+"");
				
				int row = saveQikanOrderInfo(data,1);
				if(row==0){
					result.put("result", false);
					result.put("msg", "批量生成发货单失败！");
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
					break;
				}else{
					result.put("result", true);
					result.put("msg", "批量生成发货单成功,请及时发出货物！");
				}
			
			}
		}
		return result;
	}
	public List selPeriods() {
		return sqlSession.selectList("orderDao.selPeriods");
	}
	public List<Map<String, Object>> selPublishByPeriod(int ids) {
		return sqlSession.selectList("orderDao.selPublishByPeriod",ids);
	}
	//批量发货
	public Map<String, Object> bathSend(List<Map<String, Object>> list, Integer sendAddressId) {
		Map<String,Object> result = new HashMap<String,Object>();
		for (Map<String, Object> map : list) {
			map.put("sendAddressId", sendAddressId);
			int num = saveQikanOrderInfo(map,2);
			if(num<=0) {
				String orderno = DataConvert.ToString(map.get("orderno"));
				String productname = DataConvert.ToString(map.get("productname"));
				result.put("result", false);
				result.put("msg", "订单号为"+orderno+productname+"添加发货单失败");
				return result;
			}
		}
		result.put("result", true);
		result.put("msg", "批量添加发货单成功！");
		return result;
	}
	public List<Map<String, Object>> bathSendSearch(Map search) {
		List<Map<String,Object>> list = sqlSession.selectList("orderDao.bathSend",search);
		return list;
	}
	public Map selSubType(Map search) {
		return sqlSession.selectOne("orderDao.selSubType",search);
	}
	public List selYears() {
		return  sqlSession.selectList("orderDao.selYears");
	}
	public List getPubByYear(Map search) {
		return  sqlSession.selectList("orderDao.getPubByYear",search);
	}
	public List selOndemandType() {
		return sqlSession.selectList("orderDao.selOndemandType");
	}
	public List<Map<String, Object>> selClassNameBytype(int classtype) {
		return sqlSession.selectList("orderDao.selClassNameBytype",classtype);
	}
	public Map<String, Object> getOrderDetail(Map paramMap) {
		return sqlSession.selectOne("orderDao.getOrderDetail",paramMap);
	}

}
