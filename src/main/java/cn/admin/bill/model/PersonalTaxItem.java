package cn.admin.bill.model;

import cn.util.StringHelper;

/**
 * 个税计算公式子项
 * 
 * @author xiaoxueling
 *
 */
public class PersonalTaxItem {

	/**
	 * 比较
	 */
	private RelationOperator operator;

	/**
	 * 金额
	 */
	private double money;

	/**
	 * 公式
	 */
	private String formula;

	public RelationOperator getOperator() {
		return operator;
	}

	public void setOperator(RelationOperator operator) {
		this.operator = operator;
	}

	public double getMoney() {
		return money;
	}

	public void setMoney(double money) {
		this.money = money;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}
	
	@Override
	public String toString() {
		return "PersonalTaxItem [operator=" + operator + ", money=" + money + ", formula=" + formula + "]";
	}

	/**
	 * 关系运算符
	 */
	public enum RelationOperator {

		/**
		 * 大于等于
		 */
		GreaterThanEqual("大于等于"),

		/**
		 * 大于
		 */
		GreaterThan("大于"),

		/**
		 * 等于
		 */
		Equal("等于"),

		/**
		 * 小于等于
		 */
		LessThanEqual("小于等于"),

		/**
		 * 小于
		 */
		LessThan("小于");

		String value = "";

		RelationOperator(String value) {
			this.value = value;
		}

		/**
		 * 获取数据
		 * @return
		 */
		public String getValue() {
			return this.value;
		}
	}
}
