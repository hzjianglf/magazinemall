package cn.api.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import cn.util.DataConvert;
import cn.util.StringHelper;


@Service
public class TeacherService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	@Autowired
	PathService pathService;
	
	//获取专家列表
	public List<Map<String,Object>> selExpertList(Map infoMap) {
		List<Map<String,Object>> list= sqlSession.selectList("teacherDao.selExpertList", infoMap);
		pathService.getAbsolutePath(list, "userUrl");
		for (Map<String, Object> map : list) {
			map.put("synopsis", StringHelper.cutString(DataConvert.ToString(map.get("synopsis")),84));
		}
		return list;
	}
	//查询专家列表count
	public long selectExpertCont(Map<String, Object> map) {
		return sqlSession.selectOne("teacherDao.selectExpertCont", map);
	}
	
	//查询专家扩展信息
	public Map selTeaContent(Map ma) {
		return sqlSession.selectOne("teacherDao.selTeaContent",ma);
	}
	//获取专家课程的最新的4条信息
	public List selectTeacherClass(Map<String, Object> map) {
		return sqlSession.selectList("teacherDao.selectTeacherClass", map);
	}
	
	//查询专家的课程列表
	public long getOndemandCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("teacherDao.getOndemandCount",paramap);
	}
	public List getOndemandList(Map<String, Object> paramap) {
		return sqlSession.selectList("teacherDao.getOndemandList",paramap);
	}
	//专家的问答记录
	public List selectTeacherAudit(Map<String, Object> map) {
		return sqlSession.selectList("teacherDao.selectTeacherAudit", map);
	}
	//专栏作家首页
	public Map<String,Object> selTeacherContent(Integer userId,Integer myUserId) {
		Map<String,Object> map = new HashMap<String,Object>();
		Map<String,Object> ma = new HashMap<String,Object>();
		map.put("result", 1);
		try {
			if(userId==null||myUserId==null){
				map.put("msg", "请输入专家id");
				map.put("result", 0);
				return map;
			}
			ma.put("userId", userId);
			ma.put("myUserId", myUserId);
			//专家详情信息
			Map result = sqlSession.selectOne("teacherDao.selTeaContent",ma);
			pathService.getAbsolutePath(result, "teacherUrl");
			//查询专家提问费用
			double money = sqlSession.selectOne("teacherDao.selQuestionInfo", ma);
			result.put("money", money);
			//查询专家课程，取4条记录
			List teacher = sqlSession.selectList("teacherDao.selectTeacherClass", ma);
			pathService.getAbsolutePath(teacher, "picUrl");
			result.put("teacherlist", teacher);
			//查询专家的问答记录
			ma.put("limit", 3);
			List auditlist = sqlSession.selectList("teacherDao.selectTeacherAudit", ma);
			pathService.getAbsolutePath(auditlist, "userUrl");
			result.put("auditlist", auditlist);
			//获取打赏专家的最新的三个人头像
			List userurl = sqlSession.selectList("teacherDao.selectUrl", ma);
			pathService.getAbsolutePath(userurl, "userUrl");
			result.put("userurl", userurl);
			//TODO 查询当前用户是否关注了这个专栏作家
			if(userId>0) {
				List<Map> m = sqlSession.selectList("teacherDao.selectIsFoolow", ma);
				if(!StringUtils.isEmpty(m) && m.size()>0){
					//已关注
					result.put("Isfoolow", 1);
				}else{
					//未关注
					result.put("Isfoolow", 0);
				}
			}else {
				//未关注
				result.put("Isfoolow", 0);
			}
			map.put("data", result);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", 0);
			map.put("msg", "获取信息失败");
		}
		return map;
	}
	public Map<String,Object> selTeacherContentByPC(Integer userId,Integer myUserId) {
		Map<String,Object> map = new HashMap<String,Object>();
		Map<String,Object> ma = new HashMap<String,Object>();
		map.put("result", 1);
		try {
			if(userId==null||myUserId==null){
				map.put("msg", "请输入专家id");
				map.put("result", 0);
				return map;
			}
			ma.put("userId", userId);
			ma.put("myUserId", myUserId);
			//专家详情信息
			Map result = sqlSession.selectOne("teacherDao.selTeaContent",ma);
			pathService.getAbsolutePath(result, "teacherUrl");
			//查询专家课程
			List teacher = sqlSession.selectList("teacherDao.getOndemandList", ma);
			pathService.getAbsolutePath(teacher, "picUrl");
			result.put("teacherlist", teacher);
			//TODO 查询当前用户是否关注了这个专栏作家
			if(userId>0) {
				List<Map> m = sqlSession.selectList("teacherDao.selectIsFoolow", ma);
				if(!StringUtils.isEmpty(m) && m.size()>0){
					//已关注
					result.put("Isfoolow", 1);
				}else{
					//未关注
					result.put("Isfoolow", 0);
				}
			}else {
				//未关注
				result.put("Isfoolow", 0);
			}
			map.put("data", result);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("result", 0);
			map.put("msg", "获取信息失败");
		}
		return map;
	}
	/**
	 * 专家销售记录list
	 * @param map
	 * @return
	 */
	public List selectMySalelogList(Map<String, Object> map) {
		return sqlSession.selectList("teacherDao.MySaleLogList", map);
	}
	/**
	 * 专家销售记录count
	 * @param map
	 * @return
	 */
	public long selectMySalelogCount(Map<String, Object> map) {
		return sqlSession.selectOne("teacherDao.MySaleLogCount", map);
	}
	/**
	 * 查询专栏作家信息
	 * @param userId
	 * @return
	 */
	public Map<String, Object> selectWriterMsg(String userId) {
		return sqlSession.selectOne("teacherDao.selectWriterMsg", userId);
	}
	//查询认证信息
	public Map<String, Object> selectApplyMsg(String userId) {
		return sqlSession.selectOne("teacherDao.selectApplyMsg", userId);
	}
	

}
