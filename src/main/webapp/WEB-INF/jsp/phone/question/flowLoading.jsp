<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<h2><a onClick="showBox3(2,'${teacherId}');">向TA提问</a>共有${totalCount}条</h2>
<c:forEach items="${list }" var="auditlist">
	<div class="wd_nr">
		<h3>
			<span>${auditlist.auditCount }人听过</span> <em>${auditlist.nickName }</em> 提问
		</h3>
		<P>${auditlist.content }</P>
		<div class="bf_mk">
			<img src="${auditlist.userUrl }" class="tx_biao">
			<c:if test="${auditlist.isBugAudit=='0'}">
				<a onclick="payListen( ${auditlist.money},'${auditlist.questionId}',1);">
					<c:if test="${auditlist.answertype=='1'}">
						<div class="bf_biao">
						<img src="/images/yp_biao.png"> ${auditlist.money}元
							旁听 <!-- <em>01'56''</em> -->
							</div>
					</c:if>
					<c:if test="${auditlist.answertype=='2'}">
						<div class="bf_biao2">
						${auditlist.money}元  查看
						</div>
					</c:if>
				</a>
			</c:if>
			<c:if test="${auditlist.isBugAudit!='0'}">
				<a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
					<div class="bf_biao2">
						<c:if test="${auditlist.answertype=='2'}">
							查看
						</c:if>
					</div>
				</a>
				<c:if test="${auditlist.answertype=='1'}">
					<div class="bf_biao" onclick="playNoBuy('${auditlist.musicurl}','${state.index}');">
						<img src="/images/yp_biao.png">
					           旁听
					    <audio src="${auditlist.musicurl}" id="myaudio${state.index}"></audio>
					</div>
				</c:if>
			</c:if>
		</div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
