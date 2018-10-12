<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

					<ul>
					<c:forEach var="item" items="${list }">
						<li><a href="/usercenter/account/myquestions">
							<img src="${item.userurl }">
							<p>${item.realname } ${item.content }<br>${item.addTime}</p>
							</a>
						</li>
					</c:forEach>
					</ul>
					
	<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
