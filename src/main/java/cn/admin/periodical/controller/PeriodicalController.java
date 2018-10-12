package cn.admin.periodical.controller;

import java.io.File;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.Tools;

@Controller
@RequestMapping(value = "/admin/periodical")
public class PeriodicalController {

		@Autowired
		PeriodicalService periodicalService;
		
		
		//跳转栏目页面
		@RequestMapping(value="/turnColumn")
		public ModelAndView turnColumn(int id){
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("id", id);
			return new ModelAndView("/admin/publishingplan/column",map);
		}
		//查询栏目和板块
		@RequestMapping("selectColumns")
		@ResponseBody
		public Map<String,Object> selectColumns(@RequestParam Map<String, Object> map,int page,int limit){
			map.put("isFree",DataConvert.ToInteger(map.get("isFree")));
			long totalCount = periodicalService.selectColumnsCount(map);
			Page pages = new Page(totalCount, page, limit);
			map.put("start", pages.getStartPos());
			map.put("pageSize", limit);
			List list = periodicalService.selectColumnsData(map);
			Map<String,Object> result = new HashMap<String, Object>();
			result.put("msg", "");
			result.put("code", 0);
			result.put("data", list);
			result.put("count", totalCount);
			return result;
		}
		//跳转添加栏目或板块的页面
		@RequestMapping("turnAddCategoryOrColumns")
		public ModelAndView addCategoryOrColumns(int type,Integer id,int publishId){
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("type", type);
			map.put("publishId", publishId);
			List list = periodicalService.selCategoryByPubId(publishId);
			map.put("list", list);
			if(null!=id){
				map.put("id", id);
				Map detail = periodicalService.selCategoryOrColumnsById(map);
				detail.put("type", type);
				detail.put("list", list);
				return new ModelAndView("/admin/publishingplan/addCategoryOrColumns",detail);
			}
			return new ModelAndView("/admin/publishingplan/addCategoryOrColumns",map);
		}
		//修改栏目或板块的状态
		@RequestMapping("updStatus")
		@ResponseBody
		public Map<String,Object> updStauts(@RequestParam Map<String,Object> map){
			return periodicalService.updStatus(map);
		}
		//删除栏目或板块
		@RequestMapping("delCategoryOrColumns")
		@ResponseBody
		public Map<String,Object> delCategoryOrColumns(@RequestParam Map<String,Object> map){
			return periodicalService.delCategoryOrColumns(map);
		}
		//添加/编辑栏目、板块
		@RequestMapping("/addCategoryOrColumns")
		@ResponseBody
		public Map<String,Object> addCategoryOrColumns(@RequestParam Map<String,Object> map){
			if(DataConvert.ToInteger(map.get("id"))==null || DataConvert.ToInteger(map.get("id"))==0){
				return periodicalService.addCategoryOrColumns(map);
			}else{
				return periodicalService.updCategoryOrColumns(map);
			}
		}
		//期刊档案跳转
		@RequestMapping(value = "/archives")
		//@Authorize(setting = "系统管理-刊期档案")
		public ModelAndView archives() {
			return new ModelAndView("/admin/periodical/archives");
		}
		//期刊档案跳转
		@RequestMapping(value = "/list")
		@Authorize(setting = "系统管理-刊期档案")
		public ModelAndView list() {
			return new ModelAndView("/admin/periodical/list");
		}
		//获取期刊档案数据
		@RequestMapping(value = "/listData")
		@ResponseBody
		public Map<String, Object> adminlistData(@RequestParam Map<String, Object> request, int page, int limit) {
			Map<String, Object> result = new HashMap<String, Object>();
			if (request.containsKey("regTime2") && !"".equals(request.get("regTime2").toString())) {
				String regTime2 = request.get("regTime2").toString();
				regTime2 = LocalDate.parse(regTime2).plusDays(1).toString();
				request.put("regTime2", regTime2);
			}
			long totalCount = periodicalService.getPeriodicalCount(request);// 得到总条数
			Page page2 = new Page(totalCount, page, limit);
			request.put("start", page2.getStartPos());
			request.put("pageSize", limit);
			List<Map<String, Object>> list = periodicalService.getPeriodicalList(request);
			result.put("msg", "");
			result.put("code", 0);
			result.put("data", list);
			result.put("count", totalCount);
			return result;
		}
		
		
		/**
		 * 弹出期刊添加页面
		 * 
		 * @return
		 */
		@RequestMapping(value = "/add")
		//@Authorize(setting = "用户-管理员添加")
		public ModelAndView addUrls(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			Map<String, Object> m = new HashMap<String, Object>();
			String id = request.getParameter("id");
			if(StringUtils.isNullOrEmpty(id)){
				map.put("type", "add");
				map.put("contentMap", m.put("id", ""));
			}else{
				map.put("type", "edit");
				//通过id查询期刊内容
				m = periodicalService.selOne(id);
				map.put("contentMap", m);
			}
			return new ModelAndView("/admin/periodical/details",map);
		}
		
		//添加期刊
		@RequestMapping(value = "/adds")
		@ResponseBody
		public Map<String, Object> adds(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return periodicalService.adds(param);
		}
		//修改期刊
		@RequestMapping(value = "/ups")
		@ResponseBody
		public Map<String, Object> ups(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return periodicalService.ups(param);
		}
		
		//删除期刊
		@RequestMapping(value = "/deletePeriodical")
		@ResponseBody
		public Map<String, Object> deletePeriodical(@RequestParam String id, HttpServletRequest request) {
			return periodicalService.deletePeriodical(id);
		}
		//期刊禁用启用
		@RequestMapping(value = "/upState")
		@ResponseBody
		public Map<String, Object> upState(@RequestParam Map<String, Object> param,HttpServletRequest request) {
			return periodicalService.upState(param);
		}
		
		
		@RequestMapping(value = "/uploadimage")
		@ResponseBody
		public Map<String, String> config(HttpServletRequest request) {
			Map<String, String> map = new HashMap<String, String>();
			if (request instanceof MultipartHttpServletRequest) {
				MultipartFile files = ((MultipartHttpServletRequest) request).getFile("upfile");
				String filePath = Tools.getUploadDir("content");
				String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");// 获取路径
																									// upload/Advertisement/yyyyMMdd/
				MultipartFile upFile = files;
				String newFileName = upFile.getOriginalFilename();// 获取图片名称
				String newFilePath = filePath + newFileName;// 新路径
				File newFile = new File(newFilePath);
				if (newFile.exists()) {
					String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
					newFileName = time + "_" + upFile.getOriginalFilename();
					newFilePath = filePath + newFileName;
					newFile = new File(newFilePath);
				}
				try {
					upFile.transferTo(newFile);
				} catch (Exception e) {
					e.printStackTrace();
				}
				map.put("name", newFileName);
				map.put("state", "SUCCESS");
				map.put("url", "/" + pathSub + newFileName);// 保存到数据库的路径
			}
			return map;
		}
		
	}
