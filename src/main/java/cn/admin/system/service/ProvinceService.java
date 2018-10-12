package cn.admin.system.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
@Service
public class ProvinceService {

	@Autowired
	SqlSessionFactory sqlsessionfactory;
	@Autowired
	SqlSession sqlsession;
	
	/**
	 * 获取所有省份
	 */
	public List<Map<String, Object>> getProvince() {
		return sqlsession.selectList("provinceDao.getProvince");
	}

	/**
	 * 
	 */
	public List<Map<String, Object>> getCityByParentId(String parentId) {
		return sqlsession.selectList("provinceDao.getCityByParentId",parentId);
	}
}
