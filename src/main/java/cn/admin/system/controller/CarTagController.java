package cn.admin.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.system.service.CarTagService;
import cn.util.Page;

@Controller
@RequestMapping("/admin/system/carTag")
public class CarTagController {
	@Autowired
	CarTagService carTagService;
	@Autowired
	HttpSession session;

	/**
	 * 跳转标签管理列表页面
	 * 
	 * @return
	 */
	@RequestMapping("list")
	// @Authorize(setting = "系统-标签管理")
	public ModelAndView carTagPage() {
		return new ModelAndView("/admin/system/carTag/list");
	}

	/**
	 * 查询标签列表
	 * 
	 * @param request
	 * @param draw
	 * @param start
	 * @param pageSize
	 * @return
	 */
	@RequestMapping("getCarTagList")
	@ResponseBody
	public Map<String, Object> getcarTagList(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> parMap = new HashMap<String, Object>();
		long totalCount = carTagService.getCount();
		Page pages = new Page(totalCount, page, limit);
		parMap.put("start", pages.getStartPos());
		parMap.put("pageSize", limit);
		List<Map<String, Object>> list = carTagService.getCarTagList(parMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", totalCount);
		map.put("data", list);
		return map;
	}

	/**
	 * 跳转添加标签页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/add")
	// @Authorize(setting = "系统-标签添加")
	public ModelAndView addcarTag() {
		String lastCode = carTagService.getLastCode();
		String code = "001";
		if (lastCode != null) {
			int co = Integer.parseInt(lastCode);
			if (co < 10) {
				code = "00" + (co + 1);
			} else if (co < 100) {
				code = "0" + (co + 1);
			} else {
				code = "" + (co + 1);
			}
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code", code);
		return new ModelAndView("/admin/system/carTag/addCarTag", map);
	}

	/**
	 * 保存标签信息
	 * 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/saveCarTag")
	@ResponseBody
	public Map<String, Object> savecarTag(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String id = request.getParameter("id");
		String code = request.getParameter("code");
		String name = request.getParameter("name");
		String type = request.getParameter("type");
		String status = request.getParameter("status");
		map.put("code", code);
		map.put("name", name);
		map.put("type", type);
		map.put("status", status);
		int row = 0;
		String msgPrefix = "添加";
		if (!"".equals(id)) {
			map.put("id", id);
			row = carTagService.updateCarTag(map);
			msgPrefix = "修改";
		} else {
			row = carTagService.addCarTag(map);
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

	/**
	 * 跳转标签修改页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/getCarTagInfo")
	// @Authorize(setting = "系统-标签修改")
	public ModelAndView getcarTagInfo(Integer id) {
		Map<String, Object> map = carTagService.selectCarTagById(id);
		return new ModelAndView("/admin/system/carTag/addCarTag", map);
	}

	/**
	 * 删除标签(改为删除状态不真实删除数据)
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delCarTag")
	@ResponseBody
	// @Authorize(setting = "系统-标签删除")
	public Map<String, Object> delcarTag(int id) {
		Map<String, Object> map = new HashMap<String, Object>();
		int row = carTagService.deleteCarTag(id);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "删除成功!");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败!");
		}
		return map;
	}

	@RequestMapping(value = "modifyStatus")
	@ResponseBody
	// @Authorize(setting = "系统-标签禁用,系统-标签启用", type = AuthorizeType.ONE)
	public Map<String, Object> modifyStatus(@RequestParam Map<String, Object> param) {
		Map<String, Object> map = new HashMap<String, Object>();
		int row = carTagService.modifyStatus(param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功!");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败!");
		}
		return map;
	}

}