<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	<style type="text/css">
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png"
				class="fh_biao"></a>
			<h3>代金券</h3>
		</div>
		<div class="djq">
			<div class="xxk">
				<ul>
					<li style="width:33%" class="on" data-val="1"><em>|</em><span>未使用</span></li>
					<li style="width:33%" data-val="2"><em>|</em><span>已使用</span></li>
					<li style="width:33%" data-val="0"><span>已过期</span></li>
				</ul>
			</div>
			<div id="Div_Scoll">
				<div class="det_content2">
					<div id="zzbk_lb"></div>
				</div>
			</div>
		</div>
		
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					var type = $(this).data("val");
					$("#zzbk_lb,#Div_Temp").html("");
					LoadPage(type);
				});
			});
		</script>
		<script type="text/javascript">
		$(function() {
			LoadPage(1);
		});
		function LoadPage(type){
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
					        url:"/usercenter/voucher/dataList?pageNow="+page+"&type="+type,
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
