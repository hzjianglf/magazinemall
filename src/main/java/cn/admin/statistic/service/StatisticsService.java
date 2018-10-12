package cn.admin.statistic.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.util.NewExcelUtil;

@Service
@Transactional(rollbackFor = Exception.class)
public class StatisticsService {
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	NewExcelUtil excelUtil;
	
	//统计汇总列表
	public List<Map> selectStatistics(Map search) {
		return sqlSession.selectList("selectStatistics", search);
	} 
	//统计订单数量
	public long selectAboutOrderCount(Map search) {
		return sqlSession.selectOne("statisticsDao.selectAboutOrderCount", search);
	}
	//统计订单列表
	public List<Map> selectAboutOrder(Map search) {
		return sqlSession.selectList("statisticsDao.selectAboutOrder", search);
	}
	//导出-订单
	public List<Map> selectExportOrder(Map search) {
		return sqlSession.selectList("statisticsDao.selectExportOrder", search);
	}
	//导出-商品
	public List<Map> selectExportProuduct(Map search) {
		return sqlSession.selectList("statisticsDao.selectExportProuduct", search);
	}
	//导出-汇总
	public List<Map> selectExportTotal(Map search) {
		return sqlSession.selectList("statisticsDao.selectExportTotal", search);
	}
	
	public List<Map> selectCourseTypeStatistic(Map search) {
		return sqlSession.selectList("statisticsDao.selectCourseTypeStatistic", search);
	}
	public List<Map> selectCourseStatisAboutOrder(Map search2) {
		return sqlSession.selectList("statisticsDao.selectCourseStatisAboutOrder", search2);
	}
	public long selectCourseStatisAboutOrderCount(Map search2) {
		return sqlSession.selectOne("statisticsDao.selectCourseStatisAboutOrderCount", search2);
	}
	public List<Map> selectCourseStatisAboutProduct(Map search2) {
		return sqlSession.selectList("statisticsDao.selectCourseStatisAboutProduct", search2);
	}
	public long selectCourseStatisAboutProductCount(Map search2) {
		return sqlSession.selectOne("statisticsDao.selectCourseStatisAboutProductCount", search2);
	}
	public List<Map> selectBookAndElectronic(Map search) {
		return sqlSession.selectList("statisticsDao.selectBookAndElectronic", search);
	}
	public List<Map> selectCourseItemsStatistic(Map search) {
		return sqlSession.selectList("statisticsDao.selectCourseItemsStatistic", search);
	}
	public List<Map> selectProductAndElectronicAboutOrder(Map search3) {
		return sqlSession.selectList("statisticsDao.selectProductAndElectronicAboutOrder", search3);
	}
	public long selectProductAndElectronicCount(Map search3) {
		return sqlSession.selectOne("statisticsDao.selectProductAndElectronicCount", search3);
	}
	public List<Map> selectCourseStatisByOrder(Map search2) {
		return sqlSession.selectList("statisticsDao.selectCourseStatisByOrder", search2);
	}
	public long selectCourseStatisByOrderCount(Map search2) {
		return sqlSession.selectOne("statisticsDao.selectCourseStatisByOrderCount", search2);
	}
	public List<Map> selectProductAndElectronicAboutProduct(Map search3) {
		return sqlSession.selectList("statisticsDao.selectProductAndElectronicAboutProduct", search3);
	}
	public long selectProductAndElectronicCountAboutProduct(Map search3) {
		return sqlSession.selectOne("statisticsDao.selectProductAndElectronicCountAboutProduct", search3);
	}
	public List<Map> selectCourseStatisByProduct(Map search2) {
		return sqlSession.selectList("statisticsDao.selectCourseStatisByProduct", search2);
	}
	public long selectCourseStatisByProductCount(Map search2) {
		return sqlSession.selectOne("statisticsDao.selectCourseStatisByProductCount", search2);
	}
	public List<Map<String, Object>> getBookByYear(String year) {
		return sqlSession.selectList("statisticsDao.getBookByYear", year);
	}
	public List<String> getYears() {
		return sqlSession.selectList("statisticsDao.getYears");
	}
	public long selectSearchOrderCount(Map search1) {
		return sqlSession.selectOne("statisticsDao.selectSearchOrderCount", search1);
	}
	public List<Map> selectSearchOrder(Map search1) {
		return sqlSession.selectList("statisticsDao.selectSearchOrder", search1);
	}
}
