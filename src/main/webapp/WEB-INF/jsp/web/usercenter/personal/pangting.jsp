<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

	<%-- <div class="wdtw_nr">
		<h3 style="height:2.25rem;line-height:2.25rem;">
			<img src="${item.userUrl}" style="width: 1.6rem;height: 1.6rem;margin: 0 0.2rem;border-radius: 0.8rem;"> ${item.name }
		</h3>
		<div class="wdtw_wd">
			<h4>问：${item.content }</h4>
		</div>
		<div class="wdtw_sj">${item.inputTime }</div>
		<div class="wdtw_sj">
			<c:choose>
				<c:when test="${item.answerType == 1}">
					<audio src="${item.musicUrl}" controls="controls">
					</audio>
				</c:when>
				<c:when test="${item.answerType == 2}">
					<h4 style="font-size: 0.6rem;line-height: 1.5rem;">答：${item.answer }</h4>
				</c:when>
			</c:choose>
		</div>
	</div> --%>


<span>旁听</span>
<!-- <span>旁听我的</span> -->
<div class="ins-list">
	<ul>
	<c:forEach items="${list }" var="item" varStatus="cw">
		<li>
			<p>
				<img src="${item.userUrl}" alt="" />
			</p>
			<p class="ins-con">问： ${item.content }</p>
			<span>${item.inputTime }</span>
			<p>
			<c:choose>
				<c:when test="${item.answerType == 1}">
					<audio src="${item.musicUrl}" controls="controls">
					</audio>
				</c:when>
				<c:when test="${item.answerType == 2}">
					答：${item.answer }
				</c:when>
			</c:choose>
			</p>
		</li>
	</c:forEach>
	</ul>
</div>
<div class="pageBox">
	<page:Page currentIndex="2" url="/usercenter/account/myAudit?state=${state}" numberLinkCount="2" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="pangting"></page:Page>
</div>
			
