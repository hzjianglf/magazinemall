package cn.api.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.util.HtmlUtils;

import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.util.DataConvert;
import cn.util.StringHelper;

/**
 * 运费
 *
 */
@Service
public class PostageService {

	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 比较:收货地址和logisticstemplateitem表 地址是否匹配
	 */
	public boolean addressIsMatch(List<Map<String,Object>> province,List<Integer> cityIdList,
			List<Map<String,Object>> templateDetailList,int cityId,String city) {
		//根据city查询provinces 的codeid
		List<Integer> codeid = new ArrayList<>();
		if(city !=null && city.endsWith("省")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("市")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("区")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("州")) {
			city = city.substring(0, city.length()-1);
		}	
		province = sqlSession.selectList("provinceDao.selectCodeid",city);
		if(province !=null && province.size()>0) {
			for(int i = 0;i<province.size();i++) {
				codeid.add(Integer.parseInt((province.get(i).get("codeid")).toString()));
			}
		}
		cityIdList = StringHelper.ToIntegerList(templateDetailList.get(cityId).get("cityIds")+"");
		//boolean isCity = cityIdList.containsAll(codeid);
		boolean isCity = false;
		if(cityIdList !=null && cityIdList.size()>0) {
			if(codeid !=null && codeid.size()>0) {
				for(int i=0;i<cityIdList.size();i++) {
					for(int j=0;j<codeid.size();j++) {
						if(cityIdList.get(i).intValue()==codeid.get(j).intValue()) {
							isCity = true;
							return isCity;
						}
					}
				}
			}
		}
		return isCity;
	}
	
	/**
	 * 计算运费
	 */
	public BigDecimal caculateFreight(List<Map<String,Object>> bookRecordList,
			List<Map<String,Object>> templateDetailList,int cityId,int j,BigDecimal freight) {
		double count = DataConvert.ToDouble(bookRecordList.get(j).get("count"));
		double firstGoods = 0.0;
		BigDecimal firstFreight = new BigDecimal(0.0);
		double secondGoods = 0.0;
		BigDecimal secondFreight = new BigDecimal(0.0);
		if(count<=((BigDecimal)(templateDetailList.get(cityId).get("firstGoods"))).doubleValue()) {
			freight = (BigDecimal) templateDetailList.get(cityId).get("firstFreight");
		}else{
			firstGoods = ((BigDecimal)(templateDetailList.get(cityId).get("firstGoods"))).doubleValue();
			secondGoods = ((BigDecimal)(templateDetailList.get(cityId).get("secondGoods"))).doubleValue();
			secondFreight = (BigDecimal)(templateDetailList.get(cityId).get("secondFreight"));
			if(secondGoods>0) {
				firstFreight = (BigDecimal) templateDetailList.get(cityId).get("firstFreight");
				double ceil = Math.ceil((count - firstGoods)/secondGoods);
				BigDecimal ceilBigdecimal = new BigDecimal(ceil);
				freight = firstFreight.add((ceilBigdecimal.multiply(secondFreight)));
			}
		}
		return freight;
	}
	

}
