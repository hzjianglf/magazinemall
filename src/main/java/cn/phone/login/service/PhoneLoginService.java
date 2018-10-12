package cn.phone.login.service;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PhoneLoginService {
	
	@Autowired
	SqlSession sqlSession;

	
	/**
	 * 注册
	 * @param paramMap
	 * @return
	 */
	@Transactional
	public int UserRegister(Map<String, Object> paramMap) {
		int row = sqlSession.insert("phooneLoginDao.UserRegister", paramMap);
		if(row>0){
			//初始化账户表
			sqlSession.insert("phooneLoginDao.insertAccount", paramMap);
		}
		return row;
	}
	/**
	 * 查询手机号是否已经注册
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> selectUserIsExistence(
			Map<String, Object> paramMap) {
		return sqlSession.selectOne("phooneLoginDao.selectUserIsExistence", paramMap);
	}
	
	
	
	
}
