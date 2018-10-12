package cn.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONObject;

/**
 * 根据ISBN查询手机号归属地
 * 
 * @author Administrator
 *
 */
public class TelAscription {

	/**
	 * 传入一个String类型的手机号
	 * 
	 * @param tel
	 * @return 省份名称
	 */
	public static Map<String, Object> checktel(String tel) {
		Map<String, Object> data = new HashMap<String, Object>();
		String charset = "UTF-8";
		String urlname = "http://apis.juhe.cn/mobile/get?phone=" + tel + "&key=de2bc26efacc90933cabb7436031c10f";// appkey
		String jsonResult = get(urlname, charset);// 得到JSON字符串
		JSONObject object = new JSONObject(jsonResult);// 转化为JSON类
		if (Integer.valueOf(object.get("error_code") + "") == 204402) {
			data.put("success", "NO");
			data.put("msg", "未能找到相关数据信息");
		} else {
			// 将json字符串转换成jsonObject
			// 遍历jsonObject数据，添加到Map对象
			JSONObject obj = new JSONObject(object.get("result") + "");
			Iterator<String> it = obj.keys();
			while (it.hasNext()) {
				String key = String.valueOf(it.next());
				String value = obj.get(key) + "";
				data.put(key, value);
			}
			data.put("success", "YES");
			String city = "" + data.get("province") + "省" + data.get("city") + "市";
			data.put("msg", city);
		}
		return data;
	}

	public static String get(String urlAll, String charset) {
		BufferedReader reader = null;
		String result = null;
		StringBuffer sbf = new StringBuffer();
		String userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.66 Safari/537.36";// 模拟浏览器
		try {
			URL url = new URL(urlAll);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setReadTimeout(30000);
			connection.setConnectTimeout(30000);
			connection.setRequestProperty("User-agent", userAgent);
			connection.connect();
			InputStream is = connection.getInputStream();
			reader = new BufferedReader(new InputStreamReader(is, charset));
			String strRead = null;
			while ((strRead = reader.readLine()) != null) {
				sbf.append(strRead);
				sbf.append("\r\n");
			}
			reader.close();
			result = sbf.toString();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
