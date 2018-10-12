package cn.admin.sumproduct.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.util.DataConvert;

@Service
@Transactional
public class SumProductService {
	@Autowired
	private SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	
	//合集数据列表
	public long getSumProductCount(Map<String, Object> map) {
		return sqlSession.selectOne("sumproductDao.getSumProductCount", map);
	}
	public List<Map<String, Object>> getSumProductList(Map<String, Object> map) {
		return sqlSession.selectList("sumproductDao.getSumProductList", map);
	}
	public List selDictionary() {
		return sqlSession.selectList("sumproductDao.selDictionary");
	}
	//查询课程数量
	public long getProducotCount(Map<String, Object> map) {
		if(DataConvert.ToInteger(map.get("classtype"))==2) {
			return sqlSession.selectOne("sumproductDao.getBookProducotCount",map);
		}
		return sqlSession.selectOne("sumproductDao.getProducotCount",map);
	}
	//查询课程数据
	public List<Map<String, Object>> getProducotList(Map<String, Object> map) {
		if(DataConvert.ToInteger(map.get("classtype"))==2) {
			return sqlSession.selectList("sumproductDao.getBookProducotList",map);
		}
		return sqlSession.selectList("sumproductDao.getProducotList",map);
	}
	
	public int add(Map paramap) {
		try {
			if(DataConvert.ToInteger(paramap.get("classtype"))==2) {
				//创建的是刊物合集
				int state = DataConvert.ToInteger(paramap.get("open"));
				if(state==1) {//上架
					paramap.put("state", 0);
				}else {
					paramap.put("state", 1);
				}
				int isSale = DataConvert.ToInteger(paramap.get("isSale"));
				if(isSale==1) {//纸质版
					paramap.put("isSalePaper", 1);
					paramap.put("isSaleEbook", 0);
				}else {
					paramap.put("isSaleEbook", 1);
					paramap.put("isSalePaper", 0);
				}
				sqlSession.insert("sumproductDao.addSumBookproduct", paramap);
				List<Map<String,Object>> list = new ArrayList();
				List<Map<String,Object>> qiciList = new ArrayList();
				String json = paramap.get("shangpin")+"";
				JSONArray array = JSONArray.fromObject(json);
				if(array.size() > 0){
					for(int i=0;i<array.size();i++){
						JSONObject object = array.getJSONObject(i);//{"productId":"4","price":0}
						Map ma = new HashMap();
						ma.put("bookid", object.getString("productId"));
						ma.put("productid", paramap.get("id")+"");
						ma.put("year", object.getString("price"));
						paramap.put("year", object.getString("price"));
						list.add(ma);
						qiciList.add(ma);
					}
					paramap.put("list", list);
				}
				sqlSession.insert("sumproductDao.addSubBookProduct", paramap);
				//查询合集期次表
				List<Integer> allPubIds = new ArrayList<>();
				for (Map<String,Object> subMap : qiciList) {
					List<Integer> ids = sqlSession.selectList("sumproductDao.selPublishByPeriod",subMap);
					allPubIds.addAll(ids);
				}
				StringBuffer allIds = new StringBuffer();
				for (Integer integer : allPubIds) {
					allIds.append(integer+",");
				}
				paramap.put("allIds", allIds.toString());
				sqlSession.update("sumproductDao.updSumBookproduct",paramap);
			}else {
				sqlSession.insert("sumproductDao.addSumproduct", paramap);
				List<Map<String,Object>> list = new ArrayList();
				String json = paramap.get("shangpin")+"";
				JSONArray array = JSONArray.fromObject(json);
				if(array.size() > 0){
					for(int i=0;i<array.size();i++){
						JSONObject object = array.getJSONObject(i);//{"productId":"4","price":0}
						Map ma = new HashMap();
						ma.put("itemId", object.getString("productId"));
						ma.put("year", object.getString("price"));
						ma.put("productid", paramap.get("id")+"");
						list.add(ma);
					}
					paramap.put("list", list);
				}
				sqlSession.insert("sumproductDao.addSubProduct", paramap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus()
			.setRollbackOnly();// 手动回滚
			return -1;
		}
		
		return 1;
	
	}
	public int edit(Map paramap) {
		try {
			if(DataConvert.ToInteger(paramap.get("classtype"))==2) {
				//创建的是刊物合集
				int state = DataConvert.ToInteger(paramap.get("open"));
				if(state==1) {//上架
					paramap.put("state", 0);
				}else {
					paramap.put("state", 1);
				}
				int isSale = DataConvert.ToInteger(paramap.get("isSale"));
				if(isSale==1) {//纸质版
					paramap.put("isSalePaper", 1);
					paramap.put("isSaleEbook", 0);
				}else {
					paramap.put("isSaleEbook", 1);
					paramap.put("isSalePaper", 0);
				}
				int num = sqlSession.update("sumproductDao.editSumBookproduct",paramap);
				if(num > 0){
					List<Map<String,Object>> qiciList = new ArrayList();
					List list = new ArrayList();
					String json = paramap.get("shangpin")+"";
					JSONArray array = JSONArray.fromObject(json);
					if(array.size() > 0){
						for(int i=0;i<array.size();i++){
							JSONObject object = array.getJSONObject(i);//{"productId":"4","price":0}
							Map ma = new HashMap();
							ma.put("bookid", object.getString("productId"));
							ma.put("year", object.getString("price"));
							ma.put("productid", paramap.get("id")+"");
							paramap.put("year",object.getString("price"));
							list.add(ma);
							qiciList.add(ma);
						}
						paramap.put("list", list);
					}
					sqlSession.delete("sumproductDao.delBookproduct",paramap);
					sqlSession.insert("sumproductDao.addSubBookProduct", paramap);
					//查询合集期次表
					List<Integer> allPubIds = new ArrayList<>();
					for (Map<String,Object> subMap : qiciList) {
						List<Integer> ids = sqlSession.selectList("sumproductDao.selPublishByPeriod",subMap);
						allPubIds.addAll(ids);
					}
					StringBuffer allIds = new StringBuffer();
					for (Integer integer : allPubIds) {
						allIds.append(integer+",");
					}
					paramap.put("allIds", allIds.toString());
					sqlSession.update("sumproductDao.updSumBookproduct",paramap);
				}
			}else {
				int num = sqlSession.update("sumproductDao.editSumproduct",paramap);
				if(num > 0){
					List list = new ArrayList();
					String json = paramap.get("shangpin")+"";
					JSONArray array = JSONArray.fromObject(json);
					if(array.size() > 0){
						for(int i=0;i<array.size();i++){
							JSONObject object = array.getJSONObject(i);//{"productId":"4","price":0}
							Map ma = new HashMap();
							ma.put("itemId", object.getString("productId"));
							ma.put("price", object.getString("price"));
							ma.put("productid", paramap.get("id")+"");
							list.add(ma);
						}
						paramap.put("list", list);
					}
					sqlSession.delete("sumproductDao.delproduct",paramap);
					sqlSession.insert("sumproductDao.addSubProduct", paramap);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus()
			.setRollbackOnly();// 手动回滚
			return -1;
		}
		
		return 1;
	
	}
	public Map<String,Object> selById(String id, String classtype) {
		Map<String,Object> map = new HashMap<String, Object>();
		if(DataConvert.ToInteger(classtype)==2) {
			//编辑刊物的合集
			map = sqlSession.selectOne("sumproductDao.selSumBookById",id);
			if(map!=null){
				List<Map<String,Object>> list = sqlSession.selectList("sumproductDao.selBookproductList",id);
				map.put("list", list);
			}
		}else {
			map = sqlSession.selectOne("sumproductDao.selSumById",id);
			if(map!=null){
				List<Map<String,Object>> list = sqlSession.selectList("sumproductDao.selproductList",id);
				map.put("list", list);
			}
		}
		return map;
	}
	public Map<String, Object> updStatus(Map<String, Object> parmap) {
		boolean flag = sqlSession.update("sumproductDao.updStatus",parmap)>0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("success", false);
		map.put("msg", "操作失败");
		if(flag){
			map.put("success", true);
			map.put("msg", "操作成功");
		}
		return map;
	}
	//查找所有的期刊的年份
	public List<String> selYears() {
		return sqlSession.selectList("sumproductDao.selYears");
	}
}
