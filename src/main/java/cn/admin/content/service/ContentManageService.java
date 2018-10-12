package cn.admin.content.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ContentManageService {
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;

	/**
	 * 查询某一栏目下的所有新闻总数
	 * 
	 * @param searchInfo
	 * @return
	 */
	@Transactional(readOnly = true)
	public long getTotalContentByCatId(Map<String, Object> searchInfo) {
		return sqlSession.selectOne("ContentManageDao.getTotalContentByCatId", searchInfo);
	}

	/**
	 * 查询某一栏目下的所有新闻
	 * 
	 * @param searchInfo
	 * @return
	 */
	@Transactional(readOnly = true)
	public List<Map<String, Object>> selContentByCatId(Map<String, Object> searchInfo) {
		return sqlSession.selectList("ContentManageDao.selContentByCatId", searchInfo);
	}

	/**
	 * 添加新闻
	 * 
	 * @param newsInfo
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int add(Map<String, Object> newsInfo) {
		int row = sqlSession.insert("ContentManageDao.addNewsInfo", newsInfo);
		return row;
	}

	/**
	 * 根据ID查询内容信息
	 * 
	 * @param contentId
	 * @return
	 */
	@Transactional(readOnly = true)
	public Map<String, Object> selectContentById(int contentId) {
		return sqlSession.selectOne("ContentManageDao.selectContentById", contentId);
	}

	/**
	 * 修改内容信息
	 * 
	 * @param contentInfo
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public int updateContent(Map<String, Object> contentInfo) {
		return sqlSession.update("ContentManageDao.updateContent", contentInfo);
	}

	/**
	 * 删除内容管理条目（假删除，更新isDelete的状态）
	 * 
	 * @param contentId
	 * @return
	 */
	@Transactional(rollbackFor = Exception.class)
	public Map<String, Object> updateContentStaus(Map<String, Object> map) {
		Map<String, Object> updateMapStatus = new HashMap<String, Object>();
		int row = sqlSession.delete("ContentManageDao.updateContentStaus", map);
		if (row > 0) {
			updateMapStatus.put("message", "删除成功");
		} else {
			updateMapStatus.put("message", "删除失败");
		}
		return updateMapStatus;
	}

	/**
	 * 查询内容回收站列表页
	 * 
	 * @param map
	 * @return
	 */
	@Transactional(readOnly = true)
	public List<Map<String, Object>> ContentRubbishList(Map<String, Object> map) {
		List<Map<String, Object>> list = sqlSession.selectList("ContentManageDao.selectContentRubbishList", map);
		return list;
	}

	/**
	 * 获取回收站列表总条数
	 * 
	 * @param searchInfo
	 * @return
	 */
	@Transactional(readOnly = true)
	public long getRubbishTotalCount(Map<String, Object> searchInfo) {
		return sqlSession.selectOne("ContentManageDao.countContentRubbish", searchInfo);
	}

	/**
	 * 彻底删除回收站中的内容信息
	 * 
	 * @param list
	 */
	@Transactional(rollbackFor = Exception.class)
	public int delRubbishInfo(List<String> list) {
		return sqlSession.delete("ContentManageDao.delRubbishInfo", list);
	}

	/**
	 * 从回收站中的还原选择
	 * 
	 * @param list
	 */
	@Transactional(rollbackFor = Exception.class)
	public int updateRubbishInfo(List<String> list) {
		return sqlSession.update("ContentManageDao.restoreContent", list);
	}

}
