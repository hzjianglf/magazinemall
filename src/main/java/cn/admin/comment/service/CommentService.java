package cn.admin.comment.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CommentService {
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	
	//评论查询总条数
	public long selCommentCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("commentDao.selCommentCount", reqMap);
	}
	//评论查询列表
	public List<Map<String, Object>> selOndemandList(Map<String, Object> reqMap) {
		return sqlSession.selectList("commentDao.selCommentList", reqMap);
	}
	//评论修改状态
	public int updateStatus(Map map) {
		return sqlSession.update("commentDao.updateStatus", map);
	}
	//删除评论
	public int deleteComment(Map map) {
		return sqlSession.delete("commentDao.deleteComment", map);
	}
	//批量修改启动或禁用
	public long modifyStatus(Map<String, Object> map) {
		return sqlSession.update("commentDao.modifyStatus", map);
	}
	//批量删除评论	
	public long deleteids(Map<String, Object> map) {
		return sqlSession.delete("commentDao.deleteids", map);
	}
	//审核
	public int toExamine(Map map) {
		return sqlSession.update("commentDao.toExamine", map);
	}
	//取消审核
	public int cancelExamine(Map map) {
		return sqlSession.update("commentDao.cancelExamine", map);
	}
}
