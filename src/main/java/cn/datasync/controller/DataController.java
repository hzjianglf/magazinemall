package cn.datasync.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.datasync.service.CustomerDataService;
import cn.datasync.service.DataService;

@RestController
@RequestMapping("/data")
public class DataController {
	
	@Autowired
	DataService dataService;
	@Autowired
	CustomerDataService customerDataService;
	
	@RequestMapping("/test")
	public  Map<String, Object> test(){
		Map<String, Object> result=new HashMap<String,Object>();
		
		result.put("jdbc",customerDataService.getUserCount());
		
		return result;
	}
	
}
