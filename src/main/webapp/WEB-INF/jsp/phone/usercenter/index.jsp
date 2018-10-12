<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="wd_top">
			<div class="wd_top_sz">
				<a href="/home/message/tonews"><img src="/images/xf_biao.png" class="xf_biao"></a>
				<a href="/usercenter/account/turnUserSet"><img src="/images/sz_biao.png" class="sz_biao"></a>
			</div>
			<div class="wd_xx">
				<div class="wd_tx">
					<a href="/usercenter/account/userMsg"><img src="${data.userUrl }" style="border-radius:50%;" ></a>
					${data.nickName } <em>LV${data.vipGrade }</em>
				</div>
				<div class="wd_xx_lb">
					<ul>
						<li><a href="/usercenter/account/myquestions"><em>${data.twCount }人</em><br>提问</a></li>
						<li><a href="/usercenter/account/myaudit"><em>${data.ptCount }人</em><br>旁听</a></li>
						<li><a href="/usercenter/account/rewardLog"><em>${data.rewardCount }人</em><br>打赏</a></li>
						<li><a href="/usercenter/account/followlist"><em>${data.followCount }人</em><br>关注</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div class="wd_fl">
			<ul>
				<li class="li1"><a href="/usercenter/mymoney/turnMymoney"><img src="/images/wdqb_biao.png"><br>我的钱包</a></li>
				<li><a href="/usercenter/voucher/turnVoucher"><em>${data.voucher }</em><br>代金券</a></li>
				<li><a href="/usercenter/coupon/turnCoupon"><em>${data.coupon }</em><br>优惠券</a></li>
				<li><em class="em1">${data.balance }</em><br>余额</li>
				<li><a onclick="liveClass('${data.userType}');"><img src="/images/wdzb_biao.png"><br>我要直播</a></li>
				<li><a onclick="myClass('${data.userType}','${userId }');"><img src="/images/wdkc_biao.png"><br>我的课程</a></li>
				<li><a onclick="salelog('${data.userType}');"><img src="/images/xxjl_biao.png"><br>销售记录</a></li>
				<c:if test="${data.userType=='1' }">
					<li><a onclick="applyTea();"><img src="/images/grrz.png"><br>专栏申请</a></li>
				</c:if>
			</ul>
			<div class="clear"></div>
		</div>
		<div class="sz_lb">
			<ul>
				<!-- <li><a href="#"><img src="/images/wd_biao1.png">我的积分</a></li> -->
				<li><a href="/usercenter/account/getMyOrderlist"><img src="/images/wd_biao2.png">我的订单</a></li>
				<li><a href="/usercent/favorite/turnFavorites"><img src="/images/wd_biao3.png">我的收藏</a></li>
				<li><a href="/usercenter/order/buglog"><img src="/images/wd_biao4.png">我的宝贝</a></li>
				<li><a href="/usercenter/node/nodeListFace"><img src="/images/wd_biao5.png">我的笔记</a></li>
			</ul>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			//我要直播
			function liveClass(userType){
				if(userType=='1'){
					//跳转认证页面
					confirminfo("请先进行认证？",function(){
						window.location.href="/SpecialColumn/index";
					})
				}else{
					
				}
			}
			//我的课程
			function myClass(userType,userId){
				if(userType=='1'){
					//跳转认证页面
					confirminfo("请先进行认证？",function(){
						window.location.href="/SpecialColumn/index";
					})
				}else{
					window.location.href="/home/getRecommend?recommend=0&teacherId="+userId;
				}
			}
			//销售记录
			function salelog(userType){
				if(userType=='1'){
					//跳转认证页面
					confirminfo("请先进行认证？",function(){
						window.location.href="/SpecialColumn/index";
					})
				}else{
					window.location.href="/usercenter/account/MySaleLog";
				}
			}
			//认证
			function applyTea(){
				//跳转认证页面
				window.location.href="/SpecialColumn/index";
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
