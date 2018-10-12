package cn.template;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.servlet.ModelAndView;

public class TemplateInvoker {
	public static ModelAndView invoke(HttpServletRequest request,String view){
		ITemplate template = TemplateLoader.get(view);
		if (template!=null) {
			return template.invoke(request);
		}
		throw new NullPointerException("no template is found");
	}
}
