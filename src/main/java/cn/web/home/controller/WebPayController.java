package cn.web.home.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.Pay.service.payService;
import cn.core.UserValidate;
import cn.util.DataConvert;

@Controller
@RequestMapping(value="/web/pay")
public class WebPayController {

	@Autowired
	payService payService;
	/*
	 * 支付等待页面
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/waittingPay")
	@ResponseBody
	public Map<String, Object> waittingPay(@RequestParam Map map){
		int payLogId=DataConvert.ToInteger(map.get("paylogId"));
		int payMethodId=DataConvert.ToInteger(map.get("paytype"));
		Map result=payService.orderPay(payLogId, payMethodId);
		return result;
	}
	/**
	 * 跳转微信扫码页面
	 * @param code
	 * @param paylogId
	 * @return
	 */
	@RequestMapping("/wechatcode")
	public ModelAndView turnCode(String code,String paylogId){
		Map<String,Object> reqMap = new HashMap<String,Object>();
		reqMap.put("code", code);
		reqMap.put("paylogId", paylogId);
		return new ModelAndView("/pay/web/wechatCode", reqMap);
	}
	
}
