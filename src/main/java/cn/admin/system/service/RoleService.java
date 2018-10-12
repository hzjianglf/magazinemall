package cn.admin.system.service;

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
//事务处理
@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
public class RoleService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 查询所有角色
	 * @param searchInfo
	 * @return
	 */
	public List<Map<String, Object>> selectRoleByQuery(Map<String, Object> searchInfo){
		List<Map<String, Object>> list = sqlSession.selectList("roleDao.selectRoleInfo",searchInfo);
		return list;
	}
	
	/**
	 * 根据roleid查询角色
	 * @param roleid
	 * @return
	 */
	public Map<String, Object> selectRoleById(String roleid){
		Map<String, Object> map =  sqlSession.selectOne("roleDao.selectRoleById",roleid);
		return map;
	}
	
	/**
	 * 获取角色数量
	 * @param searchInfo
	 * @return
	 */
	public long getTotalCount(Map<String, Object> searchInfo){
		return sqlSession.selectOne("roleDao.countRole",searchInfo);
	}
	
	/**
	 * 增加角色
	 * @param map
	 * @return
	 */
	public int add(Map<String,Object> map){
		int row = sqlSession.insert("roleDao.addRoleInfo", map);
		return row;
	}
	
	/**
	 * 修改角色
	 * @param map
	 * @return
	 */
	public int update(Map<String,Object> map){
		int row = sqlSession.update("roleDao.update", map);
		return row;
	}
	
	/**
	 * 根据用户id查询角色ID
	 * @param userId
	 * @return
	 */
	public List<String> selectRoleIdByUserId(String userId){
		List<String> roleId = sqlSession.selectList("roleDao.selectRoleIdByUserId", userId);
		return roleId;
	}
	
	/**
	 * 查询userrole表中的相关记录判断某一角色下是否还有人员
	 * @param roleid
	 * @return
	 */
	public int selectUserRole(String roleid){
		return sqlSession.selectOne("roleDao.selectUserRole", roleid);
	}
	
	/**
	 * 删除角色
	 * @param roleid
	 * @return
	 */
	@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
	public int delRole(String roleid){
		int ret = sqlSession.delete("roleDao.delRole",roleid);
		//同时删除userrole 和 roleauthority 表中的与role相关的记录
		sqlSession.delete("roleDao.delar",roleid);
		return ret;
	}

	/**
	 * 设置角色权限
	 * @param map
	 * @return
	 */
	@Transactional
	public Integer addra(Map<String,Object> map) {
		int roleid=  Integer.valueOf((String) map.get("roleid"));
		Map<String,Object> m= new HashMap<String,Object>();
		m.put("roleid", roleid);
		int count = sqlSession.selectOne("roleDao.select",m);
		//修改时先删除原有的权限，重新添加
		if(count>0){
			sqlSession.delete("roleDao.del",m);
		}
		int row = sqlSession.insert("roleDao.add",map);
		return row;
	}
	
	/**
	 * 根据roleId查询此角色的权限
	 * @param roleid
	 * @return
	 */
	public List<Map<String,Object>> selAuthorityID(String roleid){
		return sqlSession.selectList("roleDao.selAuthorityID",roleid);
	}
	
	/**
	 * 登录时查询该用户拥有的权限放到session中 
	 * @param userId
	 * @return
	 */
	public List<String> selAuthorityByUserId(String userId){
		return sqlSession.selectList("roleDao.selAuthorityByUserId",userId);
	}
	
}
