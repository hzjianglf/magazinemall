package cn.admin.order.controller;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.bouncycastle.ocsp.Req;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.util.DataConvert;
import cn.util.ExcelUntil;
import cn.util.StringHelper;
import cn.util.Tools;
import cn.admin.order.service.BackstageOrderService;
import cn.api.service.OrderService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.emay.sdk.util.StringUtil;
import cn.util.Page;

@Controller
@RequestMapping(value="/admin/order")
public class BackstageOrderController {
	
	@Autowired
	BackstageOrderService orderService;
	@Autowired
	OrderService apiOrderService;
	@Autowired
	HttpSession session;
	
	//实物商品订单
	@RequestMapping(value="/orderListFace")
	@Authorize(setting="订单-实物商品订单,订单-数字期刊订单,订单-点播课程订单,订单-直播课程订单",type=AuthorizeType.ONE)
	public ModelAndView goodsListFace(HttpServletRequest request,@RequestParam("listType") int listType){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		String jspName = "goodsList";
		if(listType==1){//实物商品订单
			jspName = "goodsList";
		}else if(listType==2){
			jspName = "periodicalsList";
			List periods = orderService.selPeriods();
			map.put("periods", periods);
		}else{
			List classtype = orderService.selOndemandType();
			map.put("classtype", classtype);
			jspName = "classList";
		}
		return new ModelAndView("/admin/order/"+jspName,map);
	}
	@RequestMapping("selPublishByPeriod")
	@ResponseBody
	public Map<String,Object> selPublishByPeriod(int ids){
		List<Map<String,Object>> list = orderService.selPublishByPeriod(ids);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("list", list);
		return map;
	}
	@RequestMapping("selClassNameBytype")
	@ResponseBody
	public Map<String,Object> selClassNameBytype(int classtype){
		Map<String,Object> map = new HashMap<String, Object>();
		List<Map<String,Object>> list= orderService.selClassNameBytype(classtype);
		map.put("list", list);
		return map;
	}
	//订单列表数据
	@RequestMapping(value="/orderListData")
	@ResponseBody
	public Map orderList(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		String listType = request.getParameter("listType");
		long totalCount =0;
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		search.put("listType", listType);
		String registrationDate = DataConvert.ToString(search.get("buyTime"));
		//时间处理
		if(Tools.isNotEmpty(registrationDate)){
			String[] split = registrationDate.split(" - ");
			String startDate = split[0];
			String endDate = split[1];
			search.put("startTime", startDate);
			search.put("endTime", endDate);
		}
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		if(!listType.equals("2")){
			list =  orderService.selOrderList(search);//商品、直播、点播
			totalCount= orderService.selOrderCount(search);
		}else{
			totalCount=orderService.getQiKanCount(search);
			list =  orderService.selQiKanList(search);//期刊订单
		}
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	
	@RequestMapping("/getOrderDetailForClass")
	public ModelAndView getOrderDetailForClass(@RequestParam Map paramMap) {
		Map<String, Object> map=orderService.getOrderDetailForOndemand(paramMap);
		return new ModelAndView("/admin/order/orderDetailForClass",map);
	}
	@RequestMapping("/selOrderDetails")
	public ModelAndView selOrderDetails(@RequestParam Map paramMap) {
		Integer orderId = Integer.parseInt(paramMap.get("orderId").toString());
		Map<String, Object> map = new HashMap<String, Object>();
		//根据订单id获取用户userid
		Map<String, Object> orderDetailMap = orderService.getOrderDetail(paramMap);
		if(orderDetailMap!=null) {
			Integer userId = DataConvert.ToInteger(orderDetailMap.get("userId"));
			map = apiOrderService.selectOrderDetail(userId,orderId);
		}
		return new ModelAndView("/admin/order/periodicalOrderDetails",map);
	}
	
	
	//删除订单
	@RequestMapping(value="/delOrderInfo")
	@ResponseBody
	public Map delOrderInfo(@RequestParam Map<String,Object> map){
		String orderId = DataConvert.ToString(map.get("orderId"));
		if(orderId==null) {
			map.put("result", false);
			map.put("msg", "删除失败!");
			return map;
		}
		int row = orderService.delOrderInfo(orderId);
		if(row>0){
			map.put("result", true);
			map.put("msg", "删除成功!");
		}else{
			map.put("result", false);
			map.put("msg", "删除失败!");
		}
		return map;
	}
	//商品发货页面
	@RequestMapping(value="/deliverGoodsFace")
	public ModelAndView deliverGoodsFace(HttpServletRequest request,@RequestParam("orderId") String orderId){
		Map<String,Object> search = new HashMap<String, Object>();
		String sender = (String) session.getAttribute("userId");//登录者id，即发货人id
		search.put("sender", sender);
		search.put("orderId", orderId);
		
		Map map = orderService.selOrderDetail(search);//查询订单详情
		List<Map> shopList = orderService.selShopList(search);//查询发货页面左上角的商品列表
		List<Map> senderInfo = orderService.selSenderInfo(search);//查询发货人的信息
		List wuliuCompany = orderService.selWuliuCompany();//查询物流公司
		
		map.put("shopList", shopList);
		map.put("senderInfo", senderInfo);
		map.put("wuliuCompany", wuliuCompany);
		map.put("jsonOrderItem", net.sf.json.JSONArray.fromObject(shopList));
		
		return new ModelAndView("/admin/order/goodsLssue",map);
	}
	//修改收货人的信息
	@RequestMapping(value="/updReceivInfo")
	@ResponseBody
	public Map updReceivInfo(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = orderService.updReceivInfo(map);
		if(row>0){
			result.put("result", true);
			result.put("msg", "保存成功！");
		}else{
			result.put("result", false);
			result.put("msg", "保存失败！");
		}
		return result;
	}
	//商品订单发货
	@RequestMapping(value="/saveShopOrderInfo")
	@ResponseBody
	public Map saveShopOrderInfo(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = orderService.saveShopOrderInfo(map);//新增商品发货单
		if(row>0){
			result.put("result", true);
			result.put("msg", "已生成发货单，请及时发出货物！");
		}else{
			result.put("result", false);
			result.put("msg", "生成发货单失败！");
		}
		return result;
	}
	
	
	//期刊发货页面
	@RequestMapping(value="/deliverQiKanFece")
	public ModelAndView deliverQiKanFece(@RequestParam("orderItemId") String orderItemId){
		Map<String,Object> search = new HashMap<String, Object>();
		String sender = (String) session.getAttribute("userId");//登录者id，即发货人id
		search.put("sender", sender);
		search.put("orderItemId", orderItemId);
		
		Map<String,Object> map = orderService.sqlDeliverQiKanFece(search);
		List<Map> daifaQikan = orderService.selDaifaQikan(search);//查询待发货的期刊
		List<Map> yifaQikan = orderService.selYifaQikan(search);//查询已发货的期刊
		List wuliuCompany = orderService.selWuliuCompany();//查询物流公司
		List<Map> senderInfo = orderService.selSenderInfo(search);//查询发货人的信息
		map.put("daifaQikan", daifaQikan);
		map.put("yifaQikan", yifaQikan);
		map.put("wuliuCompany", wuliuCompany);
		map.put("senderInfo", senderInfo);
		map.put("jsonSenderInfo", net.sf.json.JSONArray.fromObject(senderInfo));
		return new ModelAndView("/admin/order/periodicalsLssue",map);
	}
	
	//添加期刊发货单
	@RequestMapping(value="/saveQikanOrderInfo")
	public @ResponseBody Map saveQikanOrderInfo(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = orderService.saveQikanOrderInfo(map,1);//1代表单个订单发货2代表批量发货
		if(row>0){
			result.put("result", true);
			result.put("msg", "已生成发货单，请及时发出货物！");
		}else{
			result.put("result", false);
			result.put("msg", "生成发货单失败！");
		}
		return result;
 	}
	//跳转批量发货页面
	@RequestMapping("/turnBathSend")
	public ModelAndView turnBathSend() {
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> search = new HashMap<String, Object>();
		String sender = (String) session.getAttribute("userId");//登录者id，即发货人id
		search.put("sender", sender);
		List year = orderService.selYears();//查询年份
		List periods = orderService.selPeriods();
		List wuliuCompany = orderService.selWuliuCompany();//查询物流公司
		List<Map> senderInfo = orderService.selSenderInfo(search);//查询发货人的信息
		map.put("year", year);
		map.put("periods", periods);
		map.put("wuliuCompany", wuliuCompany);
		map.put("senderInfo", senderInfo);
		map.put("jsonSenderInfo", net.sf.json.JSONArray.fromObject(senderInfo));
		
		return new ModelAndView("/admin/order/bathSend",map);
	}
	/**
	 * @param {year 年份,period 刊物id}
	 * @return
	 */
	//通过年份查找期次
	@RequestMapping("getPubByYear")
	@ResponseBody
	public Map<String,Object> getPubByYear(@RequestParam Map search){
		Map<String,Object> result = new HashMap<String,Object>();
		List list = orderService.getPubByYear(search);
		result.put("publishs", list);
		return result;
	}
	@RequestMapping("bathSendSearch")
	@ResponseBody
	public Map<String,Object> bathSendSearch(@RequestParam Map search , int page, int limit){
		String publish = DataConvert.ToString(search.get("publish"));
		List<Integer> publishs = StringHelper.ToIntegerList(publish);
		int count = 1;
		for (Integer id : publishs) {
			search.put("publish"+(count++), id);
		}
		long totalCount=orderService.selectBathSendQikanCount(search);
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		
		List<Map<String,Object>> list =orderService.bathSendSearch(search);
		
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("data", list);
		result.put("count", totalCount);
		result.put("msg", "");
		result.put("code", 0);
		return result;
	}
	//批量发货
	@RequestMapping("/bathSend")
	@ResponseBody
	public Map<String,Object> bathSend(@RequestParam Map search){
		String publish = DataConvert.ToString(search.get("publish"));
		List<Integer> publishs = StringHelper.ToIntegerList(publish);
		int count = 1;
		for (Integer id : publishs) {
			search.put("publish"+(count++), id);
		}
		List<Map<String,Object>> list =orderService.bathSendSearch(search);//期刊订单
		
		Map<String,Object> result = new HashMap<String,Object>();
		for (Map<String, Object> map : list) {
			Integer status = DataConvert.ToInteger(map.get("status"));
			if(status!=2) {
				result.put("msg", "订单号为"+DataConvert.ToString(map.get("orderno"))+"状态有误");
				result.put("result", false);
				return result;
			}
			String openId = DataConvert.ToString(map.get("open"));
			if(openId!=null && !openId.equals("")) {
				result.put("msg", "订单号"+DataConvert.ToString(map.get("orderno"))+"为老数据暂不提供发货");
				result.put("result", false);
				return result;
			}
		}
		//批量发货
		result = orderService.bathSend(list,DataConvert.ToInteger(search.get("sendAddressId")));
		return result;
	}
	//发货单列表页面
	@RequestMapping(value="/invoiceListFace")
	public ModelAndView invoiceListFace(@RequestParam("invoiceType") int invoiceType){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("invoiceType", invoiceType);
		return new ModelAndView("/admin/order/invoiceList",map);
	}
	//发货单列表数据
	@RequestMapping(value="/invoiceList")
	@ResponseBody
	public Map invoiceList(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		String period = DataConvert.ToString(search.get("period"));
		List<Integer> periods = StringHelper.ToIntegerList(period);
		int count = 1;
		for (Integer id : periods) {
			search.put("period"+(count++), id);
		}
		long totalCount = orderService.selInvoiceCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map<String,Object>> list = orderService.selInvoiceList(search);
		for (Map map2 : list) {
			String invoiceId = map2.get("invoiceId").toString();
			Integer subtype = Integer.parseInt(map2.get("subType").toString());
			if(subtype == 2 || subtype == 3 || subtype == 4  ) {
				search.put("invoiceId", invoiceId);
				Map subType = orderService.selSubType(search);
				if(subType !=null) {
					map2.put("describes",subType.get("describes").toString() );
				}
			}
		}
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	//标记为丢件
	@RequestMapping(value="/loseGoods")
	@ResponseBody
	public Map loseGoods(@RequestParam("invoiceId") int invoiceId){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = orderService.loseGoods(invoiceId);
		if(row>0){
			result.put("result", true);
			result.put("msg", "标记成功！");
		}else{
			result.put("result", false);
			result.put("msg", "标记失败！");
		}
		return result; 
	}
	
	//批量导出待发货期刊列表
	@RequestMapping(value="/batchExport")
	@ResponseBody
	public void batchExport(@RequestParam Map map,HttpServletResponse response) throws UnsupportedEncodingException{
		if(!StringUtil.isEmpty(DataConvert.ToString(map.get("ids")))) {
			String[] id = DataConvert.ToString(map.get("ids")).split(",");
			map.put("ids", id);
		}
		List<Map> list =  orderService.daiFHQKlist(map);//待发货期刊列表
		
		List<Map> dataList = new ArrayList();
		String name = "期刊";
		// 区分
		String[] excelHeader = new String[] { "订单编号","买家","收货人","收货人电话","收货人地址","期刊名称","媒体类型", "数量","单价","应付金额", "状态"};
		String[] mapKey = new String[] { "orderNo", "userName","receivername","receiverphone","address", "productname","goorsType","buycount","buyprice","totalPrice","status"};
		
		for (Map map2 : list) {
			Map<String,Object> data = new HashMap<String, Object>();
			
			data.put("orderNo", DataConvert.ToString(map2.get("orderno")));
			String nickName = DataConvert.ToString(map2.get("nickName"));
			if(StringUtil.isEmpty(nickName)) {
				nickName=DataConvert.ToString(map2.get("realname"));
			}
			data.put("userName", nickName);
			data.put("receivername", DataConvert.ToString(map2.get("receivername")));
			data.put("receiverphone", DataConvert.ToString(map2.get("receiverphone")));
			data.put("address", DataConvert.ToString(map2.get("address")));
			data.put("productname", DataConvert.ToString(map2.get("productname")));
			data.put("goorsType", DataConvert.ToString(map2.get("goorsType")));
			data.put("buycount", DataConvert.ToString(map2.get("buycount")));
			data.put("buyprice", DataConvert.ToString(map2.get("buyprice")));
			data.put("totalPrice", DataConvert.ToString(map2.get("totalPrice")));
			String status = "";
			if(DataConvert.ToInteger(map2.get("status"))==1){
				status="待付款";
			}else if(DataConvert.ToInteger(map2.get("status"))==2){
				status="待发货";
			}else if(DataConvert.ToInteger(map2.get("status"))==3){
				if(DataConvert.ToInteger(map2.get("deliverstatus"))==1){
					status="已发货";
				}else if(DataConvert.ToInteger(map2.get("deliverstatus"))==2){
					status="部分发货";
				}
			}else if(DataConvert.ToInteger(map2.get("status"))==4){
				status="已收货，待评价";
			}else if(DataConvert.ToInteger(map2.get("status"))==5){
				status="交易完成";
			}else if(DataConvert.ToInteger(map2.get("status"))==6){
				status="订单已取消";
			}else if(DataConvert.ToInteger(map2.get("status"))==7){
				status="退款中";
			}
			data.put("status", status);
			dataList.add(data);
		}
		
		ExcelUntil.excelToFile(dataList, excelHeader, mapKey, response, name + "订单");
	}
	//批量导入
	@RequestMapping(value="/batchImport")
	@ResponseBody
	public Map batchImport(@RequestParam("excelFile") MultipartFile file,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String dictionaryId = request.getParameter("dictionaryId");
		String fileName = file.getOriginalFilename();//excel文件名称
		String pre = fileName.substring(fileName.lastIndexOf(".") + 1);//后缀名
		String senderId = session.getAttribute("userId")+"";//当前登录人的id,即发货人id
		String sendAddressId = orderService.sqlSendAddressId(senderId);//查询发货人的默认发货地址
		
		try {
			InputStream is=file.getInputStream();
			if(pre.equals("xlsx") || pre.equals("xls")){
				map = orderService.importResult(is,pre,senderId,sendAddressId);
			}else{
				map.put("result", false);
				map.put("msg", "请上传正确的excel文件！");
				return map;
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return map;
	}

	//批量导出发货单列表
	@RequestMapping(value="/batchExportInvoice")
	public void batchExportInvoice(@RequestParam Map search,HttpServletResponse response) throws UnsupportedEncodingException{
		
		List<Map<String,Object>> list = orderService.selInvoiceList(search);
		for (Map map2 : list) {
			String invoiceId = map2.get("invoiceId").toString();
			Integer subtype = Integer.parseInt(map2.get("subType").toString());
			if(subtype == 2 || subtype == 3 || subtype == 4  ) {
				search.put("invoiceId", invoiceId);
				Map subType = orderService.selSubType(search);
				if(subType !=null) {
					map2.put("goodsName",map2.get("goodsName")+"--"+subType.get("describes").toString() );
				}
			}
		}
		List<Map> dataList = new ArrayList();
		String name = "期刊发货单";
		int type = Integer.parseInt(search.get("invoiceType")+"");
		if(type==1){
			name = "商品发货单";
		}
		
		// 区分
		String[] excelHeader = new String[] { "流水号","订单编号","发货日期","发货类型","商品名称", "买家","收货人","收货地址", "快递公司","快递单号","运费","快递单状态"};
		String[] mapKey = new String[] { "liushuiNum", "orderno", "date","invoicetype","goodsName","userName","receiver","address","kuaidi","kuaidiNum","postage","statusName"};
		for (int i = 0; i < list.size(); i++) {
			Map<String,Object> data = new HashMap<String, Object>();
			String receiver = list.get(i).get("receivername")+"/"+list.get(i).get("receiverphone")+"";
			String address = list.get(i).get("receiverProvince")+"-"+list.get(i).get("receiverCity")+"-"+list.get(i).get("receiverCounty")+"-"+list.get(i).get("receiverAddress")+"";
			data.put("liushuiNum", list.get(i).get("liushuiNum")+"");
			data.put("orderno", list.get(i).get("orderno")+"");
			data.put("goodsName", list.get(i).get("goodsName")+"");
			data.put("userName", list.get(i).get("userName")+"");
			data.put("receiver", receiver);
			data.put("address", address);
			data.put("kuaidi", list.get(i).get("name")+"");
			data.put("kuaidiNum",list.get(i).get("expressNum")+"");
			data.put("postage", list.get(i).get("postage")+"");
			data.put("statusName", list.get(i).get("statusName")+"");
			data.put("date", list.get(i).get("date")+"");
			data.put("invoicetype", list.get(i).get("invoicetype")+"");
			dataList.add(data);
		}
		ExcelUntil.excelToFile(dataList, excelHeader, mapKey, response, name);
	}
	
	
}
