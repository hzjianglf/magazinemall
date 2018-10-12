<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="cn.core.page" prefix="page" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<span>关注</span>
<div class="ins-list">
	<ul class="guanZhuList oh">
	<c:forEach items="${list }" var="list">
				<li>
					<a href="/home/expert/toExpertDetail?userId=${list.userId}"><img src="${list.userUrl }" alt="" /></a>
					<p>${list.name }</p>
					<a href="javascript:void(0)" onclick="cancelFollow(this,'${list.userId}');">取消关注</a>
				</li>
		<%-- <div class="dsjl_nr" id="div_${list.userId}">
			<img src="${list.userUrl }">
			<div class="dsjl_wz">
				<h3 style="margin-left: 15px;">${list.name }</h3>
				<h4 style="margin-left: 15px;">${list.addTime }</h4>
			</div>
			<c:if test="${type==1 }">
				<div class="dsjl_je">
					<div class="gz_biao">
						<a onclick="cancelFollow('${list.userId}');">已关注</a>
					</div>
				</div>
			</c:if>
			<div class="clear"></div>
		</div> --%>
	</c:forEach>
	</ul>
</div>
<div class="pageBox">
	<page:Page url="/usercenter/account/myfollow?type=${type}" numberLinkCount="2" currentIndex="3" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="guanzhu"></page:Page>
</div>

