package cn.api.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class SettingService {

	@Autowired
	SqlSession sqlSession;
	
	
	
	//获取支付方式列表
	public List<Map<String, Object>> getPayMethods(Map<String,Object> map) {
		return sqlSession.selectList("settingApiDao.getPayMethods",map);
	}
	//支付方式count
	public long getPaymethodsCount(Map<String, Object> map) {
		return sqlSession.selectOne("settingApiDao.getPaymethodsCount", map);
	}
	//获取专栏设置信息
	public Map<String, Object> getSpecialSetMsg(Map<String, Object> map) {
		return sqlSession.selectOne("settingApiDao.getSpecialSetMsg", map);
	}
	//保存专栏设置信息
	@Transactional
	public int addSpecialSetMsg(Map<String, Object> map) {
		int row = sqlSession.update("settingApiDao.addSpecialSetMsg", map);
		int r=0;
		if(row>0){
			r=sqlSession.update("settingApiDao.addUserExtend", map);
		}
		return row+r;
	}
	//获取手机标识存储到数据库
	public Map<String, Object> getPhoneId(Integer userId, String phoneId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("phoneId", phoneId);
		int row = sqlSession.update("settingApiDao.setPhoneId",map);
		Map<String,Object> result = new HashMap<String, Object>();
		result.put("result", 0);
		result.put("msg", "获取手机标识失败");
		if(row>0) {
			result.put("result", 1);
			result.put("msg", "获取手机标识成功");
		}
		return result;
	}
	
	
	
}
