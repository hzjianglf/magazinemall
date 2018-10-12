package cn.admin.finance.service;

import java.util.List;
import java.util.Map;



import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RechargeService {
	@Autowired
	SqlSession sqlSession;
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	//充值记录列表数量
	public long selTotalCount(Map search) {
		return sqlSession.selectOne("RechargeDao.selTotalCount", search);
	}
	//充值记录列表数据
	public List<Map> getrechargeList(Map search) {
		return sqlSession.selectList("RechargeDao.getrechargeList", search);
	}
	//通过id查询详情
	public Map getContentById(Integer paylogid) {
		return sqlSession.selectOne("RechargeDao.getContentById",paylogid);
	}

}
