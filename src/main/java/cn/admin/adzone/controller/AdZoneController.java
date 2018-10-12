package cn.admin.adzone.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.adzone.service.AdZoneService;
import cn.admin.adzone.service.AdvertisementService;
import cn.admin.system.service.DictionaryService;
import cn.core.Authorize;
import cn.util.Page;

/**
 * 广告位
 */
@Controller
@RequestMapping("/admin/adZone")
public class AdZoneController {
	@Autowired
	AdZoneService adZonService;
	@Autowired
	AdvertisementService advertisementService;
	@Autowired
	DictionaryService dictionaryService;

	/**
	 * 跳转广告位页面
	 */
	@RequestMapping(value = "/adZoneList")
	@Authorize(setting = "系统-广告位管理")
	public ModelAndView adZoneList() {
		return new ModelAndView("/admin/adZone/list");
	}

	/**
	 * 获取广告位列表数据
	 * 
	 * @param page
	 *            当前页
	 * @param limit
	 *            页大小
	 */
	@RequestMapping(value = "/getAdZoneList")
	@ResponseBody
	public Map<String, Object> getStoreList(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 计算起始值
		long totalCount = adZonService.countAdZoneList();
		Page p = new Page(totalCount, page, limit);
		map.put("start", p.getStartPos());
		map.put("pageSize", limit);
		List<Map<String, Object>> list = adZonService.selectAdZoneList(map);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}

	/**
	 * 广告位新增页
	 */
	@RequestMapping(value = "/addAdZoneInfo")
	public ModelAndView adZoneInfo() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("_op", "add");
		List<Map<String, Object>> list = dictionaryService.selectDictionaryInfo(2);
		map.put("list", list);
		return new ModelAndView("/admin/adZone/adZoneInfo", map);
	}

	/**
	 * 添加广告位
	 */
	@RequestMapping("/addAdZone")
	@ResponseBody
	public Map<String, Object> addAdZone(@RequestParam Map<String, Object> parMap, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		int row = adZonService.addAdZone(parMap);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "添加成功");
		} else {
			map.put("success", false);
			map.put("msg", "添加失败");
		}
		return map;
	}

	/**
	 * 广告位编辑页
	 */
	@RequestMapping(value = "/updateAdZoneInfo")
	public ModelAndView updateUrl(HttpServletRequest request) {
		Map<String, Object> reslut = new HashMap<String, Object>();
		String zoneID = request.getParameter("zoneID");
		Map<String, Object> map = adZonService.getAdZoneDetail(zoneID);
		reslut.put("_op", "update");
		reslut.put("adZoneInfo", map);
		List<Map<String, Object>> list = dictionaryService.selectDictionaryInfo(2);
		reslut.put("list", list);
		return new ModelAndView("/admin/adZone/adZoneInfo", reslut);
	}

	/**
	 * 编辑广告位
	 */
	@RequestMapping("/updateAdZone")
	@ResponseBody
	public Map<String, Object> updateAdZone(@RequestParam Map<String, Object> parMap, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		int row = adZonService.updateAdZone(parMap);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "编辑成功");
		} else {
			map.put("success", false);
			map.put("msg", "编辑失败");
		}
		return map;
	}

	/**
	 * 改变广告位状态
	 */
	@RequestMapping("/updateAdZoneStatus")
	@ResponseBody
	public Map<String, Object> updateAdZoneStatus(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String zoneID = request.getParameter("id");
		String status = request.getParameter("status");
		map.put("zoneID", zoneID);
		map.put("status", status);
		int row = adZonService.updateAdZoneStatus(map);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败");
		}
		return map;
	}

}