<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" type="both" dateStyle="long" pattern="yyyy-MM-dd" var="nowDate"/>
<ul class="yhqList oh">
<c:forEach var="item" items="${list}">
	<c:if test="${type==1}">
		<c:if test="${nowDate } - ${item.endTime} <= 24" var="rs">
			<li>
				<img class="guoQi" src="/img/yhqstate.png" alt="" /> ￥
				<span>${item.price }</span>
				<p class="manJian">${item.name }</p>
				<p class="dateIns">${item.startTime }-${item.endTime }</p>
			</li>
		</c:if>
		<c:if test="${!rs}">
			<li>
				￥<span>${item.price }</span>
				<p class="manJian">${item.name }</p>
				<p class="dateIns">${item.startTime }-${item.endTime }</p>
			</li>
		</c:if>
	</c:if>
	<c:if test="${type==2}">
		<li>
			￥<span>${item.price }</span>
			<p class="manJian">${item.name }</p>
			<p class="dateIns">${item.startTime }-${item.endTime }</p>
		</li>
	</c:if>
	<c:if test="${type==0 }">
		<li>
			￥<span>${item.price }</span>
			<p class="manJian">${item.name }</p>
			<p class="dateIns">${item.startTime }-${item.endTime }</p>
		</li>
	</c:if>
</c:forEach>
</ul>
<div class="pagenum">
	<page:Page currentIndex="11" url="/usercenter/account/daijingList?type=${type }" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="daijinquan"></page:Page>
</div>