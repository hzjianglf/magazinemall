package cn.phone.login.service;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class WechatUserService {
	
	@Autowired
	SqlSession sqlSession;

	/**
	 * 根据openId判断用户信息是否存在
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object>getWechatUserInfoByOpenId(String openId){
		return sqlSession.selectOne("cn.dao.wechatUserDao.selWechatUserByOpenId", openId);
	}
	
	public void updateWeChatUserId(Map<String,Object> wechatParam){
		sqlSession.update("cn.dao.wechatUserDao.updateWeChatUserId", wechatParam);
	}
	public void insertWeChatUserRecord(Map<String,Object> wechatParam){
		sqlSession.insert("cn.dao.wechatUserDao.insertWeChatUserRecord", wechatParam);
	}
	//更新用户的老数据订单关联userId
	public void updateOrderByOpenId(Map<String, Object> wechatParam) {
		sqlSession.update("cn.dao.wechatUserDao.updateOrderByOpenId", wechatParam);
	}
	//更新用户的老数据地址关联userId
	public void updateAddressByOpenId(Map<String, Object> wechatParam) {
		sqlSession.update("cn.dao.wechatUserDao.updateAddressByOpenId", wechatParam);
	}
	
}
