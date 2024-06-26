package servlet.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.dto.ServletDTO;
import servlet.service.ServletService;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;

	@RequestMapping(value = "/main.do", method = RequestMethod.GET)
	public String main() throws Exception {
		
		return "main/main";
	}

	@RequestMapping(value = "/test.do")
	public String main1(Model model) throws Exception {
		List<ServletDTO> list = new ArrayList<ServletDTO>();
		list = servletService.sidoList();
		model.addAttribute("list", list);
		return "main/test";
	}

	@RequestMapping(value = "/upLoad.do", method = RequestMethod.GET)
	public String upLoad() {

		return "main/upLoad";
	}
	
	@RequestMapping(value = "/mapp.do", method = RequestMethod.GET)
	public String mapp(Model model) throws Exception {
		List<ServletDTO> list = new ArrayList<ServletDTO>();
		list = servletService.sidoList();
		model.addAttribute("list", list);
		return "main/mapp";
	}
}
