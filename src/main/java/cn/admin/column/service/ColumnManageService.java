package cn.admin.column.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ColumnManageService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;

	/**
	 * 查询所有菜单数据列表
	 * 
	 * @return
	 */
	public List<Map<String, Object>> ColumnList() {
		List<Map<String, Object>> list = sqlSession.selectList("ColumnManageDao.selectColumnList");
		return list;
	}

	/**
	 * 添加栏目信息
	 * 
	 * @param columnInfo
	 * @return
	 */
	public Map<String, Object> add(Map<String, Object> columnInfo) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 添加之前先查询栏目名称是否存在
		Map<String, Object> catId = sqlSession.selectOne("ColumnManageDao.getCatIdByName", columnInfo);
		if (catId != null) {
			map.put("success", false);
			map.put("msg", "该栏目名已存在!");
		}
		// 获得最大排序号
		Map<String, Object> orderIndex = sqlSession.selectOne("ColumnManageDao.getMaxOrderIndex");
		orderIndex.put("orderIndex", Integer.parseInt(orderIndex.get("orderIndex").toString()) + 1);
		columnInfo.putAll(orderIndex);
		int row = sqlSession.insert("ColumnManageDao.addColumnInformation", columnInfo);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "添加成功!");
		} else {
			map.put("success", false);
			map.put("msg", "添加失败!");
		}
		return map;
	}

	/**
	 * 根据Id查询栏目信息
	 * 
	 * @param catId
	 * @return
	 */
	public Map<String, Object> selectColumnById(int catId) {
		return sqlSession.selectOne("ColumnManageDao.selectColumnById", catId);
	}

	/**
	 * 修改栏目信息
	 * 
	 * @param columnInfo
	 * @return
	 */
	public Map<String, Object> updateColumn(Map<String, Object> columnInfo) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 修改之前先查询除他本身意外，要修改栏目名称是否存在
		Map<String, Object> catId = sqlSession.selectOne("ColumnManageDao.getCatIdByName", columnInfo);
		if (catId != null) {
			map.put("success", false);
			map.put("msg", "该栏目名已存在!");
		}
		int row = sqlSession.update("ColumnManageDao.updateColumn", columnInfo);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "修改成功!");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败!");
		}
		return map;
	}

	/**
	 * 删除栏目
	 * 
	 * @param catId
	 * @return
	 */
	public Map<String, Object> delColumn(int catId) {
		Map<String, Object> delMap = new HashMap<String, Object>();
		int row = sqlSession.delete("ColumnManageDao.delColumnInfo", catId);
		if (row > 0) {
			delMap.put("message", "删除成功");
		} else {
			delMap.put("message", "删除失败");
		}
		return delMap;
	}

	/**
	 * 移动栏目，更改parentId
	 * 
	 * @param parentIdInfo
	 * @return
	 */
	public int updateParentId(Map<String, Object> parentIdInfo) {
		return sqlSession.update("ColumnManageDao.updateParentId", parentIdInfo);
	}

	/**
	 * 排序 更改orderIndex
	 * 
	 * @param order
	 * @return
	 */
	public int updateOrder(Map<String, Object> order) {
		return sqlSession.update("ColumnManageDao.updateOrder", order);
	}
	
	public List<Map<String,Object>> selColumnLists(){
		return sqlSession.selectList("ColumnManageDao.selColumnLists");
	}
	
	public Map<String,Object> selColumn( String catId){
		return sqlSession.selectOne("ColumnManageDao.selColumn",catId);
	}


}
