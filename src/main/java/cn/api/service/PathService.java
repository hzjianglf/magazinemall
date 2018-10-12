package cn.api.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.util.DataConvert;
import cn.util.StringHelper;

/**
 * 路径转换
 * @author xiaoxueling
 *
 */
@Service
public class PathService {

	@Autowired
	Setting setting;

	/**
	 * 获取本站的绝对路径
	 * @param relativePath 相对路径(以 "/upload/"开头)
	 * @return
	 */
	public String getAbsolutePath(String relativePath) {
		String absolutePath=HtmlUtils.htmlUnescape(relativePath);
		try {
			
			if(!StringHelper.IsNullOrEmpty(relativePath)) {
				SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
				if(siteInfo!=null) {
					//开头
					if(relativePath.startsWith("/upload/")) {
						absolutePath=siteInfo.getSiteUrl()+relativePath;
					}
					//内容包含 /upload/ 期刊自己上传的
					if(relativePath.contains("\"/upload/")) {
						absolutePath=relativePath.replaceAll("\"/upload/", "\""+siteInfo.getSiteUrl()+"/upload/");
					}
					//内容包含 /DocumentPic/ 电子书
					if(relativePath.contains("\"../DocumentPic/")) {
						absolutePath=relativePath.replaceAll("\"../DocumentPic/", "\""+siteInfo.getSiteUrl()+"/DocumentPic/");
					}
					//图片路劲
					if(relativePath.contains("DocPic")) {
						absolutePath=siteInfo.getSiteUrl()+"/DocumentPic/";
					}
					//分享地址
					if(relativePath.contains("sharedAddress")) {
						absolutePath=siteInfo.getSiteUrl();
					}
				}
			}
		} catch (Exception e) {
		}
		return  absolutePath;
	}
	
	/**
	 * 转换相对路径为绝对路径
	 * @param dataMap 数据
	 * @param pathKey 需要转换的key,可多个
	 */
	public void getAbsolutePath(Map<String, Object>dataMap,String... pathKey) {
		
		if(dataMap!=null&&pathKey!=null) {
			for (String key : pathKey) {
				if(dataMap.containsKey(key)) {
					dataMap.put(key,getAbsolutePath(DataConvert.ToString(dataMap.get(key))));
				}
			}
		}
	}
	
	/**
	 * 转换相对路径为绝对路径
	 * @param list 数据
	 * @param pathKey 需要转换的key,可多个
	 */
	public void getAbsolutePath(List<Map<String,Object>>list,String... pathKey) {
		if(list!=null&&!list.isEmpty()&&pathKey!=null&&pathKey.length>0) {
			list.parallelStream().forEach(f->{
				getAbsolutePath(f, pathKey);
			});
		}
	}
}
