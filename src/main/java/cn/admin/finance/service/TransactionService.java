package cn.admin.finance.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class TransactionService {
	
	@Autowired
	SqlSession sqlSession;
	
	public List<Map<String,Object>> purchaseList(Map<String,Integer> map){
		return sqlSession.selectList("TransactionDao.purchaseData",map);
	}
	public List<Map> purchaseList(){
		return sqlSession.selectList("TransactionDao.purchaseData");
	}
	
	public long purchaseCount(Map search){
		return sqlSession.selectOne("TransactionDao.purchaseCount",search);
	}
	
	public List<Map<String,Object>> orderPayment(Map map){
		return sqlSession.selectList("TransactionDao.dingdanzhifu", map);
	}
	
	public Map<String,Object> questions (Map map){
		return sqlSession.selectOne("TransactionDao.tiwen", map);
	}
	
	public Map<String,Object> listenHearing (Map map){
		return sqlSession.selectOne("TransactionDao.pangting", map);
	}
	
	public Map<String,Object> reward (Map map) {
		return sqlSession.selectOne("TransactionDao.dashang", map);
	}
	
}
