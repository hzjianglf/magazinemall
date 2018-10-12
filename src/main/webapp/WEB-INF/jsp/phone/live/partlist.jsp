<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@  taglib  uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>
<c:forEach items="${list }" var="list">
	<div class="zjkc_nr">
		<img src="${list.picUrl }">
		<div class="zjkc_nr_r">
			<h3><a onclick="detail('${list.ondemandId }');"> ${list.name }
				<c:if test="${list.serialState!='0' && list.serialState!='2'}">
					<em class="lz_biao">连载</em> 
				</c:if>
				<c:if test="${list.serialState=='2'}">
					<em class="lz_biao">连载</em>
				</c:if>
				<c:if test="${list.IsRecommend=='1' }">
					<em class="tj_biao">推荐</em>
				</c:if>
				</a>
			</h3>
			<%-- <h4>${list.realname }&nbsp;&nbsp;&nbsp;&nbsp;${list.studentNum }人订阅</h4> --%>
			<p>${fn:substring(list.introduce,0,30)}...</p>
			<h5>
				<c:if test="${list.isbuy=='0' }">
					<a onclick="subscribe('${list.ondemandId }');">订阅</a>
				</c:if>
				<c:if test="${list.isbuy!='0' }">
					<a href="#">已订阅</a>
				</c:if>
				￥${list.presentPrice }
			</h5>
		</div>
		<div class="clear"></div>
	</div> 
</c:forEach>	
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
