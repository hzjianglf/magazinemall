package cn.web.usercenter.favorites.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.AccountService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@RequestMapping("/web/usercent/favorite")
@Controller
public class WebFavoriteController {
	@Autowired
	private AccountService accountService; 
	@Autowired
	private HttpSession session;
	
	@RequestMapping("/turnFavorites")
	public ModelAndView turnFavorites(){
		Map<String, Object> map = new HashMap<String,Object>();
		map.put("footer", false);
		return new ModelAndView("/phone/usercenter/favorites/index",map);
	}
	@RequestMapping("/partialList")
	public  ModelAndView showOrders(HttpServletRequest request){
		Integer userId = DataConvert.ToInteger(session.getAttribute("PCuserId"));
		String type = request.getParameter("type");
		Integer pageNow = 1;
		if(request.getParameter("pageNow")!=null && request.getParameter("pageNow")!=""){
			pageNow = Integer.parseInt(request.getParameter("pageNow"));
		}
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("type", type);
		map.put("start", (pageNow-1)*6);
		map.put("userId", userId);
		List<Object> list = new ArrayList<Object>();
		if(type.equals("1")){
			//查询纸质期刊
			long count = accountService.getBookCount(userId);
			Page page =new Page(count, pageNow, 6);
			map.put("pageTotal", page.getTotalPageCount());
			map.put("pageSize", 6);
			list = accountService.selBook(map);
			map.put("list", list);
			map.put("pageNow", pageNow);
			return new ModelAndView("/phone/usercenter/favorites/partlist",map);
		}
		long count = accountService.getOthersCount(userId);
		Page page =new Page(count, pageNow, 6);
		map.put("pageTotal", page.getTotalPageCount());
		map.put("pageSize", 6);
		list = accountService.selOthers(map);
		map.put("list", list);
		map.put("pageNow", pageNow);
		return new ModelAndView("/phone/usercenter/favorites/partlist",map);
	}
	@RequestMapping("delFavrites")
	@ResponseBody
	public Map<String,Object> delFavrites(String ids,Integer dataType){
		Integer userId = Integer.parseInt(session.getAttribute("PCuserId")+"");
		List<Integer> list = StringHelper.ToIntegerList(ids);
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("list", list);
		map.put("dataType", dataType);
		map.put("favoriteType", 1);//代表收藏
		int count = accountService.batcancelCollect(map);
		Map<String,Object> result = new HashMap<String, Object>();
		if(count<=0){
			result.put("result", 0);
			result.put("msg", "操作失败");
			return result;
		}
		result.put("result", 1);
		result.put("msg", "操作成功");
		return result;
	}
	
}
