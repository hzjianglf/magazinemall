package cn.admin.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.Pay.provider.PayProviderEntity;
import cn.Pay.provider.PayProviderLoader;
import cn.admin.system.service.PaymethodService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.Page;

@Controller
@RequestMapping(value="/admin/system/paymethod")
public class PaymethodController {
	
	
	@Autowired
	PaymethodService paymethodService;

	
	
	/**
	 * 支付管理列表
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="支付管理-支付管理列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/payment/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>();
		long count = paymethodService.selPaymentCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = paymethodService.selPaymentList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 支付管理设置
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/updateDefault")
	@ResponseBody
	@Authorize(type=AuthorizeType.ONE,setting="支付管理-设置默认,支付管理-设置启用禁用")
	public Map<String, Object> updateDefault(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = paymethodService.updateDefault(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "设置成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "设置失败!");
		}
		return reqMap;
	}
	/**
	 * 支付管理删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="支付管理-删除支付管理")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = paymethodService.deletePayment(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
	/**
	 * 添加修改弹窗
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/addOrUp")
	public ModelAndView addOrUp(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(map.get("id")) && !"null".equals(map.get("id"))){
			//查询支付管理
			reqMap = paymethodService.findByIdPayment(map);
		}
		//查询支付接口类型
		List<PayProviderEntity> list = PayProviderLoader.get();
		reqMap.put("list", list);
		return new ModelAndView("/admin/payment/addOrup",reqMap);
	}
	/**
	 * 添加/修改支付管理
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/savePayment")
	@ResponseBody
	public Map<String, Object> savePayment(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap = paymethodService.savePayment(map);
		return reqMap;
	}
	
}
