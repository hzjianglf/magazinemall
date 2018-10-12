<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>我的钱包</h3>
		</div>
		<div class="yenr">
			<div class="yecz">
				<h3>余额：<br> ${balance} 元 </h3>
				<a href="/usercenter/mymoney/trunRecharge">充 值</a>
				<div class="clear"></div>
				<h4>注：余额不能提现，仅用于购买商品</h4>
			</div>
			<div class="sz_lb">
				<ul>
					<li>
						<a href="/usercenter/coupon/turnCoupon">优惠券</a>
					</li>
					<li>
						<a href="/usercenter/voucher/turnVoucher">代金券</a>
					</li>
					<li>
						<a href="/usercenter/mymoney/turnLog">交易记录 </a>
					</li>
				</ul>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
