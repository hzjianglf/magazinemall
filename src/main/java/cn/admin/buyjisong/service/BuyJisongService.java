package cn.admin.buyjisong.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
@Service
@Transactional
public class BuyJisongService {
	@Autowired
	SqlSession sqlSession;

	public long selectCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("buyJisongDao.selectCount",paramap);
	}

	public List selectContent(Map<String, Object> paramap) {
		return sqlSession.selectList("buyJisongDao.selectContent",paramap);
	}

	public int add(Map paramap) {
		int num = sqlSession.insert("buyJisongDao.addBuyJisong", paramap);
		try {
			if(num > 0){
				List list = new ArrayList();
				String json = paramap.get("shangpin")+"";
				JSONArray array = JSONArray.fromObject(json);
				if(array.size() > 0){
					for(int i=0;i<array.size();i++){
						JSONObject object = array.getJSONObject(i);
						Map ma = new HashMap();
						ma.put("productType", object.getString("productType")+"");
						ma.put("type", object.getString("type")+"");
						ma.put("buyJisongId", paramap.get("id")+"");
						if((object.getString("type")+"").equals("1")){
							ma.put("productId", object.getString("productId")+"");
						}else{
							ma.put("productId", object.getString("productId")+"");
						}
						list.add(ma);
					}
					paramap.put("list", list);
				}
				int row = sqlSession.insert("buyJisongDao.addBuyJingProduct", paramap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus()
			.setRollbackOnly();// 手动回滚
			return -1;
		}
		
		return num;
	}

	public int edit(Map paramap) {
		int num = sqlSession.update("buyJisongDao.editBuyJisong",paramap);
		try {
			if(num > 0){
				List list = new ArrayList();
				String json = paramap.get("shangpin")+"";
				JSONArray array = JSONArray.fromObject(json);
				if(array.size() > 0){
					for(int i=0;i<array.size();i++){
						JSONObject object = array.getJSONObject(i);
						Map ma = new HashMap();
						ma.put("productType", object.getString("productType")+"");
						ma.put("type", object.getString("type")+"");
						ma.put("buyJisongId", paramap.get("id")+"");
						if((object.getString("type")+"").equals("1")){
							ma.put("productId", object.getString("productId")+"");
						}else{
							ma.put("productId", object.getString("productId")+"");
						}
						list.add(ma);
					}
					paramap.put("list", list);
				}
				sqlSession.delete("buyJisongDao.delproduct",paramap);
				sqlSession.insert("buyJisongDao.addBuyJingProduct", paramap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus()
			.setRollbackOnly();// 手动回滚
			return -1;
		}
		
		return num;
	}

	public Map selById(String id) {
		Map map = sqlSession.selectOne("buyJisongDao.selById",id);
		List<Map> list = sqlSession.selectList("buyJisongDao.selBuyProList",id);
		map.put("list", list);
		return map;
	}

	public int delete(Map map) {
		return sqlSession.delete("buyJisongDao.delete", map);
	}
	//查询商品
	public long selectMagazineCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("buyJisongDao.selProductCount", reqMap);
	}
	public List selProduct(Map<String, Object> reqMap){
		return sqlSession.selectList("buyJisongDao.selProduct", reqMap);
	}
	//查询已关联的所有商品
	public List findByIdsAll(Map<String, Object> reqMap) {
		return sqlSession.selectList("buyJisongDao.findByIdsAll", reqMap);
	}
}
