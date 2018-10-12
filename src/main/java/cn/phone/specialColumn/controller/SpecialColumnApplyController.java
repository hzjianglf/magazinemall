package cn.phone.specialColumn.controller;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.AccountService;
import cn.api.service.TeacherService;
import cn.util.DataConvert;
import cn.util.Tools;
import cn.util.UtilDate;

/**
 * 专栏认证
 * @author baoxuechao
 *
 */
@Controller
@RequestMapping(value="/phone/SpecialColumn")
public class SpecialColumnApplyController {

	@Autowired
	HttpSession session;
	@Autowired
	TeacherService teacherService;
	@Autowired
	AccountService accountService;
	
	
	/**
	 * 专栏工作台
	 * @return
	 */
	@RequestMapping(value="/index")
	public ModelAndView index(){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId=session.getAttribute("userId")+"";
		//用户角色
		int userType=DataConvert.ToInteger(session.getAttribute("userType"));
		if(userType==2){
			//查询专栏作家信息
			reqMap=teacherService.selectWriterMsg(userId);
		}
		reqMap.put("userType", userType);
		reqMap.put("footer", false);
		return new ModelAndView("/phone/specialColumn/index",reqMap);
	}
	/**
	 * 专栏作家认证页面
	 * @return
	 */
	@RequestMapping(value="/apply")
	public ModelAndView apply(){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		String userId=session.getAttribute("userId")+"";
		//查询认证信息
		Map<String, Object> apply = teacherService.selectApplyMsg(userId);
		reqMap.put("apply", apply);
		reqMap.put("footer", false);
		return new ModelAndView("/phone/specialColumn/apply",reqMap);
	}
	/**
	 * 保存认证信息
	 * @param map
	 * @return
	 */
	@RequestMapping(value="/saveApply")
	@ResponseBody
	public Map<String, Object> saveApply(@RequestParam Map<String,Object> map){
		Map<String, Object> reqMap = new HashMap<String, Object>();
		map.put("userId", session.getAttribute("userId")+"");
		int row = accountService.authentication(map);
		if(row > 0){
			reqMap.put("msg", "提交成功,待管理员确认!");
		}else{
			reqMap.put("msg", "提交失败!");
		}
		return reqMap;
	}
	
	/**
	 * 图片上传
	 * @param files
	 * @return
	 */
	@RequestMapping(value = "/uploadImg")
	@ResponseBody
	public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
		// 文件上传
		String imgUrl = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir();
		// 获取路径 upload/Advertisement/yyyyMMdd/
		String pathSub = filePath.substring(filePath.indexOf("upload")).replace("\\", "/");
		if (files.isEmpty()) {
			imgUrl = "";
		} else {
			String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
			String threeRandom = UtilDate.getThree();//三维随机数
			String newFileName = ymds+threeRandom+files.getOriginalFilename();// 获取图片名称
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
		return "{\"data\": \"" + imgUrl + "\"}";
	}
	
}
