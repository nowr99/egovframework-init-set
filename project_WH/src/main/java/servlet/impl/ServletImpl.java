package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.dao.ServletDAO;
import servlet.dto.ServletDTO;
import servlet.service.ServletService;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	

	@Override
	public List<ServletDTO> sidoList() {
		return dao.sidoList();
	}

	@Override
	public List<ServletDTO> sggList(String sido) {
		return dao.sggList(sido);
	}

	@Override
	public List<ServletDTO> bjdList(String sgg) {
		return dao.bjdList(sgg);
	}

	@Override
	public List<Map<String, Object>> allselec() {
		return dao.allselec();
	}

	@Override
	public List<Map<String, Object>> siSelecChart(String sdCd1) {
		return dao.siSelecChart(sdCd1);
	}

	@Override
	public List<Map<String, Object>> siSelecTable(String sdCd1) {
		return dao.siSelecTable(sdCd1);
	}

}
