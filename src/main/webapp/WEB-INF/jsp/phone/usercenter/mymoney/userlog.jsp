<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	<style type="text/css">
		.fail{
			color:#808080;
		}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>交易记录</h3>
		</div>
		<div id="Div_Scoll">
			<div class="jyjl">
				<div id="zzbk_lb"></div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
		$(function() {
			LoadPage();
		});
		function LoadPage(){
			//信息流加载
			layui.use('flow', function(){
				  var flow = layui.flow;
				  flow.load({
				    elem: '#Div_Scoll' //流加载容器
				    , isAuto: true
	                , isLazyimg: true
				    ,done: function(page, next){ //执行下一页的回调
				    	$.ajax({
							type:"get",
							url:"/usercenter/mymoney/partialList?pageNow="+page,
							datatype:"html",
							success:function(data){
								//将返回的数据添加到隐藏div中
								//两个id一个为了展示内容，一个找到里边的独有pagetotal的id，每次都会清空临时的这个div
								$("#zzbk_lb,#Div_Temp").append(data);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
								$("#Div_Temp").html("");
								next("", page < totalPage);
							},
					    });
				    }
				  });
			});
		}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
