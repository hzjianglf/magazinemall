<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/css/base.css" rel="stylesheet">
		<link href="/css/index.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/css/swiper.min.css" rel="stylesheet">
		<style>
			.fl {
				float: left;
			}
			.fr {
				float: right;
			}
			.clear {
				clear: both;
			}
			.newslist {
				padding: 0 0.5rem;
			}
			.newslist>div {
				padding: 0.5rem 0;
				border-bottom: 1px #e5e5e5 solid;
			}
			.newslist>div:last-child {
				border: none;
			}
			.newspic {
				width: 4.5rem;
				height: 2.8rem;
			}			
			.newscon {
				width: 10rem;
				max-height: 2.8rem;
				margin-bottom: 0.5rem;
			}
			.newscon h1 {
				font-size: 0.6rem;
				color: #333;
				line-height: 1.2rem;
				font-weight: bold;
			}
			.newscon h1 span {
				font-size: 0.5rem;
				line-height: 1.2rem;
				font-weight: normal;
			}
			.newscon p {
				font-size: 0.4rem;
				color: #333;
				line-height: 0.8rem;
			  	display: -webkit-box;
			 	word-break: break-all;
			  	-webkit-box-orient: vertical;
			  	-webkit-line-clamp: 2;
			  	overflow: hidden;
			  	text-overflow: ellipsis;
			}
			.newscon_t {
				width: 100%;
				clear: right;
			}
			
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<c:if test="${type }">
			<div class="top">
				<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			</div>
		</c:if>
			<div class="newslist">
			<c:forEach items="${data }" var="plate">
					<a href="/usercenter/order/lookArticle?articleId=${plate.DocID}">
						<c:choose>
							<c:when test="${ !(plate.url eq '') && !(plate.url eq null) }">
								<div>
									<img src="${plate.url }" class="newspic fl" />
									<div class="newscon fr">
										<h1 class="clear">
											<c:if test="${fn:length(plate.Title)>12 }">
												${fn:substring(plate.Title, 0, 12)}...
											</c:if>
											<c:if test="${fn:length(plate.Title)<=12 }">
												${plate.Title }
											</c:if>
										<span class="fr">
											<c:if test="${plate.Author != '' && plate.Author != null }">
												 <span>${plate.Author}</span>
											</c:if>
										</span></h1>
										<p>${plate.SubText }</p>
									</div>
									<div class="clear"></div>
								</div>
							</c:when>
							<c:otherwise>
								<div class="newscon newscon_t">
									<h1 class="clear">
										<c:if test="${fn:length(plate.Title)>12 }">
											${fn:substring(plate.Title, 0, 12)}...
										</c:if>
										<c:if test="${fn:length(plate.Title)<=12 }">
											${plate.Title }
										</c:if>
									<span class="fr">
										<c:if test="${plate.Author != '' && plate.Author != null }">
											<span>${plate.Author}</span>
										</c:if>
									</span></h1>
									<p>${plate.SubText }</p>
								</div>
							</c:otherwise>
						</c:choose>
					</a>
			</c:forEach>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/swiper-3.3.1.jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/swiper.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/swiper.min.js"></script>
			<script>
	    var swiper = new Swiper('.class', {
		  slidesPerView: 5,
	      freeMode: true,
	      pagination: {
	        el: '.swiper-pagination',
	        clickable: true,
	      },
	    });
	    var swiper = new Swiper('.magazine', {
		  slidesPerView: 3,
	      freeMode: true,
	      pagination: {
	        el: '.swiper-pagination',
	        clickable: true,
	      },
	    });
	  </script>
	</pxkj:Content>
</pxkj:ContentPage>
