package cn.phone.home.controller;

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

import cn.api.service.OrderService;
import cn.api.service.ProductService;
import cn.util.DataConvert;
import cn.util.StringHelper;

@Controller
@RequestMapping(value="/phone/periodical")
public class PhonePeriodicalController {
	
	@Autowired
	ProductService productService;
	@Autowired
	private OrderService orderService;
	@Autowired
	private HttpSession session;
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("userId"));
	}
	@RequestMapping("turnEbook")
	public ModelAndView turnEbook(Integer bookId,Integer pubId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("id", bookId);
		Map list = productService.getMagazinesContent(map);
		return new ModelAndView("/phone/qikan/ebook",list);
	}
	@RequestMapping(value="/addShopCart")
	@ResponseBody
	public Map addShopCart(@RequestParam Map map){
		//加入购物车
		int userId = getUserId();
		if(userId==0){
			return new HashMap(){
				{
					put("result", 0);
					put("needLogin",true);
					put("msg", "请登录后重试！");
				}
			};
		}
		map.put("userId",userId );
		Map result = orderService.createCardShop(map);
		return result;
	}
}
	
