package cn.util;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class GetIPLocation {

	/**
	 * 获取ip地址归属地、运营商等数据
	 * 
	 * @param ip
	 *            ip地址
	 * @return ip地址归属地信息
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static String getLocation(String ip) {
		try {
			URL url = new URL("http://ip.taobao.com/service/getIpInfo.php?ip=" + ip);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setConnectTimeout(300000);
			conn.setDoInput(true);
			conn.setRequestMethod("GET");
			InputStream is = conn.getInputStream();
			ByteArrayOutputStream arrayOut = new ByteArrayOutputStream();
			byte[] by = new byte[1024];
			int len = 0;
			while ((len = is.read(by)) != -1) {
				arrayOut.write(by, 0, len);
			}
			String result = new String(arrayOut.toByteArray());
			Map<String, Object> map = Tools.JsonToMap(result);
			Map<String, Object> data = (Map<String, Object>) map.get("data");
			String location = String.valueOf(data.get("region")) +" "+ String.valueOf(data.get("city"));
			return location;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}