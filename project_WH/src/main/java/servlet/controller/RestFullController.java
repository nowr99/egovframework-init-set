package servlet.controller;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import servlet.dto.ServletDTO;
import servlet.service.ServletService;

@RestController
public class RestFullController {
	
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	// 시도 선택 ajax 받기
		@RequestMapping (value = "/selectSido.do", method=RequestMethod.POST)
		public List<ServletDTO> selectSido(@RequestParam("sido") String sido) {
			System.out.println(sido);
			List<ServletDTO> list1 = new ArrayList<ServletDTO>();
			list1 = servletService.sggList(sido);
			
			return list1;
		}

	// 법정동 선택 ajax 받기
		@RequestMapping (value = "/selectSgg.do", method=RequestMethod.POST)
		public List<ServletDTO> selectSgg(@RequestParam("sgg") String sgg) {
			List<ServletDTO> list2 = new ArrayList<ServletDTO>();
			list2 = servletService.bjdList(sgg);
			
			return list2;
		}
		
}
