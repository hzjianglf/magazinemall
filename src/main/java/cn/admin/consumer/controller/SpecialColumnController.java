package cn.admin.consumer.controller;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import cn.core.Authorize;
import cn.util.ExcelUntil;
import cn.util.Page;
import cn.util.Tools;

@Controller
@RequestMapping(value="/admin/specialColumn")
public class SpecialColumnController {

	
	@Autowired
	SpecialColumnService writerService;
	
	
	
	
	/**
	 * 专栏申请
	 * @return
	 */
	@RequestMapping(value="/list")
	@Authorize(setting="用户-专栏申请")
	public ModelAndView list(){
		return new ModelAndView("/admin/consumer/approve/list");
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String,Object> listData(HttpServletRequest request, int page, int limit){
		Map<String, Object> map = new HashMap<String, Object>();
		String approve = request.getParameter("approve");
		String name = request.getParameter("name");
		String isFreeze = request.getParameter("isFreeze");
		String registrationDate = request.getParameter("registrationDate");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if(StringUtils.isEmpty(approve)){
			reqMap.put("approve", 0);
		}else{
			reqMap.put("approve", approve);
		}
		reqMap.put("name", name);
		reqMap.put("isFreeze", isFreeze);
		if(Tools.isNotEmpty(registrationDate)){
			String[] split = registrationDate.split(" - ");
			String regBeginTime = split[0];
			String regEndTime = split[1];
			reqMap.put("regBeginTime", regBeginTime);
			reqMap.put("regEndTime", regEndTime);
		}
		long count = writerService.selConsumerCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = writerService.selConsumerList(reqMap);
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
		int row = writerService.deletes(map);
		if(row > 0){
			reqMap.put("success", true);
		}else{
			reqMap.put("success", false);
		}
		return reqMap;
	}
	/**
	 * 查询基本信息
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/selConsumer")
	public ModelAndView selConsumer(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//基本信息
		Map<String, Object> userMap = writerService.selectUserInfoById(map.get("userId")+"");
		reqMap.put("userMap", userMap);
		//查询专家信息
		Map<String, Object> writerMsg = writerService.selectWriterMsg(map);
		reqMap.put("writerMsg", writerMsg);
		return new ModelAndView("/admin/consumer/approve/basicMsg",reqMap);
	}
	//导出
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
		List<Map> list = writerService.selectDownload(map);
		for (Map map2 : list) {
			//用户类型
			if("1".equals(map2.get("approve")+"")){
				map2.put("approve", "审核通过");
			}else if("0".equals(map2.get("approve")+"")){
				map2.put("approve", "未审核");
			}else{
				map2.put("approve", "审核驳回");
			}
		}
		String[] excelHeader={"昵称","手机号","性别","出生年份","积分","余额(元)","注册时间","状态"};
		String[] mapKey={"nickName","telenumber","sex","birthDate","accountJF","balance","registrationDate","approve"};
	    ExcelUntil.excelToFile(list,excelHeader,mapKey,response,"专栏申请列表");
	}
	
	
}
