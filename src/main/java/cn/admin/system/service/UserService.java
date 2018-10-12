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
@Transactional(propagation=Propagation.REQUIRED,rollbackFor=Exception.class)
public class UserService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 添加用户角色关联表
	 * @param userMap
	 * @return
	 */
	public int addUserRole(Map<String, Object>  userMap){
		return sqlSession.insert("userDao.addUserRole",userMap);
	}
	
	/**
	 * 查询用户名是否存在
	 * @param map
	 * @return
	 */
	public int selByName(Map<String, Object>  map){
		return sqlSession.selectOne("userDao.selByName", map);
	}
	
	/**
	 * 查询手机号是否存在
	 * @param map
	 * @return
	 */
	public int selByPhone(Map<String, Object>  map){
		return sqlSession.selectOne("userDao.selByPhone", map);
	}
	
	/**
	 * 添加用户
	 */
	public int addAdminUserInfo(Map<String, Object>  userMap){
		//为客服端人员添加工号
		if("1".equals(userMap.get("userType"))){
			//选查询最后一个工号，在此基础上加1
			Map<String, Object> codeMap = sqlSession.selectOne("userDao.getLastUserCode");
			int userCode = 10000;
			if(codeMap != null){
				userCode = Integer.parseInt(codeMap.get("userCode").toString()) + 1;
			}
			userMap.put("userCode", userCode);
		}
		int row = 0;
		//添加用户表
		row = sqlSession.insert("userDao.addAdminUserInfo",userMap);
		if(row >0){
			//添加用户角色关联表
			row = sqlSession.insert("userDao.addUserRole",userMap);
		}
		return row;
	}

	/**
	 * 通过ID查询单个会员
	 * @param userId
	 * @return
	 */
	public Map<String, Object> selectUserInfoById(String userId) {
		return sqlSession.selectOne("userDao.selectUserInfoById",userId);
	
	}

	/**
	 * 单个或批量删除用户
	 * @param map
	 * @return
	 */
	public int deleteUser(Map<String, Object> map) {
		 return sqlSession.delete("userDao.deleteUser", map);
	}
	
	/**
	 * 单个或批量冻结用户
	 * @param map
	 * @return
	 */
	public int lockUser(Map<String, Object> map) {
		return sqlSession.delete("userDao.lockUser", map);
	}
	
	/**
	 * 单个或批量解冻用户
	 * @param map
	 * @return
	 */
	public int unlockUser(Map<String, Object> map) {
		return sqlSession.delete("userDao.unlockUser", map);
	}

	/**
	 * 修改用户信息
	 * @param map
	 * @return
	 */
	public int updateUser(Map<String, Object> map) {
		return sqlSession.update("userDao.updateUser",map);
	}

	/**
	 * 添加或修改用户角色
	 * @param map
	 * @return
	 */
	public int addUserRoles(Map<String, Object> map) {
		//修改用户信息
		int row = sqlSession.update("userDao.updateUser",map);
		int userId=  Integer.valueOf(map.get("userId")+"");
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("userId", userId);
		//修改用户角色时先删除用户角色，再添加
		int count = sqlSession.selectOne("userDao.select",m);
		if(count>0){
			sqlSession.delete("userDao.del",m);
		}
		//添加用户角色表
		if(row > 0){
			row = sqlSession.insert("userDao.addUserRole",map);
		}
		return row;
	}
	
	/**
	 * 查询为删除管理员列表信息
	 * @param selUser
	 * @return
	 */
	public List<Map<String, Object>> selectAdminUser(Map<String, Object> selUser) {
		List<Map<String, Object>> list=sqlSession.selectList("userDao.selectAdminUser",selUser);
		return list;
	}
	
	/**
	 * 查询未删除管理员总数
	 * @param selUser
	 * @return
	 */
	public long getTotalCount2(Map<String, Object> selUser) {
		return sqlSession.selectOne("userDao.countAdminUser",selUser);
	}
	
	/**
	 * 根据用户类型查找用户下的对应角色
	 * @return
	 */
	public List<Map<String, Object>> selRoleByIdentify2(String userType){
		return sqlSession.selectList("userDao.selRoleByIdentify2",userType);
	}

	/**
	 * 根据openId获取用户信息
	 * @param openId
	 * @return
	 */
	public Map<String, Object>getUserInfoByOpenId(String openId){
		return sqlSession.selectOne("userDao.selUserByOpenId", openId);
	}

	public long selectTeachersFromAdverCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("userDao.selectTeachersFromAdverCount", reqMap);
	}

	public List<Map<String, Object>> selTeachersFromAdver(Map<String, Object> reqMap) {
		return sqlSession.selectList("userDao.selTeachersFromAdver", reqMap);
	}
	
}
