<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="cn.core.page" prefix="page" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

	<%-- <div class="dsjl_nr">
		<img src="${list.userUrl }">
		<div class="dsjl_wz">
			<h3>${(empty list.nickName)?list.realname:list.nickName } <em>${list.inputDate }</em></h3>
			<h4>${list.remark }</h4>
		</div>
		<div class="dsjl_je">${state=='1'?'-':'+' }${list.money }元</div>
		<div class="clear"></div>
	</div> --%>

<span>我的打赏</span>
<div class="ins-list">
	<table border="1" cellpadding="0" cellspacing="0">
		<thead>
			<tr>
				<th>时间</th>
				<th>专家</th>
				<th>打赏金额</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${list }" var="list">
			<tr>
				<td>${list.inputDate }</td>
				<td>${(empty list.nickName)?list.realname:list.nickName }</td>
				<td>${list.money }元</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
<div class="pageBox">
	<page:Page url="/usercenter/account/RewardlogData?state=${state}" numberLinkCount="2" currentIndex="4" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="dashang"></page:Page>
</div>
