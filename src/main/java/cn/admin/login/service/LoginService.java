package cn.admin.login.service;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class LoginService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;

	/**
	 * 修改密码
	 * 
	 * @param map
	 * @return
	 */
	public int updatePwd(Map<String, Object> map) {
		return sqlSession.update("loginDao.updatePwd", map);
	}

	/**
	 * 修改用户最后一次登录时间，登录IP登录次数
	 * 
	 * @param map
	 * @return
	 */
	public int addLoginIP(Map<String, Object> map) {
		return sqlSession.insert("loginDao.updateLoginTimeAndIP", map);
	}
	
	/**
	 * 查询超级用户
	 */
	public Map<String,Object> selectUser(Map<String,Object> map){
		return sqlSession.selectOne("loginDao.selUserByID",map);
	}
	
	/**
	 * 修改超级用户
	 */
	public int updateUser(Map<String,Object> map){
		return sqlSession.update("loginDao.upPwd",map);
	}
}
