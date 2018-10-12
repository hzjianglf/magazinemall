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

public class AdminRewriteFilter implements Filter {
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

		String requestUri = hsRequest.getRequestURI();
		if (StringUtils.isEmpty(adminPrefix)) {
			chain.doFilter(hsRequest, hsResponse);
			return;
		}
		if (requestUri.toLowerCase().startsWith("/admin/")) {
			throw new ServletException();
		}

		String forwardUri = getForwareUri(requestUri);
		if (StringUtils.isEmpty(forwardUri)) {
			chain.doFilter(hsRequest, hsResponse);
		} else {
			final RequestDispatcher dispatcher = request.getRequestDispatcher(forwardUri);
			dispatcher.forward(hsRequest, hsResponse);
		}
	}

	private String getForwareUri(String requestUri) {

		if (StringUtils.isEmpty(adminPrefix)) {
			return null;
		}
		String checkPrefix = "/" + adminPrefix + "/";
		if (requestUri.startsWith(checkPrefix)) {
			return requestUri.replaceFirst(checkPrefix, "/admin/");
		}
		return null;
	}

	@Override
	public void destroy() {

	}

}
