package cn.admin.system.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import cn.util.MapCache;
import cn.util.NumberUtil;
import cn.util.RegexUntil;

@Service
public class DictionaryService {

	@Autowired
	SqlSessionFactory sqlsessionfactory;
	@Autowired
	SqlSession sqlsession;

	/**
	 * 查询数据字典
	 */
	public List<Map<String, Object>> selectDictionary(Map<String, Object> map) {
		List<Map<String, Object>> list = sqlsession.selectList("DictionaryDao.selectDictionary", map);
		return list;
	}

	public long getTotalCount(Map<String, Object> selDic) {
		return sqlsession.selectOne("DictionaryDao.countDic", selDic);
	}

	/**
	 * 查询数据字典详细信息
	 */
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectDictionaryInfo(int dictId) {
		// 先判断缓存中是否存在
		MapCache.getInstance();
		List<Map<String, Object>> list = (List<Map<String, Object>>) MapCache.getCache(dictId + "");
		if (StringUtils.isEmpty(list)) {
			list = sqlsession.selectList("DictionaryDao.selectDictionaryInfo", dictId);
			MapCache.putCache(dictId + "", list);
		} else {
			list = sqlsession.selectList("DictionaryDao.selectDictionaryInfo", dictId);
			MapCache.putCache(dictId + "", list);
		}
		return list;
	}

	public long selectDictionaryInfoCount(int dictId) {
		return sqlsession.selectOne("DictionaryDao.selectDictionaryInfoCount", dictId);
	}

	@SuppressWarnings("unchecked")
	public LinkedHashMap<Integer, String> selectDictionaryMap(int dictId) {
		MapCache.getInstance();
		LinkedHashMap<Integer, String> item = (LinkedHashMap<Integer, String>) MapCache.getCache(dictId + "_map");
		if (item == null) {
			List<Map<String, Object>> maps = selectDictionaryInfo(dictId);
			item = new LinkedHashMap<Integer, String>();
			for (Map<String, Object> m : maps) {
				item.put(Integer.parseInt(m.get("itemValue").toString()), m.get("itemName").toString());
			}
			MapCache.putCache(dictId + "_map", item);
		}
		return item;
	}

	/**
	 * 
	 * @Description: 修改 数据字典
	 */
	public int updateDict(Map<String, Object> map) {
		return sqlsession.update("DictionaryDao.updateDictionary", map);
	}

	/**
	 * 添加数据字典
	 */
	public int addDict(Map<String, Object> map) {
		return sqlsession.insert("DictionaryDao.insertDictionary", map);
	}

	/**
	 * 通过ID查询数据字典 用于数据自带的修改
	 */

	public Map<String, Object> selectDictionaryById(int dictId) {
		return sqlsession.selectOne("DictionaryDao.selectDictionaryById", dictId);
	}

	/**
	 * 删除数据字典
	 */

	public int delteDict(int dictId) {
		return sqlsession.delete("DictionaryDao.delDictionary", dictId);
	}

	/**
	 * 修改数据字典详情
	 */

	public Map<String, Object> updateDictInfo(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		int row = sqlsession.update("DictionaryDao.updateDictionaryInfo", map);
		if (row > 0) {
			int dictId = Integer.parseInt((String) map.get("dictId"));
			this.selectDictionaryInfo(dictId);
			result.put("success", true);
			result.put("msg", "修改成功");
		} else {
			result.put("success", false);
			result.put("msg", "修改失败");
		}
		return result;
	}

	/**
	 * 添加数据字典详情
	 */

	public Map<String, Object> addDictInfo(Map<String, Object> map) {
		Map<String, Object> result = new HashMap<String, Object>();
		int row = sqlsession.insert("DictionaryDao.addDictionaryInfo", map);
		if (row > 0) {
			int dictId = Integer.parseInt((String) map.get("dictId"));
			this.selectDictionaryInfo(dictId);
			result.put("success", true);
			result.put("msg", "添加成功");
		} else {
			result.put("success", false);
			result.put("msg", "添加失败");
		}
		return result;
	}

	/**
	 * 删除数据字典详情
	 */

	public List<Map<String, Object>> delteDictInfo(Map<String, Object> maps) {
		int itemId = Integer.parseInt((String) maps.get("itemId"));
		int dictId = Integer.parseInt((String) maps.get("dictId"));
		sqlsession.insert("DictionaryDao.delDictionaryInfo", itemId);

		return this.selectDictionaryInfo(dictId);
	}

	/**
	 * 查询数据字典详情，用于修改
	 */
	public Map<String, Object> selectDictionaryInfoByItemId(int dictInfoId) {
		Map<String, Object> list = sqlsession.selectOne("DictionaryDao.selectDictionaryInfoByItemId", dictInfoId);
		return list;
	}

	/**
	 * 数据字典验证
	 */
	public Map<String, Object> DictValidate(Map<String, Object> map, Map<String, Object> msg) {
		boolean flage = true;
		String dictionaryName = map.get("dictionaryName").toString();
		if (!RegexUntil.isNull(dictionaryName)) {
			msg.put("dictNameMsg", "字典名称不能为空");
			flage = false;
		}
		msg.put("flage", flage);
		return msg;
	}

	/**
	 * 数据字典详情验证
	 */
	public Map<String, Object> DictInfoValidate(Map<String, Object> map, Map<String, Object> msg) {
		boolean flage = true;
		String itemName = map.get("itemName").toString();
		String itemValue = map.get("itemValue").toString();
		if (itemName == null || itemName == "") {
			msg.put("itemNameMsg", "此项不能为空");
			flage = false;
		}
		if (itemValue == null || itemValue == "") {
			msg.put("itemValueMsg", "项值不能为空");
			flage = false;
		} else {
			if (NumberUtil.isNumeric(itemValue)) {
				msg.put("itemValueMsg", "格式不正确,请输入数字");
				flage = false;
			}
		}
		msg.put("flage", flage);
		return msg;
	}

	// 查询最大的项值
	public Map<String, Object> selMaxValue(String dictionaryId) {
		return sqlsession.selectOne("DictionaryDao.selMaxValue", dictionaryId);
	}

	// 查询所有类型（下拉框遍历）
	public List<Map<String, Object>> selectDictionaryTypeList() {
		return sqlsession.selectList("DictionaryDao.selectDictionaryTypeList");
	}
	//查询字典项目名称
	public String selDictName(Map<String, Object> map) {
		return sqlsession.selectOne("DictionaryDao.selDictName", map);
	}

}
