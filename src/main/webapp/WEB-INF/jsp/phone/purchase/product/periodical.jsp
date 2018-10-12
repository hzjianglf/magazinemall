<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="item">
    
	<div class="zzjx_nr">
		<img src="${item.productpic }">
		<div class="zzjx_nr_r">
			<h2>${item.productname }
				<c:if test="${item.subType==1 }">
					${item.pname }
				</c:if>
			</h2>
			<%-- <c:if test="${item.subType==1 }">
				<h3>${item.year } 单期</h3>
			</c:if>
			<c:if test="${item.subType==2 }">
				<h3>${item.year } 上半年刊</h3>
			</c:if>
			<c:if test="${item.subType==3 }">
				<h3>${item.year } 下半年刊</h3>
			</c:if>
			<c:if test="${item.subType==4 }">
				<h3>${item.year } 全年</h3>
			</c:if> --%>
			<!-- 查看是否是赠品  5为赠品-->
			<c:if test="${item.subType==5}">
				<c:if test="${item.isbuy<=0 || item.status<=0}">
					<!-- 赠品下的合集为1-->
					<c:if test="${item.isPresentSign==1}">
						<a href="/product/selectProudctListByCollection?id=${item.productid }">
<!-- 						  <span class="yd_biao">查看</span>
 -->						</a>
					</c:if>
					<c:if test="${item.isPresentSign!=1}">
						<a href="/product/turnPublicationDetail?id=${item.productid }">
						   <!-- <span class="yd_biao">查看</span> -->
					    </a>
					</c:if>
				</c:if>
				<c:if test="${item.isbuy>0 && item.status>0}">
				    <!-- 赠品下的合集为1-->
					<c:if test="${item.isPresentSign==1}">
						<a href="/product/selectProudctListByCollection?id=${item.productid }">
						 <!--  <span class="yd_biao">查看</span> -->
						</a>
				    </c:if>
					<c:if test="${item.isPresentSign!=1}">
						<a href="/usercenter/order/getEBookContent?pubId=${item.planDesc }&type=1&pageNow=1&pageSize=1000">
						  <!--  <span class="yd_biao">查看</span> -->
					    </a>
					</c:if>
				</c:if>
			</c:if>
			<c:if test="${item.subType!=5}">
				<c:if test="${item.isbuy<=0 || item.status<=0}">
					<c:if test="${item.subType>1}"><!-- 合集 -->
					<a href="/product/selectProudctListByCollection?id=${item.productid }">
					  <!-- <span class="yd_biao">查看</span> -->
					</a>
			    	</c:if>
					<c:if test="${item.subType==1}"><!-- 单期刊 -->
						<a href="/product/turnPublicationDetail?id=${item.productid }">
						<!-- <span class="yd_biao">查看</span> -->
						</a>
					</c:if>
				</c:if>
				<c:if test="${item.isbuy>0 && item.status>0}">
					<c:if test="${item.subType>1}"><!-- 合集 -->
					<a href="/product/selectProudctListByCollection?id=${item.productid }">
					  <!-- <span class="yd_biao">查看</span> -->
					</a>
			    	</c:if>
					<c:if test="${item.subType==1}"><!-- 单期刊 -->
						<a href="/usercenter/order/getEBookContent?pubId=${item.planDesc }&type=1&pageNow=1&pageSize=1000">
						<!-- <span class="yd_biao">查看</span> -->
						</a>
					</c:if>
				</c:if>
			</c:if>
			
			<!-- 订单状态（1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中）  -->
			<c:if test="${item.orderstatus=='2' }"><span class="dsh_biao" onclick="toDetails(4,${item.orderId })">等待卖家发货</span></c:if>
			<c:if test="${item.orderstatus=='3' }"><span class="dsh_biao">待收货</span></c:if>
			<c:if test="${item.orderstatus=='4' }"><span class="dsh_biao">已收货</span></c:if>
			<c:if test="${item.orderstatus=='5' }"><span class="ywc_biao">已完成</span></c:if>
			<c:if test="${item.orderstatus=='6' }"><span class="dsh_biao">已取消</span></c:if>
			<c:if test="${item.orderstatus=='7' }"><span class="dsh_biao">退款中</span></c:if>
		</div>
		<div class="clear"></div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage1" value="${pageTotal}">				
