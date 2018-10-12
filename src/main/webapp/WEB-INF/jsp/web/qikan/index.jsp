<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<link rel="stylesheet" href="/css/global.css" />
		<style>
			.dataList li>img{
				width:177px;
				heigth:230px;
			}
			.dataList li{
				width: 25%;
			    float: left;
			    margin: 10px 0;
			    height: 302px;
			    min-height: 302px;
			    text-align: center;
			    cursor:pointer;
			}
			.qkList .tabBox li{
				cursor:pointer;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="qkList">
			<p class="title">期刊</p>
			<div class="tabBox" id="yearData">
				<ul>
					<c:forEach items="${years}" var="item">
						<li data-val="${item}">${item}</li>
					</c:forEach>
				</ul>
			</div>
			
			<div id="MainContent" class="dataList"></div>
			
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript">
			$('#yearData').find('li').click(function(){
				$('#yearData').find('li').removeClass("active");
				$(this).addClass("active");
				dataList($(this).data('val'));
			});
			
			$(function(){
				$("#yearData").find('ul>li:first').addClass("active");
				dataList($("#yearData").find('ul>li:first').html());
			});
			
			$(document).ajaxSuccess(function() {
				$("img").error(function() {
					$(this).attr("src", "/img/noImage.jpg");
				});
			});
			
			function dataList(year){
				$.get("/product/qikanListData?type="+year,{
					page:1,
					pageSize:8,
					r:Math.random()
				},function(html){
					$("#MainContent").html(html);
				},"html")
			}
			
			//跳入期刊详情（未登录或未购买）
			function turnPublicationDetail(bookId){
				if(bookId>0){
					location.href="/product/turnPublicationDetail?id="+bookId;
				}else{
					tipinfo("操作有误！！！");
				}
			}
			
			//期刊详情（已购买电子书的用户）
			function turnEbook(bookId,period){
				if(bookId>0){
					location.href="/product/getEBookContent?bookId="+bookId+"&period="+period;
				}else{
					tipinfo("操作有误！！！");
				}
			}
			
			//免登陆用户
			function turnEbookheji (bookId,period){
				if(bookId>0){
					location.href="/product/turnPublicaDisplay?id="+bookId;
				}else{
					tipinfo("操作有误！！！");
				}
			}
			function tipinfo(obj){
				layer.msg(obj);
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
