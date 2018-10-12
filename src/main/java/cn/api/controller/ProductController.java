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
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import cn.Pay.service.payService;
import cn.Setting.Setting;
import cn.Setting.Model.SiteInfo;
import cn.admin.adzone.service.AdvertisementService;
import cn.api.service.ActivityService;
import cn.api.service.ApiResult;
import cn.api.service.OrderService;
import cn.api.service.PathService;
import cn.api.service.ProductService;
import cn.util.DataConvert;
import cn.util.Page;

/**
 * 商品信息
 */
@Api(tags={"商品操作的接口"})
//@Sign
@RestController
@RequestMapping("/api/product")
public class ProductController {
	
	@Autowired
	private AdvertisementService advertisementService;
	@Autowired
	ProductService productService;
	@Autowired
	payService payservice;
	@Autowired
	OrderService orderService;
	@Autowired
	Setting setting;
	@Autowired
	ActivityService activityService;
	@Autowired
	PathService pathService;
	
	/**
	 * 通过文章id查找电子书内容
	 */
	@RequestMapping("getEbookByDocId")
	@ApiOperation(value="通过文章id查找电子书内容",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="DocID",value="文章id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={ColumnID='栏目id',DocID='文章id',"
				+ "ColumnName='栏目名称',Author:'作者',MainText='正文',SubText='引言',Title='文章标题',LeadTitle:'引题',Subtitle:'副标题',}}")
	})
	public Map<String,Object> getEbookByDocId(Integer DocID){
		ApiResult result=new ApiResult(false,"参数错误");
		if(DocID==null){
			return result.getResult();
		}
		try {
			SiteInfo siteInfo=setting.getSetting(SiteInfo.class);
			Map<String, Object> map = new HashMap<String, Object>();
			Map maps = productService.getArticleById(DocID);
			
			
			map.put("result", 1);
			map.put("msg", "获取数据成功");
			map.put("data", maps);
			return map;
		} catch (Exception e) {
			result.setMessage(e.getMessage());
		}
		return result.getResult();
	}
	/**
	 * 通过期刊的id查找电子书
	 */
	@RequestMapping("getEbookByPubId")
	@ApiOperation(value="通过期次id查找电子书栏目列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="pubId",value="期次id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={说明='DocID='文章id',"
				+ ",url='图片地址',SubText='文章简介',Title='文章标题'}}")
	})
	public Map<String,Object> selEbookByPubId(Integer pubId){
		ApiResult result=new ApiResult(false,"参数错误");
		
		if(null==pubId){
			
			return result.getResult();
		}
		try {
			
			List<Map<String,Object>> list = productService.selEbookByPubId(pubId);
			result.setResult(true, "获取成功！",list);
			
		} catch (Exception e) {
			e.printStackTrace();
			result.setMessage("获取失败");
		}
		return result.getResult();
	}
	/**
	 * 获取课程列表
	 * @param classtype 课程类型 0点播 1直播
	 * @param type 课程分类参数
	 * @return list
	 */
	@RequestMapping(value="/ondemand")
	@ApiOperation(value="获取课程列表/课程合集列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="classtype",value="课程类型(点播/直播 0点播 1直播)",dataType="String",required=false,paramType="query"),
		@ApiImplicitParam(name="type",value="课程分类参数 专家课程1 白马营2 听刊3 营销书院4快课8",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="IsRecommend",value="是否推荐(首页查询时，该参数传1，不是首页查询，该参数可以忽视)",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="searchName",value="搜索内容",dataType="string",required=false,paramType="query"),
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={ondemandId='课程id',name='课程名称',title='副标题',serialState='连载状态（0非连载课程 1更新中 2已完结）',introduce='简介',"
				+ "IntendedFor='适应人群',classtype='0点播课程 1直播课程',isSum='是否合集(0不是1是)',IsRecommend='是否推荐(0不推荐1推荐)',picUrl='课程图片',originalPrice='原价',presentPrice='现价',"
				+ "IsGratis='是否是免费课程 0不是 1是',userId='教师的id',hourCount='课时数量',totalPage='总页数',currentPage='当前页',totalCount='总条数',studentNum='订阅人数',hits='播放次数',realname='教师真实姓名',nickName='教师昵称',synopsis='教师简介',isbuy='是否购买了，0未购买，大于0购买了'}}")
	})
	public Map<String, Object> ondemand(Integer userId,String searchName,String classtype,Integer type,Integer IsRecommend,Integer  page,Integer  pageSize){
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", 0);
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if(page==null||page<1){
				page=1;
			}
			if(pageSize==null){
				pageSize=Integer.MAX_VALUE;
			}
			int start=(page-1)*pageSize;
			map.put("classtype", classtype);
			map.put("type", type);
			map.put("IsRecommend", IsRecommend);
			map.put("start", start);
			map.put("pageSize", pageSize);
			map.put("userId", userId);
			map.put("searchName", searchName);
			//查询课程列表
			List list = productService.selCurriculum(map);
			
			pathService.getAbsolutePath(list, "picUrl");
			
			long count=productService.selCurriculumCount(map);
	        result.put("result", 1);
	        result.put("msg", "获取数据成功！");
	        result.put("data", list);
	        result.put("totalCount", count);
			if(pageSize!=null){
				int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
				result.put("totalPage", totalPage);
				result.put("currentPage", page);
	        }
		} catch (Exception e) {
			result.put("msg", "获取数据失败！");
		}
		
		return result;
	}
	/**
	 * 获取推荐课程
	 * @param recommend 推荐 (0--否 1--是)
	 * @return list
	 */
	@RequestMapping(value="/selRecommend")
	@ApiOperation(value="获取推荐课程/专家主页获取专家的所有课程列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="recommend",value="推荐 (0--否 1--是)",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="teacherId",value="教师id(首页查询推荐课程及推荐课程列表时,该参数不用传,查询教师所有课程时需要传且recommend=0)",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={ondemandId='课程id',name='课程名称',title='副标题',serialState='连载状态（0非连载课程 1更新中 2已完结）',introduce='简介',"
				+ "IntendedFor='适应人群',classtype='0点播课程 1直播课程',IsRecommend='是否推荐(0不推荐1推荐)',picUrl='课程图片',originalPrice='原价',presentPrice='现价',"
				+ "IsGratis='是否是免费课程 0不是 1是',userId='教师的id',studentNum='订阅人数',hits='播放次数',realname='教师真实姓名',nickName='教师昵称',synopsis='教师简介',hourCount='课时数量'}}")
	})
	public Map<String, Object> selRecommend(Integer recommend,Integer teacherId,Integer  page,Integer  pageSize){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		
		if(page==null||page<1){
			page=1;
		}
		if(pageSize==null){
			pageSize=Integer.MAX_VALUE;
		}
		int start=(page-1)*pageSize;
		map.put("recommend", recommend);
		map.put("teacherId", teacherId);
		map.put("start", start);
		map.put("pageSize", pageSize);
		//查询推荐课程列表
		List list = productService.selRecommendList(map);
		
		pathService.getAbsolutePath(list, "picUrl");
		
		long count=productService.selRecommendCount(map);
        
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
		if(pageSize!=null){
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		reqMap.put("data", list);
		return reqMap;
	}
	/**
	 * 获取精选杂志列表
	 * @author baoxuechao
	 * @param page 页码
	 * @param pageSize 页容量
	 * @param isTop 是否推荐(精选) 0是/1否
	 */
	@RequestMapping(value="/choiceMagazines")
	@ApiOperation(value="获取精选杂志列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="orderType",value="排序方式(0时间/1销量)",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="isTop",value="是否推荐(精选) 1是/0全部",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="searchName",value="搜索内容",dataType="string",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='期刊id',name='杂志名称',paperPrice='纸质版价格',ebookPrice='电子版价格',sales='已售数量',picture='主图',"
				+ "pictureUrl='商品图片',totalPage='总页数',currentPage='当前页',totalCount='总条数',period='期次id',pname='期刊名称',year='年度',isbuy='用户是否已购买当前期刊对应的电子书0没有购买大于0已购买',status='是否有电子书0没有大于0有'}}")
	})
	public Map<String, Object> choiceMagazines(Integer page,Integer pageSize,Integer orderType,
			int isTop,Integer userId,String searchName){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId==null || userId<0){
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
		
		map.put("isTop", isTop);
		map.put("orderType", orderType);
		map.put("userId", userId);
		map.put("searchName", searchName);
		List list = productService.selectMagazineList(map);
		
		pathService.getAbsolutePath(list, "pictureUrl","picture");
		
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
        long count = productService.selectMagazineCount(map);
		if(flag){
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		reqMap.put("totalCount", count);
		reqMap.put("data", list);
		return reqMap;
	}
	
	/**
	 * @param  zoneID 广告位的id
	 * 获取广告位
	 * return aDName 广告名称
	 * advType 广告类型：1，图片；2，动画；3，文本；4，代码；5，页面
	 * imgUrl 图片地址
	 * imgWidth 宽
	 * imgHeight 高
	 * aDIntro 广告介绍
	 * linkUrl 链接地址
	 * linkTarget 链接弹出方式1、新窗口2、原窗口
	 * linkAlt 链接提示
	 * priority 权重
	 */
	@RequestMapping("/banner")
	@ApiOperation(value="获取首页轮播广告",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="zoneID",value="广告位id  4",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={imgUrl='图片地址',imgWidth='宽',imgHeight='高',"
				+ "linkUrl='链接地址格式{{'itemId':'id',itemType':'1期刊2课程3专家','itemSumType':'是否合集不用管这个'}}'}}")
	})
	public Map getAdzone(Integer zoneID){
		Map map = new HashMap();
		try {
			if(null==zoneID){
				map.put("result", 0);
				map.put("msg", "请输入广告位ID");
				return map;
			}
			List<Map<String,Object>> list = advertisementService.selBannerByZoneID(zoneID);
		
			pathService.getAbsolutePath(list, "imgUrl");
			map.put("result", 1);
			map.put("data", list);
		} catch (Exception e) {
			map.put("result", 0);
			map.put("msg", "加载首页banner图失败");
		}
		return map;
	}
	/**
	 * 获取指定课程基础信息
	 * @param ondemandId 课程的id  type 传1表示正序排列 传2表示倒序排列
	 * return 
	 * 课程名字 name
	 * 课程图片 picUrl
	 * 课程是否免费 IsGratis 0不是1是
	 * 课程播放次数 hits
	 * 课程简介 introduce
	 * 课时标题 title
	 * 课时简介 abstracts
	 * 用户头像 userUrl
	 * 课时播放次数 hourhits
	 * 课时的id hourId
	 * 课时时长分 minute 秒second
	 * 评论个数 commentCount
	 * 课程类型  0点播课程 1直播课程	classtype
	 */
	@RequestMapping("/getOndemandContent")
	@ApiOperation(value="获取指定课程基础信息",httpMethod="GET")
	public Map<String,Object> getOndemandContent(Integer ondemandId,Integer type){
		Map<String,Object> map= new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(ondemandId==null || type==null){
				map.put("msg", "传入参数错误");
				return map;
			}
			Map<String,Object> paramap= new HashMap<String, Object>();
			paramap.put("ondemandId", ondemandId);
			paramap.put("type", type);
			List list = productService.getOndemandContent(paramap);
			
			pathService.getAbsolutePath(list, "picUrl","userUrl");
			
			map.put("data", list);
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg", "获取信息失败:"+e.getMessage());
		}
		return map;
	}
	/**
	 * 通过课时id获取课时详情
	 * @param hourId 课时的id
	 * return 
	 * videoUrl,视频地址
	 * title,标题
	 * abstracts,摘要
	 * content,内容
	 * presentation,文稿
	 * hits,播放次数
	 * addTime 添加课时的时间
	 * commentCount 当前课时的评论数
	 */
	@RequestMapping("/getHourContent")
	@ApiOperation(value="通过课时id获取课时详情",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="hourId",value="课时的id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{\"result\":\"0/1\",\"data\":{\"hourId\\\":\\\"课时id\\\",\\\"ondemandId\\\":\\\"课程Id\\\",\\\"videoUrl\\\":\\\"音/视频地址\\\",\\\"title\\\":\\\"标题\\\",\\\"abstracts\\\":\\\"摘要\\\",\\\"content\\\":\\\"内容\\\","
				+ "\\\"presentation\\\":\\\"文稿\\\",\\\"hits\\\":\\\"播放次数\\\",\\\"addTime\\\":\\\"课时添加时间\\\",\\\"commentCount\\\":\\\"当前课时的评论数\\\",\\\"questionPrice\\\":\\\"问答价格\\\",\\\"teacherId\\\":\\\"当前课程对应的教师id\\\",\\\"picUrl\\\":\\\"课程图片\\\",\\\"imgUrls\\\":[\"图片1\",\"图片2\",\"...\"]}}")
	})
	public Map<String,Object> getHourContent(Integer hourId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==hourId){
				map.put("msg", "传入参数错误");
				return map;
			}
			Map<String,Object> result = productService.getHourContent(hourId);
			
			pathService.getAbsolutePath(result, "videoUrl","picUrl");
			
			map.put("result", 1);
			map.put("data", result);
		} catch (Exception e) {
			map.put("msg", "获取课时信息失败:"+e.getMessage());
		}
		return map;
	}
	/**
	 * 获取制定课程的评论列表
	 * @param page 
	 * @param pageSize 
	 * @param commentType 评论类型 1--专家 2--课时 3--期刊 4--商品
	 * @param contentId 评论的对象id
	 * 
	 * @return param---返回列表参数
	 * @param id 主键id
	 * @param content 评论内容
	 * @param poster 该条评论的提交人姓名
	 * @param isAnonymity 是否匿名 0--否 1--是
	 * @param parentId 上级评论id
	 * @param dateTime 评论时间
	 */
	@RequestMapping(value="/getClassComment")
	@ApiOperation(value="获取制定课程的评论列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="commentType",value="评论类型 1--专家 2--课时 3--期刊 4--商品",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="contentId",value="评论的对象id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='评论id',content='评论内容',poster='该条评论的提交人姓名',isAnonymity='是否匿名 0--否 1--是'"
				+ ",parentId='父级评论id',dateTime='评论时间',childList='子集评论列表'},count='总的评论数'}")
	})
	public Map<String, Object> getClassComment(Integer  page,Integer  pageSize,Integer commentType,Integer contentId){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(commentType==null||commentType<=0){
			return reqMap;
		}
		if(contentId==null||contentId<=0){
			return reqMap;
		}
		
		boolean flag = false;
		if(page!=null&&pageSize!=null){
			if(page<=0){
				page=1;
			}
			if(pageSize<=0){
				pageSize=10;
			}
			flag=true;
			int start=(page-1)*pageSize;
			map.put("start", start);
			map.put("pageSize", pageSize);
		}
		map.put("commentType", commentType);
		map.put("contentId", contentId);
		
		List list = productService.selectCommentList(map);
		reqMap.put("result", 1);
        reqMap.put("msg", "获取数据成功！");
        long count = productService.selectCommentCount(map);
		if(flag){
        	int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
        }
		reqMap.put("data", list);
		reqMap.put("count", count);
		return reqMap;
	}
	/**
	 * 添加、回复评论
	 * @param userId 提交人id
	 * @param content 内容
	 * @param isAnonymity 是否匿名 0--否 1--是
	 * @param contentId 评论对象id
	 * @param commentType 评论类型  1--专家 2--课时 3--期刊 4--商品
	 * @param parentId 评论的父级id(没有则传 0 )
	 * @return
	 */
	@RequestMapping(value="/addComment")
	@ApiOperation(value="添加、回复评论",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="提交人id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="content",value="内容",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="isAnonymity",value="是否匿名 0--否 1--是",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="contentId",value="评论对象id(根据评论类型区分 类型为1--专家  则contentId为专家id)",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="commentType",value="评论类型  1--专家 2--课时 3--期刊 4--商品",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="parentId",value="评论的父级id(没有则传 0 )",dataType="int",required=false,paramType="query")
	})
	public Map<String, Object> addComment(Integer userId,String content,Integer isAnonymity,Integer contentId,Integer commentType,Integer parentId){
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(userId==null||userId<=0){
			return reqMap;
		}
		map.put("userId", userId);
		map.put("content", content);
		map.put("isAnonymity", isAnonymity);
		map.put("contentId", contentId);
		map.put("commentType", commentType);
		map.put("parentId", parentId);
		try {
			if(parentId!=null&&parentId!=0) {
				//查询contentId
				Map<String,Object> ma = productService.selContentId(map);
				map.put("contentId", DataConvert.ToInteger(ma.get("contentId")));
			}
			
			//添加恢复评论
			int row = productService.addComment(map);
			if(row>0){
				reqMap.put("result", 1);
				reqMap.put("msg", "评论成功！");
			}else{
				reqMap.put("result", 0);
				reqMap.put("msg", "评论失败！");
			}
		} catch (Exception e) {
			reqMap.put("msg", "请求失败!"+e.getMessage());
		}
		return reqMap;
	}
	
	/**
	 * 获取更多杂志
	 * @param  type 年份
	 * @param  pageNow 当前页  pageSize 显示记录数
	 *
	 * return 
	 * id  杂志的id
	 * name 杂志的名字
	 * sales 销量
	 * paperPrice 价格
	 * picture 商品主图
	 * pictureUrl 杂志图片地址
	 */
	@RequestMapping("getMoreMagazines")
	@ResponseBody
	@ApiOperation(value="通过年份获取期刊接口",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="type",value="年份",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="当前页",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="显示记录数",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='期刊id',name='期刊名称',paperPrice='纸质版价格',sales='已售数量',picture='主图',"
				+ "isbuy='用户是否已购买当前期刊对应的电子书0没有购买大于0已购买',"
				+ "status='是否有电子书0没有大于0有',sumType='0不是合集1上半年2下半年,3全年',year='合集的年份'}}")
	})
	public Map<String,Object> getMoreMagazines(Integer type,Integer pageNow,Integer pageSize,Integer userId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==pageNow||null==pageSize||null==type||pageNow<0||pageSize<0){
				map.put("msg", "参数错误");
				return map;
			}
			long totalCount = productService.getMoreMagazinesCount(type);
			Page page = new Page(totalCount, pageNow, pageSize);
			Map<String,Object> paramap = new HashMap<String, Object>();
			paramap.put("start", page.getStartPos());
			paramap.put("pageSize", pageSize);
			paramap.put("type", type);
			paramap.put("userId", userId);
			List list = productService.getMoreMagazines(paramap);
			pathService.getAbsolutePath(list,"picture");
			map.put("result", 1);
			map.put("data", list);
			map.put("totalPage", page.getTotalPageCount());
			map.put("pageNow", pageNow);
		} catch (Exception e) {
			map.put("msg", "获取失败");
		}
		return map;
	}
	/**
	 * 获取期刊年份
	 * return 
	 * list 年份
	 */
	@RequestMapping("getYears")
	@ResponseBody
	@ApiOperation(value="获取期刊年份",httpMethod="GET")
	public Map<String,Object> getYears(){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			List list = productService.getYears();
			map.put("result", 1);
			map.put("data", list);
		} catch (Exception e) {
			map.put("msg", "获取失败"+e.getMessage());
		}
		return map;
	}
	/**
	 * 获取指定期刊的详细信息
	 * @param  id 期刊id
	 * return 
	 * id 期刊的id
	 * name 期刊的名称
	 * picture 期刊图片
	 * paperPrice 纸质价格
	 * ebookPrice  电子价格
	 * describes 期刊描述
	 * 
	 */
	@RequestMapping("getMagazinesContent")
	@ResponseBody
	@ApiOperation(value="获取期刊详细信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="id",value="期刊的id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='期刊id',name='期刊名称',sales='销售量',picture='期刊图片',"
				+ "paperPrice='纸质价格',isBuySend='是否有买即送活动 0/1',buySendList='买即送活动列表[{name='活动名称',remark='备注'}]',period='期次id',ebookPrice='电子价格',stock='库存',status='单期是否有电子书0没有大于0有',describes='期刊描述',"
				+ "favorite='是否收藏 0代表没收藏 有值代表收藏列表的id',isSalePaper='如果该期刊是合集表示是否销售纸媒版0/1',isSaleEbook='如果该期刊是合集表示是否销售电子版0/1',bookList='[{id='合集id',paperPrice='纸质价格',name='合集名称',picture='合集图片',ebookPrice='电子价格',"
				+ "desc='合集期次id',sumType='1上半年,2下半年,3全年,4双刊',isSalePaper='是否有纸质合集',isSaleEbook='如果该期刊是合集表示是否销售纸媒版0/1',ebook='大于0有电子书合集,0则没有',yuanPaperPrice='纸质原价',yuanEbookPrice='电子原价'}]'}}")
	})
	public Map<String,Object> getMagazinesContent(Integer id,Integer userId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		try {
			if(null==id){
				map.put("msg", "参数错误");
				return map;
			}
			Map<String,Object> maps = new HashMap<String, Object>();
			maps.put("userId", userId);
			maps.put("id", id);
			Map result = productService.getMagazinesContent(maps);
			
			//获取期刊对应的买即送活动列表
			List<Map>buySiSongList=activityService.getBuyJiSongList(id,1);
			result.put("isBuySend", buySiSongList.isEmpty()?0:1);
			result.put("buySendList", buySiSongList);
			
			map.put("data", result);
			map.put("result", 1);
		} catch (Exception e) {
			map.put("msg", "获取失败");
		}
		return map;
	}
	
	/**
	 * 获取课程对应的详细信息
	 * 
	 * @Author LiTonghui
	 * 
	 * @return
	 * name 课程名称
	 * userName 大咖名称
	 * hits 播放次数
	 * presentPrice 课程现价
	 * synopsis 大咖简介
	 * introduce 课程简介
	 * menu 目录
	 * title 副标题
	 * IntendedFor 适用人群
	 * isSubscribe 是否被订阅 0否 1是
	 * classList 课时列表 [title,addTime,hits,minute,second] 
	 * 					课时标题，添加时间，播放次数，时长分钟，时长秒
	 * 
	 * 
	 * 
	 */
	@RequestMapping("/courseDetails")
	@ResponseBody
	@ApiOperation(value="获取课程对应的详细信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户的id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="classId",value="课程的id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={ondemandId='课程id',isAddress='是否需要添加地址0否1是',subIntroduce='过滤后的简介',introduce='未过滤的简介',yuanPrice='课程原价'}}")
	})
	public Map<String,Object> courseDetails(Integer userId,Integer classId){
		Map<String,Object> search = new HashMap<String,Object>();
		search.put("userId", userId);
		search.put("classId", classId);
		Map<String, Object> data = new HashMap<String, Object>();
		//课程详情
		Map<String,Object> map = productService.selCourseDetails(search);
		if(map==null){
			map=new HashMap<String,Object>();
		}
		pathService.getAbsolutePath(map, "picUrl");
		//获取课程对应的买即送活动列表
		int classtype=3;
		if(map.get("classtype") != null && Integer.parseInt(map.get("classtype")+"")==1){
			classtype=4;
		}
		List<Map>buySiSongList=activityService.getBuyJiSongList(classId,classtype);
		int isAddress=0;
		//查询赠送商品是否包含需要发货的赠品
		if(buySiSongList!=null && !buySiSongList.isEmpty()) {
			
			List<Integer> buyJiSongIds=buySiSongList.stream().map(f->{ return DataConvert.ToInteger(f.get("id"));}).distinct().collect(Collectors.toList());
				
				//获取活动赠送的商品列表
				List<Map>productList=activityService.getSendListForBuyJiSong(buyJiSongIds);
				if(productList!=null&&!productList.isEmpty()) {
					for (Map sub : productList) {
						if(1==DataConvert.ToInteger(sub.get("productType"))){
							isAddress=1;
							break;
						}
					}
					
				}
		}
		map.put("isBuySend", buySiSongList.isEmpty()?0:1);
		map.put("buySendList", buySiSongList);
		
		//课时
		List<Map> list = productService.selClassHour(search);
		map.put("classList", list);
		map.put("hourCount", list.size());
		map.put("isAddress", isAddress);
		if(map.size()>0){
			data.put("result", 1);
			data.put("msg", "获取成功！");
			data.put("data", map);
		}else{
			data.put("result", 0);
			data.put("msg", "获取失败！");
		}
		return data;
	}
	
	/*	
	 * 获取首页展示的课程分类
	 * @return
	 */
	@RequestMapping(value="/getClassType")
	@ApiOperation(value="获取首页展示的课程分类",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	public Map<String, Object> getClassType(Integer page,Integer pageSize){
		Map<String,Object> reqMap = new HashMap<String, Object>();
		reqMap = productService.getClassType(page,pageSize);
		return reqMap;
	}
	/**
	 * 获取课程对应的课时列表
	 * @return data{list:课时列表，IsBuyOndemand：当前课程是否已购买，1是0否}
	 */
	@RequestMapping(value="/getClassHourList")
	@ApiOperation(value="获取课程对应的课时列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="ondemandId",value="课程id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="paixu",value="排序DESC:倒叙,ASC:正序",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={hourId='课时id',title='标题',type='课时类型 （0视频 1音频 2ppt 3word 4 pdf）',"
				+ "abstracts='摘要',videoUrl='音视频地址',minute='分钟',vcloudChannel='直播频道',second='秒',IsAudition='是否是试听课时 0不是 1是',ondemandId='课程id',"
				+ "content='内容',starttime='开始时间',endtime='结束时间',presentation='文稿',hits='播放次数',addTime='课时添加时间',IsBuyOndemand='当前课程是否已购买，1是0否'}}")
	})
	public Map<String, Object> getClassHourList(Integer ondemandId,Integer userId,Integer page,Integer pageSize , String paixu){
		if(paixu==null||paixu.equals("")) {
			paixu = "DESC";
		}
		Map<String,Object> reqMap = new HashMap<String, Object>();
		reqMap = productService.getClassHourList(ondemandId,userId,page,pageSize,paixu);
		return reqMap;
	}
	
	/**
	 * 获取课时文稿
	 * @param ondemandId
	 * @param hourId
	 * @return
	 */
	@RequestMapping(value="/classPresentation")
	@ApiOperation(value="获取课时文稿",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="ondemandId",value="课程id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="hourId",value="课时id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={hourId='课时id',title='课时标题',abstracts='摘要',presentation='文稿'}}")
	})
	public Map<String, Object> classPresentation(Integer ondemandId,Integer hourId){
		Map<String,Object> reqMap = new HashMap<String, Object>(){
			{
				put("result", 0);
				put("msg", "参数错误！");
			}
		};
		if(ondemandId==null || hourId==null){
			return reqMap;
		}
		try {
			//查询课时文稿
			Map map = new HashMap();
			map.put("ondemandId", ondemandId);
			map.put("hourId", hourId);
			Map pre = productService.selClassPresentation(map);
			reqMap.put("data", pre);
			reqMap.put("result", 1);
			reqMap.put("msg", "获取成功!");
		} catch (Exception e) {
			reqMap.put("msg", "请求错误,"+e.getMessage());
		}
		return reqMap;
	}
	/**
	 * userId 用户id  
	 * addressId 地址id   
	 * shopCartIds 购物车不同期刊id（用","分隔）
	 * 
	 * @return
	 */
	@RequestMapping(value="/addOrderInfo")
	@ApiOperation(value="从购物车加入订单 ",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="addressId",value="地址id商品1纸质期刊2时必须有此值",dataType="String",required=false,paramType="query"),
		@ApiImplicitParam(name="shopCartIds",value="购物车项id",dataType="String",required=true,paramType="query"),
		@ApiImplicitParam(name="couponId",value="优惠券id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="voucherId",value="代金券id",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,msg='添加订单成功/失败',orderId='支付时的id值，为0则代表支付成功无需再进行支付',id='生成订单的id',totalPrice='价格'}")
	})
	public Map addOrderInfo(String userId,String addressId,String shopCartIds,Integer couponId,Integer voucherId){
		Map<String,Object> result = new HashMap<String, Object>();
		int userInfo = productService.selUserIsHave(userId);
		if(userInfo==0 || StringUtils.isEmpty(userId)){
			result.put("result", 0);
			result.put("msg", "用户信息不存在！");
			return result;
		}
	
		//筛选出是期刊的购物车项
		List<Map> list = productService.selBookIds(shopCartIds);
		if(null!=list && list.size()>0){
			if(StringUtils.isEmpty(addressId)){
				result.put("result", 0);
				result.put("msg", "请选择收货地址");
				return result;
			}
			String ids = "";
			for (Map map : list) {
				String id = DataConvert.ToString(map.get("id"));
				id+=",";
				ids+=id;
			}
			//查询商品是否下架
			int state = productService.selIsState(ids);
			if(state==0){
				result.put("result", 0);
				result.put("msg", "有已下架或不存在的商品！");
				return result;
			}
			//判断库存 暂时不考虑
			String[] shopCartIdsStr = ids.split(",");
			for (String str : shopCartIdsStr) {
				Map cartInfo = orderService.selQiciAndCount(str);//查询购物车当中的期次和购买数量
				if(cartInfo!=null){
					String[] qici = (cartInfo.get("qici")+"").split(",");
					int buyCount = Integer.parseInt(cartInfo.get("buyCount")+"");
					for (String qiciIds : qici) {
						Map qiciKucun = orderService.selQiciKucun(qiciIds);
						if(qiciKucun!=null){
							int kucun = Integer.parseInt(qiciKucun.get("stock")+"");
							if(buyCount>kucun){//当购买数量超出了期次的库存数量时
								result.put("result", 0);
								result.put("msg", qiciKucun.get("name")+"库存不足！");
								return result;
							}
						}else{
							continue;
						}
						
					}
				}else{
					result.put("result", 0);
					result.put("msg", "购物车没有此订单！");
					return result;
				}
			}
		}
		//添加订单信息
		Map<String,Object> info = new HashMap<String, Object>();
		info.put("userId", userId);
		info.put("addressId", addressId);
		info.put("shopCartIds", shopCartIds);
		info.put("couponId", couponId);
		info.put("voucherId", voucherId);
		Map map = productService.addOrderInfo(info);
		if(DataConvert.ToInteger(map.get("paylogId"))<0){
			result.put("result", 0);
			result.put("msg", "添加订单失败！");
		}else{
			result.put("orderId", map.get("paylogId"));
			result.put("id", map.get("orderId"));
			result.put("totalPrice", map.get("totalPrice"));
			result.put("result", 1);
			result.put("msg", "添加订单成功！");
		}
		return result; 
	}
	@RequestMapping(value="/getSumById")
	@ApiOperation(value="通过课程合集id获取合集信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="ondemandId",value="课程合集的id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageNow",value="页码",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={introduce='合集简介',list=[ondemandId='课程id',name='课程名称',title='副标题',serialState='连载状态（0非连载课程 1更新中 2已完结）',introduce='简介',"
				+ "IntendedFor='适应人群',classtype='0点播课程 1直播课程',IsRecommend='是否推荐(0不推荐1推荐)',picUrl='课程图片',originalPrice='原价',presentPrice='现价',"
				+ "IsGratis='是否是免费课程 0不是 1是',userId='教师的id',hourCount='课时数量',totalPage='总页数',currentPage='当前页',totalCount='总条数',studentNum='订阅人数',hits='播放次数',realname='教师真实姓名',nickName='教师昵称',synopsis='教师简介',isbuy='是否购买了，0未购买，大于0购买了']}}")
	})
	public Map<String,Object> getSumById(Integer ondemandId,Integer userId,Integer pageNow,Integer pageSize){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null==ondemandId || ondemandId<=0){
			map.put("msg", "参数错误");
			return map;
		}
		if(null==pageNow||null==pageSize || pageNow<=0 || pageSize<=0){
			map.put("msg", "参数错误");
			return map;
		}
		try {
			Map<String,Object> parmap = new HashMap<String, Object>();
			parmap.put("ondemandId", ondemandId);
			parmap.put("userId", userId);
			long totalCount = productService.getSumByIdCount(parmap);
			Page page = new Page(totalCount, pageNow, pageSize);
			parmap.put("start", page.getStartPos());
			parmap.put("pageSize", pageSize);
			List list = productService.getSumById(parmap);
			pathService.getAbsolutePath(list, "picUrl");
			/*Map result = productService.getIntroduceById(ondemandId);
			result.put("list", list);
			map.put("result", 1);*/
			map.put("result", 1);
			map.put("totalPage", page.getTotalPageCount());
			map.put("pageNow", pageNow);
			map.put("data", list);
			map.put("msg","获取数据成功");
		} catch (Exception e) {
			e.printStackTrace();
			map.put("msg", "获取数据失败");
		}
		return map;
	}
	
	
	@RequestMapping(value="/getMagazinesById")
	@ApiOperation(value="通过期刊合集id获取合集信息",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="id",value="期刊合集的id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='期刊id',name='期刊名称',paperPrice='纸质版价格',sales='已售数量',picture='主图',"
				+ "isbuy='用户是否已购买当前期刊对应的电子书0没有购买大于0已购买',"
				+ "status='是否有电子书0没有大于0有',sumType='0不是合集1上半年2下半年,3全年',year='合集的年份'}}")
	})
	public Map<String,Object> getMagazinesById(Integer id,Integer userId){
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("result", 0);
		if(null==id || id<=0){
			map.put("msg", "参数错误");
			return map;
		}
		try {
			Map<String,Object> parmap = new HashMap<String, Object>();
			parmap.put("id", id);
			parmap.put("userId", userId);
			List list = productService.getMagazinesById(parmap);
			pathService.getAbsolutePath(list, "pictureUrl");
			map.put("result", 1);
			map.put("data", list);
			map.put("msg","获取数据成功");
		} catch (Exception e) {
			map.put("msg", "获取数据失败");
		}
		return map;
	}
	
}
