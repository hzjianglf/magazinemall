<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list}" var="item">
	<div class="zzjx_nr">
		<img src="${item.productpic}">
		<div class="zzjx_nr_r">
			<h2>${item.productname}
				<c:if test="${item.subType==1 }">
					${item.pname }
				</c:if>
			</h2>
			<%-- <c:if test="${item.subType==0 }">
				<h3>${item.year } 单期</h3>
			</c:if>
			<c:if test="${item.subType==1 }">
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
			<c:if test="${item.subType==5}">
				<!-- 赠品下的合集为1-->
				<c:if test="${item.isPresentSign==1}">
					<c:if test="${item.subType!=1 }">
						<span class="yd_biao" onclick="openEBook(${item.id},${item.status })">阅 读</span>
					</c:if>
				</c:if>
				<c:if test="${item.isPresentSign!=1}">
					<c:if test="${item.subType==1 }">
						<span class="yd_biao" onclick="readEBook(${item.desc})">阅 读</span>
					</c:if>
				</c:if>
			</c:if>
			<c:if test="${item.subType!=5}">
				<c:if test="${item.subType==1 }">
					<span class="yd_biao" onclick="readEBook(${item.desc})">阅 读</span>
			    </c:if>
				<c:if test="${item.subType!=1 }">
					<span class="yd_biao" onclick="openEBook(${item.id},${item.status })">阅 读</span>
				</c:if>
			</c:if>
			
			
		</div>
		<div class="clear"></div>
	</div>
</c:forEach>	
<%-- <input type="hidden" id="Hid_TotalPage2" value="${pageTotal}">	 --%>			
