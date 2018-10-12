package cn.api.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.util.DataConvert;


@Service
public class NewsService {

	
	@Autowired
	SqlSessionFactory sessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	/**
	 * 查询消息列表
	 * @param map
	 * @return
	 */
	public List selectNewList(Map<String, Object> map) {
		List<Map>  list=sqlSession.selectList("newsDao.selectNewList", map);
		try {
			List<Integer> idList=new ArrayList<Integer>();
			if(list!=null && !list.isEmpty()) {
				
				for (Map item : list) {
					idList.add(DataConvert.ToInteger(item.get("id")));
				}
				
				map.put("idList", idList);
				map.put("status", 2);
				sqlSession.update("newsDao.updateUserNew",map);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	/**
	 * 查询消息count
	 * @param map
	 * @return
	 */
	public long selectNewsCount(Map<String, Object> map) {
		return sqlSession.selectOne("newsDao.selectNewsCount", map);
	}
	
	/**
	 * 查询新消息数量
	 * @param map
	 * @return
	 */
	public long selectNewNewsCount(Map<String, Object> map) {
		return sqlSession.selectOne("newsDao.selectNewNewsCount", map);
	}
	
	
	/**
	 * 消息类型
	 */
	public enum NewsType{
		
		/**
		 * 关注
		 */
		favorite(1,"关注了你"),
		
		/**
		 * 打赏
		 */
		reward(3,"向您打赏了"),
		
		/**
		 * 提问
		 */
		question(4,"向您发起了一个提问"),
		
		/**
		 * 回答
		 */
		answer(5,"回答了您的提问");
		
		String content="";
		int value=0;
		private NewsType(int value,String content) {
			this.value=value;
			this.content=content;
		}
		
		public String getContent() {
			return this.content;
		}
		
		public int getValue() {
			return this.value;
		}
	}
	
	/**
	 * 添加消息
	 * @param fromUserId 来源
	 * @param toUserId 通知人
	 * @param dataId 数据Id
	 * @param type 消息类型
	 * @param money 打赏金额
	 */
	public void addUserNews(int fromUserId,int toUserId,int dataId,NewsType type,Double money) {
		
		try {
			
			if(fromUserId<=0||dataId<=0||toUserId<=0) {
				return;
			}
			
			/*if(toUserId==0) {
				//TODO 根据dataId 和 type 获取toUserId
			}*/
			
			int dataType=0;
			int newsType=type.getValue();
			String content=type.getContent();
			int fromUserType=0;
			boolean iszj=false;
			// 判断fromUser是否是专家
			Integer userId = sqlSession.selectOne("newsDao.selIsTeacher",fromUserId);
			if(null!=userId && userId>0){
				iszj=true;
			}
			if(iszj) {
				fromUserType=1;
			}
			//根据消息类型来分别处理
			switch (type) {
				case favorite:
					dataType=1;
					// 判断toUser是否关注 fromUser
//					Map<String,Object> map = new HashMap<String, Object>();
//					map.put("toUser", toUserId);
//					map.put("fromUser", fromUserId);
//					Integer newsId = sqlSession.selectOne("newsDao.selIsFavorite",map);
//					boolean flag=false;
//					if(null!=newsId && newsId>0){
//						flag=true;
//					}
//					if(flag) {
//						newsType=2;
//						//修改toUser为双向关注
//						int count = sqlSession.update("newsDao.updFavoriteByUserId",newsId);
//						if(count<=0){
//							return ;
//						}
//					}
					break;
				case reward:
						if(money<=0||money==null) {
							return;
						}
						dataType=1;
						content+=money+"元";
					break;
				case question:
				case answer:
					dataType=2;
					break;
			}
			
			if(dataType==0) {
				return;
			}
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("dataId",dataId );
			paramMap.put("dataType",dataType );
			paramMap.put("content",content );
			paramMap.put("toUserId",toUserId );
			paramMap.put("type", newsType);
			paramMap.put("fromUserId", fromUserId);
			paramMap.put("fromUserType",fromUserType );
			paramMap.put("remark", "");
			
			sqlSession.insert("newsDao.insertUserNew",paramMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
