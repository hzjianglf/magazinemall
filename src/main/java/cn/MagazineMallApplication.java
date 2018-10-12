package cn;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.DispatcherType;
import javax.servlet.MultipartConfigElement;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.FilterRegistrationBean;
import org.springframework.boot.context.embedded.ServletRegistrationBean;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import cn.core.StaticHtmlInterceptor;
import cn.Setting.Setting;
import cn.Setting.Model.AdminPreFixSetting;
import cn.Setting.Model.SiteInfo;
import cn.core.AuthorizeInterceptor;
import cn.core.JSSDKInterceptor;
import cn.core.ModelTraceProcessor;
import cn.core.SignInterceptor;
import cn.core.UploadServlet;
import cn.core.UserSecurityInterceptor;
import cn.core.UserValidate.PlatForm;
import cn.core.UserValidateInterceptor;
import cn.core.WxSessionInterceptor;
import cn.core.seo.SEOContext;
import cn.core.seo.SEOHelper;
import cn.core.seo.SEOInterceptor;
import cn.phone.wechat.service.wechatConfig;
import cn.phone.wechat.service.wechatService;
import cn.util.StringHelper;

@Configuration
@EnableAutoConfiguration
@EnableScheduling // 定时任务
@ServletComponentScan
@SpringBootApplication
@MapperScan("cn.dao")
@EnableTransactionManagement
public class MagazineMallApplication extends WebMvcConfigurerAdapter {
	
	private final static  String securityKey="qfsdfsdfasd";
	
	@Autowired
	Setting setting;
	@Autowired
	WebApplicationContext webApplicationContext;
	@Autowired
	wechatService wechatService;
	@Autowired
	wechatConfig wechatConfig;
	
	@Autowired
	SEOHelper seoHelper;
	
	public static void main(String args[]) throws InterruptedException {
		SpringApplication.run(MagazineMallApplication.class);
	}
	@Bean
	public FilterRegistrationBean filterRegistrationBean() {
		FilterRegistrationBean registrationBean = new FilterRegistrationBean();
		AdminRewriteFilter adminRewriteFilter = new AdminRewriteFilter();
		registrationBean.setFilter(adminRewriteFilter);
		List<String> urlPatterns = new ArrayList<String>();
		urlPatterns.add("/*");
		registrationBean.setUrlPatterns(urlPatterns);
		registrationBean.setDispatcherTypes(DispatcherType.REQUEST);
		return registrationBean;
	}
	
	@Bean
	public FilterRegistrationBean filterInterceptBean() {
		FilterRegistrationBean registrationBean = new FilterRegistrationBean();
		URLDifferencePCorPhoneFilter urlDifferencePCorPhoneFilter = new URLDifferencePCorPhoneFilter();
		registrationBean.setFilter(urlDifferencePCorPhoneFilter);
		List<String> urlPatterns = new ArrayList<String>();
		urlPatterns.add("/*");
		registrationBean.setUrlPatterns(urlPatterns);
		registrationBean.setDispatcherTypes(DispatcherType.REQUEST);
		return registrationBean;
	}

	@Bean
	public ServletRegistrationBean servletRegistrationBean() {
		ServletRegistrationBean bean = new ServletRegistrationBean(new UploadServlet(), "/uploader");
		bean.setMultipartConfig(new MultipartConfigElement(""));
		return bean;
	}

	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		super.addArgumentResolvers(argumentResolvers);
		argumentResolvers.add(new ModelTraceProcessor());
	}

	@Bean
	MappingJackson2HttpMessageConverter converter() {
		// Set HTTP Message converter using a JSON implementation.
		MappingJackson2HttpMessageConverter jsonMessageConverter = new MappingJackson2HttpMessageConverter();

		// Add supported media type returned by BI API.
		List<MediaType> supportedMediaTypes = new ArrayList<MediaType>();
		supportedMediaTypes.add(new MediaType("text", "json"));
		supportedMediaTypes.add(new MediaType("application", "json"));
		jsonMessageConverter.setSupportedMediaTypes(supportedMediaTypes);

		return jsonMessageConverter;
	}

	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		String root = System.getProperty("user.dir");
		registry.addResourceHandler("/upload/**").addResourceLocations("file:" + root + "\\upload\\");
		registry.addResourceHandler("/DocumentPic/**").addResourceLocations("file:" + root + "\\DocumentPic\\");
		super.addResourceHandlers(registry);
	}

	/**
	 * 配置安全拦截器
	 * 
	 * @param registry
	 */
	public void addInterceptors(InterceptorRegistry registry) {
		AdminPreFixSetting adminPreFix = setting.getSetting(AdminPreFixSetting.class);
		if (adminPreFix != null) {
			AdminRewriteFilter.adminPrefix = adminPreFix.getAdminUrl();
			URLDifferencePCorPhoneFilter.adminPrefix = adminPreFix.getAdminUrl();
			webApplicationContext.getServletContext().setAttribute("adminprefix", adminPreFix.getAdminUrl());
		}
		
		// 后台管理端拦劫器
		registry.addInterceptor(new UserSecurityInterceptor("admin","loginUser")).addPathPatterns("/admin/**").excludePathPatterns("/admin/login/**");
		
		//前台PC端拦截器
	    registry.addInterceptor(new UserValidateInterceptor(PlatForm.PC)).addPathPatterns("/web/**");
		
	    //微信端拦截器
	  	registry.addInterceptor(new WxSessionInterceptor(wechatService,wechatConfig)).addPathPatterns("/phone/**").excludePathPatterns("/phone/allow/**");
	  			
	  	//前台手机端拦截器
	    registry.addInterceptor(new UserValidateInterceptor(PlatForm.Mobile)).addPathPatterns("/phone/**");
		
		// 后台权限验证
		registry.addInterceptor(new AuthorizeInterceptor()).excludePathPatterns("/admin/login/**,/").excludePathPatterns("/error/**");
		
		//接口验证
		registry.addInterceptor(new SignInterceptor(securityKey)).addPathPatterns("/api/**");
		
		//JSSDK
		registry.addInterceptor(new JSSDKInterceptor(wechatConfig)).addPathPatterns("");
		
		//StaticHtml
		registry.addInterceptor(new StaticHtmlInterceptor());
		
		//SEO
		registry.addInterceptor(new SEOInterceptor(seoHelper)).excludePathPatterns("/api/**","/error/**");
	}

	/**
	 * 视图解析器
	 */
	public void addViewControllers(ViewControllerRegistry registry) {
		AdminPreFixSetting adminPreFix = setting.getSetting(AdminPreFixSetting.class);
		if(!StringHelper.IsNullOrEmpty(adminPreFix.getAdminUrl())){
			
			String loginUrl="/"+adminPreFix.getAdminUrl()+"/login";
		
			registry.addRedirectViewController("/login",loginUrl);
			registry.addRedirectViewController("/admin",loginUrl);
			registry.addRedirectViewController("/"+adminPreFix.getAdminUrl(), loginUrl);
		}
		registry.addRedirectViewController("/web","/home/index");
		registry.addRedirectViewController("/","/home/index");
		registry.addRedirectViewController("/phone","/home/index");
		super.addViewControllers(registry);
	}
}
