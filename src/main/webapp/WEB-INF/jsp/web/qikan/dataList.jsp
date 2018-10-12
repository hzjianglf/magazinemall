<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
	<c:forEach items="${list }" var="item">
		<c:if test="${!(item.isbuy>0)  }">
			<li onclick="turnPublicationDetail(${item.id})">
				<img src="${item.picture }" alt="" />
				<div class="data-ins">
					<span>${item.name }</span>
					<p>
						<span>${item.year }</span>
						<span>${item.sales }人付款</span>
						<!-- <img src="/img/xin.png" alt="" /> -->
					</p>
				</div>
			</li>
		</c:if>
		<c:if test="${item.isbuy>0 }">
			<c:if test="${item.isbuy == 1}">
			<li onclick="turnEbook(${item.id},${item.period})">
				<img src="${item.picture }" alt="" />
				<div class="data-ins">
					<span>${item.name }</span>
					<p>
						<span>${item.year }</span>
						<span>${item.sales }人付款</span>
						<!-- <img src="/img/xin.png" alt="" /> -->
					</p>
				</div>
			</li>
			</c:if>
			<c:if test="${item.isbuy == 2 && item.sumType!=0 }">
			<li onclick="turnEbookheji(${item.id},${item.period})">
				<img src="${item.picture }" alt="" />
				<div class="data-ins">
					<span>${item.name }</span>
					<p>
						<span>${item.year }</span>
						<span>${item.sales }人付款</span>
						<!-- <img src="/img/xin.png" alt="" /> -->
					</p>
				</div>
			</li>
			</c:if>
			<c:if test="${item.isbuy == 2 && item.sumType==0 }">
			<li onclick="turnEbook(${item.id},${item.period})">
				<img src="${item.picture }" alt="" />
				<div class="data-ins">
					<span>${item.name }</span>
					<p>
						<span>${item.year }</span>
						<span>${item.sales }人付款</span>
						<!-- <img src="/img/xin.png" alt="" /> -->
					</p>
				</div>
			</li>
			</c:if>
		</c:if>
	</c:forEach>
<div class="clear"></div>
<div class="pagenum">
	<page:Page url="/product/qikanListData?type=${year}" showPageInfo="true" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="MainContent"></page:Page>
</div>