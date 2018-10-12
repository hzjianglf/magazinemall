<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@  taglib  uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>

<div style="overflow: hidden;padding-bottom:80px;">
<ul class="kcList">
<c:forEach items="${list }" var="item">
		<li onclick="detail(${item.ondemandId},${item.isSum })">
			<img src="${item.picUrl }" alt="" />
			
			<span class="kcName">
			<c:if test="${fn:length(item.name)>12 }">
                  ${fn:substring(item.name, 0, 12)}...
            </c:if>
           <c:if test="${fn:length(item.name)<=12 }">
                  ${item.name }
            </c:if></span>
			<%-- ${item.title } --%>
		</li>
</c:forEach>
</ul>
</div>
<div class="clear"></div>
<div class="pagenum">
	<page:Page url="/product/classDataList?type=${type}&serialState=${serialState }" currentIndex="${type }" showPageInfo="true" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="Content${type }"></page:Page>
</div>