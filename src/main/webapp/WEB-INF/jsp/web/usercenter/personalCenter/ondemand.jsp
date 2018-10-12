<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<ul class="oh">
	<c:forEach items="${list }" var="item">
	<li>
		<img src="${item.productpic }" alt="" style="width:240;height:240px;" />
		<p>${item.productname }</p>
		<p class="secondTitle">
			<!-- <img src="/img/sousuo.png" alt="" /> -->
		</p>
		<c:if test="${item.subType==5}">
			<!-- 赠品下的合集为1-->
			<c:if test="${item.isPresentSign==1}"><!-- 合集 -->
				<a href="/product/selectSumList?ondemandId=${item.productid }">
				  <span class="stateBtn">学 习</span>
				</a>
			</c:if>
			<c:if test="${item.isPresentSign!=1}"><!-- 单课程 -->
				<a href="/product/classDetail?ondemandId=${item.productid }">
				<span class="stateBtn">学 习</span>
				</a>
			</c:if>
		</c:if>
		<c:if test="${item.subType!=5}">
			<!-- 赠品下的合集为1-->
			<c:if test="${item.subType>1}"><!-- 合集 -->
				<a href="/product/selectSumList?ondemandId=${item.productid }">
				  <span class="stateBtn">学 习</span>
				</a>
			</c:if>
			<c:if test="${item.subType==1}"><!-- 单课程 -->
				<a href="/product/classDetail?ondemandId=${item.productid }">
				<span class="stateBtn">学 习</span>
				</a>
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
	<page:Page currentIndex="7" url="/usercenter/order/selectOndemand" showPageInfo="true" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="selectOndemand1"></page:Page>
</div>
