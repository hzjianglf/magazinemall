package cn.admin.interlocution.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class MeetProfessorService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	//查询count
	public long selectCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("meetDao.selectCount", reqMap);
	}
	//查询列表
	public List<Map<String, Object>> selectList(Map<String, Object> reqMap) {
		return sqlSession.selectList("meetDao.selectList", reqMap);
	}
	//查询详情
	public Map<String, Object> findById(String id) {
		return sqlSession.selectOne("meetDao.findById", id);
	}
	//添加、修改
	public Map<String, Object> addOrUp(Map map) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = 0;
		if(!StringUtils.isEmpty(map.get("id"))){
			row = sqlSession.update("meetDao.updateMeet", map);
		}else{
			row = sqlSession.insert("meetDao.addMeet", map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "保存失败!");
		}
		return reqMap;
	}
	//删除
	public int delteMeet(Map map) {
		return sqlSession.delete("meetDao.delteMeet", map);
	}
	/**
	 * 查询所有专家
	 * @return
	 */
	public List selectTeacherAll() {
		return sqlSession.selectList("meetDao.selectTeacherAll");
	}
	/**
	 * 查询答疑分类
	 * @return
	 */
	public List selectlabels() {
		return sqlSession.selectList("meetDao.selectlabels");
	}
	
	
	
	
	
	
	
	
}
