package cn.admin.system.service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.util.DataConvert;
import cn.util.NewExcelUtil;
import cn.util.StringHelper;

@Service
@Transactional(rollbackFor = Exception.class)
public class VersionService {
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	//统计版本列表
	public List<Map> selectAboutVersion(Map search) {
		return sqlSession.selectList("cn.dao.versionDao.selectAboutVersion", search);
	} 
	//统计版本数量
	public long selectAboutVersionCount(Map search) {
		return sqlSession.selectOne("cn.dao.versionDao.selectAboutVersionCount", search);
	}
	public Map selByVersionId(String id) {
		return sqlSession.selectOne("cn.dao.versionDao.selByVersionId",id);
	}
	
	public void newVersionToSave(Map<String, Object> paramap) {
		 sqlSession.insert("cn.dao.versionDao.newVersionToSave",paramap);
	}
	public void newVersionToUpdate(Map<String, Object> paramap) {
		 sqlSession.update("cn.dao.versionDao.newVersionToUpdate",paramap);
	}
	public void deleteVersionRecord(Map<String, Object> paramap) {
		 sqlSession.delete("cn.dao.versionDao.deleteVersionRecord",paramap);
	}
	/**
	 * 通过版本类型获取最新版本信息
	 * @param type
	 * @return
	 */
	public Map<String, Object> getLatestVersion(Integer type) {
		//通过版本类型获取最新版本信息
		Map<String,Object> result = new HashMap<String, Object>();
		Map<String,Object> latestVersionInfo = sqlSession.selectOne("cn.dao.versionDao.sellatestVersionInfo",type);
		if(latestVersionInfo !=null) {
			if(Integer.parseInt(((latestVersionInfo.get("isForceUpdate")).toString()))==0) {
				latestVersionInfo.put("isForceUpdate", false);
			}else if(Integer.parseInt(((latestVersionInfo.get("isForceUpdate")).toString()))==1) {
				latestVersionInfo.put("isForceUpdate", true);
			}
		}
		result.put("result", 1);
		result.put("data", latestVersionInfo);
		return result;
	}
	
	public Map<String,Object> sellatestVersionInfo(Integer type) {
		return sqlSession.selectOne("cn.dao.versionDao.sellatestVersionInfo",type);
	}
}
