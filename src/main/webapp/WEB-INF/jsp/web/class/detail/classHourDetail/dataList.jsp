<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<p class="title">播放列表</p>
<ul>
<c:forEach items="${data.list }" var="list">
		<%-- <li >
			<img src="/img/sousuo.png" alt="" />
			<span class="keShiName">
				${list.title } ${list.IsAudition=='1'?'<button>试听</button>':'' }
			</span>
			<p class="keshiIns">
				<span>
					<img src="/img/play.png" alt="" />
					<c:choose>
						<c:when test="${list.hits>10000}">${list.hits/10000}万</c:when>
						<c:otherwise>${list.hits}</c:otherwise>
					</c:choose>
				</span>
				<span>${list.addTime }</span>
			</p>
		</li> --%>
		<li class="" onclick="playVideo('${list.hourId}','${list.ondemandId }','${data.IsBuyOndemand }','${list.IsAudition}');">
			<span class="bfName">
				<c:if test="${fn:length(list.title)>12 }">
                      ${fn:substring(list.title, 0, 12)}...
                </c:if>
				<c:if test="${fn:length(list.title)<=12 }">
                      ${list.title }
                </c:if>
			 ${list.IsAudition=='1'?'<button>试听</button>':'' }</span>
			<!-- <span class="bfzuozhe">包·恩和巴图</span> -->
			<span class="bfDate">${list.addTime }</span>
		</li>
</c:forEach>
</ul>
<div class="pagenum">
	<page:Page url="/product/selClassHour2?ondemandId=${ondemandId }" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="listMenuBox" />
</div>