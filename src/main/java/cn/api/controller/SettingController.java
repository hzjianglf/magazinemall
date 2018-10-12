package cn.api.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import cn.Setting.Setting;
import cn.Setting.Model.SearchSetting;
import cn.admin.adzone.service.AdvertisementService;
import cn.api.service.ApiResult;
import cn.api.service.PathService;
import cn.api.service.SettingService;
import cn.core.Sign;


/**
 * 系统设置
 */
@Api(tags={"系统设置信息接口"})
//@Sign
@RestController
@RequestMapping("/api/setting")
public class SettingController {
	
	@Autowired
	private SettingService settingService;
	
	@Autowired
	Setting setting;
	@Autowired
	PathService pathService;
	/**
	 * 获取手机标识
	 */
	@RequestMapping("getPhoneId")
	@ApiOperation(value="获取手机标识",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户Id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="phoneId",value="手机标识",dataType="string",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1}")
	})
	public Map<String,Object> getPhoneId(String phoneId,Integer userId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(phoneId==null || phoneId.equals("") || null==userId || userId<=0) {
			map.put("msg", "参数错误");
			return map;
		}
		return settingService.getPhoneId(userId,phoneId);
	}
	/**
	 * 获取支付方式列表
	 * return 
	 * methodName 支付名称
	 * picUrl 图片
	 * id 
	 * rate 手续费
	 * isDefault 是否默认1是
	 */
	@RequestMapping("getPayMethods")
	@ApiOperation(value="获取支付方式列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="platformType",value="1--所有 2--pc 3--phone 4--app",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='期刊id',methodName='支付名称',picUrl='图片',rate='手续费',isDefault='是否默认1是'}}")
	})
	public Map<String,Object> getPayMethods(Integer page,Integer pageSize,Integer platformType){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		boolean flag=false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			
			flag=true;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		map.put("platformType", platformType);
		List<Map<String,Object>> list = settingService.getPayMethods(map);
		pathService.getAbsolutePath(list, "picUrl");
		reqMap.put("result", 1);
		reqMap.put("msg", "获取成功！");
		if(flag){
			long count = settingService.getPaymethodsCount(map);
			int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
		}
		reqMap.put("data", list);
		return reqMap;
	}
	/**
	 * 获取专栏设置信息
	 */
	@RequestMapping(value="/getSpecialSetMsg")
	@ApiOperation(value="获取专栏设置信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={realname='真是姓名',cardNo='银行卡号',identitynumber='身份证号',questionPrice='问答价格'}}")
	})
	public Map<String, Object> getSpecialSetMsg(Integer userId){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		
		if(userId==null){
			return reqMap;
		}
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			Map<String, Object> ma=settingService.getSpecialSetMsg(map);
			reqMap.put("data", ma);
			reqMap.put("result", 1);
			reqMap.put("msg", "获取成功!");
		} catch (Exception e) {
			reqMap.put("msg", "请求失败,"+e.getMessage());
		}
		return reqMap;
	}
	
	/**
	 * 保存专栏设置信息
	 */
	@RequestMapping(value="/addSpecialSetMsg")
	@ApiOperation(value="保存专栏设置信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="realname",value="真实姓名",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="identitynumber",value="身份证号",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="questionPrice",value="问答价格",dataType="double",required=true,paramType="query"),
		@ApiImplicitParam(name="cardNo",value="银行卡号",dataType="String",required=true,paramType="query")
	})
	public Map<String, Object> addSpecialSetMsg(Integer userId,String realname,String identitynumber,double questionPrice,String cardNo){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		
		if(userId==null){
			return reqMap;
		}
		
		try {
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("realname", realname);
			map.put("identitynumber", identitynumber);
			map.put("questionPrice", questionPrice);
			map.put("cardNo", cardNo);
			int row = settingService.addSpecialSetMsg(map);
			if(row>1){
				reqMap.put("result", 1);
				reqMap.put("msg", "设置成功!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败,"+e.getMessage());
		}
		
		return reqMap;
	}
	
	/**
	 * 获取热搜词
	 * @return
	 */
	@RequestMapping(value="/getHotSearchWords")
	@ApiOperation(value="获取热搜词",httpMethod="GET")
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data=['热搜词','热搜词'],msg='信息'")
	})
	public Map<String, Object> getHotSearchWords(){
		
		ApiResult result=new ApiResult(false,"获取数据失败！");
		
		try {
			
			SearchSetting searchSetting=setting.getSetting(SearchSetting.class);
			if(searchSetting!=null) {
				result.setResult(true,"获取数据成功",searchSetting.getHotSearchWords());
			}
			
		} catch (Exception e) {
			result.setResult(false, "获取数据失败");
		}
		
		return result.getResult();
	}
}
