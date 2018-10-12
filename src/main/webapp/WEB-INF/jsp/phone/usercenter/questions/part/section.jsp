<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<!-- 我的提问:未回答 -->
<c:if test="${questionType=='1' }">
	<c:forEach items="${list }" var="item" varStatus="cw">
	<div class="wdtw_nr">
		<h3>
			<c:if test="${item.answerState=='0' }"><em class="ck_biao">已关闭</em></c:if>
			<c:if test="${item.answerState=='1' }"><em class="ck_biao">未回答</em></c:if>
			<c:if test="${item.answerState=='2' }">
				<%-- <c:if test="${item.answerType=='1' }">
					<em class="ck_biao" onclick="selectQues('${cw.count}');">收听</em>
				</c:if> --%>
				<c:if test="${item.answerType=='2' }">
					<em class="ck_biao" onclick="selectQues('${cw.count}');">查看</em>
				</c:if>
			</c:if>
			<c:if test="${item.picUrl != null }">
			<img src="${item.picUrl }"> </c:if> ${item.name }
		</h3>
		<div class="wdtw_wd">
			<h4>问：${item.content }</h4>
			<p id="answer${cw.count }" style="display: none;">答案：${item.answer }</p>
			<c:if test="${item.answerType=='1' }">
				<p >
					收听：<audio src="${item.musicUrl}" controls="controls">
				         </audio>
				</p>
			</c:if>
		</div>
		<div class="wdtw_sj">${item.inputDate }</div>
	</div>
</c:forEach>
</c:if>
<!-- 提问我的:回答 -->
<c:if test="${questionType=='2' }">
	<c:forEach items="${list }" var="item" varStatus="cw">
	<div class="wdtw_nr">
		<h3>
			<c:if test="${item.answerState=='0' }"><em class="ck_biao">已关闭</em></c:if>
			<c:if test="${item.answerState=='1' }"><em class="ck_biao" onclick="toAnswerQues('${item.id}','${item.lecturer}');">回答</em></c:if>
			<c:if test="${item.answerState=='2' }">
				<%-- <c:if test="${item.answerType=='1' }">
					<em class="ck_biao" onclick="selectQues('${cw.count}');">收听</em>
				</c:if> --%>
				<c:if test="${item.answerType=='2' }">
					<em class="ck_biao" onclick="selectQues('${cw.count}');">查看</em>
				</c:if>
			</c:if>
			<img src="${item.picUrl }"> ${item.name }
		</h3>
		<div class="wdtw_wd">
			<h4>问：${item.content }</h4>
			<p id="answer${cw.count }" style="display: none;">答案：${item.answer }</p>
			<c:if test="${item.answerType=='1' }">
				<p >
					收听：<audio src="${item.musicUrl}" controls="controls">
				         </audio>
				</p>
			</c:if>
		</div>
		<div class="wdtw_sj">${item.inputDate }</div>
	</div>
</c:forEach>
</c:if>
<div class="ds_nr" id="ans_ques" style="display: none;">
	  <h3>回答提问</h3>
	  <div class="clear"></div>
	  <input type="hidden" name="id" id="iterlocationId" />
	  <input type="hidden" name="lecturer" id="lecturerId" />
	  <textarea placeholder="请输入回答内容" name="rewardMsg" id="questionMsg"></textarea>
	  <button type="button" onclick="confirmToAns();">确认回答</button>
	  <a href="#" onClick="deleteAnswer()" class="gb_biao"><img src="/images/gb_biao.png"></a>
</div>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
