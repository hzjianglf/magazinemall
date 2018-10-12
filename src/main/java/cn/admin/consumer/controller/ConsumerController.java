package cn.admin.consumer.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.consumer.service.ConsumerService;
import cn.admin.consumer.service.SpecialColumnService;
import cn.admin.system.service.UserService;
import cn.api.service.AccountService;
import cn.api.service.OrderService;
import cn.api.service.PathService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.ExcelUntil;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;

/**
 * 用户管理
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/admin/consumer")
public class ConsumerController {

	@Autowired
	AccountService accountService;
	@Autowired
	ConsumerService consumerService;
	@Autowired
	UserService userService;
	@Autowired
	SpecialColumnService writerService;
	@Autowired
	OrderService orderService;
	@Autowired
	PathService pathService;
	/**
	 * 查询用户列表
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="用户-用户列表")
	public ModelAndView list(){
		return new ModelAndView("/admin/consumer/list");
	}
	//获取用户数据
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String,Object> listData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		String name = request.getParameter("name");
		String isFreeze = request.getParameter("isFreeze");
		String registrationDate = request.getParameter("registrationDate");
		String userType = request.getParameter("userType");
		String openId = request.getParameter("openId");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("name", name);
		reqMap.put("isFreeze", isFreeze);
		reqMap.put("openId", openId);
		if(Tools.isNotEmpty(registrationDate)){
			String[] split = registrationDate.split(" - ");
			String regBeginTime = split[0];
			String regEndTime = split[1];
			reqMap.put("regBeginTime", regBeginTime);
			reqMap.put("regEndTime", regEndTime);
		}
		reqMap.put("userType", userType);
		long count = consumerService.selConsumerCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = consumerService.selConsumerList(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 删除用户
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	public Map<String, Object> deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = consumerService.deletes(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败");
		}
		return reqMap;
	}
	/**
	 * 批量删除
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/deleteids")
	@ResponseBody
	public Map<String, Object> deleteids(HttpServletRequest request){
		Map<String, Object> map = new HashMap<String, Object>();
		String ids = request.getParameter("ids");
		String[] id = ids.split(",");
		map.put("id", id);
		long row = consumerService.deleteids(map);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败");
		}
		return map;
	}
	/**
	 * 弹出用户修改页面
	 * 
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/UpConsumer")
	//@Authorize(setting = "用户-管理员修改")
	public ModelAndView adminUpdate(HttpServletRequest request) {
		// 通过ID查询单个会员
		String userId = request.getParameter("userId");
		String userType = request.getParameter("userType");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userType", userType);
		map.put("userId", userId);
		//基本信息
		Map<String, Object> userMap = writerService.selectUserInfoById(userId);
		pathService.getAbsolutePath(userMap, "IDpic");
		map.put("userMap", userMap);
		if("2".equals(userType)){
			//查询专家信息
			Map<String, Object> writerMsg = writerService.selectWriterMsg(map);
			map.put("writerMsg", writerMsg);
		}
		return new ModelAndView("/admin/consumer/update", map);
	}
	/**
	 * 修改用户信息
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/editUser")
	@ResponseBody
	public Map editUser(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(map.containsKey("userPwd")) {
			String newPwd=DataConvert.ToString(map.get("userPwd"));
			if(StringHelper.IsNullOrEmpty(newPwd)) {
				map.remove("userPwd");
			}else {
				//查询用户密码
				String pwd = consumerService.selUserPwd(map);
				if(!StringHelper.IsNullOrEmpty(pwd)) {
					if(pwd.equals(newPwd)){
						map.remove("userPwd");
					}else{
						map.put("userPwd", Tools.md5(map.get("userPwd")+""));
					}
				}
			}
		}
		int row = consumerService.editUser(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "保存失败!");
		}
		return reqMap;
	}

	/**
	 * 添加扩展信息
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/upExtends")
	@ResponseBody
	public Map<String, Object> upExtends(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(!"2".equals(map.get("userType2"))){
			reqMap.put("success", false);
			reqMap.put("msg", "普通用户不需要添加扩展信息!");
			return reqMap;
		}
		int row = 0;
		if(!StringUtils.isEmpty(map.get("id"))){
			//修改
			row = consumerService.upExtends(map);
		}else{
			//添加
			row = consumerService.addExtends(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败!");
		}
		return reqMap;
	}
	/**
	 * 批量导出excel
	 * @param request
	 * @param response
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping(value="/download")
	@Authorize(setting="用户-批量导出excel")
	public void batchPlex(HttpServletRequest request,HttpServletResponse response,@RequestParam Map map) throws UnsupportedEncodingException {
		String registrationDate = map.get("registrationDate")+"";
		if(Tools.isNotEmpty(registrationDate)){
			String[] split = registrationDate.split(" - ");
			String regBeginTime = split[0];
			String regEndTime = split[1];
			map.put("regBeginTime", regBeginTime);
			map.put("regEndTime", regEndTime);
		}
		String ids = map.get("ids")+"";
		String[] id = ids.split(",");
		map.put("id", id);
		//查询导出数据
		List<Map> list = consumerService.selectDownload(map);
		for (Map map2 : list) {
			//用户类型
			if("1".equals(map2.get("userType")+"")){
				map2.put("userType", "普通用户");
			}else{
				map2.put("userType", "专家");
			}
			//是否推荐
			if("1".equals(map2.get("IsRecommend")+"")){
				map2.put("IsRecommend", "推荐");
			}else if("0".equals(map2.get("IsRecommend")+"")){
				map2.put("IsRecommend", "不推荐");
			}else{
				map2.put("IsRecommend", "-");
			}
		}
		String[] excelHeader={"昵称","手机号","性别","积分","余额(元)","注册时间","状态","用户类型","是否推荐","免购买用户"};
		String[] mapKey={"nickName","telenumber","sex","accountJF","balance","registrationDate","isFreeze","userType","IsRecommend","noPurchaseUser"};
	    ExcelUntil.excelToFile(list,excelHeader,mapKey,response,"用户列表");
	}
	
	/**
	 * 查询会员信息
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/selUserMsg")
	public ModelAndView selUserMsg(HttpServletRequest request){
		String userId = request.getParameter("userId");
		Map<String, Object> userMap = consumerService.selectUserInfoById(userId);
		if("0".equals(userMap.get("sex")+"")){
			userMap.put("sex", "男");
		}else if("1".equals(userMap.get("sex")+"")){
			userMap.put("sex", "女");
		}else{
			userMap.put("sex", "不祥");
		}
		return new ModelAndView("/admin/consumer/iframe/userMsg",userMap);
	}
	/**
	 * 查询用户的订单信息
	 * @return
	 */
	@RequestMapping(value="/selUserOrder")
	public ModelAndView selUserOrder(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//查询用户订单
		List list = consumerService.selectUserOrderList(userId);
		reqMap.put("list", list);
		return new ModelAndView("/admin/consumer/iframe/userOrder",reqMap);
	}
	/**
	 * 查询用户积分及明细
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/selUserAccountJF")
	public ModelAndView selUserAccountJF(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//查询用户积分
		Map integral = consumerService.selectJF(userId);
		reqMap.put("accountJF", integral.get("accountJF")+"");
		//查询积分记录
		List list = consumerService.selectJFlog(userId);
		reqMap.put("list", list);
		return new ModelAndView("/admin/consumer/iframe/integral",reqMap);
	}
	
	/**
	 * 查询用户余额
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/selBalance")
	public ModelAndView selBalance(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//查询余额
		Map balance = consumerService.selBalance(userId);
		reqMap.put("account", balance);
		//查询消费记录
		List list = consumerService.selAccountLog(userId);
		reqMap.put("list", list);
		return new ModelAndView("/admin/consumer/iframe/balance",reqMap);
	}
	/**
	 * 查询用户问答
	 * @return
	 */
	@RequestMapping(value="/interlocution")
	public ModelAndView interlocution(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//用户类型
		String userType = consumerService.selectUserType(userId);
		reqMap.put("userType", userType);
		//查询我的提问记录
		List questioner = consumerService.selectInterlocutionList(userId);
		reqMap.put("list", questioner);
		//查问提问我的记录
		List MyList = consumerService.selectQuestionList(userId);
		reqMap.put("list2", MyList);
		return new ModelAndView("/admin/consumer/iframe/question",reqMap);
	}
	/**
	 * 查询用户旁听记录
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/attend")
	public ModelAndView attend(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//用户类型
		String userType = consumerService.selectUserType(userId);
		reqMap.put("userType", userType);
		//查询我得旁听
		List Myaudit = consumerService.selMyaudit(userId);
		reqMap.put("Myaudit", Myaudit);
		//查询旁听我得
		List list = consumerService.selAuditMy(userId);
		reqMap.put("list2", list);
		return new ModelAndView("/admin/consumer/iframe/attend",reqMap);
	}
	/**
	 * 查询用户的打赏记录
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/selReward")
	public ModelAndView selReward(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//查询共打赏多少钱
		double sumMoney = consumerService.selSumMoney(userId);
		reqMap.put("sumMoney", sumMoney);
		//查询打赏记录
		List list = consumerService.findByUserRewardLog(userId);
		reqMap.put("list", list);
		return new ModelAndView("/admin/consumer/iframe/rewardlog",reqMap);
	}
	/**
	 * 查询用户评论列表
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/comment")
	public ModelAndView comment(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = request.getParameter("userId");
		//查询评论列表
		List list = consumerService.selectCommenUser(userId);
		reqMap.put("list", list);
		return new ModelAndView("/admin/consumer/iframe/comment",reqMap);
	}
	
	/**
	 * 注册专家
	 * @return
	 */
	@RequestMapping("expertRegister")
	public ModelAndView expertRegister(){
		Map<String,Object> reqMap = new HashMap<String,Object>();
		return new ModelAndView("/admin/consumer/expertRegister",reqMap);
	}
	
	/**
	 * 通过用户id查询订单列表
	 * @return
	 */
	@RequestMapping("userOrderByUserId")
	public ModelAndView userOrderByUserId(@RequestParam Map<String,Object> map){
		return new ModelAndView("/admin/consumer/userOrderList",map);
	}
	
	@RequestMapping(value = "/selUserOrderList")
	@ResponseBody
	public Map<String,Object> selUserOrderList(Integer page, Integer limit, String userId , String openId) {
		Map<String, Object> result = new HashMap<String, Object>();
		result = consumerService.selOrderListAdmin(userId, openId, -1, page, limit);
		return result;
	}
	
	@RequestMapping(value = "/selUserAddressList")
	@ResponseBody
	public Map<String,Object> selUserAddressList(@RequestParam Map<String,Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		result = consumerService.selOrderAddressAdmin(map);
		return result;
	}
	
	/**
	 * 注册专家 去保存
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/expertRegisterToSave")
	@ResponseBody
	public Map<String, Object> expertRegisterToSave(@RequestParam Map map){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String telenumber = map.get("telenumber").toString();
		String password = map.get("password").toString();
		if(StringUtils.isEmpty(telenumber)){
			resultMap.put("result", 0);
			resultMap.put("msg", "请输入手机号");
			return resultMap;
		}
		if(StringUtils.isEmpty(password)){
			resultMap.put("result", 0);
			resultMap.put("msg", "请输入密码");
			return resultMap;
		}
		boolean flag = isChinaPhoneLegal(telenumber);
		if(!flag){
			resultMap.put("result", 0);
			resultMap.put("msg", "手机号码有误");
			return resultMap;
		}
		password = Tools.md5(password);
		map.put("userPwd", password);
		map.put("userType", 2);
		map.put("remark", "系统后台-专家注册");
		map.put("approve", 1);//认证审核通过
		map.put("isAdmin", 0);//是否后台管理员1代表后台管理员
		resultMap = consumerService.expertRegisterToSave(map);
		return resultMap;
	}
	
	//判断手机号
	public  boolean isChinaPhoneLegal(String phoneNum){
		 String regExp = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"; 
		 
	     Pattern p = Pattern.compile(regExp);
	     Matcher m = p.matcher(phoneNum);  
	     return m.matches();  
	}
}
