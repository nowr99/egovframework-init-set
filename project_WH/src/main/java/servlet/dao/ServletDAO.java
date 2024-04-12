package servlet.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import servlet.dto.ServletDTO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<ServletDTO> sidoList() {
		return selectList("servlet.sidoList");
	}

	public List<ServletDTO> sggList(String sido) {
		return selectList("servlet.sggList", sido);
	}

	public List<ServletDTO> bjdList(String sgg) {
		return selectList("servlet.bjdList", sgg);
	}

	public List<Map<String, Object>> allselec() {
		return selectList("servlet.allselec");
	}

	public List<Map<String, Object>> siSelecChart(String sdCd1) {
		return selectList("servlet.siSelecChart", sdCd1);
	}

	public List<Map<String, Object>> siSelecTable(String sdCd1) {
		return selectList("servlet.siSelecChart", sdCd1);
	}

}
