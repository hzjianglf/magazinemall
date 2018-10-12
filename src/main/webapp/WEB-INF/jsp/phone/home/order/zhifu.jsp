<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.demo1{
			        width: 185px;
				    font-size: 18px;
				    text-align: center;
				    margin: 10px auto;
				    color:#888;
			}
		</style>
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="${url }" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>付款</h3>
		</div>
		<div class="demo1">需要支付金额</div>
		<div class="demo1">￥${totalPrice }</div>
		<div class="jxzf_fs">
				<h3>支付方式：</h3>
				<ul>
					<c:forEach var="item" items="${payMethods }" varStatus="c">
						<c:if test="${item.payType == '账户余额支付' }">
							<li>
								<c:if test="${pricePVbalan }">
										<span class="radio_box">
											<input type="radio" id="radio_${c.count }" name="radio" value="${item.id }" data-name="${item.methodName }" data-type="${item.payType }">
											<label for="radio_${c.count }"></label>
										</span>
								 </c:if>
								<a href="/usercenter/mymoney/trunRecharge" class="cz_biao">充 值</a><img src="${item.picUrl }"> 余额支付 <em>￥${balan }</em>
								<c:if test="${!pricePVbalan }"><em>(余额不足)</em></c:if>
							</li>
						</c:if>
						<c:if test="${item.payType != '账户余额支付' }">
							<li>
								<span class="radio_box">
				                   <input type="radio" id="radio_${c.count }" name="radio" value="${item.id }" data-name="${item.methodName }" data-type="${item.payType }">
				                   <label for="radio_${c.count }"></label>
			       			 	</span>
								<img src="${item.picUrl }"> ${item.methodName }
							</li>
						</c:if>
				</c:forEach>
				</ul>
			</div>
			<button onclick="save()" class="qr_biao">确认支付   <i id="price"></i></button>
			<input type="hidden" id="paylogId" value="${paylogId }">
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="js">
		<script>
			function save(){
				 var paytype = $(":radio[name='radio']:checked").val();
				 if(paytype==null){
				 	tipinfo("请选择支付方式");
				 	return false;
				 }
				var arr=[];
				var inputs = $(".jxzf_top").find("input[name=shopcart]");
				$(inputs).each(function(){
					arr.push($(this).val());
				})
				var shopCartIds=arr.join(",");
				var paylogId = $("#paylogId").val();
				if(paylogId==null || paylogId==''){
					window.location.href="/order/turnShopcart";
				}else{
					window.location.href="/pay/waittingPay?paylogId="+paylogId+"&paytype="+paytype;
				}
				
			}
		</script>
	</pxkj:Content>
	
</pxkj:ContentPage>