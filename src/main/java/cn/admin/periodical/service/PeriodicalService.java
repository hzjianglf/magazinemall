package cn.admin.periodical.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import cn.util.DataConvert;


@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class PeriodicalService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	
	//期刊档案总条数
	public long getPeriodicalCount(Map<String, Object> request) {
		return sqlSession.selectOne("perDao.getPeriodicalCount", request);
	}
	//期刊档案数据列表
	public List<Map<String, Object>> getPeriodicalList(
			Map<String, Object> request) {
		return sqlSession.selectList("perDao.getPeriodicalList", request);
	}
	//添加期刊
	public Map<String, Object> adds(Map<String, Object> param) {
		param.put("founder", session.getAttribute("loginUser"));
		if(param.get("state")!=null){
			param.put("state", 1);
		}else{
			param.put("state", 0);
		}
		long row = sqlSession.insert("perDao.adds", param);
		Map<String, Object> map = new HashMap<String, Object>();
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "保存成功！");
		} else {
			map.put("success", false);
			map.put("msg", "保存失败！");
		}
		return map;
	}
	//通过id查询期刊内容
	public Map<String, Object> selOne(String id) {
		return sqlSession.selectOne("perDao.selOne", id);
	}
	//修改期刊
	public Map<String, Object> ups(Map<String, Object> param) {
		if(param.get("state")!=null){
			param.put("state", 1);
		}else{
			param.put("state", 0);
		}
		long row = sqlSession.update("perDao.ups", param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "修改成功！");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败！");
		}
		return map;
	}
	//删除期刊
	@Transactional
	public Map<String, Object> deletePeriodical(String id) {
		long row = sqlSession.delete("perDao.deletePeriodical", id);
		Map<String, Object> map = new HashMap<String, Object>();
		if (row > 0) {
			sqlSession.delete("perDao.deleteIssue", id);
			map.put("success", true);
			map.put("msg", "删除成功！");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败！");
		}
		return map;
	}
	public Map<String, Object> upState(Map<String, Object> param) {
		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("id", id);
//		map.put("state", state);
		long row = sqlSession.update("perDao.upState", param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "修改成功！");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败！");
		}
		return map;
	}
	//查询指定期次下所有的栏目和板块
	public long selectColumnsCount(Map<String, Object> map) {
		return sqlSession.selectOne("perDao.selectColumnsCount",map);
	}
	public List selectColumnsData(Map<String, Object> map) {
		return sqlSession.selectList("perDao.selectColumnsData",map);
	}
	//查询指定期次下的栏目
	public List selCategoryByPubId(int publishId) {
		return sqlSession.selectList("perDao.selCategoryByPubId",publishId);
	}
	//保存栏目或板块
	public Map<String,Object> addCategoryOrColumns(Map<String, Object> map) {
		int num = 0;
		if(2==DataConvert.ToInteger(map.get("type"))){//2代表添加栏目
			num = sqlSession.insert("perDao.addColunms",map);
		}else{
			num = sqlSession.insert("perDao.addCategory",map);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (num > 0) {
			result.put("success", true);
			result.put("msg", "保存成功！");
		} else {
			result.put("success", false);
			result.put("msg", "保存失败！");
		}
		return result;
	}
	//修改栏目或板块
	public Map<String, Object> updCategoryOrColumns(Map<String, Object> map) {
		int num = 0;
		if(2==DataConvert.ToInteger(map.get("type"))){//2代表修改栏目
			num = sqlSession.update("perDao.updColunms",map);
		}else{
			num = sqlSession.update("perDao.updCategory",map);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (num > 0) {
			result.put("success", true);
			result.put("msg", "修改成功！");
		} else {
			result.put("success", false);
			result.put("msg", "修改失败！");
		}
		return result;
	}
	//修改栏目或板块的状态
	public Map<String, Object> updStatus(Map<String, Object> map) {
		int num = 0;
		if(1==DataConvert.ToInteger(map.get("type"))){//1代表板块2栏目
			num = sqlSession.update("perDao.updCategoryStatus",map);
		}else{
			num = sqlSession.update("perDao.updColumnsStatus",map);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (num > 0) {
			result.put("success", true);
			result.put("msg", "修改成功！");
		} else {
			result.put("success", false);
			result.put("msg", "修改失败！");
		}
		return result;
	}
	//通过id查询板块或栏目详情
	public Map selCategoryOrColumnsById(Map<String, Object> map) {
		Map<String,Object> result = new HashMap<String, Object>();
		if(2==DataConvert.ToInteger(map.get("type"))){
			result = sqlSession.selectOne("perDao.selColumnsById",map);
		}else{
			result = sqlSession.selectOne("perDao.selCategoryById",map);
		}
		return result;
	}
	//删除栏目或板块
	public Map<String, Object> delCategoryOrColumns(Map<String, Object> map) {
		int num = 0;
		if(1==DataConvert.ToInteger(map.get("type"))){//1代表板块2栏目
			num = sqlSession.update("perDao.delCategory",map);
		}else{
			num = sqlSession.update("perDao.delColumns",map);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		if (num > 0) {
			result.put("success", true);
			result.put("msg", "删除成功！");
		} else {
			result.put("success", false);
			result.put("msg", "删除失败！");
		}
		return result;
	}
	
	
}
