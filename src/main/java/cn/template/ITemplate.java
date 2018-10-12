package cn.template;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

public interface ITemplate {
	ModelAndView invoke(HttpServletRequest request);
}
