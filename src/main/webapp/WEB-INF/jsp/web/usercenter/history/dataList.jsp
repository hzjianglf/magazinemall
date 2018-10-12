<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<ul class="keShiList">
	<li onclick="playVideo('${data.hourId}','${data.ondemandId }');" style="cursor:pointer;">
		<img src="/img/sousuo.png" alt="" />
		<span class="keShiName">
			${data.title }
		</span>
		<p class="keshiIns">
			<span>
				<img src="/img/play.png" alt="" />
				<c:choose>
					<c:when test="${data.hits>10000}">${list.hits/10000}万</c:when>
					<c:otherwise>${data.hits}</c:otherwise>
				</c:choose>
			</span>
			<span>${data.addTime }</span>
		</p>
	</li>
</ul>