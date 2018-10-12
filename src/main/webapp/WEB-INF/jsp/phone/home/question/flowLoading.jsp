<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:if test="${type==0}">
<h2><!-- <a onClick="showBox3(2,1);">向TA提问</a> -->共有${totalCount}条</h2>
<c:forEach items="${list }" var="auditlist" varStatus="state">
	<div class="wd_nr">
		<h3>
			<span>${auditlist.auditCount }人听过</span> <em>${auditlist.realname}</em> 回答了 <em>${auditlist.nickName }</em> 的提问
		</h3>
		<P>${auditlist.content }</P>
		<div class="bf_mk">
			<%-- <a onclick="showBox3(2,'${auditlist.lecturer}','${auditlist.price}');" class="tw_biao">向TA提问</a> --%>
			<img src="${auditlist.userUrl }" class="tx_biao">
			<c:if test="${auditlist.isBugAudit=='0'}">
				<a onclick="payListen( ${auditlist.money},'${auditlist.questionId}',1);">
						<c:if test="${auditlist.answertype=='1'}">
						<div class="bf_biao">
						<img src="/images/yp_biao.png">
							 ${auditlist.money}元&nbsp;旁听
						</div>
						</c:if>
						<c:if test="${auditlist.answertype=='2'}">
						<div class="bf_biao2">
							${auditlist.money}元&nbsp; 查看
						</div>
						</c:if>
					</div>
				</a>
			</c:if>
			<c:if test="${auditlist.isBugAudit!='0'}">
				<%-- <a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
					<div class="bf_biao">
						<c:if test="${auditlist.answertype=='1'}">
						<img src="/images/yp_biao.png">
							    旁听<em>01'56''</em>
						</c:if>
						<c:if test="${auditlist.answertype=='2'}">
							查看
						</c:if>
					</div>
				</a> --%>
				<c:if test="${auditlist.answertype=='2'}">
					<a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
						<div class="bf_biao2">
								查看
						</div>
					</a> 
				</c:if>
				<c:if test="${auditlist.answertype=='1'}">
					<%-- <div class="bf_biao" onclick="playNoBuy('${auditlist.musicurl}','${state.index}');">
						<img src="/images/yp_biao.png">
					           旁听<em>01'56''</em>
					    <audio src="${auditlist.musicurl}" id="myaudio${state.index}"></audio>
					</div> --%>
					<audio src="${auditlist.musicurl}" controls="controls">
				    </audio>
				</c:if>
			</c:if>
		</div>
	</div>
</c:forEach>
</c:if>
<c:if test="${type==1}">
	<h2>共有${totalCount}条</h2>
	<c:forEach items="${list }" var="auditlist">
	<div class="wd_nr">
		<P>
			${auditlist.content } 
		</P>
		<div class="bf_mk">
			<span>${auditlist.auditCount }人听过</span>
			<c:if test="${auditlist.isBugAudit=='0'}">
				<a onclick="payListen( ${auditlist.money},'${auditlist.questionId}',1);">
					<c:if test="${auditlist.answertype=='1'}">
						<div class="bf_biao">
						<img src="/images/yp_biao.png"> ${auditlist.money}元
							旁听
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
				<%-- <a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
					<div class="bf_biao">
						<c:if test="${auditlist.answertype=='1'}">
						<img src="/images/yp_biao.png">
							旁听 <em>01'56''</em>
						</c:if>
						<c:if test="${auditlist.answertype=='2'}">
							查看
						</c:if>
					</div>
				</a> --%>
				<c:if test="${auditlist.answertype=='2'}">
					<a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
						<div class="bf_biao">
								查看
						</div>
					</a>
				</c:if>
				<c:if test="${auditlist.answertype=='1'}">
					<%-- <div class="bf_biao" onclick="playNoBuy('${auditlist.musicurl}','${state.index}');">
						<img src="/images/yp_biao.png">
					           旁听<em>01'56''</em>
					    <audio src="${auditlist.musicurl}" id="myaudio${state.index}"></audio>
					</div> --%>
					    <audio src="${auditlist.musicurl}" controls="controls">
					    </audio>
				</c:if>
				
			</c:if>
		</div>
	</div>
	</c:forEach>
</c:if>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
	
				
