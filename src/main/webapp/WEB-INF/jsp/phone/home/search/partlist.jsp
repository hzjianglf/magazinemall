<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>

	<c:if test="${type==2 }">
		<div class="zzjx_lb">
			<c:if test="${count != '0' }">
				<div style="line-height:1.5rem;padding: 0 0.5rem;">共<span class="countColor">${count }</span>个搜索结果</div>
			</c:if>
			<ul>
			<c:forEach var="item" items="${list }">
				<c:if test="${!(item.isbuy>0 && item.status>0)  }">
					<li>
						<a href="/product/turnPublicationDetail?id=${item.id }"><img src="${item.picture }">
						<P>${item.name }<br><em></em></P>
						</a>
					</li>
				</c:if>
				<c:if test="${item.isbuy>0 && item.status>0 }">
					<li>
						<a href="/periodical/turnEbook?bookId=${item.id }&pubId=${item.period}"><img src="${item.picture }">
						<P>${item.name }<br><em></em></P>
						</a>
					</li>
				</c:if>
			</c:forEach>
			</ul>
			<div class="clear"></div>
		</div>
	</c:if>	
	
	<c:if test="${type==0}"><!-- 点播 -->
		<c:if test="${count != '0' }">
				共<span class="countColor">${count }</span>个搜索结果
		</c:if>
		<c:forEach var="list" items="${list }">
			<div class="zjkc_nr">
				<a href="/product/classDetail?ondemandId=${list.ondemandId }">
				<img src="${list.pictureUrl }">
				<div class="zjkc_nr_r">
					<h3><a onclick="detail('${list.ondemandId }');"> ${list.name }
						<c:if test="${list.serialState!='0' && list.serialState!='2'}">
							<em class="lz_biao">连载</em> 
						</c:if>
						<c:if test="${list.serialState=='2'}">
							<em class="lz_biao">连载</em>
						</c:if>
						<c:if test="${list.IsRecommend=='1' }">
							<em class="tj_biao">推荐</em>
						</c:if>
						</a>
					</h3>
					<h4>${list.title }&nbsp;&nbsp;&nbsp;&nbsp;${list.studentNum }人订阅</h4>
					<p>${fn:substring(list.synopsis,0,30)}...</p>
					<h5>
						<c:if test="${!(list.IsGratis eq 0) && !(list.isbuy eq 0) }">
							已订阅
						</c:if>
						￥${list.originalPrice }
					</h5>
				</div>
				<div class="clear"></div>
				</a>
			</div> 
		</c:forEach>
	</c:if>	
	
	<c:if test="${type==1}"><!-- 直播 -->
		<c:if test="${count != '0' }">
				共<span class="countColor">${count }</span>个搜索结果
		</c:if>
		<c:forEach var="list" items="${list }">
			<div class="zjkc_nr">
				<a href="/product/payOndemand?ondemandId=${list.ondemandId }">
				<img src="${list.pictureUrl }">
				<div class="zjkc_nr_r">
					<h3><a onclick="detail('${list.ondemandId }');"> ${list.name }
						<c:if test="${list.serialState!='0' && list.serialState!='2'}">
							<em class="lz_biao">连载</em> 
						</c:if>
						<c:if test="${list.serialState=='2'}">
							<em class="lz_biao">连载</em>
						</c:if>
						<c:if test="${list.IsRecommend=='1' }">
							<em class="tj_biao">推荐</em>
						</c:if>
						</a>
					</h3>
					<h4>${list.title }&nbsp;&nbsp;&nbsp;&nbsp;${list.studentNum }人订阅</h4>
					<p>${fn:substring(list.synopsis,0,30)}...</p>
					<h5>
						<c:if test="${list.IsGratis eq 0 && list.isbuy eq 0 }">
							已订阅
						</c:if>
						￥${list.originalPrice }
					</h5>
				</div>
				</a>
				<div class="clear"></div>
			</div> 
		</c:forEach>
	</c:if>	
	
	<c:if test="${type==3}"><!-- 专家 -->
		<c:if test="${count != '0' }">
				共<span class="countColor">${count }</span>个搜索结果
		</c:if>
		<div class="clear"></div>
		<c:forEach items="${list }" var="list">
			<a href="/home/teacherDetail?userId=${list.userId }">
			<div class="zj_nr">
				<img src="${list.userUrl }">
				<p>${list.synopsis }</p>
				<h3>${list.realname }  <em>已发布：${list.ondemandCount }</em></h3>
			</div>
			</a>
		</c:forEach>
		<div class="clear"></div>
		
	</c:if>	
	
	<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
