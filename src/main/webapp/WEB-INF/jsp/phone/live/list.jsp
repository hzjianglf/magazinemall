<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@  taglib  uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>
<pxkj:ContentPage materPageId="PhoneMaster">

	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>直播</h3>
		</div>
		<div class="djq">
			<div class="det_content2">
				<div class="zjkc" id="det_content2">
					<div id="MainContent"></div>
				</div>
				<div id="Div_Temp" style="display:none"></div>
			</div>
		</div>
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
		$(function() {
			loadShuju(1);
		});
		//样式选中
		$('.xxk').find('li').click(function() {
			$('.xxk').find('li').removeClass('on');
			$(this).addClass('on');
			//取值
			loadShuju($(this).data('type'));
		});
		function loadShuju(type){
			layui.use('flow', function(){
				  var flow = layui.flow;
				  flow.load({
				    elem: '#det_content2' //流加载容器 
				    , isAuto: true
	                , isLazyimg: true
				    ,done: function(page, next){ //执行下一页的回调
				    	$.get("/live/selectLive",{
							page:page,
							pageSize:6,
							type:type,
							r:Math.random()
						},function(html){
							$("#MainContent,#Div_Temp").html(html);
							var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
				        	$("#Div_Temp").html("");
							next("", page < totalPage);
						},"html")
				    }
				  });
			});
		}
		//详情
		function detail(ondemandId){
			window.location.href="/live/liveDetail?ondemandId="+ondemandId;
		}
		//订阅
		function subscribe(ondemandId){
			window.location.href="/live/payOndemand?ondemandId="+ondemandId;
		}
		</script>
	</pxkj:Content>
	
</pxkj:ContentPage>
