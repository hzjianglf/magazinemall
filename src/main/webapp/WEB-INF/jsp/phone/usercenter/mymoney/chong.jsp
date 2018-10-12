<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
	<!-- 用户充值页面 -->
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>充值中心</h3>
		</div>
		<div class="czzx">
			<div class="czje">
				<h3>请选择充值金额</h3>
				<ul>
					<li class="on"><a href="javascript:void(0)"><em>0.01</em>元</a></li>
					<li><a href="javascript:void(0)"><em>20</em>元</a></li>
					<li><a href="javascript:void(0)"><em>50</em>元</a></li>
					<li><a href="javascript:void(0)"><em>100</em>元</a></li>
					<li><a href="javascript:void(0)"><em>200</em>元</a></li>
					<li><a href="javascript:void(0)"><em>500</em>元</a></li>
				</ul>
			</div>
			<div class="zffs">
				<h3>请选择支付方式</h3>
				<ul>
					<c:forEach items="${payMethods }" var="item" varStatus="c">
						<c:if test="${item.payType != '账户余额支付' }">
							<Li>
								<span class="radio_box">
					                   <input type="radio" id="radio_${c.count }" name="radio" value="${item.id }" data-name="${item.methodName }" data-type="${item.payType }">
					                   <label for="radio_${c.count }"></label>
			       			 	</span>
								<img src="${item.picUrl }"> ${item.methodName }
							</Li>
						</c:if>
					</c:forEach>
				</ul>
			</div>
			<a href="javascript:save();" class="ljzf_biao">立即支付</a>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			$(function(){
				$(".czje li").click(function(){
					$(".czje li").removeClass("on");
					$(this).addClass("on");
				})
			})
			function save(){
				var paytype = $(":radio:checked").val();
				var price = $(".on").find("em:first").text();
				if(paytype==null){
					tipinfo("请选择支付方式");
					return false;
				}
				if(price==null || price==''){
					tipinfo("请选择充值金额");
					return false;
				}
				$.ajax({
					type : "POST",
					url : "/usercenter/mymoney/createOrder",
					data : {"price" : price,"paytype":paytype},
					success : function(data) {
						if(data.result==1){
							var paylogId = data.paylogId;
							var paytype = data.paytype;
							window.location.href="/pay/waittingPay?paylogId="+paylogId+"&paytype="+paytype;
						}else{
							alertinfo(data.msg);
						}
					},
					error : function(data) {
						tipinfo("网络连接失败..")
					}
				});
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
