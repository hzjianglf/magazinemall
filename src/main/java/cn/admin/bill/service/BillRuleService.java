package cn.admin.bill.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import cn.Setting.Setting;
import cn.Setting.Model.RuleSetting;
import cn.admin.bill.model.BillRule;
import cn.admin.bill.model.CalcRuleSetting;
import cn.admin.bill.model.OndemandRuleSetting;
import cn.admin.bill.model.UserRuleSetting;
import cn.util.DataConvert;
import cn.util.StringHelper;

/**
 * 分账公式、比例配置
 * @author xiaoxueling
 *
 */
@Service
public class BillRuleService {

	@Autowired
	SqlSession sqlSession;
	@Autowired
	Setting setting;
	@Autowired
	HttpSession httpSession;
	
	/**
	 * 缓存 key:年+"_"+月
	 */
	private static Map<String, BillRule> CACHE_RULE=new ConcurrentHashMap<String,BillRule>();
	
	/**
	 * 获取用户配置
	 * @param year
	 * @param month
	 * @return
	 */
	public  BillRule getBillRule(String year,String month){
		BillRule rule=new BillRule();
		
		try {
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			String key=getCacheKey(year,month);
			if(CACHE_RULE.containsKey(key)) {
				return CACHE_RULE.get(key);
			}
			
			rule=getBillRuleFromDb(year,month);
			
			CACHE_RULE.put(key, rule);
			
		} catch (Exception e) {
			
		}
		return rule;
	}
	
	/**
	 * 保存缓存配置到数据库并清除缓存
	 * @param year 年
	 * @param month 月
	 * @return
	 */
	public boolean saveBillRuleToDb(String year,String month) {
		boolean result=false;
		
		try {
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			BillRule billRule=this.getBillRule(year, month);
			
			result=this.saveBillRuleToDb(year, month, billRule.getRuleSetting(), billRule.getUserRuleSettings());
			
		} catch (Exception e) {
			result=false;
		}
		
		if(result) {
			this.clearCache(year, month);
		}
		return result;
	}
	
	/**
	 *获取专家分成配置
	 * @param year 年
	 * @param month 月
	 * @param userId 专家Id
	 * @return
	 */
	public UserRuleSetting getUserRuleSetting(String year,String month,int userId) {
		
		UserRuleSetting userRuleSetting=null;
		
		try {
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			BillRule billRule=getBillRule(year, month);
			
			List<UserRuleSetting> userRuleSettings=billRule.getUserRuleSettings();
			if(userRuleSettings!=null&&!userRuleSettings.isEmpty()) {
				if(userRuleSettings.stream().anyMatch(f->f.getUserId()==userId)) {
					userRuleSetting=userRuleSettings.stream().filter(f->f.getUserId()==userId).findFirst().get();
				}
			}
		}catch (Exception e) {
			
		}
		if(userRuleSetting==null) {
			userRuleSetting=new UserRuleSetting();
			userRuleSetting.setUserId(userId);
			userRuleSetting.setStatus(1);
			//获取系统默认配置
			RuleSetting ruleSetting=setting.getSetting(RuleSetting.class);
			if(ruleSetting!=null) {
				userRuleSetting.setRewardRate(ruleSetting.getDefaultRewardRate());
				userRuleSetting.setQuestionRate(ruleSetting.getDefaultQuestionRate());
			}
		}
		return userRuleSetting;
	}
	
	/**
	 * 获取专家对应的课程对应的分成配置
	 * @param year 年
	 * @param month 月
	 * @param userId 专家Id
	 * @param ondemandId 课程Id
	 * @return 
	 */
	public OndemandRuleSetting getOndemandRuleSetting(String year,String month,int userId,int ondemandId) {
		OndemandRuleSetting setting=null;
		
		try {
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			//获取专家配置
			UserRuleSetting userRuleSetting=this.getUserRuleSetting(year, month, userId);
			//获取专家对应的课程配置
			List<OndemandRuleSetting> list=userRuleSetting.getOndemandRuleList();
			if(list!=null&&!list.isEmpty()) {
				if(list.stream().anyMatch(f->f.getOndemandId()==ondemandId)) {
					setting=list.stream().filter(f->f.getOndemandId()==ondemandId).findFirst().get();
				}
			}
		} catch (Exception e) {
			
		}
		if(setting==null) {
			setting=new OndemandRuleSetting();
			setting.setOndemandId(ondemandId);
			setting.setStatus(1);
		}
		
		return setting;
	}
	
	/**
	 * 更新计算公式配置
	 * @param year 年
	 * @param month 月
	 * @param setting 计算公式配置
	 * @param saveToDb 是否保存到数据库
	 * @return
	 */
	public boolean changeCalcRuleSetting(String year,String month,CalcRuleSetting setting,boolean saveToDb) {
		boolean result=false;
		try {
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)||setting==null) {
				return result;
			}
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			BillRule rule=getBillRule(year, month);
			if(saveToDb) {
				result=saveBillRuleToDb(year, month, setting,null);
				if(result) {
					rule.setRuleSetting(setting);
				}
			}else {
				rule.setRuleSetting(setting);
				result=true;
			}
			CACHE_RULE.put(getCacheKey(year, month), rule);
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 更新专家分成状态
	 * @param year  年
	 * @param month 月
	 * @param userId 专家Id
	 * @param status 分成状态
	 * @param saveToDb 是否保存到数据库
	 * @return
	 */
	public boolean changeUserRuleSetting(String year,String month,int userId,int status,boolean saveToDb) {
		
		boolean result=false;
		
		try {
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			UserRuleSetting userRuleSetting=this.getUserRuleSetting(year, month, userId);
			userRuleSetting.setStatus(status);
			
			result=this.changeUserRuleSetting(year, month, userRuleSetting, saveToDb);
			
		}catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 *  更新专家分成比例
	 * @param year 年
	 * @param month 月
	 * @param userId 专家Id
	 * @param questionRate 问答分成比例
	 * @param rewardRate 旁听分成比例
	 * @param ondemandRuleSettings  课程分成比例配置
	 * @param saveToDb 是否保存到数据库
	 * @return
	 */
	public boolean changeUserRuleSetting(String year,String month,int userId,Double questionRate,Double rewardRate,List<OndemandRuleSetting> ondemandRuleSettings ,boolean saveToDb) {
		
		boolean result=false;
		
		try {
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			UserRuleSetting userRuleSetting=this.getUserRuleSetting(year, month, userId);
			userRuleSetting.setQuestionRate(questionRate);
			userRuleSetting.setRewardRate(rewardRate);
			userRuleSetting.setOndemandRuleList(ondemandRuleSettings);
			
			result=this.changeUserRuleSetting(year, month, userRuleSetting, saveToDb);
			
		}catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 更新专家分成设置
	 * @param year 年
	 * @param month 月
	 * @param setting 分成设置
	 * @param saveToDb 是否保存到数据库
	 * @return
	 */
	public boolean changeUserRuleSetting(String year,String month,UserRuleSetting setting,boolean saveToDb) {
		
		boolean result=false;
		
		try {
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)||setting==null) {
				return result;
			}
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			BillRule billRule=getBillRule(year, month);
			UserRuleSetting cache_Setting=null;
			List<UserRuleSetting> userRuleSettings=billRule.getUserRuleSettings();
			if(userRuleSettings!=null&&!userRuleSettings.isEmpty()) {
				if(userRuleSettings.stream().anyMatch(m->m.getUserId()==setting.getUserId())) {
					cache_Setting=userRuleSettings.stream().filter(f->f.getUserId()==setting.getUserId()).findFirst().get();
				}
			}
			if(cache_Setting!=null) {
				userRuleSettings.remove(cache_Setting);
			}
			userRuleSettings.add(setting);
			
			result=changeUserRuleSetting(year, month, userRuleSettings, saveToDb);
			
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 更新专家分成设置
	 * @param year 年
	 * @param month 月
	 * @param setting 多个专家的分成设置
	 * @param saveToDb 是否保存到数据库
	 * @return
	 */
	public  boolean changeUserRuleSetting(String year,String month,List<UserRuleSetting>settings,boolean saveToDb) {
		boolean result=false;
		
		try {
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)||settings==null) {
				return result;
			}
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			BillRule rule=getBillRule(year, month);
			if(saveToDb) {
				result=saveBillRuleToDb(year, month, null,settings);
				if(result) {
					rule.setUserRuleSettings(settings);
				}
			}else {
				rule.setUserRuleSettings(settings);
				result=true;
			}
			CACHE_RULE.put(getCacheKey(year, month), rule);
			
		} catch (Exception e) {
			result=false;
		}
		return result;
	}
	
	/**
	 * 清除指定年月缓存
	 * @param year 年
	 * @param month 月
	 */
	public void clearCache(String year,String month) {
		String key=getCacheKey(year, month);
		
		if(CACHE_RULE.containsKey(key)) {
			CACHE_RULE.remove(key);
		}
	}
	
	/**
	 * 获取缓存的key
	 * @param year 年
	 * @param month 月
	 * @return
	 */
	private String getCacheKey(String year,String month) {
		return year+"_"+month;
	}
	
	/**
	 * 从数据库中获取对应的分成设置
	 * @param year 年
	 * @param month 月
	 * @return
	 */
	private BillRule getBillRuleFromDb(String year,String month) {
		BillRule billRule=new BillRule();
		try {
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)) {
				return billRule;
			}
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("year", year);
			paramMap.put("month", month);
			
			//默认配置
			RuleSetting ruleSetting=setting.getSetting(RuleSetting.class);
			//计算公式配置
			CalcRuleSetting calcRuleSetting=ruleSetting;
			//用户分成配置
			List<UserRuleSetting>userRuleSettings=new ArrayList<UserRuleSetting>();
			
			//查找分成配置（对应年月没有数据的则取最近的数据）
			Map<String, Object> ruleMap=sqlSession.selectOne("billDao.selectLastBillRuleByYearAndMonth", paramMap);
			if(ruleMap!=null && !ruleMap.isEmpty()) {
				String ruleJsonStr=DataConvert.ToString(ruleMap.get("rule"));
				if(!StringHelper.IsNullOrEmpty(ruleJsonStr)) {
					calcRuleSetting=DataConvert.jsonStrToObject(ruleJsonStr,CalcRuleSetting.class);
				}
				
				String settingJsonStr=DataConvert.ToString(ruleMap.get("setting"));
				
				if(!StringHelper.IsNullOrEmpty(settingJsonStr)) {
					userRuleSettings=DataConvert.jsonStrToList(settingJsonStr,UserRuleSetting.class);
				}
			}
			
			billRule.setYear(year);
			billRule.setMonth(month);
			billRule.setRuleSetting(calcRuleSetting);
			billRule.setUserRuleSettings(userRuleSettings);

		} catch (Exception e) {
			
		}
		return billRule;
	}	

	/**
	 * 保存配置到数据库
	 * @param year 年
	 * @param month 月
	 * @param ruleSetting 计算公式配置
	 * @param userRuleSetting 用户分成配置
	 * @return
	 */
	private boolean saveBillRuleToDb(String year,String month,CalcRuleSetting calcRuleSetting,List<UserRuleSetting> userRuleSetting) {
		
		boolean flag=false;
		try {
			if(StringHelper.IsNullOrEmpty(year)||StringHelper.IsNullOrEmpty(month)) {
				return flag;
			}
			if(calcRuleSetting==null&&userRuleSetting==null) {
				return flag;
			}
			
			month=StringHelper.PadLeft(month, 2, '0');
			
			Map<String, Object> paramMap=new HashMap<String,Object>();
			paramMap.put("year", year);
			paramMap.put("month", month);
			//查找年月对应的分成
			Map<String, Object> ruleMap=sqlSession.selectOne("billDao.selectBillRuleByYearAndMonth",paramMap);
			if(ruleMap==null) {
				int userId=DataConvert.ToInteger(httpSession.getAttribute("userId"));
				ruleMap=new HashMap<String,Object>();
				ruleMap.put("year",year);
				ruleMap.put("month",month);
				ruleMap.put("userId", userId);
			}
			if(calcRuleSetting!=null) {
				ruleMap.put("rule", DataConvert.objectToJsonStr(calcRuleSetting));
			}
			if(userRuleSetting!=null) {
				ruleMap.put("setting", DataConvert.objectToJsonStr(userRuleSetting));
			}
			
			int ruleId=DataConvert.ToInteger(ruleMap.get("id"));
			if(ruleId>0) {
				flag=sqlSession.update("billDao.updateBillRule", ruleMap)>0;
			}else {
				flag=sqlSession.update("billDao.insertBillRule", ruleMap)>0;
			}
		} catch (Exception e) {
			flag=false;
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		return flag;
	}
}
