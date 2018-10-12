package cn.admin.statistic.controller;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.admin.statistic.service.StatisticsService;
import cn.emay.sdk.util.StringUtil;
import cn.util.DataConvert;
import cn.util.ExcelUntil;
import cn.util.Page;
import cn.util.StringHelper;

@Controller
@RequestMapping(value="/admin/statistics")
public class StatisticsController {
	
	@Autowired
	StatisticsService statisticsService;
	@Autowired
	SqlSession sqlSession;
	
		/**
		 * 跳转 汇总页面
		 * @return
		 */
		@RequestMapping("index")
		public ModelAndView turnIndex() {
			ModelAndView mav=new ModelAndView("/admin/statistics/total");
			//查询book表所有期刊
			//List<Map<String,Object>> bookList = sqlSession.selectList("cn.dao.bookDao.selectAllBookList");
			//mav.addObject("bookList",bookList);
			//查询年份
			List<String> year = statisticsService.getYears();
			mav.addObject("year",year);
			//查询ondemand表所有课程
			List<Map<String,Object>> ondemandList = sqlSession.selectList("demandDao.selectAllOndemandList");
			mav.addObject("ondemandList",ondemandList);
			//查询assortment表所有type=1(课程类别)的所有课程类型.
			List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList");
			mav.addObject("ondemandTypeList",ondemandTypeList);
			return mav;
		}
		@RequestMapping("getBookByYear")
		@ResponseBody
		public Map<String,Object> getBookByYear(String year){
			List<Map<String,Object>> bookList = statisticsService.getBookByYear(year);
			Map<String,Object> map = new HashMap<String, Object>();
			map.put("bookList", bookList);
			return map;
		}
		/**
		 * 汇总列表
		 * @param request
		 * @param search
		 * @return
		 */
		@RequestMapping(value="/statisticOrderTotals")
		@ResponseBody
		public Map statisticOrderTotals(HttpServletRequest request,@RequestParam Map search){
			Map<String,Object> map = new HashMap<String, Object>();//返回值map
			List<Map> list = new ArrayList<Map>();//返回值list
			List<Map> list1 = new ArrayList<Map>();
			List<Map> booklist = new ArrayList<Map>();
			List<Integer> ordetTypeList = new ArrayList<>();
			List<Integer> bookAndElectronicList = new ArrayList<>();
			//问答和打赏参数
			if(search.get("orderTypeTotal") !=null && !"".equals(search.get("orderTypeTotal"))) {
				ordetTypeList = StringHelper.ToIntegerList(search.get("orderTypeTotal")+"");
			}
			//期刊和电子书参数
			if(search.get("bookAndElectronic") !=null && !"".equals(search.get("bookAndElectronic"))) {
				bookAndElectronicList = StringHelper.ToIntegerList(search.get("bookAndElectronic")+"");
			}
			search.put("ordetTypeList", ordetTypeList);
			search.put("bookAndElectronicType", bookAndElectronicList);
			//课程下拉选参数
			if((ordetTypeList !=null && ordetTypeList.size()>0) || (search.get("courseState") !=null && !"".equals(search.get("courseState")))
					|| (search.get("productid") !=null && !"".equals(search.get("productid")))
					|| (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
				if(ordetTypeList !=null && ordetTypeList.size()>0) {
					list =  statisticsService.selectStatistics(search);
				}
				//课程下拉选参数
				if(search.get("courseState") !=null && !"".equals(search.get("courseState"))
						&& (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
					Map<String,String> ondemandType = new HashMap<String,String>();
					ondemandType.put("_parameter", search.get("ondemandId").toString());
					//查询课程表中type(课程类型字段)
					ondemandType = sqlSession.selectOne("demandDao.findById",ondemandType);
					list1 =  statisticsService.selectCourseItemsStatistic(search); 
					if(ondemandType !=null) {
						list1.get(0).put("ondemandType", ondemandType.get("type"));
						
						search.put("ondemandTyId", ondemandType.get("type"));
						//查询assortment表name
						List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList",search);
						if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
							list1.get(0).put("name", ondemandTypeList.get(0).get("name"));
						}
						
					}
					list.add(list1.get(0));
				}else if((search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
					Map<String,String> ondemandType = new HashMap<String,String>();
					ondemandType.put("_parameter", search.get("ondemandId").toString());
					ondemandType = sqlSession.selectOne("demandDao.findById",ondemandType);
					list1 =  statisticsService.selectCourseItemsStatistic(search); 
					if(ondemandType !=null) {
						list1.get(0).put("ondemandType", ondemandType.get("type"));
						
						search.put("ondemandTyId", ondemandType.get("type"));
						//查询assortment表name
						List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList",search);
						if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
							list1.get(0).put("name", ondemandTypeList.get(0).get("name"));
						}
						
					}
					list.add(list1.get(0));
				}else if(search.get("courseState") !=null && !"".equals(search.get("courseState"))) {
					list1 =  statisticsService.selectCourseTypeStatistic(search); 
					/*list1.get(0).put("ondemandType", search.get("courseState"));
					
					search.put("ondemandTyId", search.get("courseState"));
					//查询assortment表name
					List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList",search);
					if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
						list1.get(0).put("name", ondemandTypeList.get(0).get("name"));
					}*/
					list.addAll(list1);
					//list.add(list1.get(0));
				}
				//期刊列表下拉选参数
				if(search.get("productid") !=null && !"".equals(search.get("productid"))) {
					booklist =  statisticsService.selectBookAndElectronic(search); 
					list.addAll(booklist);
				}
			}else {
				list =  statisticsService.selectStatistics(search);
				List<Map> courselist = new ArrayList<Map>();
				//查询assortment表所有type=1(课程类别)的所有课程类型.
				List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList");
				if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
					for (Map<String, Object> ondemandType : ondemandTypeList) {
						search.put("courseState", ondemandType.get("id").toString());
						courselist = statisticsService.selectCourseTypeStatistic(search); 
						courselist.get(0).put("ondemandType", ondemandType.get("id").toString());
						//为了在页面展示课程类型名称
						courselist.get(0).put("name", ondemandType.get("name").toString());
						list.addAll(courselist);
					}
				}
				
			}
			//汇总页面-合计计算
			Map<String, Object> total = total(list);
			list.add(total);
			map.put("msg", "");
			map.put("code", 0);
			map.put("data", list);
			return map;
		}
		/**
		 * 汇总-合计计算
		 * @param list
		 * @return
		 */
		public Map<String, Object> total(List<Map> list){
			String price = "0.0";
			BigDecimal totalprice = new BigDecimal(price);
			BigDecimal totalpriceNew = new BigDecimal(price);
			BigDecimal couponPrice = new BigDecimal(price);
			BigDecimal couponPriceNew = new BigDecimal(price);
			BigDecimal actualPayPrice = new BigDecimal(price);
			BigDecimal actualPayPriceNew = new BigDecimal(price);
			Map<String, Object> total = new HashMap<String, Object>();
			for (Map<String, Object> mapPrice : list) {
                for (Map.Entry<String, Object> m : mapPrice.entrySet()) {
                	//订单金额
                	if(m.getKey().equals("totalprice")) {
                		totalpriceNew = new BigDecimal(m.getValue().toString());  
                		totalprice = totalprice.add(totalpriceNew);
                	}
                	//优惠券金额
                	if(m.getKey().equals("couponPrice")) {
                			couponPriceNew = new BigDecimal(m.getValue().toString());  
                			couponPrice = couponPrice.add(couponPriceNew);
                	}
                	//余额
                	if(m.getKey().equals("actualPayPrice")) {
                		actualPayPriceNew = new BigDecimal(m.getValue().toString());  
                		actualPayPrice = actualPayPrice.add(actualPayPriceNew);
                	}
                }
            }
			total.put("totalprice", totalprice);
			total.put("couponPrice", couponPrice);
			total.put("actualPayPrice", actualPayPrice);
			total.put("ordertype", 5);//5-合计
			return total;
		}
		/**
		 * 支付方式-数字转化为汉字,StringHelper.ToIntegerList方法只有int类型转化,所以传参直接为数字,没传汉字
		 * @param search
		 * @param payName
		 * @param payMehod
		 * @return
		 */
		public List<String> transferPayWay(Map search,List<Integer> payName,List<String> payMehod){
			if(search.get("payName") !=null && !"".equals(search.get("payName"))) {
				payName = StringHelper.ToIntegerList(search.get("payName")+"");
				if(payName !=null && payName.size()>0) {
					for(int i=0;i<payName.size();i++) {
						if(payName.get(i).equals(1)) {
							payMehod.add("支付宝支付");
						}
						if(payName.get(i).equals(2)) {
							payMehod.add("微信支付");
						}
						if(payName.get(i).equals(3)) {
							payMehod.add("余额支付");
						}
					}
				}
			}
			return payMehod;
		}
		/**
		 * 订单列表
		 * @param request
		 * @param search
		 * @param page
		 * @param limit
		 * @return
		 */
		@RequestMapping(value="/statisticAboutOrders")
		@ResponseBody
		public  Map statisticAboutOrders(HttpServletRequest request,@RequestParam Map search, int page, int limit){
			List<Integer> orderTypeList = new ArrayList<Integer>();
			List<Integer> questionAnswer = new ArrayList<Integer>();
			List<Integer> bookAndElectronic = new ArrayList<Integer>();
			List<Integer> payName = new ArrayList<Integer>();
			List<String> payMehod = new ArrayList<String>();
			List<Map> list1 = new ArrayList<Map>();
			//期刊和电子书
			if(search.get("bookAndElectronic") !=null && !"".equals(search.get("bookAndElectronic"))) {
				bookAndElectronic = StringHelper.ToIntegerList(search.get("bookAndElectronic")+"");
			}
			//课程
			if(search.get("magazineAndCourse") !=null && !"".equals(search.get("magazineAndCourse"))) {
				orderTypeList = StringHelper.ToIntegerList(search.get("magazineAndCourse")+"");
			}
			//问答和打赏
			if(search.get("questionAnswer") !=null && !"".equals(search.get("questionAnswer"))) {
				questionAnswer = StringHelper.ToIntegerList(search.get("questionAnswer")+"");
			}
			//支付方式
			payMehod = transferPayWay(search,payName,payMehod);
			Map<String,Object> map = new HashMap<String, Object>();
			List<Map> list = new ArrayList<Map>();
			long totalCount = 0;
			long totalCount1 = 0;
			long totalCount2 = 0;
			long totalCount3 = 0;
			long totalCount4 = 0;
			
			List<Integer> searchTypeList = new ArrayList<Integer>();
			if(search.get("questionAnswer") !=null && !"".equals(search.get("questionAnswer"))) {
				searchTypeList.add(1);//问答或打赏:1
			}
			if((search.get("courseState") !=null && !"".equals(search.get("courseState")) || (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId"))))) {
				searchTypeList.add(2);//课程:2
			}
			if(search.get("productid") !=null && !"".equals(search.get("productid"))) {
				searchTypeList.add(3);//期刊:3
			}
			
			//实现-勾选期刊或课程和问答或打赏,记录都出来.数据库中是两个字段,不好实现
			if((orderTypeList !=null && orderTypeList.size()>0) || (questionAnswer !=null && questionAnswer.size()>0)
					|| (search.get("courseState") !=null && !"".equals(search.get("courseState"))) 
					|| (search.get("productid") !=null && !"".equals(search.get("productid")))
					|| (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
				Map search1 = new HashMap();
				search1.put("searchTypeList", searchTypeList);
				search1.put("startTime", search.get("startTime"));
				search1.put("endTime", search.get("endTime"));
				search1.put("payMehod", payMehod);
				search1.put("questionAnswer", questionAnswer);
				search1.put("ondemandId", search.get("ondemandId"));
				search1.put("courseState", search.get("courseState"));
				search1.put("productid", search.get("productid"));
				search1.put("bookAndElectronicType", bookAndElectronic);
				totalCount = statisticsService.selectSearchOrderCount(search1);//总条数
				Page page1 = new Page(totalCount, page, limit);
				search1.put("start", page1.getStartPos());
				search1.put("pageSize", limit);
				list = statisticsService.selectSearchOrder(search1);
				List<Map> subResultList = new ArrayList<Map>();
				Map subResult = new HashMap();
				StringBuffer stringBuffer = new StringBuffer();
				if(list !=null && list.size()>0) {
					for (Map subMap : list) {
						subResult.put("orderId", subMap.get("orderId").toString()) ;
						subResultList = sqlSession.selectList("statisticsDao.selIsSubName", subResult);
						if(subResultList !=null && subResultList.size()>0) {
							String productName = subMap.get("productName").toString();
							stringBuffer.append(productName);
							for (Map subIsName : subResultList) {
								stringBuffer.append(",");
								String sub = subIsName.get("isSubName").toString();
								stringBuffer.append(sub);
								stringBuffer.append("(赠品)");
							}
							subMap.put("productName", stringBuffer.toString());
						}
					}
				}
			}else {
				search.put("payMehod", payMehod);
				search.put("questionAnswer", questionAnswer);
				search.put("orderTypeList", orderTypeList);
				totalCount = statisticsService.selectAboutOrderCount(search);//总条数
				Page page2 = new Page(totalCount, page, limit);
				search.put("start", page2.getStartPos());
				search.put("pageSize", limit);
				list = statisticsService.selectAboutOrder(search);
				List<Map> subResultList = new ArrayList<Map>();
				Map subResult = new HashMap();
				StringBuffer stringBuffer = new StringBuffer();
				if(list !=null && list.size()>0) {
					for (Map subMap : list) {
						subResult.put("orderId", subMap.get("orderId").toString()) ;
						subResultList = sqlSession.selectList("statisticsDao.selIsSubName", subResult);
						if(subResultList !=null && subResultList.size()>0) {
							String productName = subMap.get("productName").toString();
							stringBuffer.append(productName);
							for (Map subIsName : subResultList) {
								stringBuffer.append(",");
								String sub = subIsName.get("isSubName").toString();
								stringBuffer.append(sub);
								stringBuffer.append("(赠品)");
							}
							subMap.put("productName", stringBuffer.toString());
						}
					}
				}
			}
			map.put("msg", "");
			map.put("code", 0);
			map.put("data", list);
			map.put("count", totalCount);
			return map;
		}
		/**
		 * 实现order表中如果userTel==null,则用order表中openid去wechat_openid中查询用户名称.
		 * @param list
		 * @param search
		 */
		public void isWechatName(List<Map> list,Map search) {
			Map courseMap = new HashMap();
			if(list !=null && list.size()>0) {
				for (Map<String,String> course : list) {
					if(course.get("userTel").toString().equals("0") ) {
						String openId = course.get("openId").toString();
						//数据库加IFNULL(b.openId, 0) openId:为了避免脏数据(有这个用户下单数据,但是用户表记录为空)
						search.put("openId", openId);
						if(openId !=null) {
							courseMap = sqlSession.selectOne("cn.dao.wechatUserDao.selWechatUserByOpenId", search);
						}
						if(courseMap !=null) {
							course.put("userTel", courseMap.get("nickName").toString());
						}
				    }
			    }
			}
		}
		
		
		/**
		 * 批量导出汇总
		 * @param map
		 * @param response
		 * @throws UnsupportedEncodingException
		 */
		@RequestMapping(value="/statisticsExport")
		@ResponseBody
		public void statisticsExport(@RequestParam Map search,HttpServletResponse response) throws UnsupportedEncodingException{
			Map<String,Object> map = new HashMap<String, Object>();//返回值map
			List<Map> list = new ArrayList<Map>();//返回值list
			List<Map> list1 = new ArrayList<Map>();
			List<Map> booklist = new ArrayList<Map>();
			List<Integer> ordetTypeList = new ArrayList<>();
			List<Integer> bookAndElectronicList = new ArrayList<>();
			//问答和打赏参数
			if(search.get("orderTypeTotal") !=null && !"".equals(search.get("orderTypeTotal"))) {
				ordetTypeList = StringHelper.ToIntegerList(search.get("orderTypeTotal")+"");
			}
			//期刊和电子书参数
			if(search.get("bookAndElectronic") !=null && !"".equals(search.get("bookAndElectronic"))) {
				bookAndElectronicList = StringHelper.ToIntegerList(search.get("bookAndElectronic")+"");
			}
			search.put("ordetTypeList", ordetTypeList);
			search.put("bookAndElectronicType", bookAndElectronicList);
			//课程下拉选参数
			if((ordetTypeList !=null && ordetTypeList.size()>0) || (search.get("courseState") !=null && !"".equals(search.get("courseState")))
					|| (search.get("productid") !=null && !"".equals(search.get("productid")))
					|| (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
				if(ordetTypeList !=null && ordetTypeList.size()>0) {
					list =  statisticsService.selectStatistics(search);
				}
				//课程下拉选参数
				if(search.get("courseState") !=null && !"".equals(search.get("courseState"))
						&& (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
					Map<String,String> ondemandType = new HashMap<String,String>();
					ondemandType.put("_parameter", search.get("ondemandId").toString());
					//查询课程表中type(课程类型字段)
					ondemandType = sqlSession.selectOne("demandDao.findById",ondemandType);
					list1 =  statisticsService.selectCourseItemsStatistic(search); 
					if(ondemandType !=null) {
						list1.get(0).put("ondemandType", ondemandType.get("type"));
						
						search.put("ondemandTyId", ondemandType.get("type"));
						//查询assortment表name
						List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList",search);
						if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
							list1.get(0).put("name", ondemandTypeList.get(0).get("name"));
						}
						
					}
					list.add(list1.get(0));
				}else if((search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
					Map<String,String> ondemandType = new HashMap<String,String>();
					ondemandType.put("_parameter", search.get("ondemandId").toString());
					ondemandType = sqlSession.selectOne("demandDao.findById",ondemandType);
					list1 =  statisticsService.selectCourseItemsStatistic(search); 
					if(ondemandType !=null) {
						list1.get(0).put("ondemandType", ondemandType.get("type"));
						
						search.put("ondemandTyId", ondemandType.get("type"));
						//查询assortment表name
						List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList",search);
						if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
							list1.get(0).put("name", ondemandTypeList.get(0).get("name"));
						}
						
					}
					list.add(list1.get(0));
				}else if(search.get("courseState") !=null && !"".equals(search.get("courseState"))) {
					list1 =  statisticsService.selectCourseTypeStatistic(search); 
					list.addAll(list1);
				}
				//期刊列表下拉选参数
				if(search.get("productid") !=null && !"".equals(search.get("productid"))) {
					booklist =  statisticsService.selectBookAndElectronic(search); 
					list.addAll(booklist);
				}
			}else {
				list =  statisticsService.selectStatistics(search);
				List<Map> courselist = new ArrayList<Map>();
				//查询assortment表所有type=1(课程类别)的所有课程类型.
				List<Map<String,Object>> ondemandTypeList = sqlSession.selectList("demandDao.selectAllOndemandTypeList");
				if(ondemandTypeList !=null && ondemandTypeList.size()>0) {
					for (Map<String, Object> ondemandType : ondemandTypeList) {
						search.put("courseState", ondemandType.get("id").toString());
						courselist = statisticsService.selectCourseTypeStatistic(search); 
						courselist.get(0).put("ondemandType", ondemandType.get("id").toString());
						//为了在页面展示课程类型名称
						courselist.get(0).put("name", ondemandType.get("name").toString());
						list.addAll(courselist);
					}
				}
				
			}
			
			
			List<Map> dataList = new ArrayList();
			String name = "汇总";
			// 区分
			String[] excelHeader = new String[] { "订单类型","订单金额","优惠券(折让)金额","实际支付金额"};
			//String[] excelHeader = new String[] { "订单类型","专家","订单金额","优惠券(折让)金额","实际支付金额"};
			String[] mapKey = new String[] { "ordertype","totalprice", "couponPrice","actualPayPrice"};
			//String[] mapKey = new String[] { "ordertype","nickName", "totalprice", "couponPrice","actualPayPrice"};
			for (Map map2 : list) {
				Map<String,Object> data = new HashMap<String, Object>();
				String ordertype = "";
				int type = DataConvert.ToInteger(map2.get("ordertype"));
				if(type==1 || type==3 || type==4 || type==6) {
					ordertype = StateValueTransfer.orderType(ordertype, map2);
					data.put("ordertype", ordertype);
				}else {
					data.put("ordertype", DataConvert.ToString(map2.get("name")));
					
				}
				//data.put("nickName", DataConvert.ToString(map2.get("nickName")));
				data.put("totalprice", DataConvert.ToString(map2.get("totalprice")));
				data.put("couponPrice", DataConvert.ToString(map2.get("couponPrice")));
				data.put("actualPayPrice", DataConvert.ToString(map2.get("actualPayPrice")));
				//if(DataConvert.ToInteger(map2.get("ordertype")))
				dataList.add(data);
			}
			//合计-计算
			Map<String, Object> total = total(list);
			total.put("ordertype", "合计");
			dataList.add(total);
			ExcelUntil.excelToFile(dataList, excelHeader, mapKey, response, name + "统计");
		}
		
		//导出-对订单,商品 传参方法
		public void paraMethod(Map map) {
			if(!StringUtil.isEmpty(DataConvert.ToString(map.get("orderTypeList")))) {
				String[] orderTypeList = DataConvert.ToString(map.get("orderTypeList")).split(",");
				map.put("orderTypeList", orderTypeList);
			}
			
			if(!StringUtil.isEmpty(DataConvert.ToString(map.get("questionAnswer")))) {
				String[] questionAnswer = DataConvert.ToString(map.get("questionAnswer")).split(",");
				map.put("questionAnswer", questionAnswer);
			}
			if(!StringUtil.isEmpty(DataConvert.ToString(map.get("payMehod")))) {
				String[] payMehod = DataConvert.ToString(map.get("payMehod")).split(",");
				map.put("payMehod", payMehod);
			}
		}
		
		
		
		/**
		 * 批量导出订单
		 * @param map
		 * @param response
		 * @throws UnsupportedEncodingException
		 */
		@RequestMapping(value="/statisticsExportForOrder")
		@ResponseBody
		public void statisticsExportForOrder(@RequestParam Map search,HttpServletResponse response) throws UnsupportedEncodingException{
		/*	if(!StringUtil.isEmpty(DataConvert.ToString(map.get("orderId")))) {
				String[] orderId = DataConvert.ToString(map.get("orderId")).split(",");
				map.put("orderId", orderId);
			}
			paraMethod(map);
			List<Map> list = new ArrayList<Map>();
			List<Map> list1 = new ArrayList<Map>();
			if(map.get("orderTypeList")!=null && !"".equals(map.get("orderTypeList")) && map.get("questionAnswer")!=null && !"".equals(map.get("questionAnswer")) ) {
				if(map.get("orderTypeList")!=null && !"".equals(map.get("orderTypeList"))) {
					Map mapOT = new HashMap();
					mapOT.put("startTime", map.get("startTime"));
					mapOT.put("endTime", map.get("endTime"));
					mapOT.put("orderId", map.get("orderId"));
					mapOT.put("orderTypeList", map.get("orderTypeList"));
					mapOT.put("payMehod", map.get("payMehod"));
					list1 = statisticsService.selectExportOrder(mapOT);
					list.addAll(list1);
				}
				if(map.get("questionAnswer")!=null && !"".equals(map.get("questionAnswer"))) {
					Map mapQA = new HashMap();
					mapQA.put("startTime", map.get("startTime"));
					mapQA.put("endTime", map.get("endTime"));
					mapQA.put("orderId", map.get("orderId"));
					mapQA.put("questionAnswer", map.get("questionAnswer"));
					mapQA.put("payMehod", map.get("payMehod"));
					list1 = statisticsService.selectExportOrder(mapQA);
					list.addAll(list1);
				}
			}else {
				list =  statisticsService.selectExportOrder(map);//待发货期刊列表
			}*/
			
			List<Integer> orderTypeList = new ArrayList<Integer>();
			List<Integer> questionAnswer = new ArrayList<Integer>();
			List<Integer> bookAndElectronic = new ArrayList<Integer>();
			List<Integer> payName = new ArrayList<Integer>();
			List<String> payMehod = new ArrayList<String>();
			List<Map> list1 = new ArrayList<Map>();
			//期刊和电子书
			if(search.get("bookAndElectronic") !=null && !"".equals(search.get("bookAndElectronic"))) {
				bookAndElectronic = StringHelper.ToIntegerList(search.get("bookAndElectronic")+"");
			}
			//课程
			if(search.get("magazineAndCourse") !=null && !"".equals(search.get("magazineAndCourse"))) {
				orderTypeList = StringHelper.ToIntegerList(search.get("magazineAndCourse")+"");
			}
			//问答和打赏
			if(search.get("questionAnswer") !=null && !"".equals(search.get("questionAnswer"))) {
				questionAnswer = StringHelper.ToIntegerList(search.get("questionAnswer")+"");
			}
			//支付方式
			payMehod = transferPayWay(search,payName,payMehod);
			Map<String,Object> map = new HashMap<String, Object>();
			List<Map> list = new ArrayList<Map>();
			long totalCount = 0;
			long totalCount1 = 0;
			long totalCount2 = 0;
			long totalCount3 = 0;
			long totalCount4 = 0;
			
			List<Integer> searchTypeList = new ArrayList<Integer>();
			if(search.get("questionAnswer") !=null && !"".equals(search.get("questionAnswer"))) {
				searchTypeList.add(1);//问答或打赏:1
			}
			if((search.get("courseState") !=null && !"".equals(search.get("courseState")) || (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId"))))) {
				searchTypeList.add(2);//课程:2
			}
			if(search.get("productid") !=null && !"".equals(search.get("productid"))) {
				searchTypeList.add(3);//期刊:3
			}
			
			//实现-勾选期刊或课程和问答或打赏,记录都出来.数据库中是两个字段,不好实现
			if((orderTypeList !=null && orderTypeList.size()>0) || (questionAnswer !=null && questionAnswer.size()>0)
					|| (search.get("courseState") !=null && !"".equals(search.get("courseState"))) 
					|| (search.get("productid") !=null && !"".equals(search.get("productid")))
					|| (search.get("ondemandId") !=null && !"".equals(search.get("ondemandId")))) {
				Map search1 = new HashMap();
				search1.put("searchTypeList", searchTypeList);
				search1.put("startTime", search.get("startTime"));
				search1.put("endTime", search.get("endTime"));
				search1.put("payMehod", payMehod);
				search1.put("questionAnswer", questionAnswer);
				search1.put("ondemandId", search.get("ondemandId"));
				search1.put("courseState", search.get("courseState"));
				search1.put("productid", search.get("productid"));
				search1.put("bookAndElectronicType", bookAndElectronic);
				list = statisticsService.selectSearchOrder(search1);
				List<Map> subResultList = new ArrayList<Map>();
				Map subResult = new HashMap();
				StringBuffer stringBuffer = new StringBuffer();
				if(list !=null && list.size()>0) {
					for (Map subMap : list) {
						subResult.put("orderId", subMap.get("orderId").toString()) ;
						subResultList = sqlSession.selectList("statisticsDao.selIsSubName", subResult);
						if(subResultList !=null && subResultList.size()>0) {
							String productName = subMap.get("productName").toString();
							stringBuffer.append(productName);
							for (Map subIsName : subResultList) {
								stringBuffer.append(",");
								String sub = subIsName.get("isSubName").toString();
								stringBuffer.append(sub);
								stringBuffer.append("(赠品)");
							}
							subMap.put("productName", stringBuffer.toString());
						}
					}
				}
			}else {
				search.put("payMehod", payMehod);
				search.put("questionAnswer", questionAnswer);
				search.put("orderTypeList", orderTypeList);
				list = statisticsService.selectAboutOrder(search);
				List<Map> subResultList = new ArrayList<Map>();
				Map subResult = new HashMap();
				StringBuffer stringBuffer = new StringBuffer();
				if(list !=null && list.size()>0) {
					for (Map subMap : list) {
						subResult.put("orderId", subMap.get("orderId").toString()) ;
						subResultList = sqlSession.selectList("statisticsDao.selIsSubName", subResult);
						if(subResultList !=null && subResultList.size()>0) {
							String productName = subMap.get("productName").toString();
							stringBuffer.append(productName);
							for (Map subIsName : subResultList) {
								stringBuffer.append(",");
								String sub = subIsName.get("isSubName").toString();
								stringBuffer.append(sub);
								stringBuffer.append("(赠品)");
							}
							subMap.put("productName", stringBuffer.toString());
						}
					}
				}
			}
			
			List<Map> dataList = new ArrayList();
			String name = "订单";
			// 区分
			String[] excelHeader = new String[] { "订单类型","订单编号","用户信息","收货人姓名","收货人电话","收货人地址","订单商品","订单金额","优惠券(折让)金额","支付日期","实际支付金额"};
			String[] mapKey = new String[] { "ordertype", "orderno", "userTel","receivername","receiverphone","address","productName","totalprice","jianprice","payTime","actualPrice"};
			
			for (Map map2 : list) {
				Map<String,Object> data = new HashMap<String, Object>();
				int type = DataConvert.ToInteger(map2.get("ordertype"));
				if(type==2) {
					data.put("ordertype", "期刊");
				}else if(type==16){
					data.put("ordertype", "电子书");
				}else if(type==4 || type==8) {
					data.put("ordertype", "课程");
				}
				data.put("receivername", DataConvert.ToString(map2.get("receivername")));
				data.put("receiverphone", DataConvert.ToString(map2.get("receiverphone")));
				data.put("address", DataConvert.ToString(map2.get("receiverProvince"))
						+DataConvert.ToString(map2.get("receiverCity"))
						+DataConvert.ToString(map2.get("receiverCounty"))
						+DataConvert.ToString(map2.get("receiverAddress")));
				data.put("orderno", DataConvert.ToString(map2.get("orderno")));
				data.put("userTel", DataConvert.ToString(map2.get("userTel")));
				data.put("productName", DataConvert.ToString(map2.get("productName")));
				data.put("totalprice", DataConvert.ToString(map2.get("totalprice")));
				data.put("jianprice", DataConvert.ToString(map2.get("jianprice")));
				data.put("payTime", DataConvert.ToString(map2.get("time")));
				data.put("actualPrice", DataConvert.ToString(map2.get("actualPrice")));
				dataList.add(data);
			}
			ExcelUntil.excelToFile(dataList, excelHeader, mapKey, response, name + "统计");
		}
		
		/**
		 * 批量导出商品
		 * @param map
		 * @param response
		 * @throws UnsupportedEncodingException
		 */
		@RequestMapping(value="/statisticsExportForProuduct")
		@ResponseBody
		public void statisticsExportForProuduct(@RequestParam Map map,HttpServletResponse response) throws UnsupportedEncodingException{
			if(!StringUtil.isEmpty(DataConvert.ToString(map.get("productId")))) {
				String[] productId = DataConvert.ToString(map.get("productId")).split(",");
				map.put("productId", productId);
			}
			paraMethod(map);
			
			List<Map> list = new ArrayList<Map>();
			List<Map> list1 = new ArrayList<Map>();
			if(map.get("orderTypeList")!=null && !"".equals(map.get("orderTypeList")) && map.get("questionAnswer")!=null && !"".equals(map.get("questionAnswer")) ) {
				if(map.get("orderTypeList")!=null && !"".equals(map.get("orderTypeList"))) {
					Map mapOT = new HashMap();
					mapOT.put("startTime", map.get("startTime"));
					mapOT.put("endTime", map.get("endTime"));
					mapOT.put("productId", map.get("productId"));
					mapOT.put("orderTypeList", map.get("orderTypeList"));
					mapOT.put("payMehod", map.get("payMehod"));
					list1 = statisticsService.selectExportProuduct(mapOT);
					list.addAll(list1);
				}
				if(map.get("questionAnswer")!=null && !"".equals(map.get("questionAnswer"))) {
					Map mapQA = new HashMap();
					mapQA.put("startTime", map.get("startTime"));
					mapQA.put("endTime", map.get("endTime"));
					mapQA.put("productId", map.get("productId"));
					mapQA.put("questionAnswer", map.get("questionAnswer"));
					mapQA.put("payMehod", map.get("payMehod"));
					list1 = statisticsService.selectExportProuduct(mapQA);
					list.addAll(list1);
				}
			}else {
				list =  statisticsService.selectExportProuduct(map);
			}
			
			List<Map> dataList = new ArrayList();
			String name = "商品";
			// 区分
			String[] excelHeader = new String[] { "订单类型","订单编号","用户信息","商品名称","商品类型","商品价格","数量","是否赠品","状态"};
			String[] mapKey = new String[] { "ordertype", "orderno", "userTel","productname","producttype","totalprice","count","subType","deliverstatus"};
			
			for (Map map2 : list) {
				Map<String,Object> data = new HashMap<String, Object>();
				String ordertype = "";
				ordertype = StateValueTransfer.orderType1(ordertype, map2);
				data.put("ordertype", ordertype);
				data.put("orderno", DataConvert.ToString(map2.get("orderno")));
				data.put("userTel", DataConvert.ToString(map2.get("userTel")));
				data.put("productname", DataConvert.ToString(map2.get("productname")));
				String producttype = "";
				producttype = StateValueTransfer.productType(producttype, map2);
				data.put("producttype", producttype);
				data.put("totalprice", DataConvert.ToString(map2.get("totalprice")));
				data.put("count", DataConvert.ToInteger(map2.get("count")));
				String subType = "";
				subType = StateValueTransfer.subType(subType, map2);
				data.put("subType", subType);
				String deliverstatus = "";
				deliverstatus = StateValueTransfer.deliverstatus(deliverstatus, map2);
				data.put("deliverstatus", deliverstatus);
				dataList.add(data);
			}
			ExcelUntil.excelToFile(dataList, excelHeader, mapKey, response, name + "统计");
		}
		
}
