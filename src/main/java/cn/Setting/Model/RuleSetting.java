package cn.Setting.Model;

import cn.admin.bill.model.CalcRuleSetting;

/**
 * 参数设置--分成规则
 * 
 * @author xiaoxueling
 *
 */
public class RuleSetting extends CalcRuleSetting {

	/**
	 * 打赏分成默认比例
	 */
	private Double defaultRewardRate;

	/**
	 * 问答分成默认比例
	 */
	private Double defaultQuestionRate;

	public Double getDefaultRewardRate() {
		return defaultRewardRate;
	}

	public void setDefaultRewardRate(Double defaultRewardRate) {
		this.defaultRewardRate = defaultRewardRate;
	}

	public Double getDefaultQuestionRate() {
		return defaultQuestionRate;
	}

	public void setDefaultQuestionRate(Double defaultQuestionRate) {
		this.defaultQuestionRate = defaultQuestionRate;
	}
}
