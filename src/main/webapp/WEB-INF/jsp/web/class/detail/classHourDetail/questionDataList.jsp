<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="page" uri="cn.core.page" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%-- <h2><a onClick="showBox3(2,'${teacherId}');">向TA提问</a>共有${totalCount}条</h2> --%>
<c:forEach items="${list }" var="auditlist">
	<div class="tiwenItem">
		<img src="${auditlist.userUrl }" alt="" />
		<div class="tiwen-sec">
			<p class="tiwen-name">
				<span>${teacherName }</span>回答了<span>${auditlist.nickName }</span>
				<span class="tiwen-date">${auditlist.inputDate }</span>
			</p>
			<p class="tiwen-con">
				${auditlist.content }
			</p>
			<div class="tiwen-ins">
			<c:if test="${auditlist.isBugAudit=='0'}">
				<a onclick="payListen(1.5,'${auditlist.questionId}',1);">
					<c:if test="${auditlist.answertype=='1'}">
						<div class="bf_biao">
						<img src="/phone/images/yp_biao.png"> 1.5元
							旁听 <em>01'56''</em>
							</div>
					</c:if>
					<c:if test="${auditlist.answertype=='2'}">
						<button>1.5元查看</button><span>${auditlist.auditCount }人看过</span>
					</c:if>
				</a>
			</c:if>
			<c:if test="${auditlist.isBugAudit!='0'}">
				<a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
					<div class="bf_biao2">
						<c:if test="${auditlist.answertype=='2'}">
							<button>查看</button><span>${auditlist.auditCount }人看过</span>
						</c:if>
					</div>
				</a>
				<c:if test="${auditlist.answertype=='1'}">
					<div class="bf_biao" onclick="playNoBuy('${auditlist.musicurl}','${state.index}');">
						<img src="/phone/images/yp_biao.png">
					           旁听<em>01'56''</em>
					    <audio src="${auditlist.musicurl}" id="myaudio${state.index}"></audio>
					</div>
				</c:if>
			</c:if>
			</div>
		</div>
	</div>
</c:forEach>
<div class="pagenum">
	<page:Page url="/product/questionList?teacherId=${teacherId }&teacherName='${teacherName }'" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="tiwenList" />
</div>