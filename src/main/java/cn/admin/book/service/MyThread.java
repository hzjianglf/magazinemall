package cn.admin.book.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.util.CalendarUntil;
import cn.util.DataConvert;

/**
 * 定时任务
 * @author Administrator
 *
 */
@Service
public class MyThread  implements Runnable {
	
	@Autowired
	SqlSession sqlSession;

	@Override
	public void run() {
		/**
		 * 执行定时任务处理方法
		 */
		HandleRelease();
	}
	
	/**
	 * 处理定时发布
	 */
	public synchronized void  HandleRelease(){
		//获取系统当前时间
		Date now = new Date();
		//查询所有的定时发布期刊
		List<Map> list=sqlSession.selectList("bookDao.selectTiming");
		for (Map map : list) {
			//取出定时发布时间
			Date publishTime=DataConvert.ToDate(map.get("publishTime"));
			
			//判断定时发布时间是否与当前时间相同
			if(publishTime==null||!now.before(publishTime)){
				sqlSession.update("bookDao.updatePublish", DataConvert.ToString(map.get("id")));
			}
		}
		//处理完毕，线程终止
		Thread.interrupted();
	}
	
}
