package cn.Vcloud;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class VcloudHelper {

	/**
	 * 获取请求的head Map
	 * @param headMap
	 */
	public static Map<String, String> getHeadMap(String appKey,String appSecret) {
		
		Map<String, String> headMap=new HashMap<String,String>();
		
		String nonce=UUID.randomUUID().toString().replace("-", "");
		String curTime=String.valueOf((new Date()).getTime() / 1000L);
		
		headMap.put("AppKey", appKey);
		//随机数
		headMap.put("Nonce",nonce);
		//时间戳
		headMap.put("CurTime", curTime);
		
		String checkSum=CheckSumBuilder.getCheckSum(appSecret, nonce, curTime);
		headMap.put("CheckSum", checkSum);
		
		return headMap;
	}
	
	/**
	 * 接口地址
	 */
	public enum ApiUrl{
		/**
		 * 创建频道
		 */
		channel_create("https://vcloud.163.com/app/channel/create"),
		
		/**
		 * 设置频道为录制状态
		 */
		channel_setAlwaysRecord("https://vcloud.163.com/app/channel/setAlwaysRecord");
		
		private String url;
		
		private ApiUrl(String url) {
			this.url=url;
		}
		
		public String getUrl() {
			return this.url;
		}
	}
}

