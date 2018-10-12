<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1);" class="a1">
			<img src="/images/fh_biao.png"class="fh_biao"></a>
			<h3>我的地址</h3>
		</div>
		<input type="hidden" value="${ids }" id="ids"></input>
		<div class="wddz_lb" style="margin-bottom: 80px;">
		<c:forEach items="${list }" var="item">
				<div class="wddz_nr" >
					<div onclick="turn(${item.Id })">
						<h3>
							<em>${item.phone }</em>${item.receiver }
						</h3>
						<h4>${item.province }${item.city }${item.county }${item.detailedAddress }</h4>
					</div>
					<h5>
						<span class="radio_box">
							<input type="radio" onclick="changeAddress(${item.Id})" id="radio_${item.Id }" name="radio" ${item.isDefault==1?'checked':'' } style="display:none">
							<label for="radio_${item.Id }"></label>
							&nbsp;&nbsp;
						</span>默认地址
					</h5>
				</div>
			</c:forEach>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			function turn(id){
				if($("#ids").val()==null||$("#ids").val()==''){
					window.location.href="/order/turnShopcart";
				}
				var url = '${url }';
				//跳转到上以页面，吧地址传过去
				window.location.href=url+"&addressId="+id;
			}
			function changeAddress(id){
				$.ajax({
					type : "POST",
					url : "/usercenter/account/changeAddressDefault",
					async : false,
					data : {
						"id" : id
					},
					success : function(data) {
						alert(data.msg);
					},
					error : function(data) {

					}
				});
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
