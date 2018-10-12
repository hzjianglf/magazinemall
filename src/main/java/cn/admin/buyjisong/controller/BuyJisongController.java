package cn.admin.buyjisong.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.buyjisong.service.BuyJisongService;
import cn.admin.marketing.service.ShareSalesService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@Controller
@RequestMapping("/admin/buyJisong")
public class BuyJisongController {
	@Autowired
	ShareSalesService shareSalesService;
	@Autowired
	private BuyJisongService buyJisongService;
	
	@RequestMapping("/list")
	public ModelAndView returnIndex(){
		return new ModelAndView("/admin/buyJisong/list");
	}
	@RequestMapping("listData")
	@ResponseBody
	public Map<String,Object> listDate(String status,String name,Integer  page, Integer limit){
		Map<String,Object> map = new HashMap<>();
		Map<String,Object> paramap = new HashMap<String, Object>();
		paramap.put("name", name);
		paramap.put("status", status);
		long totalCount = buyJisongService.selectCount(paramap);
		Page pages = new Page(totalCount, page, limit);
		paramap.put("start", pages.getStartPos());
		paramap.put("pageSize", limit);
		List list = buyJisongService.selectContent(paramap);
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("data", list);
		result.put("code", 0);
		result.put("count", totalCount);
		return result;
	}
	@RequestMapping("turnAdd")
	public ModelAndView turnAdd(HttpServletRequest request){
		String id = request.getParameter("id");
		if(StringUtils.isNullOrEmpty(id)){
			return new ModelAndView("/admin/buyJisong/addorUp");
		}
		Map reqMap = buyJisongService.selById(id);
		String type = request.getParameter("type");
		reqMap.put("type", type);
		reqMap.put("id", id);
		return new ModelAndView("/admin/buyJisong/addorUp",reqMap);

	}
	@RequestMapping("addOrUp")
	@ResponseBody
	public Map<String,Object> addOrUp(@RequestParam Map paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String id = request.getParameter("id");
		if(StringUtils.isNullOrEmpty(request.getParameter("id"))){
			
			int num = buyJisongService.add(paramap);
			
			if(num<0){
				map.put("msg", "添加失败");
				map.put("success", false);
				return map;
			}
		}else{
			int num = buyJisongService.edit(paramap);
			if(num<0){
				map.put("msg", "编辑失败");
				map.put("success", false);
				return map;
			}
		}
		map.put("msg", "操作成功");
		map.put("success", true);
		return map;
	}
	
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="快递-删除")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = buyJisongService.delete(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
	@RequestMapping(value="/toaddProduct")
	public ModelAndView toaddProduct(@RequestParam Map map){
		return new ModelAndView("/admin/buyJisong/addProduct",map);
	}
	@RequestMapping(value="/selectProduct")
	@ResponseBody
	public Map<String, Object> selectProduct(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		//商品类型
		String strs = request.getParameter("strs");
		String name = request.getParameter("name");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		List<Integer> list2 = StringHelper.ToIntegerList(strs);
		reqMap.put("list", list2);
		reqMap.put("name", name);
		long count = buyJisongService.selectMagazineCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = buyJisongService.selProduct(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
}
