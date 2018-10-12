package cn.admin.marketing.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.marketing.service.DiscountProductService;
import cn.admin.marketing.service.DiscountService;
import cn.api.service.PathService;
import cn.core.Authorize;
import cn.util.Page;

@Controller
@RequestMapping(value="/admin/discount")
public class DiscountController {

	@Autowired
	DiscountService discountService;
	@Autowired
	private HttpSession session;
	@Autowired
	DiscountProductService discountProductService;
	@Autowired
	PathService pathService;
	
	/**
	 * 显示折扣列表
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="折扣-限时折扣列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/marketing/discount/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		String type = request.getParameter("status");
		String name = request.getParameter("name");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("name", name);
		reqMap.put("type", type);
		long count = discountService.selDiscountCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = discountService.selDiscountList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 添加 | 编辑弹窗
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/toaddOrUp")
	public ModelAndView toaddOrUp(@RequestParam Map<String,Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(map.get("id"))){
			//根据id查询相应数据
			reqMap = discountService.findDisById(map);
			//查询关联商品
			List<Map<String,Object>> list = discountProductService.selDisProByDisID(map);
			if(list!=null && list.size()>0){
				reqMap.put("list", list);
			}
			//获取图片路劲
			for (Map<String, Object> map2 : list) {
				if(map2.get("url") != null && map2.get("url") != "") {
					String url = pathService.getAbsolutePath(map2.get("url") + "");
					map2.put("url", url);
				}
			}
			//点击的是详细
			reqMap.put("detail", map.get("detail")+"");
		}
		return new ModelAndView("/admin/marketing/discount/addorUp",reqMap);
	}
	
	/**
	 * 添加 || 修改 活动
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/insUpDiscount")
	@ResponseBody
	public Map<String,Object> insUpDiscount(@RequestParam Map<String,Object> map){
		Map<String,Object> result = new HashMap<String,Object>(){
			{
				put("success",false);
				put("msg","操作失败");
			}
		};
		String userId = session.getAttribute("userId") + "";
		if(userId == null || userId == "") {
			return result;
		}
		map.put("userId", userId);
		//添加或修改活动(信息和关联表信息)
		int num = discountService.insUpDisDisPro(map);
		
		if(num>0) {
			result.put("success", true);
			result.put("msg", "操作成功");
		}
		return result;
	}
	
	/**
	 * 删除活动通过id
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/delDiscount")
	@ResponseBody
	public Map<String,Object> delDiscount(@RequestParam Map<String,Object> map){
		Map<String,Object> result = new HashMap<String,Object>(){
			{
				put("success",false);
				put("msg","删除失败");
			}
		};
		int num = discountService.delDiscount(map);
		if(num > 0) {
			result.put("success", true);
			result.put("msg", "删除成功");
		}
		return result;
	}
}
