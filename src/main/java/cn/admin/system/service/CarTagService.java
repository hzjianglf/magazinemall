package cn.admin.system.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
// 事务处理
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CarTagService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;

	/**
	 * 查询所有未删除的标签
	 * 
	 * @return
	 */
	public List<Map<String, Object>> getCarTagList(Map<String, Object> map) {
		return sqlSession.selectList("carTagDao.getCarTagList", map);
	}

	/**
	 * 查询未删除的标签总数
	 * 
	 * @param map
	 * @return
	 */
	public long getCount() {
		return sqlSession.selectOne("carTagDao.getCount");
	}

	/**
	 * 添加标签
	 * 
	 * @param contract
	 * @return
	 */
	public int addCarTag(Map<String, Object> map) {
		return sqlSession.insert("carTagDao.addCarTag", map);
	}

	/**
	 * 查询单个标签信息
	 * 
	 * @param id
	 * @return
	 */
	public Map<String, Object> selectCarTagById(int id) {
		return sqlSession.selectOne("carTagDao.selectCarTagById", id);
	}

	/**
	 * 修改标签
	 * 
	 * @param map
	 * @return
	 */
	public int updateCarTag(Map<String, Object> map) {
		return sqlSession.update("carTagDao.updateCarTag", map);
	}

	/**
	 * 删除标签，修改标签的删除状态为1
	 * 
	 * @param id
	 * @return
	 */
	public int deleteCarTag(int id) {
		return sqlSession.update("carTagDao.deleteCarTag", id);
	}

	/**
	 * 修改标签的启用禁用状态
	 * 
	 * @param map
	 * @return
	 */
	public int modifyStatus(Map<String, Object> map) {
		return sqlSession.update("carTagDao.modifyStatus", map);
	}

	/**
	 * 查询最后一个编号
	 * 
	 * @return
	 */
	public String getLastCode() {
		return sqlSession.selectOne("carTagDao.getLastCode");
	}

}
