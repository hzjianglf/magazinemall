<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach var="item" items="${list}">
<c:if test="${type==1}">
	<div class="djq_lb">
		<div class="djq_nr">
			<div class="djq_nr_top">
				<h2><em>${item.price } </em></h2>
				<h5>${item.name }</h5>
				<div class="clear"></div>
			</div>
			<div class="djq_sj">
				<c:if test="${item.couponType==1 }">
					<span>品类券</span>
				</c:if>
				<c:if test="${item.couponType==2 }">
					<span>定向券</span>
				</c:if>
				${item.startTime }至${item.endTime }
			</div>
		</div>
	</div>
</c:if>
<c:if test="${type==2}">
	<div class="djq_lb">
		<div class="djq_nr djq_sx">
			<img src="/images/ysy_biao.png" class="ygq_biao">
			<div class="djq_nr_top">
				<h2><em>${item.price } </em></h2>
				<h5>${item.name }</h5>
				<div class="clear"></div>
			</div>
			<div class="djq_sj">
				<c:if test="${item.couponType==1 }">
					<span>品类券</span>
				</c:if>
				<c:if test="${item.couponType==2 }">
					<span>定向券</span>
				</c:if>
				${item.startTime }至${item.endTime }
			</div>
		</div>
	</div>
</c:if>
<c:if test="${type==0 }">
		<div class="djq_lb">
		<div class="djq_nr djq_sx">
			<img src="/images/ygq_biao.png" class="ygq_biao">
			<div class="djq_nr_top">
				<h2><em>${item.price } </em></h2>
				<h5>${item.name }</h5>
				<div class="clear"></div>
			</div>
			<div class="djq_sj">
				<c:if test="${item.couponType==1 }">
					<span>品类券</span>
				</c:if>
				<c:if test="${item.couponType==2 }">
					<span>定向券</span>
				</c:if>
				${item.startTime }至${item.endTime }
			</div>
		</div>
	</div>
</c:if>

</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
