<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			.jLeft img{
				width:140px;
				heigth:140px;
				border-radius:25px;
			}
			.layui-layer-content{
				color:#fff;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="jianJie">
			<div class="jLeft">
				<img src="${details.data.picUrl }" alt="" />
			</div>
			<div class="jMiddle">
				<span class="kName">${details.data.name }</span>
				<p>
					类别：<span>
							<c:if test="${details.data.serialState=='0' }">
								非连载课程
							</c:if>
							<c:if test="${details.data.serialState=='1' }">
								更新中
							</c:if>
							<c:if test="${details.data.serialState=='2' }">
								已完结
							</c:if>
					   </span> 
					   最后更新时间：
					<%-- <span>${details.data.creationTime }</span> --%>
					<span><fmt:formatDate value="${details.data.creationTime }" pattern="yyyy-MM-dd HH:mm:ss"/></span>
				</p>
				<p class="boFang">
					<img src="/img/video.png" alt="" />
					<b>|</b>
					<span>
						<c:choose>
							<c:when test="${details.data.hits>10000}">${details.data.hits/10000}万</c:when>
							<c:otherwise>${details.data.hits}</c:otherwise>
						</c:choose>
						次播放
					</span>
				</p>
			</div>
			<div class="jRight">
				<!-- <a href="javascript:void(0)">举报</a> -->
				<p>￥${details.data.presentPrice }</p>
				<c:if test="${details.data.isbuy=='0' }">
					<button class="dingYue" id="dingyue">订阅</button>
				</c:if>
				<c:if test="${details.data.isbuy!='0' }">
					<button class="dingYue">已订阅</button>
				</c:if>
			</div>
		</div>
		<input type="hidden" name="userId" id="userId" value="${userId}"/>
		<div class="jianJieCon">
			<span>简介：</span>
			<p>${details.data.introduce }</p>
		</div>
		<c:if test="${details.data.isBuySend > 0 }">
				<div class="cuXiao">
					促销
					<a class="song" href="javascript:void(0)">${details.data.buySendList[0].name }</a>
					${details.data.buySendList[0].remark }
				</div>
		</c:if>
		<div class="keChengBox">
			<p class="title">课程</p>
			<div class="qk-list">
			<ul class="oh">
				<c:forEach items="${collectionList.data }" var="ondemands">
					<%-- <c:if test="${not empty item.ondemandId}"> --%>
						<li>
							<a href="javascript:void(0);" onclick="toClassDetail(${ondemands.ondemandId })">
								<img src="${ondemands.picUrl }" alt="" />
								<%-- <span class="kcName">${ondemands.title }</span> --%>
							</a>
						</li>
					<%-- </c:if> --%>
				</c:forEach>
			</ul>
		</div>
			
			<%-- <div class="classContent">
				<table class="kcDataTable" cellpadding="0" cellspacing="0">
					<tbody>
						<tr>
							<c:forEach var="ondemands" items="${collectionList.data.list }">
								<td>
									<a href="/product/classDetail?ondemandId=${ondemands.ondemandId }">
										<a href="javascript:void(0);" onclick="toClassDetail(${ondemands.ondemandId })">
											<img src="${ondemands.picUrl }" alt="" />
											<span class="kcName">${ondemands.title }</span>
											<p>
												<img src="img/sousuo.png" alt="" /> ${ondemands.name }
											</p>
										</a>
									<!-- </a> -->
								</td>
							</c:forEach>
						</tr>
					</tbody>
				</table>
			</div> --%>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript">
			var layer;
			layui.use('layer', function(){
				layer = layui.layer;
			});
			//订阅
			$('#dingyue').click(function(){
				$.ajax({
					type:'post',
					url:'/usercenter/account/inspectUserId',
					data:{},
					dataType:'json',
					success:function(data){
						if(!data.result){
							tipinfo(data.msg);
						}else{
							window.location.href="/product/payOndemand?ondemandId="+${details.data.ondemandId };
						}
					}
				});
				
			}); 
			//合辑列表点击
			function toClassDetail(ondemandId){
				/* 
				var isSubscribe = ${details.data.isbuy}
				if(isSubscribe == 0){//未订阅
					tipinfo("请先订阅！")
					return false;
				}
				window.location.href="/product/classDetail?ondemandId="+ondemandId; */
				var isSubscribe = ${details.data.isbuy}
				if(isSubscribe == 0){//未订阅
					tipinfo("请先订阅！")
					return false;
				}
				$.ajax({
					type:'post',
					url:"/usercenter/account/inspectUserId",
					datatype:'json',
					success:function(data){
						if(data.result){
							window.location.href="/product/classDetail?ondemandId="+ondemandId;
						}else{
							tipinfo(data.msg);
						}
					},
					error:function(){
						alert("出错了!");
					}
				})
			}
			
			$(function() {
				//var ondemandId = ${data.ondemandId};
				//classHout(ondemandId);
			});
			
			function classHout(ondemandId){
				$.get("/product/selClassHour",{
					page:1,
					pageSize:6,
					ondemandId:ondemandId,
					r:Math.random()
				},function(html){
					$("#keShi").html(html);
				},"html")
			}
			
			//播放课时	IsBuyOndemand 是否购买了该课程（1是0否） IsAudition 是否是试听课时(1是0否)
			function playVideo(hourId,ondemandId,IsBuyOndemand,IsAudition){
				var userId = ${userId==null?0:userId};
				if(userId<1){
					tipinfo("请先登录！")
					return false;
				}
				//先判断是否购买了
				if(IsBuyOndemand=='0'){
					//未购买，判断是否是试听课时
					if(IsAudition=='0'){
						//跳转到购买页面
						window.location.href="/product/payOndemand?ondemandId="+ondemandId;
					}else{
						//未购买，但是是试听课时，则跳转播放界面
						window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
					}
				}else{
					//购买了
					window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
				}
			}
			//查询课时文稿	IsBuyOndemand 是否购买了该课程（1是0否） IsAudition 是否是试听课时(1是0否)
			/* function showArticle(hourId,ondemandId,IsBuyOndemand,IsAudition){
				//先判断是否购买了
				if(IsBuyOndemand=='0'){
					//未购买，判断是否是试听课时
					if(IsAudition=='0'){
						//跳转到购买页面
						window.location.href="/phone/product/payOndemand?ondemandId="+ondemandId;
					}else{
						//未购买，但是是试听课时，则跳转播放界面
						window.location.href="/phone/product/classPresentation?hourId="+hourId+"&ondemandId="+ondemandId;
					}
				}else{
					//购买了
					window.location.href="/phone/product/classPresentation?hourId="+hourId+"&ondemandId="+ondemandId;
				}
				event.stopPropagation(); 
			}
			function tipinfo(obj){
				layer.msg(obj);
			} */
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
