package cn.admin.dictionary.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;


@Service
@Transactional(rollbackFor = Exception.class)
public class logisticsTemplateService {

	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	//查询模板数量
	public long selCount() {
		return sqlSession.selectOne("logisticsTemplateDao.selCount");
	}
	//只查询分页数据
	public List selPageList(Map<String, Object> search){
		return sqlSession.selectList("logisticsTemplateDao.selPageList", search);
	}
	//查询模板数据
	public List selTemplateList(Map<String, Object> search) {
		return sqlSession.selectList("logisticsTemplateDao.selTemplateList", search);
	}
	//修改价格
	public int updPrice(Map map) {
		return sqlSession.update("logisticsTemplateDao.updPrice",map);
	}
	//删除信息
	public int delInfo(Map map) {
		int type = Integer.parseInt(map.get("type")+"");
		int row = 0;
		if(type==1){
			row = sqlSession.update("logisticsTemplateDao.delPriceInfo",map);//删除价格信息
		}else{
			int ro = sqlSession.update("logisticsTemplateDao.delTemplate",map);//删除模板
			int rw = sqlSession.update("logisticsTemplateDao.delPriceTemp",map);//删除模板后，也删除模板对应的价格信息
			if(ro>0 && rw>0){
				row=1;
			}else{
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
			}
		}
		return row;
	}
	//查询区域列表
	public List<Map> selRegionList() {
		return sqlSession.selectList("logisticsTemplateDao.selRegionList");
	}
	//查询省市列表
	public List<Map> selProvinceList() {
		return sqlSession.selectList("logisticsTemplateDao.selProvinceList");
	}
	//查询该运费项所有的地址信息
	public Map selAllAddressIds(Map<String, Object> map) {
		return sqlSession.selectOne("logisticsTemplateDao.selAllAddressIds", map);
	}
	//修改运费的地址信息
	public int updAddressInfo(Map map) {
		return sqlSession.update("logisticsTemplateDao.updAddressInfo",map);
	}
	//添加模板的运费项
	public int addPriceInfo(Map map) {
		return sqlSession.insert("logisticsTemplateDao.addPriceInfo",map);
	}
	public int addTemplateInfo(Map map) {
		int result = 0;
		try {
			//添加总模板
			int row = sqlSession.insert("logisticsTemplateDao.saveTempplate",map);
			//添加模板下的运费项
			int priceCount = Integer.parseInt(map.get("priceCount")+"");
			String[] nowNums = map.get("nowNums").toString().split(",");
			if(priceCount>0){
				for (String str : nowNums) {
					Map<String,Object> itemInfo = new HashMap<String, Object>();
					itemInfo.put("templateId", map.get("tempId")+"");//模板id
					itemInfo.put("addressName", map.get("provinceName-"+str)+"");//省级名称
					itemInfo.put("regionId", map.get("region-"+str)+"");//区域id
					itemInfo.put("provinceIds", map.get("provinceIds-"+str)+"");//省级id
					itemInfo.put("cityIds", map.get("cityIds-"+str)+"");//市级id
					itemInfo.put("firstGoods", map.get("firstGoods-"+str)+"");//首件个数
					itemInfo.put("firstFreight", map.get("firstFreight-"+str)+"");//首件运费
					itemInfo.put("secondGoods", map.get("secondGoods-"+str)+"");//续件个数
					itemInfo.put("secondFreight", map.get("secondFreight-"+str)+"");//续件运费
					//添加运费项
					int rw = sqlSession.insert("logisticsTemplateDao.savePriceInfo",itemInfo);
				}
			}
			
			//添加全国其他城市的运费
			int ro = sqlSession.insert("logisticsTemplateDao.saveOrtherPrice",map);
			
			result=1;
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return result;
	}
	
}
