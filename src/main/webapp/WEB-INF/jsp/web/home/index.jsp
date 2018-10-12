<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
	 <style type="text/css">
	 	.qiKan .yingXiaoShuYuan li img{
		    width: 50%;
		}
		.swiper-slide{
			cursor:pointer;
		}
		#qrcode{
			width:180px;
			height:180px;
			margin: 10px auto;
			border:1px solid #333;
		}
		.xzBtn{
			width:218px;
			margin: 0px auto;
		}
		.xzBtn>div.xzItem{
			width:89px;
			margin:0 5px;
			float:left;
			padding:5px;
		}
		.xzBtn>div.xzItem>img{
			width:20px;
			margin-top:6px;
		}
		.xzBtn>div.xzItem>a{
			display:inline-block;
			width:62px;
			float:right;
		}
		.qiKan .qiKanList li {
		    width: 25%;
		}
		.qiKan .rightBox.adbgBox{
			height:400px;
		}
		.zuoJiaList li:last-child{
			border-bottom:none;
		}
		.zuoJiaList li img{
			margin-left:15px;
		}
	 </style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<!--轮播、作家展示-->
		<div class="BroadCon">
			<div class="leftBox">
				<!-- Swiper -->
				<div class="swiper-container">
					<div class="swiper-wrapper imgList" id="imgList">
						<c:forEach var="item" items="${zone }">
							<div class="swiper-slide" onclick="details('${item.linkUrl}')" style="height:405px;background: url(${item.imgUrl }) no-repeat 0 0; background-size:100% 100%;">
								<p class="ins">${item.aDName }</p>
							</div>
						</c:forEach>
					</div>
					<!-- Add Pagination -->
					<div class="swiper-pagination"></div>
				</div>
			</div>
			<div class="rightBox">
				<p class="title" style="text-align: center">
					${siteInfo.pcSiteTitle }
				</p>
				<div id="qrcode"></div>
				<div class="xzBtn" style="float: left;">
					<div class="xzItem oh">
						<img src="/img/appstore.png" alt="" />
						<a href="http://www.pgyer.com/fGw8"><p>App Store<br>IOS版下载</p></a>
					</div>
					<div class="xzItem oh">
						<img src="/img/android.png" alt="" />
						<a href="http://tzxl.kuguanyun.net/images/xsysc.apk"><p>Android<br>安卓版下载</p></a>
					</div>
				</div>
			</div>
		</div>
		<!--期刊-->
		<div class="qiKan">
			<div class="leftBox">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					期刊
					<a href="/home/toQikan">全部</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="book" items="${bookList }">
						<c:if test="${book.isbuy < 1 }">
							<li>
								<a href="/product/turnPublicationDetail?id=${book.id }"><img src="${book.picture }" alt="" />
								<div class="qKins">
									<span class="qkName twoLine">${book.name }</span>
									<p>销量：<span>${book.sales }</span></p>
								</div>
								</a>
							</li>
						</c:if>
						<c:if test="${book.isbuy > 0 }">
							<li>
								<a href="/product/turnPublicationDetail?id=${book.id }&period=${book.period}"><img src="${book.picture }" alt="" />
								<div class="qKins">
									<span class="qkName twoLine">${book.name }</span>
									<p>销量：<span>${book.sales }</span></p>
								</div>
								</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
			<div class="rightBox adbgBox">
			<c:choose>
				     <c:when test="${zoneR01[0].imgUrl != '' && zoneR01[0].imgUrl != null }">
				          <img src="${zoneR01[0].imgUrl }" alt="" />
				     </c:when>
				     <c:otherwise>
				          <img src="/img/adbg.png" alt="" />
				     </c:otherwise>
			</c:choose>
			</div>
		</div>
		<!--专家课程-->
		<div class="qiKan zhuanJia secItem">
			<div class="leftBox">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					专家课程
					<a href="/home/toClass?type=1">全部</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand1" items="${ondemand1list }">
						<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand1.isSum=='0' }">
							<li>
							<a href="/product/classDetail?ondemandId=${ondemand1.ondemandId }">
								<img src="${ondemand1.picUrl }" alt="" />
								<div class="qKins">
									<span class="qkName">${ondemand1.name }</span>
									<p class="zuozhe">${ondemand1.nickName }</p>
									<p>
										订阅：<span>${ondemand1.studentNum }</span>
									</p>
								</div>
							</a>
							</li>
						</c:if>
						<c:if test="${ondemand1.isSum=='1' }">
							<li>
							<a href="/home/ondemandCollections?ondemandId=${ondemand1.ondemandId }">
								<img src="${ondemand1.picUrl }" alt="" />
								<div class="qKins">
									<span class="qkName">${ondemand1.name }</span>
									<p class="zuozhe">${ondemand1.nickName }</p>
									<p>
										订阅：<span>${ondemand1.studentNum }</span>
									</p>
								</div>
							</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
			<div class="rightBox adbgBox">
				<%-- <c:choose>
				     <c:when test="${zoneR02[0].imgUrl != '' && zoneR02[0].imgUrl != null }">
				          <img src="${zoneR02[0].imgUrl }" alt="" />
				     </c:when>
				     <c:otherwise>
				          <img src="/img/adbg.png" alt="" />
				     </c:otherwise>
				</c:choose> --%>
				<p class="title">
					<img src="/img/titleicon.png" alt="">
					推荐作家
					<a href="/home/expert/toExpert">全部</a>
				</p>
				<ul class="zuoJiaList">
					<c:forEach var="item" items="${teacherList }" begin="0" end="2">
						<li>
						  	<a onclick="expertDetailIndex('${item.userId}');">
							<img src="${item.userUrl }" alt="">
							<div class="zuoJiaIns">
								<span class="zName">${(item.realname==''||item.realname==null)?item.nickName:item.realname }</span>
								<p>已发布课程：<span>${item.ondemandCount }</span></p>
							</div>
							</a>
						</li>
					</c:forEach>
						
					
						<!-- <li>
						  	<a onclick="expertDetailIndex('107');">
							<img src="" alt="">
							<div class="zuoJiaIns">
								<span class="zName">王贝</span>
								<p>已发布课程：<span>0</span></p>
							</div>
							</a>
						</li>
					
						<li>
						  	<a onclick="expertDetailIndex('89');">
							<img src="/upload/20180517/95f75502-ad39-4edd-aa9b-65c0db3c06fc.jpg" alt="">
							<div class="zuoJiaIns">
								<span class="zName">朱毅</span>
								<p>已发布课程：<span>0</span></p>
							</div>
							</a>
						</li> -->
				</ul>
			</div>
		</div>
		<div class="qiKan zhuanJia secItem">
			<div class="leftBox">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					白马营微课
					<a href="/home/toClass?type=2">全部</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand2" items="${ondemand2list }">
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
									<!-- <img src="/img/msg.png" alt="" />
									<span>3600</span> -->
								</p>
							</div>
							</a>
							</li>
						</c:if>
						<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand2.isSum=='1' }">
							<li>
							<a href="/home/ondemandCollections?ondemandId=${ondemand2.ondemandId }">
							<img src="${ondemand2.picUrl }" alt="" />
							<div class="qKins">
								<span class="qkName">${ondemand2.name }</span>
								<p class="zuozhe">${ondemand2.nickName }</p>
								<p>
									订阅：<span>${ondemand2.studentNum }</span>
									<!-- <img src="/img/msg.png" alt="" />
									<span>3600</span> -->
								</p>
							</div>
							</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
			
			<div class="rightBox">
				<p class="title">
					<img src="/img/titleicon.png" alt="" />
					问答
					<a href="/home/question/toInterlocution?type=0">全部</a>
				</p>
				<ul class="wenDaList">
					<c:forEach var="interlocution" items="${interlocutionList }">
						<li>
							<p>
								<a href="javascript:void(0)">${interlocution.realname }</a>回答了
								<a href="javascript:void(0)">${interlocution.nickName }</a>的提问
							</p>
							<p class="replyCon">
								${interlocution.content }。
							</p>
							<p class="btnBox">
								<c:if test="${interlocution.isBugAudit=='0'}">
									<c:if test="${interlocution.answertype=='1'}">
										<button class="chakanBtn" onclick="payListenIndex(${interlocution.money},'${interlocution.questionId}',1);">${interlocution.money}元旁听</button><span>${interlocution.auditCount>0?interlocution.auditCount:0 }人看过</span>
									</c:if>
									<c:if test="${interlocution.answertype=='2'}">
										<button class="chakanBtn" onclick="payListenIndex(${interlocution.money},'${interlocution.questionId}',1);">${interlocution.money}元查看</button><span>${interlocution.auditCount>0?interlocution.auditCount:0 }人看过</span>
									</c:if>
								</c:if>
								<c:if test="${interlocution.isBugAudit!='0'}">
									<c:if test="${interlocution.answertype=='1'}">
										<audio src="${auditlist.musicurl}" controls="controls">
				   							 </audio>${interlocution.auditCount>0?interlocution.auditCount:0 }人看过
									</c:if>
									<c:if test="${interlocution.answertype=='2'}">
										<button class="chakanBtn" onclick="lookAnswerIndex('${interlocution.answertype}','${interlocution.answer}',${userId});">查看</button><span>${auditlist.auditCount>0?auditlist.auditCount:0 }人看过</span>
									</c:if>
								</c:if>
							</p>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="qiKan secItem">
			<div class="leftBox">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					听刊
					<a href="/home/toClass?type=3">全部</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand3" items="${ondemand3list }">
					<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand3.isSum=='0' }">
							<li>
							<a href="/product/classDetail?ondemandId=${ondemand3.ondemandId }">
							<img src="${ondemand3.picUrl }" alt="" />
							<div class="qKins">
								<span class="qkName">${ondemand3.name }</span>
								<p class="zuozhe">${ondemand3.nickName }</p>
								<p>
									订阅：<span>${ondemand3.studentNum }</span>
								</p>
							</div>
							</a>
							</li>
						</c:if>
						<c:if test="${ondemand3.isSum=='1' }">
							<li>
								<a href="/home/ondemandCollections?ondemandId=${ondemand3.ondemandId }">
								<img src="${ondemand3.picUrl }" alt="" />
								<div class="qKins">
									<span class="qkName">${ondemand3.name }</span>
									<p class="zuozhe">${ondemand3.nickName }</p>
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
			<div class="rightBox">
				<p class="title">
					<img src="/img/titleicon.png" alt="" />
					营销百科
					<a href="/home/question/toInterlocution?type=1">全部</a>
				</p>
				<ul class="wenDaList">
					<c:forEach var="teacherAnswer" items="${teacherAnswerList }">
						<li>
							<p class="replyCon">
								${teacherAnswer.content }。
							</p>
							<p class="btnBox">
								<c:if test="${teacherAnswer.isBugAudit=='0'}">
									<c:if test="${teacherAnswer.answertype=='1'}">
										<button class="chakanBtn" onclick="payListenIndex(${teacherAnswer.money},'${teacherAnswer.questionId}',1);">${teacherAnswer.money}元旁听</button><span>${teacherAnswer.auditCount>0?teacherAnswer.auditCount:0 }人看过</span>
									</c:if>
									<c:if test="${teacherAnswer.answertype=='2'}">
										<button class="chakanBtn" onclick="payListenIndex(${teacherAnswer.money},'${teacherAnswer.questionId}',1);">${teacherAnswer.money}元查看</button><span>${teacherAnswer.auditCount>0?teacherAnswer.auditCount:0 }人看过</span>
									</c:if>
								</c:if>
								<c:if test="${teacherAnswer.isBugAudit!='0'}">
									<c:if test="${teacherAnswer.answertype=='1'}">
										<audio src="${auditlist.musicurl}" controls="controls">
				   							 </audio>${teacherAnswer.auditCount>0?teacherAnswer.auditCount:0 }人看过
									</c:if>
									<c:if test="${teacherAnswer.answertype=='2'}">
										<button class="chakanBtn" onclick="lookAnswerIndex('${teacherAnswer.answertype}','${teacherAnswer.answer}',${userId});">查看</button><span>${auditlist.auditCount>0?auditlist.auditCount:0 }人看过</span>
									</c:if>
								</c:if>
							</p>
						</li>
					</c:forEach>
				</ul>
				<%-- <c:choose>
				     <c:when test="${zoneR02[0].imgUrl != '' && zoneR02[0].imgUrl != null }">
				          <img src="${zoneR02[0].imgUrl }" alt="" />
				     </c:when>
				     <c:otherwise>
				          <img src="/img/adbg.png" alt="" />
				     </c:otherwise>
				</c:choose> --%>
			</div>
		</div>
		<div class="qiKan secItem">
			<div class="leftBox">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					营销书苑
					<a href="/home/toClass?type=4">全部</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand4" items="${ondemand4list }">
					<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand4.isSum=='0' }">
							<li>
							<a href="/product/classDetail?ondemandId=${ondemand4.ondemandId }">
								<img src="${ondemand4.picUrl }" alt="" />
								<div class="qKins">
									<span class="qkName">${ondemand4.name }</span>
									<p class="zuozhe">${ondemand4.nickName }</p>
									<p>
										订阅：<span>${ondemand4.studentNum }</span>
										<!-- <img src="/img/msg.png" alt="" />
										<span>3600</span> -->
									</p>
								</div>
								</a>
							</li>
						</c:if>
						<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand4.isSum=='1' }">
							<li>
								<a href="/home/ondemandCollections?ondemandId=${ondemand4.ondemandId }">
									<img src="${ondemand4.picUrl }" alt="" />
									<div class="qKins">
										<span class="qkName">${ondemand4.name }</span>
										<p class="zuozhe">${ondemand4.nickName }</p>
										<p>
											订阅：<span>${ondemand4.studentNum }</span>
											<!-- <img src="/img/msg.png" alt="" />
											<span>3600</span> -->
										</p>
									</div>
								</a>
							</li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
			<%-- <div class="rightBox">
				
				<c:choose>
				     <c:when test="${zoneR03[0].imgUrl != '' && zoneR03[0].imgUrl != null }">
				          <img src="${zoneR03[0].imgUrl }" alt="" />
				     </c:when>
				     <c:otherwise>
				          <img src="/img/adbg.png" alt="" />
				     </c:otherwise>
				</c:choose>
			</div> --%>
		</div>
		<div class="qiKan zhuanJia secItem">
			<div class="leftBox">
				<p class="title">
					<img src="/img/itemIcon.png" alt="" />
					快课
					<a href="/home/toClass?type=8">全部</a>
				</p>
				<ul class="qiKanList">
					<c:forEach var="ondemand3" items="${fastCourseList }">
					<!-- isSum是否合集  0不是1是 -->
						<c:if test="${ondemand3.isSum=='0' }">
							<li>
							<a href="/product/classDetail?ondemandId=${ondemand3.ondemandId }">
							<img src="${ondemand3.picUrl }" alt="" />
							<div class="qKins">
								<span class="qkName">${ondemand3.name }</span>
								<p class="zuozhe">${ondemand3.nickName }</p>
								<p>
									订阅：<span>${ondemand3.studentNum }</span>
									<!-- <img src="/img/msg.png" alt="" />
									<span>3600</span> -->
								</p>
							</div>
							</a>
							</li>
						</c:if>
						<c:if test="${ondemand3.isSum=='1' }">
							<li>
								<a href="/home/ondemandCollections?ondemandId=${ondemand3.ondemandId }">
								<img src="${ondemand3.picUrl }" alt="" />
								<div class="qKins">
									<span class="qkName">${ondemand3.name }</span>
									<p class="zuozhe">${ondemand3.nickName }</p>
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
			<%-- <div class="rightBox adbgBox">
				<c:choose>
				     <c:when test="${zoneR04[0].imgUrl != '' && zoneR04[0].imgUrl != null }">
				          <img src="${zoneR04[0].imgUrl }" alt="" />
				     </c:when>
				     <c:otherwise>
				          <img src="/img/adbg.png" alt="" />
				     </c:otherwise>
				</c:choose>
			</div> --%>
			
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/js/jquery.js"></script>
		<script type="text/javascript" src="/js/swiper.min.js"></script>
		<script type="text/javascript">
			var layer;
			layui.use('layer', function(){
				layer = layui.layer;
				
				$(function() {
					var swiper = new Swiper('.swiper-container',{
						 pagination:{
							el:'.swiper-pagination'
						},
					    speed: 2000,
					    autoplay: true
						/* direction: "vertical",
						autoplay: true,
						speed: 2000,
			            loop: true */
					});
				});
			});
			
			//旁听支付
			function payListenIndex(price,questionId,auditType){/* quesOrAnswer 1提问支付 2旁听支付 */
				$.ajax({
					type:"get",
					url:"/home/question/webListenQuestion",
					data:{"money":price,"questionId":questionId,"auditType":auditType},
					datatype:"html",
					async:false,
					success:function(data){
						if(data.result==1){
							$("#content").val("");
							window.location.href = "/home/question/questionPay?payLogId="+data.payLogId+"&price="+price+"&content="+data.content+"&quesOrAnswer=2";
						}else{
							tipinfo(data.msg);
						}
					},
					
				})
			}
			//已支付的直接查看答案
			function lookAnswerIndex(answertype,answer,userId){
				if(answertype=='2'){
					tipinfo(answer);
				}else if(answertype=='1'){
					//tipinfo("别着急，随后给你加个播放器！");
				}
			}
			//专家详情
			function expertDetailIndex(userId){
				window.location.href="/home/expert/toExpertDetail?userId="+userId;
			}
			
			//大图滚动详情链接
			function details(url){
				location.href=url;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
