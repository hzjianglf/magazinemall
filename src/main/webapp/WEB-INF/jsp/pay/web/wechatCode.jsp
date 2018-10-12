<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.zhifuType ul li.zhifu_Type{
				border:2px solid red;
			}
			.priceNum{
				padding:10px 0;
				color:#FF9966;
				font-size:20px;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div id="qrcode">
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/web/js/jquery.js"></script>
	<script type="text/javascript" src="/web/js/jquery.qrcode.min.js"></script>
		<script type="text/javascript">
		var times = 0;
		$(function() {
			var code= '${code}';
			jQuery('#qrcode').qrcode(code);
			setInterval ("showTime()", 5000);
		})
		function showTime(){
			var paylogId= '${paylogId}';
			console.log(paylogId);
			var times=0;
			$.ajax({
				type:'post',
				url:'/pay/result/PCwechatPay',
				data:{paylogId:paylogId},
				success:function(data){
					if(data.result){
						tipinfo(data.msg);
						setTimeout(function(){window.location.href="/web/home/index"},1000);
					}
					
				}
			});
			//15分钟后,该用户未扫码成功,则跳转主页面
			if(times == 180){
				setTimeout(function(){window.location.href="/web/home/index"},1000);
			}
			console.log(times++);
			
		}
   
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
