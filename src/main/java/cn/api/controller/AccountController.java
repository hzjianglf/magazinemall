package cn.api.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import cn.SMS.SmsService;
import cn.api.service.AccountService;
import cn.api.service.PathService;
import cn.api.service.SearcheDiscountService;
import cn.core.Sign;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;
import cn.util.UtilDate;

/**
 * 用户信息
 */
@Api(tags={"用户操作的接口"})
//@Sign
@RestController
@RequestMapping("/api/account")
public class AccountController {
	

	@Autowired
	AccountService accountService;
	@Autowired
	private SmsService smsService;
	@Autowired
	private HttpSession session;
	@Autowired
	PathService pathService;
	/**
	 * 充值操作
	 */
	@RequestMapping("addMoney")
	@ApiOperation(value="用户充值生成paylog",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="price",value="充值金额",dataType="double",required=true,paramType="query"),
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={data='paylog的ID'}}")
	})
	public Map<String,Object> addMoney(Integer userId,Double price){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null==userId || null==price){
			map.put("msg", "参数错误");
			return map;
		}
		Map<String,Object> parmap = new HashMap<String, Object>();
		parmap.put("questioner", userId);
		parmap.put("money", price);
		parmap.put("userId", userId);
		parmap.put("price", price);
		int paylogId = accountService.addMoney(parmap);
		if(paylogId<0){
			map.put("msg", "生成订单失败");
			return map;
		}
		map.put("data", paylogId);
		map.put("result", 1);
		map.put("msg", "生成订单成功");
		return map;
	}
	/**
	 * 获取提问详情
	 * @param 提问的表的记录 id
	 * return content 提问的内容  answer 答案的内容
	 */
	@RequestMapping("getInterlocution")
	@ApiOperation(value="获取提问详情",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="id",value="提问的表的记录 id",dataType="int",required=true,paramType="query")
	})
	public Map<String,Object> getInterlocution(Integer id){
		Map<String,Object> map = new HashMap();
		map.put("result", 0);
		if(null==id){
			map.put("msg", "请输入提问的id");
			return map;
		}
		Map data = accountService.getInterlocution(id);
		
		pathService.getAbsolutePath(data, "picUrl","musicUrl");
		
		map.put("data", data);
		map.put("result", 1);
		return map;
	}
	/**
	 * 获取用户提问列表
	 * @param userId 客户id
	 * @param pageNow 当前页数
	 * @param pageSize 一页显示的记录数
	 * return
	 * id 提问列表的id
	 * name 课时名字
	 * content 提问的内容
	 * answerState 状态  0已关闭 1 待回答 2已回答
	 * inputDate 提问的时间
	 * answer 答案的内容
	 */
	@RequestMapping("getInterlocutionList")
	@ApiOperation(value="(个人中心)获取普通用户提问列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="类型1--我的提问 2--提问我的",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页数",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="一页显示的记录数",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='提问id',title='课程标题',content='提问内容',answerState='回答状态0已关闭 1 待回答 2已回答',"
				+ "picUrl='课程图片',name='课程名称',inputDate='提问时间',answer='答案',answerType='答案类型：1音频,2文字',musicUrl='音频地址'}}}}")
	})
	public Map<String,Object> getInterlocutionList(Integer userId,Integer type,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("result", 0);
		try {
			if(null==userId){
				map.put("msg", "请输入客户id");
				return map;
			}
			if(null==pageNow || pageNow<1){
				pageNow=1;
			}
			if(null==pageSize|| pageSize<0){
				pageSize=10;
			}
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			paramap.put("type", type);
			
			long count = accountService.getInterlocutionCount(paramap);
			Page page = new Page(count,pageNow,pageSize);
			int startPos = page.getStartPos();
			
			paramap.put("start", startPos);
			paramap.put("pageSize", pageSize);
			List list = accountService.getInterlocutionList(paramap);
			
			pathService.getAbsolutePath(list, "picUrl","musicUrl");
			
			map.put("totalPage", page.getTotalPageCount());
			map.put("pageNow", pageNow);
			map.put("data", list);
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg", "获取列表失败");
		}
		return map;
	}
	/**
	 * 获取客户的收货地址
	 * @param userId
	 * @return
	 */
	@RequestMapping("/address_list")
	@ApiOperation(value="获取客户的收货地址",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query")
	})
	public Map<String,Object> GetCustomerAddress(Integer userId){
		Map<String, Object> resultMap=new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		if(userId==null||userId<=0){
			return resultMap;
		}
		
		try {
			List list = accountService.selAddressList(userId);
			resultMap.put("result",1);
			resultMap.put("msg", "获取数据成功！");
			resultMap.put("data", list);
			
		} catch (Exception e) {
			resultMap.put("msg", "获取数据失败！"+e.getMessage());
		}
		
		return resultMap;
	}
	
	/**
	 * 删除地址
	 * @param userId 用户Id
	 * @param id 地址id
	 * @return
	 */
	@RequestMapping(value="address_delete")
	@ApiOperation(value="删除地址",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="id",value="地址id",dataType="int",required=true,paramType="query")
	})
	public Map<String, Object>DeleteAddress (int userId,int id) {
		Map<String, Object> resultMap=new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		if(id<=0||userId<=0){
			return resultMap;
		}
		
		try {
			
			boolean result=accountService.DeleteAddress(id, userId);
			if(result){
				resultMap.put("result",1);
				resultMap.put("msg", "删除成功！");
			}else{
				resultMap.put("msg", "删除失败！");
			}
			
		} catch (Exception e) {
			resultMap.put("msg", "删除失败！"+e.getMessage());
		}
		
		return resultMap;
	}
	
	/**
	 * 设置用户的默认地址
	 * @param userId 用户Id
	 * @param id 地址id
	 * @param type 是否默认  0否   1默认
	 * @return
	 * 
	 * */
	@RequestMapping(value="/defaultAddress")
	@ApiOperation(value="设置用户的默认地址",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="id",value="地址id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="是否默认  0否   1默认",dataType="int",required=true,paramType="query")
	})
	public Map defaultAddress(int userId,int Id,int type){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> result = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("Id", Id);
		map.put("type", type);
		try {
			int row = accountService.updDefaultAddress(map);
			if(row>0){
				result.put("result", 1);
				result.put("msg", "设置成功！");
			}else{
				result.put("result", 0);
				result.put("msg", "设置失败！");
			}
		} catch (Exception e) {
			result.put("result", 0);
			result.put("msg", "设置失败！"+e.getMessage());
		}
		
		return result;
	 	
	}
	/**
	 * 获取用户默认地址
	 */
	@RequestMapping(value="/getDefaultAddress")
	@ApiOperation(value="获取用户默认地址",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="isDefault",value="固定参数传1",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={Id='地址id',userId='用户id',userName='用户名',receiver='（个人）收货人姓名/(商家）发货人姓名',"
				+ "phone='手机号',province='省',city='市',county='县',detailedAddress='详细地址'isDefault='是否默认1是',addTime='添加时间'}}")
	})
	public Map<String, Object> getDefaultAddress(Integer userId,Integer isDefault){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		if(userId==null||isDefault==null){
			return reqMap;
		}
		try {
			map.put("userId", userId);
			map.put("isDefault", isDefault);
			Map address = accountService.selectIsDefaultAddress(map);
			if(StringUtils.isEmpty(address)){
				map.remove("isDefault");
				address = accountService.selectIsDefaultAddress(map);
			}
			reqMap.put("result", 1);
			reqMap.put("msg", "获取数据成功!");
			reqMap.put("data", address);
		} catch (Exception e) {
			reqMap.put("msg", "请求失败,"+e.getMessage());
		}
		return reqMap;
	}
	
	/**
	 * 获取用户单个地址详情
	 * @param userId 用户id
	 * @param Id 地址id
	 * 
	 * */
	@RequestMapping(value="/addressDetail")
	@ApiOperation(value="获取用户单个地址详情",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="Id",value="地址id",dataType="int",required=true,paramType="query")
	})
	public Map addressDetail(int userId,int Id){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> result = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("Id", Id);
		try {
			Map data = accountService.selAddressDetail(map);
			if(data.size()>0){
				result.put("result", 1);
				result.put("msg", "获取成功！");
				result.put("data", data);
			}else{
				result.put("result", 0);
				result.put("msg", "获取失败！");
			}
		} catch (Exception e) {
			result.put("result", 0);
			result.put("msg", "获取失败！"+e.getMessage());
		}
		
		return map;
			
	}
	/**
	 * 添加/修改收货地址
	 * @param userId 用户id
	 * @param userName 用户姓名
	 * @param receiver 收货人姓名
	 * @param phone 手机号
	 * @param province 省
	 * @param city 市
	 * @param county 县/区 
	 * @param detailedAddress 详细地址
	 * @param isDefault 是否是默认地址
	 * @return
	 */
	@RequestMapping(value="/addAddress")
	@ApiOperation(value="添加收货地址",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="Id",value="地址id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userName",value="用户姓名",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="receiver",value="收货人姓名",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="phone",value="手机号",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="province",value="省",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="city",value="市",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="county",value="县/区",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="detailedAddress",value="详细地址",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="isDefault",value="是否是默认地址",dataType="int",required=true,paramType="query")
	})
	public Map<String, Object> addAddress(int Id,int userId,String userName,String receiver,String phone,String province,String city,String county,
			String detailedAddress,int isDefault){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("Id", Id);
		map.put("userId", userId);
		map.put("userName", userName);
		map.put("receiver", receiver);
		map.put("phone", phone);
		map.put("province", province);
		map.put("city", city);
		map.put("county", county);
		map.put("detailedAddress", detailedAddress);
		map.put("isDefault", isDefault);
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId <= 0){
			return reqMap;
		}
		try {
			//保存收货地址
			int row = 0;
			if(Id>0){
				//编辑
				row = accountService.updateAddress(map);
			}else{
				row = accountService.addAddress(map);
			}
			if(row > 0){
				reqMap.put("result", 1);
				reqMap.put("msg", "保存成功!");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "保存失败!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败"+e.getMessage());
		}
		return reqMap;
		
	}
	
	/**
	 * 获取银行卡列表
	 * @param map {userId 用户id}
	 * @return
	 */
	@RequestMapping(value="/bankCardList")
	@ApiOperation(value="获取银行卡列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query"),
	})
	public Map<String,Object> bankCardList(Integer userId,Integer page,Integer pageSize){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		if(userId==null || userId<=0){
			return reqMap;
		}
		
		if(page==null||page<1){
			page=1;
		}
		if(pageSize==null){
			pageSize=Integer.MAX_VALUE;
		}
		int start=(page-1)*pageSize;
		map.put("userId", userId);
		map.put("start", start);
		map.put("pageSize", pageSize);
		
		List list = accountService.selectBankCardList(map);
		long count=accountService.selectBankCardCount(map);
        
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
		if(pageSize!=null){
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		reqMap.put("data", list);
		return reqMap;
	}
	/**
	 * 添加银行卡
	 * @param userId 用户id bankName 银行卡名称 cardNo 卡号
	 * @return
	 */
	@RequestMapping(value="/addBankCard")
	@ResponseBody
	@ApiOperation(value="添加银行卡",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="bankName",value="银行卡名称",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="cardNo",value="卡号",dataType="String",required=true,paramType="query"),
	})
	public Map<String,Object> addBankCard(int userId,String bankName,String cardNo){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("bankName", bankName);
		map.put("cardNo", cardNo);
		Map<String, Object> reqMap = accountService.addBankCard(map);
		return reqMap;
	}
	/**
	 * 查询用户详情
	 * @param userId
	 * @return userId 用户id 
	 * userUrl 头像 
	 * nickName 昵称 
	 * sex 性别（0男，1女，2未知）
	 * birthDate 出生日期
	 * synopsis 简介
	 * education 学历
	 * industry 行业
	 * occupation 职业
	 */
	@RequestMapping(value="/selUserBasic")
	@ApiOperation(value="查询用户详情",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={userId='用户id',userUrl='头像id',nickName='昵称',sex='性别（0男，1女，2未知）',"
				+ "birthDate='出生日期',synopsis='简介',education='学历',industry='行业',occupation='职业'}}")
	})
	public Map<String, Object> selUserBasic(int userId){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId <= 0){
			return reqMap;
		}
		try {
			//查询用户详情
			Map<String,Object> map = accountService.selUserBasic(userId);
			
			pathService.getAbsolutePath(map, "userUrl");
			
			reqMap.put("data", map);
			reqMap.put("result", 1);
			reqMap.put("msg", "成功！");
		} catch (Exception e) {
			reqMap.put("msg", "请求失败"+e.getMessage());
		}
		return reqMap;
	}
	
	/**
	 * 修改用户基本信息
	 * @param 
	 * userId 用户id 
	 * userUrl 头像 
	 * nickName 昵称 
	 * sex 性别（0男，1女，2未知）
	 * birthDate 出生日期
	 * synopsis 简介
	 * education 学历
	 * industry 行业
	 * occupation 职业
	 * @return
	 */
	@RequestMapping(value="/updateBasic")
	@ApiOperation(value="修改用户基本信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userUrl",value="头像",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="nickName",value="昵称",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="sex",value="性别（0男，1女，2未知）",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="birthDate",value="出生日期",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="synopsis",value="简介",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="education",value="学历",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="industry",value="行业",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="occupation",value="职业",dataType="String",required=true,paramType="query")
	})
	public Map<String, Object> updateBasic(int userId,String userUrl,String nickName,int sex,String birthDate,String synopsis,String education,String industry,String occupation){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("userUrl", userUrl);
		map.put("nickName", nickName);
		map.put("sex", sex);
		map.put("birthDate", birthDate);
		map.put("synopsis", synopsis);
		map.put("education", education);
		map.put("industry", industry);
		map.put("occupation", occupation);
		Map<String,Object> reqMap = accountService.updateUserBasic(map);
		return reqMap;
	}
	/**
	 * 注册
	 * @param telenumber 手机号
	 * @param password 密码
	 * return data 注册用户的id
	 */
	@RequestMapping("/register")
	@ApiOperation(value="注册",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="telenumber",value="手机号",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="password",value="密码",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="code",value="验证码",dataType="string",required=true,paramType="query")
	})
	public Map register(String telenumber,String password,String code){
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("msg", "注册成功");
		map.put("result", 1);
		if(StringUtils.isEmpty(telenumber)){
			map.put("result", 0);
			map.put("msg", "请输入手机号");
			return map;
		}
		if(StringUtils.isEmpty(password)){
			map.put("result", 0);
			map.put("msg", "请输入密码");
			return map;
		}
		if(StringUtils.isEmpty(code)){
			map.put("result", 0);
			map.put("msg", "请输入验证码");
			return map;
		}
		boolean flag = isChinaPhoneLegal(telenumber);
		if(!flag){
			map.put("result", 0);
			map.put("msg", "手机号码有误");
			return map;
		}
		String userPwd = Tools.md5(password);
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("userPwd", userPwd);
		paramMap.put("telenumber", telenumber);
		paramMap.put("isAdmin", 0);
		paramMap.put("userType", 1);//新注册用户为普通用户角色
		int count = accountService.selUserBytelenumber(telenumber);
		if(count>0){
			map.put("result", 0);
			map.put("msg", "该手机号已经被注册");
			return map;
		}
		boolean validCode=smsService.Verify("用户注册",telenumber,code);
		if(!validCode) {
			map.put("msg","短信验证码错误！");
			map.put("result",0);
			return map;
		}
		String userId = accountService.register(paramMap);
		if(userId.equals("0")||userId==null){
			map.put("result", 0);
			map.put("msg","注册失败");
			return map;
		}
		map.put("data", userId);
		return map;
	}
	
	/**
	 * 忘记密码
	 * @param telenumber 手机号
	 * return data:用户id
	 */
	@RequestMapping("/fogotPassword")
	@ApiOperation(value="忘记密码",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="telenumber",value="手机号",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="code",value="验证码",dataType="string",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data='用户id'}")
	})
	public Map fogotPassword(String telenumber,String code){
		Map map =new HashMap();
		map.put("result", 0);
		if(StringUtils.isEmpty(telenumber)){
			map.put("msg", "请输入手机号");
			return map;
		}
		if(StringUtils.isEmpty(code)){
			map.put("msg", "请输入验证码");
			return map;
		}
		boolean flags = isChinaPhoneLegal(telenumber);
		if(!flags){
			map.put("msg", "手机号码有误");
			return map;
		}
		boolean validCode=smsService.Verify("密码找回",telenumber,code);
		if(!validCode) {
			map.put("msg","短信验证码错误！");
			return map;
		}
		Map user = new HashMap();
		user.put("telenumber", telenumber);
		Map userinfo = accountService.login(user);
		if(userinfo!=null){
			map.put("result", 1);
			map.put("data",userinfo.get("userId"));
		}else{
			map.put("msg", "您还未注册");
		}
		return map;
	}
	
	
	
	
	/**
	 * 快捷登陆
	 * @param telenumber 手机号
	 * return data:用户id
	 */
	@RequestMapping("/quickLogin")
	@ApiOperation(value="快捷登陆",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="telenumber",value="手机号",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="code",value="验证码",dataType="string",required=true,paramType="query")
	})
	public Map quickLogin(String telenumber,String code){
		Map map =new HashMap();
		if(StringUtils.isEmpty(telenumber)){
			map.put("result", 0);
			map.put("msg", "请输入手机号");
			return map;
		}
		if(StringUtils.isEmpty(code)){
			map.put("result", 0);
			map.put("msg", "请输入验证码");
			return map;
		}
		boolean flags = isChinaPhoneLegal(telenumber);
		if(!flags){
			map.put("result", 0);
			map.put("msg", "手机号码有误");
			return map;
		}
		boolean validCode=smsService.Verify("快捷登录",telenumber,code);
		if(!validCode) {
			map.put("msg","短信验证码错误！");
			map.put("result",0);
			return map;
		}
		Map user = new HashMap();
		user.put("telenumber", telenumber);
		Map userinfo = accountService.login(user);
		if(userinfo!=null){
			map.put("result", 1);
			map.put("data",userinfo.get("userId"));
		}else{
			user.put("isAdmin", 0);
			user.put("userType", 1);
			String userId = accountService.register(user);
			if(userId.equals("0")||userId==null){
				map.put("result", 0);
				map.put("msg","注册失败");
				return map;
			}
			map.put("result", 1);
			map.put("data", userId);
			map.put("msg", "登录成功");
		}
		return map;
	}
	/**
	 * 发送手机验证码
	 * @param telenumber 手机号
	 * return data 验证码
	 */
	@RequestMapping("/sendMessage")
	@ApiOperation(value="发送手机验证码",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="telenumber",value="手机号",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="验证类型：1--快捷登陆(默认) 2--用户注册 3--密码找回",dataType="int",paramType="query"),
		@ApiImplicitParam(name="time",value="时间空则默认90秒失效",dataType="int",paramType="query")
	})
	@ResponseBody
	public Map sendMessage(String telenumber,Integer type,Integer time){
		Map map = new HashMap();
		map.put("result", 1);
		String code = Tools.getOnlynumber(6);
		try {
			if(type==null){
				type=1;
			}
			if(time==null){
				time=90;
			}
			String tempKey="";
			
			switch (type) {
			case 1:
				tempKey="快捷登录";
				break;
			case 2:
				tempKey="用户注册";
				break;
			case 3:
				tempKey="密码找回";
				break;
			}
			
			if(StringHelper.IsNullOrEmpty(tempKey)){
				map.put("result",0);
				map.put("msg", "发送短信失败:未找到对应类型的模板！");
				return map;
			}
			
			boolean flags = isChinaPhoneLegal(telenumber);
			if(flags){
				boolean flag = smsService.send(tempKey, time, telenumber,code);
				if(!flag){
					map.put("result",0);
					map.put("msg", "发送短信失败");
					return map;
				}
			}else{
				map.put("msg", "手机号码有误！");
				map.put("result", 0);
				return map;
			}
		} catch (Exception e) {
			map.put("msg", e.getMessage());
		}
		map.put("data", code);
		return map;
	}
	/**
	 * 登录
	 * @param telenumber 手机号/用户名
	 * @param userPwd  密码
	 * @return 
	 */
	@RequestMapping("/login")
	@ApiOperation(value="登陆",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="telenumber",value="手机号/用户名",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="userPwd",value="密码",dataType="string",required=true,paramType="query")
	
	})
	public Map login(@RequestParam Map paramMap){
		Map result = new HashMap();
		try {
			String telenumber = (String) paramMap.get("telenumber");
			String password = (String) paramMap.get("userPwd");
			if(StringUtils.isEmpty(telenumber)||StringUtils.isEmpty(password)){
				result.put("result",0);
				result.put("msg","手机号用户名或密码不能为空");
				return result;
			}
			String userPwd = Tools.md5(password);
			paramMap.put("userPwd", userPwd);
			Map userinfo = accountService.login(paramMap);
			if(userinfo!=null){
				if(userinfo.get("isFreeze").toString().equals("0")){
					result.put("result", 0);
					result.put("msg", "该账户已被冻结！");
					return result;
				}
				result.put("msg", "登录成功");
				result.put("data", userinfo.get("userId"));
				result.put("result", 1);
				return result;
			}else{
				result.put("result", 0);
				result.put("msg", "手机号或密码错误");
				return result;
			}
		} catch (Exception e) {
			result.put("msg", e.getMessage());
		}
		return result;
		
	}
	/**
	 * 查询用户消费记录
	 * @param 用户userId 
	 * @return consumTotal当月总消费
	 * return  incomeTotal当月总收入
	 * return  Id 用户id
	 * return  money 单笔金额
	 * return  num 编号
	 * return  status 0代表支出 1代表收入
	 * return  time  交易时间
	 * return  types 类型
	 */
	@RequestMapping("getUserAccountLog")
	@ApiOperation(value="查询用户消费记录",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={[types='充值 提问 购买 旁听 打赏  提问退款 平台收益',year='当前年月  格式:2018-03',consumTotal='当月总消费',"
				+ "incomeTotal='当月总收入',money='单笔金额',num='编号',status='0代表支出 1代表收入',time='交易时间',failMoney='统计每月的总收入时需incomeTotal减去此值'"
				+ ",paystatus='类型是充值时需判断此状态 0未支付 1已支付 ']}}")
	})//list<Map<list>> -->list 里是 map 有year 用来判断哪年哪月  总收入总消费以及失败的充值金额 
	//map里有data（list）里边是当月的交易的详情记录
	public Map getYearsAndmonth(Integer userId,Integer pageNow,Integer pageSize){
		Map map = new HashMap();
		if(null == userId || null==pageNow || pageSize==null){
			map.put("msg", "参数 错误");
			map.put("result", 0);
			return map;
		}
		Map paramap = new HashMap();
		paramap.put("pageNow", pageNow);
		
		List<Map<String,Object>> length = accountService.getYearsAndmonthCount(userId);
		if(null==length || length.size()==0){
			map.put("result", 1);
			map.put("tatalPage", 1);
			map.put("pageNow", 1);
			map.put("msg","获取成功");
			map.put("data", new ArrayList());
			return map;
		}
		long totalCount = length.size();
		Page page = new Page(totalCount, pageNow, pageSize);
		List list = accountService.getYearsAndmonth(page.getStartPos(),pageSize,userId);
		map.put("tatalPage", page.getTotalPageCount());
		map.put("pageNow", pageNow);
		map.put("data", list);
		map.put("msg","获取成功");
		map.put("result", 1);
		return map;
	}
	//判断手机号
	public  boolean isChinaPhoneLegal(String phoneNum){
		 String regExp = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"; 
		 
	     Pattern p = Pattern.compile(regExp);
	     Matcher m = p.matcher(phoneNum);  
	     return m.matches();  
	}
	/**
	 * 图片上传
	 * @param files
	 * @return
	 */
	@RequestMapping(value="/uploadPic")
	@ApiOperation(value="图片上传 ",httpMethod="POST")
	public Map<String, Object> uploadImg(@RequestParam("picUrl") MultipartFile files) {
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		// 文件上传
		String imgUrl = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir();
		String newFileName = "";
		// 获取路径 upload/Advertisement/yyyyMMdd/
		String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");
		if (files.isEmpty()) {
			imgUrl = "";
		} else {
			newFileName = UUID.randomUUID().toString()+Tools.getFileExtension(files.getOriginalFilename());// 获取图片名称
			String newFilePath = filePath + newFileName;// 新路径
			File newFile = new File(newFilePath);
			if (newFile.exists()) {
				//String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				newFilePath = filePath + newFileName;
				newFile = new File(newFilePath);
			}
			try {
				files.transferTo(newFile);
			} catch (Exception e) {
				reqMap.put("msg", "上传失败!"+e.getMessage());
			}
			;
			imgUrl = "/" + pathSub + newFileName;// 保存到数据库的路径
		}
		if(StringUtils.isEmpty(newFileName)){
			reqMap.put("result", 0); 
			reqMap.put("msg", "上传失败!");
		}else{
			reqMap.put("result", 1); 
			reqMap.put("msg", "上传成功!");
			reqMap.put("data", imgUrl);
		}
		return reqMap;
	}
	/**
	 * 个人认证
	 * @param userId 用户id （int）
	 * @param realname 真实姓名
	 * @param documentType 证件类型 （String）
	 * @param identitynumber 身份证号 （String）
	 * @param IDpic 身份证照片 (String)
	 * @param oneselfPic 本人照片 (String)
	 * @return
	 */
	@RequestMapping(value="/authentication")
	@ApiOperation(value="个人认证 ",httpMethod="POST")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="realname",value="真实姓名",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="documentType",value="证件类型",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="identitynumber",value="身份证号",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="IDpic",value="身份证照片",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="oneselfPic",value="本人照片",dataType="String",required=true,paramType="query")
	})
	public Map<String, Object> authentication(int userId,String realname,String documentType,String identitynumber,String IDpic,String oneselfPic){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId <= 0){
			return reqMap;
		}
		map.put("userId", userId);
		map.put("realname", realname);
		map.put("documentType", documentType);
		map.put("identitynumber", identitynumber);
		map.put("IDpic", IDpic);
		map.put("oneselfPic", oneselfPic);
		try {
			//添加认证信息
			int row = accountService.authentication(map);
			if(row > 0){
				reqMap.put("result", 1);
				reqMap.put("msg", "保存成功!");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "保存失败!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败!"+e.getMessage());
		}
		return reqMap;
	}
	/**
	 * 修改密码
	 * @param userId 用户id (int)
	 * @param oldPwd 旧密码 （String）
	 * @param newPwd 新密码 （String）
	 * @param confirmNewPwd 确认新密码 (String)
	 * @return
	 */
	@RequestMapping(value="/updatePwd")
	@ApiOperation(value="修改密码",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="oldPwd",value="原密码如没有设置不传即可",dataType="String",required=false,paramType="query"),
		@ApiImplicitParam(name="newPwd",value="新密码",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="confirmNewPwd",value="确认新密码",dataType="String",required=true,paramType="query")
	})
	public Map<String, Object> updatePwd(Integer userId,String oldPwd,String newPwd,String confirmNewPwd){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("oldPwd", oldPwd);
		map.put("newPwd", newPwd);
		map.put("confirmNewPwd", confirmNewPwd);
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(newPwd==null || confirmNewPwd==null || userId==null){
			return reqMap;
		}
		//判断旧密码是否正确
		//查询旧密码
		if(oldPwd !=null && !"".equals(oldPwd)) {
			String password = accountService.selPwd(map);
			if(password!=null) {
				if(oldPwd==null) {
					reqMap.put("msg", "请输入原密码");
					return reqMap;
				}
				if(!password.equals(Tools.md5(oldPwd))){
					reqMap.put("result", 0);
					reqMap.put("msg", "旧密码不正确!");
					return reqMap;
				}
			}
		}
		//判断两次输入的密码是否一致
		if(!Tools.md5(newPwd).equals(Tools.md5(confirmNewPwd))){
			reqMap.put("result", 0);
			reqMap.put("msg", "两次输入的密码不一致!");
			return reqMap;
		}
		try {
			//修改密码
			map.put("password", Tools.md5(newPwd));
			int row = accountService.updatePwd(map);
			if(row > 0){
				reqMap.put("result", 1);
				reqMap.put("msg", "修改成功!");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "修改失败!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败!"+e.getMessage());
		}
		return reqMap;
	}
	/**
	 * 设置专栏信息
	 * @param userId 用户id （int）
	 * @param realname 真实姓名 （String）
	 * @param identitynumber 身份证号 (String)
	 * @param questionPrice 问答价格 (double)
	 * @param cardNo 银行卡号 (String)
	 * @return
	 */
	@ApiOperation(value="设置专栏信息",httpMethod="GET")
	@RequestMapping(value="/setColumn")
	public Map<String, Object> setColumn(Integer userId,String realname,String identitynumber,double questionPrice,String cardNo){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId == null || userId <= 0){
			return reqMap;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("realname", realname);
		map.put("identitynumber", identitynumber);
		map.put("questionPrice", questionPrice);
		map.put("cardNo", cardNo);
		
		try {
			//设置专栏信息
			int row = accountService.setColumns(map);
			if(row > 0){
				reqMap.put("result", 1);
				reqMap.put("msg", "设置成功!");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "设置失败!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败！"+e.getMessage());
		}
		return reqMap;
	}
	/**
	 * 用户取消收藏
	 * @param 用户id userId
	 * @param dataId 收藏对象id 
	 * @param dataType 收藏类型
	 * @param favoriteType 类型 1--收藏 2--关注
	 */
	@RequestMapping("cancelCollect")
	@ApiOperation(value="用户取消收藏",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="dataId",value="收藏对象id ",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="dataType",value="收藏类型 1--纸质期刊 2--电子期刊 3--点播直播课程 4--商品 5--专家",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="favoriteType",value="类型 1--收藏 2--关注",dataType="int",required=true,paramType="query")
	})
	public Map cancelCollect(Integer userId,Integer dataId,Integer dataType,Integer favoriteType){
		Map map = new HashMap();
		map.put("msg", "取消操作成功");
		map.put("result", 1);
		try {
			if(null==userId||null==dataId||null==dataType||null==favoriteType){
				map.put("result", 0);
				map.put("msg", "传入数据错误！");
				return map;
			}
			Map paramap = new HashMap();
			paramap.put("userId", userId);
			paramap.put("dataId", dataId);
			paramap.put("dataType", dataType);
			paramap.put("favoriteType", favoriteType);
			accountService.cancelCollect(paramap);
		} catch (Exception e) {
			map.put("result", 0);
			map.put("msg", "取消操作失败");
		}
		return map;
	}
	/**
	 * 批量取消收藏
	 * 
	 */
	@RequestMapping("batcancelCollect")
	@ApiOperation(value="批量用户取消收藏/关注",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="ids",value="收藏对象id多个用‘,’分隔 ",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="dataType",value="数据类型：1--纸质期刊 2--电子期刊 3--点播直播课程 4--商品 5--专家",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="favoriteType",value="类型 1--收藏 2--关注",dataType="int",required=true,paramType="query")
	})
	public Map batcancelCollect(Integer userId,String ids,Integer dataType,Integer favoriteType){
		Map map = new HashMap();
		map.put("msg", "取消成功");
		map.put("result", 1);
		try {
			if(null==userId||null==ids||null==dataType||null==favoriteType){
				map.put("result", 0);
				map.put("msg", "传入数据错误！");
				return map;
			}
			Map paramap = new HashMap();
			paramap.put("userId", userId);
			List<Integer> list = StringHelper.ToIntegerList(ids);
			paramap.put("list", list);
			paramap.put("dataType", dataType);
			paramap.put("favoriteType", favoriteType);
			int count = accountService.batcancelCollect(paramap);
			if(count<=0){
				map.put("result", 0);
				map.put("msg", "取消失败");
			}
		} catch (Exception e) {
			map.put("result", 0);
			map.put("msg", "取消失败"+e.getMessage());
		}
		return map;
	}
	/**
	 * * 用户收藏列表
	 * @param 用户id userId
	 * @param 数据类型 dataType 1--纸质期刊  2--电子
	 * @param pageNow 当前页数
	 * @param pageSize 一页显示的记录数
	 * 
	 *  杂志：收藏列表的id favoriteId ,杂志的id： id,杂志名字 bookName,年：year,期次:describes,杂志图片picture
*  电子: 收藏列表的id favoriteId ,课程名称 name,头像图片userUrl,购买数量studentNum, 点击次数hits,更新课时count
*  		serialState连载状态 （0非连载课程 1更新中 2已完结）IsRecommend是否推荐0否 1是
	 */
	@RequestMapping("favoriteList")
	@ApiOperation(value="用户收藏列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="dataType",value=" 1--纸质期刊  2--电子",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="一页显示的记录数",dataType="int",required=true,paramType="query")
	})
	public Map favoriteList(Integer userId, Integer dataType,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String,Object>();
		if(null==userId||null==dataType){
			map.put("result", 0);
			map.put("msg", "传入数据错误！");
			return map;
		}
		if(null==pageNow || pageNow<1){
			pageNow=1;
		}
		if(null==pageSize|| pageSize<0){
			pageSize=10;
		}
		Map<String,Object> paramap = new HashMap<String,Object>();
		paramap.put("userId", userId);
		paramap.put("dataType", dataType);
		//查询纸质期刊
		if(dataType==1){
			long count = accountService.getBookCount(userId);
			Page page = new Page(count,pageNow,pageSize);
			int startPos = page.getStartPos();
			paramap.put("start", startPos);
			paramap.put("pageSize", pageSize);
			List list = accountService.selBook(paramap);
			
			pathService.getAbsolutePath(list, "picture");
			
			map.put("totalPage", page.getTotalPageCount());
			map.put("data", list);
			map.put("pageNow", pageNow);
			map.put("result", 1);
			return map;
		}
		//查询点播课程和直播课程.电子期刊
		long count = accountService.getOthersCount(userId);
		Page page = new Page(count,pageNow,pageSize);
		int startPos = page.getStartPos();
		paramap.put("start", startPos);
		paramap.put("pageSize", pageSize);
		List list = accountService.selOthers(paramap);
		
		pathService.getAbsolutePath(list, "userUrl");
		
		map.put("totalPage", page.getTotalPageCount());
		map.put("data", list);
		map.put("pageNow", pageNow);
		map.put("result", 1);
		return map;
	}
	/**
	 * 用户添加收藏
	 * @param 用户id userId
	 * @param 收藏的对象的id dataId
	 * @param 数据类型 dataType 1--纸质期刊 2--电子期刊 3--点播直播课程 4--商品 5--专家
	 * @param 类型 favoriteType ：1--收藏 2--关注
	 */
	@RequestMapping(value="/addCollect")
	@ApiOperation(value="用户添加收藏/关注",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="dataId",value="收藏的对象的id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="dataType",value="数据类型 1--纸质期刊 2--电子期刊 3--点播直播课程 4--商品 5--专家",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="favoriteType",value="类型 1--收藏 2--关注",dataType="int",required=true,paramType="query")
	})
	public  Map<String, Object> addCollect(Integer userId,Integer dataId,Integer dataType,Integer favoriteType){
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(null==userId||userId <= 0||dataId<=0||null==dataId||null==dataType||null==favoriteType){
			return reqMap;
		}
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userId", userId);
			map.put("dataId", dataId);
			map.put("dataType", dataType);
			map.put("favoriteType", favoriteType);
			//不可关注自己
			if(dataType==5&&favoriteType==2&&userId==dataId) {
				reqMap.put("msg", "不可以关注自己");
				return reqMap;
			}
			//查询当前商品是否已经收藏/关注
			Map ma = accountService.selIsfavorites(map);
			if(!StringUtils.isEmpty(ma)){
				reqMap.put("result", 0);
				if(favoriteType==1){
					reqMap.put("msg", "该商品已经收藏了!");
				}else{
					reqMap.put("msg", "已经关注了!");
				}
				return reqMap;
			}
			//作家自己不能关注自己
			if(favoriteType==2) {
				if(userId==dataId) {
					reqMap.put("msg", "专栏作家不能关注自己!");
					return reqMap;
				}
			}
			//添加收藏
			int row = accountService.addCollect(map);
			if(row > 0){
				reqMap.put("result", 1);
				reqMap.put("msg", "添加操作成功!");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "添加操作失败!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败！"+e.getMessage());
		}
		return reqMap;
	}
	/**
	 * 购物车商品移入收藏
	 * @param 用户id userId
	 * @param 收藏的对象的id dataId
	 * @param 数据类型 dataType 1--纸质期刊 2--电子期刊 3--点播直播课程 4--商品 
	 */
	/*@RequestMapping("moveFavorite")
	public Map<String,Object> moveFavorite(Integer userId,Integer dataId,Integer dataType){
		Map<String,Object> map = new HashMap<>();
		map.put("result", 0);
		try {
			if(null==userId||null==dataId||null==dataType){
				map.put("msg", "传入参数错误");
				return map;
			}
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			paramap.put("dataId", dataId);
			paramap.put("dataType", dataType);
			boolean flag = accountService.moveFavorite(paramap);
			if(!flag){
				map.put("result", "移入收藏失败");
				return map;
			}
		} catch (Exception e) {
			map.put("msg", "移入收藏失败"+e.getMessage());
			return map;
		}
		map.put("msg", "移入收藏成功");
		map.put("result", 1);
		return map;
	}*/
	/**
	 * 获取用户打赏列表
	 * @param userId
	 * @param page
	 * @param pageSize 
	 * * @param type 类型(我的打赏---1，打赏我的---2)
	 * @return
	 */
	@RequestMapping(value="/rewardlog")
	@ApiOperation(value="(个人中心)获取用户打赏列表--我的打赏/打赏我的",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="类型(我的打赏---1，打赏我的---2)",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="当前页数",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="一页显示的记录数",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='记录id',money='金额',inputDate='打赏时间',realname='打赏人真实姓名',nickName='打赏人昵称',userUrl='头像'}}")
	})
	public Map<String, Object> rewardlog(Integer userId,Integer type,Integer page,Integer  pageSize){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId == null || userId <= 0){
			return reqMap;
		}
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
		map.put("type", type);
		map.put("userId", userId);
		//获取用户打赏列表
		List list = accountService.selRewardLoglist(map);
		
		pathService.getAbsolutePath(list, "userUrl");
		
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
		if(flag){
			long count=accountService.selRewardLogcount(map);
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		reqMap.put("data", list);
		
		return reqMap;
	}
	/**
	 * 用户添加笔记
	 * @param userId 用户id
	 * @param hourId 课时id
	 * @param content 笔记内容
	 * @param minute 视频节点分钟 second 视频节点秒
	 */
	@RequestMapping("/createNode")
	@ApiOperation(value="用户添加笔记",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="hourId",value="课时id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="content",value="笔记内容",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="nodeTime",value="视频节点时分秒",dataType="String",required=true,paramType="query")
//		@ApiImplicitParam(name="second",value="视频节点秒",dataType="String",required=true,paramType="query")
	})
	public Map<String,Object> createNode(Integer userId,Integer hourId,String content,String nodeTime){
		Map<String,Object> map = new HashMap<>();
		map.put("msg", "传入数据错误");
		map.put("result", 0);
		try {
			if(userId==null||hourId==null||content==null){
				return map;
			}
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			paramap.put("hourId", hourId);
			paramap.put("content", content);
			paramap.put("nodeTime", nodeTime);
			boolean flag = accountService.createNode(paramap);
			if(!flag){
				map.put("msg", "添加笔记失败");
				return map;
			}
			map.put("msg", "添加笔记成功");
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg", e.getMessage());
		}
		return map;
	}
	/**
	 * 展示用户笔记列表
	 * @param userId
	 * @param pageNow 当前页数
	 * @param pageSize 一页显示的记录数
	 * return   id,userUrl 头像图片,title提问的课时名称,abstracts课时简介,content笔记的内容,addTime
	 */
	@RequestMapping("/getNodeList")
	@ApiOperation(value="获取用户笔记列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页数",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="一页显示的记录数",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='笔记的id',name='课程的名字',addTime='笔记的创建时间',hourId='课时的id',title='课时名称',"
				+ "abstracts='课时的摘要',content='笔记内容',ondemandId=课程的id,userUrl='用户头像',nodeTime='笔记节点（时分秒）'}}")
	})
	public Map<String,Object> getNodeList(Integer userId,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<>();
		map.put("result", 0);
		try {
			if(null==userId){
				map.put("msg", "请输入用户的id");
				return map;
			}
			if(null==pageNow || pageNow<1){
				pageNow=1;
			}
			if(null==pageSize|| pageSize<0){
				pageSize=10;
			}
			long count = accountService.getNodeCount(userId);
			Page page = new Page(count,pageNow,pageSize);
			int startPos = page.getStartPos();
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			paramap.put("start", startPos);
			paramap.put("pageSize", pageSize);
			List<Map<String,Object>> list = accountService.getNodeList(paramap);
			
			pathService.getAbsolutePath(list, "userUrl");
			
			map.put("totalPage", page.getTotalPageCount());
			map.put("data", list);
			map.put("pageNow", pageNow);
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg", "获取列表失败");
		}
		return map;
	}
	/**
	 * 删除笔记
	 * @param 笔记id  nodeIds  多个用“，”间隔  nodeIds
	 * @param userId
	 */
	@RequestMapping("delNode")
	@ApiOperation(value="删除笔记",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="nodeIds",value="笔记id 多个‘,’间隔",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query")
	})
	public Map<String,Object> delNode(String nodeIds,Integer userId){
		Map<String,Object> map = new HashMap<>();
		map.put("result", 0);
		try {
			if(nodeIds==null||nodeIds==""||userId==null){
				map.put("msg", "传入的参数错误");
				return map;
			}
			List<Integer> list = StringHelper.ToIntegerList(nodeIds);
			Map<String,Object> maps = new HashMap<>();
			maps.put("list", list);
			maps.put("userId", userId);
			boolean flag = accountService.delNode(maps);
			if(!flag){
				map.put("msg", "删除笔记失败");
				return map;
			}
			map.put("result", 1);
			map.put("msg", "删除笔记成功");
		} catch (Exception e) {
			map.put("msg", "删除失败"+e.getMessage());
		}
		return map;
	}
	
	/**
	 * 旁听列表
	 * @param userId  客户id
	 * @param pageNow 当前页
	 * @param pageSize 每页显示记录数
	 * 
	 */
	@RequestMapping("getMyAuditList")
	@ApiOperation(value="(个人中心)旁听列表--我的旁听/旁听我的",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="客户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="类型1--我的旁听 2--旁听我的",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页数",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="一页显示的记录数",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='旁听id',userUrl='用户头像',name='课程名称',content='旁听内容',picUrl='课程图片',"
				+ "inputTime='旁听时间',answer='答案',answerType='答案类型：1音频,2文字',musicUrl='音频地址'}}")
	})
	public Map<String,Object> getMyAuditList(Integer userId,Integer type,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(userId==null){
				map.put("msg", "请输入用户id");
				return map;
			}
			if(null==pageNow || pageNow<1){
				pageNow=1;
			}
			if(null==pageSize|| pageSize<0){
				pageSize=10;
			}
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			paramap.put("type", type);
			
			long count = accountService.getMyAuditListCount(paramap);
			Page page = new Page(count,pageNow,pageSize);
			int startPos = page.getStartPos();
			paramap.put("start", startPos);
			paramap.put("pageSize", pageSize);
			
			List list = accountService.getMyAuditList(paramap);
			
			pathService.getAbsolutePath(list, "userUrl","picUrl","musicUrl");
			
			map.put("result", 1);
			map.put("totalPage", page.getTotalPageCount());
			map.put("data", list);
			map.put("pageNow", pageNow);
		} catch (Exception e) {
			map.put("result", 0);
			map.put("msg","获取旁听列表失败"+e.getMessage());
		}
		return map;
	}
	/**
	 * 获取用户优惠券列表
	 * @param  userId 用户id
	 * @param  pageNow 当前页  pageSize 显示记录数
	 * return 
	 */
	@RequestMapping("getCoupons")
	@ResponseBody
	@ApiOperation(value="获取用户优惠券列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="2已使用1未使用0已过期",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="显示记录数",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={Id='优惠券id',name='优惠券名字',manprice='满多少价格',jianprice='减多少价格',"
				+ "couponType='1品类券2定向券',pinleiGoodsType='品类券类型多个，号间隔 1商品 2期刊 3点播 4直播',dingxiangGoodsType='定向券类型1作家 2期刊 3点播 4直播',dingxiangGoodsName='定向券指定的商品名',"
				+ "startTime='开始时间',endTime='结束时间'}}")
	})
	public Map<String,Object> getCoupons(String type,Integer userId,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==pageNow||null==pageSize||null==type||pageNow<0||pageSize<0||null==userId){
				map.put("msg", "参数错误");
				return map;
			}
			Map<String,Object> paramap = new HashMap<String, Object>();
			paramap.put("userId", userId);
			paramap.put("type", type);
			long totalCount = accountService.getCouponsCount(paramap);
			Page page = new Page(totalCount, pageNow, pageSize);
			paramap.put("start", page.getStartPos());
			paramap.put("pageSize", pageSize);
			paramap.put("type", type);
			List list = accountService.getCoupons(paramap);
			map.put("totalPage", page.getTotalPageCount());
			map.put("result", 1);
			map.put("data", list);
			map.put("pageNow", pageNow);
		} catch (Exception e) {
			map.put("msg", "获取失败");
		}
		return map;
	}
	/**
	 * 获取用户代金券列表
	 * @param  userId 用户id
	 * @param  pageNow 当前页  pageSize 显示记录数
	 * return 
	 */
	@RequestMapping("getVoucher")
	@ResponseBody
	@ApiOperation(value="获取用户代金券列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="2已使用1未使用0已过期",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="显示记录数",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={Id='代金券id',name='代金券名字',price='代金券面值',"
				+ "couponType='1品类券2定向券',pinleiGoodsType='品类券类型多个，号间隔 1商品 2期刊 3点播 4直播',dingxiangGoodsType='定向券类型1作家 2期刊 3点播 4直播',dingxiangGoodsName='定向券指定的商品名',"
				+ "startTime='开始时间',endTime='结束时间'}}")
	})
	public Map<String,Object> getVoucher(String type,Integer userId,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==pageNow||null==pageSize||null==type||pageNow<0||pageSize<0||null==userId){
				map.put("msg", "参数错误");
				return map;
			}
			Map<String,Object> paramap = new HashMap<String, Object>();
			paramap.put("userId", userId);
			paramap.put("type", type);
			long totalCount = accountService.getVoucherCount(paramap);
			Page page = new Page(totalCount, pageNow, pageSize);
			paramap.put("start", page.getStartPos());
			paramap.put("pageSize", pageSize);
			paramap.put("type", type);
			List list = accountService.getVoucher(paramap);
			map.put("totalPage", page.getTotalPageCount());
			map.put("result", 1);
			map.put("data", list);
			map.put("pageNow", pageNow);
		} catch (Exception e) {
			map.put("msg", "获取失败");
		}
		return map;
	}
	/**
	 * 通过商品类型和id获取符合的代金券
	 * @param  userId 用户id
	 * return 
	 */
	@RequestMapping("getVoucherByType")
	@ResponseBody
	@ApiOperation(value="通过商品类型和id获取符合的代金券",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="商品类型2期刊 3点播 4直播",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="productId",value="商品id期刊是购物车项的id多个,号间隔",dataType="string",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={Id='代金券id',name='代金券名字',price='代金券的减免的面额价格',"
				+ "couponType='1品类券2定向券',pinleiGoodsType='品类券类型多个，号间隔 1商品 2期刊 3点播 4直播',dingxiangGoodsType='定向券类型1作家 2期刊 3点播 4直播',dingxiangGoodsName='定向券指定的商品名',startTime='开始时间',endTime='结束时间'}}")
	})
	public Map<String,Object> getVoucherByType(String type,Integer userId,Double price,String productId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==type||null==userId||null==productId){
				map.put("msg", "参数错误");
				return map;
			}
			Map<String,Object> paramap = new HashMap<String, Object>();
			paramap.put("userId", userId);
			paramap.put("type", type);
			paramap.put("productId", productId);
			return accountService.getVoucherByType(paramap);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("msg", "获取失败");
		}
		return map;
	}
	/**
	 * 通过商品类型和id获取符合的优惠券
	 * @param  userId 用户id
	 * return 
	 */
	@RequestMapping("getCouponsByType")
	@ResponseBody
	@ApiOperation(value="通过商品类型和id获取符合的优惠券",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="商品类型2期刊 3点播 4直播",dataType="string",required=true,paramType="query"),
		@ApiImplicitParam(name="productId",value="商品id期刊是购物车项的id多个,号间隔",dataType="string",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={Id='优惠券id',name='优惠券名字',manprice='满多少价格',jianprice='减多少价格',"
				+ "couponType='1品类券2定向券',pinleiGoodsType='品类券类型多个，号间隔 1商品 2期刊 3点播 4直播',dingxiangGoodsType='定向券类型1作家 2期刊 3点播 4直播',dingxiangGoodsName='定向券指定的商品名',startTime='开始时间',endTime='结束时间'}}")
	})
	public Map<String,Object> getCouponsByType(String type,Integer userId,String productId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==type||null==userId||null==productId){
				map.put("msg", "参数错误");
				return map;
			}
			Map<String,Object> paramap = new HashMap<String, Object>();
			paramap.put("userId", userId);
			paramap.put("type", type);
			paramap.put("productId", productId);
			return accountService.getCouponsByType(paramap);
		/*	if(!DataConvert.ToBoolean(result.get("success"))){
				map.put("result", 0);
				map.put("msg", "获取失败");
				return map;
			}
			map.put("result", 1);
			map.put("data", result.get("lists"));
			map.put("msg", "获取成功");*/
		} catch (Exception e) {
			e.printStackTrace();
			map.put("msg", "获取失败");
		}
		return map;
	}
	/**
	 * 获取用户信息(个人中心)
	 * @param userId
	 * @return
	 */
	@RequestMapping(value="/getUserMsg")
	@ApiOperation(value="获取用户信息(个人中心，我的页面)",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="String",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={(isHasPassword='用户是否已经设置密码1是0否',userUrl='头像',nickName='昵称',"
				+ "vipGrade='等级',buyCount='已购',balance='余额',"
				+ "coupon='优惠券数量',voucher='代金券数量',twCount='提问',ptCount='旁听',rewardCount='打赏')}}")
	})
	public Map<String, Object> getUserMsg(String userId){
		Map<String, Object> userMsg = accountService.selectUserMsg(userId);
		return userMsg;
	}
	
	/**
	 * 生成打赏记录
	 */
	@RequestMapping(value="/getReardlog")
	@ApiOperation(value="生成打赏记录",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="contentId",value="被打赏人id",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="money",value="打赏金额",dataType="double",required=true,paramType="query"),
		@ApiImplicitParam(name="rewardMsg",value="备注",dataType="String",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={paylogId='支付记录id'}}")
	})
	public Map<String, Object> getReardlog(String userId,String contentId,double money,String rewardMsg){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map = accountService.addRewardLog(contentId,money,rewardMsg,userId);
		boolean falg = DataConvert.ToBoolean(map.get("success"));
		if(falg){
			reqMap.put("result", 1);
			reqMap.put("msg", DataConvert.ToString(map.get("msg")));
			reqMap.put("paylogId", map.get("paylogId")+"");
		}else{
			reqMap.put("result", 0);
			reqMap.put("msg", DataConvert.ToString(map.get("msg")));
		}
		return reqMap;
	}
	/**
	 * 关注列表
	 */
	@RequestMapping(value="/getFollowList")
	@ApiOperation(value="获取关注列表(个人中心、关注我的/我的关注)",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="type",value="1--我的关注 2--关注我的 ",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={userUrl='关注人头像',name='名称',id='关注id',userId='用户id',dataType='数据类型：1--纸质期刊 2--电子期刊 3--点播直播课程 4--商品 5--专家 6--评论 7--会员 '"
				+ "favoriteType='类型：1--收藏 2--关注',addTime='时间'}}")
	})
	public Map<String, Object> getFollowList(Integer userId,Integer type,Integer page,Integer pageSize){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
			}
		};
		
		if(userId==null||type==null){
			return reqMap;
		}
		
		boolean flag = false;
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
		map.put("userId", userId);
		map.put("type", type);
		
		List list = accountService.selectFollowList(map);
		
		pathService.getAbsolutePath(list, "userUrl");
		
		reqMap.put("data", list);
		reqMap.put("result", 1);
		reqMap.put("msg", "获取成功!");
		if(flag){
			long count = accountService.selectFollowCount(map);
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		return reqMap;
	}
	
	
	
	
}
















