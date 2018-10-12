<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>


	<!-- <p>
		订单编号：20180710112804115
	</p> -->
	<c:if test="${type eq 1	 }">
		<div class="daiQueRen">
			<p>待确认收货</p>
			<ul class="oh">
				<c:forEach items="${data.data }" var="dali">
					<li>
						<input type="checkbox" name="test" id="check_5" value="${orderId }" data-val="${dali.invoicInfo.invoiceId }"/>
						<div>
							<img src="${dali.list[0].picture }" />
							<p>${dali.list[0].name }</p>
							<p> 发货单号：${dali.list[0].expressNum }</p>
						</div>
					</li>
				</c:forEach>
			</ul>
			<div>
				<a href="#" onclick="confirmToReceiveRight()">确认无误，请收货</a>
			</div>
		</div>
	</c:if>
	<%-- <c:if test="${type eq 2 }">
		<div class="weiQueRen">
			<p>已确认收货</p>
			<ul class="oh">
			<c:forEach items="${data.data }" var="item">
					<li>
						<div>
							<img src="${item.picture }" />
							<p>${item.name }</p>
							<p> 快递单号：${item.expressname }${item.expressNum }</p>
						</div>
					</li>
			</c:forEach>
			</ul>
		</div>
	</c:if>
	<c:if test="${type eq 3 }">
		<div class="weiQueRen">
			<p>未发货</p>
			<ul class="oh">
				<c:forEach  items="${data.data }" var="item">
					<li>
						<div>
							<c:if test="${item.picture==null || item.picture==''}">
								<img src="/phone/images/not.png">
							</c:if>
							<c:if test="${item.picture!=null}">
								<img src="${item.picture }">
							</c:if>
							<p>${item.name }</p>
						</div>
					</li>
				</c:forEach>
				
			</ul>
		</div>
	</c:if> --%>
	
	