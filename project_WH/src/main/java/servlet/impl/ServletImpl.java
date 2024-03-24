package servlet.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.dto.ServletDTO;
import servlet.service.ServletService;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}

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

}
