package cn.admin.friendLink.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.friendLink.service.FriendService;
import cn.util.DataConvert;
import cn.util.Page;

@Controller 
@RequestMapping("/admin/link")
public class FriendController {
	@Autowired 
	FriendService friendLinkService;
	
	@Autowired
	HttpSession session;
	
	@RequestMapping(value="friendListData")
	public ModelAndView friendListData () {
		return new ModelAndView("/admin/friendlink/friendListData");
	}
	
	//查询所有 友情链接
	@RequestMapping(value="/list")
	@ResponseBody
	public Map<String,Object> list(@RequestParam Map<String,Object> map , Integer page , Integer limit){
		Map<String, Object> result = new HashMap<String, Object>();
		long count=friendLinkService.getTotalCount();//得到总条数
		
		Page page2 = new Page(count, page, limit);
		map.put("start", page2.getStartPos());
		map.put("pageSize", limit);
		
		List<Map<String,Object>> list=friendLinkService.selectLink(map);
		
		result.put("msg", "");
		result.put("code", 0);
		result.put("data", list);
		result.put("count", count);
		return result;
	}
	
	//编辑数据
	@RequestMapping(value="selFriByID")
	public ModelAndView selFriByID(@RequestParam String id) {
		if(id.isEmpty()) {
			return null;
		}
		Map<String,Object> result = new HashMap<String,Object>();
		result.putAll(friendLinkService.selId(DataConvert.ToInteger(id)));
		return new ModelAndView("/admin/friendlink/addFriendLink",result);
		
	}
	
	//添加链接跳转
	@RequestMapping(value="/add")
	public ModelAndView addUrl(){
		return new ModelAndView("/admin/friendlink/addFriendLink");
	}
	
	//添加,修改友情链接
	@RequestMapping(value="/addLink")
	@ResponseBody
	public Map<String,Object> add(@RequestParam Map<String,Object> map){
		Map<String,Object> result = new HashMap<String,Object>(){
			{
				put("success", false);
				put("msg","操作失败！");
			}
		};
		
		Integer LinkId=DataConvert.ToInteger(map.get("Id"));
		if(LinkId > 0 && LinkId != null){
			Map<String,Object> ma=friendLinkService.selId(LinkId);
			if(!ma.isEmpty()) {
				Integer num = friendLinkService.update(map);
				if(num>0) {
					result.put("success", true);
					result.put("msg","修改成功！");
				}
			}
		}else{
			Integer num = friendLinkService.add(map);
			if(num>0) {
				result.put("success", true);
				result.put("msg", "添加成功");
			}
		}
		
		return result;
	}
	
	//通过id删除链接
	@RequestMapping(value="/delete")
	@ResponseBody
	public Map<String,Object> delete(int Id){
		Map<String,Object> result = new HashMap<String,Object>(){
			{
				put("success",false);
				put("msg", "删除失败！");
			}
		};
		
		Integer num = friendLinkService.delete(Id);
		
		if(num>0) {
			result.put("success", true);
			result.put("msg", "删除成功！");
		}
		return result;
	}
	
	//批量删除连接
	@RequestMapping(value="/deletes")
	@ResponseBody
	public Map<String,Object> del(@RequestParam String items){
		
		Map<String,Object> result = new HashMap<String,Object>(){
			{
				put("success", false);
				put("msg","请选择需要删除的数据");
			}
		};
		
		if(items.isEmpty()) {
			return result;
		}
		
		List<String> delList=new ArrayList<String>();
		
		String[] strs=items.split(",");
		for(String str:strs){
			delList.add(str);
		}
		
		Integer num = friendLinkService.delLink(delList);
		
		if(num>0) {
			result.put("success", true);
			result.put("msg", "删除成功！");
		}
		
		return result;
	}
	
}
