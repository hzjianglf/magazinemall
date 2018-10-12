<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
	 <style type="text/css">
		.qiKan .showAll{
			width:100%;
			margin-bottom:20px;
		}
		.qiKan .showAll li{
			width:25%;
		}
	 </style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<!--期刊-->
		<c:if test="${fn:length(qikan) > 0 }">
		<div class="qiKan">
			<div class="leftBox showAll">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					期刊
					<a href="/home/toQikan">更多</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="book" items="${qikan }">
						<c:if test="${book.isbuy < 1 }">
							<li>
								<a href="/product/turnPublicationDetail?id=${book.id }"><img src="${book.picture }" alt="" />
								<div class="qKins">
									<span class="qkName">${book.name }</span>
									<p>销量：<span>${book.sales }</span></p>
								</div>
								</a>
							</li>
						</c:if>
						<c:if test="${book.isbuy > 0 }">
							<li>
								<a href="/product/turnPublicationDetail?id=${book.id }&period=${book.period}"><img src="${book.picture }" alt="" />
								<div class="qKins">
									<span class="qkName">${book.name }</span>
									<p>销量：<span>${book.sales }</span></p>
								</div>
								</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</c:if>
		<!-- 点播课程 -->
		<c:if test="${fn:length(dianbo) > 0 }">
		<div class="qiKan zhuanJia secItem">
			<div class="leftBox showAll">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					点播课程
					<a href="/home/toClass">更多</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand2" items="${dianbo }">
						<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand2.isSum=='0' }">
							<li>
							<a href="/product/classDetail?ondemandId=${ondemand2.ondemandId }">
							<img src="${ondemand2.picUrl }" alt="" />
							<div class="qKins">
								<span class="qkName">${ondemand2.name }</span>
								<p class="zuozhe">${ondemand2.nickName }</p>
								<p>
									订阅：<span>${ondemand2.studentNum }</span>
								</p>
							</div>
							</a>
							</li>
						</c:if>
						<c:if test="${ondemand2.isSum=='1' }">
							<li>
							<a href="/home/ondemandCollections?ondemandId=${ondemand2.ondemandId }">
							<img src="${ondemand2.picUrl }" alt="" />
							<div class="qKins">
								<span class="qkName">${ondemand2.name }</span>
								<p class="zuozhe">${ondemand2.nickName }</p>
								<p>
									订阅：<span>${ondemand2.studentNum }</span>
								</p>
							</div>
							</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
		</c:if>
		<c:if test="${fn:length(zhibo) > 0 }">
		<div class="qiKan zhuanJia secItem">
			<div class="leftBox showAll">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					直播
					<a href="/home/toClass">更多</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand3" items="${zhibo }">
					<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand3.isSum=='0' }">
							<li>
							<img src="${ondemand3.picUrl }" alt="" />
							<div class="qKins">
								<span class="qkName">${ondemand3.name }</span>
								<%-- <p class="zuozhe">${ondemand3.nickName }</p> --%>
								<p>
									订阅：<span>${ondemand3.studentNum }</span>
								</p>
							</div>
							</li>
						</c:if>
						<c:if test="${ondemand3.isSum=='1' }">
							<li>
								<a href="/home/ondemandCollections?ondemandId=${ondemand3.ondemandId }">
								<img src="${ondemand3.picUrl }" alt="" />
								<div class="qKins">
									<span class="qkName">${ondemand3.name }</span>
									<%-- <p class="zuozhe">${ondemand3.nickName }</p> --%>
									<p>
										订阅：<span>${ondemand3.studentNum }</span>
									</p>
								</div>
								</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
		</div>
		</c:if>
		<c:if test="${fn:length(zhuanjia) > 0 }">
		<div class="qiKan zhuanJia secItem">
			<div class="leftBox showAll">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					专家
					<a href="/home/expert/toExpert">更多</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="item" items="${zhuanjia }">
						<li>
						  	<a  onclick="expertDetailIndex('${item.userId}');">
							<img src="${item.userUrl }" alt="" />
							<div class="zuoJiaIns">
								<span class="zName">${item.nickName }</span>
								<p>已发布课程：<span>${item.ondemandCount }</span></p>
							</div>
							</a>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		</c:if>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script>
			$(function(){
				$("img").error(function() {
					$(this).attr("src", "/phone/images/noImage.jpg");
				});
				$(document).ajaxSuccess(function() {
					$("img").error(function() {
						$(this).attr("src", "/phone/images/noImage.jpg");
					});
				});
				$("#searchName").val('${name}');
			});
			//专家详情
			function expertDetailIndex(userId){
				window.location.href="/home/expert/toExpertDetail?userId="+userId;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
