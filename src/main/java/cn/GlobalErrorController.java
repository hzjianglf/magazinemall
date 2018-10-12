package cn;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value="/error")
public class GlobalErrorController  {
	@RequestMapping(value="notallow")
	public String notAllow(){
		return "/error/notallow";
	}
	
	@RequestMapping(value="/{code}")
	public String index(@PathVariable String code){
		return "/error/exception";
	}
}
