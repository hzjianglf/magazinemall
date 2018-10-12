<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link rel="stylesheet" href="/css/swiper.min.css" />
		<style type="text/css">
			* {
				margin: 0;
				padding: 0;
			}
			body {
				font-size: 20px;
			}
			.class {
				padding: 0.5rem 0;
			}
			.class .swiper-slide {
				width: 3rem !important;
				text-align: center;
			}
			.class .swiper-slide img {
				width: 60%;
			}
			.class .swiper-slide p {
				font-size:0.5rem;
				color: #666;
				line-height: 1rem;
			}
			.magazine {
				padding: 0.5rem 0 1rem;
			}
			.magazine .swiper-slide {
				width: 5rem !important;
				text-align: center;
			}
			.magazine .swiper-slide img {
				width: 4rem;
				height: 5.25rem;
			}
			.magazine .swiper-slide p {
				font-size: 0.6rem;
				color: #333;
				line-height: 1rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="/home/message/tonews">
				<img src="/images/xx_biao.png" class="xx_biao">
			</a>
			<a href="/home/turnSearche">
				<div class="ss_div" style="width:12.55rem">
						<img src="/images/ss_biao.png">
				</div>
			</a>
			<!-- <img src="/images/sj_biao.png" class="sj_biao">
			<img src="/images/xz_biao.png" class="xz_biao"> -->
		</div>
		<div class="addWrap">
			<div class="swipe" id="mySwipe">
				<div class="swipe-wrap">
					<c:forEach var="item" items="${zone }">
						<div>
							<a href="${item.linkUrl }">
								<img class="img-responsive" src="${item.imgUrl }" />
							</a>
						</div>
					</c:forEach>
				</div>
			</div>
			<ul id="position">
				<c:forEach var="item" items="${zone }">
					<li class=""></li>
				</c:forEach>
			</ul>
		</div>
		<div class="swiper-container class">
			<div class="swiper-wrapper">
		      <div class="swiper-slide">
		      	<a href="/product/turnPublication"><img src="/images/sy_mk_tu1.png"></a>
		      	<P>期刊</P>
		      </div>	
			<div class="swiper-slide">
		      	<a href="/product/classList"><img src="/images/sy_mk_tu2.png"></a>
		      	<P>课程</P>
		      </div>
		      <div class="swiper-slide">
		      	<a href="/home/returnShuYuan"><img src="/images/sy_mk_tu3.png"></a>
		      	<P>书苑</P>
		      </div>
				<div class="swiper-slide">
		      	<a href="/live/liveList"><img src="/images/sy_mk_tu4.png"></a>
		      	<P>直播</P>
		      </div>
				<div class="swiper-slide">
		      	<a href="/question/indexQuestion"><img src="/images/sy_mk_tu5.png"></a>
		      	<P>问答</P>
		      </div>
		      <div class="swiper-slide">
		      	<a href="/home/getMoveWriter?IsRecommend=''"><img src="/images/sy_mk_tu6.png"></a>
		      	<P>专栏</P>
		      </div>
		      <div class="swiper-slide">
		      	<a href="javascript:void(0)" onclick="shopping();"><img src="/images/sy_mk_tu7.png"></a>
		      	<P>商城</P>
		      </div>
			</div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/home/getMoveZine">更多></a>
				<span></span>
				精选杂志
			</div>
			<div class="swiper-container magazine">
				<div class="swiper-wrapper">
					<c:forEach var="item" items="${zazhi }" >
						<div class="swiper-slide">
							<a href="/product/turnPublicationDetail?id=${item.id }" data-bookid="${item.id }"><img src="${item.picture }"></a>
							<P>${item.name }</P>
						</div>
					</c:forEach>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/home/getRecommend?recommend=1&teacherId=''">更多></a>
				<span></span>
				推荐
			</div>
			<div class="tjkc">
				<c:forEach var="item" items="${kecheng }" >
					<div class="tjkc_nr" onclick="classDetail('${item.ondemandId}');">
						<img src="${item.picUrl }" data-ondemandid="${item.ondemandId }">
						<div class="tjkc_nr_r">
								<h3 style="font-size: 0.65rem;width:70%;float: left;">
								<c:if test="${fn:length(item.name)>12 }">
									${fn:substring(item.name,0,12)}...
								</c:if>
								<c:if test="${fn:length(item.name)<=12 }">
									${item.name}
								</c:if>
								</h3>
								<div style="float: right;">
									<em style="font-size:0.6rem;color:#dc8d39">￥${item.presentPrice }</em>
								</div>
							<c:if test="${item.userName!=null && item.userName!='' }">
								<h4><span>${item.userName }</span></h4>
							</c:if>
							<P style="width:70%;font-size: 0.6rem;color: #666;">${fn:substring(item.title,0,23)}...</P>
						</div>
						<div class="clear"></div>
					</div>
				</c:forEach>
			</div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/product/classList?type=2">更多></a>
				<span></span>
				白马营
			</div>
			<div class="bmy">
				<ul>
					<c:forEach items="${bailist }" var="bailist">
						<li onclick="classDetail('${bailist.ondemandId}');" >
							<%-- <span>
							<c:if test="${fn:length(bailist.nickName)>3 }">
						            ${fn:substring(bailist.nickName, 0, 3)}..
						    </c:if>
						    <c:if test="${fn:length(bailist.nickName)<=3 }">
						           ${bailist.nickName }
						    </c:if>老师</span> --%>
							<a href="javascript:void(0);" style="font-size: 0.65rem;">
							<c:if test="${fn:length(bailist.name)>18 }">
						            ${fn:substring(bailist.name, 0, 18)}..
						    </c:if>
						    <c:if test="${fn:length(bailist.name)<=18 }">
						           ${bailist.name }
						    </c:if></a>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/home/returnTingkan">更多></a>
				<span></span>
				听刊
			</div>
			<div class="swiper-container magazine">
				<div class="swiper-wrapper">
					<c:forEach var="item" items="${hearList }" >
						<div class="swiper-slide" onclick="classDetail('${item.ondemandId}');">
							<img src="${item.picUrl }">
							<P>${item.name }</P>
						</div>
					</c:forEach>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/product/classList?type=8">更多></a>
				<span></span>
				快课
			</div>
			<%-- <div class="" yxsy>
				<c:forEach items="${fastCourseList }" var="list">
					<div class="yxsy_nr" onclick="classDetail('${list.ondemandId}');">
						<img src="${list.picUrl }">
						<div class="yxsy_nr_r">
							<p>${fn:substring(list.introduce,0,30)}...</p>
							<h4>
								<span>
									<img src="/images/dy_biao.png">${list.studentNum}人订阅
								</span>
								<em>￥${list.presentPrice }</em>
							</h4>
						</div>
						<div class="clear"></div>
					</div>
				</c:forEach>
			</div> --%>
			<div class="bmy">
				<ul>
					<c:forEach items="${fastCourseList }" var="bailist">
						<li onclick="classDetail('${bailist.ondemandId}');">
							<%-- <span>
							<c:if test="${fn:length(bailist.nickName)>3 }">
						            ${fn:substring(bailist.nickName, 0, 3)}..
						    </c:if>
						    <c:if test="${fn:length(bailist.nickName)<=3 }">
						           ${bailist.nickName }
						    </c:if>老师</span> --%>
							<a href="javascript:void(0);">
							<c:if test="${fn:length(bailist.name)>12 }">
						            ${fn:substring(bailist.name, 0, 12)}..
						    </c:if>
						    <c:if test="${fn:length(bailist.name)<=12 }">
						           ${bailist.name }
						    </c:if></a>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/home/returnShuYuan">更多></a>
				<span></span>
				营销书苑
			</div>
			<div class="swiper-container magazine">
				<div class="swiper-wrapper">
					<c:forEach var="item" items="${booklist }" >
						<div class="swiper-slide" onclick="classDetail('${item.ondemandId}');">
							<img src="${item.picUrl }" >
							<P>${item.name }</P>
						</div>
					</c:forEach>
				</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="nrmk">
			<div class="nrmk_top">
				<a href="/home/getMoveWriter?IsRecommend=1">更多></a>
				<span></span>
				专家专栏
			</div>
			<div class="tjkc">
				<c:forEach var="item" items="${teacher }" >
					<div class="tjkc_nr" onclick="teacherDetail('${item.userId }');">
						<img src="${item.userUrl }" data-userid="${item.userId }">
						<div class="tjkc_nr_r">
							<h3>${(item.realname==''||item.realname==null)?item.nickName:item.realname }</h3>
							
							<P>${fn:substring(item.synopsis,0,35)}...</P>
						</div>
						<div class="clear"></div>
					</div>
				</c:forEach>	
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script>
			;(function(win,doc){
				function change(){
					doc.documentElement.style.fontSize=20*doc.documentElement.clientWidth/320+'px';
				}
				change();
				win.addEventListener('resize',change,false);
			})(window,document);
		</script>
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/js/swiper.min.js" ></script>
		<script type="text/javascript">
			$(function() {
				var bullets = document.getElementById('position')
						.getElementsByTagName('li');
				var banner = Swipe(document.getElementById('mySwipe'), {
					auto : 2000,
					continuous : true,
					disableScroll : false,
					callback : function(pos) {
						var i = bullets.length;
						while (i--) {
							bullets[i].className = ' ';
						}
						bullets[pos].className = 'cur';
					}
				});
				
			});
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
			//课程详情
			function classDetail(ondemandId){
				window.location.href="/product/classDetail?ondemandId="+ondemandId;
			}
			//专家详情
			function teacherDetail(userId){
				window.location.href="/home/teacherDetail?userId="+userId;
			}
			function shopping(){
				tipinfo("暂未开放!");
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
