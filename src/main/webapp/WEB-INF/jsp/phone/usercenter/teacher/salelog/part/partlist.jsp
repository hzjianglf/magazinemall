<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<table>
	<tr>
		<th style="width:30%">课程名称</th>
		<th style="width:20%">买家昵称</th>
		<th style="width:20%">价格</th>
		<th style="width:30%">时间</th>
	</tr>
	<c:forEach items="${list }" var="list" varStatus="cw">
		<tr>
			<c:if test="${fn:length(list.name)>12 }">
				<td>${fn:substring(list.name, 0, 12)}...</td>
			</c:if>
			<c:if test="${fn:length(list.name)<=12 }">
				<td>${list.name }</td>
			</c:if>
			<td>${list.nickName=""?list.realname:list.nickName }</td>
			<td><em>${list.totalprice }</em></td>
			<td>${list.addtime }</td>
		</tr>
	</c:forEach>
</table>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
