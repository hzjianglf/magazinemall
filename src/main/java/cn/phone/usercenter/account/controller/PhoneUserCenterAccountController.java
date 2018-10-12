package cn.phone.usercenter.account.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.SMS.SmsService;
import cn.api.service.AccountService;
import cn.api.service.OrderService;
import cn.api.service.SettingService;
import cn.api.service.TeacherService;
import cn.core.UserValidate;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.RegexUntil;
import cn.util.StringHelper;
import cn.util.Tools;

/**
 * 用户个人信息
 *
 */
@UserValidate
@Controller
@RequestMapping("/phone/usercenter/account")
public class PhoneUserCenterAccountController {

	@Autowired
	HttpSession session;
	@Autowired
	AccountService accountService;
	@Autowired
	OrderService orderService;
	@Autowired
	TeacherService teacherService;
	@Autowired
	SmsService smsService;

	public Integer getUserId() {
		return DataConvert.ToInteger(session.getAttribute("userId") + "");
	}

	/**
	 * 个人中心
	 * 
	 * @return
	 */
	@RequestMapping(value = "/index")
	public ModelAndView index() {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId = getUserId() + "";
		reqMap = accountService.selectUserMsg(userId);
		reqMap.put("userId", userId);
		return new ModelAndView("/phone/usercenter/index", reqMap);
	}

	// 跳转设置页面
	@RequestMapping("turnUserSet")
	public ModelAndView turnUserSet(Integer ids, HttpServletRequest request, HttpServletResponse response) {
		if (null == ids) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("userType", session.getAttribute("userType") + "");
			map.put("footer", false);
			return new ModelAndView("/phone/usercenter/userSet", map);
		}
		return new ModelAndView("redirect:/phone/order/turnJieSuan?shoppingIds=" + ids);
	}

	// 跳转我的地址页面
	@RequestMapping("turnMyAddress")
	@ResponseBody
	public ModelAndView turnMydress(Integer ids) {
		int userId = getUserId();
		Map<String, Object> map = new HashMap<String, Object>();
		List list = accountService.selAddressList(userId);
		map.put("list", list);
		map.put("footer", false);
		map.put("ids", ids);
		return new ModelAndView("/phone/usercenter/mydress", map);
	}
	
	// 跳转到选择地址页面
	@RequestMapping("toChoiceAddress")
	public ModelAndView toChoiceAddress(@RequestParam Map<String,Object> map) {
		Integer userId = getUserId();
		
		if(userId==null||userId==0) {
			return new ModelAndView("/phone/usercenter/account/index");
		}
		
		List list = accountService.selAddressList(userId);
		map.put("list", list);
		map.put("footer", false);
		
		return new ModelAndView("/phone/usercenter/choiceAddress",map);
		
	}

	// 删除地址
	@RequestMapping("delAddress")
	@ResponseBody
	public Map<String, Object> delAddress(Integer id) {
		Map<String, Object> map = new HashMap<String, Object>();
		int userId = getUserId();
		map.put("success", 1);
		boolean flag = accountService.DeleteAddress(id, userId);
		if (flag) {
			map.put("msg", "删除成功");
			return map;
		}
		map.put("success", 0);
		map.put("msg", "删除失败");
		return map;
	}

	// 修改默认地址
	@RequestMapping("changeAddressDefault")
	@ResponseBody
	public Map<String, Object> changeAddress(Integer id) {
		Map<String, Object> map = new HashMap<String, Object>();
		int userId = getUserId();
		map.put("type", 1);
		map.put("Id", id);
		map.put("userId", userId);
		int count = accountService.updDefaultAddress(map);
		if (count > 0) {
			map.put("msg", "修改成功");
			return map;
		}
		map.put("msg", "修改失败");
		return map;
	}

	// 跳转编辑和添加地址页面
	@RequestMapping("turnAddAddress")
	public ModelAndView turnAddAddress(Integer id) {
		int userId = getUserId();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("footer", false);
		if (null == id) {
			return new ModelAndView("/phone/usercenter/addAddress", map);
		}
		map.put("Id", id);
		map.put("userId", userId);
		Map data = accountService.selAddressDetail(map);
		map.put("data", data);
		return new ModelAndView("/phone/usercenter/addAddress", data);
	}

	// 保存和修改地址
	@RequestMapping("saveAddress")
	@ResponseBody
	public Map<String, Object> saveAddress(@RequestParam Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("userType", 1);
		result.put("msg", "操作失败");
		try {
			if (null == (map.get("Id") + "") || (map.get("Id") + "").equals("")) {
				map.put("isDefault", 0);
				List list = accountService.selAddressList(getUserId());
				if(list.size()<1) {
					map.put("isDefault", 1);
				}
				int count = accountService.addAddress(map);
				if (count > 0) {
					result.put("msg", "保存成功");
					return result;
				}
			}
			int index = accountService.updateAddress(map);
			if (index > 0) {
				result.put("msg", "保存成功");
				return result;
			}
		} catch (Exception e) {
			result.put("msg", "操作失败" + e.getMessage());
		}
		return result;
	}

	/**
	 * 我的提问
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myquestions")
	public ModelAndView myquestions() {
		Map<String, Object> map = new HashMap<String, Object>();
		String userId = session.getAttribute("userId") + "";
		// 查询用户的userType
		String userType = accountService.selectUserType(userId);
		map.put("userType", userType);
		map.put("footer", false);
		return new ModelAndView("/phone/usercenter/questions/list", map);
	}

	/**
	 * 获取提问部分视图
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myQuizData")
	public ModelAndView myQuizData(Integer page, Integer pageSize, Integer state) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", session.getAttribute("userId") + "");
		map.put("type", state);
		// 查询count
		long count = accountService.getInterlocutionCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		// 列表
		List list = accountService.getInterlocutionList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("questionType", state);
		return new ModelAndView("/phone/usercenter/questions/part/section", reqMap);
	}

	/**
	 * 个人中心，旁听列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myaudit")
	public ModelAndView myaudit() {
		Map<String, Object> map = new HashMap<String, Object>();
		String userId = session.getAttribute("userId") + "";
		// 查询用户的userType
		String userType = accountService.selectUserType(userId);
		map.put("userType", userType);
		map.put("footer", false);
		return new ModelAndView("/phone/usercenter/audit/list", map);
	}

	/**
	 * 获取旁听部分视图
	 * 
	 * @param page
	 * @param pageSize
	 * @param state
	 * @return
	 */
	@RequestMapping(value = "/myAudit")
	public ModelAndView myAudit(Integer page, Integer pageSize, Integer state) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("type", state);
		// 查询count
		long count = accountService.getMyAuditListCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		// 列表
		List list = accountService.getMyAuditList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		return new ModelAndView("/phone/usercenter/audit/part/partlist", reqMap);
	}

	/**
	 * 打赏记录
	 * 
	 * @return
	 */
	@RequestMapping(value="/rewardLog")
	public ModelAndView rewardLog(String userId){
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isEmpty(userId)||"null".equals(userId)) {
			userId=session.getAttribute("userId")+"";
		}
		//查询用户的userType
		String userType = accountService.selectUserType(userId);
		map.put("userId", userId);
		map.put("userType", userType);
		map.put("footer", false);
		return new ModelAndView("/phone/usercenter/rewardlog/list", map);
	}

	/**
	 * 获取打赏记录列表的部分视图
	 * 
	 * @param page
	 * @param pageSize
	 * @param state
	 * @return
	 */
	@RequestMapping(value="/RewardlogData")
	public ModelAndView RewardlogData(Integer page,Integer pageSize,Integer state,String userId){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("type", state);
		// 查询count
		long count = accountService.selRewardLogcount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		// 列表
		List list = accountService.selRewardLoglist(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("state", state);
		return new ModelAndView("/phone/usercenter/rewardlog/part/partlist", reqMap);
	}

	/**
	 * 我的订单列表
	 */
	@RequestMapping(value = "/getMyOrderlist")
	public ModelAndView getMyOrderlist() {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int userId = DataConvert.ToInteger(session.getAttribute("userId"));
		reqMap.put("footer", false);
		reqMap.put("userId", userId);
		return new ModelAndView("/phone/usercenter/order/list", reqMap);
	}

	@RequestMapping(value = "/selectPartOrder")
	public ModelAndView selectPartOrder(Integer page, Integer pageSize, Integer orderstatus) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int userId = DataConvert.ToInteger(session.getAttribute("userId"));
		reqMap = orderService.selOrderList(userId, orderstatus, page, pageSize);
		reqMap.put("footer", false);
		return new ModelAndView("/phone/usercenter/order/partorder", reqMap);
	}

	/**
	 * 订单详情
	 */
	@RequestMapping(value = "/orderDetail")
	public ModelAndView orderDetail(Integer orderId, String status) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		// 查询订单详情
		int userId = DataConvert.ToInteger(session.getAttribute("userId"));
		reqMap = orderService.selectOrderDetail(userId, orderId);
		reqMap.put("status", status);
		reqMap.put("footer", false);
		return new ModelAndView("/phone/usercenter/order/detail", reqMap);
	}

	/**
	 * 关注
	 */
	@RequestMapping(value = "/followlist")
	public ModelAndView followlist() {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("footer", false);
		return new ModelAndView("/phone/usercenter/follow/list", reqMap);
	}

	// 关注部分视图
	@RequestMapping(value = "/myfollow")
	public ModelAndView myfollow(Integer state, Integer page, Integer pageSize) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", getUserId());
		map.put("type", state);
		// 查询count
		long count = accountService.selectFollowCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		// 列表
		List list = accountService.selectFollowList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		reqMap.put("state", state);
		reqMap.put("type", state);
		return new ModelAndView("/phone/usercenter/follow/partlist",reqMap);
	}

	/**
	 * 个人资料编辑
	 * 
	 * @return
	 */
	@RequestMapping(value = "/userMsg")
	public ModelAndView userMsg() {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		// 用户id
		int userId = getUserId();
		reqMap = accountService.selUserBasic(userId);
		reqMap.put("footer", false);
		return new ModelAndView("/phone/usercenter/usermsg/basic", reqMap);
	}

	/**
	 * 个人资料编辑保存
	 * 
	 * @param map
	 * @return
	 */
	@RequestMapping(value = "/saveUserMsg")
	@ResponseBody
	public Map<String, Object> saveUserMsg(@RequestParam Map map) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int userId = getUserId();
		map.put("userId", userId);
		reqMap = accountService.updateUserBasic(map);
		return reqMap;
	}

	/**
	 * 专栏作家下的销售记录
	 * 
	 * @return
	 */
	@RequestMapping(value = "/MySaleLog")
	public ModelAndView MySaleLog() {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("footer", false);
		return new ModelAndView("/phone/usercenter/teacher/salelog/list", reqMap);
	}

	@RequestMapping(value = "/MySaleLogData")
	public ModelAndView MySaleLogData(Integer page, Integer pageSize) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", getUserId());
		// 查询count
		long count = teacherService.selectMySalelogCount(map);
		Page pages = new Page(count, page, pageSize);
		map.put("start", pages.getStartPos());
		map.put("pageSize", pageSize);
		// 列表
		List list = teacherService.selectMySalelogList(map);
		reqMap.put("list", list);
		reqMap.put("pageTotal", pages.getTotalPageCount());
		reqMap.put("count", count);
		return new ModelAndView("/phone/usercenter/teacher/salelog/part/partlist", reqMap);
	}

	/**
	 * @author LiTonghui
	 * @title 修改订单状态
	 * 
	 * 
	 */
	@RequestMapping(value = "/updOrderStatus")
	@ResponseBody
	public Map<String,Object> updOrderStatus(@RequestParam Map<String,Object> map) {
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", false);
		result.put("msg", "操作失败！");
		
		Integer userId = getUserId();
		
		if(userId==0||userId==null) {
			return result;
		}
		
		result.put("userId", userId);
		result.put("orderId", DataConvert.ToString(map.get("orderId")));
		result.put("orderstatus", DataConvert.ToString(map.get("orderstatus")));
		
		int row = orderService.sureReceived(result);
		
		if (row > 0) {
			result.put("result", true);
			result.put("msg", "操作成功！");
		}
		
		return result;
	}

	/**
	 * @author LiTonghui
	 * @title 删除订单
	 * 
	 */
	@RequestMapping(value = "/delOrder")
	@ResponseBody
	public Map delOrder(@RequestParam("userId") int userId, @RequestParam("orderId") int orderId) {
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("orderId", orderId);
		int row = orderService.delUserOrder(map);
		if (row > 0) {
			result.put("result", 1);
			result.put("msg", "删除成功！");
		} else {
			result.put("result", 0);
			result.put("msg", "删除失败！");
		}
		return result;
	}

	/**
	 * @author WangYueLei
	 * @param status
	 * @param orderId
	 * @return
	 */
	@RequestMapping(value = "/toDetail")
	public ModelAndView toDetail(String orderId) {
		Map map = new HashMap();
		map.put("footer", false);
		map.put("orderId", orderId);
		return new ModelAndView("phone/usercenter/order/orderDetail", map);
	}

	@RequestMapping(value = "oDetail")
	@ResponseBody
	public ModelAndView oDetail(Integer orderId, Integer type) {
		Integer userid = (Integer) session.getAttribute("userId");
		Map map = new HashMap();
		map.put("orderId", orderId);
		map.put("type", type);
		map.put("data", orderService.getInvoiceList(userid, orderId, type - 1));
		return new ModelAndView("phone/usercenter/order/orderDetailList", map);
	}

	@RequestMapping(value = "invoiceList")
	public ModelAndView invoiceList(Integer orderId, Integer type , Integer invoiceId) {
		Integer userid = (Integer) session.getAttribute("userId");
		Map map = new HashMap();
		map.put("orderId", orderId);
		map.put("invoiceId", invoiceId);
		map.put("data", orderService.getInvoiceList(userid, orderId, type - 1));
		return new ModelAndView("phone/usercenter/order/invoiceList", map);
	}

	@RequestMapping(value = "upOStatus")
	@ResponseBody
	public Map<String,Object> upOStatus(int orderId, String invoiceId) {
		Integer userId = (Integer) session.getAttribute("userId");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("orderId", orderId);
		map = orderService.orderConfirm(userId, invoiceId, orderId);
		return map;
	}

	/**
	 * @author LiTonghui
	 * @title 从订单列表里付款
	 * 
	 */
	// @RequestMapping(value="/payForOrder")
	// public ModelAndView payForOrder(){
	// return new ModelAndView("")
	// }

	// 跳转手机绑定页面
	@RequestMapping("turnMyphone")
	@ResponseBody
	public ModelAndView turnMyphone() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("footer", false);
		return new ModelAndView("/phone/usercenter/phone/rebindphone", map);
	}

	/**
	 * 修改手机号
	 * 
	 * @return
	 */

	@RequestMapping(value = "/updatePhone")
	@ResponseBody
	public Map<String, Object> updatePhone(@RequestParam Map<String, Object> map, HttpServletRequest request) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", DataConvert.ToInteger(session.getAttribute("userId")));

		String code = DataConvert.ToString(map.get("Tbx_Code"));
		if (StringHelper.IsNullOrEmpty(code)) {
			reqMap.put("msg", "请输入短信验证码");
			return reqMap;
		}
		// 验证短信
		boolean validCode = smsService.Verify(DataConvert.ToString(map.get("oldPhone")), code, request);
		if (!validCode) {
			reqMap.put("msg", "短信验证码错误！");
			return reqMap;
		}

		// 修改手机号
		map.put("telenumber", map.get("newPhone") + "");
		int row = accountService.updatePhone(map);
		if (row > 0) {
			reqMap.put("success", true);
			reqMap.put("msg", "修改成功!");
		} else {
			reqMap.put("success", false);
			reqMap.put("msg", "修改失败!");
		}
		return reqMap;
	}

	@RequestMapping("/sendSms")
	public @ResponseBody Map<String, Object> sendSMS(int type, String telenumber, HttpServletRequest request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", false);
		result.put("msg", "发送失败！");

		try {

			if (!RegexUntil.isMobileNum(telenumber)) {
				result.put("msg", "手机号格式错误！");
				return result;
			}

			String smsTemplateKey = "";
			switch (type) {
			case 0:
				smsTemplateKey = "快捷登录";
				break;
			case 1:
				smsTemplateKey = "用户注册";
				break;
			case 2:
				smsTemplateKey = "密码找回";
				break;
			}

			if (StringHelper.IsNullOrEmpty(smsTemplateKey)) {
				return result;
			}

			boolean flag = smsService.send(smsTemplateKey, 90, telenumber, request);
			if (flag) {
				result.put("result", true);
				result.put("msg", "发送成功！");
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("msg", "发送失败！");

		}
		return result;
	}

}
