<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
			.keShi ul li{
				cursor:pointer;
			}
			.dingYue{
				cursor:pointer;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="jianJie">
			<div class="jLeft">
				<img src="${data.picUrl }" alt="" />
			</div>
			<div class="jMiddle">
				<span class="kName">${data.name }</span>
				<p>
					类别：<span style="color:orange;">
					<c:if test="${data.serialState eq 0 }">非连载课程</c:if>
					<c:if test="${data.serialState eq 1 }">更新中</c:if>
					<c:if test="${data.serialState eq 2 }">已完结</c:if>
					</span> 
					创建时间：  
					<span style="color:orange;"><fmt:formatDate value="${data.creationTime }" pattern="yyyy-MM-dd"/></span>
				</p>
				<p class="boFang">
					<img src="/img/video.png" alt="" />
					<b>|</b>
					<span>
						<c:choose>
							<c:when test="${data.hits>10000}">${data.hits/10000}万</c:when>
							<c:otherwise>${data.hits}</c:otherwise>
						</c:choose>
						次播放
					</span>
				</p>
			</div>
			<div class="jRight">
				<!-- <a href="javascript:void(0)">举报</a> -->
				<p>￥${data.presentPrice }</p>
				<c:if test="${Double.parseDouble(data.presentPrice) != Double.parseDouble(data.yuanPrice) }">
					<p style="font-size: 14px;color:#888;text-decoration:line-through;margin-left:7px;">￥${data.yuanPrice }</p>
				</c:if>
				<c:if test="${data.isbuy=='0' }">
					<button class="dingYue" onclick="dingyue()">订阅</button>
				</c:if>
				<c:if test="${data.isbuy!='0' }">
					<button class="dingYue">已订阅</button>
				</c:if>
			</div>
		</div>
		<div class="jianJieCon">
			<span>简介：</span>
			<p>${data.introduce }</p>
		</div>
		<div class="keShi" id="keShi"></div>

</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			//订阅
			function dingyue(){
				$.ajax({
					type:'post',
					url:'/usercenter/account/inspectUserId',
					data:{},
					dataType:'json',
					success:function(data){
						if(!data.result){
							tipinfo(data.msg);
						}else{
							window.location.href="/product/payOndemand?ondemandId="+${data.ondemandId };
						}
					}
				});
				
			};
			
			$(function() {
				var ondemandId = ${data.ondemandId};
				classHout(ondemandId);
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
				var userId = ${userId==''?0:userId};
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
			} */
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
