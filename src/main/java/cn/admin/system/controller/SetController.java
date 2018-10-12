package cn.admin.system.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import cn.AdminRewriteFilter;
import cn.Setting.Setting;
import cn.Setting.Model.AdminPreFixSetting;
import cn.Setting.Model.SiteInfo;
import cn.Setting.Model.SmsSetting;
import cn.Setting.Model.VcloudSetting;
import cn.Setting.Model.WechatSetting;
import cn.api.service.PathService;
import cn.util.StringHelper;
import cn.util.Tools;

/**
 * @author
 */
@Controller
@RequestMapping(value = "/admin/system/set")
public class SetController {

	@Autowired
	HttpSession session;
	@Autowired
	Setting setting;
	@Autowired
	WebApplicationContext webApplicationContext;
	@Autowired
	PathService pathService;

	@RequestMapping(value = "/setModel")
	public ModelAndView setModel(@RequestParam Map map, HttpServletRequest request, HttpServletResponse response) {
		// 查询参数设置
		SiteInfo siteInfo = setting.getSetting(SiteInfo.class, null);
		//修改Log图片路劲
		siteInfo.setImgUrl(pathService.getAbsolutePath(siteInfo.getImgUrl()));
		map.put("siteInfo", siteInfo);
		
		WechatSetting wechatSetting = setting.getSetting(WechatSetting.class);
		map.put("wechatSetting",wechatSetting);
		
		VcloudSetting vcloudSetting=setting.getSetting(VcloudSetting.class);
		map.put("vcloudSetting",vcloudSetting);
		
		SmsSetting smsSetting = setting.getSetting(SmsSetting.class);
		Map<String, String> smsMessage = smsSetting.getMessageSettings();
		
		smsSetting.InitMessage(new ArrayList<String>(){
			{
				add("快捷登录");
				add("用户注册");
				add("密码找回");
			}
		});
		
		map.put("smsMsgList", smsSetting.getMessageList());
		map.put("smsSetting", smsSetting);


		AdminPreFixSetting adminPreFixSetting = setting.getSetting(AdminPreFixSetting.class);
		map.put("adminPreFixSetting", adminPreFixSetting);
		
		return new ModelAndView("/admin/system/setModel", map);
	}

	@RequestMapping(value = "/saveSetting")
	public @ResponseBody Map<String, Object> SaveSetting(SiteInfo siteInfo) {
		
		Map<String, Object> resultMap = new HashMap<String, Object>() {
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};
		boolean result = setting.setSetting(siteInfo);
		if (result) {
			resultMap.put("success", true);
			resultMap.put("msg", "保存成功！");
		}
		return resultMap;
	}

	@RequestMapping(value = "/saveAdminPreFixSetting")
	public @ResponseBody Map<String, Object> SaveAdminPreFixSetting(AdminPreFixSetting adminPreFixSetting) {
		Map<String, Object> resultMap = new HashMap<String, Object>() {
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};
		boolean result = setting.setSetting(adminPreFixSetting);
		if (result) {
			AdminRewriteFilter.adminPrefix = adminPreFixSetting.getAdminUrl();
			webApplicationContext.getServletContext().setAttribute("adminprefix", adminPreFixSetting.getAdminUrl());
			resultMap.put("success", true);
			resultMap.put("adminUrl", adminPreFixSetting.getAdminUrl());
			resultMap.put("msg", "保存成功！");
		}
		return resultMap;
	}

	@RequestMapping(value = "/saveSmsSetting")
	public @ResponseBody Map<String, Object> SaveSmsSetting(@RequestParam Map<String, Object> paramMap) {
		Map<String, Object> resultMap = new HashMap<String, Object>() {
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};

		SmsSetting smsSetting = new SmsSetting();

		smsSetting.setServer(paramMap.get("server") + "");
		smsSetting.setAccount(paramMap.get("account") + "");
		smsSetting.setPassword(paramMap.get("password") + "");
		smsSetting.setServiceNumber(paramMap.get("serviceNumber") + "");

		Map<String, String> messgeMap = new HashMap<String, String>();
		List<Map<String, Object>> msgList = Tools.JsonTolist(paramMap.get("message") + "");
		if (msgList != null && !msgList.isEmpty()) {
			for (Map<String, Object> map : msgList) {
				String name = map.get("name") + "";
				String message = map.get("message") + "";

				if (StringHelper.IsNullOrEmpty(name)) {
					continue;
				}
				messgeMap.put(name, message);
			}
		}
		smsSetting.setMessageSettings(messgeMap);

		boolean result = setting.setSetting(smsSetting);
		if (result) {
			resultMap.put("success", true);
			resultMap.put("msg", "保存成功！");
		}
		return resultMap;
	}

	@RequestMapping(value = "/saveWechatSetting")
	public @ResponseBody Map<String, Object> SaveWechatSetting(WechatSetting wechatSettingInfo) {
		Map<String, Object> resultMap = new HashMap<String, Object>() {
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};

		boolean result = setting.setSetting(wechatSettingInfo);
		if (result) {
			resultMap.put("success", true);
			resultMap.put("msg", "保存成功！");
		}
		return resultMap;
	}
	
	@RequestMapping(value = "/saveVcloudSetting")
	public @ResponseBody Map<String, Object> saveVcloudSetting(VcloudSetting vcloudSetting) {
		Map<String, Object> resultMap = new HashMap<String, Object>() {
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};

		boolean result = setting.setSetting(vcloudSetting);
		if (result) {
			resultMap.put("success", true);
			resultMap.put("msg", "保存成功！");
		}
		return resultMap;
	}
	
	@RequestMapping(value = "/uploadImg")
	@ResponseBody
	public String uploadImg(@RequestParam("imgUrl") MultipartFile files) {
		// 上传图片
		String SiteLogo = "";
		// 上传的图片保存路径
		String filePath = Tools.getUploadDir("logo");
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

}
