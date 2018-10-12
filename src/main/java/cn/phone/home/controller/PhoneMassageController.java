package cn.phone.home.controller;

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

import cn.api.service.NewsService;
import cn.util.Page;

@Controller
@RequestMapping("/phone/home/message")
public class PhoneMassageController {
		
	@Autowired
	private NewsService newsService;
	@Autowired
	HttpSession session;
	
	@RequestMapping("/tonews")
	public ModelAndView tonews(){
		if(session.getAttribute("userId")==null){
			return new ModelAndView("/phone/login/index");
		}
		return new ModelAndView("phone/home/message/index");
	}
	@RequestMapping("/newsList")
	@ResponseBody
	public ModelAndView newsList(HttpServletRequest request){
		Map map = new HashMap();
		if(session.getAttribute("userId")==null){
			return new ModelAndView("/phone/login/index");
		}else if(session.getAttribute("userId")!=null){
			map.put("userId", session.getAttribute("userId"));
		}
		long count = newsService.selectNewsCount(map);
		Integer pageNow = 1;
		if(request.getParameter("pageNow")!=null && request.getParameter("pageNow")!=""){
			pageNow = Integer.parseInt(request.getParameter("pageNow"));
		}
		map.put("start", (pageNow-1)*10);
		map.put("pageSize", 10);
		List list = newsService.selectNewList(map);
		Page page = new Page(count,pageNow,10);
		map.put("list", list);
		map.put("pageTotal", page.getTotalPageCount());
		return new ModelAndView("phone/home/message/partlist",map);
	}
}
