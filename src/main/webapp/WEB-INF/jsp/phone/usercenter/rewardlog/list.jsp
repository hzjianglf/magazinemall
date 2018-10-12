<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a onclick="fanhui();" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>打赏记录</h3>
		</div>
		<c:if test="${userType=='2' }">
			<div class="xxk">
				<ul>
					<li class="on" data-state="1"><em>|</em><span>我的打赏</span></li>
					<li data-state="2"><span>打赏我的</span></li>
				</ul>
			</div>
		</c:if>
		<div class="dsjl" id="Div_Scoll">
			<div id="MainContent"></div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//加载我的提问
				Rewardlog(1);
			});
			//切换效果
			$('.xxk').find('li').click(function() {
				$('.xxk').find('li').removeClass('on');
				$(this).addClass('on');
				Rewardlog($(this).data("state"));
				$("#MainContent,#Div_Temp").html("");
			});
			function Rewardlog(type){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#Div_Scoll' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/usercenter/account/RewardlogData",{
								page:page,
								pageSize:8,
								state:type,
								userId:'${userId}',
								r:Math.random()
							},function(html){
								$("#MainContent,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			function fanhui(){
				window.history.go(-1);
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
