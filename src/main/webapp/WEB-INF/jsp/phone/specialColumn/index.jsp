<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.wd_tx{
				display:flex;
				align-items: center;
				position:relative;
			}
			a.renZheng{
				position:absolute;
				right:0.7rem;
				font-size:0.6rem;
				background:#FF4E00;
				color:#fff !important;
				border-radius:0.5rem;
				padding:0.3rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1);" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>专栏工作台</h3>
		</div>
		<div class="zggz">
			<div class="wd_xx">
				<div class="wd_tx">
					<img src="${userUrl }" style="border-radius:50%;">
					${realname } <em style="margin:0 0 0 0.7rem;">LV${vipGrade }</em>
					<a class="renZheng" onclick="apply('${userType}');">去认证</a>
				</div>
				<div class="wd_xx_lb wd_xx_lb1">
					<ul>
						<li><em>${(empty worksCount)?'0':worksCount }个</em><br>我的作品</li>
						<li><em>${(empty liveCount)?'0':liveCount }个</em><br>我的直播</li>
						<li><em><img src="/images/zb_biao.png"></em><br>开始直播</li>
					</ul>
				</div>
			</div>
			<div class="sylb">
				<div class="sylb_top">
					<ul>
						<li>
							本月收益（${mothNowPrice }元）<br>
							<c:if test="${userType==1}">
								<em>认证后开启></em>
							</c:if>
						</li>
						<li>
							累计收益（${sumMoney }元）<br>
							<c:if test="${userType==1}">
								<em>认证后开启></em>
							</c:if>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			function apply(userType){
				if(userType=='1'){
					window.location.href="/SpecialColumn/apply";
				}else if (userType=='0'){
					tipinfo("链接错误,重新登录!")
				}else{
					tipinfo("已经认证过了!");
				}
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
