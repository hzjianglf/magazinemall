package cn.admin.marketing.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 分享销售
 * @author baoxuechao
 *
 */
@Service
public class ShareSalesService {

	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	/**
	 * 分享销售count
	 * @param reqMap
	 * @return
	 */
	public long selShareSalesCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("shareDao.selShareSalesCount", reqMap);
	}
	/**
	 * 分享销售列表
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selShareSalesList(
			Map<String, Object> reqMap) {
		return sqlSession.selectList("shareDao.selShareSalesList", reqMap);
	}
	/**
	 * 删除
	 * @param map
	 * @return
	 */
	public int deleteShare(Map map) {
		return sqlSession.delete("shareDao.deleteShare", map);
	}
	/**
	 * 添加活动
	 * @param map
	 * @return
	 */
	@Transactional
	public int addShareSales(Map map) {
		int row = sqlSession.insert("shareDao.addShareSales", map);
		int row2 = 0;
		if(row > 0){
			List list = new ArrayList();
			String json = map.get("shangpin")+"";
			JSONArray array = JSONArray.fromObject(json);
			if(array.size() > 0){
				for(int i=0;i<array.size();i++){
					Map ma = new HashMap();
					//第一个元素
					JSONObject object = array.getJSONObject(i);
					ma.put("productType", object.getString("productType")+"");
					ma.put("productId", object.getString("productId")+"");
					ma.put("activeId", map.get("id")+"");
					ma.put("activityType", 2);
					list.add(ma);
				}
				map.put("list", list);
				//添加中间表
				row2 = sqlSession.insert("shareDao.addShareSalesProduct", map);
			}
		}
		return row+row2;
	}
	/**
	 * 编辑活动
	 * @param map
	 * @return
	 */
	@Transactional
	public int UpShareSales(Map map) {
		int row = sqlSession.update("shareDao.UpShareSales", map);
		int row2 = 0;
		if(row > 0){
			List list = new ArrayList();
			String json = map.get("shangpin")+"";
			JSONArray array = JSONArray.fromObject(json);
			if(array.size() > 0){
				for(int i=0;i<array.size();i++){
					Map ma = new HashMap();
					//第一个元素
					JSONObject object = array.getJSONObject(i);
					ma.put("productType", object.getString("productType")+"");
					ma.put("productId", object.getString("productId")+"");
					ma.put("activeId", map.get("id")+"");
					ma.put("activityType", 2);
					list.add(ma);
				}
				map.put("list", list);
				//先删除中间表，后添加
				map.put("activityType", 2);
				sqlSession.delete("shareDao.delShareSalesProduct", map);
				//添加中间表
				row2 = sqlSession.insert("shareDao.addShareSalesProduct", map);
			}
		}
		return row+row2;
	}
	//查询商品
	public long selectMagazineCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("shareDao.selProductCount", reqMap);
	}
	public List selProduct(Map<String, Object> reqMap){
		return sqlSession.selectList("shareDao.selProduct", reqMap);
	}
	//查询已关联的所有商品
	public List findByIdsAll(Map<String, Object> reqMap) {
		return sqlSession.selectList("shareDao.findByIdsAll", reqMap);
	}
	//根据id查询详情
	public Map<String, Object> findByIdshareSales(Map map) {
		return sqlSession.selectOne("shareDao.findByIdshareSales", map);
	}
	//查询活动关联商品
	public List selectRelationProduct(Map map) {
		return sqlSession.selectList("shareDao.selectRelationProduct", map);
	}
	
	
	
	
}
