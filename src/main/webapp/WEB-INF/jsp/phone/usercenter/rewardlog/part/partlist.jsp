<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="list">
	<div class="dsjl_nr">
		<img src="${list.userUrl }">
		<div class="dsjl_wz">
			<h3>${(empty list.nickName)?list.realname:'' } <em>${list.inputDate }</em></h3>
			<h4>${list.remark }</h4>
		</div>
		<div class="dsjl_je">${state=='1'?'-':'+' }${list.money }元</div>
		<div class="clear"></div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
