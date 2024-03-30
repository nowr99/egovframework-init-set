package servlet.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import servlet.dao.FileDAO;

@Service("FileService")
public class FileServiceImpl implements FileService {

	@Autowired
	private FileDAO fileDAO;

	@Override
	public void deleteTable() {
		fileDAO.deleteTable();
	}

	@Override
	public int uploadFile(MultipartFile multi) {

		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		int result = 0;

		try {
			InputStreamReader isr = new InputStreamReader(multi.getInputStream());
			BufferedReader br = new BufferedReader(isr);
			String line = null;
			int i = 0;

			while ((line = br.readLine()) != null) {
				if (i == 15000) {
					fileDAO.uploadFile(list);
					list.clear();
					i = 0;
				}
				if (result == 2100000) {
					break;
				}

				// 필요 없는 항목 주석처리하여 처리 속도 향상시키기
				Map<String, Object> map = new HashMap<String, Object>();
				String[] lineArr = line.split("\\|");

				map.put("year_month", lineArr[0]); // 사용년월
				// map.put("site_lo", lineArr[1]); // 대지위치
				// map.put("road_site_lo", lineArr[2]); // 도로명대지위치
				map.put("sgg_cd", lineArr[3]); // 시군구코드
				map.put("bjd_cd", lineArr[4]); // 법정동코드
				// map.put("site_div_cd", lineArr[5]); // 대지구분코드
				// map.put("bun", lineArr[6]); // 번
				// map.put("ji", lineArr[7]); // 지
				// map.put("new_addr_no", lineArr[8]); // 새주소일련번호
				// map.put("new_addr_road_cd", lineArr[9]); // 새주소도로코드
				// map.put("new_addr_under_cd", lineArr[10]);// 새주소지상지하코드
				// map.put("new_addr_main_no", !lineArr[11].isEmpty() ?
				// Integer.parseInt(lineArr[11]) : 0); // 새주소본번
				// map.put("new_addr_sub_no", !lineArr[12].isEmpty() ?
				// Integer.parseInt(lineArr[12]) : 0); // 새주소부번
				map.put("used_khw", !lineArr[13].isEmpty() ? Integer.parseInt(lineArr[13]) : 0); // 사용량

				list.add(map);
				i++;
				result++;

			}
			br.close();
			isr.close();

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (list.size() != 0) {
				fileDAO.uploadFile(list);
			}
		}
		return result;
	}

	@Override
	public void updateTable() {
		fileDAO.updateTable();
	}

}
