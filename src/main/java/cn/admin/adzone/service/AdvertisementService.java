package cn.admin.adzone.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import cn.api.service.PathService;
import cn.util.Tools;

@Service
@Transactional
public class AdvertisementService {
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	@Autowired
	PathService pathService;

	public List<Map<String, Object>> selectAdver(Map<String, Object> map) {
		List<Map<String, Object>> list = sqlSession.selectList("adverDao.selAdver", map);
		return list;
	}

	public long getTotalCount(Map<String, Object> selAdver) {
		return sqlSession.selectOne("adverDao.countAdver", selAdver);
	}

	public int addAdver(Map<String, Object> map) {
		int row = sqlSession.insert("adverDao.insAdver", map);
		if (map.get("zoneID") != null) {
			int advId = sqlSession.selectOne("adverDao.getAdvId", map);
			map.put("aDID", advId);
			row = sqlSession.insert("adverDao.insAdment", map);
		}
		return row;
	}

	public Map<String, Object> updateUrl(int aDID) {
		Map<String, Object> map = sqlSession.selectOne("adverDao.selAdverId", aDID);
		return map;
	}

	public int updateAdver(Map<String, Object> map) {
		return sqlSession.update("adverDao.updAdver", map);
	}

	public int delAdver(List<String> delList) {
		return sqlSession.delete("adverDao.deleteAdver", delList);
	}

	public int updAdver(List<String> delList) {
		return sqlSession.update("adverDao.updAdver1", delList);
	}

	public int updAdver2(List<String> delList) {
		return sqlSession.update("adverDao.updAdver2", delList);
	}

	// 删除广告时，删除对应的广告和广告位关系
	public int delAD(List<String> delList) {
		return sqlSession.delete("adverDao.delADByAdvId", delList);
	}

	// 前台查询广告banner
	public List<Map<String, Object>> selBannerByZoneID(Integer zoneID) {
		List<Map<String, Object>> list = sqlSession.selectList("adverDao.selBanner", zoneID);
		return list;
	}
	/**
	 * 
	 * @param list
	 * @param num 0 img不需要转为绝对路径  1 需要转为绝对路径
	 * @return
	 */
	public List<Map<String, Object>> changeUrl(List<Map<String,Object>> list,Integer num){
		for (Map<String, Object> adverMap : list) {
			String linkUrl = adverMap.get("linkUrl").toString();
			if(linkUrl != null && linkUrl != "") {
				Map<String, Object> maps = Tools.JsonToMap(linkUrl);
				if(maps !=null && maps.size()>0) {
						if(Integer.parseInt(maps.get("itemType").toString())==1) {//期刊
							linkUrl = "/product/turnPublicationDetail?id="+maps.get("itemId");
							adverMap.put("linkUrl", linkUrl);
						}else if(Integer.parseInt(maps.get("itemType").toString())==2) {//课程
							linkUrl = "/product/classDetail?ondemandId="+maps.get("itemId");
							adverMap.put("linkUrl", linkUrl);
						}else if(Integer.parseInt(maps.get("itemType").toString())==3) {//专家
							linkUrl = "/expert/toExpertDetail?userId="+maps.get("itemId");
							adverMap.put("linkUrl", linkUrl);
						}
				}
			}
			if(num>0 && adverMap.get("imgUrl")!=null) {
				String imgUrl = adverMap.get("imgUrl").toString();
				adverMap.put("imgUrl", pathService.getAbsolutePath(imgUrl));
			}
		}
		return list;
	}

	// 查询广告位没有添加的广告
	public List<Map<String, Object>> seltAdver(Map<String, Object> map) {
		List<Map<String, Object>> list = sqlSession.selectList("adverDao.seltAdver", map);
		return list;
	}

	public long selectProductCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("adverDao.selectProductCount", reqMap);
	}

	public List<Map<String, Object>> selProduct(Map<String, Object> reqMap) {
		return sqlSession.selectList("adverDao.selProduct", reqMap);
	}

	public List<Map<String, Object>> selAdzoneListTotal() {
		return sqlSession.selectList("adverDao.selAdzoneListTotal");
	}
}
