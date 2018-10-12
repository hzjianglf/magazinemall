<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="list">
	<div class="zzjx_nr">
		<a href="/product/turnPublicationDetail?id=${list.id }">
			<img src="${list.picture }">
			<div class="zzjx_nr_r">
				<h2>${list.name }</h2>
				<h3>${list.pname }  ${list.year }年度</h3>
				<h4>￥${list.paperPrice }</h4>
				<h5>${list.sales }人付款</h5>
			</div>
			<div class="clear"></div>
		</a>
	</div>
</c:forEach>	
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
