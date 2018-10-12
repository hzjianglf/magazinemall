package cn.api.service;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.util.HtmlUtils;

import cn.Pay.provider.PayExtension;
import cn.Pay.provider.offlinepays.pursepay.PurseProvider;
import cn.Pay.service.payService;
import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.admin.book.service.BookService;
import cn.util.DataConvert;
import cn.util.DeHtml;
import cn.util.Page;
import cn.util.StringHelper;
import cn.util.Tools;
import cn.util.UtilDate;
import cn.util.page.PageInfo;

import com.alibaba.druid.util.StringUtils;
import com.alipay.api.domain.OrderItem;
import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mysql.fabric.xmlrpc.base.Array;
/**
 * 商品信息
 */
@Service
@Transactional(rollbackFor = Exception.class)
public class ProductService {

	@Autowired
	Setting setting;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	PayExtension payExtension;
	@Autowired 
	PurseProvider purseProvider;
	@Autowired
	private OrderService orderService;
	@Autowired
	private HttpSession session;
	@Autowired
	BookService bookService;
	@Autowired
	PathService pathService;
	@Autowired
	private ActivityService activityService;
	@Autowired
	private AccountService accountService;
	@Autowired
	payService payService;
	@Autowired
	PostageService postageService;
	@Autowired
	SearcheDiscountService searcheDiscountService;	//查询课程列表
	public List selCurriculum(Map<String, Object> map) {
		List<Map<String,Object>> list=sqlSession.selectList("productDao.selCurriculum", map);
		Map<String,Object> parmap = new HashMap<String,Object>();
		parmap.put("userId", map.get("userId"));
		for (Map map2 : list) {
			if(!StringUtils.isEmpty(DataConvert.ToString(map2.get("introduce")))) {
				map2.put("introduce", DeHtml.delHTMLTag( DataConvert.ToString(map2.get("introduce"))));
			}
			parmap.put("ondemandId",DataConvert.ToInteger(map2.get("ondemandId")));
			//查询用户信息是否是免购用户
			if(DataConvert.ToInteger(map.get("userId"))>0){
				int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(map.get("userId")));
				if(row==2) {//2代表免购用户
					list.stream().forEach(f->{
						f.put("isbuy", 2);
					});
				}else {
					if(1==DataConvert.ToInteger(map2.get("isSum"))){//合集是否购买
						int isbuy = sqlSession.selectOne("productDao.selIsBuySum",parmap);
						map2.put("isbuy", isbuy);
					}else{
						int isbuy = sqlSession.selectOne("productDao.selectIsByOndemand",parmap);
						map2.put("isbuy", isbuy);
					}
				}
			}else {
				map2.put("isbuy", 0);
			}
		}
		return list;
	}
	//推荐课程
	public List selRecommendList(Map<String, Object> map) {
		List<Map<String,Object>> list=sqlSession.selectList("productDao.selRecommendList", map);
		Map<String,Object> parmap = new HashMap<String,Object>();
		for (Map map2 : list) {
			if(!StringUtils.isEmpty(DataConvert.ToString(map2.get("introduce")))) {
				map2.put("introduce", DeHtml.delHTMLTag( DataConvert.ToString(map2.get("introduce"))));
			}
			parmap.put("ondemandId",DataConvert.ToInteger(map2.get("ondemandId")));
		}
		return list;
	}
	//查询课程count
	public long selCurriculumCount(Map<String, Object> map) {
		return sqlSession.selectOne("productDao.selCurriculumCount", map);
	}
	//推荐课程count
	public long selRecommendCount(Map<String, Object> map) {
		return sqlSession.selectOne("productDao.selRecommendCount", map);
	}
	//获取精选杂志列表
	public List selectMagazineList(Map<String, Object> map) {
		List<Map<String,Object>> list = sqlSession.selectList("productDao.selectMagazineList", map);
		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(map.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(map.get("userId")));
			if(row==2) {//2代表免购用户
				if(list.size()>0) {
					list.stream().forEach(f->{
						f.put("isbuy", 2);
					});
				}
			}else {
				if(list.size()>0) {
					for(Map item :list) {
						String period = item.get("period")+"";
						map.put("period", period);
						int isBuy = sqlSession.selectOne("productDao.getIsBuy",map);
						if((Double.parseDouble(item.get("ebookPrice").toString()))>0) {
							if(isBuy == 0) {
								item.put("isbuy", 0);
							}else {
								item.put("isbuy", 1);
							}
						}else {
							item.put("isbuy", 1);
						}
					}
				}
			}
		}
		return list;
	}
	
	public List getMagazinesById(Map<String, Object> map) {
		//通过bookeId获取desc字段
		Map<String,Object>  bookRecord = sqlSession.selectOne("productDao.getBookRecord", map.get("id").toString());
		List<Integer> descList = new ArrayList<Integer>();
		if(bookRecord !=null) {
			descList = StringHelper.ToIntegerList(bookRecord.get("desc").toString()+"");
			map.put("descList", descList);
		}
		List<Map<String,Object>> list = sqlSession.selectList("productDao.getMagazinesById", map);
		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(map.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(map.get("userId")));
			if(row==2) {//2代表免购用户
				list.stream().forEach(f->{
					f.put("isbuy", 2);
				});
			}
		}
		return list;
	}
	
	
	//获取列表记录数量
	public long selectMagazineCount(Map<String, Object> map) {
		return sqlSession.selectOne("productDao.selectMagazineCount", map);
	}
	//获取指定课程基础信息
	public List getOndemandContent(Map<String, Object> paramap) {
		List<Map<String,Object>> list = sqlSession.selectList("productDao.getOndemandContent",paramap);
		
		return list;
	}
	//获取课时的详细信息
	public Map<String, Object> getHourContent(Integer hourId) {
		//增加课时的播放次数和课程的播放次数
		sqlSession.update("productDao.updateHits", hourId);
		Map<String, Object> map = sqlSession.selectOne("productDao.getHourContent",hourId);
		//获取图片的json串变为list集合
		if(map.get("imgUrls") != null && map.get("imgUrls") != "") {
			try {
				List<String> imgUrls = new ObjectMapper().readValue(map.get("imgUrls").toString(), ArrayList.class);
				List<String> list = new ArrayList<String>();
				for (String imgUrl : imgUrls) {
					list.add(pathService.getAbsolutePath(imgUrl));
				}
				map.put("imgUrls", list);
			} catch (JsonParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JsonMappingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		pathService.getAbsolutePath(map, "content");
		SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
		String siteUrl="";
		if(siteInfo!=null){
			siteUrl=siteInfo.getSiteUrl();
		}
		if(!StringUtils.isEmpty(DataConvert.ToString(map.get("presentation")))) {
			map.put("present", DataConvert.ToString(map.get("presentation")));
			map.put("presentation",siteUrl+"/phone/product/presentation?hourId="+map.get("hourId"));
		}
		return map;
	}
	public Map<String, Object> getHourContentById(Integer hourId) {
		return sqlSession.selectOne("productDao.getHourContent",hourId);
	}
	//获取指定课程的评论列表
	public List selectCommentList(Map<String, Object> map) {
		List<Map> list = sqlSession.selectList("productDao.selectParentComment", map);
		for (Map map2 : list) {
			Map ma = new HashMap();
			ma.put("id", map2.get("id")+"");
			List li = sqlSession.selectList("productDao.selectCommentList", ma);
			map2.put("childList", li);
		}
		return list;
	}
	//获取指定课程的评论列表count
	public long selectCommentCount(Map<String, Object> map) {
		return sqlSession.selectOne("productDao.selectCommentCount", map);
	}
	//添加、回复评论
	public int addComment(Map<String, Object> map) {
		return sqlSession.insert("productDao.addComment", map);
	}
	//手机站获取精选杂志
	public List selectZazhiList() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", 0);
		map.put("pageSize", 5);
		map.put("orderType", 0);
		map.put("isTop", 1);
		return selectMagazineList(map);
	}
	//手机站获取推荐课程
	public List selKechengList() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", 0);
		map.put("pageSize", 3);
		map.put("recommend", 1);
		return sqlSession.selectList("productDao.selRecommendList",map);
	}
	//手机站获取推荐教师
	public List<Map<String,Object>> selTeacherList() {
		List<Map<String,Object>> list =  sqlSession.selectList("productDao.selTeacherList");
		for (Map<String, Object> map : list) {
			map.put("synopsis", StringHelper.cutString(DataConvert.ToString(map.get("synopsis")), 64));
		}
		return list;
	}
	//获取更多杂志
	public List<Map> getMoreMagazines(Map<String, Object> paramap) {
		
//		CASE WHEN b.ebookPrice>0 THEN 
//		CASE (select count(0) from orderitem ot 
//			LEFT JOIN `order` o on ot.orderId=o.id
//			LEFT join wechat_userinfo w on w.openId=o.openId
//			where FIND_IN_SET(b.period,ot.`desc`)>0
//			and (o.userId=#{userId} or (o.openId=w.openId and w.userId=#{userId}))
//			and ot.producttype=16)
//		WHEN 0 THEN 0 ELSE 1 END
//ELSE 1 END
		List<Map> list = sqlSession.selectList("productDao.getMoreMagazines",paramap);
		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(paramap.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(paramap.get("userId")));
			if(row==2) {//2代表免购用户
				if(list.size()>0) {
					list.stream().forEach(f->{
						f.put("isbuy", 2);
					});
				}
			}else {
				if(list.size()>0) {
					for(Map item :list) {
						//String userId = paramap.get("userId")+"";
						String period = item.get("period")+"";
						paramap.put("period", period);
						int isBuy = sqlSession.selectOne("productDao.getIsBuy",paramap);
						if((Double.parseDouble(item.get("ebookPrice").toString()))>0) {
							if(isBuy == 0) {
								item.put("isbuy", 0);
							}else {
								item.put("isbuy", 1);
							}
						}else {
							item.put("isbuy", 1);
						}
						
					}
				}
			}
		}
		return list;
	}
	public long getMoreMagazinesCount(Integer type) {
		return sqlSession.selectOne("productDao.getMoreMagazinesCount",type);
	}
	//获取指定期刊的详细信息
	public Map<String,Object> getMagazinesContent(Map<String, Object> maps) {
		Map<String,Object> detai  = sqlSession.selectOne("productDao.getMagazinesContent",maps);
		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(maps.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(maps.get("userId")));
			if(row==2) {//2代表免购用户
				detai.put("isbuy", 2);
			}
		}
		String describes = HtmlUtils.htmlUnescape(detai.get("describes")+"");
		detai.put("describes", describes);
		if(DataConvert.ToInteger(detai.get("sumType"))==0){//不是合集则查找相关是否有合集
			//查询纸质合集
			List bookList = sqlSession.selectList("productDao.selSumBookById",detai);
			
			pathService.getAbsolutePath(bookList, "picture");
			
			detai.put("bookList", bookList);
		}
		pathService.getAbsolutePath(detai, "picture","describes");
		
		//限时折扣价格添加
		if(detai!=null) {
			String proId = detai.get("id")+"";
			Map<String,Object> mapPrice = new HashMap<String,Object>();
			mapPrice.put("productId", proId);
			double conPrice = 0d;
			if(detai.get("isSalePaper")!=null && detai.get("isSalePaper").toString().equals("1") && proId!="") {
				mapPrice.put("type", 1);
				//访问接口返回价格返回期刊价格
				double price = searcheDiscountService.searchDiscountPrice(mapPrice);
				double paperPrice = DataConvert.ToDouble(detai.get("paperPrice"));
				conPrice = paperPrice;
				detai.put("paperPrice", price);
				detai.put("yuanPaperPrice", conPrice);
			}
			if(detai.get("isSaleEbook")!=null&&detai.get("isSaleEbook").toString().equals("1") && proId!="") {
				mapPrice.put("type", 2);
				//访问接口返回价格返回期刊价格
				double price = searcheDiscountService.searchDiscountPrice(mapPrice);
				double ebookPrice = DataConvert.ToDouble(detai.get("ebookPrice"));
				conPrice = ebookPrice;
				detai.put("ebookPrice", price);
				detai.put("yuanEbookPrice", conPrice);
			}
		}
		
		return detai;
	}
	//获取期刊年份
	public List getYears() {
		return sqlSession.selectList("productDao.getYears");
	}
	//获取课程对应的详细信息
	public Map<String, Object> selCourseDetails(Map<String, Object> search) {
 		Map<String,Object> map = sqlSession.selectOne("productDao.selCourseDetails", search);
 		//限时特价
 		if(map.get("classtype") != null && map.get("classtype") != "") {
 			Map<String,Object> paramMap = new HashMap<String,Object>();
 			paramMap.put("type", DataConvert.ToInteger(map.get("classtype"))==0?3:4);
 			paramMap.put("productId", map.get("ondemandId"));
			double price = searcheDiscountService.searchDiscountPrice(paramMap);
			map.put("yuanPrice", DataConvert.ToDouble(map.get("presentPrice")));
			map.put("presentPrice", price);
 		}
 		pathService.getAbsolutePath(map, "introduce");
 		search.put("ondemandId", search.get("classId"));
 		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(search.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(search.get("userId")));
			if(row==2) {//2代表免购用户
				map.put("isbuy", 2);
			}else {
				if(map != null) {
					if(1==DataConvert.ToInteger(map.get("isSum"))){//合集是否购买
						int isbuy = sqlSession.selectOne("productDao.selIsBuySum",search);
						map.put("isbuy", isbuy);
					}else{
						int isbuy = sqlSession.selectOne("productDao.selectIsByOndemand",search);
						map.put("isbuy", isbuy);
					}
				}
			}
		}else {
			map.put("isbuy", 0);
		}
 		if(map != null && !StringUtils.isEmpty(DataConvert.ToString(map.get("introduce")))) {
 			map.put("subIntroduce", DeHtml.delHTMLTag( DataConvert.ToString(map.get("introduce"))));
		}
		return map;
	}
	//查询课时
	public List<Map> selClassHour(Map<String, Object> search) {
		return sqlSession.selectList("productDao.selClassHour", search);
	}
	/**
	 * 获取首页展示的课程分类
	 * @param page
	 * @param pageSize
	 * @return
	 */
	public Map<String, Object> getClassType(Integer page, Integer pageSize) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		if(page==null||page<1){
			page=1;
		}
		if(pageSize==null){
			pageSize=Integer.MAX_VALUE;
		}
		int start=(page-1)*pageSize;
		map.put("start", start);
		map.put("pageSize", pageSize);
		//查询课程列表
		List list = sqlSession.selectList("productDao.getClassTypeList", map);
		long count=sqlSession.selectOne("productDao.getClassTypeCount", map);
        
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
		if(pageSize!=null){
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		reqMap.put("data", list);
		
		return reqMap;
	}
	/**
	 * 获取课程对应的课时列表
	 * @param ondemandId
	 * @param page
	 * @param pageSize
	 * @return data{list:课时列表，IsBuyOndemand：当前课程是否已购买，1是0否}
	 */
	public Map<String, Object> getClassHourList(Integer ondemandId,Integer userId,
			Integer page, Integer pageSize , String paixu) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		boolean flag=false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			
			flag=true;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		map.put("ondemandId", ondemandId);
		map.put("userId", userId);
		map.put("paixu", paixu);
		
		//查询课时列表
		List<Map<String,Object>> list = sqlSession.selectList("productDao.getClassHourList", map);
		
		pathService.getAbsolutePath(list, "videoUrl");
		
		SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
		String siteUrl="";
		if(siteInfo!=null){
			siteUrl=siteInfo.getSiteUrl();
		}
		Map<String, Object> data=new HashMap<String, Object>();
		
		if(list.size()>0) {
			for (Map<String, Object> map2 : list) {
				if(!StringUtils.isEmpty(DataConvert.ToString(map2.get("presentation")))) {
					map2.put("presentation",siteUrl+"/phone/product/presentation?hourId="+map2.get("hourId"));
				}
				if(!StringUtils.isEmpty(DataConvert.ToString(map.get("content")))) {
		 			map.put("content", DeHtml.delHTMLTag( DataConvert.ToString(map.get("content"))));
				}
			}
			data.put("serialState",list.get(0).get("serialState"));
		}
		reqMap.put("result", 1);
		reqMap.put("msg", "获取数据成功！");
		if(flag){
			long count=sqlSession.selectOne("productDao.getClassHourCount", map);
			int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
			reqMap.put("totalPage", totalPage);
			reqMap.put("currentPage", page);
			
			Page pages = new Page(count, page, pageSize);
			PageInfo pageInfo = new PageInfo((int)count,page,pageSize);
			reqMap.put("pageInfo", pageInfo);
			reqMap.put("pageTotal", pages.getTotalPageCount());
		}
		
		data.put("list", list);
		//判断当前课程是否已经购买了
		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(map.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(map.get("userId")));
			if(row==2) {//2代表免购用户
				data.put("IsBuyOndemand", 1);
			}else {
				int Isbuy = sqlSession.selectOne("productDao.selectIsByOndemand", map);
				if(Isbuy > 0){
					data.put("IsBuyOndemand", 1);
				}else{
					data.put("IsBuyOndemand", 0);
				}
			}
		}else {
			data.put("IsBuyOndemand", 0);
		}
		reqMap.put("data", data);
		
		return reqMap;
	}
	
	//查询提问支付的信息
	public Map selQuestionsPayInfo(Map<String, Object> search) {
		//根据问题id查询被提问的专家或者课程的id
		int beAskedId = sqlSession.selectOne("productDao.selQuestionInfo",search);
		search.put("beAskedId", beAskedId);
		return sqlSession.selectOne("productDao.selQuestionsPayInfo",search);
	}
	//支付方式
	public List selPayType() {
		return sqlSession.selectList("productDao.selPayType");
	}
	//提问确认支付
//	public Map questionsSurePay(Map<String, Object> info) {
//		
//		//添加paylog记录
//		Map result = new HashMap();
//		
//		PayResult payResult=new PayResult();
//		
//		try {
//			int row = sqlSession.insert("productDao.addPayLogInfo",info);
//			
//			if(row>0){
//				int payType = Integer.parseInt(info.get("payTypeId")+"");
//				int payLogId = Integer.parseInt(info.get("payLogId")+"");
//				
//				PayParamEntity payParam = new PayParamEntity();
//				payParam.setOrderId(payLogId);
//				payParam.setOrderNo(info.get("orderNo")+"");
//				payParam.setPayMoney(Double.valueOf(info.get("price")+""));
//				payParam.setSubject(info.get("orderNo")+"");
//				payParam.setBody(info.get("orderNo")+"");
//				payParam.setPayMehtodId(Integer.parseInt(info.get("payTypeId")+""));
//				
//				//支付逻辑放方法
//				payResult =payExtension.Pay(payParam);
//				
//				if(payResult.isSuccess()&&!payResult.isOnline()){
//					int questionsId = selQuestionsId(info.get("orderNo")+"");
//			 		int rw = updQuestionsStatus(questionsId); 
//				}
//			}
//			
//			//int rw = sqlSession.update("productDao.updPayLogStatus",info.get("payLogId")+"");
//		
//		} catch (Exception e) {
//			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
//		}
//		return result;
//	}
	
	//查询期次列表和对应的价格
	public List getQiciList(Map<String, Object> search) {
		return sqlSession.selectList("productDao.getQiciList", search);
	}
	/**
	 * 根据课时id，课程id获取相应的课时文稿
	 * @param map
	 * @return
	 */
	public Map<String, Object> selClassPresentation(Map map) {
		return sqlSession.selectOne("productDao.selClassPresentation", map);
	}
	//查询刚才提问的id
	/*public int selQuestionsId(String orderNo) {
		return sqlSession.selectOne("productDao.selQuestionsId",orderNo);
	}*/
	//查询课程价格
	public Map<String, Object> selectOndemandPrice(String productId) {
		return sqlSession.selectOne("productDao.selectOndemandPrice", productId);
	}
	//查询该用户是否存在
	public int selUserIsHave(String userId) {
		return sqlSession.selectOne("productDao.selUserIsHave", userId);
	}
	//查询商品您是否下架
	public int selIsState(String shopCartIds) {
		int result = 0;
		String[] cartIds = shopCartIds.split(",");
		for (String strId : cartIds) {
			String qiciIds = sqlSession.selectOne("productDao.sqlQiciIds", strId);//购物车中期次的ids
			if(!StringUtils.isEmpty(qiciIds) && !qiciIds.equals("null")){
				String[] qiciCount = qiciIds.split(",");//期次
				for (String str : qiciCount) {
					Map stateInfo = sqlSession.selectOne("productDao.selBookState", str);
					int isCount = Integer.parseInt(stateInfo.get("count")+""); 
					int state = Integer.parseInt(stateInfo.get("state")+""); 
					if(isCount!=0 && state==1){
						result = 0;
						break;
					}else{
						result = 1;
					}
				}
			}else{
				result = 0;
				break;
			}
			
		}
		return result;
	}
	/**
	 * 从购物车中生成订单
	 * @param info
	 * @return
	 */  
	public Map<String,Object> addOrderInfo(Map<String, Object> info) {
				Map<String,Object> result = new HashMap<String,Object>();
		int paylogId = -1;
		try {
			
			int userId=DataConvert.ToInteger(info.get("userId"));
			if(userId<0) {
				throw new Exception();
			}
			String cartIds =DataConvert.ToString(info.get("shopCartIds"));
			if(StringHelper.IsNullOrEmpty(cartIds)) {
				throw new Exception();
			}
			List<Map<String,Object>>shopCartList=sqlSession.selectList("productDao.selCartItemList",cartIds);
			if(shopCartList==null||shopCartList.isEmpty()) {
				throw new Exception();
			}
			//1.获取订单子项数据
			double totalPrice=0.00;
			List<Map<String,Object>>orderItemList=new ArrayList<Map<String,Object>>();
			for (Map item : shopCartList) {
				
				//TODO 实时获取商品价格
			
				Map<String,Object> orderItem = new HashMap<String, Object>();
				
				//产品类型：1实物，2期刊，4点播，8直播，16电子书
				int productType=DataConvert.ToInteger(item.get("producttype"));
				
				orderItem.put("productid", DataConvert.ToString(item.get("productid")));
				orderItem.put("productname", DataConvert.ToString(item.get("productname")));
				orderItem.put("productpic", DataConvert.ToString(item.get("productpic")));
				orderItem.put("desc", DataConvert.ToString(item.get("desc")));
				orderItem.put("count", DataConvert.ToString(item.get("count")));
				orderItem.put("price", DataConvert.ToString(item.get("price")));
				orderItem.put("buyprice", DataConvert.ToString(item.get("buyprice")));
				//查看该商品是否限时特价
				if(productType==2) {
					orderItem.put("type", 1);
				}else if(productType==16) {
					orderItem.put("type", 2);
				}
				orderItem.put("productId", DataConvert.ToString(item.get("productid")));
				Double disPrice = searcheDiscountService.searchDiscountPrice(orderItem);
				if(DataConvert.ToInteger(item.get("subType"))!=5) {
					totalPrice+=(disPrice*DataConvert.ToInteger(item.get("count")));
				}
				orderItem.put("buyprice", disPrice);
				orderItem.put("producttype",  productType);
				orderItem.put("subType",  DataConvert.ToString(item.get("subType")));
				orderItem.put("shopCartId", item.get("id"));
				orderItemList.add(orderItem);
			}
			
			//2. 添加总订单信息
			Map<String,Object> orderInfo = new HashMap<String, Object>();
			orderInfo.put("userId",userId);
			String orderNo= UtilDate.getOrderNum()+UtilDate.getThree();
			orderInfo.put("orderno", orderNo);
			Double postagePrice = 0.00;
			//添加地址信息
			String addressId = DataConvert.ToString(info.get("addressId"));
			if(!StringUtils.isEmpty(addressId)){
				Map addressInfo = sqlSession.selectOne("productDao.selAddressInfo",addressId);
				if(addressInfo!=null) {
					orderInfo.put("receivername", DataConvert.ToString(addressInfo.get("receiver")));
					orderInfo.put("receiverphone", DataConvert.ToString(addressInfo.get("phone")));
					orderInfo.put("receiverProvince", DataConvert.ToString(addressInfo.get("province")));
					orderInfo.put("receiverCity", DataConvert.ToString(addressInfo.get("city")));
					orderInfo.put("receiverCounty", DataConvert.ToString(addressInfo.get("county")));
					orderInfo.put("receiverAddress", DataConvert.ToString(addressInfo.get("detailedAddress")));
					try {
						Map<String, Object> postage = orderService.getPostage(cartIds,Integer.parseInt(addressId), userId);
						postagePrice = DataConvert.ToDouble(postage.get("data"));
					} catch (Exception e) {
						throw new Exception("获取运费失败！");
					}
				}
			}else{
				List isHasAddress = shopCartList.stream().filter(f->{return DataConvert.ToInteger(f.get("producttype"))==2;}).collect(Collectors.toList());
				if(isHasAddress!=null && isHasAddress.size()>0){
					throw new Exception("有发货商品,需要添加地址信息！");
				}
			}
			//获取订单包含的商品类型
			List<Map> producttypes = sqlSession.selectList("shopCartDao.selTypeByIds",cartIds);
			int producttype = 0;
			if(producttypes!=null) {
				for (Map map : producttypes) {
					producttype|=DataConvert.ToInteger(map.get("producttype"));
				}
			}
			orderInfo.put("ordertype", producttype);
			//购物车总价
			totalPrice+=postagePrice;
			double payPrice=totalPrice;
			//判断是否使用代金券
			int voucherId=DataConvert.ToInteger(info.get("voucherId"));
			if(voucherId >0){
				//查看购物车中是否有适合此类代金券的商品
				boolean isHas=false;
				for (Map<String,Object> subShopCart : shopCartList) {
					Map<String,Object> voucherParamMap = new HashMap<String,Object>();
					voucherParamMap.put("userId", userId);
					voucherParamMap.put("productId", subShopCart.get("id"));
					voucherParamMap.put("type", 2);
					Map<String,Object> voucherMap = accountService.getVoucherByType(voucherParamMap);
					if(voucherMap!=null) {
						List<Map<String,Object>> subList = (List<Map<String, Object>>) voucherMap.get("lists");
						for (Map<String, Object> map : subList) {
							int selvoucherId = DataConvert.ToInteger(map.get("Id"));
							if(selvoucherId==voucherId) {
								isHas = true;
								break;
							}
						}
					}
				}
				if(isHas) {
					Map shouldMap = orderService.getVoucherprice(cartIds,voucherId,userId,postagePrice);
					payPrice = payPrice-DataConvert.ToDouble(shouldMap.get("data"));
					orderInfo.put("voucherId", voucherId);
					orderInfo.put("voucherprice", DataConvert.ToDouble(shouldMap.get("data")));
				}
			}
			//判断是否使用优惠券
			int couponId=DataConvert.ToInteger(info.get("couponId"));
			if(couponId >0){
				Double price = sqlSession.selectOne("productDao.selPriceByCid",info);
				//查看购物车中是否有适合此类代金券的商品
				boolean isHas=false;
				Map<String,Object> couponParamMap = new HashMap<String,Object>();
				couponParamMap.put("userId", userId);
				couponParamMap.put("productId", cartIds);
				couponParamMap.put("type", 2);
				Map<String,Object> couponMap = accountService.getCouponsByType(couponParamMap);
			
				if(couponMap!=null) {
					List<Map<String,Object>> subList = (List<Map<String, Object>>) couponMap.get("lists");
					for (Map<String, Object> map : subList) {
						int selcouponId = DataConvert.ToInteger(map.get("Id"));
						if(selcouponId==couponId) {
							isHas = true;
							break;
						}
					}
				}
				if(isHas) {
					payPrice = payPrice-DataConvert.ToDouble(price);
					orderInfo.put("couponId", couponId);
					orderInfo.put("couponprice", price);
				}
			}
			
			if(Double.doubleToLongBits(payPrice) <=Double.doubleToLongBits(0.0) ) {
				System.out.println("付款金额为负数或等于0直接代表支付成功");
				orderInfo.put("paystatus", 1);
				orderInfo.put("orderstatus", 2);
				payPrice=0;
			}
			if(voucherId>0) {
				//修改用户的代金券为已使用
				boolean isSuccess = sqlSession.update("payDao.updateVoucher",orderInfo)>0;
				if(!isSuccess){
					throw new Exception("修改代金券失败");
				}
			}
			if(couponId>0) {
				//修改用户的优惠券为已使用
				boolean isSuccess = sqlSession.update("payDao.updateCoupon",orderInfo)>0;
				if(!isSuccess){
					throw new Exception("修改优惠券失败");
				}
			}
			
			orderInfo.put("totalPrice", totalPrice);
			orderInfo.put("postage",postagePrice);
			
			//添加订单
			boolean flag= sqlSession.insert("productDao.addOrderInfo",orderInfo)>0;
			if(!flag) {
				throw new Exception("添加订单信息失败！");
			}
			
			int orderId=DataConvert.ToInteger(orderInfo.get("orderId"));
			if(orderId<=0) {
				throw new Exception("添加订单信息失败！");
			}
			
			//3.添加订单子项数据
			for (Map<String,Object> item : orderItemList) {
				
				item.put("orderId", orderId);
				item.put("orderno", orderNo);
				
				item.put("receivername", DataConvert.ToString(orderInfo.get("receivername")));
				item.put("receiverphone", DataConvert.ToString(orderInfo.get("receiverphone")));
				item.put("receiverProvince", DataConvert.ToString(orderInfo.get("receiverProvince")));
				item.put("receiverCity", DataConvert.ToString(orderInfo.get("receiverCity")));
				item.put("receiverCounty", DataConvert.ToString(orderInfo.get("receiverCounty")));
				item.put("receiverAddress", DataConvert.ToString(orderInfo.get("receiverAddress")));
				
			}
			
			//4.先保存非赠品的订单子项
			for(Map<String,Object> item:orderItemList) {
				int subType=DataConvert.ToInteger(item.get("subType"));
				if(subType==5) {
					continue;
				}
				
				flag=sqlSession.insert("productDao.addOrderItemInfo",item)>0;
				if(!flag) {
					throw new Exception("添加订单子项信息失败！");
				}
			}
			
			//5.保存赠品的订单子项 
			//TODO 现在赠品是直接从购物车中获取，以后按需求可以改成时时获取
			for(Map<String,Object> item:orderItemList) {
				
				int subType=DataConvert.ToInteger(item.get("subType"));
				if(subType==5) {
					continue;
				}
				
				int shopCartId=DataConvert.ToInteger(item.get("shopCartId"));
				
				for (Map<String,Object> item_zp : orderItemList) {
					
					subType=DataConvert.ToInteger(item_zp.get("subType"));
					if(subType!=5) {
						continue;
					}
					
					int cartId=DataConvert.ToInteger(item_zp.get("desc"));
					if(shopCartId!=cartId) {
						continue;
					}
					
					item_zp.put("desc",item.get("orderitemId"));
					
					flag=sqlSession.insert("productDao.addOrderItemInfo",item_zp)>0;
					if(!flag) {
						throw new Exception("添加订单子项(赠品)信息失败！");
					}
				}
			}
			if(payPrice>0) {
				//6.添加支付记录
				Map<String,Object> paylogMap = new HashMap<String, Object>();
				paylogMap.put("questioner",userId);
				paylogMap.put("source", 1);
				paylogMap.put("questionId", orderId);
				paylogMap.put("money",payPrice);
				paylogMap.put("orderNo", orderNo);
				flag= sqlSession.insert("questionDao.addPayLogInfo",paylogMap)>0;
				if(!flag) {
					throw new Exception("添加支付记录失败！");
				}
				paylogId=DataConvert.ToInteger(paylogMap.get("payLogId"));
			}else {
				orderInfo.put("id",orderInfo.get("orderId"));
				payService.updOrderByProduct(orderInfo);
				paylogId=0;
			}
			
			//7.删除购物车数据
			Map<String, Object> deleteCarItem = orderService.deleteCarItem(userId, cartIds);
			if(deleteCarItem.get("result").equals("0")){
				throw new Exception("删除购物车数据失败！");
			}
			
			
			result.put("orderId", orderId);
			result.put("totalPrice", payPrice);
			
		} catch (Exception e) {
			paylogId=-1;
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		
		result.put("paylogId",paylogId);
		
		return result;
	}
	
	/**
	   * @param s
	   * @return 获得图片
	   */
	public static List<String> getImg(String s)  
	{  
	   String regex;  
	   List<String> list = new ArrayList<String>();  
	   regex = "src=\"(.*?)\"";  
	   Pattern pa = Pattern.compile(regex, Pattern.DOTALL);  
	   Matcher ma = pa.matcher(s);  
	   while (ma.find())  
	   {
	    list.add(ma.group());  
	   }  
	   return list;  
	}  
	/**
	 * 返回存有图片地址的数组
	 * @param tar
	 * @return
	 */
	public static String[] getImgaddress(String tar){
		List<String> imgList = getImg(tar);
		
		String res[] = new String[imgList.size()];
		
		if(imgList.size()>0){
			for (int i = 0; i < imgList.size(); i++) {
				int begin = imgList.get(i).indexOf("\"")+1;
				int end = imgList.get(i).lastIndexOf("\"");
				String url[] = imgList.get(i).substring(begin,end).split("/");
				res[i]=url[url.length-1];
			}
		}else{
		}
		return res;
	}

	//通过期次查找电子书栏目板块文章三级列表
	public List selEbookByPubId(int pubId) {
		//通过期次id查找文章
		List<Map<String,Object>> documentList =  sqlSession.selectList("productDao.selDocumentsByPubId", pubId);
		if(documentList.size()>0) {
			for (Map<String, Object> map : documentList) {
				String text = DataConvert.ToString(map.get("MainText"));
				String SubText = DataConvert.ToString(map.get("SubText"));
				if(SubText.length()<=0) {
					String deText = DeHtml.delHTMLTag(text);
					map.put("SubText", deText);
				}
				List<String> imgaddress = getImg(text);
				if(imgaddress.size()>0) {
					map.put("url", imgaddress.get(0).substring(5, imgaddress.get(0).length()-1));
				}
			}
		}
		/*if(documentList!=null && documentList.size()>0){
			//找出文章id集合
			List<Integer> docIds = documentList.stream().map(f->{return DataConvert.ToInteger(f.get("DocID"));}).collect(Collectors.toList());
			//通过文章id查找栏目
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("docIds", docIds);
			List<Map<String,Object>> columnsList = sqlSession.selectList("productDao.selColumnsByDocIds",map);
			if(columnsList!=null && columnsList.size()>0){
				//将栏目下的文章添加到栏目集合中
				for (Map<String, Object> itemColumns : columnsList) {
					List<Map<String,Object>> itemlist = new ArrayList<Map<String,Object>>();
					for (Map<String, Object> itemDoc : documentList) {
						if(DataConvert.ToInteger(itemDoc.get("ColumnID"))==DataConvert.ToInteger(itemColumns.get("ColumnID"))){
							itemlist.add(itemDoc);
						}
					}
					if(itemlist.size()>0){
						itemColumns.put("list", itemlist);
					}
				}
				//找出栏目id集合
				List<Integer> columnsIds = columnsList.stream().map(f->{return DataConvert.ToInteger(f.get("ColumnID"));}).collect(Collectors.toList());
				//通过栏目id查找板块
				map.put("columnsIds", columnsIds);
				catList = sqlSession.selectList("productDao.selCategoryByColumnsId",map);
				//将板块下的栏目添加到板块集合中
				for (Map<String, Object> itemCat : catList) {
					List<Map<String,Object>> itemlist = new ArrayList<Map<String,Object>>();
					for (Map<String, Object> itemCol : columnsList) {
						if(DataConvert.ToInteger(itemCol.get("CategoryID"))==DataConvert.ToInteger(itemCat.get("CategoryID"))){
							itemlist.add(itemCol);
						}
					}
					if(itemlist.size()>0){
						itemCat.put("list", itemlist);
					}
				}
			}
			//查找板块下直接关联的文章
			List<Map<String,Object>> subCatList = sqlSession.selectList("productDao.selCategoryByDocIds",map);
			//将板块下直接的文章添加到板块集合中
			if(subCatList.size()>0 && null!=subCatList){
				
				for (Map<String, Object> itemCat : subCatList) {
					List<Map<String,Object>> itemlist = new ArrayList<Map<String,Object>>();
					for (Map<String, Object> itemDoc : documentList) {
						if(DataConvert.ToInteger(itemDoc.get("CategoryID"))==DataConvert.ToInteger(itemCat.get("CategoryID"))){
							itemlist.add(itemDoc);
						}
					}
					if(itemlist.size()>0){
						itemCat.put("list", itemlist);
					}
					catList.add(itemCat);
					
				}
				
			}
			
		}
		
		if(catList!=null&&!catList.isEmpty()){
			catList.sort((i1,i2)->{
				return DataConvert.ToInteger(i1.get("OrderNo"))>DataConvert.ToInteger(i2.get("OrderNo"))?1:-1;
			});
		}*/
		return documentList;
	}
	
	//通过期次查找电子书栏目板块文章三级列表
	public List selEbookByPubIdPC(int pubId) {
		List<Map<String,Object>> catList = new ArrayList<Map<String,Object>>();
		//通过期次id查找文章
		List<Map<String,Object>> documentList =  sqlSession.selectList("productDao.selDocumentsByPubId", pubId);
		if(documentList!=null && documentList.size()>0){
			//找出文章id集合
			List<Integer> docIds = documentList.stream().map(f->{return DataConvert.ToInteger(f.get("DocID"));}).collect(Collectors.toList());
			//通过文章id查找栏目
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("docIds", docIds);
			List<Map<String,Object>> columnsList = sqlSession.selectList("productDao.selColumnsByDocIds",map);
			if(columnsList!=null && columnsList.size()>0){
				//将栏目下的文章添加到栏目集合中
				for (Map<String, Object> itemColumns : columnsList) {
					List<Map<String,Object>> itemlist = new ArrayList<Map<String,Object>>();
					for (Map<String, Object> itemDoc : documentList) {
						if(DataConvert.ToInteger(itemDoc.get("ColumnID"))==DataConvert.ToInteger(itemColumns.get("ColumnID"))){
							itemlist.add(itemDoc);
						}
					}
					if(itemlist.size()>0){
						itemColumns.put("list", itemlist);
					}
				}
				//找出栏目id集合
				List<Integer> columnsIds = columnsList.stream().map(f->{return DataConvert.ToInteger(f.get("ColumnID"));}).collect(Collectors.toList());
				//通过栏目id查找板块
				map.put("columnsIds", columnsIds);
				catList = sqlSession.selectList("productDao.selCategoryByColumnsId",map);
				//将板块下的栏目添加到板块集合中
				for (Map<String, Object> itemCat : catList) {
					List<Map<String,Object>> itemlist = new ArrayList<Map<String,Object>>();
					for (Map<String, Object> itemCol : columnsList) {
						if(DataConvert.ToInteger(itemCol.get("CategoryID"))==DataConvert.ToInteger(itemCat.get("CategoryID"))){
							itemlist.add(itemCol);
						}
					}
					if(itemlist.size()>0){
						itemCat.put("list", itemlist);
					}
				}
			}
			//查找板块下直接关联的文章
			List<Map<String,Object>> subCatList = sqlSession.selectList("productDao.selCategoryByDocIds",map);
			//将板块下直接的文章添加到板块集合中
			if(subCatList.size()>0 && null!=subCatList){
				
				for (Map<String, Object> itemCat : subCatList) {
					List<Map<String,Object>> itemlist = new ArrayList<Map<String,Object>>();
					for (Map<String, Object> itemDoc : documentList) {
						if(DataConvert.ToInteger(itemDoc.get("CategoryID"))==DataConvert.ToInteger(itemCat.get("CategoryID"))){
							itemlist.add(itemDoc);
						}
					}
					if(itemlist.size()>0){
						itemCat.put("list", itemlist);
					}
					catList.add(itemCat);
					
				}
				
			}
		}
		if(catList!=null&&!catList.isEmpty()){
			catList.sort((i1,i2)->{
				return DataConvert.ToInteger(i1.get("OrderNo"))>DataConvert.ToInteger(i2.get("OrderNo"))?1:-1;
			});
		}
		return catList;
	}
	//查询文章的内容
	public Map<String, Object> getArticleById(int DocID) {
		Map<String,Object> content = sqlSession.selectOne("productDao.getEbookByDocId", DocID);
		pathService.getAbsolutePath(content, "MainText");
		return content;
	}
	
	//查询期刊下的所有文章集合数据
	public List<Map<String,Object>> selDocumentDataByPubId(int pubId){
		List<Map<String,Object>> data = sqlSession.selectList("productDao.selDocumentDataByPubId",pubId);
		return data;
	}
	
	//筛选出是期刊的购物车项
	public List selBookIds(String shopCartIds) {
		List list = StringHelper.ToIntegerList(shopCartIds);
		return sqlSession.selectList("shopCartDao.selBookIds",list);
	}
	
	//根据parentId查询contentID
	public Map<String, Object> selContentId(Map<String, Object> map) {
		return sqlSession.selectOne("productDao.selContentId", map);
	}
	
	//通过合集id获取合集信息
	public List getSumById(Map<String, Object> parmap) {
		List<Map> list =  sqlSession.selectList("productDao.getSumById",parmap);
		//查询用户信息是否是免购用户
		if(DataConvert.ToInteger(parmap.get("userId"))>0){
			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(parmap.get("userId")));
			if(row==2) {//2代表免购用户
				list.stream().forEach(f->{
					f.put("isbuy", 2);
				});
			}
		}
		return list;
	}
	/**
	 * 通过期刊合集id查看合集下的商品列表
	 * @param parmap
	 * @return
	 */
	public List getProudctListByCollection(Map<String, Object> parmap) {
		List<Map> list =  sqlSession.selectList("productDao.getProudctListByCollection",parmap);
		//查询用户信息是否是免购用户
//		if(DataConvert.ToInteger(parmap.get("userId"))>0){
//			int row = sqlSession.selectOne("productDao.selUserIsmiangou",DataConvert.ToInteger(parmap.get("userId")));
//			if(row==2) {//2代表免购用户
//				list.stream().forEach(f->{
//					f.put("isbuy", 2);
//				});
//			}
//		}
		return list;
	}
	public Map<String,Object> getBookRecord(Map<String, Object> parmap) {
		Map<String,Object> map =  sqlSession.selectOne("productDao.getBookRecord",parmap);
		return map;
	}
	
	
	public Map getIntroduceById(Integer ondemandId) {
		return sqlSession.selectOne("productDao.getIntroduceById",ondemandId);
	}
	/**
	 * 通过课程id类型以及地址获取运费
	 * @param userId
	 * @param productId
	 * @param producttype
	 * @param addressId
	 * @return
	 */
	public Map<String, Object> getPostageByOndemand(Integer userId, Integer productId, Integer producttype,Integer addressId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("data", 0);
		int classtype=3;
		if(producttype==8){
			classtype=4;
		}
		List<Map>buySiSongList=activityService.getBuyJiSongList(productId,classtype);
		BigDecimal freight = new BigDecimal(0.0);//运费
		BigDecimal totalFreight1 = new BigDecimal(0.0);//模版类型为1运费
		BigDecimal totalFreight0 = new BigDecimal(0.0);//模版类型为0运费
		if(buySiSongList!=null && !buySiSongList.isEmpty()) {
			List<Integer> buyJiSongIds=buySiSongList.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
			//获取活动赠送的商品列表
			List<Map>productList=activityService.getSendListForBuyJiSong(buyJiSongIds);
			//需要发货的商品productid就是期刊的id
			List<Map> list = productList.stream().filter(f->{return DataConvert.ToInteger(f.get("productType"))==1;}).collect(Collectors.toList());
			Map<String,Object> addressInfo = sqlSession.selectOne("productDao.selAddressInfo",addressId.toString());
			if(addressInfo==null){
				map.put("msg", "获取地址信息错误");
				map.put("result", 0);
				return map;
			}
			//获取用户选择的城市  city=北京
			String city = DataConvert.ToString(addressInfo.get("city"));
			
			Map<String,Object> bookIdMap = new HashMap<String,Object>();
			bookIdMap.put("userId", userId);
			List<Object> bookIdList = new ArrayList<Object>();
			List<Map<String,Object>> province = new ArrayList<Map<String,Object>>();
			List<Integer> cityIdList = new ArrayList<>();
			if(list!=null && list.size()>0) {
				for(int i = 0; i<list.size();i++) {
					bookIdList.add(list.get(i).get("productid"));
				}
				//productid(book表主键)
				bookIdMap.put("bookIdList", bookIdList);
				//模版类型-0,计算运费
				Map<String,Object> postageTypeForZero = sqlSession.selectOne("cn.dao.bookDao.selectpostageTypeForZero",bookIdMap);
				if(postageTypeForZero !=null) {
					totalFreight0 = (BigDecimal)postageTypeForZero.get("postage");
				}
				//模版类型-1,计算运费
				// 根据模版类型-1,查询模版类型和模版id
				List<Map<String,Object>> bookRecordList = sqlSession.selectList("cn.dao.bookDao.selectTemplateId",bookIdMap);
				for(int j = 0;bookRecordList !=null && bookRecordList.size()>0 && j<bookRecordList.size();j++) {
					// 根据模版id查询 logisticstemplateitem表
					int postageTempId=  (int)bookRecordList.get(j).get("postageTempId");
					List<Map<String,Object>> templateDetailList = sqlSession.selectList("cn.dao.logisticsTemplateDao.selectlogisticsTemplat",postageTempId);
					for(int cityId = 0;templateDetailList !=null && templateDetailList.size()>0 && cityId <templateDetailList.size();cityId++) {
						if(templateDetailList.get(cityId).get("cityIds") !=null && !"".equals(templateDetailList.get(cityId).get("cityIds"))) {
							//比较:收货地址和logisticstemplateitem表 地址是否匹配
							if(postageService.addressIsMatch(province,cityIdList,templateDetailList,cityId,city)) {
								freight = postageService.caculateFreight(bookRecordList,templateDetailList,cityId,j,freight);
								break;
							}
						}else {
							freight = postageService.caculateFreight(bookRecordList,templateDetailList,cityId,j,freight);
						}
					}
				    totalFreight1 = totalFreight1.add(freight);
				}
			}else {
				map.put("msg", "没有需要发货的商品");
				map.put("data", 0);
				return map;
			}
		}else {
			map.put("result", 1);
			map.put("msg", "没有需要发货的商品");
		}
		map.put("result", 1);
		map.put("data", totalFreight1.add(totalFreight0));
		
		return map;
	}
	
	/**
	 * 比较:收货地址和logisticstemplateitem表 地址是否匹配
	 */
	/*public boolean addressIsMatch(List<Map<String,Object>> province,List<Integer> cityIdList,
			List<Map<String,Object>> templateDetailList,int cityId,String city) {
		//根据city查询provinces 的codeid
		List<Integer> codeid = new ArrayList<>();
		if(city !=null && city.endsWith("省")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("市")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("区")) {
			city = city.substring(0, city.length()-1);
		}
		if(city !=null && city.endsWith("州")) {
			city = city.substring(0, city.length()-1);
		}	
		province = sqlSession.selectList("provinceDao.selectCodeid",city);
		if(province !=null && province.size()>0) {
			for(int i = 0;i<province.size();i++) {
				codeid.add(Integer.parseInt((province.get(i).get("codeid")).toString()));
			}
		}
		cityIdList = StringHelper.ToIntegerList(templateDetailList.get(cityId).get("cityIds")+"");
		//boolean isCity = cityIdList.containsAll(codeid);
		boolean isCity = false;
		if(cityIdList !=null && cityIdList.size()>0) {
			if(codeid !=null && codeid.size()>0) {
				for(int i=0;i<cityIdList.size();i++) {
					for(int j=0;j<codeid.size();j++) {
						if(cityIdList.get(i).intValue()==codeid.get(j).intValue()) {
							isCity = true;
							return isCity;
						}
					}
				}
			}
		}
		return isCity;
	}*/
	
	/**
	 * 计算运费
	 */
	/*public BigDecimal caculateFreight(List<Map<String,Object>> bookRecordList,
			List<Map<String,Object>> templateDetailList,int cityId,int j,BigDecimal freight) {
		double count = DataConvert.ToDouble(bookRecordList.get(j).get("count"));
		double firstGoods = 0.0;
		BigDecimal firstFreight = new BigDecimal(0.0);
		double secondGoods = 0.0;
		BigDecimal secondFreight = new BigDecimal(0.0);
		if(count<=((BigDecimal)(templateDetailList.get(cityId).get("firstGoods"))).doubleValue()) {
			freight = (BigDecimal) templateDetailList.get(cityId).get("firstFreight");
		}else{
			firstGoods = ((BigDecimal)(templateDetailList.get(cityId).get("firstGoods"))).doubleValue();
			secondGoods = ((BigDecimal)(templateDetailList.get(cityId).get("secondGoods"))).doubleValue();
			secondFreight = (BigDecimal)(templateDetailList.get(cityId).get("secondFreight"));
			if(secondGoods>0) {
				firstFreight = (BigDecimal) templateDetailList.get(cityId).get("firstFreight");
				double ceil = Math.ceil((count - firstGoods)/secondGoods);
				BigDecimal ceilBigdecimal = new BigDecimal(ceil);
				freight = firstFreight.add((ceilBigdecimal.multiply(secondFreight)));
			}
		}
		return freight;
	}*/
	/**
	 * 通过课程合集id查看合集列表数量
	 * @param map
	 * @return
	 */
	public long getSumCount(Map<String, Object> map) {
		return sqlSession.selectOne("productDao.getSumCount",map);
	}
	/**
	 * 从rc_pics表导入classhour_picture表数据
	 * @return
	 */
	public Map<String, Object> getRcPicPicurl() {
		Map<String,Object> result = null;
		Map<String,Object> search = new HashMap<String,Object>();
		List<Map<String,Object>> classHourList = new ArrayList<Map<String,Object>>(); 
		//1.查询rc_pics表pid不为 null的数据:目前287条数据
		List<Map<String,Object>> rcPicList = sqlSession.selectList("productDao.getRcPicList");
		if(rcPicList !=null && rcPicList.size()>0) {
			for (Map<String, Object> map : rcPicList) {
				result = new HashMap<String,Object>();
				String url = map.get("picurl").toString();
				if(url.startsWith(".")) {
					url = url.substring(1, url.length());
				}
				String picurl ="http://go.cmmo.cn"+url;
				result.put("hourId", map.get("pid").toString());
				result.put("picurl", picurl.trim());
				classHourList.add(result);
			}
		}
		//2.导入到classhour_picture表(picurl字段要加上绝对路径:http://go.cmmo.cn)
		search.put("classHourList", classHourList);
		sqlSession.insert("productDao.addPictureUrlData", search);
		result.put("result", 1);
		return result;
	}
	/**
	 * 获取课时图片接口
	 * @return
	 */
	public Map<String, Object> getClassHourPicurl(Integer hourId) {
		Map<String,Object> result = new HashMap<String, Object>();
		List<Map<String, Object>> picurlList = sqlSession.selectList("productDao.getClassHourPicurl",hourId);
		result.put("result", 1);
		result.put("data", picurlList);
		return result;
	}
	/**
	 * 获取推荐的最近的前三个期刊
	 * @param bookmap
	 * @return
	 */
	public List getLatestTopMagazines(Map<String, Object> bookmap) {
		List<Map> list = sqlSession.selectList("productDao.getLatestTopMagazines",bookmap);
		return list;
	}
	public long getSumByIdCount(Map<String, Object> parmap) {
		return sqlSession.selectOne("productDao.getSumByIdCount", parmap);
	}
	public List selectZazhiList(Integer userId) {
		// TODO Auto-generated method stub
		return null;
	}
	
}
