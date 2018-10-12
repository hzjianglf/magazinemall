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
		<style>
			.ml_nr li{
				margin:15px 20px;
				font-size:14px;
				list-style: none;
			}
			h4{
			    line-height: 1rem;
			    margin-bottom: 0.3rem;
			    text-align: center;
			}
			p{
				line-height:30px !important;
			}
			.tjkc_n{
				    font-size: 0.6rem;
				    line-height: 0.8rem;
				    margin-top: 0.5rem;
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
			}
			.newscon h1 {
				font-size: 0.6rem;
				color: #333;
				line-height: 1rem;
			}
			.newscon h1 span {
				font-size: 0.5rem;
				line-height: 1rem;
				font-weight: normal;
			}
			.newscon p {
				font-size: 0.4rem;
				color: #333;
				line-height: 0.6rem;
			  	display: -webkit-box;
			 	word-break: break-all;
			  	-webkit-box-orient: vertical;
			  	-webkit-line-clamp: 3;
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
			<c:forEach items="${data }" var="plate">
					<a href="/usercenter/order/lookArticle?articleId=${plate.DocID}">
					<div class="newslist">
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
						<%-- <div>
							<h1 style="font-size: 0.6rem;line-height: 1rem;font-weight: bold;">
								<c:if test="${fn:length(plate.Title)>12 }">
									${fn:substring(plate.Title, 0, 12)}...
								</c:if>
								<c:if test="${fn:length(plate.Title)<=12 }">
									${plate.Title }
								</c:if>
							</h1>
							<p style="font-size: 0.5rem;line-height: 0.7rem !important;text-align:right;margin-bottom: 0.5rem;">
								<c:if test="${plate.Author != '' && plate.Author != null }">
									 <span>${plate.Author}</span>
								</c:if>
							</p>
							<p style="font-size: 0.5rem;line-height: 0.7rem !important;">
								<c:if test="${fn:length(plate.SubText)>70 }">
									${fn:substring(plate.SubText, 0, 70)}...
								</c:if>
								
								<c:if test="${fn:length(plate.SubText)<=70 }">
									${plate.SubText }
								</c:if>
							</p>
							
						</div> --%>
					</div>
					</a>
			</c:forEach>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		
	</pxkj:Content>
</pxkj:ContentPage>
