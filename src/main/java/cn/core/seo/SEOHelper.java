package cn.core.seo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.util.StringHelper;

@Component
public class SEOHelper {

	static Setting setting;
	static SEOContext seo;
	static int count;
	
	@Autowired
	public SEOHelper(Setting setting){
		this.setting=setting;
	}
	
	public static void Seo(SEOContext context){

		if(context==null){
			context=new SEOContext();
		}
		
		SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
		if(StringHelper.IsNullOrEmpty(context.getTitle())){
			context.setTitle(siteInfo.getSiteTitle());
		}
		if(StringHelper.IsNullOrEmpty(context.getMetaKeywords())){
			context.setMetaKeywords(siteInfo.getMetaKeywords());
		}
		if(StringHelper.IsNullOrEmpty(context.getMetaDescription())){
			context.setMetaDescription(siteInfo.getMetaDescription());
		}
		count=0;
		seo=context;
	}
	
	public  SEOContext getSEO() {
		if(count>0||seo==null){
			Seo(null);
		}else{
			count++;
		}
		return seo;
	}
}
