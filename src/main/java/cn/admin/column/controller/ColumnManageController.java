package cn.admin.column.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.column.service.ColumnManageService;
import cn.admin.content.service.ContentManageService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.template.Template.TemplateType;
import cn.template.TemplateLoader;
import cn.util.Tools;

@Controller
@RequestMapping("/admin/column")
public class ColumnManageController {
	@Autowired
	ColumnManageService columnManageService;
	@Autowired
	ContentManageService contentManageService;
	@Autowired
	HttpSession session;

	/**
	 * 进入到栏目管理页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/showColumn")
	// @Authorize(setting = "内容-栏目管理")
	public String showColumn() {
		return "/admin/column/ColumnManage";
	}

	/**
	 * 加载栏目列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/columnList")
	@ResponseBody
	public Map<String, Object> ColumnList() {
		Map<String, Object> columnMap = new HashMap<String, Object>();
		List<Map<String, Object>> list = columnManageService.ColumnList();
		columnMap.put("list", list);
		return columnMap;
	}

	/**
	 * 添加和修改栏目页面跳转
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/showContent")
	// @Authorize(setting = "内容-栏目添加, 内容-栏目修改", type = AuthorizeType.ONE)
	public ModelAndView showContentByFrame(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");// 操作类型，add：添加；revise：修改
		String catId = request.getParameter("catId");// 要添加到所属栏目的id
		List<Map<String, Object>> columnList = columnManageService.ColumnList();// 查询所有栏目列表，用于页面所属栏目下拉使用
		map.put("columnList", columnList);
		// 解析模板的内容
		Set<String> defaultSet = TemplateLoader.getNames(TemplateType.Default);// 单页模板
		Set<String> listSet = TemplateLoader.getNames(TemplateType.List);// 列表页模板
		Set<String> detailSet = TemplateLoader.getNames(TemplateType.Detail);// 详情页页模板
		map.put("defaultSet", defaultSet);
		map.put("listSet", listSet);
		map.put("detailSet", detailSet);
		if ("revise".equals(type)) {
			// 修改时，查询要修改栏目的信息，回显到页面
			Map<String, Object> columnMap = columnManageService.selectColumnById(Integer.parseInt(catId));
			map.put("columnMap", columnMap);
		}
		map.put("catId", catId);
		map.put("type", type);
		return new ModelAndView("/admin/column/add", map);
	}

	/**
	 * 添加栏目信息
	 * 
	 * @param columnMap
	 * @return
	 */
	@RequestMapping(value = "/saveColumnInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(@RequestParam Map<String, Object> columnMap) {
		if (columnMap.containsKey("IsActive")) {
			columnMap.put("IsRec", 1);
		} else {
			columnMap.put("IsRec", 0);
		}
		if (columnMap.containsKey("IsShowOnMenu")) {
			columnMap.put("IsShowOnMenu", 1);
		} else {
			columnMap.put("IsShowOnMenu", 0);
		}
		if (columnMap.containsKey("IsShowOnPath")) {
			columnMap.put("IsShowOnPath", 1);
		} else {
			columnMap.put("IsShowOnPath", 0);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		if (columnMap.get("catId") == null || "".equals(columnMap.get("catId").toString())) {
			map = columnManageService.add(columnMap);
		} else {
			if (!columnMap.containsKey("imgUrl") || "".equals(columnMap.get("imgUrl").toString())) {
				columnMap.put("imgUrl", columnMap.get("oldImgUrl").toString());
			}
			map = columnManageService.updateColumn(columnMap);
		}
		return map;
	}

	@RequestMapping(value = "/uploadImg")
	@ResponseBody
	public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
		// 文件上传
		String imgUrl = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir("column");
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
			;
			imgUrl = "/" + pathSub + newFileName;// 保存到数据库的路径
		}
		return "{\"data\": \"" + imgUrl + "\"}";
	}

	/**
	 * 删除栏目信息
	 * 
	 * @param catId
	 * @return
	 */
	@RequestMapping(value = "/delColumnInfo", method = RequestMethod.POST)
	@ResponseBody
	// @Authorize(setting = "内容-栏目删除")
	public Map<String, Object> delColumn(@RequestParam(value = "catId") int catId) {
		Map<String, Object> delMap = columnManageService.delColumn(catId);
		return delMap;
	}

	/**
	 * 移动栏目信息,更改栏目的顺序
	 * 
	 * @param parentId
	 * @param moveType
	 * @param catId
	 * @return
	 */
	@RequestMapping(value = "/updateParentId", method = RequestMethod.POST)
	@ResponseBody
	// @Authorize(setting = "内容-栏目移动")
	public Map<String, Object> updateParentId(@RequestParam int parentId, @RequestParam String moveType,
			@RequestParam int catId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentId", parentId);
		map.put("catId", catId);
		if (moveType.equals("inner")) {
			int row = columnManageService.updateParentId(map);
			if (row > 0) {
				map.put("message", "栏目信息移动成功");
			} else {
				map.put("message", "栏目信息移动失败");
			}
		} else {
			int row = columnManageService.updateOrder(map);
			if (row > 0) {
				map.put("message", "栏目信息移动成功");
			} else {
				map.put("message", "栏目信息移动失败");
			}
		}
		return map;
	}

}
