package cn.admin.ondemand.service;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.util.StringUtils;

import cn.util.DataConvert;
import cn.util.StringHelper;
import it.sauronsoftware.jave.Encoder;
import it.sauronsoftware.jave.MultimediaInfo;


@Service
public class OndemandService {

	
	@Autowired
	SqlSessionFactory sqlSessionFactory;
	@Autowired
	SqlSession sqlSession;
	
	
	
	/**
	 * 列表记录数量
	 * @param reqMap
	 * @return
	 */
	public long selOndemandCount(Map<String, Object> reqMap) {
		return sqlSession.selectOne("demandDao.selOndemandCount", reqMap);
	}
	/**
	 * 列表查询
	 * @param reqMap
	 * @return
	 */
	public List<Map<String, Object>> selOndemandList(Map<String, Object> reqMap) {
		return sqlSession.selectList("demandDao.selOndemandList", reqMap);
	}
	/**
	 * 修改状态
	 * @param map
	 * @return
	 */
	public int updateStatus(Map map) {
		return sqlSession.update("demandDao.updateStatus", map);
	}
	/**
	 * 删除点播课程
	 * @param map
	 * @return
	 */
	public int deleteOndemand(Map map) {
		return sqlSession.delete("demandDao.deleteOndemand", map);
	}
	/**
	 * 添加点播课程基本信息
	 * @param map
	 * @return
	 */
	public int addBasic(Map map) {
		return sqlSession.insert("demandDao.addBasic", map);
	}
	/**
	 * 修改点播课程信息
	 * @param map
	 * @return
	 */
	public int updateBasic(Map map) {
		//修改基础信息
		int row = 0;
		//添加课程与教师中间表
		if("on".equals(map.get("display")+"")){
			map.put("display", "1");
		}else{
			map.put("display", "0");
		}
		if(StringUtils.isEmpty(DataConvert.ToString(map.get("id"))) && !StringUtils.isEmpty(DataConvert.ToString(map.get("teacherId")))){
			sqlSession.insert("demandDao.addOndemandANDteacher", map);
		}else if(!StringUtils.isEmpty(DataConvert.ToString(map.get("teacherId")))){
			sqlSession.update("demandDao.upOndemandANDteacher", map);
		}
		//判断是否是课程发布
		if("1".equals(DataConvert.ToString(map.get("release")))){
			//只更改课程的状态即可
			if("1".equals(map.get("classtype")+"")){
				map.put("status", "2");
			}else{
				map.put("status", "1");
			}
			row = sqlSession.update("demandDao.updateStatus", map);
		}else{
			row = sqlSession.update("demandDao.updateBasic", map);
		}
		return row;
	}
	/**
	 * 查询课程基本信息
	 * @param ondemandId
	 * @return
	 */
	public Map findById(String ondemandId) {
		return sqlSession.selectOne("demandDao.findById", ondemandId);
	}
	/**
	 * 修改
	 * @param map
	 * @return
	 */
	public int updateMsg(Map map) {
		return sqlSession.update("demandDao.updateMsg", map);
	}
	/**
	 * 添加课时相关章节
	 * @param map
	 * @return
	 */
	public int insertChapter(Map<String, Object> map) {
		//先查询当前课时下是否有章节目录
		List<Object> list = sqlSession.selectList("demandDao.selectChapter", map.get("ondemandId")+"");
		int orderIndex = 0;
		if(list.size() > 0 && !StringUtils.isEmpty(list)){
			//查询此时章节目录最大的排序号
			orderIndex = sqlSession.selectOne("demandDao.selectChapterOrder");
		}
		map.put("orderIndex", orderIndex+1);
		return sqlSession.insert("demandDao.insertChapter", map);
	}
	/**
	 * 保存课时信息
	 * @param map
	 * @return
	 */
	public int addClassHour(Map<String, Object> map) {
		int row = 0;
		try {
			List<Object> list = sqlSession.selectList("demandDao.selectClass", map.get("ondemandId")+"");
			int orderIndex = 0;
			if(list.size() > 0 && !StringUtils.isEmpty(list)){
				//查询此时课时最大的排序号
				orderIndex = sqlSession.selectOne("demandDao.selectHourOrder");
			}
			map.put("orderIndex", orderIndex+1);
			row = sqlSession.insert("demandDao.addClassHour", map);
			if(row<=0) {
				return row;
			}
			//添加ppt关联信息
			if(!DataConvert.ToString(map.get("pptfileName")).isEmpty() && !DataConvert.ToString(map.get("pptUrl")).isEmpty()) {
				String[] pptUrls = DataConvert.ToString(map.get("pptUrl")).split(",");
				List pptUrlslist = new ArrayList<>();
				for (String string : pptUrls) {
					pptUrlslist.add(string);
				}
				map.put("pptUrls", pptUrlslist);
				row = sqlSession.insert("demandDao.addPpt",map);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return row ;
	}
	//修改课时
	public int updateClassHour(Map<String, Object> map) {
		int row =0;
		try {
			row = sqlSession.update("demandDao.updateClassHour", map);
			if(row>0) {
				//先删掉关联的ppt
				if(!DataConvert.ToString(map.get("pptfileName")).isEmpty() && !DataConvert.ToString(map.get("pptUrl")).isEmpty()) {
					sqlSession.delete("demandDao.delPpt",map);
					String[] pptUrls = DataConvert.ToString(map.get("pptUrl")).split(",");
					map.put("pptUrls", pptUrls);
					row = sqlSession.insert("demandDao.addPpt",map);
				}
			}
		} catch (Exception e) {
			row=0;
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();//手动回滚
		}
		return row;
	}
	//查询章节信息
	public List selectChapter(String ondemandId) {
		return sqlSession.selectList("demandDao.selectChapter", ondemandId);
	}
	//查询最新的章id
	public Map selLastChapter(Map<String, Object> map) {
		return sqlSession.selectOne("demandDao.selLastChapter", map);
	}
	//删除章节目录
	public int delChapter(Map<String, Object> map) {
		return sqlSession.delete("demandDao.delChapter", map);
	}
	//查询章节信息
	public Map selChapterMsg(String chapterId) {
		return sqlSession.selectOne("demandDao.selChapterMsg", chapterId);
	}
	//编辑章节信息
	public int editChapter(Map<String, Object> map) {
		return sqlSession.update("demandDao.editChapter", map);
	}
	//查询教师
	public List selTeacherAll() {
		return sqlSession.selectList("demandDao.selTeacherAll");
	}
	//根据id查询指定教师
	public Map teacherMsg(Map map) {
		return sqlSession.selectOne("demandDao.teacherMsg", map);
	}
	//查询已经设置的教师信息
	public Map CheckTeacherMsg(String ondemandId) {
		return sqlSession.selectOne("demandDao.CheckTeacherMsg", ondemandId);
	}
	//获取课时信息
	public List<Map> selectClass(String ondemandId) {
		return sqlSession.selectList("demandDao.selectClass", ondemandId);
	}
	//删除课时信息
	public int delClassHour(Map<String, Object> map) {
		int row = 1;
		try {
			sqlSession.delete("demandDao.delClassHour", map);
			sqlSession.delete("demandDao.delPpt", map);
		} catch (Exception e) {
			e.printStackTrace();
			row=0;
		}
		return row;
	}
	//根据课时id查询课时信息
	public Map findByKid(String parameter) {
		return sqlSession.selectOne("demandDao.findByKid", parameter);
	}

	/**
	 * 章节目录拖拽排序
	 * 	同一个父级节点下的拖拽
	 * 
	 * @param dragId 被拖拽节点Id
	 * 	fallId 落下时当前位置的节点Id
	 * @return
	 */
	public int upOrderIndex(Map<String, Object> map) {
		int row = 0;
		/**
		 * 判断要排序的是课时还是章节目录
		 */
		if(!StringUtils.isEmpty(map.get("KId"))){
			//课时排序变更
			String before = sqlSession.selectOne("demandDao.ChapterOrderIndex", map.get("dragId")+"");
			String after = sqlSession.selectOne("demandDao.ChapterOrderIndex", map.get("KId")+"");
			Map m = new HashMap();
			m.put("orderIndex", before);
			m.put("hourId", map.get("KId")+"");
			row = sqlSession.update("demandDao.UpChapterOrder", m);
			Map mm = new HashMap();
			mm.put("orderIndex", after);
			mm.put("hourId", map.get("dragId")+"");
			row = sqlSession.update("demandDao.UpChapterOrder", mm);
		}else{//章节目录排序变更
			//先查询被拖拽节点的排序号
			String beforeIndex = sqlSession.selectOne("demandDao.selDragIndex", map.get("dragId")+"");
			String afterIndex = sqlSession.selectOne("demandDao.selDragIndex", map.get("fallId")+"");
			//更改
			Map ma = new HashMap();
			ma.put("orderIndex", beforeIndex);
			ma.put("chapterId", map.get("fallId")+"");
			row = sqlSession.update("demandDao.updateIndex", ma);
			Map mas = new HashMap();
			mas.put("orderIndex", afterIndex);
			mas.put("chapterId", map.get("dragId")+"");
			row = sqlSession.update("demandDao.updateIndex", mas);
		}
		return row;
	}
	/**
	 * 不是同一父级节点下的拖拽排序
	 *  dragId 被拖拽节点Id parentId要变更成的父Id
	 * @return
	 */
	public int upParentId(Map<String, Object> map) {
		int row = 0;
		if(!StringUtils.isEmpty(map.get("KId")) || "k".equals(map.get("type")+"")){
			row = sqlSession.update("demandDao.UpHourPId", map);
		}else{
			row = sqlSession.update("demandDao.UpChapterPId", map);
		}
		return row;
	}
	//删除课程原本关联的教师
	public int delTeacher(Map map) {
		return sqlSession.delete("demandDao.delTeacher", map);
	}
	//修改点播课程是否推荐
	public int updateIsRecommend(Map map) {
		return sqlSession.update("demandDao.updateIsRecommend", map);
	}
	//查询课程名称
	public int selOndemanType(Map<String, Object> reqMap) {
		return sqlSession.selectOne("demandDao.selOndemanType", reqMap);
	}
	/**
	 * 获取音视频时长
	 * @return min sec
	 */
	public Map<String,Object> getDuration(String videoUrl) {
		Map<String, Object> map = new HashMap<String,Object>();
        try {
        	 String userDir = System.getProperty("user.dir");
    		 File source = new File(userDir+videoUrl);
        	 Encoder encoder = new Encoder();
        	 
             MultimediaInfo m = encoder.getInfo(source);
             long ls = m.getDuration();
             //转换为分钟
             long min = ls/60000;
             //转换为秒
             long sec = ls%60000/1000;
             
             map.put("min", min);
             map.put("sec", sec);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
	
	
	
}
