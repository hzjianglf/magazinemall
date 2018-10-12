<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<p class="title">课时</p>
<ul class="keShiList">
<c:forEach items="${data.list }" var="list">
		<li onclick="playVideo('${list.hourId}','${list.ondemandId }','${data.IsBuyOndemand }','${list.IsAudition}');">
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
		</li>
</c:forEach>
</ul>
<div class="pagenum">
	<page:Page url="/product/selClassHour?ondemandId=${ondemandId }" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="keShi" />
</div>