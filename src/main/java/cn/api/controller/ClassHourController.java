package cn.api.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import cn.api.service.ProductService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(tags={"课时接口"})
@RestController
//@Sign
@RequestMapping("/api/classHour")
public class ClassHourController {

	@Autowired
	ProductService productService;
	/**
	 * 从rc_pics表导入classhour_picture表数据
	 */
	/*@RequestMapping(value="/getRcPicPicurl")
	@ApiOperation(value="从rc_pics表导入classhour_picture表数据的接口",httpMethod="POST")
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1}")
	})
	public Map<String,Object> getRcPicPicurl(){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", 0);
		try {
			 result = productService.getRcPicPicurl();
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取信息失败");
		}
		return result;
	}*/
	
	/**
	 * 获取课时图片接口
	 */
	@RequestMapping(value="/getClassHourPicurl")
	@ApiOperation(value="获取课时图片接口",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="hourId",value="课时表Id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1},data='课时图片信息,'list[picurl='课时图片地址']'}'}")
	})
	public Map<String,Object> getClassHourPicurl(Integer hourId){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", 0);
		if(hourId==null || "".equals(hourId)){
			result.put("msg", "参数错误");
			return result;
		}
		try {
			 result = productService.getClassHourPicurl(hourId);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取信息失败");
		}
		return result;
	}
}
