<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<c:if test="${type==1 }">
		<div class="subCheck">
			<ul>
				<c:forEach var="item" items="${list }" varStatus="c">
					<a href="/product/turnPublicationDetail?id=${item.id }">
						<li>
							<span class="check_box"> 
								<input type="checkbox" name="check" id="check_${c.count }" value=${item.favoriteId } style="display:none">
								<label for="check_${c.count }"></label>
							</span>
							<a href="/product/turnPublicationDetail?id=${item.id }"><img src="${item.picture }"></a>
							<P>
								<em>${item.bookName }</em>
							</P>
						</li>
					</a>
				</c:forEach>
			</ul>
		</div>
		<div class="qx_mk">
			<span class="check_box"> <input type="checkbox" id="check_All" style="display:none">
				<label for="check_All"></label> <em>全选</em>
			</span> <a href="javascript:deleteItem();">移出收藏</a>
		</div>
	<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
</c:if>
<c:if test="${type==2 }">
	<div class="qbkc_lb">
		<c:forEach items="${list }" var="item" varStatus="c">
				<div class="qbkc_nr">
					<img src="${item.userUrl }">
					<div class="qbkc_nr_r qbkc_nr_r1">
						<h3>
							<a href="javascript:delOndemanFavorite(${item.favoriteId });"><img src="/images/sc_biao.png"></a><i onclick="turnOndemand(${item.ondemandId})">${item.name }</i>
							<em class="lz_biao">
								<c:if test="${item.serialState==1 }">连载</c:if>
								<c:if test="${item.serialState==2}">完结</c:if>
							</em> 
							<c:if test="${item.IsRecommend==1 }"><em class="tj_biao">推荐</em></c:if>
						</h3>
						<h4>${item.studentNum}人订阅</h4>
						<h5>
							<a href="#"><img src="/images/xz_biao1.png"> </a><img
								src="/images/bf_biao2.png">${item.hits } &nbsp;&nbsp;&nbsp;&nbsp;
							<c:if test="${item.serialState==2 }">共${item.count }课时</c:if>
							<c:if test="${item.serialState==1 }">已更新${item.count }课时</c:if>
						</h5>
					</div>
					<div class="clear"></div>
				</div>
		</c:forEach>
	</div>
	<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
</c:if>
