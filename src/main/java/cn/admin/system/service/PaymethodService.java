package cn.admin.system.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class PaymethodService {

	
	@Autowired
	SqlSessionFactory sqlsessionfactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	
	//查询列表数量
	public long selPaymentCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("paymethodDao.selPaymentCount",reqMap);
	}
	//查询列表
	public List<Map<String, Object>> selPaymentList(Map<String, Object> reqMap) {
		return sqlSession.selectList("paymethodDao.selPaymentList", reqMap);
	}
	//支付管理状态设置
	public int updateDefault(Map<String, Object> map) {
		return sqlSession.update("paymethodDao.updateDefault", map);
	}
	//删除
	public int deletePayment(Map<String, Object> map) {
		return sqlSession.delete("paymethodDao.deletePayment", map);
	}
	//根据id查询支付方式
	public Map<String, Object> findByIdPayment(Map<String, Object> map) {
		return sqlSession.selectOne("paymethodDao.findByIdPayment", map);
	}
	//添加或修改支付方式
	public Map<String, Object> savePayment(Map<String, Object> map) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		if("on".equals(map.get("isfreeze")+"")){
			map.put("isfreeze", 1);
		}else{
			map.put("isfreeze", 0);
		}
		if("on".equals(map.get("isDefault")+"")){
			map.put("isDefault", 1);
		}else{
			map.put("isDefault", 0);
		}
		int row = 0;
		if(StringUtils.isEmpty(map.get("id"))){
			//添加
			row = sqlSession.insert("paymethodDao.addPayment", map);
		}else{
			//修改
			row = sqlSession.update("paymethodDao.UpPayment", map);
		}
		if(row > 0){
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功!");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "保存失败!");
		}
		return reqMap;
	}
	
	
	
	
	
	
}
