<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.textline{
				line-height: 20px;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
	   <div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>合集详情</h3>
		</div>
		<c:forEach items="${list }" var="list">
			<div class="zzjx_nr zzjx_nr1">
				<a href="/product/classDetail?ondemandId=${list.ondemandId }">
				<img src="${list.picUrl }">
				<div class="zzjx_nr_r">
					<h2 class="textline">${list.name }</h2>
					<h3>${list.realname }</h3>
					<span class="yd_biao">学 习</span>
				</div>
				</a>
				<div class="clear"></div>
			</div>
       </c:forEach>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script>
			function back(){
				window.history.go(-1);  	
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>

<input type="hidden" id="Hid_TotalPage3" value="${pageTotal}">		
