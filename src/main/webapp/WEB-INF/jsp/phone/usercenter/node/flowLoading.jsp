<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list}" var="item">
	<div class="xxjl_lb" id="div_${item.id}">
		<div class="xxjl_nr" style="border-bottom: 0.025rem solid #ccc;background: #fff;    padding-top: 0.5rem;">
			<div class="xxjl_xq">
				<h3><img src="${item.userUrl}"><p style="width: 80%;float: right;padding: 0;font-size: 0.75rem;color: #333;line-height: 1rem;">${item.name}</p></h3>
				<p>${item.content}</p>
			</div>
			<div class="xxkl_sj">
				${item.addTime}
				<img src="/images/gd_biao.png" onclick="cancelNode(${item.id})" />
			</div>
		</div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
