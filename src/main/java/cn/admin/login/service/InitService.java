package cn.admin.login.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class InitService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	HttpSession session;
	
	public List<Map<String, Object>> selectAllAuthority(){
		return sqlSession.selectList("initPageDao.selectAllMenu");
	}
	
	/*public List<Map<String, Object>> initPage(List m){
		return sqlSession.selectList("initPageDao.selectModule", m);
	}
	//点击顶部导航
	public List<Map<String, Object>> selDaoHang(List parentModuleID){
		return sqlSession.selectList("initPageDao.selectDaoHang", parentModuleID);
	}*/
	//根据点击的类型查询孙子类
	public List<Map<String, Object>> selectSZ(String AuthorityType){
		return sqlSession.selectList("initPageDao.selectSZ", AuthorityType);
	}
	//查询子节点
	public List<Map<String, Object>> selChild(String userId){
		return sqlSession.selectList("initPageDao.selectChild", userId);
	}
	public Map<String, Object> selUrl(String parentModuleID) {
		//根据权限查询 要显示的一级列表
		String userId =  (String) session.getAttribute("userId");
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("parentModuleID", parentModuleID);
		Map<String, Object> m1 = new HashMap<String, Object>();
		m1.put("userId", userId);
		m1.put("parentModuleID", parentModuleID);
		List<Map<String, Object>> AuthorityIdLi = sqlSession.selectList("initPageDao.selone", m1);
		if(AuthorityIdLi!=null&&AuthorityIdLi.size()!=0){
			m1.put("parentModuleID", AuthorityIdLi.get(0).get("AuthorityID"));
			m.put("indexNoa", AuthorityIdLi.get(0).get("indexNo"));
		}
		List<Map<String, Object>> AuthorityIdLi2 = sqlSession.selectList("initPageDao.seltwo" ,m1);
		if(AuthorityIdLi2!=null&&AuthorityIdLi2.size()!=0){
			m.put("indexNob", AuthorityIdLi2.get(0).get("indexNo"));
		}
		Map<String, Object> a = sqlSession.selectOne("initPageDao.selUrl", m);
		return a;
	}
	
	//查询用户的角色，从而判断显示哪个首页
	public int selUserRole(String userId) {
		return sqlSession.selectOne("initPageDao.selUserRole", userId);
	}
	
	/**
	 * 登录
	 * @param map
	 * @return
	 */
	public Map<String, Object> login(Map<String, Object> map){
		return sqlSession.selectOne("initPageDao.login", map);
	}
	
	/**
	 * 通过id查询用户信息
	 * @param userId
	 * @return
	 */
	public Map<String, Object> getUserById(String userId){
		return sqlSession.selectOne("initPageDao.getUserById", userId);
	}
	
}
