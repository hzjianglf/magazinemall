package cn.api.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ActivityService {

	@Autowired
	SqlSession sqlSession;
	
	/**
	 * 获取商品对应的买即送列表
	 * @param productId 商品Id
	 * @param productType 商品类型 1:纸质期刊 2:电子期刊 3:点播课程 4:直播课程 5:商品
	 * @return
	 */
	public  List<Map>getBuyJiSongList(int productId,int productType){
		
		List<Map>list=null;
		
		try {
			if(productId>0&&Arrays.asList(1,2,3,4,5).contains(productType)) {
				
				Map<String, Object> paramMap=new HashMap<String,Object>();
				paramMap.put("id", productId);
				paramMap.put("type", productType);
				
				list=sqlSession.selectList("cn.dao.activityDao.selBuyjisongList",paramMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(list==null) {
			list=new ArrayList<Map>();
		}
		return list;
	}
	
	/**
	 * 获取买即送活动对应赠送的商品列表
	 * @param id 活动Id
	 * @return
	 */
	public  List<Map>getSendListForBuyJiSong(int id){
		
		List<Map>list=null;
		
		try {
			if(id<=0) {
				return list;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("id", id);
			
			list=sqlSession.selectList("activityDao.selZsListById",paramMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(list==null) {
			list=new ArrayList<Map>();
		}
		return list;
	}
	
	/**
	 * 获取买即送活动对应赠送的商品列表
	 * @param idList 活动Id 列表
	 * @return
	 */
	public  List<Map>getSendListForBuyJiSong(List<Integer>idList){
		
		List<Map>list=null;
		
		try {
			if(idList==null ||idList.isEmpty()) {
				return list;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("idList", idList);
			
			list=sqlSession.selectList("cn.dao.activityDao.selZsListById",paramMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(list==null) {
			list=new ArrayList<Map>();
		}
		return list;
	}
	
}
