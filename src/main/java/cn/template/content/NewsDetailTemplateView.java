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
//@Template(name="新闻详情页",type=TemplateType.Detail)
//public class NewsDetailTemplateView implements ITemplate {
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
//		String contentId = request.getAttribute("contentId").toString();
//		map.putAll(homeHeaderService.commonsModel(catId));//头部尾部共用参数信息
//		Map<String, Object> contentMap = homeNavigatService.selectContentById(Integer.parseInt(contentId));//获取新闻内容信息
//		List<Map<String, Object>> list2=homeNavigatService.selectChildrenByCatId(catId);//查询新闻列表、详情页面的菜单栏
//		List<Map<String, Object>> navCats=homeNavigatService.selectNavCats(catId);//查询栏目名称
//		map.put("navCats", navCats);
//		map.put("list2", list2);
//		map.put("contentMap", contentMap);
//		map.put("catId", catId);
//		homeNavigatService.addHits(contentId);//更新内容点击数
//		if(isphone){
//			return new ModelAndView("/phone/column/details",map);
//		}else{
//			return new ModelAndView("/home/web/navigat/details",map);
//		}
//	}
//
//}
