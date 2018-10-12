package cn.api.service;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpSession;

import org.apache.commons.beanutils.converters.DateConverter;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import cn.api.service.NewsService.NewsType;
import cn.util.CalendarUntil;
import cn.util.DataConvert;
import cn.util.UtilDate;

@Service
public class AccountService {
		
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	private HttpSession session;
	@Autowired
	NewsService newsService;
	@Autowired
	PathService pathService;
	@Autowired
	private SearcheDiscountService searcheDiscountService;
	//查询用户信息
	public Map login(Map paramMap) {
		return sqlSession.selectOne("accountDao.login",paramMap);
	}
	//注册
	public String register(Map<String, Object> paramMap) {
		try {
			int num = sqlSession.insert("userDao.addAdminUserInfo",paramMap);
			int count = sqlSession.insert("userDao.addUserAccount",paramMap.get("userId")+"");
			if(num<0||count<0){
				return "0";
			}
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
		return paramMap.get("userId")+""; 	
	}
//	获取用户地址列表信息
	public List selAddressList(Integer userId) {
		return sqlSession.selectList("accountDao.selAddressList",userId);
	}
//  删除用户地址
	public boolean DeleteAddress(int id, int userId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("Id", id);
		map.put("userId", userId);
		return sqlSession.update("accountDao.DeleteAddress",map)>0;
	}
//	修改默认地址
	public int updDefaultAddress(Map<String, Object> map) {
		sqlSession.update("accountDao.updOtherAddress",map);
		return sqlSession.update("accountDao.updDefaultAddress",map);
	}
//	查询用户某个地址的详情
	public Map selAddressDetail(Map<String, Object> map) {
		return sqlSession.selectOne("accountDao.selAddressDetail", map);
	}
	//获取银行卡列表
	public List selectBankCardList(Map<String, Object> map) {
		return sqlSession.selectList("accountDao.selectBankCardList", map);
	}
	//查询银行卡数量
	public long selectBankCardCount(Map<String, Object> map) {
		return sqlSession.selectOne("accountDao.selectBankCardCount", map);
	}
	//添加银行卡
	public Map<String, Object> addBankCard(Map<String, Object> map) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		int row = sqlSession.insert("accountDao.addBankCard", map);
		if(row > 0){
			reqMap.put("result", 1);
			reqMap.put("msg", "添加成功!");
		}else{
			reqMap.put("result", 0);
			reqMap.put("msg", "添加失败!");
		}
		return reqMap;
	}
	//修改用户基本信息
	public Map<String, Object> updateUserBasic(Map<String, Object> map) {
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(StringUtils.isEmpty(map)){
			return reqMap;
		}
		if(DataConvert.ToInteger(map.get("userId"))==null){
			return reqMap;
		}
		if(null!=DataConvert.ToString(map.get("birthDate")) && !"".equals(DataConvert.ToString(map.get("birthDate")))){
			if(CalendarUntil.ParseDate(map.get("birthDate"),"yyyy-MM-dd")==null) {
				reqMap.put("msg", "日期格式错误!");
				return reqMap;
			}
		}
		
		try {
			int row = sqlSession.update("accountDao.updateUserBasic", map);
			if(row > 0){
				reqMap.put("result", 1);
				reqMap.put("msg", "修改成功!");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "修改失败!");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求错误!"+e.getMessage());
		}
		return reqMap;
	}
	//查询用户详情
	public Map<String, Object> selUserBasic(int userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		return sqlSession.selectOne("accountDao.selUserBasic", map);
	}
	//查询用户消费记录
	public List selAccountLog(Integer userId) {
		List<Map> list = sqlSession.selectList("accountLogDao.selAccountLog",userId);
		return list;
	}
	public List getYearsAndmonth(Integer start, Integer pageSize,Integer userId) {
		Map<String,Object> paramap = new HashMap<String, Object>();
		paramap.put("start", start);
		paramap.put("pageSize", pageSize);
		paramap.put("userId", userId);
		List<Map<String,Object>> yearAndMonth = sqlSession.selectList("accountLogDao.getContentByYearAndMonth",paramap);
		List content = new ArrayList();
		
		for (Map object : yearAndMonth) {
			String string = (object.get("year")+"");
			String end = (object.get("year")+"");
			Map<String,Object> map = new HashMap<String, Object>();
			Map<String,Object> parmap = new HashMap<String, Object>();
			String startTime = (string+="-00");
			String endTime = (end+="-32");
			parmap.put("startTime", startTime);
			parmap.put("endTime", endTime);
			parmap.put("userId", userId);
			List<Map<String,Object>> subList = sqlSession.selectList("accountLogDao.selAccountLog",parmap);
			map.put("year",object.get("year"));
			map.put("incomeTotal", subList.get(0).get("incomeTotal"));
			map.put("consumTotal", subList.get(0).get("consumTotal"));
			map.put("failMoney", subList.get(0).get("failMoney"));
			map.put("data", subList);
			content.add(map);
		}
		return content;
	}
	public List getYearsAndmonthCount(Integer userId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		return sqlSession.selectList("accountLogDao.getContentByYearAndMonth",map);
	}
	//获取用户的交易记录列表count
	public long getRecordCount(Map<String,Object> map) {
		return sqlSession.selectOne("accountLogDao.getRecordCount",map);
	}
	//获取用户的交易记录列表count
	public List<Map<String,Object>> getRecordList(Map<String,Object> map) {
		return sqlSession.selectList("accountLogDao.getRecordList",map);
	}
	//添加用户地址
	public int addAddress(Map<String, Object> map) {
		int num = 0 ;
		try {
			
			if((map.get("isDefault")+"").equals("1")){
				sqlSession.update("accountDao.updOtherAddress",map);
			}
			num =  sqlSession.insert("accountDao.addAddress", map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return num;
	}
	//修改收货地址
	public int updateAddress(Map<String, Object> map) {
		if((map.get("isDefault")+"").equals("1")){
			sqlSession.update("accountDao.updOtherAddress",map);
		}
		return sqlSession.update("accountDao.updateAddress", map);
	}
	
	//保存个人认证信息
	@Transactional
	public int authentication(Map<String, Object> map) {
		//查询专家扩展信息表是否有该用户数据，若无则初始化一条记录
		Map<String,Object> extend=sqlSession.selectOne("accountDao.selectExtends", map);
		if(StringUtils.isEmpty(extend)) {
			//初始化扩展信息表
			sqlSession.insert("accountDao.addExtends", map);
		}
		return sqlSession.update("accountDao.authentication", map);
	}
	//查询旧密码
	public String selPwd(Map<String, Object> map) {
		return sqlSession.selectOne("accountDao.selPwd", map);
	}
	//修改密码
	public int updatePwd(Map<String, Object> map) {
		return sqlSession.update("accountDao.updatePwd", map);
	}
	//专栏设置
	public int setColumns(Map<String, Object> map) {
		return sqlSession.insert("accountDao.setColumns", map);
	}
	//取消收藏
	public int cancelCollect(Map paramap) {
		return sqlSession.delete("favoritesDao.delCollect",paramap);
	}
	//购物车移入收藏
	/*public boolean moveFavorite(Map<String, Object> paramap) {
		return sqlSession.insert("favoritesDao.moveFavorite",paramap)>0;
	}*/
	//查询纸质期刊收藏的物品
	public List selBook(Map paramap) {
		return sqlSession.selectList("favoritesDao.selBook",paramap);
	}
	public long getBookCount(Integer userId) {
		return sqlSession.selectOne("favoritesDao.getBookCount",userId);
	}
	public long getOthersCount(Integer userId) {
		return sqlSession.selectOne("favoritesDao.selOthersCount",userId);
	}
	//查询电子相关收藏的物品
	public List selOthers(Map<String, Object> paramap) {
		return sqlSession.selectList("favoritesDao.selOthers",paramap);
	}
	
	//用户添加收藏
	public int addCollect(Map<String, Object> map) {
		if("2".equals(map.get("favoriteType")+"")) {//如果是关注，专家id应该增加粉丝数
			sqlSession.update("accountDao.updateFollowNum", map);
			newsService.addUserNews(DataConvert.ToInteger(map.get("userId")), DataConvert.ToInteger(map.get("dataId")), DataConvert.ToInteger(map.get("dataId")), NewsType.favorite, null);
		}
		return sqlSession.insert("accountDao.addCollect", map);
	}
	//查询该商品是否已经收藏了
	public Map selIsfavorites(Map<String, Object> map){
		return sqlSession.selectOne("accountDao.selIsfavorites", map);
	}
	//获取用户打赏列表
	public List selRewardLoglist(Map<String, Object> map) {
		List list = sqlSession.selectList("accountDao.selRewardLoglist", map);
		pathService.getAbsolutePath(list, "userUrl");
		return list;
	}
	//获取用户打赏列表数量
	public long selRewardLogcount(Map<String, Object> map) {
		return sqlSession.selectOne("accountDao.selRewardLogcount", map);
	}
	//获取用户提问列表
	public List getInterlocutionList(Map<String, Object> paramap) {
		return sqlSession.selectList("accountDao.getInterlocutionList",paramap);
	}
	public long getInterlocutionCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("accountDao.getInterlocutionCount",paramap);
	}
	//获取用户提问详情
	public Map getInterlocution(Integer id) {
		return sqlSession.selectOne("accountDao.getInterlocution",id);
	}
	//用户添加笔记
	public boolean createNode(Map<String, Object> paramap) {
		return  sqlSession.insert("accountDao.createNode",paramap)>0;
	}
	//获取用户笔记列表
	public List<Map<String,Object>> getNodeList(Map<String, Object> paramap) {
		return sqlSession.selectList("accountDao.getNodeList",paramap);
	}
	//查询用户笔记总数量
	public long getNodeCount(Integer userId) {
		return sqlSession.selectOne("accountDao.getNodeCount",userId);
	}
	//删除笔记
	public boolean delNode(Map<String, Object> maps) {
		return sqlSession.delete("accountDao.delNode",maps)>0;
	}
	//通过手机号查询用户
	public Integer selUserBytelenumber(String telenumber) {
		return sqlSession.selectOne("userDao.selUserUserBytelenumber",telenumber);
	}
	//获取用户旁听列表
	public List getMyAuditList(Map<String, Object> paramap) {
		return sqlSession.selectList("auditDao.getAuditList",paramap);
	}
	public long getMyAuditListCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("auditDao.getAuditListCount",paramap);
	}
	//获取用户优惠券
	public long getCouponsCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("accountDao.getCouponsCount",paramap);
	}
	//获取用户代金券
	public long getVoucherCount(Map<String, Object> paramap) {
		return sqlSession.selectOne("accountDao.getVoucherCount",paramap);
	}
	//用户优惠券列表
	public List getCoupons(Map<String, Object> paramap) {
		return sqlSession.selectList("accountDao.getCoupons",paramap);
	}
	//用户代金券列表
	public List<Map<String,Object>> getVoucher(Map<String, Object> paramap) {
		return sqlSession.selectList("accountDao.getVouchers",paramap);
	}
	/**
	 * 获取用户信息 (头像，昵称，等级，已购，余额，优惠券，提问，旁听，打赏，关注)
	 * @param userId
	 * @return
	 */
	public Map<String, Object> selectUserMsg(String userId) {
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		if(StringUtils.isEmpty(userId) || "undefined".equals(userId)){
			return reqMap;
		}
		try {
			//获取用户信息
			map.put("userId", userId);
			Map message = sqlSession.selectOne("accountDao.getUserMsg", map);
			
			pathService.getAbsolutePath(message, "userUrl");
			
			//查询当前有几张优惠券
			int coupon = sqlSession.selectOne("accountDao.selUserCouponCount", map);
			message.put("coupon", coupon);
			//查询当前有几张优惠券
			int voucher = sqlSession.selectOne("accountDao.selUserVoucherCount", map);
			message.put("voucher", voucher);
			String openId = DataConvert.ToString(session.getAttribute("openId"));
			if(openId!=null && !openId.equals("")) {
				map.put("openId", openId);
			}
			//查询购买了几件物品
			int BuyCount = sqlSession.selectOne("accountDao.userBuyCount", map);
			message.put("buyCount", BuyCount);
			//查询我提问了几个人
			int twCount = sqlSession.selectOne("accountDao.userTwCount", map);
			message.put("twCount", twCount);
			//查询我旁听了几人
			int ptCount = sqlSession.selectOne("accountDao.userPTing", map);
			message.put("ptCount", ptCount);
			//查询我打赏了几人
			int rewardCount = sqlSession.selectOne("accountDao.userReward", map);
			message.put("rewardCount", rewardCount);
			//查询我关注了几人
			int followCount=sqlSession.selectOne("accountDao.myfollowCount", map);
			message.put("followCount", followCount);
			reqMap.put("result", 1);
			reqMap.put("msg", "获取成功");
			reqMap.put("data", message);
		} catch (Exception e) {
			e.printStackTrace();
			reqMap.put("msg", "请求错误");
		}
		return reqMap;
	}
	//查询userType
	public String selectUserType(String userId) {
		return sqlSession.selectOne("accountDao.selectUserType", userId);
	}
	//查询账户余额
	public Map selectBalance(String userId) {
		return sqlSession.selectOne("accountDao.selectBalance", userId);
	}
	//查询用户默认地址
	public Map selectIsDefaultAddress(Map<String, Object> map) {
		return sqlSession.selectOne("accountDao.selectIsDefaultAddress", map);
	}
	/**
	 * 创建打赏记录
	 * @param contentId
	 * @param money
	 * @param remark
	 * @return
	 */
	@Transactional
	public Map<String, Object> addRewardLog(String contentId, double money,String remark,String userId) {
		Map<String, Object> reqMap = new HashMap<String, Object>();
		//自己不能打赏自己
		if(userId.equals(contentId)) {
			reqMap.put("success", false);
			reqMap.put("msg", "自己不能打赏自己!");
			return reqMap;
		}
		Map<String, Object> map = new HashMap<String, Object>();
		String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
		String threeRandom = UtilDate.getThree();//三维随机数
		String sixRandom = ((int)((Math.random()*9+1)*100000))+"";//六位随机数

		map.put("rewardPeople", userId);
		map.put("beRewarding", contentId);
		map.put("money", money);
		map.put("remark", remark);
		map.put("orderno", ymds+sixRandom);
		map.put("tradeNo", ymds+threeRandom);
		int row = sqlSession.insert("accountDao.addRewardlog", map);
		if(row > 0){
			//添加paylog记录
			sqlSession.insert("accountDao.rewardPaylog", map);
			reqMap.put("success", true);
			reqMap.put("msg", "操作成功!");
			reqMap.put("paylogId", map.get("paylogId")+"");
		}else{
			reqMap.put("success", false);
			reqMap.put("msg", "操作失败!");
		}
		return reqMap;
	}
	//批量取消收藏/关注
	public int batcancelCollect(Map paramap) {
		return sqlSession.delete("favoritesDao.batcancelCollect",paramap);
	}
	/**
	 * 关注列表
	 * @param map
	 * @return
	 */
	public List selectFollowList(Map<String, Object> map) {
		return sqlSession.selectList("favoritesDao.selectFollowList", map);
	}
	/**
	 * 关注count
	 * @param map
	 * @return
	 */
	public long selectFollowCount(Map<String, Object> map) {
		return sqlSession.selectOne("favoritesDao.selectFollowCount", map);
	}
	//充值生成paylogId
	public int addMoney(Map<String, Object> parmap) {
		try {
			//useraccountlog中添加记录
			String ymds = UtilDate.getOrderNum();//年月日时分秒毫秒
			String threeRandom = UtilDate.getThree();//三维随机数
			String sixRandom = ((int)((Math.random()*9+1)*100000))+"";//六位随机数
			parmap.put("type",1 );
			parmap.put("orderNum", ymds+sixRandom);
			Calendar cal = Calendar.getInstance();
			int month = cal.get(Calendar.MONTH) + 1;// 当前月份
			parmap.put("month", month);
			parmap.put("status", 1);//收入
			int row = sqlSession.insert("accountLogDao.add",parmap);
			//生成paylog
			if(row>0){
				parmap.put("questionId",parmap.get("useraccountId"));
				parmap.put("source", 2);
				parmap.put("orderNo", ymds+sixRandom);
				int count = sqlSession.insert("questionDao.addPayLogInfo",parmap);
				if(count>0){
					return Integer.parseInt(parmap.get("payLogId")+"");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	// 通过商品类型和id获取符合的优惠券
	public Map getCouponsByType(Map<String, Object> paramap) {
		Map result = new HashMap();
		result.put("result", 1);
		double totalPrice =0;
		try {
			if(DataConvert.ToInteger(paramap.get("type"))==2 ||DataConvert.ToInteger(paramap.get("type"))==5){
				//用于放优惠券lists
				Set<Map<String,Object>> set  = new HashSet<>();
				List<Map<String,Object>> list = sqlSession.selectList("accountDao.getPubIdsCoupon", paramap);
				Map<String,Object> couponmap = new HashMap<String, Object>();
				Map<String,Object> disMap = new HashMap<String, Object>();
				for (Map<String, Object> map : list) {
					int type = DataConvert.ToInteger(map.get("producttype"));
					double subprice = DataConvert.ToDouble(map.get("subprice"));
					double bookPrice = DataConvert.ToDouble(map.get("bookPrice"));
					int productid = DataConvert.ToInteger(map.get("bookId"));
					disMap.put("productId", productid);
					//判断是否限时折扣
					if(type==2) {
						disMap.put("type", 1);
						Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
						if(bookPrice!=disPrice){
							result.put("result", 0);
							result.put("msg", "折扣商品不能和优惠券同时使用！");
							return result;
						}
					}else if(type==16) {
						//暂电子期刊不提供优惠券
					}
					couponmap.put("type", type);
					couponmap.put("price", subprice);
					couponmap.put("productId", productid);
					couponmap.put("userId", paramap.get("userId"));
					List subList = sqlSession.selectList("accountDao.getCouponsByType", couponmap);
					set.addAll(subList);
					totalPrice+=subprice;
				}
				//还需查询一次看是否有品类券的所有期刊的
				couponmap.put("price", totalPrice);
				List subList = sqlSession.selectList("accountDao.getCouponsByTypePinlei", couponmap);
				set.addAll(subList);
				List voucherlist = new ArrayList(set);
				result.put("lists", voucherlist);
			}else{
				//查询课程的价格
				totalPrice = sqlSession.selectOne("productDao.selTotalPriceOndemand", paramap);
				paramap.put("price", totalPrice);
				
				Map<String,Object> disMap = new HashMap<String, Object>();
				int productid = DataConvert.ToInteger(paramap.get("productId"));
				disMap.put("productId", productid);
				disMap.put("type", productid);
				int type = DataConvert.ToInteger(paramap.get("type"));
				//判断是否限时折扣
				disMap.put("type", type);
				Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
				if(!(totalPrice+"").equals(disPrice+"")){
					result.put("result", 0);
					result.put("msg", "折扣商品不能和优惠券同时使用！");
					return result;
				}
				//paramap:type  price productId
				List lists = sqlSession.selectList("accountDao.getCouponsByType", paramap);
				result.put("lists", lists);
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("result", 0);
			result.put("msg", "获取失败");
		}
		return result;
	}
	// 通过商品类型和id获取符合的代金券
	public Map getVoucherByType(Map<String, Object> paramap) {
		Map result = new HashMap();
		result.put("result", 1);
		//如果购买的
		
		
		if(DataConvert.ToInteger(paramap.get("type"))==2 || DataConvert.ToInteger(paramap.get("type"))==5){
			//判断是否限时折扣
			
			List<Map<String,Object>> dislist = sqlSession.selectList("accountDao.getPubIdsCoupon", paramap);
			Map<String,Object> disMap = new HashMap<String, Object>();
			for (Map<String, Object> dismap : dislist) {
				int type = DataConvert.ToInteger(dismap.get("producttype"));
				double bookPrice = DataConvert.ToDouble(dismap.get("bookPrice"));
				int productid = DataConvert.ToInteger(dismap.get("bookId"));
				disMap.put("productId", productid);
				//判断是否限时折扣
				if(type==2) {
					disMap.put("type", 1);
					Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
					if(bookPrice!=disPrice){
						result.put("result", 0);
						result.put("msg", "折扣商品不能和代金券同时使用！");
						return result;
					}
				}else if(type==16) {
					//暂电子期刊不提供优惠券
				}
			
			}
			
			
			List<Map> list = sqlSession.selectList("accountDao.getPubIds", paramap);
			if(list.size()>0) {
				List pubIds = new ArrayList();
				for (Map map : list) {
					String descs = DataConvert.ToString(map.get("desc"));
					String[] pubId = descs.split(",");
					pubIds.add(pubId[0]);
				}
				try {
					paramap.put("pubIds", pubIds);
					List<Map> period = sqlSession.selectList("accountDao.getPeriods", paramap);
					String periods = "";
					for (Map map : period) {
						String subid = DataConvert.ToString(map.get("id"));
						periods+=subid;
						periods+=",";
					}
					paramap.put("productId", periods);
					List lists = sqlSession.selectList("accountDao.getVoucherByType", paramap);
					result.put("lists", lists);
					return result;
				} catch (Exception e) {
					e.printStackTrace();
					result.put("result", 0);
					return result;
				}
			}else {
				result.put("lists", null);
				return result;
			}
			
		}else{
			try {
				Double totalPrice = sqlSession.selectOne("productDao.selTotalPriceOndemand", paramap);
				Map<String,Object> disMap = new HashMap<String, Object>();
				int productid = DataConvert.ToInteger(paramap.get("productId"));
				disMap.put("productId", productid);
				disMap.put("type", productid);
				int type = DataConvert.ToInteger(paramap.get("type"));
				//判断是否限时折扣
				disMap.put("type", type);
				Double disPrice = searcheDiscountService.searchDiscountPrice(disMap);
				if(!(totalPrice+"").equals(disPrice+"")){
					result.put("result", 0);
					result.put("msg", "折扣商品不能和优惠券同时使用！");
					return result;
				}
				List lists = sqlSession.selectList("accountDao.getVoucherByType", paramap);
				result.put("lists", lists);
			} catch (Exception e) {
				e.printStackTrace();
			}
			return result;
		}
	}
	
	//修改手机号
	public int updatePhone(Map<String, Object> map) {
		return sqlSession.update("accountDao.updatePhone", map);
	}

	
}
