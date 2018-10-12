<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/pagetag.tld" prefix="page"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<div class="userInfo">
	<img src="${data.teacherUrl }" alt="" />
	<h2>
		${data.realname==null?data.nickName:data.realname }
		<a onclick="followByPC('${data.userId}');" class="guanzhu" id="follow">+${(data.Isfoolow==0||! empty data.Isfoollow)?'关注':'取消关注' }</a>
	</h2>
	<p class="ins">
	 <c:if test="${fn:length(data.synopsis)>30 }">
            ${fn:substring(data.synopsis, 0, 30)}...
      </c:if>
     <c:if test="${fn:length(data.synopsis)<=12 }">
            ${data.synopsis }
      </c:if>
     </p>
	<div class="daShang">
		<span class="shang">
			<!-- <a  class="ds_biao" href="javascript:void(0)" onClick="showBoxByPC()">赏</a> -->
			<a onClick="showBoxByPC('${data.userId}')">赏</a>
		</span>
		<p>已有${(empty data.rewardNum)?'0':data.rewardNum }人打赏</p>
	</div>
	<div class="bottomIns">
		<ul>
			<!-- <li>评论:<span>3600</span></li> -->
			<li>关注:<span>${(empty data.followNum)?'0':data.followNum }</span></li>
			<li>粉丝:<span>${(data.fansNum > 10000)?(data.fansNum/10000):(data.fansNum) }${(data.fansNum>10000)?'万':'' }</span></li>
		</ul>
	</div>
</div>
<div class="qiKan zhuanJia secItem">
	<ul class="qiKanList zhuanLanZuoJia">
		<c:forEach items="${data.teacherlist }" var="course" varStatus="state">
			<!-- isSum是否合集  0不是1是 -->
			<c:if test="${course.isSum=='0' }">
				<li>
					<a href="/product/classDetail?ondemandId=${course.ondemandId }">
						<img src="${course.picUrl }" alt="" />
						<div class="qKins">
							<p class="zuozhe">
							  <c:if test="${fn:length(course.name)>12 }">
			                         ${fn:substring(course.name, 0, 12)}...
			                   </c:if>
			                  <c:if test="${fn:length(course.name)<=12 }">
			                         ${course.name }
			                   </c:if>
							</p>
							<p>
								<%-- 发布：<span>${expert.ondemandCount }</span> --%>
								订阅：<span>${course.studentNum }</span>
								<!-- <img src="img/reply.png" alt="" />
								<span>3600</span> -->
							</p>
						</div>
					</a>
				</li>
			</c:if>
			<!-- isSum是否合集  0不是1是 -->
			<c:if test="${course.isSum=='1' }">
				<li>
					<a href="/home/ondemandCollections?ondemandId=${ondemand1.ondemandId }">
						<img src="${course.picUrl }" alt="" />
						<div class="qKins">
							<p class="zuozhe">
								<c:if test="${fn:length(course.name)>12 }">
			                         ${fn:substring(course.name, 0, 12)}...
			                   </c:if>
			                  <c:if test="${fn:length(course.name)<=12 }">
			                         ${course.name }
			                   </c:if>
							</p>
							<p>
								<%-- 发布：<span>${expert.ondemandCount }</span> --%>
								订阅：<span>${course.studentNum }</span>
								<!-- <img src="img/reply.png" alt="" />
								<span>3600</span> -->
							</p>
						</div>
					</a>
				</li>
			</c:if>
		</c:forEach>
		<c:if test="${fn:length(data.teacherlist)<1 }">
			<div class='defaultData'>暂无数据</div>
		</c:if>
	</ul>
</div>