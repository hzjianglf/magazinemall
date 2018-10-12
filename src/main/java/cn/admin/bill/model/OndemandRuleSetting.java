package cn.admin.bill.model;

/**
 * 课程对应的规则
 * @author xiaoxueling
 *
 */
public class OndemandRuleSetting {
	
	/**
	 * 课程Id
	 */
	private int ondemandId;
	
	/**
	 * 分成比例
	 */
	private Double rate;
	
	/**
	 * 分成状态 0--启用 1--禁用
	 */
	private int status;

	public int getOndemandId() {
		return ondemandId;
	}

	public void setOndemandId(int ondemandId) {
		this.ondemandId = ondemandId;
	}

	public Double getRate() {
		return rate;
	}

	public void setRate(Double rate) {
		this.rate = rate;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
}
