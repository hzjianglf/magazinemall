package cn.admin.marketing.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.marketing.service.ShareSalesService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.util.Page;
import cn.util.StringHelper;

/**
 * 分享销售
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping(value="/admin/sharesales")
public class ShareSalesController {

	
	@Autowired
	ShareSalesService shareSalesService;
	
	
	/**
	 * 分享销售列表
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="分享销售-列表展示")
	public ModelAndView list(){
		return new ModelAndView("/admin/marketing/shareSales/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		String status = request.getParameter("status");
		String name = request.getParameter("name");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("name", name);
		reqMap.put("status", status);
		long count = shareSalesService.selShareSalesCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = shareSalesService.selShareSalesList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="分享销售-列表删除")
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = shareSalesService.deleteShare(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "删除成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "删除失败!");
		}
		return reqMap;
	}
	/**
	 * 添加编辑弹窗
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/toaddOrUp")
	public ModelAndView toaddOrUp(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(map.get("id"))){
			//根据id查询相应数据
			reqMap = shareSalesService.findByIdshareSales(map);
			map.put("activityType", 2);
			//查询关联商品
			List list = shareSalesService.selectRelationProduct(map);
			if(list!=null && list.size()>0){
				reqMap.put("list", list);
			}
			//点击的是详细
			reqMap.put("detail", map.get("detail")+"");
		}
		return new ModelAndView("/admin/marketing/shareSales/addorUp",reqMap);
	}
	/**
	 * 保存数据
	 * @return
	 */
	@RequestMapping(value="/addOrUp")
	@Authorize(setting="分享销售-添加活动,分享销售-编辑活动",type=AuthorizeType.ONE)
	@ResponseBody
	public Map<String, Object> addOrUp(@RequestParam Map map,HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = 0;
		if(!StringUtils.isEmpty(map.get("id"))){
			row = shareSalesService.UpShareSales(map);
		}else{
			row = shareSalesService.addShareSales(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "保存失败!");
		}
		return reqMap;
	}
	@RequestMapping(value="/toaddProduct")
	public ModelAndView toaddProduct(@RequestParam Map map){
		return new ModelAndView("/admin/marketing/shareSales/addProduct",map);
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
		long count = shareSalesService.selectMagazineCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = shareSalesService.selProduct(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 查询已关联商品数据
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/selProducts")
	@ResponseBody
	public Map<String, Object> selProducts(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//获取商品类型及id的json字符串
		String json = map.get("ids")+"";
		JSONArray array = JSONArray.fromObject(json);
		for(int i = 0;i < array.size();i++){
			//第一个元素
			JSONObject object = array.getJSONObject(i);
			//元素类型
			String key = object.getString("type");
			//ids
			String strs = object.getString("str");
			if(!StringUtils.isEmpty(strs) && !"null".equals(strs)){
				String[] ids = strs.split(",");
				reqMap.put("list"+key, ids);
				reqMap.put("strs"+key, strs);
			}
		}
		List<Map<String, Object>> list = shareSalesService.findByIdsAll(reqMap);
		reqMap.put("productList", list);
		return reqMap;
	}
}
