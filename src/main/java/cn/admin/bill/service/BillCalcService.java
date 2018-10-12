package cn.admin.bill.service;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.script.Bindings;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;

import org.springframework.stereotype.Service;

import cn.admin.bill.model.CalcRuleSetting;
import cn.admin.bill.model.PersonalTaxItem;
import cn.util.DataConvert;
import cn.util.StringHelper;

/**
 * 分成规则动态计算
 * @author xiaoxueling
 *
 */
@Service
public class BillCalcService {
	
	/**
	 *计算类型
	 */
	public static enum BILL_CALC_TYPE{
		
		/**
		 * 课销收入
		 */
		ONDEMAND_SALES_INCOME("课销收入"),
		
		/**
		 * 课销营业税
		 */
		ONDEMAND_SALES_TAX("课销营业税"),
		
		/**
		 * 课销分成
		 */
		ONDEMAND_SALES_SEPARATE("课销分成"),
		
		/**
		 * 问答收入
		 */
		QUESTION_SALES_INCOME("问答收入"),
		
		/**
		 * 问答营业税
		 */
		QUESTION_SALES_TAX("问答营业税"),
		
		/**
		 * 问答分成
		 */
		QUESTION_SALES_SEPARATE("问答分成"),
		
		/**
		 * 打赏收入
		 */
		REWARD_SALES_INCOME("打赏收入"),
		
		/**
		 * 打赏营业税
		 */
		REWARD_SALES_TAX("打赏营业税"),
		
		/**
		 * 打赏分成
		 */
		REWARD_SALES_SEPARATE("打赏分成"),
		
		/**
		 *  个税
		 */
		PERSIONAL_TAX("个税"),
		
		/**
		 * 应发总金额
		 */
		SHOULD_PAYMENT("应发总金额"),
		
		/**
		 * 实发总金额
		 */
		ACTUAL_PAYMENT("实发总金额");
		
		String value="";
		BILL_CALC_TYPE(String value){
			this.value=value;
		}
		
		public String getValue() {
			return this.value;
		}
	}
	
	/**
	 * 分成规则可用变量
	 * @author xiaoxueling
	 *
	 */
	public  static enum BILL_CALC_RULE_VARS{
	
		/**
		 * 购买类型代金券金额
		 */
		CASH_COUPON_MONEY("购买类型代金券金额"),
		/**
		 * 课销订单实际支付金额
		 */
		ONDEMAND_PAY_MONEY("课销订单实际支付金额"),
		/**
		 * 课销收入
		 */
		ONDEMAND_SALES_INCOME("课销收入"),
		/**
		 * 课销营业税
		 */
		ONDEMAND_SALES_TAX("课销增值税"),
		/**
		 * 总课销分成
		 */
		ONDEMAND_SALES_TOTAL_SEPARATE("总课销分成"),
		/**
		 * 课销分成比例
		 */
		ONDEMAND_SALES_RATE("课销分成比例"),
		/**
		 * 问答订单实际支付金额
		 */
		QUESTION_PAY_MONEY("问答订单实际支付金额"),
		/**
		 * 问答收入
		 */
		QUESTION_SALES_INCOME("问答收入"),
		/**
		 * 问答营业税
		 */
		QUESTION_SALES_TAX("问答增值税"),
		/**
		 * 问答分成比例
		 */
		QUESTION_SALES_RATE("问答分成比例"),
		/**
		 * 总问答分成
		 */
		QUESTION_SALES_TOTAL_SEPARATE("总问答分成"),
		/**
		 * 打赏订单实际支付金额
		 */
		REWARD_PAY_MONEY("打赏订单实际支付金额"),
		/**
		 * 打赏收入
		 */
		REWARD_SALES_INCOME("打赏收入"),
		/**
		 * 打赏营业税
		 */
		REWARD_SALES_TAX("打赏增值税"),
		/**
		 * 打赏分成比例
		 */
		REWARD_SALES_RATE("打赏分成比例"),
		/**
		 * 总打赏分成
		 */
		REWARD_SALES_TOTAL_SEPARATE("总打赏分成"),
		/**
		 *  个税金额
		 */
		PERSIONAL_TAX_MONEY("个税金额"),
		/**
		 * 应发总金额
		 */
		SHOULD_PAYMENT_MONEY("应发总金额"),
		/**
		 * 实发总金额
		 */
		ACTUAL_PAYMENT_MONEY("实发总金额");
		
		String value="";
		BILL_CALC_RULE_VARS(String value){
			this.value=value;
		}
		
		public String getValue() {
			return this.value;
		}
		
	}
	
	private static final ScriptEngine jse = new ScriptEngineManager().getEngineByName("JavaScript"); 

	
	/**
	 * 根据配置的计算公式获取数据
	 * @param type 计算类型
	 * @param setting 计算公式配置
	 * @param dataMap 数据
	 * @return
	 * @throws Exception 
	 */
	public double getBillCalcTypeValue(BILL_CALC_TYPE type,CalcRuleSetting setting,Map<String, Object> dataMap) throws Exception {
		return this.getBillCalcTypeValue(type, setting, 0d, dataMap);
	}
	
	/**
	 * 根据配置的计算公式获取数据
	 * @param type 计算类型
	 * @param setting 计算公式配置
	 * @param rate 分成比例 (课程、问答、打赏)
	 * @param dataMap 数据
	 * @return
	 * @throws Exception 
	 */
	public double getBillCalcTypeValue(BILL_CALC_TYPE type,CalcRuleSetting setting,double rate,Map<String, Object> dataMap) throws Exception {
		
		double value=0d;
		try {
			if(setting==null) {
				throw new Exception("获取分成设置失败！");
			}
			
			if(dataMap==null) {
				throw new Exception(type.getValue()+"计算失败！");
			}
			
			/**
			 * 动态计算用的参数数据
			 */
			Map<BILL_CALC_RULE_VARS, Double> calcDataMap=new HashMap<BILL_CALC_RULE_VARS, Double>();
			
			/**
			 * 根据计算类型获取参数数据
			 */
			switch (type) {
				case ONDEMAND_SALES_INCOME:
				case ONDEMAND_SALES_TAX:
				case ONDEMAND_SALES_SEPARATE:
					
					//订单支付金额
					double ondemandPayMoney=DataConvert.ToDouble(dataMap.get("payMoney"));
					double cashCouponMoney=0d;
					calcDataMap.put(BILL_CALC_RULE_VARS.ONDEMAND_PAY_MONEY, ondemandPayMoney);
					calcDataMap.put(BILL_CALC_RULE_VARS.CASH_COUPON_MONEY, cashCouponMoney);
					calcDataMap.put(BILL_CALC_RULE_VARS.ONDEMAND_SALES_RATE, rate*0.01);
					
					//课销收入
					double ondemandSalesIncome=DataConvert.ToDouble(dataMap.get(BILL_CALC_RULE_VARS.ONDEMAND_SALES_INCOME.getValue()));
					calcDataMap.put(BILL_CALC_RULE_VARS.ONDEMAND_SALES_INCOME,ondemandSalesIncome);
					
					//课销营业税
					double ondemandSalesTax=DataConvert.ToDouble(dataMap.get(BILL_CALC_RULE_VARS.ONDEMAND_SALES_TAX.getValue()));
					calcDataMap.put(BILL_CALC_RULE_VARS.ONDEMAND_SALES_TAX,ondemandSalesTax);
					
					break;
				case QUESTION_SALES_INCOME:
				case QUESTION_SALES_TAX:
				case QUESTION_SALES_SEPARATE:
					
					//问答支付金额
					double questionPayMoney=DataConvert.ToDouble(dataMap.get("payMoney"));
					calcDataMap.put(BILL_CALC_RULE_VARS.QUESTION_PAY_MONEY, questionPayMoney);
					calcDataMap.put(BILL_CALC_RULE_VARS.QUESTION_SALES_RATE, rate*0.01);
					
					//问答收入
					double questionSalesIncome=DataConvert.ToDouble(dataMap.get(BILL_CALC_RULE_VARS.QUESTION_SALES_INCOME.getValue()));
					calcDataMap.put(BILL_CALC_RULE_VARS.QUESTION_SALES_INCOME,questionSalesIncome);
					
					//问答营业税
					double questionSalesTax=DataConvert.ToDouble(dataMap.get(BILL_CALC_RULE_VARS.QUESTION_SALES_TAX.getValue()));
					calcDataMap.put(BILL_CALC_RULE_VARS.QUESTION_SALES_TAX,questionSalesTax);
					
					break;
				case REWARD_SALES_INCOME:
				case REWARD_SALES_TAX:
				case REWARD_SALES_SEPARATE:
					
					//打赏支付金额
					double rewardPayMoney=DataConvert.ToDouble(dataMap.get("payMoney"));
					calcDataMap.put(BILL_CALC_RULE_VARS.REWARD_PAY_MONEY, rewardPayMoney);
					calcDataMap.put(BILL_CALC_RULE_VARS.REWARD_SALES_RATE, rate*0.01);
					
					//打赏收入
					double rewardSalesIncome=DataConvert.ToDouble(dataMap.get(BILL_CALC_RULE_VARS.REWARD_SALES_INCOME.getValue()));
					calcDataMap.put(BILL_CALC_RULE_VARS.REWARD_SALES_INCOME,rewardSalesIncome);
					
					//打赏营业税
					double rewardSalesTax=DataConvert.ToDouble(dataMap.get(BILL_CALC_RULE_VARS.REWARD_SALES_TAX.getValue()));
					calcDataMap.put(BILL_CALC_RULE_VARS.REWARD_SALES_TAX,rewardSalesTax);
					
					break;
					
				case SHOULD_PAYMENT:
				case PERSIONAL_TAX:
				case ACTUAL_PAYMENT:
					
					//分成金额
					double ondemandMoney=DataConvert.ToDouble(dataMap.get("ondemandMoney"));
					double questionMoney=DataConvert.ToDouble(dataMap.get("questionMoney"));
					double rewardMoney=DataConvert.ToDouble(dataMap.get("rewardMoney"));
					
					calcDataMap.put(BILL_CALC_RULE_VARS.ONDEMAND_SALES_TOTAL_SEPARATE,ondemandMoney);
					calcDataMap.put(BILL_CALC_RULE_VARS.QUESTION_SALES_TOTAL_SEPARATE,questionMoney);
					calcDataMap.put(BILL_CALC_RULE_VARS.REWARD_SALES_TOTAL_SEPARATE,rewardMoney);
					
					//应发金额
					double shouldMoney=DataConvert.ToDouble(dataMap.get("shouldMoney"));
					calcDataMap.put(BILL_CALC_RULE_VARS.SHOULD_PAYMENT_MONEY,shouldMoney);
					
					//个人所得税
					double personalTax=DataConvert.ToDouble(dataMap.get("personalTax"));
					calcDataMap.put(BILL_CALC_RULE_VARS.PERSIONAL_TAX_MONEY,personalTax);
					
					break;
			}
			
			value=this.getValueByBillCalc(type,setting,calcDataMap);
			
			if(value<0){
				value=0d;
			}
		} catch (Exception e) {
			throw e;
		}
		return value;
	}
	
	/**
	 * 按照公式进行计算
	 * @param type 计算类型
	 * @param CalcRuleSetting 分成规则
	 * @param payMoney  课销订单实际支付金额
	 * @param cashCouponMoney 购买类型代金券金额
	 * @return
	 * @throws Exception 
	 */
	private double getValueByBillCalc(BILL_CALC_TYPE type,CalcRuleSetting setting,Map<BILL_CALC_RULE_VARS, Double> dataMap) throws Exception {
		
		double value=0d;
		try {
			
			if(type==null) {
				return value;
			}
			
			//计算公式
			String  calcStr="";
			
			/**
			 * 根据计算类型获取对应的计算公式
			 */
			switch (type) {
				case ONDEMAND_SALES_INCOME:
					calcStr=setting.getOndemandSalesIncome();
					break;
				case ONDEMAND_SALES_TAX:
					calcStr=setting.getOndemandSalesTax();
					break;
				case ONDEMAND_SALES_SEPARATE:
					calcStr=setting.getOndemandSalesSeparate();
					break;
				case QUESTION_SALES_INCOME:
					calcStr=setting.getQuestionSalesIncome();
					break;
				case QUESTION_SALES_TAX:
					calcStr=setting.getQuestionSalesTax();	
					break;
				case QUESTION_SALES_SEPARATE:
					calcStr=setting.getQuestionSalesSeparate();
					break;
				case REWARD_SALES_INCOME:
					calcStr=setting.getRewardSalesIncome();
					break;
				case REWARD_SALES_TAX:
					calcStr=setting.getRewardSalesTax();
					break;
				case REWARD_SALES_SEPARATE:
					calcStr=setting.getRewardSalesSeparate();
					break;
				case ACTUAL_PAYMENT:
					calcStr=setting.getActualPayment();
					break;
				case PERSIONAL_TAX:
					List<PersonalTaxItem> list=setting.getPersonalTaxList();
					
					if(list!=null&&!list.isEmpty()) {
						//获取应发总金额
						double shouldPayMoney=dataMap.get(BILL_CALC_RULE_VARS.SHOULD_PAYMENT_MONEY);
						
						for (PersonalTaxItem item : list) {
							
							double money=item.getMoney();
							
							switch (item.getOperator()) {
								case GreaterThanEqual:
									
									if(shouldPayMoney>=money) {
										calcStr=item.getFormula();
									}
									break;
								case GreaterThan:
									if(shouldPayMoney>money) {
										calcStr=item.getFormula();
									}							
									break;
								case Equal:
									if(shouldPayMoney==money) {
										calcStr=item.getFormula();
									}
									break;
								case LessThanEqual:
									if(shouldPayMoney<=money) {
										calcStr=item.getFormula();
									}
									break;
								case LessThan:
									if(shouldPayMoney<money) {
										calcStr=item.getFormula();
									}
									break;
							}
							
							if(!StringHelper.IsNullOrEmpty(calcStr)) {
								break;
							}
						}
						
						if(StringHelper.IsNullOrEmpty(calcStr)) {
							throw new Exception("分成规则-未找到匹配的个税计算公式！");
						}
					}
					break;
				case SHOULD_PAYMENT:
					calcStr=setting.getShouldPayment();
					break;
			}
			
			if(StringHelper.IsNullOrEmpty(calcStr)) {
				throw new Exception("分成规则-"+type.getValue()+"公式不能为空！");
			}
			
			Bindings bindings=jse.createBindings();
			
			for(Map.Entry<BILL_CALC_RULE_VARS,Double>item : dataMap.entrySet()){
				bindings.put(item.getKey().getValue(), item.getValue());
			}
			
			Object v=jse.eval(calcStr,bindings);
			
			double errorV=-10d;
			value=DataConvert.ToDouble(v,errorV);
			if(value==errorV) {
				throw new Exception("分成规则-"+type.getValue()+"公式配置错误！");
			}
			
			value=new BigDecimal(value).setScale(2, BigDecimal.ROUND_DOWN).doubleValue();
			
		} catch (Exception e) {
			throw new Exception("分成规则-"+type.getValue()+"公式配置错误！");
		}
		return value;
	}
}
