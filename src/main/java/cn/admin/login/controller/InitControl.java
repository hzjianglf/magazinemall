package cn.admin.login.controller;

import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import cn.util.DataConvert;

import com.alibaba.druid.util.StringUtils;
import cn.Setting.Setting;
import cn.AdminRewriteFilter;
import cn.Setting.Model.SiteInfo;
import cn.admin.login.service.InitService;
import cn.util.TreeNode;

@Controller
@RequestMapping("/admin")
public class InitControl {

	@Autowired
	InitService initService;
	@Autowired
	HttpSession session;
	@Autowired
	Setting setting;

	private boolean hasAuthorize(String chk, List<String> auth) {
		if (StringUtils.isEmpty(chk)) {
			return true;
		}
		
		//是系统默认添加的超级管理员
		int userType=DataConvert.ToInteger(session.getAttribute("userType"),1);
		if(userType==0){
			return true;
		}
		if(auth==null||auth.isEmpty()){
			return false;
		}
		List<String> actionList=new ArrayList<String>();
		if(chk.contains(",")){
			String[] arr=chk.split(",");
			for (String str : arr) {
				if(!actionList.contains(str)){
					actionList.add(str);
				}
			}
		}else{
			actionList.add(chk);
		}
		for (String action : actionList) {
			for(String s:auth){
				if (s.equals(action)) {
					return true;
				}
			}
		}
		return false;
	}

	private TreeNode buildNode(Map<String, Object> m, List<Map<String, Object>> all, List<String> auth) {
		boolean isLeaf = (boolean) m.get("isInTree");
		if (isLeaf) {
			if (m.get("AuthorityDescription") != null
					&& !hasAuthorize(m.get("AuthorityDescription").toString(), auth)) {
				return null;
			}
		}
		TreeNode node = new TreeNode();
		node.setTreeName(m.get("AuthorityType").toString());
		node.setId(m.get("AuthorityID").toString());

		if (!isLeaf) {
			List<TreeNode> childs = buildNode(m.get("AuthorityID").toString(), all, auth);
			if (childs == null || childs.size() == 0) {
				return null;
			} else {
				node.setChList(childs);
			}
		} else {
			if (m.get("icoUrl") != null) {
				node.setIcon(m.get("icoUrl").toString());
			}
			if (m.get("moduleUrl") != null) {
				node.setUrl(m.get("moduleUrl").toString());
			}

		}

		return node;
	}

	private List<TreeNode> buildNode(String parentId, List<Map<String, Object>> all, List<String> auth) {
		List<TreeNode> nodes = new ArrayList<TreeNode>();
		if (StringUtils.isEmpty(parentId)) {
			for (Map<String, Object> m : all) {
				if (m.get("parentModuleID") == null || m.get("parentModuleID").toString().equals("0")) {
					TreeNode node = buildNode(m, all, auth);
					if (node != null) {
						nodes.add(node);
					}

				}
			}
		} else {
			for (Map<String, Object> m : all) {
				if (m.get("parentModuleID") != null && m.get("parentModuleID").toString().equals(parentId)) {
					TreeNode node = buildNode(m, all, auth);
					if (node != null) {
						nodes.add(node);
					}
				}
			}
		}

		return nodes;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/index")
	public ModelAndView index(String moduleName) {
		Map<String, Object> map = new HashMap<String, Object>();
		Object menu = session.getAttribute("menu");

		List<TreeNode> nodes = null;

		if (menu == null) {
			// 获取用户权限列表
			List<String> allAuthorityForUser = (List<String>) session.getAttribute("AuthorityID");
			List<Map<String, Object>> allAuthority = initService.selectAllAuthority();
			nodes = buildNode("", allAuthority, allAuthorityForUser);
			session.setAttribute("menu", nodes);
		} else {
			nodes = (List<TreeNode>) session.getAttribute("menu");
		}

		map.put("treenodes", nodes);
		if (!StringUtils.isEmpty(moduleName)) {
			for (TreeNode node : nodes) {
				if (node.getTreeName().equals(moduleName)) {
					map.put("erList", node.getChList());
					map.put("url", "/" + AdminRewriteFilter.adminPrefix + "/" + node.getChList().get(0).getChList().get(0).getUrl());
					break;
				}
			}
		} else {
			map.put("erList", nodes.get(0).getChList());
			map.put("url", "/" + AdminRewriteFilter.adminPrefix + "/shouye");
		}
		map.put("moduleName", moduleName);
		map.put("username", session.getAttribute("adminRealName"));

		//获取网站标题
		SiteInfo siteInfo = setting.getSetting(SiteInfo.class, null);
		map.put("title", siteInfo.getSiteTitle());
		return new ModelAndView("/admin/index", map);
	}

	@RequestMapping("/shouye")
	public ModelAndView hy() throws UnknownHostException {
		return new ModelAndView("/admin/login/shouye");
	}

}
