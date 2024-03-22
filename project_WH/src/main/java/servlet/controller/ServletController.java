package servlet.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@RequestMapping(value = "/main.do")
	public String main() throws Exception {
		
		return "main/main";
	}

	@RequestMapping(value = "/test.do")
	public String test() {
		return "main/test";
	}
}
