package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.web.bind.annotation.PostMapping;
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

	@PostMapping("/fileUpload.do")
	public void fileUpload(@RequestParam("testfile") MultipartFile multi) throws IOException {

		System.out.println(multi.getOriginalFilename());
		System.out.println(multi.getName());
		System.out.println(multi.getContentType());
		System.out.println(multi.getSize());

		fileService.deleteTable();
		
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

		InputStreamReader isr = new InputStreamReader(multi.getInputStream());
		BufferedReader br = new BufferedReader(isr);

		String line = null;
		while ((line = br.readLine()) != null) {
			Map<String, Object> m = new HashMap<String, Object>();
			String[] lineArr = line.split("\\|");
			System.out.println(Arrays.toString(lineArr));
			m.put("year_month", lineArr[0]); // 사용년월
			m.put("site_lo", lineArr[1]); // 대지위치
			m.put("road_site_lo", lineArr[2]); // 도로명대지위치
			m.put("sgg_cd", lineArr[3]); // 시군구코드
			m.put("bjd_cd", lineArr[4]); // 법정동코드
			m.put("site_div_cd", lineArr[5]); // 대지구분코드
			m.put("bun", lineArr[6]); // 번
			m.put("ji", lineArr[7]); // 지
			m.put("new_addr_no", lineArr[8]); // 새주소일련번호
			m.put("new_addr_road_cd", lineArr[9]); // 새주소도로코드
			m.put("new_addr_under_cd", lineArr[10]);// 새주소지상지하코드
			m.put("new_addr_main_no", !lineArr[11].isEmpty() ? Integer.parseInt(lineArr[11]) : 0); // 새주소본번
			m.put("new_addr_sub_no", !lineArr[12].isEmpty() ? Integer.parseInt(lineArr[12]) : 0); // 새주소부번
			m.put("used_khw", !lineArr[13].isEmpty() ? Integer.parseInt(lineArr[13]) : 0); // 사용량

			list.add(m);
		}
		fileService.uploadFile(list);

		br.close();
		isr.close();

	}
}