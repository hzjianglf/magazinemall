package cn.admin.system.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.system.model.Contract;
import cn.admin.system.service.ContractService;
import cn.util.Page;

@Controller
@RequestMapping("/admin/system/contract")
public class ContractController {
	@Autowired
	ContractService contractService;
	@Autowired
	HttpSession session;

	/**
	 * 跳转合同管理列表页面
	 * 
	 * @return
	 */
	@RequestMapping("list")
	// @Authorize(setting = "合同-合同管理")
	public ModelAndView contractPage() {
		return new ModelAndView("/admin/system/contract/list");
	}

	/**
	 * 查询合同列表
	 * 
	 * @param request
	 * @param draw
	 * @param start
	 * @param pageSize
	 * @return
	 */
	@RequestMapping("getContractList")
	@ResponseBody
	public Map<String, Object> getContractList(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> parMap = new HashMap<String, Object>();
		String title = request.getParameter("title");
		parMap.put("title", title);
		long totalCount = contractService.getCount(parMap);
		Page pages = new Page(totalCount, page, limit);
		parMap.put("start", pages.getStartPos());
		parMap.put("pageSize", limit);
		List<Contract> list = contractService.getContractList(parMap);
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", totalCount);
		map.put("data", list);
		return map;
	}

	/**
	 * 跳转添加合同页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/add")
	// @Authorize(setting = "合同-合同添加")
	public ModelAndView addContract() {
		return new ModelAndView("/admin/system/contract/addContract");
	}

	/**
	 * 保存合同信息
	 * 
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/saveContract")
	@ResponseBody
	public Map<String, Object> saveContract(Contract contract, HttpServletRequest request) {
		Object userId = session.getAttribute("userId");
		int inputerid = Integer.parseInt(userId.toString());
		String content = request.getParameter("editorValue");// 获取编辑器内容
		contract.setInputerid(inputerid);
		contract.setContent(content);
		int row = 0;
		String msgPrefix = "添加";
		if (contract.getId() != null) {
			row = contractService.updateContractSelective(contract);
			msgPrefix = "修改";
		} else {
			row = contractService.addContract(contract);
		}
		Map<String, Object> result = new HashMap<>();
		if (row > 0) {
			result.put("success", true);
			result.put("msg", msgPrefix + "成功");
		} else {
			result.put("success", false);
			result.put("msg", msgPrefix + "失败");
		}
		return result;
	}

	/**
	 * 跳转合同修改页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/getContractInfo")
	// @Authorize(setting = "合同-合同修改")
	public ModelAndView getContractInfo(Integer id) {
		Map<String, Object> map = new HashMap<String, Object>();
		Contract contract = contractService.selectContractById(id);
		map.put("contract", contract);
		return new ModelAndView("/admin/system/contract/addContract", map);
	}

	/**
	 * 删除合同(改为删除状态不真实删除数据)
	 * 
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "delContract")
	@ResponseBody
	// @Authorize(setting = "合同-合同删除")
	public Map<String, Object> delContract(int id) {
		Map<String, Object> map = new HashMap<String, Object>();
		int row = contractService.deleteContract(id);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "删除成功!");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败!");
		}
		return map;
	}

	@RequestMapping(value = "modifyStatus")
	@ResponseBody
	// @Authorize(setting = "合同-合同禁用,合同-合同启用", type = AuthorizeType.ONE)
	public Map<String, Object> modifyStatus(@RequestParam Map<String, Object> param) {
		Map<String, Object> map = new HashMap<String, Object>();
		int row = contractService.modifyStatus(param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功!");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败!");
		}
		return map;
	}

}