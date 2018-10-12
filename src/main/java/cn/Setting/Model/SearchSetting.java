package cn.Setting.Model;

import java.util.ArrayList;
import java.util.List;

/**
 * 参数设置--搜索设置
 * @author xiaoxueling
 *
 */
public class SearchSetting {

	public SearchSetting() {
		hotSearchWords=new ArrayList<String>();
	}
	
	/**
	 * 热搜词
	 */
	private List<String> hotSearchWords;

	public List<String> getHotSearchWords() {
		return hotSearchWords;
	}

	public void setHotSearchWords(List<String> hotSearchWords) {
		this.hotSearchWords = hotSearchWords;
	}
}
