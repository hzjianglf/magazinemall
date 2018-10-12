<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="list">
	<div class="zzjx_nr zzjx_nr1">
		<img src="${list.productpic }">
		<div class="zzjx_nr_r">
			<h2>${list.productname }</h2>
			<h3>${list.realname }</h3>
			
			<c:if test="${list.subType==5}">
			    <!-- 赠品下的合集为1-->
				<c:if test="${list.isPresentSign==1}"><!-- 合集 -->
					<a href="/product/selectSumList?ondemandId=${list.productid }">
					  <span class="dsh_biao">学 习</span>
					</a>
				</c:if>
				<c:if test="${list.isPresentSign!=1}"><!-- 单课程 -->
					<a href="/product/classDetail?ondemandId=${list.productid }">
					<span class="dsh_biao">学 习</span>
					</a>
				</c:if>
			</c:if>
			<c:if test="${list.subType!=5}">
			    <!-- 赠品下的合集为1-->
				<c:if test="${list.subType>1}"><!-- 合集 -->
					<a href="/product/selectSumList?ondemandId=${list.productid }">
					  <span class="dsh_biao">学 习</span>
					</a>
				</c:if>
				<c:if test="${list.subType==1}"><!-- 单课程 -->
					<a href="/product/classDetail?ondemandId=${list.productid }">
					<span class="dsh_biao">学 习</span>
					</a>
				</c:if>
			</c:if>
		</div>
		<div class="clear"></div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage3" value="${pageTotal}">		

