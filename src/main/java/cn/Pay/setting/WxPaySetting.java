package cn.Pay.setting;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class WxPaySetting {
    @Value("${appid}")
	private String appid;
	
	@Value("${partner}")
	private String partner;
	
	@Value("${partnerkey}")
	private String partnerkey;
	
	@Value("${host}")
	private String host;

	public String getAccountId() {
		return partner;
	}

	public String getEncryptionKey() {
		return appid+"|"+partnerkey+"|127.0.0.1"+"|"+host;
	}
}