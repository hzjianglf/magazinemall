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
			<h3>${recommend > 0?'推荐':'全部课程' }</h3>
		</div>
		<div class="qbkc">
			<h2 id="kecheng">共有3个课程</h2>
			<div class="qbkc_lb" id="DIV_content">
				<div id="content"></div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				loadShuju();
			});
			function loadShuju(){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#DIV_content' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/home/recommendData",{
								page:page,
								pageSize:6,
								recommend:${recommend},
								teacherId:${teacherId},
								r:Math.random()
							},function(html){
								$("#content,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
								var count = $("#content").find("#count").val();
								$("#kecheng").text("共有"+count+"个课程");
							},"html")
					    }
					  });
				});
			}
			//课程详情
			function detail(ondemandId){
				window.location.href="/product/classDetail?ondemandId="+ondemandId;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
