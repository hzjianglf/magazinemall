<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%-- <c:if test="${error eq '请先登录' }" >
	<div class="error"><a href="../../../usercenter/account/index">${error }</a></div>
</c:if>
<c:if test="${!error eq '请先登录' }" > --%>
	<c:forEach var="item" items="${data }">
			<h4>· ${item.ColumnName}</h4>
			<c:forEach var="it" items="${item.data }">
					<a href="/usercenter/order/lookArticle?articleId=${it.DocID}"><p>${it.Title }</p></a>
			</c:forEach>
	</c:forEach>
<%-- </c:if> --%>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
