package cn.admin.bill.model;

import java.util.ArrayList;
import java.util.List;

/**
 * 每月对应的分配公式设置
 * 
 * @author xiaoxueling
 *
 */
public class CalcRuleSetting {

	public CalcRuleSetting() {
		personalTaxList = new ArrayList<PersonalTaxItem>();
	}

	/**
	 * 课销收入计算公式
	 */
	private String ondemandSalesIncome;

	/**
	 * 问答收入计算公式
	 */
	private String questionSalesIncome;

	/**
	 * 打赏收入计算公式
	 */
	private String rewardSalesIncome;

	/**
	 * 课销营业税计算公式
	 */
	private String ondemandSalesTax;

	/**
	 * 问答营业税计算公式
	 */
	private String questionSalesTax;

	/**
	 * 打赏营业税计算公式
	 */
	private String rewardSalesTax;
	
	/**
	 * 课销分成计算公式
	 */
	private String ondemandSalesSeparate;

	/**
	 * 问答分成计算公式
	 */
	private String questionSalesSeparate;

	/**
	 * 打赏分成计算公式
	 */
	private String rewardSalesSeparate;
	
	
	/**
	 * 个税计算公式
	 */
	private List<PersonalTaxItem> personalTaxList;

	/**
	 * 应发总金额公式
	 */
	private String shouldPayment;

	/**
	 * 实发总金额公式
	 */
	private String actualPayment;
	
	public String getOndemandSalesIncome() {
		return ondemandSalesIncome;
	}

	public void setOndemandSalesIncome(String ondemandSalesIncome) {
		this.ondemandSalesIncome = ondemandSalesIncome;
	}

	public String getQuestionSalesIncome() {
		return questionSalesIncome;
	}

	public void setQuestionSalesIncome(String questionSalesIncome) {
		this.questionSalesIncome = questionSalesIncome;
	}

	public String getRewardSalesIncome() {
		return rewardSalesIncome;
	}

	public void setRewardSalesIncome(String rewardSalesIncome) {
		this.rewardSalesIncome = rewardSalesIncome;
	}

	public String getOndemandSalesTax() {
		return ondemandSalesTax;
	}

	public void setOndemandSalesTax(String ondemandSalesTax) {
		this.ondemandSalesTax = ondemandSalesTax;
	}

	public String getQuestionSalesTax() {
		return questionSalesTax;
	}

	public void setQuestionSalesTax(String questionSalesTax) {
		this.questionSalesTax = questionSalesTax;
	}

	public String getRewardSalesTax() {
		return rewardSalesTax;
	}

	public void setRewardSalesTax(String rewardSalesTax) {
		this.rewardSalesTax = rewardSalesTax;
	}

	public String getOndemandSalesSeparate() {
		return ondemandSalesSeparate;
	}

	public void setOndemandSalesSeparate(String ondemandSalesSeparate) {
		this.ondemandSalesSeparate = ondemandSalesSeparate;
	}

	public String getQuestionSalesSeparate() {
		return questionSalesSeparate;
	}

	public void setQuestionSalesSeparate(String questionSalesSeparate) {
		this.questionSalesSeparate = questionSalesSeparate;
	}

	public String getRewardSalesSeparate() {
		return rewardSalesSeparate;
	}

	public void setRewardSalesSeparate(String rewardSalesSeparate) {
		this.rewardSalesSeparate = rewardSalesSeparate;
	}

	public List<PersonalTaxItem> getPersonalTaxList() {
		return personalTaxList;
	}

	public void setPersonalTaxList(List<PersonalTaxItem> personalTaxList) {
		this.personalTaxList = personalTaxList;
	}

	public String getShouldPayment() {
		return shouldPayment;
	}

	public void setShouldPayment(String shouldPayment) {
		this.shouldPayment = shouldPayment;
	}

	public String getActualPayment() {
		return actualPayment;
	}

	public void setActualPayment(String actualPayment) {
		this.actualPayment = actualPayment;
	}

	@Override
	public String toString() {
		return "CalcRuleSetting [ondemandSalesIncome=" + ondemandSalesIncome + ", questionSalesIncome="
				+ questionSalesIncome + ", rewardSalesIncome=" + rewardSalesIncome + ", ondemandSelesTax="
				+ ondemandSalesTax + ", questionSelesTax=" + questionSalesTax + ", rewardSelesTax=" + rewardSalesTax
				+ ", personalTaxList=" + personalTaxList + ", shouldPayment=" + shouldPayment + ", actualPayment="
				+ actualPayment + "]";
	}
	
}