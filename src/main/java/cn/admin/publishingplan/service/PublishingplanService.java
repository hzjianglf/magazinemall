package cn.admin.publishingplan.service;

import java.util.ArrayList;
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

import cn.util.NumberUtil;


@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class PublishingplanService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	
	//出版计划总条数
	public long getPublishingplanCount(Map<String, Object> request) {
		return sqlSession.selectOne("planDao.getPublishingplanCount", request);
	}
	//出版计划数据列表
	public List<Map<String, Object>> getPublishingplanList(
			Map<String, Object> request) {
		return sqlSession.selectList("planDao.getPublishingplanList", request);
	}
	//批量添加出版计划
	public Map<String, Object> adds(Map<String, Object> param) {
		param.put("founder", session.getAttribute("loginUser"));
		String cycle = param.get("cycle")+"";
		int total = Integer.parseInt(param.get("totalPeriod")+"");
		int num=0;
		if(cycle.equals("1")){//周刊
			num=48;
		}else if(cycle.equals("2")){//半月刊
			num=24;
		}else if(cycle.equals("3")){//月刊
			num=12;
		}else if(cycle.equals("4")){//双月刊
			num=6;
		}else{//季刊
			num=4;
		}
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		for(int i=1;i<=num;i++){
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("describes", "第"+NumberUtil.toChinese(i+"")+"期");
			map.put("totalPeriod", total+i-1);
			list.add(map);
		}
		param.put("list", list);
		long row = sqlSession.insert("planDao.adds", param);
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
	//通过id查询出版计划
	public Map<String, Object> selOne(String id) {
		return sqlSession.selectOne("planDao.selOne", id);
	}
	//修改出版计划
	public Map<String, Object> ups(Map<String, Object> param) {
		long row = sqlSession.update("planDao.ups", param);
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
	//删除出版计划
	public Map<String, Object> deletePeriodical(String id) {
		long row = sqlSession.delete("planDao.deletePeriodical", id);
		Map<String, Object> map = new HashMap<String, Object>();
		if (row > 0) {
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
		long row = sqlSession.update("planDao.upState", param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "修改成功！");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败！");
		}
		return map;
	}
	//查询年份
	public List<Map<String, Object>> selYear(Map<String, Object> map) {
		return sqlSession.selectList("planDao.selYear", map);
	}
	
	
}
