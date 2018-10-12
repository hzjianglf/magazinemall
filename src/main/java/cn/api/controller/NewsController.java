package cn.api.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.api.service.ApiResult;
import cn.api.service.NewsService;
import cn.api.service.PathService;
import cn.core.Sign;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

/**
 * 消息
 */
@Api(tags={"消息操作的接口"})
//@Sign
@RestController
@RequestMapping("/api/news")
public class NewsController {

	@Autowired
	NewsService newsService;
	@Autowired
	PathService pathService;
	
	
	/**
	 * 消息列表
	 */
	@RequestMapping("/getNewsList")
	@ApiOperation(value="获取消息列表",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query"),
		@ApiImplicitParam(name="page",value="页码",dataType="int",required=false,paramType="query"),
		@ApiImplicitParam(name="pageSize",value="页容量",dataType="int",required=false,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data={id='主键id',dataId='数据id(根据dataType区分为专家id和问答id)',dataType='数据类型：1--专家Id  2--问答Id',"
				+ "content='内容',type='消息类型：1--单向关注 2--双向关注 3--打赏 4--提问 5--回答',fromUserId='发送者id',fromUserType='发送者类型 是否是专家  0--否 1-是',"
				+ "addTime='添加时间',realname='发送者姓名'}}")
	})
	public Map<String, Object> GetNewsList(Integer userId,Integer page,Integer pageSize){
		Map<String, Object> map = new HashMap<String,Object>();
		Map<String, Object> reqMap = new HashMap<String,Object>(){
			{
				put("result", 0);
				put("msg", "参数错误!");
			}
		};
		
		if(userId==null) {
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
		//查询消息列表
		List list = newsService.selectNewList(map);
		
		pathService.getAbsolutePath(list, "userurl");
		
		reqMap.put("result", 1);
		reqMap.put("msg", "获取成功!");
		if(flag) {
			long count = newsService.selectNewsCount(map);
			int totalPage=(int)(count / pageSize )+(count % pageSize > 0 ? 1: 0);
        	reqMap.put("totalPage", totalPage);
        	reqMap.put("currentPage", page);
		}
		reqMap.put("data", list);
		return reqMap;
	}
	
	/**
	 * 获取新消息数量
	 */
	@RequestMapping("/getLatestNewsCount")
	@ApiOperation(value="获取用户新消息数量",httpMethod="GET")
	@ApiImplicitParams({
		@ApiImplicitParam(name="userId",value="用户id",dataType="int",required=true,paramType="query")
	})
	@ApiResponses({
		@ApiResponse(code=200,message="{result=0/1,data=新消息数量，msg=信息")
	})
	public Map<String, Object> getLatestNewsCount(Integer userId){
		ApiResult result=new ApiResult();
		
		if(userId==null||userId<=0) {
			result.setMessage("请输入用户Id");
		}else {
			
			long count=newsService.selectNewNewsCount(new HashMap<String,Object>(){
				{
					put("userId", userId);
				}
			});
			
			result.setResult(true, "获取新消息数量成功！",count);
		}
		
		return result.getResult();
		
	}
}
