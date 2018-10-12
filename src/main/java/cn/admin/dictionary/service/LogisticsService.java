package cn.admin.dictionary.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class LogisticsService {
	@Autowired
	SqlSession sqlSession;

	public long selCount() {
		return sqlSession.selectOne("logisticsDao.selCount");
	}

	public List selectContent(Map<String, Object> paramap) {
		return sqlSession.selectList("logisticsDao.selList",paramap);
	}

	public int add(Map paramap) {
		if("1".equals(paramap.get("isDefault")+"")){
			sqlSession.update("logisticsDao.updIsDefault",paramap);
		}
		return sqlSession.insert("logisticsDao.add",paramap);
	}

	public int edit(Map paramap) {
		if("1".equals(paramap.get("isDefault")+"")){
			sqlSession.update("logisticsDao.updIsDefault",paramap);
		}
		return sqlSession.update("logisticsDao.edit",paramap);
	}

	public Map selById(String id) {
		return sqlSession.selectOne("logisticsDao.selById",id);
	}

	public int delete(Map map) {
		return sqlSession.update("logisticsDao.delete", map);
	}
	
}
