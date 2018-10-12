<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

<c:if test="${!empty data.list }">
	<ul>
		<c:forEach items="${data.list }" var="hourlist">
			<li><a class="${classhourId==hourlist.hourId?'on':'' }" onclick="playVideo('${hourlist.hourId}','${hourlist.ondemandId }','${data.IsBuyOndemand }','${hourlist.IsAudition}');">${hourlist.title }</a></li>
		</c:forEach>
 	</ul>
</c:if>
<input type="hidden" id="Hid_TotalPage2" value="${pageTotal}">				
