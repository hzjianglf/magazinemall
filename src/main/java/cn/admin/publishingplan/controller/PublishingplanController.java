package cn.admin.publishingplan.controller;

import java.io.File;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.periodical.service.PeriodicalService;
import cn.admin.publishingplan.service.PublishingplanService;
import cn.core.Authorize;
import cn.util.Page;
import cn.util.Tools;

@Controller
@RequestMapping(value = "/admin/publishingplan")
public class PublishingplanController {

		@Autowired
		PublishingplanService publishingplanService;
		@Autowired
		PeriodicalService periodicalService;
		
		
		
		//出版计划跳转
		@RequestMapping(value = "/list")
		@Authorize(setting = "系统管理-出版计划")
		public ModelAndView list(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("perId", request.getParameter("id"));
			//查询年份
			List<Map<String,Object>> list = publishingplanService.selYear(map);
			map.put("list", list);
			return new ModelAndView("/admin/publishingplan/list",map);
		}
		//获取出版计划数据
		@RequestMapping(value = "/listData")
		@ResponseBody
		public Map<String, Object> adminlistData(@RequestParam Map<String, Object> request, int page, int limit) {
			Map<String, Object> result = new HashMap<String, Object>();
			
			long totalCount = publishingplanService.getPublishingplanCount(request);// 得到总条数
			Page page2 = new Page(totalCount, page, limit);
			request.put("start", page2.getStartPos());
			request.put("pageSize", limit);
			List<Map<String, Object>> list = publishingplanService.getPublishingplanList(request);
			result.put("msg", "");
			result.put("code", 0);
			result.put("data", list);
			result.put("count", totalCount);
			return result;
		}
		
		
		/**
		 * 弹出出版计划添加页面
		 * 
		 * @return
		 */
		@RequestMapping(value = "/add")
		public ModelAndView addUrls(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			Map<String, Object> m = new HashMap<String, Object>();
			String id = request.getParameter("id");
			String perId = request.getParameter("perId");
			//查询期刊档案内容
			m = periodicalService.selOne(perId);
			map.put("perId", perId);
			map.put("name", m.get("name"));
			map.put("cycle", m.get("cycle"));
			if(StringUtils.isNullOrEmpty(id)){
				map.put("type", "add");
				//return new ModelAndView("/admin/publishingplan/sumProduct",map);
			}else{
				map.put("type", "edit");
				//通过id查询期刊内容
				m = publishingplanService.selOne(id);
				map.put("contentMap", m);
			}
			return new ModelAndView("/admin/publishingplan/details",map);
		}
		
		//添加出版计划
		@RequestMapping(value = "/adds")
		@ResponseBody
		public Map<String, Object> adds(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return publishingplanService.adds(param);
		}
		//修改出版计划
		@RequestMapping(value = "/ups")
		@ResponseBody
		public Map<String, Object> ups(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return publishingplanService.ups(param);
		}
		
		//删除出版计划
		@RequestMapping(value = "/deletePeriodical")
		@ResponseBody
		public Map<String, Object> deletePeriodical(@RequestParam String id, HttpServletRequest request) {
			return publishingplanService.deletePeriodical(id);
		}
		//出版计划禁用启用
		@RequestMapping(value = "/upState")
		@ResponseBody
		public Map<String, Object> upState(@RequestParam Map<String, Object> param,HttpServletRequest request) {
			return publishingplanService.upState(param);
		}
		
		
		
	}
