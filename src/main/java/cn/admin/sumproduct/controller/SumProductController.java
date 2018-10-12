package cn.admin.sumproduct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.Pay.service.payService;
import cn.admin.book.service.BookService;
import cn.admin.sumproduct.service.SumProductService;
import cn.api.service.PathService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;

@Controller
@RequestMapping("admin/sumproduct")
public class SumProductController {
	@Autowired
	private SumProductService sumProductService;
	@Autowired
	HttpSession session;
	@Autowired
	private BookService bookService;
	@Autowired
	private PathService pathService;
	
	@RequestMapping(value = "/list")
	@Authorize(setting = "合集-合集列表")
	public ModelAndView list() {
		return new ModelAndView("/admin/sumproduct/list");
	}
	
	@RequestMapping("listData")
	@ResponseBody
	public Map<String, Object> adminlistData(@RequestParam Map<String, Object> map, int page, int limit) {
		Map<String, Object> result = new HashMap<String, Object>();
		long totalCount = sumProductService.getSumProductCount(map);// 得到总条数
		Page page2 = new Page(totalCount, page, limit);
		map.put("start", page2.getStartPos());
		map.put("pageSize", limit);
		List<Map<String, Object>> list = sumProductService.getSumProductList(map);
		result.put("msg", "");
		result.put("code", 0);
		result.put("data", list);
		result.put("count", totalCount);
		return result;
	}
	//跳转添加商品页面
	@RequestMapping("/selOndemandByType")
	public ModelAndView selOndemandByType(Integer classtype,String ids){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("classtype", classtype);
		if(classtype==2) {
			//跳转添加刊物的页面
			List<String> list = sumProductService.selYears();
			
			map.put("list", list);
			return new ModelAndView("/admin/sumproduct/bookproduct",map);
		}
		List dictionary = sumProductService.selDictionary();
		map.put("list", dictionary);
		map.put("ids",ids);
		return new ModelAndView("/admin/sumproduct/product",map);
	}
	//查询添加的商品
	@RequestMapping("selectProduct")
	@ResponseBody
	public Map<String, Object> selectProduct(@RequestParam Map<String, Object> map, int page, int limit) {
		Map<String, Object> result = new HashMap<String, Object>();
		long totalCount = sumProductService.getProducotCount(map);// 得到总条数
		Page page2 = new Page(totalCount, page, limit);
		map.put("start", page2.getStartPos());
		map.put("pageSize", limit);
		List<String> yearlist = sumProductService.selYears();
		if(DataConvert.ToString(map.get("year")).isEmpty()) {
			map.put("year", yearlist.get(0));
		}
		List<Map<String, Object>> list = sumProductService.getProducotList(map);
		result.put("msg", "");
		result.put("code", 0);
		result.put("data", list);
		result.put("count", totalCount);
		return result;
	}
	//跳转添加合集页面
	@RequestMapping("/addSum")
	@Authorize(setting = "合集-添加合集")
	public ModelAndView addSum(HttpServletRequest request){
		String id = request.getParameter("id");
		List<Map<String, Object>>tempList=bookService.getLogisticsTemplateList();
		
		Map<String,Object> reqMap= new HashMap<String,Object>();
		if(StringUtils.isEmpty(id)){
			reqMap.put("tempList", tempList);
			return new ModelAndView("/admin/sumproduct/addSumproduct",reqMap);
		}
		//获取分享域名
		String sharedAddress = pathService.getAbsolutePath("sharedAddress");
		reqMap = sumProductService.selById(id,request.getParameter("classtype"));
		reqMap.put("sharedAddress", sharedAddress);
		reqMap.put("tempList", tempList);
		reqMap.put("id", id);
		reqMap.put("classtypes", request.getParameter("classtypes"));
		return new ModelAndView("/admin/sumproduct/addSumproduct",reqMap);
	}
	
	@RequestMapping("addOrUp")
	@ResponseBody
	public Map<String,Object> addOrUp(@RequestParam Map paramap,HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String id = request.getParameter("id");
		Integer open  = DataConvert.ToInteger(request.getParameter("open"));
		paramap.put("open", open);
		paramap.put("founder",session.getAttribute("userId"));
		if(StringUtils.isEmpty((request.getParameter("id")))){
			
			int num = sumProductService.add(paramap);
			
			if(num<0){
				map.put("msg", "添加失败");
				map.put("success", false);
				return map;
			}
		}else{
			int num = sumProductService.edit(paramap);
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
	@RequestMapping("updStatus")
	@ResponseBody
	public Map<String,Object> updStatus(@RequestParam Map<String,Object> map){
		return sumProductService.updStatus(map);
	}
	
}
