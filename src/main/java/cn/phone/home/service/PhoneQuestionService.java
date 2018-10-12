package cn.phone.home.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class PhoneQuestionService{
	
	@Autowired
	SqlSession sqlSession;
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	
	
	//查询提问页面信息/教师
	public String selQuestionInfo(int teacherId) {
		return sqlSession.selectOne("phoneQuestionDao.selQuestionInfo", teacherId);
	}

	public Map selTeacherName(int payLogId,String userId,int quesOrAnswer) {
		Map<String,Object> map = new HashMap<String,Object>();
		Map search = new HashMap();
		search.put("quesOrAnswer", quesOrAnswer);
		search.put("payLogId", payLogId);
		String teacherName = sqlSession.selectOne("phoneQuestionDao.teacherName", search);
		String balance = sqlSession.selectOne("phoneQuestionDao.selBalance", userId);
		map.put("teacherName", teacherName);
		map.put("balance", balance);
		return map;
	}
	
	//首页问答列表数量
	public long selQuestionCount() {
		return sqlSession.selectOne("phoneQuestionDao.selQuestionCount");
				
	}

	
}
