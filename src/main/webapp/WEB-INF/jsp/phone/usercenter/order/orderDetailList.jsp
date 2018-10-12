<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

<c:if test="${type eq 1	 }">
	<c:set value="0" var="sum" />
	<c:set value="1" var="a" />
	<input type="hidden" id="orderId" value="${orderId }"/>
	<c:forEach items="${data.data }" var="dali">
		<div class="ddnr ddnr1">
			<span class="check_box"> <input type="checkbox" name="test"  data-val="${dali.invoicInfo.invoiceId }"></span>
				<div class="element" onclick="invoiceList('1','${orderId}','${dali.invoicInfo.invoiceId }')">
				<c:forEach items="${dali.list }" var="item">
					<img src="${item.picture }">
					<c:set value="${sum+item.count }" var="sum" />
				</c:forEach>
				</div>
				<div class="clear"></div>
				<h5 class="js_biao">共${sum}件商品 发货单号：${dali.list[0].expressNum }</h5>
				<c:set value="0" var="sum" />
			<div class="clear"></div>
		</div>
	</c:forEach>
	
	<div class="hj_qr">
		<a href="#" class="ljzf_biao" onclick="updOrderStatus()">确认收货</a>
	</div>
</c:if>

<c:if test="${type eq 2 }">
	<c:forEach items="${data.data }" var="item">
		<div class="ddnr ">
			<img src="${item.picture }">
			<div class="ddnr_r">
				<h2>${item.name }</h2>
				<h4>
					<span>x${item.count }</span>
				</h4>
			</div>
			<div class="clear"></div>
			<h5 class="js_biao">快递单号：${item.expressname }${item.expressNum }</h5>
		</div>
	</c:forEach>
</c:if>

<c:if test="${type eq 3 }">
	<c:forEach  items="${data.data }" var="item">
		<div class="ddnr ">
		<c:if test="${item.picture==null || item.picture==''}">
			<img src="/images/not.png">
		</c:if>
		<c:if test="${item.picture!=null}">
			<img src="${item.picture }">
		</c:if>
			<div class="ddnr_r">
				<h2>${item.name }</h2>
				<h4>
					<span>x${item.count }</span>
				</h4>
			</div>
			<div class="clear"></div>
		</div>
	</c:forEach>
</c:if>