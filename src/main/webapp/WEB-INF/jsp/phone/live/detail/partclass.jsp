<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:forEach items="${data.list }" var="list">
	<div class="ks_nr" onclick="playVideo('${list.hourId}','${list.ondemandId }','${data.IsBuyOndemand }','${list.IsAudition}');">
		<div class="ks_img">
			<img src="/images/bf_biao3.png" class="bf_biao1">
			<img src="/images/kspic.png" class="ks_biao">
		</div>
		<div class="ks_nr_r">
			<h3>${list.title } ${list.IsAudition=='1'?'<em>试听</em>':'' }</h3>
			<div class="ks_nr_biao">
				<a href="#"><img src="/images/xz_biao2.png"></a>
				<span><img src="/images/bf_biao2.png">${list.hits/10000 }万</span>
				<span><img src="/images/dx_biao.png">${list.commentCount }</span>
				<span><img src="/images/sj_biao1.png">${list.minute }:${list.second }</span>
				<span><img src="/images/xin_biao.png" onclick="showArticle('${list.hourId}','${list.ondemandId }','${data.IsBuyOndemand }','${list.IsAudition}');"></span><!-- 文稿 -->
			</div>
		</div>
		<div class="clear"></div>
	</div>
</c:forEach>
<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">				
