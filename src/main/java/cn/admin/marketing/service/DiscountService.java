package cn.admin.marketing.service;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import cn.util.DataConvert;

@Service
public class DiscountService {

	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	DiscountProductService discountProductService;
	
	
	/**
	 * 查询限时折扣count
	 * @param reqMap
	 * @return
	 */
	public long selDiscountCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("discountDao.selDiscountCount", reqMap);
	}
	/**
	 * 查询限时折扣列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selDiscountList(Map<String, Object> reqMap) {
		List<Map<String,Object>> listData = sqlSession.selectList("discountDao.selDiscountList", reqMap);
		for (Map<String, Object> map : listData) {
			if(map != null && map.get("startTime") != null && map.get("endTime") != null) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				Date startTime = null;
				Date endTime = null;
				try {
					startTime = sdf.parse(map.get("startTime").toString());
					endTime = sdf.parse(map.get("endTime").toString());
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				String state = returnDate(startTime,endTime);
				map.put("state", state);
			}
		}
		return listData;
	}
	/**
	 * 时间判断活动状态
	 * @param startTime
	 * @param endTime
	 * @return 0 活动有误 1活动未开启 2活动进行中 3 活动已结束
	 */
	public String returnDate(Date startTime,Date endTime) {
		String num = "0";
		Date newDate = new Date();
		if(startTime.getTime() > endTime.getTime()) {
		}else if (startTime.getTime() > newDate.getTime()) {
			num = "1";
		}else if (endTime.getTime() < newDate.getTime()) {
			num = "3";
		}else if (endTime.getTime() >= startTime.getTime()) {
			num = "2";
		}
		return num;
	}
	/**
	 * 通过id查询指定限时折扣活动信息
	 * @param reqMap
	 * @return
	 */
	public Map<String, Object> findDisById(Map map) {
		return sqlSession.selectOne("discountDao.findDisById", map);
	}
	
	/**
	 * 修改 || 添加商品
	 * @param map
	 * @return
	 */
	public int insUpDiscount (Map<String,Object> map) {
		if(map!=null && map.get("id")!=null && map.get("id") != "") {
			return sqlSession.update("discountDao.upDiscount",map);
		}
		return sqlSession.insert("discountDao.insDiscount",map);
	}
	
	public int delDiscount (Map<String,Object> map) {
		return sqlSession.delete("discountDao.delDiscount",map);
	}
	
	public int insUpDisDisPro(Map<String,Object> map) {
		//添加或修改活动信息
		int num = insUpDiscount(map);
		if(num<1) {
			return num;
		}
		//添加或修改活动关联表
		List<Map<String, Object>> listData = null;
		try {
			listData = new ObjectMapper().readValue(map.get("shangpin")+"", ArrayList.class);
		} catch (IOException e) {
			e.printStackTrace();
		}
		if(listData.size()>0) {
			discountProductService.delDisProByID(map);
			for (Map<String, Object> map2 : listData) {
				map2.put("disID", map.get("id"));
				num = discountProductService.insDisPro(map2);
				if(num<1) {
					return num;
				}
			}
		}
		return num;
	}
	
	
}
