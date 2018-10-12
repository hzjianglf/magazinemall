package cn.admin.divisionAccounts.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DivisionExamineService {

	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	/**
	 * 审核列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selectExamineList(Map<String, Object> reqMap) {
		return sqlSession.selectList("examineDao.selectExamineList", reqMap);
	}
	/**
	 * 审核count
	 */
	public long selectExamineCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("examineDao.selectExamineCount", reqMap);
	}
	/**
	 * 审核
	 * @param map
	 * @return
	 */
	public int updateExamineResult(Map<String, Object> map) {
		return sqlSession.update("examineDao.updateExamineResult", map);
	}
	
	/**
	 * @param id
	 */
	public Map<String,Object> selOpinion(Map<String,Object> map){
		return sqlSession.selectOne("examineDao.selOpinion",map);
	}
	
	
}
