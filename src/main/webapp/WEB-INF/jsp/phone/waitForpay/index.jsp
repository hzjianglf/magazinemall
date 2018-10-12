<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<c:choose>
			<c:when test="${payResult.online}">
				<c:choose>
					<c:when test="${payResult.success}">
						<p style="color:green;font-size: 20px;margin-left: 10px;margin-top: 20px;">支付中...</p>
						${payResult.requestData}
					</c:when>
					<c:otherwise>
						<p style="color:red;font-size: 20px;margin-left: 10px;margin-top: 20px;">支付失败！</p>
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${success}">
						<p id="paySuccess" style="color:green;font-size: 20px;margin-left: 10px;margin-top: 20px;">支付成功！</p>
					</c:when>
					<c:otherwise>
						<p style="color:red;font-size: 20px;margin-left: 10px;margin-top: 20px;">支付失败！</p>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$(function(){
				var success=${success};
				if(success){
					//暂时写成这样
					$("#paySuccess").text("支付成功！3秒后跳回首页");
					setTimeout(function(){
						window.location.href="/home/index";
					},3000);
				}
			})
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
