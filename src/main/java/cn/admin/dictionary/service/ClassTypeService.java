package cn.admin.dictionary.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ClassTypeService {

	
	@Autowired
	SqlSessionFactory sessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	
	/**
	 * 查询分类count
	 * @param reqMap
	 * @return
	 */
	public long selectClasstypeCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("classtypeDao.selectClasstypeCount", reqMap);
	}
	/**
	 * 查询分类列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selectClasstypeList(Map<String, Object> reqMap) {
		return sqlSession.selectList("classtypeDao.selectClasstypeList", reqMap);
	}
	/**
	 * 禁用启用
	 * @param map
	 * @return
	 */
	public int updateStatus(Map map) {
		return sqlSession.update("classtypeDao.updateStatus", map);
	}
	/**
	 * 批量启用禁用
	 * @param map
	 * @return
	 */
	public int batchUpStatus(Map map) {
		return sqlSession.update("classtypeDao.batchUpStatus", map);
	}
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	public int delete(Map map) {
		return sqlSession.delete("classtypeDao.delete", map);
	}
	/**
	 * 批量删除
	 * @param map
	 * @return
	 */
	public int deleteAll(Map map) {
		return sqlSession.delete("classtypeDao.deleteAll", map);
	}
	/**
	 * 查询分类
	 * @param map
	 * @return
	 */
	public List selectTypelist(Map map) {
		return sqlSession.selectList("classtypeDao.selectTypelist", map);
	}
	/**
	 * 根据id查询详情
	 * @param map
	 * @return
	 */
	public Map findById(Map map) {
		return sqlSession.selectOne("classtypeDao.findById", map);
	}
	/**
	 * 编辑
	 * @param map
	 * @return
	 */
	public int updateMsg(Map map) {
		return sqlSession.update("classtypeDao.updateMsg", map);
	}
	/**
	 * 新增
	 * @param map
	 * @return
	 */
	public int addMsg(Map map) {
		return sqlSession.insert("classtypeDao.addMsg", map);
	}
	/**
	 * 查询导出数据
	 * @param map
	 * @return
	 */
	public List selectDownLoad(Map map) {
		return sqlSession.selectList("classtypeDao.selectDownLoad", map);
	}
	/**
	 * 根据类型查询课程分类数据
	 * @param name
	 * @return
	 */
	public List selClassTypeByName(Integer type){
		return sqlSession.selectList("classtypeDao.selClassTypeByName", type);
	}
	
	
	
	
}
