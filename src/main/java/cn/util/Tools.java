package cn.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.codec.binary.Base64;
import org.apache.poi.POIXMLDocument;
import org.apache.poi.POIXMLTextExtractor;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.alibaba.druid.util.StringUtils;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class Tools {
	/**
	 * json转Map
	 * 
	 * @author dhr
	 * @param json
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static Map<String, Object> JsonToMap(String json) {
		Map<String, Object> map = null;
		ObjectMapper objectMapper = new ObjectMapper();
		try {
			map = objectMapper.readValue(json, HashMap.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return map;
	}

	/**
	 * json转List
	 * 
	 * @author dhr
	 * @param json
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> JsonTolist(String json) {
		List<Map<String, Object>> list = null;
		try {
			list = new ObjectMapper().readValue(json, ArrayList.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 将msg采用MD5算法处理,返回一个String结果
	 * 
	 * @param msg
	 *            明文
	 * @return 密文
	 */
	public static String md5(String msg) {
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			// 原始信息input
			byte[] input = msg.getBytes();
			// 加密信息output
			byte[] output = md.digest(input);// 加密处理
			// 采用Base64将加密内容output转成String字符串
			String s = Base64.encodeBase64String(output);
			return s;
		} catch (Exception ex) {
			System.out.println("md5加密失败");
			return null;
		}
	}

	/**
	 * MD5加密 32位小写
	 * 
	 * @param text
	 * @return
	 */
	public static String getMD5(String text) {
		String result = "";
		try {

			// result=DigestUtils.md5DigestAsHex(text.getBytes("UTF-8")).toLowerCase();

			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(text.getBytes("UTF-8"));
			byte b[] = md.digest();
			int i;
			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			result = buf.toString().toLowerCase();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 字符串按逗号分隔为List
	 * 
	 * @author dhr
	 * @param Strings
	 * @return
	 */
	public static List<String> handleString(String Strings) {
		if (StringUtils.isEmpty(Strings)) {
			return null;
		}
		List<String> list = new ArrayList<>();
		String[] strs = Strings.split(",");
		for (String str : strs) {
			list.add(str);
		}
		return list;
	}

	/**
	 * 上传单张图片
	 * 
	 * @author dhr
	 * @param files
	 *            文件
	 * @param path
	 *            上传地址
	 * @return
	 */
	public static String saveUploadFile(MultipartFile files, String path) {
		// 上传图片
		String fileSavePath = "";
		// 上传的图片保存路径
		String filePath = path;
		File pathFile = new File(filePath);// 建文件夹
		if (!pathFile.exists()) {
			pathFile.mkdirs();
		}
		MultipartFile upFile = files;
		if (files.isEmpty()) {
			fileSavePath = "";
		} else {
			String newFileName = UUID.randomUUID().toString() + Tools.getFileExtension(upFile.getOriginalFilename());
			String newFilePath = filePath + newFileName;// 新路径
			File newFile = new File(newFilePath);
			try {
				upFile.transferTo(newFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			fileSavePath = Tools.getFileVirtualPath(newFilePath);// 保存到数据库的路径
		}
		return fileSavePath;
	}

	/**
	 * 上传多张图片
	 * 
	 * @author dhr
	 * @param filess
	 *            多个文件数组
	 * @param path
	 *            上传地址
	 * @return
	 */
	public static String addImages(MultipartFile[] filess, String path) {
		// 图片的个数
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		// 存到数据库的图片集合名称
		String SiteLogos = "";
		for (MultipartFile files : filess) {
			// 上传图片
			String SiteLogo = "";
			// 上传的图片保存路径
			String filePath = path;
			// 建文件夹
			File pathFile = new File(filePath);
			// 如果这个文件夹存在!pathFile.exists()会返回false
			if (!pathFile.exists()) {
				// 建立目录文件夹
				pathFile.mkdirs();
			}
			MultipartFile upFile = files;
			// 判断要上传的文件是否为空，如果为空则返回true
			if (files.isEmpty()) {
				SiteLogo = "";
			} else {
				// 获取图片名称
				String newFileName = upFile.getOriginalFilename();
				// 图片保存路径
				String newFilePath = filePath + newFileName;
				File newFile = new File(newFilePath);
				// 如果这个图片名字存在！newFile.exists()会返回true
				if (newFile.exists()) {
					// 获取新的图片名
					newFileName = sdf.format(new Date()) + "_" + upFile.getOriginalFilename();
					newFilePath = filePath + newFileName;
					newFile = new File(newFilePath);
				}
				try {
					upFile.transferTo(newFile);
				} catch (Exception e) {
					e.printStackTrace();
				}
				// 保存到数据库的路径
				SiteLogo = path + newFileName + ",";
				// 将所有图片名称按照逗号拼接
				SiteLogos = SiteLogos + SiteLogo;
			}
		}
		return SiteLogos;
	}

	/**
	 * 删除图片
	 * 
	 * @param preFilePath
	 *            配置文件路径
	 * @param url
	 *            文件路径
	 */
	public static void delImg(String url) {
		try {
			String dir = System.getProperty("user.dir");
			if (!StringUtils.isEmpty(url)) {
				String path = dir + url.replace("/", "\\");
				File file = new File(path);
				if (file.exists()) {
					file.delete();
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String getUploadDir() {
		SimpleDateFormat sdfFolderName = new SimpleDateFormat("yyyyMMdd");
		String newFolderName = sdfFolderName.format(new Date());
		String userDir = System.getProperty("user.dir");
		String path = userDir + "\\upload\\" + newFolderName + "\\";
		File file = new File(path);
		if (!file.exists()) {
			file.mkdirs();
		}
		return path;
	}
	public static String getpptUploadDir() {
		SimpleDateFormat sdfFolderName = new SimpleDateFormat("yyyyMMdd");
		String newFolderName = sdfFolderName.format(new Date());
		String userDir = System.getProperty("user.dir");
		String path = userDir + "\\upload\\ppt\\" + newFolderName + "\\";
		File file = new File(path);
		if (!file.exists()) {
			file.mkdirs();
		}
		return path;
	}
	public static String getFileVirtualPath(String path) {
		return path.replace(System.getProperty("user.dir"), "").replaceAll("\\\\", "/");
	}

	public static String getFileExtension(String file) {
		if (com.mysql.jdbc.StringUtils.isNullOrEmpty(file) || file.lastIndexOf(".") == -1) {
			return "";
		}
		return file.substring(file.lastIndexOf("."));
	}

	// 生成随机数
	public static String getnumber(int n) {
		String str = "0123456789qwertyuioplkjhgfdsazxcvbnm";
		Random random = new Random();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < n; ++i) {
			int number = random.nextInt(36);
			sb.append(str.charAt(number));
		}
		return sb.toString();
	}

	public static String getOnlynumber(int length) {
		String str = "0123456789";
		Random random = new Random();
		StringBuffer sb = new StringBuffer();
		sb.append("123456789".charAt(random.nextInt(9)));
		for (int i = 0; i < length - 1; ++i) {
			int number = random.nextInt(10);
			sb.append(str.charAt(number));
		}
		return sb.toString();
	}

	public static String getTextFromWord(String path) {
		File file = new File(path);
		String text = "";
		try {
			InputStream is = new FileInputStream(file);
			WordExtractor ex = new WordExtractor(is);
			text = ex.getText();
		} catch (Exception e) {
			OPCPackage opcPackage;
			try {
				opcPackage = POIXMLDocument.openPackage(path);
				POIXMLTextExtractor extractor = new XWPFWordExtractor(opcPackage);
				text = extractor.getText();
			} catch (Exception e1) {
				e1.printStackTrace();
			}

		}

		return text;
	}

	/**
	 * 返回随机数
	 * 
	 * @param list
	 * @author dhr
	 * @param selected
	 *            备选数量
	 * @return
	 */
	public static List getRandomNum(List list, int selected) {
		List reList = new ArrayList();
		Random random = new Random();
		// 先抽取，备选数量的个数
		if (list.size() >= selected) {
			for (int i = 0; i < selected; i++) {
				// 随机数的范围为0-list.size()-1;
				int target = random.nextInt(list.size());
				reList.add(list.get(target));
				list.remove(target);
			}
		} else {
			// 如果数量超出
			selected = list.size();
			for (int i = 0; i < selected; i++) {
				// 随机数的范围为0-list.size()-1;
				int target = random.nextInt(list.size());
				reList.add(list.get(target));
				list.remove(target);
			}
		}
		return reList;
	}

	/**
	 * 计算两个日期相差的天，时，分，秒
	 * 
	 * @param endDate
	 * @param nowDate
	 * @author dhr
	 * @return
	 */
	public static String getDatePoor(Date endDate, Date nowDate) {
		long nd = 1000 * 24 * 60 * 60;
		long nh = 1000 * 60 * 60;
		long nm = 1000 * 60;
		long ns = 1000;
		// 获得两个时间的毫秒时间差异
		long diff = endDate.getTime() - nowDate.getTime();
		// 计算差多少天
		long day = diff / nd;
		// 计算差多少小时
		long hour = diff % nd / nh;
		// 计算差多少分钟
		long min = diff % nd % nh / nm;
		// 计算差多少秒//输出结果
		long sec = diff % nd % nh % nm / ns;
		return day + "天" + hour + "小时" + min + "分钟" + sec + "秒";
	}

	/**
	 * 计算两个日期相差的天或时或分或秒
	 * 
	 * @param endDate
	 * @param nowDate
	 * @author dhr
	 * @return
	 */
	public static Map<String, Object> getDatePoors(Date endDate, Date nowDate) {
		double nd = 1000 * 24 * 60 * 60;
		double nh = 1000 * 60 * 60;
		double nm = 1000 * 60;
		double ns = 1000;
		double mss = endDate.getTime() - nowDate.getTime();
		double days = Arith.div(mss, nd, 2);
		double hours = Arith.div(mss, nh, 2);
		double minutes = Arith.div(mss, nm, 2);
		double seconds = Arith.div(mss, ns, 2);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("days", days);
		map.put("hours", hours);
		map.put("minutes", minutes);
		map.put("seconds", seconds);
		return map;
	}

	// Excel导出封装方法
	public static Map excel(String[] excelHeader) {
		HSSFWorkbook wb = new HSSFWorkbook();
		// 创建工作表格
		HSSFFont fontStyle = wb.createFont();
		fontStyle.setFontName("微软雅黑");
		HSSFSheet sheet = wb.createSheet("sheet");
		// 创建行
		HSSFRow row = sheet.createRow((int) 0);
		// 创建单元格 并将表头设置为居中
		HSSFCellStyle style = wb.createCellStyle();
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		HSSFFont font = wb.createFont();
		font.setFontName("仿宋_GB2312");
		font.setFontHeightInPoints((short) 12);
		font.setColor(HSSFFont.COLOR_RED);
		style.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 表格居中
		style.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直
		style.setFont(font);
		// 创建单元格 并将表头设置为居中
		HSSFCellStyle style2 = wb.createCellStyle();
		style2.setBorderBottom(BorderStyle.THIN);
		style2.setBorderLeft(BorderStyle.THIN);
		style2.setBorderRight(BorderStyle.THIN);
		style2.setBorderTop(BorderStyle.THIN);
		style2.setBottomBorderColor(HSSFColor.BLACK.index);
		HSSFFont font2 = wb.createFont();
		font2.setFontName("仿宋_GB2312");
		style2.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 表格居中
		style2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);// 垂直
		// 设置单元格宽度
		sheet.setColumnWidth(0, 3000);
		sheet.setColumnWidth(1, 3000);
		sheet.setColumnWidth(2, 3000);
		sheet.setColumnWidth(3, 3000);
		sheet.setColumnWidth(4, 3000);
		sheet.setColumnWidth(5, 3000);
		sheet.setColumnWidth(6, 3000);
		sheet.setColumnWidth(7, 3100);
		sheet.setColumnWidth(8, 3100);
		// 创建标题
		for (int i = 0; i < excelHeader.length; i++) {
			// 标题的列
			HSSFCell cell = row.createCell(i);
			// 标题列的写入
			cell.setCellValue(excelHeader[i]);
			// 样式
			cell.setCellStyle(style);
			// 每列长度自适应
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sheet", sheet);
		map.put("style2", style2);
		map.put("wb", wb);
		map.put("row", row);
		return map;
	}

	/**
	 * * 设置cookie * @param response * @param name cookie名字 * @param value cookie值
	 * * @param maxAge cookie生命周期 以秒为单位
	 */
	public static void addCookie(HttpServletResponse response, String name, String value, int maxAge) {
		Cookie cookie = new Cookie(name, value);
		cookie.setPath("/");
		// 生存周期默认时间为秒，如果设置为负值的话，则为浏览器进程Cookie(内存中保存)，关闭浏览器就失效。如果设置成0，删除Cookie
		cookie.setMaxAge(maxAge);
		response.addCookie(cookie);
	}

	/**
	 * 获取cookie里面的微信信息
	 * 
	 * @param request
	 * @return
	 */
	public static Map<String, String> getCookieByName(HttpServletRequest request) {
		Cookie[] cookies = ((HttpServletRequest) request).getCookies();
		Map<String, String> map = new HashMap<String, String>();
		if (cookies != null) {
			for (Cookie c : cookies) {
				if (c.getName().equals("answer_openid")) {
					map.put("answer_openid", c.getValue());
					continue;
				}
				if (c.getName().equals("answer_access_token")) {
					map.put("answer_access_token", c.getValue());
					continue;
				}
				if (c.getName().equals("answer_refresh_token")) {
					map.put("answer_refresh_token", c.getValue());
					continue;
				}
			}
		}
		return map;
	}

	/**
	 * 将list1中包含的list2的值去掉
	 * 
	 * @param list1
	 *            要改变的list
	 * @param list2
	 *            要去除的list
	 * @return
	 */
	public static List<String> listRemoveList(List<String> list1, List<String> list2) {
		List<String> newList = new ArrayList<String>();
		Collection exists = new ArrayList<String>(list1);
		exists.removeAll(list2);
		newList = (List<String>) exists;
		return newList;
	}

	/**
	 * 随机打乱list中元素的顺序
	 * 
	 * @param list
	 * @return
	 */
	public static List shuffle(List<Map> list) {
		int size = list.size();
		Random random = new Random();

		for (int i = 0; i < size; i++) {
			// 获取随机位置
			int randomPos = random.nextInt(size);

			// 当前元素与随机元素交换
			Map temp = list.get(i);
			list.set(i, list.get(randomPos));
			list.set(randomPos, temp);
		}
		return list;
	}

	/**
	 * 过滤html标签
	 * 
	 * @param String
	 *            字符串
	 * @return 文本
	 */
	public static String delHTMLTag(String htmlStr,String type) {
		String regEx_script = "<script[^>]*?>[\\s\\S]*?<\\/script>"; // 定义script的正则表达式
		String regEx_style = "<style[^>]*?>[\\s\\S]*?<\\/style>"; // 定义style的正则表达式
		String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式
		String regEx_img = "<img[^>]*>";
		if("script".equals(type)) {
			Pattern p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);
			Matcher m_script = p_script.matcher(htmlStr);
			htmlStr = m_script.replaceAll(""); // 过滤script标签
		}else if("style".equals(type)) {
			Pattern p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);
			Matcher m_style = p_style.matcher(htmlStr);
			htmlStr = m_style.replaceAll(""); // 过滤style标签
		}else if("html".equals(type)) {
			Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
			Matcher m_html = p_html.matcher(htmlStr);
			htmlStr = m_html.replaceAll(""); // 过滤html标签
		}else if("img".equals(type)) {
			Pattern p_img = Pattern.compile(regEx_img, Pattern.CASE_INSENSITIVE);
			Matcher m_img = p_img.matcher(htmlStr);
			htmlStr = m_img.replaceAll(""); // 过滤html标签
		}
		return htmlStr.trim(); // 返回文本字符串
	}

	/**
	 * 获取登录IP
	 * 
	 * @param request
	 * @return
	 */
	public static String getIpAddr(HttpServletRequest request) {
		String ip = request.getHeader("x-forwarded-for");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_CLIENT_IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("HTTP_X_FORWARDED_FOR");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}
		if ("0:0:0:0:0:0:0:1".equals(ip)) {
			ip = "127.0.0.1";
		}
		return ip;
	}

	/**
	 * 文件上传路径
	 * 
	 * @param moduleName
	 *            功能模块名称
	 * @return
	 */
	public static String getUploadDir(String moduleName) {
		SimpleDateFormat sdfFolderName = new SimpleDateFormat("yyyyMM");
		String newFolderName = sdfFolderName.format(new Date());
		String userDir = System.getProperty("user.dir");
		String path = userDir + "\\upload\\" + moduleName + "\\" + newFolderName + "\\";
		File file = new File(path);
		if (!file.exists()) {
			file.mkdirs();
		}
		return path;
	}

	/**
	 * MD5加密
	 */
	public static String Md5(String plainText) {
		byte[] secretBytes = null;
		try {
			secretBytes = MessageDigest.getInstance("md5").digest(plainText.getBytes("utf-8"));
		} catch (Exception e) {
			throw new RuntimeException("没有md5这个算法！");
		}
		String md5code = new BigInteger(1, secretBytes).toString(16);
		int num = md5code.length();
		int mn = 32 - num;
		String w = "";
		for (int i = 0; i < mn; i++) {
			w += 0;
		}
		String aa = w + md5code;
		return aa;
	}

	/**
	 * 检查字符串数组中是否有空字符串
	 * 
	 * @param params
	 * @return boolean
	 */
	public static boolean checkParams(String... params) {
		for (int i = 0; i < params.length; i++) {
			if (!isNotEmpty(params[i])) {
				return false;
			}
		}
		return true;
	}

	/**
	 * 检查字符串中是否有空字符串
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isNotEmpty(Object str) {
		if (str == null || "".equals(str) || "null".equals(str)) {
			return false;
		}
		return true;
	}
}
