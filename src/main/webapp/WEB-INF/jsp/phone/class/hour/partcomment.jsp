<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="item" varStatus="cw">
	<div class="kspj_nr">
		<img src="${item.userUrl }" class="tx_tu" style="border-radius: 50%;">
		<div class="kspj_nr_r">
			<h3>
				<c:if test="${item.userType=='2' }">
					<em>大咖</em>
				</c:if>
				${item.isAnonymity=='1'?'匿名':item.poster }
			</h3>
			<p class="pjnr">${item.content }</p>
			<h5>${item.dateTime } <a href="javascript:void(0)" onClick="showBox3('${item.id}','1','${item.userId }')">回复</a></h5>
			<c:if test="${!empty item.childList }">
				<div class="dkhf">
					<div class="triangle-up"></div>
					<c:forEach items="${item.childList }" var="childList">
						<p> 
							<c:if test="${childList.userType=='2' }">
								<span>大咖</span>
							</c:if>
							<em>${childList.isAnonymity=='1'?'匿名':childList.poster }：</em>${childList.content }
						</p>
					</c:forEach>
				</div>
			</c:if>
		</div>
		<div class="clear"></div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
