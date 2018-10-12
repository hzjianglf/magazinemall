package cn.admin.consumer.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;



@Service
public class SpecialColumnService {

	
	@Autowired
	SqlSessionFactory sessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	
	//查询普通用户数量
	public long selConsumerCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("writerDao.selConsumerCount", reqMap);
	}
	//查询普通用户列表
	public List<Map<String, Object>> selConsumerList(Map<String, Object> reqMap) {
		return sqlSession.selectList("writerDao.selConsumerList", reqMap);
	}
	//删除用户
	public int deletes(Map<String, Object> map) {
		return sqlSession.update("writerDao.deletes", map);
	}
	//查询用户信息
	public Map<String, Object> selectUserInfoById(String userId) {
		return sqlSession.selectOne("writerDao.selectUserInfoById", userId);
	}
	//查询专家信息
	public Map<String, Object> selectWriterMsg(Map map) {
		return sqlSession.selectOne("writerDao.selectWriterMsg", map);
	}
	//查询导出数据
	public List<Map> selectDownload(Map map) {
		return sqlSession.selectList("writerDao.selectDownload", map);
	}

	
	
	
}
