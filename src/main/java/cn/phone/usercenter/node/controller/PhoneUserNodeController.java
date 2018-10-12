package cn.phone.usercenter.node.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alipay.api.domain.Data;

import cn.api.service.AccountService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Page;

@UserValidate
@Controller
@RequestMapping(value="/phone/usercenter/node")
public class PhoneUserNodeController {
	
	@Autowired
	HttpSession session;
	@Autowired
	AccountService accountService;
	
	//笔记列表页面
	@RequestMapping(value="/nodeListFace")
	public ModelAndView nodeListFace(){
		Map<String, Object> map = new HashMap<String,Object>();
		return new ModelAndView("/phone/usercenter/node/nodeList",map);
	}
	//笔记列表数据
	@RequestMapping(value="/nodeList")
	@ResponseBody
	public ModelAndView nodeList(Integer page,Integer pageSize){
		Map<String, Object> map = new HashMap<String, Object>();
		int userId = DataConvert.ToInteger(session.getAttribute("userId"));
		
		// 查询记录count
		long count = accountService.getNodeCount(userId);

		Page pages = new Page(count, page, pageSize);
		map.put("userId", userId);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		// 查询数据
		List list = accountService.getNodeList(map);
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("totalCount", count);

		return new ModelAndView("/phone/usercenter/node/flowLoading",reqMap);
	}
	
	/**
	 * 取消笔记
	 * @param id
	 * @return
	 */
	@RequestMapping("/cancelNode")
	public @ResponseBody Map<String, Object> cancelNode(Integer id){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", false);
		map.put("msg","删除失败！");
		
		int userId=DataConvert.ToInteger(session.getAttribute("userId"));
		if(userId<=0) {
			return map;
		}
		
		if(id==null||id<=0) {
			return map;
		}
		
		Map<String,Object> paramMap=new HashMap<String,Object>();
		paramMap.put("userId",userId);
		paramMap.put("list", Arrays.asList(id));
		
		boolean flag=accountService.delNode(paramMap);
		if(flag) {
			map.put("result", true);
			map.put("msg","删除成功！");
		}
		
		return map;
	}
	
}
