<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${list }" var="list">
	<div class="qbkc_nr" onclick="detail('${list.ondemandId}');">
		<img src="${list.picUrl }">
		<div class="qbkc_nr_r">
			<h3>${list.name } 
				<%-- <c:if test="${list.serialState!='0'}">
					<em class="lz_biao">连载</em> 
				</c:if>
				<c:if test="${list.serialState!='0'}">
					<em class="lz_biao">已完结</em> 
				</c:if>
				<c:if test="${list.IsRecommend=='1' }">
					<em class="tj_biao">推荐</em>
				</c:if> --%>
			</h3>
			<h4>${list.studentNum }人订阅</h4>
			<h5><img src="/images/bf_biao2.png">${list.hits/10000 }万 &nbsp;&nbsp;&nbsp;&nbsp;    已更新${list.hourCount }课时</h5>
		</div>
		<div class="clear"></div>
	</div>
</c:forEach>	
<!-- 共有多少个课程 -->
<input type="hidden" id="count" value="${count }" />
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
