//package cn.template.content;
//
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//import javax.servlet.http.HttpServletRequest;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.servlet.ModelAndView;
//
//import cn.pxp2p.home.service.HomeHeaderService;
//import cn.pxp2p.home.service.HomeNavigatService;
//import cn.pxp2p.util.PhoneService;
//import cn.template.ITemplate;
//import cn.template.Template;
//import cn.template.Template.TemplateType;
//import cn.util.Page;
//
//@Template(name="新闻列表页",type=TemplateType.List)
//public class NewsListTemplateview implements ITemplate{
//	@Autowired
//	HomeNavigatService homeNavigatService;
//	@Autowired
//	PhoneService phoneService;
//	@Autowired
//	HomeHeaderService homeHeaderService;
//
//	@Override
//	public ModelAndView invoke(HttpServletRequest request) {
//		boolean isphone = phoneService.JudgeIsMoblie(request);
//		Map<String, Object> map = new HashMap<String, Object>();
//		Map<String, Object> searchInfo=new HashMap<String, Object>();
//		int catId = Integer.valueOf(request.getAttribute("columnid").toString());//网页新闻内容所属菜单的ID
//		searchInfo.put("catId", catId);
//		map.putAll(homeHeaderService.commonsModel(catId));//头部尾部共用参数信息
//		Page page=null;
//		int pageNow=1;
//		String yehao=request.getParameter("yehao");
//		if(yehao!=null){
//			pageNow=Integer.parseInt(yehao);
//		}
//		if(pageNow<=0){
//			pageNow=1;
//		}
//		int pageSize=10;
//		long totalCount = homeNavigatService.getTotalCount(searchInfo);//得到新闻总条数
//		//取得总页数
//		int zong = (int)(totalCount / pageSize )+(totalCount % pageSize > 0 ? 1: 0);
//		if(pageNow>zong){
//			pageNow = zong;
//		}
//		page = new Page(totalCount, pageNow, pageSize);
//		searchInfo.put("start", page.getStartPos());
//		searchInfo.put("pageSize", pageSize);
//		map.put("page", page);
//		map.put("zong", zong);
//		List<Map<String, Object>> list = homeNavigatService.selectContentListByCatid(searchInfo);//查询某菜单下所有的新闻列表数据
//		List<Map<String, Object>> list2 = homeNavigatService.selectChildrenByCatId(catId);//查询新闻列表、详情页面的菜单栏
//		List<Map<String, Object>> navCats = homeNavigatService.selectNavCats(catId);
//		map.put("navCats", navCats);
//		map.put("list", list);
//		map.put("list2", list2);
//		map.put("catId",catId);
//		map.put("catName",request.getAttribute("catName").toString());
//		if(isphone){
//			return new ModelAndView("/phone/column/list",map);
//		}else{
//			return new ModelAndView("/home/web/navigat/list",map);
//		}
//	}
//}
