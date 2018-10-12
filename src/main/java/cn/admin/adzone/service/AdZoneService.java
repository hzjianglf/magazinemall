package cn.admin.adzone.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdZoneService {
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 获取广告位总数
	 */
	public long countAdZoneList() {
		return sqlSession.selectOne("adZoneDao.countAdZoneList");
	}
	
	/**
	 * 获取广告位列表
	 */
	public List<Map<String, Object>> selectAdZoneList(Map<String, Object> map) {
		return sqlSession.selectList("adZoneDao.selectAdZoneList",map);
	}
	
	/**
	 * 添加广告位
	 */
	public int addAdZone(Map<String, Object> map) {
		
		return sqlSession.insert("adZoneDao.addAdZone",map);
	}
	
	/**
	 * 广告位详情
	 */
	public Map<String, Object> getAdZoneDetail(String zoneID) {
		return sqlSession.selectOne("adZoneDao.getAdZoneDetail",zoneID);
	}
	
	/**
	 * 编辑广告位
	 */
	public int updateAdZone(Map<String, Object> parMap) {
		return sqlSession.update("adZoneDao.updateAdZone",parMap);
	}
	
	/***
	 * 更新广告位状态
	 */
	public int updateAdZoneStatus(Map<String, Object> map) {
		return sqlSession.update("adZoneDao.updateAdZoneStatus",map);
	}
	
}