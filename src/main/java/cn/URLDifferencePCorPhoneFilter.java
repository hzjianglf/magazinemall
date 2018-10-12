package cn;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.util.StringUtils;

public class URLDifferencePCorPhoneFilter implements Filter{
	
	// 后台配置修改
	public static String adminPrefix = "";

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		final HttpServletRequest hsRequest = (HttpServletRequest) request;
		final HttpServletResponse hsResponse = (HttpServletResponse) response;
		
		String userAgent = hsRequest.getHeader("user-agent");
		//获取域名
		//String domainURL = hsRequest.getServerName();
		//获取路径	
		String requestURL = hsRequest.getRequestURI();

		/*if(domainURL.equals("localhost") && requestURL.toString().equals("/")) {
			hsResponse.sendRedirect("/home/index");
		}*/
		
		String forwardUri = requestURL.toString();
		boolean flg = isNotAdmin(forwardUri);
		if(flg) {
			if (userAgent.indexOf("Android") != -1) {
				forwardUri = getForwareUri("/phone",requestURL);
			} else if (userAgent.indexOf("iPhone") != -1 || userAgent.indexOf("iPad") != -1) {
				forwardUri = getForwareUri("/phone",requestURL);
			}else {
				forwardUri = getForwareUri("/web",requestURL);
			}
			if(forwardUri == null) {
				chain.doFilter(hsRequest, hsResponse);
			}else {
				if(forwardUri.lastIndexOf("/web") != -1 || forwardUri.lastIndexOf("/phone") != -1) {
					final RequestDispatcher dispatcher = request.getRequestDispatcher(forwardUri);
					dispatcher.forward(hsRequest, hsResponse);
				}else {
					chain.doFilter(hsRequest, hsResponse);
				}
			}
		}else {
			chain.doFilter(hsRequest, hsResponse);
		}
	}
	
	private String getForwareUri( String param , String rul ) {

		if (!rul.startsWith(param)) {
			return param + rul;
		}else if( rul.lastIndexOf(param) == -1){
			return null;
		}
		return rul.replaceFirst(param, "");
	}
	
	public boolean isNotAdmin( String url ) {
		boolean flg = false;
		
		boolean isnull= (url.equals("/"));
		boolean isAdmin = (url.startsWith("/admin"));
		boolean isGetUrl = (url.startsWith("/"+adminPrefix));
		//boolean isLogin = (url.startsWith("/login"));
		boolean isManage = (url.startsWith("/manage"));
		boolean isCode = (url.startsWith("/code"));
		boolean isUpdate = (url.startsWith("/upload"));
		boolean isswagger = (url.startsWith("/swagger"));
		boolean isv2 = (url.startsWith("/v2"));
		boolean isapi = (url.startsWith("/api"));
		boolean isDocumentPic = (url.startsWith("/DocumentPic"));
		boolean wechat = (url.startsWith("/wechat"));
		boolean MP = (url.startsWith("/MP_verify_N4LeicC2Vmd3hPTt"));
		if(!isAdmin && !isGetUrl && !isManage &&
				!isCode && !isUpdate && !isswagger
				&& !isv2 && !isapi && !isDocumentPic && !isnull && !wechat && !MP) {
			flg = true;
		}
		
		return flg;
	}

	@Override
	public void destroy() {
		
	}

}
