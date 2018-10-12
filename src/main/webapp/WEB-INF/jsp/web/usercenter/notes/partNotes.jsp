<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

<c:forEach var="item" items="${list}">
	<div class="biJiItem">
		<div class="biJiIns oh">
			<div class="biJiLeft">
				<img src="${item.userUrl}" alt="" />
			</div>
			<div class="biJiRight">
				<span>${item.name}</span>
				<p>${item.content}</p>
			</div>
		</div>
		<p>
			<span>${item.addTime}  添加了笔记</span>
			<a href="javascript:void(0)" onclick="cancelNode(this,${item.id})">
				<img src="/img/dele.png" alt="" />
			</a>
		</p>
	</div>
</c:forEach>
<div class="pagenum">
	<page:Page currentIndex="8" url="/usercenter/account/nodeList" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="notes"></page:Page>
</div>