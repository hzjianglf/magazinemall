package cn.admin.finance.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.finance.service.TransactionService;
import cn.core.Authorize;
import cn.util.ExcelUntil;
import cn.util.Page;

/**
 * @2018年5月9日下午2:44:45 
 * @Title:交易
 */
@Controller
@RequestMapping(value="/admin/finance/transaction")
public class TransactionController {
	
	@Autowired
	TransactionService transactionService;

	/**
	 * @title 购买记录列表
	 */
	@RequestMapping(value="/purchaseList")
	@Authorize(setting="财务-购买记录列表")
	public ModelAndView purchaseList(){
		return new ModelAndView("/admin/finance/transaction/purchaseList");	
	}
	
	@RequestMapping(value="/purchaseListData")
	@ResponseBody
	public Map<String,Object> purchaseListData(HttpServletRequest request, @RequestParam Map search, int page, int limit ){
		long totalCount = transactionService.purchaseCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map<String,Object>> model = transactionService.purchaseList(search);
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", model);
		map.put("count", totalCount);
		return map;
	}
	@RequestMapping(value="/purchaseDataUp")
	@ResponseBody
	public ModelAndView purchaseDataUp(@RequestParam String paylogid , String source ){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("paylogid", paylogid);
		if(source.equals("1")){
			map.put("data", transactionService.orderPayment(map));
		}else if (source.equals("3")){
			map.put("data", transactionService.questions(map));
		}else if (source.equals("4")){
			map.put("data", transactionService.listenHearing(map));
		}else if (source.equals("5")){
			map.put("data", transactionService.reward(map)); 
		}else{
			map.clear();
		}
		map.put("source", source);
		return new ModelAndView("/admin/finance/transaction/purchaseUp",map);
	}
	
	@RequestMapping(value="/downPurchaseData")
	@ResponseBody
	public void downPurchaseData(HttpServletResponse response) throws UnsupportedEncodingException{
		List<Map> purchaseData = transactionService.purchaseList();
		String [] excelHeader = {"订单编号","买家","下单时间","订单金额（元）","支付方式"};
		String [] mapKey = {"orderNo","userName","payTime","price","payMethodName"};
		String name = "购买记录列表";
		ExcelUntil.excelToFile(purchaseData, excelHeader, mapKey, response, name);
	}
	
	/**
	 * @title 充值记录列表
	 */
	/*@RequestMapping(value="/rechargeList")
	@Authorize(setting="财务-充值记录列表")
	public ModelAndView rechargeList(){
		return new ModelAndView("/admin/finance/transaction/rechargeList");
				
	}*/
}
