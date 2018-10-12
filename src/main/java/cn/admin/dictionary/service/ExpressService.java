package cn.admin.dictionary.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ExpressService {
	@Autowired
	SqlSession sqlSession;

	public long selectCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("expressAdminDao.selectCount",paramap);
	}

	public List selectContent(Map<String, Object> paramap) {
		return sqlSession.selectList("expressAdminDao.selectContent",paramap);
	}

	public int add(Map paramap) {
		return sqlSession.insert("expressAdminDao.add",paramap);
	}

	public int edit(Map paramap) {
		return sqlSession.update("expressAdminDao.edit",paramap);
	}

	public Map selById(String id) {
		return sqlSession.selectOne("expressAdminDao.selById",id);
	}

	public int deleteAll(Map map) {
		return sqlSession.delete("expressAdminDao.deleteAll", map);
	}

	public int updateStatus(Map map) {
		return sqlSession.update("expressAdminDao.updateStatus", map);
	}

	public int delete(Map map) {
		return sqlSession.delete("expressAdminDao.delete", map);
	}

	public int batchUpStatus(Map map) {
		return sqlSession.update("expressAdminDao.batchUpStatus", map);
	}

	public List selectDownLoad(Map map) {
		return sqlSession.selectList("classtypeDao.selectDownLoad", map);
	}
	
	
}
