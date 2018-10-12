package cn.admin.finance.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.core.Authorize;


/**
 * @2018年5月9日下午2:44:45 
 * @Title:发票
 */
@Controller
@RequestMapping(value="/admin/finance/invoice")
public class InvoiceController {
	
	
	/**
	 * @title 财务-发票列表
	 */
	/*@RequestMapping(value="/invoice")
	@Authorize(setting="财务-发票列表")
	public ModelAndView invoice(){
		return new ModelAndView("/admin/finance/centsSetUp/list");
				
	}*/
	
}
