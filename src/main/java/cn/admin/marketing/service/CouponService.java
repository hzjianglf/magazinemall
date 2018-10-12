package cn.admin.marketing.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.alibaba.druid.util.StringUtils;

@Service
@Transactional(rollbackFor = Exception.class)
public class CouponService {
	
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	
	//查询优惠券列表总数
	public long selTotalCount(Map search) {
		return sqlSession.selectOne("couponDao.selTotalCount", search);
	}
	//查询优惠券列表
	public List<Map> selCouponList(Map search) {
		return sqlSession.selectList("couponDao.selCouponList", search);
	}
	//查询详情
	public Map selDetail(String couponId) {
		return sqlSession.selectOne("couponDao.selDetail", couponId);
	}
	//期刊数量
	public long selQikanCount(Map<String, Object> map) {
		return sqlSession.selectOne("couponDao.selQikanCount", map);
	}
	//直播、点播总数
	public long selClassCount(Map<String, Object> map) {
		return sqlSession.selectOne("couponDao.selClassCount", map);
	}
	//专家总数
	public long selTeacherCount(Map<String, Object> map) {
		return sqlSession.selectOne("couponDao.selTeacherCount", map);
	}
	//查询期刊列表
	public List<Map> getQikanlist(Map map) {
		return sqlSession.selectList("couponDao.getQikanlist", map);
	}
	//查询点播课程、直播课程列表
	public List<Map> getClassList(Map map) {
		return sqlSession.selectList("couponDao.getClassList", map);
	}
	//获取专家列表
	public List<Map> getTeacherList(Map<String, Object> map) {
		return sqlSession.selectList("couponDao.getTeacherList", map);
	}
	
	//添加优惠券
	public int addCoupon(Map map) {
		
		int row = 0;
		try {
			/*String effectiveDate = map.get("effectiveDate")+"";
			if(StringUtils.isEmpty(effectiveDate) || effectiveDate.equals("null")){
				map.put("effectiveDate", 0);
			}*/
			int ro = sqlSession.insert("couponDao.addCoupon",map);
			if(ro<=0){
				throw new Exception("添加优惠券异常！");
			}
			
			//添加关联商品表
			//String[] ids = map.get("ids").toString().split(",");
			/*List list = new ArrayList();
			String json = map.get("ids")+"";
			JSONArray array = JSONArray.fromObject(json);
			if(array.size() > 0){
				for(int i=0;i<array.size();i++){
					Map ma = new HashMap();
					//第一个元素
					JSONObject object = array.getJSONObject(i);
					ma.put("productType", object.getString("productType")+"");
					ma.put("productId", object.getString("productId")+"");
					ma.put("activeId", map.get("couponId")+"");
					ma.put("activityType", 1);
					list.add(ma);
				}
				map.put("list", list);
				//添加中间表
				int row2 = sqlSession.insert("shareDao.addShareSalesProduct", map);
				if(row2<=0){
					throw new Exception("添加优惠券和商品关系表异常！");
				}
			}*/
			
			row = 1;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return row;
	}
	//修改优惠券信息
	public int updCoupon(Map map) {
		
		int result = 0;
		try {
			/*String effectiveDate = map.get("effectiveDate")+"";
			if(StringUtils.isEmpty(effectiveDate) || effectiveDate.equals("null")){
				map.put("effectiveDate", 0);
			}*/
			int row = sqlSession.update("couponDao.updCoupon",map);//修改优惠券信息
			//修改商品关联表
			/*List list = new ArrayList();
			String json = map.get("ids")+"";
			JSONArray array = JSONArray.fromObject(json);
			if(array.size() > 0){
				for(int i=0;i<array.size();i++){
					Map ma = new HashMap();
					//第一个元素
					JSONObject object = array.getJSONObject(i);
					ma.put("productType", object.getString("productType")+"");
					ma.put("productId", object.getString("productId")+"");
					ma.put("activeId", map.get("couponId")+"");
					ma.put("activityType", 1);
					list.add(ma);
				}
				map.put("list", list);
				//先删除中间表，后添加
				map.put("id", map.get("couponId")+"");
				map.put("activityType", 1);
				sqlSession.delete("shareDao.delShareSalesProduct", map);
				//添加中间表
				int row2 = sqlSession.insert("shareDao.addShareSalesProduct", map);
				
			}*/
		
			result=1;
		} catch (Exception e) {
			// TODO: handle exception
		}
		return result;
	}
	//删除优惠券
	public int delCouponInfo(int couponId) {
		return sqlSession.update("couponDao.delCouponInfo",couponId);
	}
	//查询用户数量
	public long selUserTotalCount(Map search) {
		return sqlSession.selectOne("couponDao.selUserTotalCount", search);
	}
	//查询用户信息
	public List selUserInfo(Map search) {
		return sqlSession.selectList("couponDao.selUserInfo",search);
	}
	//查询该优惠券的剩余数量
	public int selCouponCount(int couponId) {
		return sqlSession.selectOne("couponDao.selCouponCount", couponId);
	}
	//发放优惠券，并且修改优惠券的剩余数量
	public int grantCoupon(Map<String, Object> search) {
		int row = 0;
		String[] userId = search.get("userIds").toString().split(",");
		try {
			for (String str : userId) {
				search.put("userId", str);
				int rw = sqlSession.insert("couponDao.addCouponUser",search);
				if(rw<=0){
					throw new Exception("添加优惠券和用户关系表异常！");
				}
			}
			
			int ro = sqlSession.update("couponDao.updCouponCount",search);//修改优惠券的剩余数量和发行数量
			if(ro<=0){
				throw new Exception("修改优惠券剩余数量异常");
			}
			
			row = 1;
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		
		return row;
		
	}
	//查询已发优惠券数量
	public long alreadyGrantCount(Map search) {
		return sqlSession.selectOne("couponDao.alreadyGrantCount", search);
	}
	//查询已发优惠券信息
	public List<Map> selAlreadyGrantList(Map search) {
		return sqlSession.selectList("couponDao.selAlreadyGrantList", search);
	}

}
