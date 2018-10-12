<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="item" varStatus="cw">
	<div class="plItem">
		<div class="plCon">
			<div class="replayText">
				<textarea name="" rows="" id="abc" placeholder="请输入内容" cols=""></textarea>
				
				<div style="text-align:right;">
					<button style="cursor:pointer;" onclick="Publish(this);" class="huiFuBtn">回复</button>
				</div>
			</div>
			<img src="${item.userUrl }" alt="" />
			<div class="pl-sec">
				<p class="pl-name">${item.isAnonymity=='1'?'匿名':item.poster }</p>
				<p class="pl-con">${item.content }</p>
				<p class="pl-date">
					<span>${item.dateTime }</span>
					<a href="javascript:void(0)" onclick="showBox3(this,'${item.id}','1','${item.userId }')">回复</a>
				</p>
			</div>
		</div>
		<c:if test="${!empty item.childList }">
			<c:forEach items="${item.childList }" var="childList">
				<div class="replyList">
					<div class="replyItem">
						<img src="${childList.userUrl }" alt="" />
						<div class="pl-sec">
							<p class="pl-name">${childList.isAnonymity=='1'?'匿名':childList.poster }</p>
							<p class="pl-con">${childList.content }</p>
							<p class="pl-date">
								<span>${childList.dateTime }</span>
							</p>
						</div>
					</div>
				</div>
			</c:forEach>
		</c:if>
	</div>
	<div class="clear"></div>
</c:forEach>
<div class="pagenum">
	<page:Page url="/product/commentList?commentType=2&hourId=${hourId }" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="pinglunList" />
</div>