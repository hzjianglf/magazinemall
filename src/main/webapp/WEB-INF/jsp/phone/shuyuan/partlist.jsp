<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@  taglib  uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>
	
			<ul>
			<c:forEach var="item" items="${list }">
				<li>
					<!-- <span class="hj_biao">合辑</span> -->
					<a href="/product/classDetail?ondemandId=${item.ondemandId }"><img src="${item.picUrl }"></a>
					<P>${fn:substring(item.name,0,10)}...<%-- <br> ${item.title } --%></P>
				</li>
			</c:forEach>
			</ul>


<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
