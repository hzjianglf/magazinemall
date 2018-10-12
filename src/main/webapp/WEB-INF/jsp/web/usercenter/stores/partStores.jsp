<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<ul class="shouCangList oh">
<c:if test="${type==1 }">
	
	<c:forEach var="item" items="${list}">
			<li>
				<a href="/product/turnPublicationDetail?id=${item.id }"><img src="${item.picture }" alt="" /></a>
				<p>
					 <em>${item.bookName }</em>
					<img src="/img/shouCang.png" onclick="delCang(${item.favoriteId})" alt="" />
				</p>
			</li>
		
	</c:forEach>
</c:if>
<c:if test="${type==2 }">
	<c:forEach var="item" items="${list}">
			<li >
				<a href="/product/turnPublicationDetail?id=${item.id }"><img src="${item.userUrl }" alt="" /></a>
				<p>
					${item.name }
					<span>${item.studentNum}人付款</span>
					<img src="/img/shouCang.png" onclick="delCang(${item.id})" alt="" />
				</p>
			</li>
	</c:forEach>
</c:if>
</ul>
<%-- <div class="pagenum">
	<page:Page currentIndex="10" url="/usercenter/account/storeList?type=${type}" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="storeList"></page:Page>
</div> --%>