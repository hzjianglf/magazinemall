<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<table class="orderItem" border="1" cellpadding="0" cellspacing="0" id="totalOrder">
	<c:forEach var="item" items="${data}">
	<tbody>
			<tr>
				<td class="w500" onclick="orderDetail('${item.orderId}','${item.orderstatus}');">
					<p>
						<!-- 时间： --> 订单编号：${item.orderno}
					</p>
					<c:forEach items="${item.itemList}" var="imgList">
						<img class="proImg" src="${imgList.productpic }" alt="" />
						<div class="proIns">
							<h1>${imgList.productname }</h1>
							<span>${imgList.goodsType }</span>
							<p>￥${imgList.buyprice }</p>
							<%-- <p><s>￥${imgList.yuanjia}</s></p> --%>
							<!-- <span>单期</span> -->
							<p>数量：${imgList.count }</p>
						</div>
					</c:forEach>
					<c:forEach items="${item.itemList}" var="imgList">
						<c:forEach items="${imgList.buySendList}" var="buySendList">
							<img class="proImg" src="${buySendList.productpic }" alt="" />
							<div class="proIns">
								赠品:<h1>${buySendList.productname }</h1>
								<span>${buySendList.goodsType }</span>
								<p>￥${buySendList.buyprice }</p>
								<%-- <p><s>￥${buySendList.yuanjia}</s></p> --%>
								<!-- <span>单期</span> -->
								<!-- <p>数量：1</p> -->
								<p>x1</p>
							</div>
						</c:forEach>
					</c:forEach>
					
				</td>
				<!-- <td class="w180">
					张三
				</td> -->
				
				
				<td class="payIns">
					<p>￥${item.totalprice }</p>
					<%-- <p><s>￥${imgList.yuanjia}</s></p> --%>
					<p>运费${item.postage }元</p>
					<p>共${item.itemCount }件商品</p>
					<!-- <p>余额支付</p> -->
				</td>
				
				<td>
					<c:if test="${item.orderstatus=='1' }">
						等待买家付款
					</c:if>
					<c:if test="${item.orderstatus=='2' }">
						等待卖家发货
					</c:if>
					<c:if test="${item.orderstatus=='3' }">
						<c:if test="${item.orderstatus=='1' }">卖家已发货</c:if>
						<c:if test="${item.orderstatus=='2' }">卖家已部分发货</c:if>
					</c:if>
					<c:if test="${item.orderstatus=='4' }">
						待评价
					</c:if>
					<c:if test="${item.orderstatus=='5' }">
						订单已完成
					</c:if>
					<c:if test="${item.orderstatus=='6' }">
						订单已取消
					</c:if>
					<c:if test="${item.orderstatus=='7' }">
						退款中
					</c:if>
					
				</td>
				 <td>
					 <c:if test="${item.isHasInvoice > 0 }">
						<button><a onclick="toDetails(4,${item.orderId});">确认收货</a></button>
					</c:if>
				 	<c:if test="${item.orderstatus=='1'}">
						<button><a onclick="turnzhifu(${item.orderId },${item.payLogId},${item.totalprice })">去付款</a></button>
						<button><a onclick="updOrderStatus(6,${item.orderId});">取消订单</a></button>
					</c:if>
			   	 </td>
			</tr>
			<tr>
			
			</tr>
			
		</tbody>
</c:forEach>
</table>

<div class="pagenum">
	<c:if test="${orderType=='-1' }">
		<page:Page url="/usercenter/order/selectPersonalOrders?orderStatus=-1" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="totalOrder"></page:Page>
	</c:if>
	<c:if test="${orderType=='1' }">
		<page:Page url="/usercenter/order/selectPersonalOrders?orderStatus=1" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="totalOrder"></page:Page>
	</c:if>
	<c:if test="${orderType=='5' }">
		<page:Page url="/usercenter/order/selectPersonalOrders?orderStatus=5" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="totalOrder"></page:Page>
	</c:if>
	<c:if test="${orderType=='6' }">
		<page:Page url="/usercenter/order/selectPersonalOrders?orderStatus=6" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="totalOrder"></page:Page>
	</c:if>
</div>