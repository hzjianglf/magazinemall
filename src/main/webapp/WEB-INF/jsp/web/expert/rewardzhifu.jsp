<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.zhifu_Type{
				border:2px solid red;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="checkOrder">
			<p class="title">支付中心</p>
			<div class="orderSec zhiFuCon">
				<div class="orderCon">
					<div class="oContent">
						<span class="oName">打赏-${realname }</span>
						<span class="priceCon">${money }元</span>
						<span class="describe">描述：${rewardMsg }</span>
					</div>
					<div class="youHuiJuan zhifuType">
						<ul>
							<li data-val="3">
								<img src="/img/alipey.png" alt="" />
							</li>
							<li data-val="7">
								<img src="/img/weiXinPey.png" alt="" />
							</li>
							<li data-val="5">
								<c:choose>
									<c:when test="${pricePVbalan }"><!-- 如果 -->
										<img src="/img/yuE.png" alt="" /> ${balance }
									</c:when>
									<c:otherwise> <!-- 否则 -->
										余额不足
									</c:otherwise>
								</c:choose>
							</li>
						</ul>
					</div>
					<div class="totlanum">
						<button class="submitOrder" type="button" onclick="pay('${teacherId}','${money }','${rewardMsg }');">立即支付 ￥${money }</button>
					</div>
				</div>
			</div>
		</div>
		<div id="qrcode">
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/js/jquery.qrcode.min.js"></script>
		<script>
			$('.zhifuType li').click(function(){
				$(this).addClass("zhifu_Type").siblings().removeClass("zhifu_Type");
			});
			//var paylogId = ${paylogId};
			function pay(teacherId,money,rewardMsg){
				var paytype = $('.zhifuType li[class="zhifu_Type"]').data('val');
				if(paytype=="" || paytype==undefined){
					tipinfo("请选择支付方式，或该方式还未开放");
					return ;
				}
				/* if(paylogId==null || paylogId==''){
					tipinfo("操作失误，从新操作！");
					setTimeout(function(){window.location.href="/home/index"},1000);
				}else{ */
					if(paytype == 5){
						$.ajax({
							type:'post',
							data:{"contentId":teacherId,"money":money,"rewardMsg":rewardMsg},
							url:'/home/expert/RewardTeacher',
							datatype:'json',
							success:function(data){
								if(data.success){
									//跳转等待页面
									$.ajax({
										type:'post',
										url:'/pay/waittingPay',
										data:{paylogId:data.paylogId,paytype:paytype},
										success:function(data){
											tipinfo(data.msg);
											setTimeout(function(){window.location.href="/home/index"},1000);
										}
									});
									
								}
							},
							error:function(data){
								alert("系统异常,请联系管理员!");
							}
						});
					}else if(paytype == 3){
						$.ajax({
							type:'post',
							data:{"contentId":teacherId,"money":money,"rewardMsg":rewardMsg},
							url:'/home/expert/RewardTeacher',
							datatype:'json',
							success:function(data){
								if(data.success){
									//跳转等待页面
									$.ajax({
										type:'post',
										url:'/pay/waittingPay',
										data:{paylogId:data.paylogId,paytype:paytype},
										success:function(data){
											$('#qrcode').html(data.payResult.requestData);
										}
									});
									
								}
							},
							error:function(data){
								alert("系统异常,请联系管理员!");
							}
						});
					}else if(paytype == 7){
						$.ajax({
							type:'post',
							data:{"contentId":teacherId,"money":money,"rewardMsg":rewardMsg},
							url:'/home/expert/RewardTeacher',
							datatype:'json',
							success:function(data){
								if(data.success){
									//跳转等待页面
									$.ajax({
										type:'post',
										url:'/pay/waittingPay',
										data:{paylogId:data.paylogId,paytype:paytype},
										success:function(data){
											//tipinfo(data.msg);
											//setTimeout(function(){window.location.href="/home/index"},1000);
											//jQuery('#qrcode').qrcode(data.payResult.requestData);
											window.location.href="/pay/wechatcode?code="+data.payResult.requestData+"&paylogId="+paylogId;
										}
									});
									
								}
							},
							error:function(data){
								alert("系统异常,请联系管理员!");
							}
						});
						
					}
					
				//}
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
