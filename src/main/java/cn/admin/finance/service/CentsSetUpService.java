package cn.admin.finance.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.alibaba.druid.util.StringUtils;

@Service
public class CentsSetUpService {
	
	@Autowired
	SqlSession sqlSession;
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	
	//分账设置数量
	public long selTotalCount(Map search) {
		return sqlSession.selectOne("sentsSetUpDao.selTotalCount", search);
	}
	//分账设置列表数据
	public List<Map> getcentsSetUpList(Map search) {
		return sqlSession.selectList("sentsSetUpDao.getcentsSetUpList", search);
				
	}
	//查询用户信息
	public Map getuserinfoById(int userId) {
		return sqlSession.selectOne("sentsSetUpDao.getuserinfoById", userId);
	}
	//查询专家的所有课程
	public List<Map> selTeachersClass(int userId) {
		return sqlSession.selectList("sentsSetUpDao.selTeachersClass", userId);
	}
	//查询分账设置表中是否有该用户的信息
	public int selInfoIsHave(String userId) {
		return sqlSession.selectOne("sentsSetUpDao.selInfoIsHave", userId);
	}
	public int updSetUpInfo(Map<String,Object> map) {
		int result = 0;
		try {
			int noSetCount = 0;
			int setCount = 0;
			for(String dataKey : map.keySet()){ 
				Map<String,Object> info = new HashMap<String, Object>();
				if(dataKey.indexOf("classinfo")>-1){
					String[] ids = dataKey.split("_");
					info.put("classId", ids[1]);
					String classRate = map.get(dataKey)+"";
					if(!StringUtils.isEmpty(classRate)){
						info.put("classRate", classRate);
						sqlSession.update("sentsSetUpDao.updClassRate",info);
						setCount += 1;
					}else{
						noSetCount += 1;
					}
				}
			}
			map.put("noSetCount", noSetCount);
			map.put("setCount", setCount);
			
			int isHave = Integer.parseInt(map.get("isHave")+"");
			if(isHave==0){//不存在时保存
				sqlSession.insert("sentsSetUpDao.addSetUpInfo",map);
			}else{//存在时修改
				sqlSession.update("sentsSetUpDao.updSetUpInfo",map);
			}
			
			result = 1;
		} catch (Exception e) {
			System.out.println(e.getMessage());
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		
		return result;
	}
	//修改分成设置的状态
	public int setUpStatus(Map map) {
		return sqlSession.update("sentsSetUpDao.setUpStatus",map);
	}
	
	
}
