package cn.admin.marketing.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
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

import com.alibaba.druid.util.StringUtils;

import cn.admin.marketing.service.VoucherService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;
//代金券
@Controller
@RequestMapping("/admin/voucher")
public class VoucherController {
	@Autowired
	private VoucherService voucherService;
	@Autowired
	HttpSession session;
	
	@RequestMapping(value="/list")
	@Authorize(setting="代金券-查看列表")
	public ModelAndView turnList(){
		Map<String,Object> map = new HashMap<String, Object>();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		Date now = new Date();
		String nowTime = df.format(now);
		map.put("nowTime", nowTime);
		return new ModelAndView("/admin/marketing/voucher/list",map);
	}
	//代金列表数据
	@RequestMapping(value="/voucherList")
	@ResponseBody
	public Map couponListData(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		long totalCount = voucherService.selTotalCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map<String, Object>> list = voucherService.selVoucherList(search);//商品、直播、点播
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	//添加代金券
	@RequestMapping(value="/turnVoucher")
	public ModelAndView turnVoucher(HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");
		String voucherId = request.getParameter("voucherId");
		Map data = new HashMap();
		if(!StringUtils.isEmpty(voucherId)){
			data = voucherService.selDetail(voucherId);
		}
		map.put("type", type);
		map.put("data", data);
		return new ModelAndView("/admin/marketing/voucher/newAdd",map);
	}
	//期刊/点播/直播/专家搜索页面
	@RequestMapping(value="/getAllGoods")
	public ModelAndView getAllGoods(@RequestParam("type") int type,@RequestParam("searchText") String searchText){//1期刊 2点播 3直播 4专家
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("searchText", searchText);
		String jspName = "qikan";
		if(type==2){
			jspName = "qikan";
		}else if(type==3){
			jspName = "dianbo";
		}else if(type==4){
			jspName = "zhibo";
		}else{
			jspName = "zhuanjia";
		}
		return new ModelAndView("/admin/marketing/voucher/searchFace/"+jspName,map);
	}
	
	//添加/修改 代金券
	@RequestMapping(value="/addVoucher")
	@ResponseBody
	public Map addVoucher(HttpServletRequest request,@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		String userName = session.getAttribute("adminRealName")+"";
		String userId = session.getAttribute("userId")+"";
		map.put("userName", userName);
		map.put("userId", userId);
		int row = 0;
		String type = map.get("type")+"";
		if(type.equals("1")){
			row = voucherService.addVoucher(map);
		}else if(type.equals("2")){
			row = voucherService.updVoucher(map);
		}
		if(row>0){
			result.put("result", true);
			result.put("msg", "操作成功！");
		}else{
			result.put("result", false);
			result.put("msg", "操作失败！");
		}
		return result;
	}
	//删除代金券
	@RequestMapping(value="/delVoucherById")
	@ResponseBody
	public Map delVoucherById(@RequestParam("voucherId") int voucherId) {
		Map<String,Object> result = new HashMap<String, Object>();
		int row = voucherService.delVoucherById(voucherId);
		if(row>0){
			result.put("result", true);
			result.put("msg", "删除成功！");
		}else{
			result.put("result", false);
			result.put("msg", "删除失败！");
		}
		return result;
	}
	//代金券发放页面
	@RequestMapping(value="/grantVoucherFace")
	public ModelAndView grantVoucherFace(@RequestParam("voucherId") int voucherId){
		Map<String,Object> map = new HashMap<String, Object>();
		int voucherCount = voucherService.selVoucherCount(voucherId);//查询该优惠券剩余的数量
		map.put("voucherId", voucherId);
		map.put("voucherCount", voucherCount);
		return new ModelAndView("/admin/marketing/voucher/grantList",map);
	}
	//代金券可发放的用户列表
	@RequestMapping(value="/userinfoList")
	@ResponseBody
	public Map userinfoList(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		String voucherId = request.getParameter("voucherId");
		search.put("voucherId", voucherId);
		long totalCount = voucherService.selUserTotalCount(search);//总条数
		Page pages = new Page(totalCount, page, limit);
		search.put("start", pages.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = voucherService.selUserInfo(search);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
	//发放代金券
	@RequestMapping(value="/grantVoucher")
	@ResponseBody
	public Map grantVoucher(HttpServletRequest request,@RequestParam Map map){
		Map<String,Object> result = new HashMap<String, Object>();
		//发放代金券。并且修改代金券剩余数量
		int totalCount = voucherService.selVoucherCount(DataConvert.ToInteger(map.get("voucherId")));
		String[] userId = map.get("userIds").toString().split(",");
		if(userId.length>totalCount){
			result.put("result", false);
			result.put("msg", "库存不足");
			return result;
		}
		int row = voucherService.grantVoucher(map);
 		if(row>0){
 			result.put("result", true);
 			result.put("msg", "发放成功！");
 		}else{
 			result.put("result", false);
 			result.put("msg", "发放失败！");
 		}
		return result;
	}
	//启用禁用
	@RequestMapping("changeStateById")
	@ResponseBody
	public Map<String,Object> changeStateById(Integer type,Integer voucherId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("type", type);
		map.put("voucherId", voucherId);
		return voucherService.changeStateById(map);
	}
	//已发代金券列表
	@RequestMapping(value="/alreadyGrant")
	public ModelAndView alreadyGrant(HttpServletRequest request){
		Map<String,Object> map = new HashMap<String, Object>();
		String type = request.getParameter("type");
		String voucherId = request.getParameter("voucherId");
		map.put("type", type);
		map.put("voucherId", voucherId);
		return new ModelAndView("/admin/marketing/voucher/alreadyGrant",map);
	}
	//已发代金券数据列表
	@RequestMapping(value="/alreadyGrantList")
	@ResponseBody
	public Map alreadyGrantList(HttpServletRequest request,@RequestParam Map search, int page, int limit){
		Map<String,Object> map = new HashMap<String, Object>();
		String voucherId = request.getParameter("voucherId");
		String type = request.getParameter("type");
		search.put("voucherId", voucherId);
		search.put("type", type);
		long totalCount = voucherService.alreadyGrantCount(search);//总条数
		Page page2 = new Page(totalCount, page, limit);
		search.put("start", page2.getStartPos());
		search.put("pageSize", limit);
		List<Map> list = voucherService.selAlreadyGrantList(search);
		map.put("msg", "");
		map.put("code", 0);
		map.put("data", list);
		map.put("count", totalCount);
		return map;
	}
}
