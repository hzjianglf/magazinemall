<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
	 <style type="text/css">
		
	 </style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="btnGroup">
			<button onclick="isRecommend();">人气</button>
			<button onclick="latestExpertList();">最新</button>
		</div>
		<div class="checkOrder">
			<div id="MainContent" class="dataList"></div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			var layer;
			layui.use('layer', function(){
				layer = layui.layer;
			});
			$(function(){
				expertList();
			});
			function expertList(){
				$('.btnGroup>button').eq(1).removeClass("zuiXin").addClass("renQi").siblings().removeClass("renQi").addClass("zuiXin");
				$.get("/home/expert/expertList?IsRecommend=0",{
					page:1,
					pageSize:8,
					r:Math.random()
				},function(html){
					$("#MainContent").html(html);
				},"html")
			}
			
			function isRecommend(obj){
				$('.btnGroup>button').eq(0).removeClass("zuiXin").addClass("renQi").siblings().removeClass("renQi").addClass("zuiXin");
				$.get("/home/expert/expertList?IsRecommend=1",{
					page:1,
					pageSize:8,
					r:Math.random()
				},function(html){
					$("#MainContent").html(html);
				},"html")
			}
			function latestExpertList(){
				expertList();
			}
			function tipinfo(obj){
				layer.msg(obj);
			}
			//专家详情
			function expertDetail(userId){
				window.location.href="/home/expert/toExpertDetail?userId="+userId;
			}
			
			$(document).ajaxSuccess(function() {
				$("img").error(function() {
					$(this).attr("src", "/img/pcZJdefault.png");
				});
			});
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
