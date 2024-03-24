package servlet.impl;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.dto.ServletDTO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<ServletDTO> sidoList() {
		return selectList("servlet.sidoList");
	}

	public List<ServletDTO> sggList(String sido) {
		return selectList("servlet.sggList", sido);
	}

	public List<ServletDTO> bjdList(String sgg) {
		return selectList("servlet.bjdList", sgg);
	}

}
