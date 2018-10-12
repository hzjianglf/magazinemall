package cn.admin.marketing.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

@Service
@Transactional
public class VoucherService {
	@Autowired
	private SqlSession sqlSession;

	//查询代金券列表总数
	public long selTotalCount(Map search) {
		return sqlSession.selectOne("voucherDao.selTotalCount", search);
	}
	//查询代金券列表
	public List<Map<String,Object>> selVoucherList(Map search) {
		List<Map<String,Object>> listData = sqlSession.selectList("voucherDao.selVoucherList", search);
		//遍历判断日期是否过期
		for (Map<String, Object> map : listData) {
			if(map.get("endDate")!=null && map.get("endDate")!="") {
				String times = map.get("endDate").toString();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				try {
					Date endDate = sdf.parse(times);
					if(new Date().getTime() > endDate.getTime()) {
						map.put("timeStart",0);
					}else {
						map.put("timeStart",1);
					}
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
		
		return listData;
	}
	//查询详情
	public Map selDetail(String voucherId) {
		return sqlSession.selectOne("voucherDao.selDetail", voucherId);
	}
	//添加代金券
	public int addVoucher(Map map) {
		int row = 0;
		try {
			int ro = sqlSession.insert("voucherDao.addVoucher",map);
			if(ro<=0){
				throw new Exception("添加代金券异常！");
			}
			row = 1;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return row;
	}
	//修改代金券信息
	public int updVoucher(Map map) {
		int result = 0;
		try {
			int row = sqlSession.update("voucherDao.updVoucher",map);//修改优惠券信息
			result=1;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return result;
	}
	//删除代金券
	public int delVoucherById(int voucherId) {
		return sqlSession.update("voucherDao.delVoucherById",voucherId);
	}
	//查询该优惠券的剩余数量
	public int selVoucherCount(int voucherId) {
		return sqlSession.selectOne("voucherDao.selVoucherCount", voucherId);
	}
	//查询用户数量
	public long selUserTotalCount(Map search) {
		return sqlSession.selectOne("voucherDao.selUserTotalCount", search);
	}
	//查询用户信息
	public List selUserInfo(Map search) {
		return sqlSession.selectList("voucherDao.selUserInfo",search);
	}
	//发放代金券，并且修改代金券的剩余数量
	public int grantVoucher(Map<String, Object> search) {
		int row = 0;
		String[] userId = search.get("userIds").toString().split(",");
		try {
			for (String str : userId) {
				search.put("userId", str);
				int rw = sqlSession.insert("voucherDao.addVoucherUser",search);
				if(rw<=0){
					throw new Exception("添加优惠券和用户关系表异常！");
				}
			}
			
			int ro = sqlSession.update("voucherDao.updVoucherCount",search);//修改优惠券的剩余数量和发行数量
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
	//启用禁用
	public Map<String, Object> changeStateById(Map<String, Object> map) {
		Map<String,Object> result = new HashMap<String,Object>();
		result.put("result", false);
		result.put("msg", "操作失败");
		boolean flag = sqlSession.update("voucherDao.changeStateById",map)>0;
		if(flag){
			result.put("result", true);
			result.put("msg", "操作成功");
		}
		return result;
	}
	//查询已发代金券数量
	public long alreadyGrantCount(Map search){
		return sqlSession.selectOne("voucherDao.alreadyGrantCount", search);
	}
	//查询已发代金券信息
	public List<Map> selAlreadyGrantList(Map search) {
		return sqlSession.selectList("voucherDao.selAlreadyGrantList", search);
	}
}
