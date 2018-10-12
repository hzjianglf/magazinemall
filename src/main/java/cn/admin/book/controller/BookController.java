package cn.admin.book.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.HtmlUtils;

import cn.admin.book.service.BookService;
import cn.admin.dictionary.service.LabelsService;
import cn.admin.periodical.service.PeriodicalService;
import cn.admin.publishingplan.service.PublishingplanService;
import cn.api.service.PathService;
import cn.core.Authorize;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;

@Controller
@RequestMapping(value = "/admin/book")
public class BookController {

		@Autowired
		BookService bookService;
		@Autowired
		PublishingplanService publishingplanService;
		@Autowired
		PeriodicalService periodicalService;
		@Autowired
		LabelsService labelsService;
		@Autowired
		private PathService pathService;
		
		//图书期刊跳转
		@RequestMapping(value = "/list")
		@Authorize(setting = "商品-图书期刊")
		public ModelAndView list(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("perId", request.getParameter("id"));
			
			//获取期刊类型
			List<Map<String, Object>>periodList=bookService.getPeriodicalList();
			//获取年份
			List<String>years=bookService.getYears();
			
			map.put("periodList", periodList);
			map.put("years", years);
			
			return new ModelAndView("/admin/book/list",map);
		}
		
		//获取图书期刊数据
		@RequestMapping(value = "/listData")
		@ResponseBody
		public Map<String, Object> adminlistData(@RequestParam Map<String, Object> request, int page, int limit) {
			Map<String, Object> result = new HashMap<String, Object>();
			
			long totalCount = bookService.getbookCount(request);// 得到总条数
			Page page2 = new Page(totalCount, page, limit);
			request.put("start", page2.getStartPos());
			request.put("pageSize", limit);
			List<Map<String, Object>> list = bookService.getbookList(request);
			result.put("msg", "");
			result.put("code", 0);
			result.put("data", list);
			result.put("count", totalCount);
			return result;
		}

		//获取电子图书期刊数据
		@RequestMapping(value = "/ebookListData")
		@ResponseBody
		public Map<String, Object> ebookListData(@RequestParam Map<String, Object> request, int page, int limit) {
			Map<String, Object> result = new HashMap<String, Object>();
			long totalCount = bookService.getebookCount(request);// 得到总条数
			Page page2 = new Page(totalCount, page, limit);
			request.put("start", page2.getStartPos());
			request.put("pageSize", limit);
			List<Map<String, Object>> list = bookService.getebookList(request);
			result.put("msg", "");
			result.put("code", 0);
			result.put("data", list);
			result.put("count", totalCount);
			return result;
		}
		//修改电子书的状态（启用，禁用）
		@RequestMapping(value = "/upBookStatus")
		@ResponseBody
		public Map<String,Object> upBookStatus(@RequestParam Map<String,Object> map){
			map.put("mag", "修改失败");
			map.put("result", false);
			long count= bookService.upPubByIdToStatus(map);
			if(count>0){
				map.put("msg", "修改成功");
				map.put("result", true);
			}
			return map;
		}
		//修改文章的状态（启用，禁用）
		@RequestMapping(value="/updDocIDByID")
		@ResponseBody
		public Map<String,Object> updDocIDByID(@RequestParam Map<String,Object> map){
			map.put("mag", "修改失败");
			map.put("result", false);
			long count= bookService.updStatusByID(map);
			if(count>0){
				map.put("msg", "修改成功");
				map.put("result", true);
			}
			return map;
		}
		//删除文章
		@RequestMapping(value="/delDocIDByID")
		@ResponseBody
		public Map<String,Object> delDocIDByID(@RequestParam Map<String,Object> map){
			map.put("mag", "删除失败");
			map.put("result", false);
			long count= bookService.delStatusByID(map);
			if(count>0){
				map.put("msg", "删除成功");
				map.put("result", true);
			}
			return map;
		}
		@RequestMapping(value = "/turnebookContent")
		public ModelAndView turnebookContent(HttpServletRequest request) {
			String id = request.getParameter("id");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("id", id);
			return new ModelAndView("/admin/book/ebookDetail",map);
		}
		@RequestMapping(value = "/ebookContent")
		@ResponseBody
		public Map<String, Object> ebookContent(@RequestParam Map<String,Object> map) {
			List list = bookService.getDocById(map);
			map.put("data", list);
			map.put("msg", "");
			map.put("code", 0);
			return map;
		}
		@RequestMapping(value = "/turneditDoc")
		public ModelAndView editDoc(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			String id = request.getParameter("id");
			map = bookService.selDocById(Integer.parseInt(id));
			List<Map<String,Object>> list = new ArrayList<Map<String, Object>>();
			if(map.get("PublicationID")!=null){
				list = bookService.selCategoryAllName(map);
				List publishlist = bookService.selAllEbook();
				map.put("publishlist", publishlist);
				if(list.size()>0){
					//添加所有的板块信息
					map.put("Category", list);
				}
			}if(map.get("CatID")!=null){
				list = bookService.selColumnsAllName(map);
				if(list.size()>0){
					//添加所有的栏目信息
					map.put("Columns", list);
				}
			}
			pathService.getAbsolutePath(map, "MainText");
			//List list = bookService.selCatList(id);
			//List clist = bookService.selCouList(id);
			//map.put("list", list);
			return new ModelAndView("/admin/book/doc",map);
		}
		//查找期次
		@RequestMapping(value="selEbookdoc")
		@ResponseBody
		public Map<String,Object> selEbookdoc(@RequestParam Map<String,Object> map){
			List<Map<String,Object>> list = new ArrayList<Map<String, Object>>();
			if(map.get("publishId")!=null){
				map.put("publishId", DataConvert.ToString(map.get("publishId")));
				list = bookService.selCategoryAllName(map);
				if(list.size()>0){
					//添加所有的栏目信息
					map.put("Category", list);
				}
			}else{
				map.put("Category", null);
			}
			return map;
		}
		//级联板块和栏目
		@RequestMapping(value="categoryAsColumnID")
		@ResponseBody
		public Map<String,Object> categoryAsColumnID(@RequestParam Map<String,Object> map){
			List<Map<String,Object>> list = new ArrayList<Map<String, Object>>();
			if(map.get("CategoryID")!=null){
				map.put("CatID", DataConvert.ToString(map.get("CategoryID")));
				list = bookService.selColumnsAllName(map);
				if(list.size()>0){
					//添加所有的栏目信息
					map.put("Columns", list);
				}
			}else{
				map.put("Columns", null);
			}
			return map;
		}
		
		@RequestMapping(value="/previewDoc")
		public ModelAndView previewDoc(HttpServletRequest request){
			Map<String,Object> map =new HashMap<String,Object>();
			String id = request.getParameter("id");
			map = bookService.selDocById(Integer.parseInt(id));
			pathService.getAbsolutePath(map, "MainText");
			return new ModelAndView("/admin/book/previewDoc",map);
		}
		@RequestMapping(value = "/updDoc")
		@ResponseBody
		public Map<String, Object> updDoc(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			if(param.get("ColumnID")==null||DataConvert.ToInteger(param.get("ColumnID"))==0){
				param.put("ColumnID", "0");
			}
			return bookService.updDoc(param);
		}
		/**
		 * 弹出图书期刊添加页面
		 * 
		 * @return
		 */
		@RequestMapping(value = "/add")
		public ModelAndView addUrls(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			Map<String, Object> m = new HashMap<String, Object>();
			String id = request.getParameter("id");
			
			if(!StringHelper.IsNullOrEmpty(id)) {
				//通过id查询期刊内容
				m = bookService.selOne(id);
				String describes = HtmlUtils.htmlUnescape(m.get("describes")+"");
				m.put("describes", describes);
			}
			
			if(m==null||m.isEmpty()){//添加
				//查询期刊列表
				List<Map<String,Object>> list = bookService.selPerList();
				map.put("type", "add");
				map.put("list", list);
				//书刊杂志下的分类
				List fenlei = bookService.selectMagazineType(5);
				map.put("fenlei", fenlei);
				return new ModelAndView("/admin/book/addColumn",map);
			}else{
				map.put("type", "edit");
				
				Map<String, Object> yearMap = new HashMap<String,Object>();
				yearMap.put("period", m.get("period"));
				
				List<Map<String, Object>>tempList=bookService.getLogisticsTemplateList();
				
				map.put("tempList", tempList);
				
				//获取刊物的出版年份列表
				List<String>years=bookService.getYearsForPer(map);
				map.put("yearList", years);
				map.put("selYear", m.get("year"));
				map.put("perId", DataConvert.ToString(m.get("preId")));
				
				Map<String, Object> issMap = new HashMap<String,Object>();
				issMap.put("preId", DataConvert.ToString(m.get("preId")));
				issMap.put("period", DataConvert.ToString(m.get("period")));
				issMap.put("year", m.get("year"));
				List<Map<String,Object>> period = bookService.selPeriod(issMap);//查询出版期次
				map.put("periodList", period);
				map.put("contentMap", m);
				List labelList = labelsService.findLabelBytype("图书");
				map.put("labelList", labelList);
				 Double toDouble = DataConvert.ToDouble(m.get("ebookPrice"));
				if(toDouble>0) {
					map.put("ebook", 1);
				}
			}
			//添加分享地址
			String sharedAddress = pathService.getAbsolutePath("sharedAddress");
			map.put("sharedAddress", sharedAddress);
			
			return new ModelAndView("/admin/book/details",map);
		}
		/**
		 * 图书期刊填写详细页面
		 * 
		 * @return
		 */
		@RequestMapping(value = "/details")
		public ModelAndView addXq(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			String perId = request.getParameter("perId");
			map.put("perId", perId);
			String defaultYear="";
			//获取刊物的出版年份列表
			List<String>years=bookService.getYearsForPer(map);
			if(years!=null&&!years.isEmpty()) {
				map.put("yearList", years);
				//获取默认查询的年份
				defaultYear=Calendar.getInstance().get(Calendar.YEAR)+"";
				if(!years.contains(defaultYear)) {
					defaultYear=years.get(0);
				}
				map.put("selYear", defaultYear);
			}
			
			List<Map<String, Object>>tempList=bookService.getLogisticsTemplateList();
			
			map.put("tempList", tempList);
			
			Map<String, Object> issMap = new HashMap<String,Object>();
			issMap.put("preId", perId);
			issMap.put("year", defaultYear);
			List<Map<String,Object>> period = bookService.selPeriod(issMap);//查询出版期次
			
			map.put("periodList", period);
			map.put("perName", request.getParameter("name"));
			map.put("protype", request.getParameter("protype"));
			
			//查询标签
			List labelList = labelsService.findLabelBytype("图书");
			map.put("labelList", labelList);
			return new ModelAndView("/admin/book/details",map);
		}
		
		/**
		 * 图书期刊添加图片页面
		 * 
		 * @return
		 */
		@RequestMapping(value = "/imgs")
		//@Authorize(setting = "用户-管理员添加")
		public ModelAndView imgs(HttpServletRequest request) {
			Map<String, Object> map = new HashMap<String, Object>();
			String id = request.getParameter("id");
			map.put("id", id);
			//查询商品图片
			List<String> delList=new ArrayList<String>();
			String pictureUrl = bookService.selPictureUrl(id);
			String[] strs=pictureUrl.split(",");
			for(String str:strs){
				delList.add(str);
			}
			map.put("delList", delList);
			return new ModelAndView("/admin/book/imgs",map);
		}
		
		@RequestMapping(value = "/uploadImg")
		@ResponseBody
		public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
			// 上传图片
			String SiteLogo = "";
			// 上传的图片保存路径
			String filePath = Tools.getUploadDir("Advertisement");
			String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");// 获取路径
			if (files.isEmpty()) {
				SiteLogo = "";
			} else {
				String newFileName = files.getOriginalFilename();// 获取图片名称
				String newFilePath = filePath + newFileName;// 新路径
				File newFile = new File(newFilePath);
				if (newFile.exists()) {
					String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddhhmmssSSS"));
					newFileName = time + "_" + files.getOriginalFilename();
					newFilePath = filePath + newFileName;
					newFile = new File(newFilePath);
				}
				try {
					files.transferTo(newFile);
				} catch (Exception e) {
					e.printStackTrace();
				}
				SiteLogo = "/" + pathSub + newFileName;// 保存到数据库的路径
			}
			return "{\"data\": \"" + SiteLogo + "\"}";
		}
		//批量上传
		@RequestMapping(value = "/uploadImgs")
		@ResponseBody
		public Map<String,Object> uploadImgs(@RequestParam("imgUrl") MultipartFile files) {

			Map<String,Object> map = new HashMap<String, Object>();
			// 上传图片
			String SiteLogo = "";
			// 上传的图片保存路径
			String filePath = Tools.getUploadDir("Advertisement");
			String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");// 获取路径
				if (files.isEmpty()) {
					SiteLogo = "";
				} else {
					String newFileName = files.getOriginalFilename();// 获取图片名称
					String newFilePath = filePath + newFileName;// 新路径
					File newFile = new File(newFilePath);
					if (newFile.exists()) {
						String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddhhmmssSSS"));
						newFileName = time + "_" + files.getOriginalFilename();
						newFilePath = filePath + newFileName;
						newFile = new File(newFilePath);
					}
					try {
						files.transferTo(newFile);
					} catch (Exception e) {
						e.printStackTrace();
					}
					SiteLogo += "/" + pathSub + newFileName;// 保存到数据库的路径
					String[] name=newFileName.split("\\.");
					map.put("name", name[0]);
//					if(i<files.length-1){
//						SiteLogo += ",";
//					}
					
				}
				map.put("data", SiteLogo);
			return map;
		}
		//添加图书期刊
		@RequestMapping(value = "/adds")
		public @ResponseBody Map<String, Object> adds(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return bookService.adds(param);
		}
		
		@RequestMapping(value="/pic")
		public ModelAndView picList(@RequestParam Map<String, Object> param) throws Exception {
			
			int id=DataConvert.ToInteger(param.get("id"));
			if(id<=0) {
				throw new Exception("参数错误");
			}
			
			//查询商品图片
			List<String> delList=new ArrayList<String>();
			String pictureUrl =bookService.selPictureUrl(id+"");
			if(!StringHelper.IsNullOrEmpty(pictureUrl)){
				String[] strs=pictureUrl.split(",");
				for(String str:strs){
					delList.add(str);
				}
			}
			param.put("delList", delList);
			return new ModelAndView("/admin/book/imgs",param);
			
		}
		
		//修改图书期刊
		@RequestMapping(value = "/ups")
		@ResponseBody
		public Map<String, Object> ups(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return bookService.ups(param);
		}
		//添加图书期刊商品图片
		@RequestMapping(value = "/upPictureUrl")
		@ResponseBody
		public Map<String,Object> upPictureUrl(@RequestParam Map<String, Object> param, HttpServletRequest request) {
			return bookService.upPictureUrl(param);
		}
		
		//删除图书期刊
		@RequestMapping(value = "/deleteBook")
		@ResponseBody
		public Map<String, Object> deleteBook(@RequestParam String id, HttpServletRequest request) {
			return bookService.deleteBook(id);
		}
		//图书期刊上架下架
		@RequestMapping(value = "/upState")
		@ResponseBody
		public Map<String, Object> upState(@RequestParam Map<String, Object> param,HttpServletRequest request) {
			return bookService.upState(param);
		}
		
		/**
		 * 查询期次
		 * @param type
		 * @return
		 */
		@RequestMapping(value="/selectIssue")
		@ResponseBody
		public Map<String, Object> selectIssue(@RequestParam Map<String, Object> map){
			String type=DataConvert.ToString(map.get("type"));
			Map<String, Object> maps = new HashMap<String, Object>();
			List<Map<String,Object>> period = new ArrayList<Map<String,Object>>();
			if("1".equals(type)){
				map.remove("type");
				//所有
				period = bookService.selectPeriodlist(map);//查询出版期次
			}else{
				//部分
				period = bookService.selectPeriodlist(map);//查询出版期次
			}
			maps.put("list", period);
			return maps;
		}
		
		/**
		 * 查询当前期次下是否有电子书
		 * @param map
		 * @return
		 */
		@RequestMapping(value="/selectEbook")
		@ResponseBody
		public Map<String, Object> selectEbook(@RequestParam Map<String,Object> map){
			Map<String, Object> reqMap = new HashMap<String, Object>();
			List list=bookService.selectIsEbook(map);
			if(list.size() > 0){
				reqMap.put("success", true);
			}else{
				reqMap.put("success", false);
			}
			return reqMap;
		}
		
		/**
		 * 查询对应刊物、年份、合集类型 有无电子书
		 * @param map
		 * @return
		 */
		@RequestMapping(value="/selectEbookForSum")
		@ResponseBody
		public Map<String, Object> selectEbookForSum(@RequestParam Map<String,Object> map){
			Map<String, Object> reqMap = new HashMap<String, Object>();
			reqMap.put("success", false);
			
			int perId=DataConvert.ToInteger(map.get("perId"));
			int type=DataConvert.ToInteger(map.get("type"));
			String  year=DataConvert.ToString(map.get("year"));
			
			if(perId<=0||type<=0||StringHelper.IsNullOrEmpty(year)) {
				return reqMap;
			}
			
			//获取合集类型对应的期次Id列表
			List<Integer>list=bookService.getPeriodList(perId,type,year);
			
			if(list==null||list.isEmpty()) {
				return reqMap;
			}
			map.put("list", list);
			long count=bookService.getEbookCountForSum(map);
			if(count > 0){
				reqMap.put("success", true);
			}
			return reqMap;
		}
	}
