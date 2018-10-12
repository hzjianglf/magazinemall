package cn.admin.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.system.service.RoleService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.core.AuthorizeSettingLoader;
import cn.util.Page;

/**
 * 用户角色类
 * 
 * 
 */
@Controller
@RequestMapping("/admin/system/role")
public class RoleController {
	@Autowired
	RoleService roleService;

	/**
	 * 跳转管理员角色管理页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/adminList")
	@Authorize(setting = "角色-角色管理")
	public ModelAndView adminList(HttpServletRequest request) {
//		Map<String,Object> map = new HashMap<String, Object>();
//		String identify = request.getParameter("identify");
//		map.put("identify", identify);
		return new ModelAndView("/admin/system/role/rolelist");
	}

	/**
	 * 获取角色列表数据
	 * 
	 * @param request
	 * @param page	当前页
	 * @param limit	页大小
	 */
	@RequestMapping(value = "/list/dataTable")
	@ResponseBody
	public Object listDataTable(HttpServletRequest request,int page,int limit) {
		Map<String, Object> searchInfo = new HashMap<String, Object>();
//		String identify = request.getParameter("identify");
//		searchInfo.put("identify", identify);
		//计算起始值
		long totalCount = roleService.getTotalCount(searchInfo);
		Page p = new Page(totalCount, page, limit);
		searchInfo.put("start", p.getStartPos());
		searchInfo.put("pageSize", limit);
		List<Map<String, Object>> list = roleService.selectRoleByQuery(searchInfo);
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("msg", "");
		result.put("code", 0);
		result.put("data", list);
		result.put("count", totalCount);
		return result;
	}

	/**
	 * 修改、添加、 角色权限 的判断（业务逻辑处理方法）
	 * 
	 * @param request
	 * @return
	 * @throws JSONException
	 */
	@RequestMapping(value = "/roleInfo")
	//@Authorize(setting = "角色-修改角色,角色-添加角色,角色-角色权限", type = AuthorizeType.ONE)
	public ModelAndView rolelimit(HttpServletRequest request) throws JSONException {
		Map<String, Object> map = new HashMap<String, Object>();
		String _op = request.getParameter("_op");
		String roleId = request.getParameter("roleId");
		if ("add".equals(_op)) {// 角色增加 不需要传值
			map.put("_op", _op);
			return new ModelAndView("/admin/system/role/roleInfo", map);
		} else if ("update".equals(_op)) {// 角色修改 需要传值
			map = roleService.selectRoleById(roleId);// 根据roleid查询一条记录
			map.put("_op", _op);
			return new ModelAndView("/admin/system/role/roleInfo", map);
		} else if ("limits".equals(_op)) {// 角色权限
			List<Map<String, Object>> authorityList = new ArrayList<Map<String, Object>>();
			map.put("roleId", roleId);
			// 根据roleId查询此角色的权限
			List<Map<String, Object>> list = roleService.selAuthorityID(request.getParameter("roleId"));
			for (Map<String, Object> mm : list) {
				Map<String, Object> m = new HashMap<String, Object>();
				String AuthorityID = mm.get("AuthorityID") + "";
				AuthorityID = AuthorityID.substring(AuthorityID.lastIndexOf("-") + 1);
				m.put("AuthorityID", AuthorityID);
				authorityList.add(m);
			}
			map.put("authorityList", authorityList);
			// settings为权限配置列表
			Map<String, List<String>> settings = AuthorizeSettingLoader.get();
			map.put("settings", settings);
			return new ModelAndView("/admin/system/role/adminroleset", map);
		}
		return null;
	}

	/**
	 * 设置角色权限
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveRoleAuthority")
	@ResponseBody
	public Map<String, Object> saveRoleAuthority(HttpServletRequest request) {
		List<String> list = new ArrayList<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> param = new HashMap<String, Object>();
		String roleId = request.getParameter("roleId");
		String spCodesTemp = request.getParameter("spCodesTemp");
		String[] oldArray = spCodesTemp.split(",");
		for (String str : oldArray) {
			list.add(str);
		}
		param.put("AuthorityID", list);
		param.put("roleid", roleId);
		int row = roleService.addra(param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "设置成功");
		} else {
			map.put("success", false);
			map.put("msg", "设置失败");
		}
		return map;
	}

	/**
	 * 增加角色
	 * 
	 * @return
	 */
	@RequestMapping(value = "/roleAdd")
	@ResponseBody
	public Map<String, Object> roleAdd(@RequestParam Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		int row = roleService.add(map);
		if (row > 0) {
			result.put("success", true);
			result.put("msg", "添加成功");
		} else {
			result.put("success", false);
			result.put("msg", "添加失败");
		}
		return result;
	}

	/**
	 * 修改
	 * 
	 * @return
	 */
	@RequestMapping(value = "/roleUpdate")
	@ResponseBody
	public Map<String, Object> roleUpdate(@RequestParam Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		int row = roleService.update(map);
		if (row > 0) {
			result.put("success", true);
			result.put("msg", "修改成功");
		} else {
			result.put("success", false);
			result.put("msg", "修改失败");
		}
		return result;
	}

	/**
	 * 刪除
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/roleDelete")
	@ResponseBody
	//@Authorize(setting = "角色-删除角色")
	public Map<String, Object> operation(HttpServletRequest request) {
		Map<String, Object> msg = new HashMap<String, Object>();
		int row = 0;
		String roleid = request.getParameter("roleId");
		// 查看权限人员表是否有关联
		int count = roleService.selectUserRole(roleid);
		if (count > 0) {
			msg.put("success", false);
			msg.put("msg", "该角色下尚有人员，不可删除！！！");
			return msg;
		}
		row = roleService.delRole(roleid);
		if (row > 0) {
			msg.put("success", true);
			msg.put("msg", "删除成功");
		} else {
			msg.put("success", false);
			msg.put("msg", "删除失败");
		}
		return msg;
	}

}