package servlet.service;

import java.util.List;
import java.util.Map;

import servlet.dto.ServletDTO;

public interface ServletService {

	List<ServletDTO> sidoList();

	List<ServletDTO> sggList(String sido);

	List<ServletDTO> bjdList(String sgg);

	List<Map<String, Object>> allselec();

	List<Map<String, Object>> siSelecChart(String sdCd1);

	List<Map<String, Object>> siSelecTable(String sdCd1);
}
