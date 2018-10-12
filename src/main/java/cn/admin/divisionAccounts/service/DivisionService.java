package cn.admin.divisionAccounts.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.util.DataConvert;

/**
 * 分账计算
 * @author baoxuechao
 *
 */
@Service
public class DivisionService {

	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	HttpSession session;
	
	
	
	/**
	 * 查询分账批次列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selectDivisionList(Map<String, Object> reqMap) {
		return sqlSession.selectList("divisionDao.selectDivisionList", reqMap);
	}
	/**
	 * 查询分账批次count
	 * @param reqMap
	 * @return
	 */
	public long selectDivisionCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("divisionDao.selectDivisionCount", reqMap);
	}
	/**
	 * 作废分账计算
	 * @param map
	 * @return
	 */
	public int updateStatus(Map<String, Object> map) {
		return sqlSession.delete("divisionDao.updateStatus", map);
	}
	/**
	 * 提交分账记录
	 * @param map
	 * @return
	 */
	public int handInDivisonlog(Map<String, Object> map) {
		return sqlSession.update("divisionDao.handInDivisonlog", map);
	}
	/**
	 * 开始计算分账
	 * @param map
	 * @return
	 */
	@Transactional
	public Map<String, Object> startCalculation(Map<String, Object> map) {
		Map<String, Object> reqMap = new HashMap<String,Object>();
		
		//查询作家的课程销售金额、问答金额、打赏金额
		List<Map> list = sqlSession.selectList("divisionDao.startCalculation", map);
		/**
		 * TODO 这里需要根据增值税，个人所得税的计算公式去计算需要缴纳的税费，从应发金额中减去缴纳的税费剩余的为实发金额
		 * 传入参数名称：营业税 salesTax，个人所得税 personalTax，实发金额 actualMoney(sql中以按该字段名称写好，只需在这里按这个名称塞入map中即可)
		 */
		
		/**
		 * TODO 计算批次总额，此处还缺少营业额总数、个人所得税总数的计算
		 * 传入参数名称：totalSalesTax 营业税总数，totalPersonalTax 个人所得税总数
		 */
		Map<String, Object> maps=new HashMap<String,Object>();
		int usernum=1;//专家数目
		double totalOndemandMoney=0;//课程销售总金额
		double totalQuestionMoney=0;//问答总金额
		double totalRewardMoney=0;//打赏总金额
		for (Map map2 : list) {
			usernum++;
			//计算课程销售金额总数
			totalOndemandMoney+=DataConvert.ToDouble(map2.get("ondemandMoney"));
			//计算问答金额总数
			totalQuestionMoney+=DataConvert.ToDouble(map2.get("questionMoney"));
			//计算打赏金额总数
			totalRewardMoney+=DataConvert.ToDouble(map2.get("rewardMoney"));
		}
		maps.put("name", DataConvert.ToString(map.get("year"))+"年度"+DataConvert.ToString(map.get("month"))+"月份");
		maps.put("userCount", usernum);
		maps.put("totalOndemandMoney", totalOndemandMoney);
		maps.put("totalQuestionMoney", totalQuestionMoney);
		maps.put("totalRewardMoney", totalRewardMoney);
		maps.put("addUserId", DataConvert.ToString(session.getAttribute("userId")));//添加人id
		maps.put("inputer", DataConvert.ToString(session.getAttribute("adminRealName")));//添加人姓名
		//添加分成计算批次
		int row = sqlSession.insert("divisionDao.addReckonBatch", maps);
		if(row>0) {
			//添加分成计算详细
			for (Map map2 : list) {
				map2.put("addUserId", DataConvert.ToString(session.getAttribute("userId")));//添加人id
				map2.put("year", DataConvert.ToString(map.get("year")));
				map2.put("month", DataConvert.ToString(map.get("month")));
				map2.put("batchId", DataConvert.ToString(maps.get("batchId")));
			}
			map.put("list", list);
			//添加分成详细
			sqlSession.insert("divisionDao.insertBillreckon", map);
		}
		
		return reqMap;
	}
	/**
	 * 分成详情列表查询
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selectDivisionDetailList(Map<String, Object> reqMap) {
		return sqlSession.selectList("divisionDao.selectDivisionDetailList", reqMap);
	}
	/**
	 * 分成详细count
	 * @param reqMap
	 * @return
	 */
	public long selectDivisionDetailCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("divisionDao.selectDivisionDetailCount", reqMap);
	}
	/**
	 * 扣款操作
	 * @param map
	 * @return
	 */
	public int upCutMoney(Map<String, Object> map) {
		return sqlSession.update("divisionDao.upCutMoney", map);
	}
	/**
	 * 课程销售记录列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selClassSaleLogList(Map<String, Object> reqMap) {
		return sqlSession.selectList("divisionDao.selClassSaleLogList", reqMap);
	}
	/**
	 * 课程销售记录count
	 * @param reqMap
	 * @return
	 */
	public long selClassSaleLogCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("divisionDao.selClassSaleLogCount", reqMap);
	}
	/**
	 * 问答记录列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selQuestionlogList(Map<String, Object> reqMap) {
		return sqlSession.selectList("divisionDao.selQuestionloglist", reqMap);
	}
	/**
	 * 问答记录count
	 * @param reqMap
	 * @return
	 */
	public long selQuestionlogCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("divisionDao.selQuestionCount", reqMap);
	}
	/**
	 * 打赏记录列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selRewardlogList(Map<String, Object> reqMap) {
		return sqlSession.selectList("divisionDao.selRewardLogList", reqMap);
	}
	/**
	 * 打赏记录count
	 * @param reqMap
	 * @return
	 */
	public long selRewardlogCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("divisionDao.selRewardLogCount", reqMap);
	}
	/**
	 * 无效
	 * @param map
	 * @return
	 */
	@Transactional
	public Map<String, Object> invalid(Map<String, Object> map) {
		Map<String, Object> reqMap = new HashMap<String,Object>();
		//先将该问答记录分成状态改为无效
		int row = 0;
		//statusType 1代表问答 2代表打赏
		if("1".equals(map.get("statusType")+"")) {
			row = sqlSession.update("divisionDao.updateInterlocution", map);
		}else if("2".equals(map.get("statusType")+"")) {
			row = sqlSession.update("divisionDao.updateReward", map);
		}
		if(row > 0) {
			//从该专家的分成详细中扣除此款项
			String payTime = DataConvert.ToString(map.get("payTime"));
			String[] str = payTime.split("-");
			map.put("year", str[0]);
			map.put("month", str[1].replace("0", ""));
			map.put("type", 1);
			
			int a = sqlSession.update("divisionDao.updateMoney", map);
			//查询分成批次id
			String batchId = sqlSession.selectOne("divisionDao.selBillReckonId", map);
			map.put("batchId", batchId);
			//扣除批次中的款项
			int b = sqlSession.update("divisionDao.updateBatchPrice",map);
			reqMap.put("msg", "修改成功!");
		}else {
			reqMap.put("msg", "修改失败!");
		}
		return reqMap;
	}
	/**
	 * 有效
	 * @param map
	 * @return
	 */
	public Map<String, Object> effective(Map<String, Object> map) {
		Map<String, Object> reqMap = new HashMap<String,Object>();
		//先将该问答记录分成状态改为无效
		int row = 0;
		//statusType 1代表问答 2代表打赏
		if("1".equals(map.get("statusType")+"")) {
			row = sqlSession.update("divisionDao.updateInterlocution", map);
		}else if("2".equals(map.get("statusType")+"")) {
			row = sqlSession.update("divisionDao.updateReward", map);
		}
		if(row > 0) {
			//从该专家的分成详细中扣除此款项
			String payTime = DataConvert.ToString(map.get("payTime"));
			String[] str = payTime.split("-");
			map.put("year", str[0]);
			map.put("month", str[1].replace("0", ""));
			map.put("type", 2);
			
			sqlSession.update("divisionDao.updateMoney", map);
			//查询分成批次id
			String batchId = sqlSession.selectOne("divisionDao.selBillReckonId", map);
			map.put("batchId", batchId);
			//扣除批次中的款项
			sqlSession.update("divisionDao.updateBatchPrice",map);
			reqMap.put("msg", "修改成功!");
		}else {
			reqMap.put("msg", "修改失败!");
		}
		return reqMap;
	}
	/**
	 * 查询当前年份已经计算的月份
	 * @param ma
	 * @return
	 */
	public List selYearByMonth(Map ma) {
		return sqlSession.selectList("divisionDao.selYearByMonth", ma);
	}
	
	
	
	
	
}
