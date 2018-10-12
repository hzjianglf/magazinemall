<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
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
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>支付</h3>
		</div>
		<div class="demo1">需要支付金额</div>
		<div class="demo1">￥${price }</div>
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
								<a href="/usercenter/mymoney/trunRecharge" class="cz_biao">充 值</a><img src="${item.picUrl }"> 余额支付 <em>￥${balance }</em>
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

		<button class="qr_biao" type="button" onclick="pay('${data.ondemandId }','${data.classtype }');">确认支付 </button>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			//确认支付（商品类型,点播课程4，直播课程8）
			function pay(ondemandId,classtype){
				//获取支付方式id
				var paytype = $("input[type='radio']:checked").val();
				if(paytype==null || paytype==''){
					tipinfo("请选择支付方式");
					return false;
				}
				var paylogId = ${paylogId };
				if(paylogId==null || paylogId==''){
					tipinfo("操作失误，从新操作！");
					setTimeout(function(){window.location.href="/product/classList"},1000);
				}else{
					window.location.href="/pay/waittingPay?paylogId="+paylogId+"&paytype="+paytype;
				}
				
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
