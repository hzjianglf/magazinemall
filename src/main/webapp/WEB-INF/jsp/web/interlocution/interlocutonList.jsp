<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:if test="${type==0}">
	<div class="checkOrder">
			<div class="orderSec">
				<div class="tiwenList dataItem wenDaBox show">
					<c:forEach items="${list }" var="auditlist" varStatus="state">
						<div class="tiwenItem">
							<img src="/img/start.png" alt="" />
							<div class="tiwen-sec">
								<p class="tiwen-name">
									<span>${auditlist.realname}</span>回答了<span>${auditlist.nickName }</span>
									<span class="tiwen-date">
										<fmt:formatDate value="${auditlist.inputDate}" pattern="yyyy-MM-dd HH:mm"/>
									</span>
								</p>
								<p class="tiwen-con">
									${auditlist.content }
								</p>
								<div class="tiwen-ins">
									<c:if test="${auditlist.isBugAudit=='0'}">
										<c:if test="${auditlist.answertype=='1'}">
											<button onclick="payListen(${auditlist.money},'${auditlist.questionId}',1);">${auditlist.money}元旁听</button><span>${auditlist.auditCount }人看过</span>
										</c:if>
										<c:if test="${auditlist.answertype=='2'}">
											<button onclick="payListen(${auditlist.money},'${auditlist.questionId}',1);">${auditlist.money}元查看</button><span>${auditlist.auditCount }人看过</span>
										</c:if>
									</c:if>
									<c:if test="${auditlist.isBugAudit!='0'}">
										<c:if test="${auditlist.answertype=='2'}">
											<button onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}',${userId});">查看</button><span>${auditlist.auditCount }人看过</span>
										</c:if>
										<c:if test="${auditlist.answertype=='1'}">
											<audio src="${auditlist.musicurl}" controls="controls">
				   							 </audio>
										</c:if>
									</c:if>
									<!-- <a href="javascript:void(0)">提问</a> -->
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
	</div>
</c:if>
<c:if test="${type==1}">
	<div class="checkOrder">
			<div class="orderSec">
				<div class="tiwenList dataItem wenDaBox show">
					<c:forEach items="${list }" var="auditlist" varStatus="state">
						<div class="tiwenItem">
							<img src="/img/start.png" alt="" />
							<div class="tiwen-sec">
								<p class="tiwen-name">
									<span>${auditlist.realname}</span>
									<span class="tiwen-date">
										<fmt:formatDate value="${auditlist.inputDate}" pattern="yyyy-MM-dd HH:mm"/>
									</span>
								</p>
								<p class="tiwen-con">
									${auditlist.content }
								</p>
								<div class="tiwen-ins">
									<c:if test="${auditlist.isBugAudit=='0'}">
										<c:if test="${auditlist.answertype=='1'}">
											<button onclick="payListen(${auditlist.money},'${auditlist.questionId}',1);">${auditlist.money}元旁听</button><span>${auditlist.auditCount }人看过</span>
										</c:if>
										<c:if test="${auditlist.answertype=='2'}">
											<button onclick="payListen(${auditlist.money},'${auditlist.questionId}',1);">${auditlist.money}元查看</button><span>${auditlist.auditCount }人看过</span>
										</c:if>
									</c:if>
									<c:if test="${auditlist.isBugAudit!='0'}">
										<c:if test="${auditlist.answertype=='2'}">
											<button onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}',${userId});">查看</button><span>${auditlist.auditCount }人看过</span>
										</c:if>
										<c:if test="${auditlist.answertype=='1'}">
											<audio src="${auditlist.musicurl}" controls="controls">
				   							 </audio>
										</c:if>
									</c:if>
									<!-- <a href="javascript:void(0)">提问</a> -->
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
	</div>
</c:if>
		<input type="hidden" name="userId" id="userId" value="${userId}"/>
<div class="pagenum">
	<page:Page url="/home/question/interlucationList?type=${type}" showPageInfo="true" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="MainContent"></page:Page>
</div>