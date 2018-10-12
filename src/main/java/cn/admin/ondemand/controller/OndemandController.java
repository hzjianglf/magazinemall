package cn.admin.ondemand.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.poi.hslf.usermodel.HSLFSlideShow;
import org.apache.poi.hslf.usermodel.HSLFTable;
import org.apache.poi.hslf.usermodel.HSLFTableCell;
import org.apache.poi.hslf.usermodel.HSLFTextShape;
import org.apache.poi.sl.usermodel.PictureData;
import org.apache.poi.sl.usermodel.Shape;
import org.apache.poi.sl.usermodel.Slide;
import org.apache.poi.sl.usermodel.SlideShow;
import org.apache.poi.xslf.usermodel.XMLSlideShow;
import org.apache.poi.xslf.usermodel.XSLFTable;
import org.apache.poi.xslf.usermodel.XSLFTableCell;
import org.apache.poi.xslf.usermodel.XSLFTextShape;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import cn.Vcloud.VcloudChannelService;
import cn.admin.dictionary.service.ClassTypeService;
import cn.admin.dictionary.service.LabelsService;
import cn.admin.ondemand.service.OndemandService;
import cn.admin.system.service.DictionaryService;
import cn.api.service.PathService;
import cn.core.Authorize;
import cn.core.Authorize.AuthorizeType;
import cn.emay.sdk.util.json.gson.JsonObject;
import cn.util.DataConvert;
import cn.util.Page;
import cn.util.PptToJpgUtil;
import cn.util.Tools;
import it.sauronsoftware.jave.Encoder;
import it.sauronsoftware.jave.MultimediaInfo;
import net.sf.json.JSONObject;

/**
 * 点播课程管理
 * @author BAO
 *
 */
@Controller
@RequestMapping(value="/admin/ondemand")
public class OndemandController {

	
	@Autowired
	OndemandService ondemandService;
	@Autowired
	HttpSession session;
	@Autowired
	DictionaryService dictService;
	@Autowired
	LabelsService labelsService;
	@Autowired
	ClassTypeService classTypeService;
	@Autowired
	VcloudChannelService vcloudChannelService;
	@Autowired
	private PathService pathServcie;
	@Autowired
	private PptToJpgUtil pptToJpgUtil;
	@RequestMapping(value="/list")
	@Authorize(setting="点播-点播课程列表,直播-直播课程列表",type=AuthorizeType.ONE)
	public ModelAndView list(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//课程类型
		String classtype = request.getParameter("classtype");
		reqMap.put("classtype", classtype);
		//查询课程分类数据字典项
		List type = classTypeService.selClassTypeByName(1);
		reqMap.put("typeList", type);
		return new ModelAndView("/admin/ondemand/list",reqMap);
	}
	@RequestMapping(value="/listData")
	@ResponseBody
	public Map<String, Object> listData(HttpServletRequest request, int page, int limit) {
		Map<String, Object> map = new HashMap<String, Object>();
		//课程类型
		String classtype = request.getParameter("classtype");
		String teacher = request.getParameter("teacher");
		String founder = request.getParameter("founder");
		String name = request.getParameter("name");
		String type = request.getParameter("type");
		String status = request.getParameter("status");
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("classtype", classtype);
		reqMap.put("teacher", teacher);
		reqMap.put("founder", founder);
		reqMap.put("name", name);
		reqMap.put("type", type);
		reqMap.put("status", status);
		long count = ondemandService.selOndemandCount(reqMap);
		Page pages = new Page(count, page, limit);
		reqMap.put("start", pages.getStartPos());
		reqMap.put("pageSize", limit);
		List<Map<String, Object>> list = ondemandService.selOndemandList(reqMap);
		for (Map<String, Object> map2 : list) {
			map2.put("founder", map2.get("founder")+""+"\n"+map2.get("creationTime"));
		}
		map.put("code", 0);
		map.put("msg", "");
		map.put("count", count);
		map.put("data", list);
		return map;
	}
	/**
	 * 修改状态
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/upStatus")
	@ResponseBody
	@Authorize(setting="点播-修改课程状态")
	public Map upStatus(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = ondemandService.updateStatus(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 删除点播课程
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/deletes")
	@ResponseBody
	@Authorize(setting="点播-删除点播课程")
	public Map Deletes(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = ondemandService.deleteOndemand(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 创建/编辑点播课程
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/insert")
	@Authorize(type=AuthorizeType.ONE,setting="点播-创建点播课程,点播-编辑点播课程")
	public ModelAndView InsertOrUpdate(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//课程类型
		String classtype = request.getParameter("classtype");
		reqMap.put("classtype", classtype);
		//查询课程分类数据字典项
		List type = classTypeService.selClassTypeByName(1);
		reqMap.put("typeList", type);
		//点播课程id
		String ondemandId = request.getParameter("ondemandId");
		reqMap.put("ondemandId", ondemandId);
		//当前选择的是第几项
		String page = request.getParameter("page");
		if(!StringUtils.isEmpty(ondemandId)){
			//查询点播课程信息
			Map findById = ondemandService.findById(ondemandId);
			List<String> imgUrls = null;
			try {
				if(findById.get("imgUrls") != null ) {
					findById.put("imgUrlsEl", findById.get("imgUrls").toString());
					imgUrls = new ObjectMapper().readValue(findById.get("imgUrls").toString(), ArrayList.class);
					List<String> lUrl = new ArrayList<String>();
					for (String imgUrl : imgUrls) {
						lUrl.add(pathServcie.getAbsolutePath(imgUrl));
					}
					findById.put("imgUrls", lUrl);
				}
			} catch (JsonParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JsonMappingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			reqMap.put("findById", findById);
			//查询已经勾选的教师
			Map tMsg = ondemandService.CheckTeacherMsg(ondemandId);
			reqMap.put("tMsg", tMsg);
		}
		//跳转的页面
		String html = "";
		if("1".equals(page)){
			//查询标签
			List labelList = labelsService.findLabelBytype("课程");
			reqMap.put("labelList", labelList);
			html = "/admin/ondemand/basic";
		}else if("2".equals(page)){
			html = "/admin/ondemand/detail";
		}else if("3".equals(page)){
			html = "/admin/ondemand/classPic";
		}else if("4".equals(page)){
			html = "/admin/ondemand/classHour";
		}else if("5".equals(page)){
			html = "/admin/ondemand/file";
		}else if("6".equals(page)){
			html = "/admin/ondemand/setprice";
		}else if("7".equals(page)){
			//查询所有的教师
			List teacher = ondemandService.selTeacherAll();
			reqMap.put("teacher", teacher);
			html = "/admin/ondemand/teacher";
		}
		String sharedAddress = pathServcie.getAbsolutePath("sharedAddress");
		reqMap.put("sharedAddress", sharedAddress);
		return new ModelAndView(html,reqMap);
	}
	/**
	 * 保存基本信息
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/addBasic")
	@ResponseBody
	@Authorize(setting="点播-保存课程信息")
	public Map addBasic(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", session.getAttribute("userId")+"");
		int row = 0;
		if(!StringUtils.isEmpty(map.get("ondemandId"))){
			reqMap.put("ondemandId", map.get("ondemandId")+"");
			row = ondemandService.updateMsg(map);
		}else{
			row = ondemandService.addBasic(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
			reqMap.put("ondemandId", map.get("ondemandId")+"");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 保存详细信息
	 */
	@RequestMapping(value="/upBasic")
	@ResponseBody
	@Authorize(setting="点播-修改课程信息")
	public Map upBasic(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		reqMap.put("ondemandId", map.get("ondemandId")+"");
		int row = ondemandService.updateBasic(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	//添加章节目录
	@RequestMapping(value="/addchapter")
	@Authorize(setting="点播-添加章节目录")
	public ModelAndView addchapter(HttpServletRequest request,@RequestParam Map<String,Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//获取添加类型名称
		String title = "";
		if("添加章".equals(map.get("title")+"")){
			title = "章";
		}else if("添加节".equals(map.get("title")+"")){
			title = "节";
			//判断是编辑还是添加
			if(!StringUtils.isEmpty(map.get("ondemandId"))){
				//添加
				//查询pid
				Map chapterId = ondemandService.selLastChapter(map);
				if(!StringUtils.isEmpty(chapterId)){
					reqMap.put("parentId", chapterId.get("chapterId")+"");
				}
			}
		}
		//课程id
		reqMap.put("ondemandId", map.get("ondemandId")+"");
		reqMap.put("title", title);
		//查询章节
		//章节id
		if(!"null".equals(map.get("chapterId")) && !StringUtils.isEmpty(map.get("chapterId")) && StringUtils.isEmpty(map.get("ondemandId"))){
			reqMap.put("chapterId", map.get("chapterId")+"");
			//查询章节信息
			Map msg = ondemandService.selChapterMsg(map.get("chapterId")+"");
			reqMap.put("msg", msg);
		}
		
		return new ModelAndView("/admin/ondemand/addchapter",reqMap);
	}
	/**
	 * 保存章节目录
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/insertChapter")
	@ResponseBody
	public Map<String, Object> savaChapter(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//通过parentId判断是章还是节
		if(StringUtils.isEmpty(map.get("parentId"))){
			map.put("parentId", 0);
		}
		//添加章节
		int row =  0;
		if(!"null".equals(map.get("chapterId")+"") && !StringUtils.isEmpty(map.get("chapterId"))){
			//编辑
			row = ondemandService.editChapter(map);
		}else{
			row = ondemandService.insertChapter(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 删除章节/课时目录
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/delChapter")
	@ResponseBody
	public Map<String, Object> delChapter(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = 0;
		if(StringUtils.isEmpty(map.get("hourId"))){
			//删除章节信息
			row = ondemandService.delChapter(map);
		}else{
			//删除课时信息
			row = ondemandService.delClassHour(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	/**
	 * 添加课时弹窗
	 * @param request
	 * @return
	 */
	@RequestMapping(value="/toaddclassHour")
	public ModelAndView toaddclassHour(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//课时类型
		String classtype = request.getParameter("classtype");
		reqMap.put("classtype", classtype);
		String ondemandId = request.getParameter("ondemandId");
		String parentId = request.getParameter("parentId");
		reqMap.put("parentId", parentId);
		reqMap.put("ondemandId", ondemandId);
		//判断是添加还是编辑
		if(!"null".equals(request.getParameter("kid")) && !StringUtils.isEmpty(request.getParameter("kid"))){
			//查询课时信息
			Map ma = ondemandService.findByKid(request.getParameter("kid"));
			reqMap.put("KsMsg", ma);
		}
		
		return new ModelAndView("/admin/ondemand/hour/toaddclassHour",reqMap);
	}
	//保存课时信息
	@RequestMapping(value="/addClassHour")
	@ResponseBody
	public Map<String, Object> addClassHour(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if("on".equals(map.get("IsAudition"))){
			map.put("IsAudition", "1");
		}else{
			map.put("IsAudition", "0");
		}
		if(StringUtils.isEmpty(map.get("minute"))){
			map.put("minute", 0);
		}
		if(StringUtils.isEmpty(map.get("second"))){
			map.put("second", 0);
		}
		//保存课时
		int row = 0;
		if(!StringUtils.isEmpty(map.get("hourId"))){
			//修改
			row = ondemandService.updateClassHour(map);
		}else{
			// 需要通过课程id判断当前课程是否是直播课程
			int classType = ondemandService.selOndemanType(map);
			if(classType==1) {
				// 先创建直播频道，直播频道创建成功才可以保存课时信息
				Map<String, Object> channel = vcloudChannelService.creatChannel(DataConvert.ToString(map.get("title")).replaceAll("\\s+", ""));
				if(DataConvert.ToBoolean(channel.get("result"))) {
					//设置频道录制状态
					vcloudChannelService.channelSetAlwaysRecord(DataConvert.ToString(channel.get("data")), 1);
					map.put("vcloudChannel", DataConvert.ToString(channel.get("data")));
				}else {
					reqMap.put("msg", DataConvert.ToString(channel.get("msg")));
					return reqMap;
				}
			}
			row = ondemandService.addClassHour(map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功！");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败！");
		}
		return reqMap;
	}
	//查询章节信息
	@RequestMapping(value="/selectTree")
	@ResponseBody
	public Map<String, Object> selectTree(HttpServletRequest request){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String ondemandId = request.getParameter("ondemandId");
		//查询章节信息
		List<Map> treeList = ondemandService.selectChapter(ondemandId);
		for(Map item:treeList){
			item.put("id", item.get("chapterId")+"");
			item.put("pId", item.get("parentId")+"");
			item.put("name", item.get("title")+"");
			item.remove("chapterId");
			item.remove("parentId");
			item.remove("title");
		}
		//获取课时信息
		List<Map> clssList = ondemandService.selectClass(ondemandId);
		for (Map map : clssList) {
			Map ma = new HashMap();
			ma.put("Kid", map.get("hourId")+"");
			ma.put("pId", map.get("chapterId")+"");
			ma.put("name", map.get("title")+"");
			treeList.add(ma);
		}
		reqMap.put("treeList", treeList);
		return reqMap;
	}
	/**
	 * 章节目录拖拽排序
	 * 	同一个父级节点下的拖拽
	 * @param dragId 被拖拽节点Id
	 * 	fallId 落下时当前位置的节点Id
	 */
	@RequestMapping(value="/upOrderIndex")
	@ResponseBody
	public Map<String,Object> upOrderIndex(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = ondemandService.upOrderIndex(map);
		if(row > 0){
			reqMap.put("success", true);
		}else{
			reqMap.put("success", false);
		}
		return reqMap;
	}
	/**
	 * 不是同一父级节点下的拖拽排序
	 *  dragId 被拖拽节点Id parentId要变更成的父Id
	 * @return
	 */
	@RequestMapping(value="/upParentId")
	@ResponseBody
	public Map<String, Object> upParentId(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = ondemandService.upParentId(map);
		if(row > 0){
			reqMap.put("success", true);
		}else{
			reqMap.put("success", false);
		}
		return reqMap;
	}
	
	//删除课程原本关联的教师
	@RequestMapping(value="/delTeacher")
	@ResponseBody
	public Map delTeacher(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = ondemandService.delTeacher(map);
		if(row > 0){
			reqMap.put("success", true);
		}else{
			reqMap.put("success", false);
		}
		return reqMap;
	}
	
	
	
	
	
	
	
	
	
	
	/**
	 * 编辑器上传图片
	 * @param request
	 * @param upfile
	 * @return
	 */
	@RequestMapping(value="/uploadimage")
	@ResponseBody
	public Map uploadimage(HttpServletRequest request){
		Map<String, Object> map = new HashMap<String, Object>();
		//判断文件是否为空
		if(request instanceof MultipartHttpServletRequest){
			MultipartFile files1=((MultipartHttpServletRequest) request).getFile("upfile");
			String filePath=Tools.getUploadDir();
			String fileUrl = Tools.saveUploadFile(files1, filePath);
			map.put("fileUrl", fileUrl);
			Date now = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String newFileName = fileUrl.replace("/upload/"+sdf.format(now)+"/", "");
			map.put("name", newFileName);
			map.put("state","SUCCESS");
			map.put("url", fileUrl);
		}
		return map;
	}
	@RequestMapping(value = "/uploadImg")
	@ResponseBody
	public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
		// 文件上传
		String imgUrl = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir();
		// 获取路径 upload/Advertisement/yyyyMMdd/
		String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");
		String fileName="";
		if (files.isEmpty()) {
			imgUrl = "";
		} else {

			fileName=files.getOriginalFilename();
			String newFileName = UUID.randomUUID().toString()+Tools.getFileExtension(files.getOriginalFilename());// 获取图片名称
			String newFilePath = filePath + newFileName;// 新路径
			File newFile = new File(newFilePath);
			if (newFile.exists()) {
				//String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				newFilePath = filePath + newFileName;
				newFile = new File(newFilePath);
			}
			
			try {
				files.transferTo(newFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			;
			imgUrl = "/" + pathSub + newFileName;// 保存到数据库的路径
		}
		//截取文件类型
		String lower=imgUrl.substring(imgUrl.length()-4, imgUrl.length());
		Map<String, Object> map = new HashMap<String,Object>();
		if(lower.equals(".mp3") || lower.equals(".mp4") || lower.equals(".avi")) {
			//调用获取时间方法
			map = ondemandService.getDuration(imgUrl);
		}
		map.put("fileName", fileName);
		map.put("data", imgUrl);
		return com.alibaba.fastjson.JSONObject.toJSONString(map);
		//return "{\"data\": \"" + imgUrl + "\""+ "min\":\"" + DataConvert.ToString(map.get("min")) + "\"}";
		//return "{\"data\": \"" + imgUrl + "\""+ DataConvert.ToString(map.get("min")) +"\""+ DataConvert.ToString(map.get("sec")) +"\"}";
	}
	
	@RequestMapping(value = "/uploadPpt")
	@ResponseBody
	public String uploadPpt(@RequestParam("imgUrl") MultipartFile files ,HttpServletRequest request) {
		// 文件上传
		String path = "";
		String imgUrl = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir();
		// 获取路径 upload/Advertisement/yyyyMMdd/
		String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");
		String fileName="";
		if (files.isEmpty()) {
			imgUrl = "";
		} else {
			fileName=files.getOriginalFilename();
			String newFileName = UUID.randomUUID().toString()+Tools.getFileExtension(files.getOriginalFilename());// 获取图片名称
			String newFilePath = filePath + newFileName;// 新路径
			File newFile = new File(newFilePath);
			if (newFile.exists()) {
				//String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
				newFilePath = filePath + newFileName;
				newFile = new File(newFilePath);
			}
			
			try {
				files.transferTo(newFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			;
			path = "/" + pathSub + newFileName;// 保存到数据库的路径
		}
		String userDir = System.getProperty("user.dir")+path;
		userDir = userDir.replaceAll("\\\\", "/");
		Map<String, Object> map = new HashMap<String,Object>();
		List<String> pptPaths = new ArrayList<String>();
		if (files.isEmpty()) {
			path = "";
		} else {
			// String path = "D:\\temp\\temp\\test.pptx";
			File file = new File(userDir);
			InputStream is = null;
			try {
				is = new FileInputStream(file);
				SimpleDateFormat sdfFolderName = new SimpleDateFormat("yyyyMMdd");
				String newFolderName = sdfFolderName.format(new Date());
				String absolutePath = System.getProperty("user.dir")+"/upload/ppt/"+newFolderName+"/";
				if (path.endsWith(".ppt")) {
					pptPaths = pptToJpgUtil.toImage2003(userDir, absolutePath);
				} else if (path.endsWith(".pptx")) {
					pptPaths = pptToJpgUtil.toImage2007(userDir, absolutePath);
				}
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		map.put("pptfileName", fileName);
		map.put("pptUrl", pptPaths);
		return com.alibaba.fastjson.JSONObject.toJSONString(map);
		//return "{\"data\": \"" + imgUrl + "\""+ "min\":\"" + DataConvert.ToString(map.get("min")) + "\"}";
		//return "{\"data\": \"" + imgUrl + "\""+ DataConvert.ToString(map.get("min")) +"\""+ DataConvert.ToString(map.get("sec")) +"\"}";
	}
	
	
	//根据id查询指定的教师信息
	@RequestMapping(value="/teacherMsg")
	@ResponseBody
	public Map teacherMsg(@RequestParam Map map){
		Map ma = ondemandService.teacherMsg(map);
		return ma;
	}
	
	//设置课程是否推荐
	@RequestMapping(value="/updateIsRecommend")
	@ResponseBody
	public Map<String, Object> updateIsRecommend(@RequestParam Map map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = ondemandService.updateIsRecommend(map);
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败!");
		}
		return reqMap;
	}
	
}
