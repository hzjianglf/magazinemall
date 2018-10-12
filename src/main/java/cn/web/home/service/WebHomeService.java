package cn.web.home.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import cn.api.service.ProductService;
import cn.api.service.TeacherService;
import cn.util.DataConvert;

@Service
public class WebHomeService {
	
	@Autowired
	HttpSession session;
	@Autowired
	ProductService productService;
	@Autowired
	TeacherService teacherService;
	
	
	public Integer getUserId(){
		return DataConvert.ToInteger(session.getAttribute("PCuserId"));
	}
	
	//根据类型和名称搜所内容
	public List<Map<String, Object>> searchContentByName(Integer type,String name){
		Map<String,Object> parmap = new HashMap<String, Object>();
		long count = 0;
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		parmap.put("searchName", name);
		parmap.put("userId", getUserId());
		parmap.put("start",0);
		parmap.put("pageSize", 4);
		if(type==2){
			list = productService.selectMagazineList(parmap);
		}else if(type==0 || type==1){
			parmap.put("classtype", type);
			list = productService.selCurriculum(parmap);
		}else if(type==3){
			list = teacherService.selExpertList(parmap);
		}else{
			
		}
		return list;
	}
	
}
