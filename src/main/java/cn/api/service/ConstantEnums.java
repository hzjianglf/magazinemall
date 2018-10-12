package cn.api.service;

import cn.util.DataConvert;

/**
 * 枚举常量
 * @author Administrator
 *
 */
public class ConstantEnums {

	/**
	 * 订单状态
	 * @author Administrator
	 *
	 */
	public static enum ORDER_STATUS{
		/**
		 * 待支付/新订单
		 */
		WAITPAY(1,"待支付"),
		/**
		 * 已支付/代发货
		 */
		PAID(2,"已支付"),
		/**
		 * 已发货/待收货
		 */
		SHIPPED(3,"已发货"),
		/**
		 * 已收货/待评价
		 */
		RECEIVED(4,"已收货"),
		/**
		 * 已完成
		 */
		FINISH(5,"已完成"),
		/**
		 * 已取消
		 */
		CANC(6,"已取消"),
		/**
		 * 退款中
		 */
		REFUND(7,"退款中");
		
		
		int status=0;
		String name="";
		
		ORDER_STATUS(int status,String name){
			this.status=status;
			this.name=name;
		}
		
		/**
		 * 获取对应的值数据
		 * @return
		 */
		public int value(){
			return this.status;
		}
		
		@Override
		public String toString(){
			return this.name;
		}
	}

}


