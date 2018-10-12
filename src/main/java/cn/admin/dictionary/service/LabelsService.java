package cn.admin.dictionary.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LabelsService {

	@Autowired
	SqlSessionFactory sessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	/**
	 * 查询标签列表count
	 * @param reqMap
	 * @return
	 */
	public long selLabelsCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("labelsDao.selLabelsCount", reqMap);
	}
	/**
	 * 查询标签列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selectLabelsList(Map<String, Object> reqMap) {
		return sqlSession.selectList("labelsDao.selectLabelsList", reqMap);
	}
	/**
	 * 删除标签
	 * @param map
	 * @return
	 */
	public int deleteLabel(Map map) {
		return sqlSession.delete("labelsDao.deleteLabel",map);
	}
	/**
	 * 批量删除标签
	 * @param map
	 * @return
	 */
	public int deleteLabelByids(Map map) {
		return sqlSession.delete("labelsDao.deleteLabelByids", map);
	}
	/**
	 * 启用、禁用标签
	 * @param map
	 * @return
	 */
	public int updateStatus(Map map) {
		return sqlSession.update("labelsDao.updateStatus", map);
	}
	/**
	 * 批量启用禁用
	 * @param map
	 * @return
	 */
	public int batchUpStatus(Map map) {
		return sqlSession.update("labelsDao.batchUpStatus", map);
	}
	/**
	 * 根据id查询标签详情
	 * @param map
	 * @return
	 */
	public Map<String, Object> findById(Map map) {
		return sqlSession.selectOne("labelsDao.findById", map);
	}
	/**
	 * 新增标签
	 * @param map
	 * @return
	 */
	public int addLabel(Map map) {
		return sqlSession.insert("labelsDao.addLabel", map);
	}
	/**
	 * 编辑标签
	 * @param map
	 * @return
	 */
	public int updateLabel(Map map) {
		return sqlSession.update("labelsDao.updateLabel", map);
	}
	/**
	 * 查询导出数据
	 * @param map
	 * @return
	 */
	public List selectDownLoad(Map map) {
		return sqlSession.selectList("labelsDao.selectDownLoad", map);
	}
	/**
	 * 根据类型查询标签
	 */
	public List findLabelBytype(String type){
		return sqlSession.selectList("labelsDao.findLabelBytype", type);
	}
	 
}
