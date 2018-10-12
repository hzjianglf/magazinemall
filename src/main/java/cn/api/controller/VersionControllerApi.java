package cn.api.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import cn.admin.interlocution.service.InterlocutionService;
import cn.admin.system.service.VersionService;
import cn.api.service.ActivityService;
import cn.api.service.OrderService;
import cn.api.service.PathService;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;

@Api(tags={"版本号操作的接口"})
@RestController
//@Sign
@RequestMapping("/api/version")
public class VersionControllerApi {

	@Autowired
	VersionService versionService;
	@Autowired
	InterlocutionService interlocutionService;
	/**
	 * 通过类型type获取最新的versionCode
	 */
	@RequestMapping(value="/getLatestVersion")
	@ApiOperation(value="通过类型type获取最新的versionCode的接口",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="type",value="类型",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data='版本信息'}")
	})
	public Map<String,Object> getLatestVersion(Integer type){
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", 0);
		if(type==null){
			result.put("msg", "参数错误");
			return result;
		}
		try {
			 result = versionService.getLatestVersion(type);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "获取版本号信息失败");
		}
		return result;
	}
//	
//	
//	@RequestMapping(value="/test")
//	@ApiOperation(value="测试",httpMethod="POST")
//	public void test(){
//		
//		interlocutionService.interlocutionByRefund();
//	}
}
