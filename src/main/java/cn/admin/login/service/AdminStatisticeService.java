package cn.admin.login.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class AdminStatisticeService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;

	/**
	 * 今天视频咨询量
	 * 
	 * @return
	 */
	public int getTodayBrowse() {
		return sqlSession.selectOne("adminStatisticsDao.getTodayBrowse");
	}

	/**
	 * 今天交易金额
	 * 
	 * @return
	 */
	public int getTodayPay() {
		Integer result = sqlSession.selectOne("adminStatisticsDao.getTodayPay");
		if (result == null) {
			return 0;
		}
		return result;
	}

	/**
	 * 今天投诉次数
	 * 
	 * @return
	 */
	public int getTodayCount() {
		return sqlSession.selectOne("adminStatisticsDao.getTodayCount");
	}

	/**
	 * 最近7天的日访问量
	 * 
	 * @return
	 */
	public List<Map<String, Object>> getCountInSevenDays() {
		return sqlSession.selectList("adminStatisticsDao.getCountInSevenDays");
	}

	/**
	 * 最近30天客服排行榜
	 * 
	 * @return
	 */
	public List<Map<String, Object>> getCountInThirtyDays() {
		return sqlSession.selectList("adminStatisticsDao.getCountInThirtyDays");
	}

	/**
	 * 服务类型分布情况
	 * 
	 * @return
	 */
	public List<Map<String, Object>> getBusinessType() {
		return sqlSession.selectList("adminStatisticsDao.getBusinessType");
	}

}
