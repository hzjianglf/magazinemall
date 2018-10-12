package cn.admin.system.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.system.service.UserService;
import cn.core.Authorize;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;

@Controller
@RequestMapping("/admin/system/user")
public class UserController {
	@Autowired
	UserService userService;

	/**
	 * 跳转用户管理列表页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/adminlist")
	@Authorize(setting = "用户-管理员管理")
	public ModelAndView adminList(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String userType = request.getParameter("userType");
		map.put("role", userService.selRoleByIdentify2(userType));
		map.put("userType", userType);
		return new ModelAndView("/admin/system/user/adminlist", map);
	}
	
	/**
	 * 跳转会员管理列表页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/memberList")
	@Authorize(setting = "用户-会员管理")
	public ModelAndView memberList(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String userType = request.getParameter("userType");
		map.put("role", userService.selRoleByIdentify2(userType));
		map.put("userType", userType);
		return new ModelAndView("/admin/system/user/adminlist",map);
	}
	
	/**
	 * 跳转业务员管理列表页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saleManList")
	@Authorize(setting = "用户-业务员管理")
	public ModelAndView saleManList(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String userType = request.getParameter("userType");
		map.put("role", userService.selRoleByIdentify2(userType));
		map.put("userType", userType);
		return new ModelAndView("/admin/system/user/adminlist",map);
	}

	/**
	 * 获取用户列表数据
	 * 
	 * @param request
	 * @param page		当前页
	 * @param limit		页大小
	 */
	@RequestMapping(value = "/adminlistData")
	@ResponseBody
	public Map<String, Object> adminlistData(HttpServletRequest request,int page,int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> maps = new HashMap<String, Object>();
		String userType = request.getParameter("userType");
		maps.put("userType", userType);
		String userName = request.getParameter("userName");
		String roleName = request.getParameter("roleName");
		maps.put("userName", userName);
		maps.put("roleName", roleName);
		//计算起始值
		long totalCount = userService.getTotalCount2(maps);
		Page p = new Page(totalCount, page, limit);
		maps.put("start", p.getStartPos());
		maps.put("pageSize", limit);
		List<Map<String, Object>> list = userService.selectAdminUser(maps);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}

	/**
	 * 弹出用户添加页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/adds")
	//@Authorize(setting = "用户-管理员添加")
	public ModelAndView addUrls(HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		String userType = request.getParameter("userType");
		map.put("role", userService.selRoleByIdentify2(userType));
		map.put("_op", "add");
		map.put("userType", userType);
		return new ModelAndView("/admin/system/user/userInfo", map);
	}

	/**
	 * 添加用户
	 */
	@RequestMapping("/addAdmin")
	@ResponseBody
	public Map<String, Object> addAdmin(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> list = new ArrayList<String>();
		int count = userService.selByName(param);
		if (count > 0) {
			map.put("success", false);
			map.put("msg", "该用户名已存在！");
			return map;
		}
		count = userService.selByPhone(param);
		if (count > 0) {
			map.put("success", false);
			map.put("msg", "该手机号已存在！");
			return map;
		}
		String userPwd1 = param.get("userPwd") + "";
		if (!StringUtils.isEmpty(userPwd1)) {
			String userPwd = Tools.md5(userPwd1);
			param.put("userPwd", userPwd);
		}
		/*String[] roleid = request.getParameterValues("roleId");
		for (String str : roleid) {
			list.add(str);
		}*/
		String roleid = request.getParameter("roleId");
		list = Arrays.asList(roleid.split(","));
		String birthDate = param.get("birthDate") + "";
		if (StringUtils.isEmpty(birthDate)) {
			param.put("birthDate", null);
		}
		param.put("roleId", list);
		int row = userService.addAdminUserInfo(param);
		//int ro = userService.addUserRole(param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "添加成功！");
		} else {
			map.put("success", false);
			map.put("msg", "添加失败！");
		}
		return map;
	}

	/**
	 * 弹出用户修改页面
	 * 
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/adminUpdate")
	//@Authorize(setting = "用户-管理员修改")
	public ModelAndView adminUpdate(HttpServletRequest request) {
		// 通过ID查询单个会员
		String userId = request.getParameter("userId");
		String userType = request.getParameter("userType");
		Map<String, Object> map = new HashMap<String, Object>();
		//根据用户类型查找用户下的对应角色
		map.put("role", userService.selRoleByIdentify2(userType));
		Map<String, Object> userMap = userService.selectUserInfoById(userId);
		map.put("userMap", userMap);
		map.put("_op", "update");
		return new ModelAndView("/admin/system/user/userInfo", map);
	}

	/**
	 * 修改用户信息
	 * 
	 * @param param
	 * @param request
	 * @return
	 */
	@RequestMapping("/editAdminUser")
	@ResponseBody
	public Map<String, Object> editAdminUser(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<String> list = new ArrayList<String>();
		String userPwd1 = param.get("userPwd") + "";
		if (!StringUtils.isEmpty(userPwd1)) {
			String userPwd = Tools.md5(userPwd1);
			param.put("userPwd", userPwd);
		}
		String roleid = request.getParameter("roleId");
		list = Arrays.asList(roleid.split(","));
		String birthDate = param.get("birthDate") + "";
		if (StringUtils.isEmpty(birthDate)) {
			param.put("birthDate", null);
		}
		param.put("roleId", list);
		//int row = userService.updateUser(param);
		int ro = userService.addUserRoles(param);
		if (ro > 0) {
			map.put("success", true);
			map.put("msg", "修改成功！");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败！");
		}
		return map;
	}

	/**
	 * 单个或批量删除后台用户
	 * 
	 * @param userId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/delAdminUser")
	//@Authorize(setting = "用户-管理员删除")
	public Map<String, Object> delAdminUser(@RequestParam("userId") String userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> parMap = new HashMap<String, Object>();
		String[] userIds = userId.split(",");
		parMap.put("userId", userIds);
		int row = userService.deleteUser(parMap);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "删除成功！");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败！");
		}
		return map;
	}

	/**
	 * 单个或批量冻结用户
	 * 
	 * @param userId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/lockAdminUser")
	//@Authorize(setting = "用户-管理员冻结")
	public Map<String, Object> lockAdminUser(@RequestParam("userId") String userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> parMap = new HashMap<String, Object>();
		String[] userIds = userId.split(",");
		parMap.put("userId", userIds);
		int row = userService.lockUser(parMap);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "冻结成功！");
		} else {
			map.put("success", false);
			map.put("msg", "冻结失败！");
		}
		return map;
	}

	/**
	 * 单个或批量解冻用户
	 * 
	 * @param userId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/unlockAdminUser")
	//@Authorize(setting = "用户-管理员解冻")
	public Map<String, Object> unlockAdminUser(@RequestParam("userId") String userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> parMap = new HashMap<String, Object>();
		String[] userIds = userId.split(",");
		parMap.put("userId", userIds);
		int row = userService.unlockUser(parMap);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "解冻成功！");
		} else {
			map.put("success", false);
			map.put("msg", "解冻失败！");
		}
		return map;
	}
	
	/**
	 * 查询 专家信息
	 * @param request
	 * @param page
	 * @param limit
	 * @return
	 */
	@RequestMapping(value="/selectTeachersFromAdver")
	@ResponseBody
	public Map<String, Object> selectTeachersFromAdver(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		//商品类型
		String strs = request.getParameter("strs");
		String name = request.getParameter("name");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		List<Integer> list2 = StringHelper.ToIntegerList(strs);
		reqMap.put("list", list2);
		reqMap.put("name", name);
		long count = userService.selectTeachersFromAdverCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = userService.selTeachersFromAdver(reqMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	

}
