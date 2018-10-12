<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<!-- <h3>专栏作家</h3>
			<a href="#" class="a2"><img src="/images/ss_biao.png" class="ss_biao"></a> -->
			<!-- <div class="ss_div ss_div1" onclick="turnSel()">
				<img src="/images/ss_biao.png"> 
				<input type="text" class="in1" />
			</div> -->
		</div>
		<div id="contentAll">
			<div class="zlzj_lb" style="display: inline-block;" >
				<div id="content"></div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			function turnSel(){
				window.location.href = "/home/turnSearche";
			}
			$(function() {
				loadShuju();
			});
			function loadShuju(){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#contentAll' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/home/selTeacherList",{
								page:page,
								pageSize:6,
								IsRecommend:${IsRecommend},
								r:Math.random()
							},function(html){
								$("#content,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			//专家详情
			function detail(userId){
				window.location.href="/home/teacherDetail?userId="+userId;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
