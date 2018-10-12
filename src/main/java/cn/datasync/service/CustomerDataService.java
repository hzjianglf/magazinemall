package cn.datasync.service;

import java.sql.SQLException;

import org.springframework.stereotype.Service;

import cn.util.DataConvert;

/**
 * 客户数据库
 * @author xiaoxueling
 *
 */
@Service
public class CustomerDataService {
	
	private DbHelper dbHelper=null;
	
	public DbHelper getDbHelper() {
		if(dbHelper==null) {
			dbHelper=new DbHelper();
		}
		return dbHelper;
	}
	
	/**
	 * 获取会员总数量
	 * @return
	 */
	public long getUserCount(){
		try {
			return DataConvert.ToLong(getDbHelper().getSingle("SELECT count(1) FROM rc_member"));
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}
	
	
}
