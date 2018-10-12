package cn.admin.adzone.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONArray;

import cn.admin.adzone.service.AdZoneService;
import cn.admin.adzone.service.AdvertisementService;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;

@Controller
@RequestMapping("/admin/adver")
public class AdvertisementController {
	@Autowired
	AdvertisementService advertisementService;
	@Autowired
	AdZoneService adZonService;

	@RequestMapping("/list")
	// @Authorize(setting = "系统-广告管理")
	public ModelAndView pageTo(String zoneID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("zoneID", zoneID);
		return new ModelAndView("/admin/adver/list", map);
	}
	/**
	 * 添加页面展示商品
	 * @param request
	 * @param page
	 * @param limit
	 * @return
	 */
	@RequestMapping(value="/selectProduct")
	@ResponseBody
	public Map<String, Object> selectProduct(@RequestParam Map reqMap, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		long count = advertisementService.selectProductCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = advertisementService.selProduct(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	
	

	// 查询所有广告
	@RequestMapping(value = "/dataList")
	@ResponseBody
	public Map<String, Object> dataList(String zoneID, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> selAdver = new HashMap<String, Object>();
		selAdver.put("zoneID", Integer.valueOf(zoneID));
		long totalCount = advertisementService.getTotalCount(selAdver);// 得到总条数
		Page pages = new Page(totalCount, page, limit);
		selAdver.put("start", pages.getStartPos());
		selAdver.put("pageSize", limit);
		List<Map<String, Object>> list = advertisementService.selectAdver(selAdver);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", totalCount);
		map.put("data", list);
		return map;
	}

	// 添加广告跳转
	@RequestMapping(value = "/add")
	// @Authorize(setting = "系统-广告添加")
	public ModelAndView addUrl(String zoneID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("zoneID", zoneID);
		return new ModelAndView("/admin/adver/addAdver", map);
	}

	// 添加(修改)广告
	@RequestMapping(value = "/addAdver")
	@ResponseBody
	public Map<String, Object> addAdver(@RequestParam Map<String, Object> map) {
		if (map.get("passed") == null) {
			map.put("passed", 0);
		} else {
			map.put("passed", 1);
		}
		int row = 0;
		String msgPrefix = "添加";
		if (map.containsKey("aDID") && !"".equals(map.get("aDID").toString())) {
			if (map.get("imgUrl") == null || "".equals(map.get("imgUrl"))) {
				map.put("imgUrl", map.get("oldImgUrl"));
			}
			
			String itemId = map.get("itemId").toString();
			String itemType =map.get("itemType").toString();
			String itemSumType =map.get("itemSumType").toString();
			String itemName =map.get("itemName").toString();
			String jsonUrl = "{\"itemId\":"+itemId+",\"itemType\":"+itemType+",\"itemSumType\":"+itemSumType+",\"itemName\":"+"\""+itemName+"\"}";
			map.put("linkUrl", jsonUrl);
			row = advertisementService.updateAdver(map);
			msgPrefix = "修改";
		} else {
			String itemId = map.get("itemId").toString();
			String itemType =map.get("itemType").toString();
			String itemSumType =map.get("itemSumType").toString();
			String itemName =map.get("itemName").toString();
			String jsonUrl = "{\"itemId\":"+itemId+",\"itemType\":"+itemType+",\"itemSumType\":"+itemSumType+",\"itemName\":"+"\""+itemName+"\"}";
			map.put("linkUrl", jsonUrl);
			row = advertisementService.addAdver(map);
		}
		Map<String, Object> result = new HashMap<>();
		if (row > 0) {
			result.put("success", true);
			result.put("msg", msgPrefix + "成功");
		} else {
			result.put("success", false);
			result.put("msg", msgPrefix + "失败");
		}
		return result;
	}

	@RequestMapping(value = "/uploadImg")
	@ResponseBody
	public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
		// 上传图片
		String SiteLogo = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir("Advertisement");
		String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");// 获取路径
		if (files.isEmpty()) {
			SiteLogo = "";
		} else {
			String newFileName = files.getOriginalFilename();// 获取图片名称
			String newFilePath = filePath + newFileName;// 新路径
			File newFile = new File(newFilePath);
			if (newFile.exists()) {
				String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddhhmmssSSS"));
				newFileName = time + "_" + files.getOriginalFilename();
				newFilePath = filePath + newFileName;
				newFile = new File(newFilePath);
			}
			try {
				files.transferTo(newFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			SiteLogo = "/" + pathSub + newFileName;// 保存到数据库的路径
		}
		return "{\"data\": \"" + SiteLogo + "\"}";
	}

	// 修改广告跳转
	@RequestMapping(value = "/update")
	// @Authorize(setting = "系统-广告修改")
	public ModelAndView updateUrl(@RequestParam("aDID") Integer aDID, @RequestParam("zoneID") Integer zoneID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map = advertisementService.updateUrl(aDID);
		if(map !=null && map.size()>0) {
			String linkUrl = map.get("linkUrl").toString();
			Map<String, Object> maps = Tools.JsonToMap(linkUrl);
			if(maps !=null && maps.size()>0) {
				map.put("itemName", maps.get("itemName"));
				map.put("itemId", maps.get("itemId"));
				map.put("itemType", maps.get("itemType"));
				map.put("itemSumType", maps.get("itemSumType"));
			}
		}
		map.put("zoneID", zoneID);
		return new ModelAndView("/admin/adver/addAdver", map);
	}
	/**
	 * 跳转页面
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/adverToAddProduct")
	public ModelAndView adverToAddProduct(@RequestParam Map map){
		return new ModelAndView("/admin/adver/adverAddProduct",map);
	}
	

	// 批量删除广告
	@RequestMapping(value = "/deletes")
	@ResponseBody
	// @Authorize(setting = "广告删除")
	public Map<String, Object> del(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> delList = new ArrayList<String>();
		String items = request.getParameter("delitems");
		String[] strs = items.split(",");
		for (String str : strs) {
			delList.add(str);
		}
		int row = advertisementService.delAdver(delList);
		row = advertisementService.delAD(delList);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "删除成功");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败");
		}
		return map;
	}

	// 批量暂停审核广告
	@RequestMapping(value = "/upadtePassed1")
	@ResponseBody
	// @Authorize(setting = "系统-广告停用")
	public Map<String, Object> upd(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> delList = new ArrayList<String>();
		String items = request.getParameter("delitems");
		String[] strs = items.split(",");
		for (String str : strs) {
			delList.add(str);
		}
		int row = advertisementService.updAdver(delList);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "停用成功");
		} else {
			map.put("success", false);
			map.put("msg", "停用失败");
		}
		return map;
	}

	// 批量通过审核广告
	@RequestMapping(value = "/upadtePassed2")
	@ResponseBody
	// @Authorize(setting = "系统-广告启用")
	public Map<String, Object> upd2(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> delList = new ArrayList<String>();
		String items = request.getParameter("delitems");
		String[] strs = items.split(",");
		for (String str : strs) {
			delList.add(str);
		}
		int row = advertisementService.updAdver2(delList);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "启用成功");
		} else {
			map.put("success", false);
			map.put("msg", "启用失败");
		}
		return map;
	}

}