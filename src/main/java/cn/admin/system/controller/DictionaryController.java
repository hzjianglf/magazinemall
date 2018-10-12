package cn.admin.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.system.service.DictionaryService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.Page;

/**
 * 
 * @author LuBin
 * @date 2016年7月21日 下午4:44:39
 */
@Controller
@RequestMapping("/admin/system/dictionary")
public class DictionaryController {
	@Autowired
	DictionaryService dictService;

	/**
	 * 字典表
	 * 
	 */
	@RequestMapping("/list")
	@Authorize(setting = "字典-数据字典管理")
	public ModelAndView selectdict(HttpServletRequest request) {
		return new ModelAndView("/admin/system/dictionary/list");
	}

	@RequestMapping(value = "/listData")
	@ResponseBody
	public Object dataTable(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		String title = request.getParameter("title");
		map.put("title", title);
		// 得到总条数
		long totalCount = dictService.getTotalCount(map);
		Page pages = new Page(totalCount, page, limit);
		map.put("start", pages.getStartPos());
		map.put("pageSize", limit);
		// 查询List
		List<Map<String, Object>> list = dictService.selectDictionary(map);
		Map<String, Object> result = new HashMap<>();
		result.put("code", 0);
		result.put("msg", "");
		result.put("count", totalCount);
		result.put("data", list);
		return result;
	}

	// 添加字典弹窗
	@RequestMapping("/addDictModel")
	@Authorize(setting = "字典-添加字典项")
	public ModelAndView addDict() {
		List<Map<String, Object>> typeList = dictService.selectDictionaryTypeList();
		Map<String, Object> map = new HashMap<>();
		map.put("typeList", typeList);
		return new ModelAndView("/admin/system/dictionary/addDict", map);
	}

	// 修改字典弹窗
	@RequestMapping("/updateDict")
	@Authorize(setting = "字典-修改字典项")
	public ModelAndView shuntUrl(@RequestParam("dictId") String dictId) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 代表这是修改
		map.put("dic", dictService.selectDictionaryById(Integer.parseInt(dictId)));
		List<Map<String, Object>> typeList = dictService.selectDictionaryTypeList();
		map.put("typeList", typeList);
		return new ModelAndView("/admin/system/dictionary/addDict", map);
	}

	// 添加和修改字典项
	@RequestMapping("/addOrUpDictionary")
	@ResponseBody
	public Map<String, Object> addOrUpDictionary(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String dictionaryId = request.getParameter("dictionaryId");
		String dictionaryName = request.getParameter("dictionaryName");
		String dictionaryDescription = request.getParameter("dictionaryDescription");
		String dictionaryType = request.getParameter("dictionaryType");
		map.put("dictionaryId", dictionaryId);
		map.put("dictionaryName", dictionaryName);
		map.put("dictionaryDescription", dictionaryDescription);
		map.put("dictionaryType", dictionaryType);
		Map<String, Object> result = new HashMap<>();
		if (dictionaryId != null && !"".equals(dictionaryId)) {
			int a = dictService.updateDict(map);
			if (a > 0) {
				result.put("success", true);
				result.put("msg", "修改成功");
			} else {
				result.put("success", false);
				result.put("msg", "修改失败");
			}
		} else {
			int b = dictService.addDict(map);
			if (b > 0) {
				result.put("success", true);
				result.put("msg", "添加成功");
			} else {
				result.put("success", false);
				result.put("msg", "添加失败");
			}
		}
		return result;
	}

	@RequestMapping("/delDict")
	@ResponseBody
	@Authorize(setting = "字典-删除字典项")
	public Map<String, Object> delDict(@RequestParam int dictId) {
		Map<String, Object> map = new HashMap<String, Object>();
		long num = dictService.selectDictionaryInfoCount(dictId);
		if (num > 0) {
			map.put("success", false);
			map.put("msg", "删除失败！该字典下还存在值！");
		} else {
			int row = dictService.delteDict(dictId);
			if (row > 0) {
				map.put("success", true);
				map.put("msg", "删除成功！");
			} else {
				map.put("success", false);
				map.put("msg", "删除失败！");
			}
		}
		return map;
	}

	/**
	 * 
	 * @Description: 字典详细列表
	 */
	@RequestMapping(value = "/showDictInfo", method = { RequestMethod.GET, RequestMethod.POST })
	@Authorize(setting = "字典-查看字典详细")
	public ModelAndView selectdictInfo(@RequestParam("dictId") int dictId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("dictId", dictId);
		//查询字典名称
		String name = dictService.selDictName(map);
		map.put("dictionaryName", name);
		return new ModelAndView("/admin/system/dictionary/itemList", map);
	}

	@RequestMapping(value = "/dataInfo")
	@ResponseBody
	public Object selectdictInfo (HttpServletRequest request, int page, int limit) {
		String dictId = request.getParameter("dictId");
		// 得到总条数
		long totalCount = dictService.selectDictionaryInfoCount(Integer.parseInt(dictId));
		// 查询List
		List<Map<String, Object>> list = dictService.selectDictionaryInfo(Integer.parseInt(dictId));
		//
		Map<String, Object> result = new HashMap<>();
		result.put("code", 0);
		result.put("msg", "");
		result.put("count", totalCount);
		result.put("data", list);
		return result;
	}

	// 添加字典详细，修改字典详细，的弹窗
	@RequestMapping("/addOrUpItemModel")
	@Authorize(setting = "字典-添加字典详细,字典-修改字典详细", type = AuthorizeType.ONE)
	public ModelAndView addOrUpItemModel(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<>();
		String dictId = request.getParameter("dictId");
		String itemId = request.getParameter("itemId");
		map.put("itemId", itemId);
		map.put("dictId", dictId);
		if (itemId.equals("0")) {
			// 添加
		} else {
			// 修改
			Map<String, Object> itemMap = dictService.selectDictionaryInfoByItemId(Integer.parseInt(itemId));
			map.put("itemMap", itemMap);
		}
		return new ModelAndView("/admin/system/dictionary/addOrUpItem", map);

	}

	// 修改（添加）数字字典详情
	@RequestMapping("/addOrUpItem")
	@ResponseBody
	public Map<String, Object> addOrUpItem(HttpServletRequest request) {
		Map<String, Object> maps = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> result = new HashMap<String, Object>();
		String itemId = request.getParameter("itemId");
		if (!itemId.equals("0")) {
			// 修改
			String dictId = request.getParameter("dictId");// 父表ID
			String itemName = request.getParameter("itemName");
			String orderIndex = request.getParameter("orderIndex");
			maps.put("itemId", itemId);
			maps.put("itemName", itemName);
			maps.put("orderIndex", orderIndex);
			maps.put("dictId", dictId);
			map.put("dictId", dictId);
			result = dictService.updateDictInfo(maps);
		} else {
			// 添加
			String dictId = request.getParameter("dictId");// 父表ID
			String itemName = request.getParameter("itemName");
			Map<String, Object> mm = dictService.selMaxValue(dictId);
			if (mm == null) {
				maps.put("itemValue", 1);
				maps.put("orderIndex", 1);
			} else {
				int itemValue = Integer.valueOf(mm.get("itemValue") + "");
				int orderIndex = Integer.valueOf(mm.get("orderIndex") + "");
				maps.put("orderIndex", orderIndex + 1);
				maps.put("itemValue", itemValue + 1);
			}
			maps.put("itemId", itemId);
			maps.put("itemName", itemName);

			maps.put("dictId", dictId);
			map.put("dictId", dictId);
			result = dictService.addDictInfo(maps);
		}
		return result;
	}

	// 删除数据字典详情
	@RequestMapping("/delDictInfo")
	@ResponseBody
	@Authorize(setting = "字典-删除字典详细")
	public Map<String, Object> delDictInfo(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> maps = new HashMap<String, Object>();
		String itemId = request.getParameter("itemId");
		String dictId = request.getParameter("dictId");
		maps.put("itemId", itemId);
		maps.put("dictId", dictId);
		List<Map<String, Object>> list = dictService.delteDictInfo(maps);
		if (list.size() > 0) {
			map.put("success", true);
			map.put("msg", "删除成功！");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败！");
		}
		return map;
	}

}
