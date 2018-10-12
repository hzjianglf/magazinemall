<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${data }" var="list">
	<div class="wddd_nr">
		<!-- orderstatus订单状态（1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中）  -->
		<!-- deliverstatus 发货状态 0未发货 1已发货 2部分发货 -->
			<%-- <c:forEach items="${list.itemList}" var="itemList">
				<c:if test="${itemList.producttypes!='4' && itemList.producttypes!='8'}"> --%>
		<div class="ddzt">
					<c:if test="${list.orderstatus=='1' }">
						等待买家付款
					</c:if>
					<c:if test="${list.orderstatus=='2' }">
						等待卖家发货
					</c:if>
					<c:if test="${list.orderstatus=='3' }">
						<c:if test="${list.orderstatus=='1' }">卖家已发货</c:if>
						<c:if test="${list.orderstatus=='2' }">卖家已部分发货</c:if>
					</c:if>
					<c:if test="${list.orderstatus=='4' }">
						待评价
					</c:if>
					<c:if test="${list.orderstatus=='5' }">
						订单已完成
					</c:if>
					<c:if test="${list.orderstatus=='6' }">
						订单已取消
					</c:if>
					<c:if test="${list.orderstatus=='7' }">
						退款中
					</c:if>
			<%-- 	</c:if>
			</c:forEach> --%>
		</div>
		<div class="ddnr" onclick="orderDetail('${list.orderId}');" data-status="${list.orderId}">
				<c:forEach items="${list.itemList}" var="imgList">
					<img src="${imgList.productpic }">
					<div class="ddnr_r">
							<h2><em>￥${imgList.buyprice }</em>${imgList.productname }</h2>
							<h3>
								<em>￥${imgList.yuanjia}</em>${imgList.years}
								<c:if test="${imgList.minQici==imgList.maxQici}">${imgList.minQici}</c:if>
								<c:if test="${imgList.minQici!=imgList.maxQici}">${imgList.minQici}-${imgList.maxQici}</c:if>
							</h3>
							<h4><span>x${imgList.count}</span><em>${imgList.goodsType }</em></h4>
					</div>
				</c:forEach>
				<c:forEach items="${list.itemList}" var="imgList">
					<c:forEach items="${imgList.buySendList}" var="buySendList">
						 <img src="${buySendList.productpic }">
					<div class="ddnr_r">
							<h2><em>赠品</em>${buySendList.productname }</h2>
							<h3>
								<em>￥${buySendList.yuanjia}</em>${buySendList.years}
								<c:if test="${buySendList.minQici==buySendList.maxQici}">${imbuySendListgList.minQici}</c:if>
								<c:if test="${buySendList.minQici!=buySendList.maxQici}">${buySendList.minQici}-${buySendList.maxQici}</c:if>
						    </h3>
							<h4><span>x1</span><em>${buySendList.goodsType }</em></h4>
					</div>
					</c:forEach>
				</c:forEach>
				<div class="ddnr_r ddnr_r1">
					<h5>共${list.itemCount }件商品   合计${list.totalprice }元（含运费￥${list.postage }）</h5>
				</div>
				<div class="clear"></div>
		
			<%-- <c:if test="${list.itemCount=='1' }">
				<c:forEach items="${list.itemList}" var="imgList">
				<img src="${imgList.productpic }">
				</c:forEach>
				<div class="ddnr_r">
					<c:forEach items="${list.itemList}" var="imgList">
						<h2><em>￥${list.totalprice }</em>${imgList.productname }</h2>
						<h3>
							<em>￥${imgList.yuanjia}</em>${imgList.years}年
							<c:if test="${imgList.minQici==imgList.maxQici}">${imgList.minQici}</c:if>
							<c:if test="${imgList.minQici!=imgList.maxQici}">${imgList.minQici}-${imgList.maxQici}</c:if>
						</h3>
						<h4><span>x${list.itemCount }</span><em>${imgList.goodsType }</em></h4>
					</c:forEach>
					<h5>共${list.itemCount }件商品   合计${list.totalprice }元（含运费￥${list.postage }）</h5>
				</div>
				<div class="clear"></div>
			</c:if>
			<c:if test="${list.itemCount!='1' }">
				<c:forEach items="${list.itemList}" var="imgList">
					<img src="${imgList.itemImg }" style="margin-left: 10px;margin-bottom: 5px;">
				</c:forEach>
				<div class="ddnr_r">
					<h5 class="js_biao">共${list.itemCount }件商品   合计${list.totalprice }元（含运费￥${(empty list.postage)?'0':list.postage }）</h5>
				</div> 
				<div class="clear"></div>
			</c:if> --%>
		</div>
		<!-- orderstatus订单状态（1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中）  -->
		<!-- paystatus支付状态 0未支付 1已支付  -->
		<!-- deliverstatus 发货状态 0未发货 1已发货 2部分发货 -->
		<div class="ddxx">
			<c:if test="${list.orderstatus=='1'}">
				<a onclick="turnzhifu(${list.orderId },${list.payLogId},${list.totalprice })">付款</a>
				<a onclick="updOrderStatus(6,${list.orderId});">取消订单</a>
			</c:if>
			<%-- <c:if test="${list.orderstatus=='2'}">
				<a href="#">申请退款</a>
			</c:if> --%>
			<c:if test="${list.orderstatus!='5' && list.orderstatus!='1' }">
				<!-- <a href="#">查看物流</a>
				<a href="#">延长收货</a> -->
				<a onclick="toDetails(4,${list.orderId});">确认收货</a>
			</c:if>
			<%-- <c:if test="${list.orderstatus=='4'}">
				<a onclick="updOrderStatus(5,${list.orderId});">评价</a>
				<!-- <a href="#">退货</a> -->
			</c:if> --%>
			<c:if test="${list.orderstatus=='5' || list.orderstatus=='6'}">
				<a onclick="delOrder(${list.orderId});">删除订单</a>
			</c:if>
		</div>
	</div>
</c:forEach>	
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
