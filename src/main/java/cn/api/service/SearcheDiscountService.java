package cn.api.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.util.DataConvert;

@Service
public class SearcheDiscountService {
	
	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * @param
	 * type 商品类型1纸质期刊2电子期刊3点播课程4直播课程
	 * productId  商品id
	 * 
	 * @return 商品价格
	 */
	public  Double searchDiscountPrice(Map<String,Object> map) {
		Integer type = DataConvert.ToInteger(map.get("type"));
		//查询所有限时特价活动
		Double discountPrice=0.00;
		List<Integer> list = sqlSession.selectList("discountPriceDao.selAllDiscount");
		//查询打折最低的价格
		if(null!=list && list.size()>0) {
			map.put("list", list);
			Double Price = sqlSession.selectOne("discountPriceDao.selMinPrice",map);
			if(Price!=null) {
				return Price;
			}else {
				if(type==1 || type==2) {
					discountPrice = sqlSession.selectOne("discountPriceDao.selBookYuanPrice",map);
				}else if(type==3 || type==4) {
					discountPrice= sqlSession.selectOne("discountPriceDao.selOndemandPrice",map);
				}else {
					
				}
			}
		}else {
			if(type==1 || type==2) {
				discountPrice = sqlSession.selectOne("discountPriceDao.selBookYuanPrice",map);
			}else if(type==3 || type==4) {
				discountPrice= sqlSession.selectOne("discountPriceDao.selOndemandPrice",map);
			}else {
				
			}
		}
		
		return discountPrice;
	}
}
