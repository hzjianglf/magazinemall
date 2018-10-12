package cn.admin.bill.model;

import java.util.ArrayList;
import java.util.List;

import cn.util.JsonProperty;
import cn.util.JsonProperty.JsonPropertyType;

/**
 * 专家对应的分账设置
 * @author xiaoxueling
 *
 */
public class UserRuleSetting {

	public UserRuleSetting() {
		ondemandRuleList=new ArrayList<OndemandRuleSetting>();
	}
	
	/**
	 * 专家用户Id
	 */
	private  int userId;
	
	/**
	 * 打赏分成比例
	 */
	private Double rewardRate;

	/**
	 * 问答分成比例
	 */
	private Double questionRate;
	
	/**
	 * 分成状态 0--禁用 1--启用
	 */
	private int status;
	
	/**
	 * 课程对应的分成配置
	 */
	@JsonProperty(JsonPropertyType=JsonPropertyType.JsonList,cls=OndemandRuleSetting.class)
	private List<OndemandRuleSetting> ondemandRuleList;

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public Double getRewardRate() {
		return rewardRate;
	}

	public void setRewardRate(Double rewardRate) {
		this.rewardRate = rewardRate;
	}

	public Double getQuestionRate() {
		return questionRate;
	}

	public void setQuestionRate(Double questionRate) {
		this.questionRate = questionRate;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int statue) {
		status = statue;
	}

	public List<OndemandRuleSetting> getOndemandRuleList() {
		return ondemandRuleList;
	}

	public void setOndemandRuleList(List<OndemandRuleSetting> ondemandRuleList) {
		this.ondemandRuleList = ondemandRuleList;
	}

	@Override
	public String toString() {
		return "UserRuleSetting [userId=" + userId + ", rewardRate="
				+ rewardRate + ", questionRate=" + questionRate + ", status="
				+ status + ", ondemandRuleList=" + ondemandRuleList + "]";
	}
}
