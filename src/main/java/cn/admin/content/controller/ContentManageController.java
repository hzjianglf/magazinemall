package cn.admin.content.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import cn.AdminRewriteFilter;
import cn.Setting.Model.AdminPreFixSetting;
import cn.admin.column.service.ColumnManageService;
import cn.admin.content.service.ContentManageService;
import cn.admin.system.service.DictionaryService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.Page;
import cn.util.Tools;

@Controller
@RequestMapping("/admin/content")
public class ContentManageController {
	@Autowired
	ContentManageService contentManageService;
	@Autowired
	ColumnManageService columnManageService;
	@Autowired
	DictionaryService dictionaryService;
	@Autowired
	HttpSession session;

	/**
	 * 跳转到内容管理页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showColumn")
	// @Authorize(setting = "内容-文章列表")
	public String showColumn() {
		return "/admin/content/list";
	}

	/**
	 * 加载树形菜单
	 * 
	 * @return
	 */
	@RequestMapping(value = "/selectColumnList")
	@ResponseBody
	public Map<String, Object> ColumnList() {
		Map<String, Object> columnMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = columnManageService.ColumnList();
		columnMap.put("list", list);
		return columnMap;
	}

	/**
	 * 跳转文章列表页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/contentList")
	public ModelAndView contentList(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String catId = request.getParameter("catId");
		String catType = request.getParameter("type");
		Map<String, Object> searchInfo = new HashMap<String, Object>();
		int Id = 0;
		if (catId != null && !"".equals(catId)) {
			Id = Integer.parseInt(catId);
			searchInfo.put("catId", Id);
			Map<String, Object> columnMap = columnManageService.selectColumnById(Id);
			map.put("catName", " &gt; " + columnMap.get("catName").toString());
		}
		map.put("catId", Id);
		if ("2".equals(catType)) {
			searchInfo.put("start", 0);
			searchInfo.put("pageSize", 1);
			List<Map<String, Object>> contentList = contentManageService.selContentByCatId(searchInfo);
			List<Map<String, Object>> columnList = columnManageService.ColumnList();
			map.put("contentList", contentList);
			map.put("columnList", columnList);
			map.put("catType", catType);
			return new ModelAndView("/admin/content/singlePageAdd", map);
		} else {
			return new ModelAndView("/admin/content/contentManage", map);
		}
	}

	/**
	 * 通过栏目Id查询该栏目下的新闻列表
	 * 
	 * @param Id
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/selContentByCatId")
	@ResponseBody
	public Map<String, Object> selContentById(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> searchInfo = new HashMap<String, Object>();
		String catId = request.getParameter("catId");
		String title = request.getParameter("title");
		if (!"0".equals(catId)) {
			searchInfo.put("catId", catId);
		}
		searchInfo.put("title", title);
		long totalCount = contentManageService.getTotalContentByCatId(searchInfo);// 得到总条数
		Page pages = new Page(totalCount, page, limit);
		searchInfo.put("start", pages.getStartPos());
		searchInfo.put("pageSize", limit);
		List<Map<String, Object>> contentList = contentManageService.selContentByCatId(searchInfo);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", totalCount);
		map.put("data", contentList);
		return map;
	}

	/**
	 * 删除内容管理条目（逻辑删除）
	 * 
	 * @param contentId
	 * @return
	 */
	@RequestMapping(value = "/delContentInfo", method = RequestMethod.POST)
	@ResponseBody
	// @Authorize(setting = "内容-文章删除")
	public Map<String, Object> updateContentStaus(@RequestParam(value = "contentId") String contentId) {
		Map<String, Object> map = new HashMap<>();
		String[] strs = contentId.split(",");
		map.put("list", strs);
		Map<String, Object> updateMapStatus = contentManageService.updateContentStaus(map);
		return updateMapStatus;
	}

	/**
	 * 添加和修改新闻内容页面跳
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/showContent")
	// @Authorize(setting = "内容-文章添加, 内容-文章修改", type = AuthorizeType.ONE)
	public ModelAndView showColumn(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");// 操作类型，add：添加；edit：修改
		String contentId = request.getParameter("contentId");// 新闻内容id
		String catId = request.getParameter("catId");
		List<Map<String, Object>> columnList = columnManageService.ColumnList();
		map.put("columnList", columnList);
		int Id = Integer.parseInt(catId);
		Map<String, Object> columnMap = columnManageService.selectColumnById(Id);
		if (columnMap != null) {
			map.put("catName", " &gt; " + columnMap.get("catName").toString());
		}
		if ("edit".equals(type)) {
			Map<String, Object> contentMap = contentManageService.selectContentById(Integer.parseInt(contentId));
			map.put("contentMap", contentMap);
		}
		map.put("catId", catId);
		map.put("type", type);
		return new ModelAndView("/admin/content/add", map);
	}

	@RequestMapping(value = "/uploadImg")
	@ResponseBody
	public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
		// 文件上传
		String imgUrl = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir("content");
		// 获取路径 upload/Advertisement/yyyyMMdd/
		String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");
		if (files.isEmpty()) {
			imgUrl = "";
		} else {
			String newFileName = files.getOriginalFilename();// 获取图片名称
			String newFilePath = filePath + newFileName;// 新路径
			File newFile = new File(newFilePath);
			if (newFile.exists()) {
				String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				newFileName = time + "_" + files.getOriginalFilename();
				newFilePath = filePath + newFileName;
				newFile = new File(newFilePath);
			}
			try {
				files.transferTo(newFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			imgUrl = "/" + pathSub + newFileName;// 保存到数据库的路径
		}
		return "{\"data\": \"" + imgUrl + "\"}";
	}

	/**
	 * 添加新闻
	 * 
	 * @param files
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/saveContent")
	public String add(HttpServletRequest req) {
		Map<String, Object> contentMap = this.accept(req);
		String catId = req.getParameter("parentId");
		String catType = req.getParameter("catType");
		String contentId = req.getParameter("contentId");
		contentMap.put("createUserId", session.getAttribute("userId"));
		if (contentId == null || "".equals(contentId)) {
			contentManageService.add(contentMap);
		} else {
			if (!contentMap.containsKey("picUrl") || "".equals(contentMap.get("picUrl").toString())) {
				contentMap.put("picUrl", contentMap.get("oldPicUrl").toString());
			}
			contentMap.put("contentId", contentId);
			contentMap.put("updateTime",
					LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
			contentManageService.updateContent(contentMap);
		}
		if (catType == null || "".equals(catType)) {
			return "redirect:/" + AdminRewriteFilter.adminPrefix + "/content/contentList?catId=" + catId;
		} else {
			return "redirect:/" + AdminRewriteFilter.adminPrefix + "/content/contentList?catId=" + catId + "&type=" + catType;
		}
	}

	// 查询内容回收站列表页
	@RequestMapping(value = "/rubbishList")
	// @Authorize(setting = "内容-回收站")
	public ModelAndView selectContentRubbishList() {
		return new ModelAndView("/admin/content/rubbish");
	}

	@RequestMapping("/rubbishData")
	@ResponseBody
	public Map<String, Object> rubbishData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> searchInfo = new HashMap<String, Object>();
		String title = request.getParameter("title");
		searchInfo.put("title", title);
		long totalCount = contentManageService.getRubbishTotalCount(searchInfo);// 得到总条数
		Page pages = new Page(totalCount, page, limit);
		searchInfo.put("start", pages.getStartPos());
		searchInfo.put("pageSize", limit);
		List<Map<String, Object>> rubbishList = contentManageService.ContentRubbishList(searchInfo);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", totalCount);
		map.put("data", rubbishList);
		return map;
	}

	// 彻底删除回收站中的内容信息
	@RequestMapping(value = "/delRubbish")
	@ResponseBody
	// @Authorize(setting = "内容-回收站彻底删除")
	public Map<String, Object> del(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> delList = new ArrayList<String>();
		String items = request.getParameter("contentId");
		String[] strs = items.split(",");
		for (String str : strs) {
			delList.add(str);
		}
		int row = contentManageService.delRubbishInfo(delList);
		if (row > 0) {
			map.put("message", "删除成功");
		} else {
			map.put("message", "删除失败");
		}
		return map;
	}

	// 从回收站中的还原选择
	@RequestMapping(value = "/restoreRubbishInfo")
	@ResponseBody
	// @Authorize(setting = "内容-回收站还原")
	public Map<String, Object> restore(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> delList = new ArrayList<String>();
		String items = request.getParameter("contentId");
		String[] strs = items.split(",");
		for (String str : strs) {
			delList.add(str);
		}
		int row = contentManageService.updateRubbishInfo(delList);
		if (row > 0) {
			map.put("message", "还原成功");
		} else {
			map.put("message", "还原失败");
		}
		return map;
	}

	// 获取前台页面的参数
	public Map<String, Object> accept(HttpServletRequest req) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("catId", Integer.parseInt(req.getParameter("parentId")));
		map.put("title", req.getParameter("title"));
		map.put("subTitle", req.getParameter("subTitle"));
		map.put("keywords", req.getParameter("keywords"));
		map.put("createTime", req.getParameter("createTime"));
		map.put("textUrl", req.getParameter("textUrl"));
		map.put("author", req.getParameter("author"));
		map.put("summary", req.getParameter("summary"));
		map.put("mainContent", req.getParameter("mainContent"));
		map.put("webTitle", req.getParameter("webTitle"));
		map.put("webDescription", req.getParameter("webDescription"));
		map.put("picUrl", req.getParameter("picUrl"));
		map.put("oldPicUrl", req.getParameter("oldPicUrl"));
		return map;
	}

	/******************************************
	 * 超级分割线
	 ****************************************************/

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
