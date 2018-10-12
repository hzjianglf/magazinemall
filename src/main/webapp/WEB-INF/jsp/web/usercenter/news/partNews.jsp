<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>

<c:forEach var="item" items="${list}">
	<div class="xiaoXiItem">
		<p class="msgTime">${item.addTime}<%-- <fmt:formatDate value="${item.addTime}"  pattern="yyyy-MM-dd HH:mm:ss" /> --%></p>
		<div class="xiaoXiCon oh">
			<img src="${item.userurl }" alt="" />
			<div class="xiaoXiSec">
				<span>${item.realname }</span>
				<!-- <p>区块链是什么？</p>
				<div>回答：
					<p>区块链是分布式数据存储、点对点传输、共识机制、加密算法等计算机技术的新型应用模式。所谓共识机制是区块链系统中实现不同节点之间建立信任、获取权益的数学算法 。</p>
				</div> -->
				<div>
					<p>${item.content }</p>
				</div>
			</div>
		</div>
	</div> 
</c:forEach>
<div class="pagenum">
	<page:Page currentIndex="9" url="/usercenter/account/newsList" showPageInfo="true" ajaxPager="true" page="${pageInfo }" ajaxUpdateTargetId="personalNewList"></page:Page>
</div>