<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	<style>
		body {
			background: #fafafa;
		}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>课程</h3>
		</div>
		<div class="djq">
			<div class="xxk xxk2">
				<ul>
					<li class="${type==null||type==1?'on':''}" data-type="1"><span>专家课程</span></li>
					<li class="li1 ${type==2?'on':''}" data-type="2"><span>白马营微课</span></li>
					<li class="${type==8?'on':''}" data-type="8"><span>快课</span></li>
				</ul>
			</div>
			<div class="det_content2">
				<div class="zjkc" id="det_content_1">
					<div id="MainContent_1"></div>
				</div>
				<div id="Div_Temp_1" style="display:none"></div>
				
				<div class="zjkc layui-hide" id="det_content_2">
					<div id="MainContent_2"></div>
				</div>
				<div id="Div_Temp_2" style="display:none"></div>
				
				<div class="zjkc layui-hide" id="det_content_8">
					<div id="MainContent_8"></div>
				</div>
				<div id="Div_Temp_8" style="display:none"></div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				clickOn($(".xxk2 li.on"));
			});
			//样式选中
			$('.xxk').find('li').bind("click",function() {
				clickOn(this);
			});
			//点击效果
			function clickOn(Obj){
				//选取id前几个字母是det_content_的数组
				$("[id^='det_content']").addClass("layui-hide");
				$('.xxk').find('li').removeClass('on');
				$(Obj).addClass('on');
				//取值
				var type = $(Obj).data('type');
				$("#det_content_"+type).removeClass("layui-hide");
				$("[id^='MainContent'],[id^='Div_Temp']").html("");
				loadShuju(type,Obj);
			}
			var flg = false;
			function loadShuju(type,Obj){
				layui.use(['flow','layer'], function(){
					  var flow = layui.flow,
					  layer = layui.layer;
					  flow.load({
					    elem: '#det_content_'+type //流加载容器 
					    , isAuto: true
					    , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	if(flg){
								return ;
							}
							flg = true;
					    	$.get("/product/selectClass",{
								page:page,
								pageSize:10,
								type:type,
								r:Math.random(),
								async:true
							},function(html){
								$("#MainContent_"+type+",#Div_Temp_"+type).append(html);
								var totalPage =$("#Div_Temp_"+type).find("#Hid_TotalPage").val();
								next("", page < totalPage);
								flg = false;
							},"html");
					    }
					  });
				});
			}
			//详情
			function detail(ondemandId){
				window.location.href="/product/classDetail?ondemandId="+ondemandId;
			}
			//订阅
			function subscribe(ondemandId){
				window.location.href="/product/payOndemand?ondemandId="+ondemandId;
			}
			
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
