<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<ul class="oh">
	<c:forEach items="${list }" var="item">
		<li>
			<img src="${item.productpic }" alt="" />
			<p>${item.productname }</p>
			<!-- 查看是否是赠品  5为赠品-->
			<c:if test="${item.subType==5}">
				<c:if test="${item.isbuy<=0 || item.status<=0}">
					<!-- 赠品下的合集为1-->
					<c:if test="${item.isPresentSign==1}">
						<a href="/product/turnPublicaDisplay?id=${item.productid }">
						  <span class="stateBtn">查看</span>
						</a>
					</c:if>
					<c:if test="${item.isPresentSign!=1}">
						<a href="/product/turnPublicationDetail?id=${item.productid }">
						   <span class="stateBtn">查看</span>
						</a>
					</c:if>
				</c:if>
				<c:if test="${item.isbuy>0 && item.status>0}">
					<!-- 赠品下的合集为1-->
					<c:if test="${item.isPresentSign==1}">
						<a href="/product/turnPublicaDisplay?id=${item.productid }">
						  <span class="stateBtn">查看</span>
						</a>
					</c:if>
					<c:if test="${item.isPresentSign!=1}">
						<a href="/product/getEBookContent?period=${item.planDesc }&type=1&pageNow=1&pageSize=1000">
						   <span class="stateBtn">查看</span>
						</a>
					</c:if>
				</c:if>
			</c:if>
			<c:if test="${item.subType!=5}">
				<c:if test="${item.isbuy<=0 || item.status<=0}">
					<c:if test="${item.subType>1}"><!-- 合集 -->
					<a href="/product/turnPublicaDisplay?id=${item.productid }">
					  <span class="stateBtn">查看</span>
					</a>
					</c:if>
					<c:if test="${item.subType==1}"><!-- 单期刊 -->
						<a href="/product/turnPublicationDetail?id=${item.productid }">
						<span class="stateBtn">查看</span>
						</a>
					</c:if>
				</c:if>
				<c:if test="${item.isbuy>0 && item.status>0}">
					<c:if test="${item.subType>1}"><!-- 合集 -->
					<a href="/product/turnPublicaDisplay?id=${item.productid }">
					  <span class="stateBtn">查看</span>
					</a>
					</c:if>
					<c:if test="${item.subType==1}"><!-- 单期刊 -->
						<a href="/product/getEBookContent?period=${item.planDesc }&type=1&pageNow=1&pageSize=1000">
						<span class="stateBtn">查看</span>
						</a>
					</c:if>
				</c:if>
			</c:if>
			<span class="stateBtn">
				<!-- 订单状态（1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中） -->
				<c:if test="${item.orderstatus=='2' }">待发货</c:if>
				<c:if test="${item.orderstatus=='3' }">待收货</c:if>
				<c:if test="${item.orderstatus=='4' }">已收货</c:if>
				<c:if test="${item.orderstatus=='5' }">已完成</c:if>
				<c:if test="${item.orderstatus=='6' }">已取消</c:if>
				<c:if test="${item.orderstatus=='7' }">退款中</c:if>
			</span>
		</li>
	</c:forEach>
</ul>
<div class="pagenum">
	<page:Page currentIndex="5" url="/usercenter/order/selectProduct" showPageInfo="true" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="selectProduct1"></page:Page>
</div>