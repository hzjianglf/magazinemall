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
			<h3>消息中心</h3>
		</div>
		<div class="xxlb" id="dgScoll">
			<div id="scoll"></div>
		</div>
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
				//信息流加载
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#dgScoll' //流加载容器
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page,next){//执行下一页的回调
					    	$.get("/home/message/newsList",{
					    		pageNow:page
							},function(html){
								$("#scoll","#dgScoll").append(html);
								var totalPage =$("#dgScoll").find("#Hid_TotalPage").val();
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
		</script>
	</pxkj:Content>
	
</pxkj:ContentPage>
