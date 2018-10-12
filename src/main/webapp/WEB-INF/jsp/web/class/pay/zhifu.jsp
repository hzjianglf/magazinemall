<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.orderPay{
				font-size: 14px;
				color:#A1A1A1;
				margin-top:20px;
				text-align: center;
			}
			.orderPay span{
				color:#FF6633;
				font-size: 32px;
			}
			.zhifuType{
				text-align: center;
			}
			.zhifuType ul{
				overflow: hidden;
			}
			.zhifuType ul li{
				width: 335px;
				margin:0 3px;
				cursor: pointer;
				border:1px solid transparent;
			}
			.zhifuType ul li.sel{
				border:1px solid #ff9966;
			}
			.zhifuType ul li>.zfName {
				font-size: 30px;
				color: #666666;
				position: relative;
				top: 20px;
			}
			
			.zhifuType ul li>div {
				display: inline-block;
			}
			
			.zhifuType ul li>div .zfName {
				font-size: 30px;
				color: #666666;
				position: relative;
				top: 8px;
			}
			
			.zhifuType ul li .yueNum {
				position: relative;
				top: 10px;
				font-size: 18px;
				color: #B2B2B2;
				text-align: left;
			}
			
			.zhifuType ul li img {
				width: 80px;
			}
			.totlanum>.submitOrder{
				font-size: 16px;
			}
			.oContent {
				margin-top: 20px;
			}
			
			.oContent .oName {
				margin-left: 20px;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="checkOrder">
			<p class="title">支付中心</p>
			<div class="orderSec zhiFuCon">
				<div class="orderCon">
					<!-- <p class="title">订单：2018071009140001</p> -->
					<p class="orderPay">
						支付金额：<span>￥${price }</span>
					</p>
					<div class="youHuiJuan zhifuType">
						<ul>
							<li data-val="3">
								<img src="/img/zhifu01.png" alt="" />
								<span class="zfName">支付宝</span>
							</li>
							<li data-val="7">
								<img src="/img/zhifu02.png" alt="" />
								<span class="zfName">微信支付</span>
							</li>
							<li data-val="5">
								<c:choose>
									<c:when test="${pricePVbalan }"><!-- 如果 -->
										<img src="/img/zhifu03.png" alt="" />
										<div>
											<span class="zfName">我的余额</span>
											<p class="yueNum">￥${balance }</p>
										</div>
									</c:when>
									<c:otherwise> <!-- 否则 -->
										<p class="yueNum">余额不足</p>
									</c:otherwise>
								</c:choose>
							</li>
						</ul>
					</div>
					<div class="totlanum">
						<button class="submitOrder">立即支付</button>
					</div>
				</div>
			</div>
		</div>
		<div id="qrcode"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script>
			/* $('.zhifuType li').click(function(){
				$(this).addClass("zhifu_Type").siblings().removeClass("zhifu_Type");
			});*/
			$('.zhifuType ul li').click(function(){
				$(this).addClass('sel').siblings().removeClass('sel');
			})
			var paylogId = ${paylogId};
			$('.submitOrder').click(function(){
				var paytype = $('.zhifuType li[class="sel"]').data('val');
				if(paytype=="" || paytype==undefined){
					tipinfo("请选择支付方式，或该方式还未开放");
					return ;
				}
				if(paylogId==null || paylogId==''){
					tipinfo("操作失误，从新操作！");
					setTimeout(function(){window.location.href="/home/index"},1000);
				}else if(paytype == 5){
					$.ajax({
						type:'post',
						url:'/pay/waittingPay',
						data:{paylogId:paylogId,paytype:paytype},
						success:function(data){
							tipinfo(data.msg);
							setTimeout(function(){window.location.href="/home/index"},1000);
						}
					});
				}else if(paytype == 3){//支付宝支付
					$.ajax({
						type:'post',
						url:'/pay/waittingPay',
						data:{paylogId:paylogId,paytype:paytype},
						success:function(data){
							$('#qrcode').html(data.payResult.requestData);
						}
					});
				}else if(paytype == 7){//微信支付
					$.ajax({
						type:'post',
						url:'/pay/waittingPay',
						data:{paylogId:paylogId,paytype:paytype},
						success:function(data){
							//tipinfo(data.msg);
							//setTimeout(function(){window.location.href="/home/index"},1000);
							//jQuery('#qrcode').qrcode(data.payResult.requestData);
							window.location.href="/pay/wechatcode?code="+data.payResult.requestData+"&paylogId="+paylogId;
						}
					});
					
				}
			});
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
