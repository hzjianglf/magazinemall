package cn.admin.statistic.controller;

import java.util.Map;

import cn.util.DataConvert;

/**
 * 状态 -数字 转 状态-汉字
 * @author Administrator
 *
 */
public class StateValueTransfer {
	public static String orderType(String ordertype,Map map2) {
		switch(DataConvert.ToInteger(map2.get("ordertype"))) {
		case 1:
			ordertype="期刊";
			break;
		case 2:
			ordertype="课程";
			break;
		case 3:
			ordertype="问答";
			break;
		case 4:
			ordertype="打赏";
			break;	
		case 6:
			ordertype="电子书";
		break;	
	}
		return ordertype;
	}
	public static String orderType1(String ordertype,Map map2) {
		if(DataConvert.ToInteger(map2.get("source"))==1){
			if(DataConvert.ToInteger(map2.get("ordertype"))==2) {
				ordertype="期刊";
			}else if(DataConvert.ToInteger(map2.get("ordertype"))==4 || DataConvert.ToInteger(map2.get("ordertype"))==8) {
				ordertype="课程";
			}
		}else if(DataConvert.ToInteger(map2.get("source"))==3 || DataConvert.ToInteger(map2.get("source"))==4){
			ordertype="问答";
		}else if(DataConvert.ToInteger(map2.get("source"))==5){
			ordertype="打赏";
		}
		return ordertype;
	}
	public static String productType(String producttype,Map map2) {
		switch(DataConvert.ToInteger(map2.get("producttype"))) {
		case 1:
			producttype="实物";
			break;
		case 2:
			producttype="期刊";
			break;
		case 4:
			producttype="点播";
			break;
		case 8:
			producttype="直播";
			break;	
		case 16:
			producttype="电子书";
			break;
		}
		return producttype;
	}
	
	public static String deliverstatus(String deliverstatus,Map map2) {
		switch(DataConvert.ToInteger(map2.get("deliverstatus"))) {
		case 0:
			deliverstatus="未发货";
			break;
		case 1:
			deliverstatus="已发货";
			break;
		case 2:
			deliverstatus="部分发货";
			break;
		case 3:
			deliverstatus="已完成";
			break;
		}
		return deliverstatus;
	}
	//是否赠品
	public static String subType(String subType,Map map2) {
		if(DataConvert.ToInteger(map2.get("subType"))==5) 
			subType="是";
		else 
			subType="";
		return subType;
	}
	
} 
