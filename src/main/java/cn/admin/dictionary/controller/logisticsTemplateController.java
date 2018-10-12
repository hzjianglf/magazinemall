package cn.admin.dictionary.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.dictionary.service.logisticsTemplateService;
import cn.util.Page;


@Controller
@RequestMapping(value="/admin/logisticsTemplate")
public class logisticsTemplateController {
	
	@Autowired
	logisticsTemplateService templateService;
	
	
	@RequestMapping(value="/listFace")
	public ModelAndView listFace(){
		return new ModelAndView("/admin/dictionary/template/list");
	}
	
	//模板数据list
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String,Object> listData(Integer  page, Integer limit){
		
		Map<String,Object> result = new HashMap();
		long totalCount = templateService.selCount();
		Page pages = new Page(totalCount, page, limit);
		Map<String,Object> search = new HashMap();
		search.put("start", pages.getStartPos());
		search.put("pageSize", limit);
		List tempList = templateService.selPageList(search);
		search.put("tempList", tempList);
		List list = templateService.selTemplateList(search);
		
		result.put("data", list);
		result.put("code", 0);
		result.put("count", totalCount);
		return result;
	}
	
	//修改价格
	@RequestMapping(value="/updPrice")
	@ResponseBody
	public Map updPrice(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = templateService.updPrice(map);
		if(row>0){
			result.put("result", true);
			result.put("msg", "修改成功！");
		}else{
			result.put("result", false);
			result.put("msg", "修改失败！");
		}		
		return result;
	}
	//删除
	@RequestMapping(value="/delInfo")
	@ResponseBody
	public Map delInfo(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = templateService.delInfo(map);
		if(row>0){
			result.put("result", true);
			result.put("msg", "删除成功！");
		}else{
			result.put("result", false);
			result.put("msg", "删除失败！");
		}
		return result;
		
	}
	//区域选择
	@RequestMapping(value="/addressSetUp")
	public ModelAndView addressSetUp(@RequestParam("msgId") int msgId ,@RequestParam("type") int type){
		Map<String,Object> map = new HashMap<String, Object>();
		List<Map> list = templateService.selRegionList();
		map.put("list", list);
		List<Map> provinceList = templateService.selProvinceList();
		
		List<Map>provinceList_New=provinceList.parallelStream().filter(m->list.parallelStream().anyMatch(f->f.get("codeid").equals(m.get("parentid")))).collect(Collectors.toList());
		
		map.put("province", provinceList_New);
		
		List<Map> cityList_New=provinceList.parallelStream().filter(m->provinceList_New.parallelStream().anyMatch(p->p.get("codeid").equals(m.get("parentid")))).collect(Collectors.toList());
		
		map.put("city", cityList_New);
		map.put("msgId", msgId);
		map.put("type", type);
		
		if(type==2){
			Map addressIds = templateService.selAllAddressIds(map);
			map.put("addressIds", addressIds);
		}
		
		return new ModelAndView("/admin/dictionary/template/address",map);
	}
	
	//保存区域
	@RequestMapping(value="/saveAddress")
	@ResponseBody
	public Map saveAddress(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int type = Integer.parseInt(map.get("type")+"");
		int row = 0;
		if(type==1){//添加模板的运费项
			row=1;
		}else if(type==2){//修改已经添加的模板的地址
			row = templateService.updAddressInfo(map);
		}else if(type==3){
			row = templateService.addPriceInfo(map);
		}
		
		if(row>0){
			result.put("result", true);
			result.put("msg", "操作成功！");
		}else{
			result.put("result", false);
			result.put("msg", "操作失败！");
		}
		result.put("type", type);
		return result;
	}
	
	//添加模板页面
	@RequestMapping(value="/addTemplateFace")
	public ModelAndView addTemplateFace(){
		return new ModelAndView("/admin/dictionary/template/addTemp");
	}
	//保存模板
	@RequestMapping(value="/addTemplate")
	@ResponseBody
	public Map addTemplate(@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		int row = templateService.addTemplateInfo(map);
		if(row>0){
			result.put("result", true);
			result.put("msg", "添加成功！");
		}else{
			result.put("result", false);
			result.put("msg", "添加失败！");
		}
		return result;
	}
	
}
