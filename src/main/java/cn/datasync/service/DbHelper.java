package cn.datasync.service;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cn.util.StringHelper;
import net.bytebuddy.asm.Advice.This;

public class DbHelper {
	
	private String driver="com.mysql.jdbc.Driver";
    private String url="jdbc:mysql://192.168.1.133:3306/magezinemall_customer?useUnicode=true&characterEncoding=UTF-8&ENGINE=InnoDB";
    private String userName="p2proot";
    private String password="pxkj123";
    
    private Connection conn=null;
    private PreparedStatement pstmt = null;
    
    public DbHelper() {
    	
    }
    
    public DbHelper(String url) {
    	this(url,null,null);
    }
    
    public DbHelper(String url,String userName,String password) {
    	this(null,url,userName,password);
    }
    
    public DbHelper(String driver,String url,String userName,String password) {
    	if(driver!=null) {
    		this.driver=driver;
    	}
    	if(url!=null) {
    		this.url=url;
    	}
    	if(userName!=null) {
    		this.userName=userName;
    	}
    	if(password!=null) {
    		this.password=password;
    	}
    }
    
    private  Connection getConnection(){
        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        try {
            conn=DriverManager.getConnection(url, userName, password);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }
    
    private  PreparedStatement getStatement(String sql,List<Object>params) {
        try {
            getConnection();
            pstmt=conn.prepareStatement(sql);
            if(params!=null&&!params.isEmpty()){
                for(int i=0;i<params.size();i++){
                    pstmt.setObject(i+1, params.get(i));
                }
            } 
        } catch (SQLException e) {
            e.printStackTrace();
        }
    	return pstmt;
    }
    
    /**
     *用于查询，返回结果集 
     * @param sql
     * @return
     */
    public List<Map<String,Object>> excuteQuery(String sql) throws SQLException{
    	return this.excuteQuery(sql, null);
    }
    
    /**
     * 用于查询，返回结果集 
     * @param sql
     * @param params
     * @return
     */
    public List<Map<String,Object>> excuteQuery(String sql,List<Object>params) throws SQLException{
    	ResultSet rs=null;
    	try {
        	getStatement(sql,params);
        	rs=pstmt.executeQuery();
        	return resultToListMap(rs);
        } catch (SQLException e) {
        	throw new SQLException(e); 
        }finally{
            closeAll(rs);
        }
    }
    
    
    /**
     *返回单个结果的值
     * @param sql
     * @return
     */
    public Object getSingle(String sql) throws SQLException{
    	return this.getSingle(sql,null);
    }
    
    /**
     *返回单个结果的值
     * @param sql
     * @return
     */
    public Object getSingle(String sql,List<Object>params) throws SQLException{
    	Object result=null;
    	ResultSet rs=null;
    	try {
        	getStatement(sql,params);
        	rs=pstmt.executeQuery();
        	if(rs.next()) {
        		result=rs.getObject(1);
        	}
        } catch (SQLException e) {
        	throw new SQLException(e); 
        }finally{
            closeAll(rs);
        }
    	return result;
    }
    
    /**
     * 插入值后返回主键值
     * @param sql
     * @return
     * @throws SQLException
     */
    public Object insertWithReturnPrimekey(String sql) throws SQLException {
    	return this.insertWithReturnPrimekey(sql,null);
    }
    
    /**
     * 插入值后返回主键值
     * @param sql
     * @param params
     * @return
     * @throws SQLException
     */
    public Object insertWithReturnPrimekey(String sql,List<Object>params) throws SQLException {
    	
    	Object result=null;
    	
    	ResultSet rs=null;
    	
    	try {
    		 getConnection();
             pstmt=conn.prepareStatement(sql,PreparedStatement.RETURN_GENERATED_KEYS);
             if(params!=null){
                 for(int i=0;i<params.size();i++){
                     pstmt.setObject(i+1, params.get(i));
                 }
             } 
        	pstmt.executeUpdate();
        	rs=pstmt.getGeneratedKeys();
    		if(rs.next()) {
        		result=rs.getObject(1);
        	}
        } catch (SQLException e) {
        	throw new SQLException(e); 
        }finally{
            closeAll(rs);
        }
    	
    	return result;
    	
    }
    
    /**
     * 添加、更新、删除操作
     * @param sql
     * @return true or false
     * @throws SQLException 
     */
    public boolean excuteUpdate(String sql) throws SQLException{
    	return this.excuteUpdate(sql, null);
    }
    
    /**
     * 添加、更新、删除操作
     * @param sql
     * @param params
     * @return true or false
     * @throws SQLException 
     */
    public boolean excuteUpdate(String sql,List<Object> params) throws SQLException{
    	//受影响的行数
    	int res=0;
        try {
        	getStatement(sql, params);
            res=pstmt.executeUpdate();
        } catch (SQLException e) {
        	throw new SQLException(e); 
        }finally{
            closeAll(null);
        }
        return res>0?true:false;
    }
     
    /**
     * 查询返回实体对象
     * @param sql
     * @param params
     * @param cls
     * @return
     */
    public <T> List<T> executeQuery(String sql,List<Object> params,Class<T> cls) throws Exception{
        ResultSet rs=null;
        List<T> data=new ArrayList<T>();
        try {
            getStatement(sql, params);
            rs=pstmt.executeQuery();
            while(rs.next()){
                T m=cls.newInstance();
                ResultSetMetaData rsd=rs.getMetaData();
                for(int i=0;i<rsd.getColumnCount();i++){
                    String col_name=rsd.getColumnName(i+1);
                    Object value=rs.getObject(col_name);
                    Field field=cls.getDeclaredField(col_name);
                    field.setAccessible(true);
                    
                    String typeString = field.getGenericType().toString().toLowerCase();
                    if(!StringHelper.IsNullOrEmpty(typeString)) {
                    	
                    	if(typeString.contains("boolean")) {
                    		value=rs.getBoolean(col_name);
                    	}else if (typeString.contains("date")) {
                    		value=rs.getTime(col_name);
						}else if (typeString.contains("float")) {
							value=rs.getFloat(col_name);
						}else if (typeString.contains("double")) {
							value=rs.getDouble(col_name);
						}else if (typeString.contains("long")) {
							value=rs.getLong(col_name);
						}else if (typeString.contains("int")) {
							value=rs.getInt(col_name);
						}else if (typeString.contains("string")) {
							value=rs.getString(col_name);
						}
                    }
                   
                    field.set(m, value);
                }
                data.add(m);
            }
             
        } catch (SQLException e) {
            e.printStackTrace();
        }finally{
            closeAll(rs);
        }
        return data;
    }
    
    /**
     * result To List Map
     * @param rs
     * @return
     * @throws SQLException
     */
    private  List<Map<String,Object>> resultToListMap(ResultSet rs) throws SQLException{
        List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
        while (rs.next()) {
            ResultSetMetaData md = rs.getMetaData();
            Map<String,Object> map = new HashMap<String,Object>();  
            for (int i = 1; i < md.getColumnCount(); i++) {
            	String columnName=md.getColumnLabel(i);
            	Object value=null;
            	try {
                	value=rs.getObject(i);
				} catch (Exception e) {
					e.printStackTrace();
				}
            	map.put(columnName, value);  
            }  
            list.add(map);  
        }  
        return list;  
    } 
    

    private void closeAll(ResultSet rs){
        try {
            if(rs!=null&&!rs.isClosed()){
                rs.close();
            }
            if(pstmt!=null&&!pstmt.isClosed()){
                pstmt.close();
            }
            if(conn!=null&&!conn.isClosed()){
            	conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
