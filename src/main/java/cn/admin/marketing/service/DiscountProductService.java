package cn.admin.marketing.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DiscountProductService {
	
	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 通过活动的ID查询活动关联表信息
	 * @param map
	 * @return
	 */
	public List<Map<String,Object>> selDisProByDisID(Map<String,Object> map){
		return sqlSession.selectList("discountProductDao.findDisProById",map);
	}
	
	/**
	 * 添加活动关联表
	 * @param map
	 * @return
	 */
	public int insDisPro(Map<String,Object> map) {
		return sqlSession.insert("discountProductDao.insDiscountPro",map);
	}
	
	/**
	 * 通过活动id删除关联表的数据
	 * @param map
	 * @return
	 */
	public int delDisProByID(Map<String,Object> map) {
		return sqlSession.delete("discountProductDao.delDiscountPro",map);
	}
}
