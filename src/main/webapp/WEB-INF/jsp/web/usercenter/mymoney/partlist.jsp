<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach var="item" items="${list}">
	<div class="jyjl_bt">
		<h3>${item.year}</h3>
		<h4>支出：${item.consumTotal} 收入：${item.incomeTotal-item.failMoney }</h4>
	</div>
	<div class="jyjl_lb">
		<c:forEach var="ite" items="${item.data}">
				<div class="jyjl_nr">
					<div class="jyjl_biao">
						<c:if test="${ite.types=='充值'}">
						<img src="/images/cz_biao.png">
						</c:if>
						<c:if test="${ite.types=='购买' }">
						<img src="/images/gm_biao.png">
						</c:if>
						<c:if test="${ite.types=='提问' }">
						<img src="/images/tw_biao.png">
						</c:if>
						<c:if test="${ite.types=='旁听' }">
						<img src="/images/pt_biao.png">
						</c:if>
						<c:if test="${ite.types=='打赏' }">
						<img src="/images/ds_biao.png">
						</c:if>
						<c:if test="${ite.types=='提问退款' }">
						<img src="/images/twtk_biao.png">
						</c:if>
						<c:if test="${ite.types=='平台收益' }">
						<img src="/images/ptsy_biao.png">
						</c:if>
						<c:if test="${!(ite.types=='充值'&& ite.paystatus==0)}">
						<p>${ite.types}</p>
						</c:if>
						<c:if test="${(ite.types=='充值'&& ite.paystatus==0)}">
						<p>${ite.types}失败</p>
						</c:if>
					</div>
					<h3>
						${ite.num}<br>
						<span>${ite.time}</span>
					</h3>
					<c:if test="${!(ite.types=='充值'&& ite.paystatus==0)}">
					<h4 class="${ite.status==1?'jia':'jian'}">${ite.status==1?'+':'-'}${ite.money}</h4>
					</c:if>
					<c:if test="${(ite.types=='充值'&& ite.paystatus==0)}">
					<h4 class="fail">${ite.money}</h4>
					</c:if>
					<div class="clear"></div>
				</div>
		</c:forEach>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
