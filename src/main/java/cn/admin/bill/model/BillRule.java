package cn.admin.bill.model;

import java.util.ArrayList;
import java.util.List;

import cn.util.JsonProperty;
import cn.util.JsonProperty.JsonPropertyType;

/**
 * 分配规则
 * @author xiaoxueling
 *
 */
public class BillRule {

	public BillRule() {
		userRuleSettings=new ArrayList<UserRuleSetting>();
	}
	
	/**
	 * 年
	 */
	private String year;
	
	/**
	 * 月
	 */
	private String month;
	
	/**
	 * 计算公式配置
	 */
	private CalcRuleSetting ruleSetting;
	
	/**
	 * 用户分成比例设置
	 */
	@JsonProperty(JsonPropertyType=JsonPropertyType.JsonList,cls=UserRuleSetting.class)
	private List<UserRuleSetting> userRuleSettings;

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getMonth() {
		return month;
	}

	public void setMonth(String month) {
		this.month = month;
	}

	public CalcRuleSetting getRuleSetting() {
		return ruleSetting;
	}

	public void setRuleSetting(CalcRuleSetting ruleSetting) {
		this.ruleSetting = ruleSetting;
	}

	public List<UserRuleSetting> getUserRuleSettings() {
		return userRuleSettings;
	}

	public void setUserRuleSettings(List<UserRuleSetting> userRuleSettings) {
		this.userRuleSettings = userRuleSettings;
	}
}
