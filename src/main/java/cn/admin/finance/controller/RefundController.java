package cn.admin.finance.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.core.Authorize;


/**
 * @2018年5月9日下午2:44:45 
 * @Title:退款
 */
@Controller
@RequestMapping(value="/admin/finance/refund")
public class RefundController {
	
	/**
	 * @title 财务-待审退款申请
	 */
	/*@RequestMapping(value="/refundApplication")
	@Authorize(setting="财务-退款记录列表")
	public ModelAndView refundApplication(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}*/
	
	/**
	 * @title 财务-退款记录列表
	 */
	/*@RequestMapping(value="/refundsRecord")
	@Authorize(setting="财务-退款记录列表")
	public ModelAndView refundsRecord(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}*/
	
}
