<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<div class="qiKan zhuanJia secItem">
	<ul class="qiKanList zhuanLanZuoJia">
		<c:forEach items="${list }" var="expert" varStatus="state">
			<li>
				<a  onclick="expertDetail('${expert.userId}');">
				<img src="${expert.userUrl }" alt="" />
				<div class="qKins">
					<p class="zuozhe">${expert.realname==null?expert.nickName:expert.realname }</p>
					<p>
						发布：<span>${expert.ondemandCount }</span>
						<!-- 订阅：<span>100256</span>
						<img src="img/reply.png" alt="" />
						<span>3600</span> -->
					</p>
				</div>
				</a>
			</li>
		</c:forEach>
		
	</ul>
</div>
<div class="pagenum">
	<page:Page url="/home/expert/expertList?IsRecommend=${IsRecommend}" showPageInfo="true" page="${pageInfo }" ajaxPager="true" ajaxUpdateTargetId="MainContent"></page:Page>
</div>