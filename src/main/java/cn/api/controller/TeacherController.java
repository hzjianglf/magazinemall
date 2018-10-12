package cn.api.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import cn.api.service.PathService;
import cn.api.service.TeacherService;
import cn.core.Sign;
import cn.util.DeHtml;
import cn.util.Page;

@Api(tags={"获取专家信息接口"})
//@Sign
@RestController
@RequestMapping(value="/api/teacher")
public class TeacherController {
	
	/**
	 * 教师专家等信息
	 * 
	 * */
	
	@Autowired
	TeacherService teacherService;
	@Autowired
	PathService pathService;
	private static String delHTMLTag;
	
	//获取专家列表
	@RequestMapping(value="/expertList")
	@ApiOperation(value="获取专家列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="IsRecommend",value="是否推荐 0所有 1推荐",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="searchName",value="搜索内容",dataType="string",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={userId='专家id',realname='专家真实姓名',nickName='专家昵称',userUrl='头像',synopsis='简介',ondemandCount='已发布课程数量'}}")
	})
	public Map expertList(Integer IsRecommend,String searchName,Integer page,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误");
			}
		};
		
		boolean flag=false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			
			flag=true;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		map.put("IsRecommend", IsRecommend);
		map.put("searchName", searchName);
		List<Map<String,Object>> list = teacherService.selExpertList(map);
		pathService.getAbsolutePath(list, "userUrl");
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
        long count = teacherService.selectExpertCont(map);
        reqMap.put("totalCount", count);
		if(flag){
			int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
		}
		reqMap.put("data", list);
		return reqMap;
	}

	/**
	 * 获取专家详细信息
	 * @param 专家id  userId
	 * @return
	 * realname 真实姓名
	 * nickName 昵称   sex 性别
	 * userUrl 头像   synopsis 简介
	 * education 学历     industry	行业
	 * fansNum	粉丝数   rewardNum 打赏人数   followNum 关注数	
	 */
	@RequestMapping("/selTeaContent")
	@ApiOperation(value="获取专家详细信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="专家id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="myUserId",value="当前用户id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={userId='专家id',realname='专家真实姓名',nickName='专家昵称',userUrl='头像',synopsis='简介',ondemandCount='已发布课程数量'"
				+ ",education='学历',industry='行业',money='提问价格',fansNum='粉丝数',rewardNum='打赏人数',followNum='关注数',twCount='问答数量',userurl='打赏人头像list',teacherlist='专家课程',auditlist='问答列表'}}")
	})
	public Map<String,Object> selTeaContent(Integer userId,Integer myUserId){
		Map<String,Object> map = teacherService.selTeacherContent(userId,myUserId);
		return map;
	}
	/**
	 * 获取专家的课程列表
	 * @param userId 专家的id
	 * @param pageNow 当前页
	 * @param pageSize 每页查询的记录数
	 * 
	 * return: userUrl 头像
	 * name 课程名字
	 * count 视频个数
	 * studentNum 订阅人数
	 * hits 播放次数
	 * IsRecommend 是否推荐
	 * serialState 连载状态
	 * status 状态 0已关闭 1已发布 -1未发布：草稿状态 2未开始 3直播中 4已结束
	 * IsGratis 是否免费
	 */
	@RequestMapping("getOndemandList")
	@ApiOperation(value="获取专家的课程列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="专家id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="classtype",value="课程类型（0点播,1直播.不传显示所有类型）",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="每页查询的记录数",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={userUrl='头像',name='课程名字',count=' 视频个数',studentNum=' 订阅人数',hits='播放次数',IsRecommend='是否推荐'"
				+ ",serialState='连载状态',status='状态 0已关闭 1已发布 -1未发布：草稿状态 2未开始 3直播中 4已结束',IsGratis='是否免费'}}")
	})
	public Map<String,Object> getOndemandlist(Integer userId,Integer classtype,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==userId){
				map.put("msg", "请输入专家id");
				return map;
			}
			if(pageNow==null || pageNow<1){
				pageNow=1;
			}
			if(pageSize==null||pageSize<0){
				pageSize=10;
			}
			Map<String,Object> paramap = new HashMap<>();
			paramap.put("userId", userId);
			if(classtype!=null) {
				paramap.put("classtype", classtype);
			}
			long count = teacherService.getOndemandCount(paramap);
			Page page = new Page(count, pageNow, pageSize);
			int startPos = page.getStartPos();
			paramap.put("start", startPos);
			paramap.put("pageSize", pageSize);
			List list = teacherService.getOndemandList(paramap);
			
			pathService.getAbsolutePath(list, "picUrl");
			
			map.put("totalPage", page.getTotalPageCount());
			map.put("pageNow", pageNow);
			map.put("data", list);
			map.put("msg", "获取成功!");
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg",e.getMessage()+ "获取列表失败");
		}
		return map;
	}
	/**
	 * 专家下的销售记录
	 * @return
	 */
	@RequestMapping(value="/getMySaleLog")
	@ApiOperation(value="专家下的销售记录",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="专家id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={name='课程名称',nickName='买家昵称',totalprice='价格',addtime='购买时间'}}")
	})
	public Map<String, Object> getMySaleLog(Integer userId,Integer page,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		Map<String,Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		if(userId==null){
			return reqMap;
		}
		
		boolean flag=false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			int start=(page-1)*pageSize;
			
			flag=true;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		map.put("userId", userId);
		List list = teacherService.selectMySalelogList(map);
		reqMap.put("result", 1);
		reqMap.put("msg", "获取成功！");
		if(flag){
			long count = teacherService.selectMySalelogCount(map);
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
		}
		reqMap.put("data", list);
		return reqMap;
	}
	
	/**
	 * 获取专栏工作台信息
	 */
	@RequestMapping(value="/specialColumnApply")
	@ApiOperation(value="获取专栏工作台信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="专家id",dataType="String",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={nickName='昵称',realname='真实姓名',userUrl='头像',vipGrade='等级',worksCount='作品数量',"
				+ "liveCount='直播课程数量',mothNowPrice='本月收益',sumMoney='累计收益'}}")
	})
	public Map<String, Object> specialColumnApply(String userId){
		Map<String, Object> reqMap =  new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误");
			}
		};
		
		if(userId==null){
			return reqMap;
		}
		
		try {
			Map<String, Object> ma = teacherService.selectWriterMsg(userId);
			
			pathService.getAbsolutePath(ma, "userUrl");
			
			reqMap.put("result", 1);
			reqMap.put("msg", "获取成功!");
			reqMap.put("data", ma);
		} catch (Exception e) {
			reqMap.put("msg", "请求失败,"+e.getMessage());
		}
		return reqMap;
	}
}
