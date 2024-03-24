package servlet.service;

import java.util.List;

import servlet.dto.ServletDTO;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<ServletDTO> sidoList();

	List<ServletDTO> sggList(String sido);

	List<ServletDTO> bjdList(String sgg);
}
