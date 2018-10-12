package cn.web.appload;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.apache.log4j.Priority;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.SMS.SmsService;
import cn.api.service.AccountService;
import cn.phone.login.service.PhoneLoginService;
import cn.phone.login.service.WechatUserService;
import cn.util.DataConvert;
import cn.util.StringHelper;
import cn.util.Tools;
import cn.util.wechat.WxUserInfo;
import cn.util.wechat.wechatHelper;

/**
 * app下载
 */
@Controller
@RequestMapping("/web/appLoad")
public class WebAppLoadController {
	
	/**
	 * 调整app下载页面
	 */
	@RequestMapping(value="/appLoadSite")
	public ModelAndView appLoadSite() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("headers", false);
		map.put("foots", false);
		return new ModelAndView("/web/appload/load",map);
	}
	
	
}
