package cn.admin.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.system.service.VersionService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;

@Controller
@RequestMapping("/admin/version")
public class VersionController {
	@Autowired
	VersionService versionService;
	@Autowired
	private Environment environment;
	
	
	@RequestMapping("/list")
	@Authorize(setting = "系统管理-版本管理")
	public ModelAndView index() {
		return new ModelAndView("/admin/system/version/list");
	}
	//版本列表
	@RequestMapping(value="/versionListData")
	@ResponseBody
	public Map versionListData(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		List<Map> list = new ArrayList<Map>();
		Map<String,Object> map = new HashMap<String, Object>();
		long totalCount = 0;
		totalCount = versionService.selectAboutVersionCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		list = versionService.selectAboutVersion(search);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	//发布新版本
	@RequestMapping("releaseNewVersion")
	public ModelAndView releaseNewVersion(HttpServletRequest request){
		String id = request.getParameter("id");
		Map<String,Object> reqMap = new HashMap<String,Object>();
		if(id !=null) {
			reqMap = versionService.selByVersionId(id);
		}
		return new ModelAndView("/admin/system/version/releaseNewVersion",reqMap);
	}
	/**
	 * 版本发布或编辑
	 * @param paramap
	 * @param request
	 * @return
	 */
	@RequestMapping("newVersionToSave")
	@ResponseBody
	public Map<String,Object> newVersionToSave(@RequestParam Map<String,Object> paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> versionMap = new HashMap<String,Object>();
		String id = request.getParameter("Id");
		if(StringUtils.isNullOrEmpty(id)){//发布新版本
			if(Integer.parseInt(paramap.get("versionType").toString())==1) {//获取最新安卓版versionCode
				versionMap = versionService.sellatestVersionInfo(Integer.parseInt(paramap.get("versionType").toString()));
				paramap.put("packageUrl", environment.getProperty("androidVersionUrl","http://tzxl.kuguanyun.net/images/xsysc.apk"));
			}else if(Integer.parseInt(paramap.get("versionType").toString())==2) {//获取最新ios版versionCode
				versionMap = versionService.sellatestVersionInfo(Integer.parseInt(paramap.get("versionType").toString()));
				paramap.put("packageUrl", environment.getProperty("iosVersionUrl","www.pgyer.com/fGw8"));
			}
			if(versionMap !=null && versionMap.size()>0) {
				Integer versionCode = Integer.parseInt(versionMap.get("versionCode").toString());
				versionCode+=1;
				paramap.put("versionCode", versionCode);
			}else {
				int versionCode = 0;
				versionCode+=1;
				paramap.put("versionCode", versionCode);
			}
			
			 String versionNum =  paramap.get("versionNum").toString();
			 String name = "销售与市场"+"|"+versionNum;
			 paramap.put("name", name);
			 versionService.newVersionToSave(paramap);
		}else{//编辑新版本
			paramap.put("Id", id);
			String versionNum =  paramap.get("versionNum").toString();
			String name = "销售与市场"+"|"+versionNum;
			paramap.put("name", name);
			versionService.newVersionToUpdate(paramap);
			
		}
		map.put("msg", "操作成功");
		map.put("success", true);
		return map;
	}
	
	@RequestMapping("deleteVersionRecord")
	@ResponseBody
	public Map<String,Object> deleteVersionRecord(@RequestParam Map<String,Object> paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		versionService.deleteVersionRecord(paramap);
		map.put("msg", "操作成功");
		map.put("success", true);
		return map;
	}
	@RequestMapping("setIsEnable")
	@ResponseBody
	public Map<String,Object> setIsEnable(@RequestParam Map<String,Object> paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		versionService.newVersionToUpdate(paramap);
		map.put("msg", "操作成功");
		map.put("success", true);
		return map;
	}
	
}
