package cn.admin.system.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import cn.admin.system.service.ProvinceService;

/**
 * 省市县
 */
@Controller
@RequestMapping("/admin/system/province")
public class ProvinceController {
	
	@Autowired
	private ProvinceService provinceService;
	
	/**
	 * 获取省份
	 */
	@RequestMapping("/getProvince")
	@ResponseBody
	public List<Map<String,Object>> getProvince() {
		return provinceService.getProvince();
	}
	
	/**
	 * 通过省获取市
	 */
	@RequestMapping("/getCityByParentId")
	@ResponseBody
	public List<Map<String, Object>> getCityByParentId(@RequestParam("parentId") String parentId) {
		List<Map<String, Object>> list = provinceService.getCityByParentId(parentId);
		return list;
	}
	
}
