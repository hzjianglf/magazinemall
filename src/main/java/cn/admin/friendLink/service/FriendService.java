package cn.admin.friendLink.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FriendService {

	@Autowired
	SqlSessionFactory sqlsessionfactory;
	@Autowired
	SqlSession sqlsession;
	public List<Map<String,Object>> selectLink(Map<String, Object> map) {
		return sqlsession.selectList("linkDao.selLink",map);
	}
	public long getTotalCount() {
		return sqlsession.selectOne("linkDao.countLink");
	}
	public Integer add(Map<String, Object> map) {
		return sqlsession.insert("linkDao.inseLink",map);
		
	}
	public Integer delete(int Id) {
		return sqlsession.delete("linkDao.deleteLinkId",Id);
		
	}
	public Integer delLink(List delList) {
		return sqlsession.delete("linkDao.delLinkId",delList);
		
	}
	public Integer updLink(List delList) {
		return sqlsession.update("linkDao.updLinkId",delList);
		
	}
	public Integer updLink2(List delList) {
		return sqlsession.update("linkDao.updLinkId2",delList);
		
	}
	
	public Map<String,Object> selId(int Id) {
		Map<String,Object> map=sqlsession.selectOne("linkDao.selId", Id);
		return map;
	}
	public Integer  update(Map<String, Object> map) {
		return sqlsession.update("linkDao.update",map);
	}
}
