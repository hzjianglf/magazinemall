package cn.admin.system.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cn.Setting.Setting;
import cn.Setting.Model.RuleSetting;
import cn.Setting.Model.SearchSetting;
import cn.admin.bill.model.PersonalTaxItem;
import cn.admin.bill.model.PersonalTaxItem.RelationOperator;
import cn.util.DataConvert;
import cn.util.StringHelper;

/**
 * 参数设置
 * @author Administrator
 *
 */
@Controller
@RequestMapping(value="/admin/parameter")
public class ParameterSettingController {

	
	@Autowired
	Setting setting;
	
	
	/**
	 * 获取参数配置信息
	 * @return
	 */
	@RequestMapping(value="/setIndex")
	public ModelAndView setIndex(@RequestParam Map<String, Object> map){
		
		//分成规则
		RuleSetting ruleSetting = setting.getSetting(RuleSetting.class);
		map.put("ruleSetting", ruleSetting);
		
		//热搜词设置
		SearchSetting searchSetting = setting.getSetting(SearchSetting.class);
		List<String> words = searchSetting.getHotSearchWords();
		String hotWords = StringHelper.Join(",", words.toArray());
		map.put("hotWords", hotWords);
		
		return new ModelAndView("/admin/system/parameter/setIndex",map);
	}
	
	/**
	 * 保存规则配置
	 */
	@RequestMapping(value="/setRule")
	@ResponseBody
	public Map<String, Object> setRule(RuleSetting ruleSetting,@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>(){
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};
		
		List<PersonalTaxItem> personalTaxList =new ArrayList<PersonalTaxItem>();
		
		for(Map.Entry<String, Object> item : map.entrySet()) {
			
			String key=item.getKey();
			if(key.startsWith("operator_")) {
				
				int index=DataConvert.ToInteger(key.replace("operator_",""));
				
				//比较
				RelationOperator operator = null;
				String ro =DataConvert.ToString(item.getValue());
				switch (ro) {
					case "大于等于":
						operator = RelationOperator.GreaterThanEqual;
						break;
					case "大于":
						operator = RelationOperator.GreaterThan;
						break;
					case "等于":
						operator = RelationOperator.Equal;
						break;
					case "小于等于":
						operator = RelationOperator.LessThanEqual;
						break;
					case "小于":
						operator = RelationOperator.LessThan;
						break;
					default:
						operator = RelationOperator.GreaterThanEqual;
						break;
				}
				//金额
				double money = DataConvert.ToDouble(map.get("money_"+index+""));
				//公式
				String formula = DataConvert.ToString(map.get("formula_"+index+""));
				
				PersonalTaxItem personalTaxItem=new PersonalTaxItem();
				personalTaxItem.setOperator(operator);
				personalTaxItem.setMoney(money);
				personalTaxItem.setFormula(formula);
				
				personalTaxList.add(personalTaxItem);
			}
			
		}
		
		ruleSetting.setPersonalTaxList(personalTaxList);
		
		boolean result = setting.setSetting(ruleSetting);
		if(result) {
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功！");
		}
		
		return reqMap;
	}
	
	/**
	 * 保存热搜词设置
	 */
	@RequestMapping(value="/setSearch")
	@ResponseBody
	public Map<String, Object> setSearch(@RequestParam Map<String, Object> map){
		Map<String, Object> reqMap = new HashMap<String,Object>(){
			{
				put("success", false);
				put("msg", "保存失败");
			}
		};
		
		String hotWards = DataConvert.ToString(map.get("hotWords"));
		String[] arr = hotWards.split(",");
		List<String> hotSearchWords=new ArrayList<String>();
		for (String string : arr) {
			hotSearchWords.add(string);
		}
		SearchSetting searchSetting=new SearchSetting();
		searchSetting.setHotSearchWords(hotSearchWords);
		
		boolean result = setting.setSetting(searchSetting);
		if(result) {
			reqMap.put("success", true);
			reqMap.put("msg", "保存成功！");
		}
		
		return reqMap;
	}
}
