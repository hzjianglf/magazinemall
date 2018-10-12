package cn.phone.home.service;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class HomeService {

	@Autowired
	SqlSession sqlSession;
	
	
}
