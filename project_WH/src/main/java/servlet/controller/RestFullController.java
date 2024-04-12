package servlet.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import servlet.dto.ServletDTO;
import servlet.service.FileService;
import servlet.service.ServletService;

@RestController
public class RestFullController {

	@Resource(name = "ServletService")
	private ServletService servletService;

	@Resource(name = "FileService")
	private FileService fileService;

	// 시도 선택 ajax 받기
	@RequestMapping(value = "/selectSido.do", method = RequestMethod.POST)
	public List<ServletDTO> selectSido(@RequestParam("sido") String sido) {
		System.err.println(sido);
		List<ServletDTO> list1 = new ArrayList<ServletDTO>();
		list1 = servletService.sggList(sido);

		return list1;
	}

	// 법정동 선택 ajax 받기
	@RequestMapping(value = "/selectSgg.do", method = RequestMethod.POST)
	public List<ServletDTO> selectSgg(@RequestParam("sgg") String sgg) {
		List<ServletDTO> list2 = new ArrayList<ServletDTO>();
		list2 = servletService.bjdList(sgg);

		return list2;
	}

	// 파일업로드
	@RequestMapping(value = "/fileUpload.do", method = RequestMethod.POST)
	public String fileUpload(@RequestParam("file") MultipartFile multi) throws IOException {

		fileService.deleteTable();
		int result = fileService.uploadFile(multi);
		fileService.updateTable();
		return String.valueOf(result);
	}

	///// 통계
	// 전체 선택 (allSelected)
	@RequestMapping(value = "/allSelec.do", method = RequestMethod.POST)
	public List<Map<String, Object>> allSelected() {
		System.out.println("@@@@@@@@@@@@@@@@@@@@");
		List<Map<String, Object>> allselec = servletService.allselec();
		System.out.println(allselec);
		return allselec;
	}

	// 시 선택 (siSelec)
	@RequestMapping(value = "/siSelecChart.do", method = RequestMethod.POST)
	public List<Map<String, Object>> drawChart(@RequestParam("sdCd1") String sdCd1, Model model) {

		List<Map<String, Object>> siSelecChart = servletService.siSelecChart(sdCd1);
		model.addAttribute("siSelecChart", siSelecChart);
		System.out.println(siSelecChart);
		return siSelecChart;
	}

	// 시 선택 (siSelec) _ table
	@RequestMapping(value = "/siSelecTable.do", method = RequestMethod.POST)
	public List<Map<String, Object>> drawTable(@RequestParam("sdCd1") String sdCd1, Model model) {

		List<Map<String, Object>> siSelecTable = servletService.siSelecTable(sdCd1);
		model.addAttribute("siSelecTable", siSelecTable);
		System.out.println(siSelecTable);
		return siSelecTable;
	}

}
