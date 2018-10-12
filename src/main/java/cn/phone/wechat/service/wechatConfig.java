package cn.phone.wechat.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.Setting.Setting;
import cn.Setting.Model.WechatSetting;
import cn.util.wechat.wechatHelper;


@Service
public class wechatConfig {

	private static String appId="";
	private static String appSecret="";
	
	@Autowired
	Setting setting;
	
	/**
	 * appId
	 * @return
	 */
	public String getAppId(){
		getBaseSetting();
		return appId;
	}
	
	/**
	 * appSecret
	 * @return
	 */
	public String getAppSecret(){
		getBaseSetting();
		return appSecret;
	}
	
	/**
	 * 获取微信基本参数
	 */
	private  void  getBaseSetting() {
		
		WechatSetting wechatSetting=setting.getSetting(WechatSetting.class);
		
		appId=wechatSetting.getAppId();
		appSecret=wechatSetting.getAppSecret();
	}
	
	/**
	 * 获取token
	 */
	public String getAccess_Token(){
		return wechatHelper.getAccess_token(getAppId(), getAppSecret());
	}
	
	/**
	 * 获取ticket
	 */
	public String getJsApi_Ticket(){
		return wechatHelper.getJsapi_ticket(getAccess_Token());
	}
}
