package servlet.service;

import java.util.List;

import servlet.dto.ServletDTO;

public interface ServletService {

	List<ServletDTO> sidoList();

	List<ServletDTO> sggList(String sido);

	List<ServletDTO> bjdList(String sgg);
}
