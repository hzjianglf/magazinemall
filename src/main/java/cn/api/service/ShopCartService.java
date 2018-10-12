package cn.api.service;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
@Service
@Transactional(rollbackFor = Exception.class)
public class ShopCartService {
	@Autowired
	SqlSession sqlSession;
	//加入购物车
	public int createCardShop(Map paramMap) {
		return sqlSession.insert("shopCartDao.createCardShop",paramMap);
	}

}
