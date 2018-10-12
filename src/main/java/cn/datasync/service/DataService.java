package cn.datasync.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 现有数据库
 * @author xiaoxueling
 *
 */
@Service
public class DataService {

	@Autowired
	SqlSession sqlSession;
	
	public List<Map> getBooks(){
		return sqlSession.selectList("dataDao.selectBook");
	}
}
