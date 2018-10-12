<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="list">
	<div class="zj_nr" onclick="detail('${list.userId}');">
		<img src="${list.userUrl }" style="border-radius: 10px;">
		<p style="color: #999999;">${list.synopsis }</p>
		<h3>${list.nickName }  <em>已发布：${list.ondemandCount }</em></h3>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
