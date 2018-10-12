<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css">
		<style>
			.kcItem li > img {
			    border: 0;
			    outline-width: 0px;
			    vertical-align: top;
			    width:140px;
			    height:140px;
			}
			.leftMenu li{
				cursor:pointer;
			}
			.pagenum{
				position:absolute;
				bottom:0;
				width:100%;
			}
			.page{
				margin:15px auto;
			}
			.kcList li{
				cursor:pointer;
			}
			.classContainer .kcItem {
    display: none;
    height: 100%;
    position: relative;
}
.classContent .classContainer {
    width: 1076px;
    height:auto;
    min-height: 720px;
    padding: 5px 10px;
    float: left;
    border: 1px solid #DDDDDD;
}
.classContainer .kcItem {
    min-height: 720px;
    position: relative;
}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
	<div class="kcState">
		<a href="javascript:void(0)" class="serialState" data-val="1">连载中</a>
		<a href="javascript:void(0)" class="serialState" data-val="2">完结</a>
		<a href="javascript:void(0)" class="serialState active" data-val="0">热门</a>
	</div>
	<div class="keChengBox">
		<p class="title">专家课程</p>
		<div class="classContent" style="overflow: hidden;">
			<div class="leftMenu">
				<ul>
					<li class="active" data-type="1">专家课程</li>
					<li data-type="2">白马营微课</li>
					<li data-type="4">营销书院</li> 
					<li data-type="3">听刊</li>
					<li data-type="8">快课</li>
				</ul>
			</div>
			<div class="classContainer">
				<div class="kcItem show" id="Content1"></div>
				<div class="kcItem" id="Content2"></div>
				<div class="kcItem" id="Content4"></div>
				<div class="kcItem" id="Content3"></div>
				<div class="kcItem" id="Content8"></div>
			</div>
		</div>
	</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript">
			$('.leftMenu ul li').click(function(){
				var inner = $(this).html();
				$(this).parents('.keChengBox').find('p.title').html(inner);
				$(this).addClass('active').siblings().removeClass('active');
				var index = $(this).index();
				$('.classContainer>div:eq('+ index +')').addClass('show').siblings().removeClass('show');
				//清空数据
				$('.classContainer>div').html("");
				//获取类型
				loadClass($(this).data('type'),$('.classContainer .show'));
			})
			
			//页面加载完执行数据
			$(function(){
				var type = '${type }';
				if(type!='1' && type!='2' && type!='3' && type!='4' && type!='8' && type!='0'){
					alert("操作有误！！！");
					$('.leftMenu li.active').click()
				}else{
					${type } < 1?$('.leftMenu li.active').click():$('.leftMenu  li[data-type='+${type }+']').click();
				}
			});
			
			//完结，连载中
			$('.serialState').click(function(){
				$(this).addClass("active").siblings().removeClass("active");
				loadClass($('.leftMenu .active').data('val'),$('.show'));
			});
			function nullDataList(obj){
				if(obj.text()==""||obj.text()==null){
					obj.html("<div class='defaultData'>暂无数据</div>");
				}
			}
			
			//防止操作频繁
			var flg = false;
			function loadClass(type,obj){
				if(flg){
					tipinfo("操作过于频繁！！！");
					return ;
				}
				flg = true;
				//完结，连载中
				var serialState = $('.kcState .active').data('val');
				$.get("/product/classDataList",{
					page:1,
					pageSize:16,
					type:type,
					serialState,serialState,
					async:false,
					r:Math.random()
				},function(html){
					obj.html(html);
					flg = false;
				},"html");
			}
			//详情
			function detail(ondemandId,isSum){
				if(isSum==0){
					window.location.href="/product/classDetail?ondemandId="+ondemandId;
				}else if (isSum==1){
					window.location.href="/home/ondemandCollections?ondemandId="+ondemandId;
				}
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>