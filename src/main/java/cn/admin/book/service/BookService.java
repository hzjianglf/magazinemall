package cn.admin.book.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.aspectj.weaver.ast.Var;
import org.h2.util.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import cn.api.service.ProductService;
import cn.util.DataConvert;
import cn.util.StringHelper;


@Service
@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class BookService {
	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	@Autowired
	private ProductService productService;
	@Autowired
	private MyThread myThread;
	
	//图书期刊总条数
	public long getbookCount(Map<String, Object> request) {
		return sqlSession.selectOne("cn.dao.bookDao.getbookCount", request);
	}
	//图书期刊数据列表
	public List<Map<String, Object>> getbookList(
			Map<String, Object> request) {
		return sqlSession.selectList("cn.dao.bookDao.getbookList", request);
	}
	
	//电子图书期刊总条数
	public long getebookCount(Map<String, Object> request) {
		return sqlSession.selectOne("cn.dao.bookDao.getebookCount", request);
	}
	
	/**
	 * 年份列表
	 * @return
	 */
	public List<String> getYears(){
		return sqlSession.selectList("cn.dao.bookDao.getYears");
	}
	
	/**
	 * 获取期刊类别
	 * @return
	 */
	public List<Map<String, Object>>getPeriodicalList(){
		return sqlSession.selectList("cn.dao.bookDao.selectPeriodicalList");
	}
	
	//电子图书期刊数据列表
	public List<Map<String, Object>> getebookList(
			Map<String, Object> request) {
		return sqlSession.selectList("cn.dao.bookDao.getebookList", request);
	}
	//修改电子期刊的状态
	public long upPubByIdToStatus(Map<String,Object> map){
		return sqlSession.update("cn.dao.bookDao.upPubByIdToStatus", map);
	}
	/**
	 * 获取合集的期次列表
	 * @param perId 刊物id
	 * @param type 1--上半年 2--下半年 3--全年
	 * @param year  年份
	 * @return
	 */
	public List<Integer>getPeriodList(int perId,int type,String year){
		List<Integer>list=new ArrayList<Integer>();
		
		Map<String,Object> paramMap=new HashMap<String,Object>();
		paramMap.put("perId", perId);
		paramMap.put("year", year);
		
		List<Integer> idList=sqlSession.selectList("cn.dao.bookDao.getPeriodIdList", paramMap);
		if(idList!=null&&!idList.isEmpty()) {
			int totalCount=idList.size();
			if(totalCount==1) {
				type=3;
			}
			int start=0;
			int end=0;
			switch (type) {
				case 1:
					start=0;
					end=totalCount/2;
					break;
				case 2:
					start=totalCount/2;
					end=totalCount;
					break;
				case 3:
					start=0;
					end=totalCount;
					break;
			}
			
			for(;start<end;start++) {
				list.add(idList.get(start));
			}
		}
		
		return list;
	}
	
	/**
	 * 获取物流模板列表
	 * @return
	 */
	public List<Map<String, Object>>getLogisticsTemplateList(){
		return sqlSession.selectList("cn.dao.bookDao.selectLogisticsTemplateList");
	}
	
	//添加图书期刊
	public Map<String,Object> adds(Map<String, Object> param) {
		Map<String,Object> map = new HashMap<String, Object>();
		long row=0;
		if(StringHelper.IsNullOrEmpty(DataConvert.ToString(param.get("ebookPrice")))){
			param.put("ebookPrice", "0");
		}
		
		int isSaleEbook=DataConvert.ToInteger(param.get("isSaleEbook"),1);
		if(isSaleEbook==0) {
			param.put("ebookPrice", "0");
		}
		
		param.put("isShowAsProduct", DataConvert.ToInteger(param.get("isShowAsProduct"),0)+"");
		param.put("isSalePaper", DataConvert.ToInteger(param.get("isSalePaper"),1)+"");
		param.put("isSaleEbook", isSaleEbook+"");
		
		//判断是否是合集
		int sumType=DataConvert.ToInteger(param.get("sumType"));
		param.put("sumType", sumType+"");
		int perId=DataConvert.ToInteger(param.get("perId"));
		String year=DataConvert.ToString(param.get("year"));
		if(sumType!=0) {
			//获取合集对应的期次id列表
			List<Integer>list=getPeriodList(perId,sumType,year);
			if(list==null||list.isEmpty()) {
				map.put("success", false);
				map.put("msg", "保存失败:未找到对应的出版计划！");
				return map;
			}
			param.put("desc",StringHelper.Join(",",list.toArray()));
			param.put("period",list.get(0));
		}else {
			param.put("desc",param.get("period"));
		}
		
		param.put("periodicalId", perId+"");
		int id=DataConvert.ToInteger(param.get("id"));
		
		//判断是否是重复添加同一期刊
		long count=sqlSession.selectOne("cn.dao.bookDao.selectBook", param);
		if(count>0) {
			map.put("success", false);
			map.put("msg", "保存失败:不允许重复添加期刊！");
			
			return map;
		}
		
		if(id>0){//修改
			row = sqlSession.update("cn.dao.bookDao.ups", param);
		}else{//添加
			param.put("founder", session.getAttribute("loginUser"));
			row = sqlSession.insert("cn.dao.bookDao.adds", param);
		}
		
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "保存成功！");
		} else {
			map.put("success", false);
			map.put("msg", "保存失败！");
		}
		map.put("id", param.get("id"));
		
		return map;
	}
	
	//通过id查询图书期刊
	public Map<String, Object> selOne(String id) {
		return sqlSession.selectOne("cn.dao.bookDao.selOne", id);
	}
	//修改图书期刊
	public Map<String, Object> ups(Map<String, Object> param) {
		long row = sqlSession.update("cn.dao.bookDao.ups", param);
		Map<String, Object> map = new HashMap<String, Object>();
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "修改成功！");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败！");
		}
		return map;
	}
	//删除图书期刊
	public Map<String, Object> deleteBook(String id) {
		long row = sqlSession.delete("cn.dao.bookDao.deleteBook", id);
		Map<String, Object> map = new HashMap<String, Object>();
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "删除成功！");
		} else {
			map.put("success", false);
			map.put("msg", "删除失败！");
		}
		return map;
	}
	public Map<String, Object> upState(Map<String, Object> param) {
		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("id", id);
//		map.put("state", state);
		long row = sqlSession.update("cn.dao.bookDao.upState", param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "修改成功！");
		} else {
			map.put("success", false);
			map.put("msg", "修改失败！");
		}
		return map;
	}
	
	/**
	 * 获取刊物所有的年份
	 * @param paramMap
	 * @return
	 */
	public List<String>getYearsForPer(Map<String, Object>paramMap){
		return sqlSession.selectList("cn.dao.bookDao.selectYearForPerId", paramMap);
	}

	
	//查询年份
	public List<Map<String, Object>> selYear(Map<String, Object> map) {
		return sqlSession.selectList("cn.dao.bookDao.selYear", map);
	}
	//查询期次
	public List<Map<String, Object>> selPeriod(Map map) {
		return sqlSession.selectList("cn.dao.bookDao.selPeriod", map);
	}
	//查询期刊列表
	public List<Map<String, Object>> selPerList() {
		return sqlSession.selectList("cn.dao.bookDao.selPerList");
	}
	//添加图书期刊商品图片
	public Map<String,Object> upPictureUrl(Map<String, Object> param) {
		Map<String,Object> map = new HashMap<String, Object>();
		param.put("state", 0);
		long row = sqlSession.update("cn.dao.bookDao.upPictureUrl", param);
		if (row > 0) {
			map.put("success", true);
			map.put("msg", "操作成功！");
		} else {
			map.put("success", false);
			map.put("msg", "操作失败！");
		}
		return map;
	}
	//查询商品图片
	public String selPictureUrl(String id) {
		return sqlSession.selectOne("cn.dao.bookDao.selPictureUrl", id);
	}
	//查询出版期次
	public List<Map<String, Object>> selectPeriodlist(Map<String, Object> map) {
		return sqlSession.selectList("cn.dao.bookDao.selectPeriodlist", map);
	}
	/**
	 * 查询书刊杂志分类
	 * @param i
	 * @return
	 */
	public List selectMagazineType(int id) {
		return sqlSession.selectList("cn.dao.bookDao.selectMagazineType", id);
	}
	//查询是否有电子书
	public List selectIsEbook(Map<String, Object> map) {
		return sqlSession.selectList("cn.dao.bookDao.selectIsEbook", map);
	}
	
	/**
	 * 查询期次对应的电子书数量
	 * @param paramMap
	 * @return
	 */
	public long getEbookCountForSum(Map<String, Object>paramMap) {
		return sqlSession.selectOne("cn.dao.bookDao.selectHaveEbookForSum",paramMap);
	}
	
	/**
	 * 定时任务
	 * 	根据图书期刊设置的定时发布时间，自动发布图书期刊（每天晚上12点触发）
	 */
	@Scheduled(cron = "0 0 0 * * ? ")
	public void TimingRelease(){ 
		
		//先判断是否有需要定时发布的期刊，若有则执行线程方法
		List<Map> list=sqlSession.selectList("cn.dao.bookDao.selectTiming");
		if(list.size() > 0){
			Thread thread1 = new Thread(myThread); 
			Thread thread2 = new Thread(myThread);  
			thread1.start();
			thread2.start();
		}
	}
	public List getDocById(Map<String,Object> map) {
		List list = sqlSession.selectList("cn.dao.bookDao.selEbookByPubId",map);
		return list;
	}
	public Map<String,Object> selDocById(int DocId) {
		return sqlSession.selectOne("cn.dao.bookDao.selDocById",DocId);
	}
	public Map<String, Object> updDoc(Map<String, Object> param) {
		boolean flag = sqlSession.update("cn.dao.bookDao.updDoc",param)>0;
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("success", flag);
		if(flag){
			map.put("msg", "编辑成功");
		}else{
			map.put("msg", "编辑失败");
		}
		return map;
	}
	
	public long updStatusByID(Map<String,Object> map){
		return sqlSession.update("cn.dao.bookDao.updStatusByID", map);
	}
	public long delStatusByID(Map<String,Object> map){
		return sqlSession.update("cn.dao.bookDao.delStatusByID", map);
	}
	//查询所有的板块信息
	public List<Map<String,Object>> selCategoryAllName(Map<String,Object> map){
		return sqlSession.selectList("cn.dao.bookDao.selCategoryAllName",map);
	}
	//查询所有的栏目信息
	public List<Map<String,Object>> selColumnsAllName(Map<String,Object> map){
		return sqlSession.selectList("cn.dao.bookDao.selColumnsAllName",map);
	}
	//查询所有的期次
	public List selAllEbook() {
		return sqlSession.selectList("cn.dao.bookDao.getebookList");
	}
}
