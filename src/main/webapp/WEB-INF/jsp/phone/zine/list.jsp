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
			<a href="/home/index" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<!-- <div class="ss_div ss_div1">
				<img src="/images/ss_biao.png">
				<input type="text" id="searchName" class="in1" oninput="search();" value="" />
			</div> -->
		</div>
		<div class="zzjx">
			<div class="zzjx_top">
				<ul>
					<li><a href="javascript:void(0)" class="on" data-state="0"><span>|</span>按上架时间</a></li>
					<li><a href="javascript:void(0)" data-state="1">按销量</a></li>
				</ul>
			</div>
			<div class="zzjx_lb" id="det_content2">
				<div id="content"></div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				loadShuju(0);
			});
			$('.zzjx_top').find('li').click(function() {
				$('.zzjx_top').find('li').find('a').removeClass('on');
				$(this).find('a').addClass('on');
				var orderType = $(this).find('a').data('state');
				$("#content,#Div_Temp").html("");
				loadShuju(orderType,"");
			})	
			//搜索
			function search(){
				//获取当前选中的排序方式
				var orderType = $('.zzjx_top li a.on').attr('data-state');
				//输入的值
				var searchName = $("#searchName").val();
				$("#content,#Div_Temp").html("");
				loadShuju(orderType,searchName);
			}
			function loadShuju(orderType,searchName){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#det_content2' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/home/selectZine",{
								page:page,
								pageSize:6,
								orderType:orderType,
								search:searchName,
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
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
