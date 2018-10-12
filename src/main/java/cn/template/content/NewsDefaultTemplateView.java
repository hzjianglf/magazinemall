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
//
//
//@Template(name="单页",type=TemplateType.Default)
//public class NewsDefaultTemplateView implements ITemplate {
//	@Autowired
//	HomeNavigatService homeNavigatService;
//	@Autowired
//	HomeHeaderService homeHeaderService;
//	@Autowired
//	PhoneService phoneService;
//
//	@Override
//	public ModelAndView invoke(HttpServletRequest request) {
//		boolean isphone = phoneService.JudgeIsMoblie(request);
//		Map<String, Object> map = new HashMap<String, Object>();
//		int catId = Integer.valueOf(request.getAttribute("columnid").toString());
//		map.putAll(homeHeaderService.commonsModel(catId));//头部尾部共用参数信息
//		Map<String, Object> contentMap = homeNavigatService.selectContentByCatId(catId);//获取新闻内容信息
//		List<Map<String, Object>> list2=homeNavigatService.selectChildrenByCatId(catId);//查询新闻列表、详情页面的菜单栏
//		List<Map<String, Object>> navCats=homeNavigatService.selectNavCats(catId);//查询栏目名称
//		map.put("navCats", navCats);
//		map.put("list2", list2);
//		map.put("contentMap", contentMap);
//		map.put("catId", catId);
//		map.put("catName",request.getAttribute("catName").toString());
//		homeNavigatService.addHits(contentMap.get("contentId").toString());//更新内容点击数
//		if(isphone){
//			return new ModelAndView("/phone/column/aboutUsDetail",map);
//		}
//		return new ModelAndView("/home/web/navigat/aboutUsDetail",map);
//	}
//
//}
