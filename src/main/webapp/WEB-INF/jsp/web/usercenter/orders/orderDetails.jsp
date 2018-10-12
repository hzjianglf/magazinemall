<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

<h1 class="title">
		订单详情
	</h1>
	<p>
		订单编号：${data[0].orderno }
		<!-- <a href="javascript:void(0)">确认收货</a> -->
	</p>
	<div class="orderDetailCon">
		<p>${status }</p>
		<!-- <ul class="oh">
			<li class="first sel">待付款</li>
			<li class="sel">待发货</li>
			<li>待收货</li>
			<li>待评价</li>
			<li class="last">已完成</li>
		</ul> -->
		<p>${data[0].addtime }</p>
		<c:forEach items="${data[0].itemList }" var="item">
			<div class="shangPinXinXi">
				<p>商品信息</p>
				<table>
					<tbody>
						<tr>
							<td class="w100" rowspan="3">
								<img src="${item.productpic }" alt="" />
							</td>
							<td>${item.year }${item.productname }</td>
							<%-- <td class="w150">商品总额：¥${item.buyprice }</td> --%>
						</tr>
						<tr>
							<!-- <td>期刊杂志全年</td> -->
							<td>
								<c:if test="${item.producttypes==2}">
									<h4>纸媒版</h4>
								</c:if>
								<c:if test="${item.producttypes==16}">
									<h4>电子版</h4>
								</c:if>
							</td>
							<!-- <td class="w150">
								运费金额： 0
								<p>优惠券金额： 0</p>
							</td> -->
						</tr>
						<tr>
							<td>数量：${item.count }</td>
							<!-- <td class="w150">总额：¥6</td> -->
						</tr>
					</tbody>
				</table>
			</div>
		</c:forEach>
		
		
		
		
		<div class="jieSuanXinXi">
			<p>结算信息</p>
			<table border="1" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td class="center">收货人信息</td>
						<td class="center">支付方式</td>
						<!-- <td class="center">发票信息</td> -->
					</tr>
					<tr>
						<td>
							<div data-ordertype="${data[0].ordertype}" class="gwc_top" style=" background: #fff;display:none;">
									<p>收货人:${data[0].receivername }</p>
									<p>联系方式：${data[0].receiverphone }</p>
									<p>地址：${data[0].receiverAddress }</p>
							</div>
						</td>
						
						<td>
							<p>商品总额：¥${data[0].totalprice - data[0].postage }</p>
							<p>运费金额： ¥${(empty data[0].postage)?'0':data[0].postage }</p>
							<c:if test="${data[0].jianprice != null }">
								<p>优惠券金额： ¥${data[0].jianprice }</p>
							</c:if>
							<c:if test="${data[0].voucherPrice != null }">
								<p>代金券金额： ¥${data[0].voucherPrice }</p>
							</c:if>
							
							<p>支付金额：¥${status eq "等待买家付款"?0:data[0].payprice }</p>
							<c:if test="${data[0].methodName != null }">
								<p>支付方式：${data[0].methodName }</p>
							</c:if>
							<c:forEach items="${data[0].itemList }" var="itemby">
								<div data-ordertype="${data[0].ordertype}" class="gwc_top" style=" background: #fff;display:none;">
								<c:if test="${itemby.delivername != '' && itemby.delivername != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }">
									<p>快递公司：${itemby.delivername }</p>
								</c:if>
								<c:if test="${itemby.expressNum != '' && itemby.expressNum != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }">
									<p>快递单号：${itemby.expressNum }</p>
								</c:if>
								</div>
							</c:forEach>
						</td>
						<!-- <td>
							买家未填写发票信息
						</td> -->
					</tr>
				</tbody>
			</table>
		</div>
	</div>
	