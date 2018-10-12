<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<link href="/css/index.css"  rel="stylesheet">
		<link href="/css/base.css"  rel="stylesheet">
		<style type="text/css">
			.element {
			    width: 13.2rem;
			    height: 4.55rem;
			    float: left;
			}
			.hj_qr{
				height:2rem;
			}
			.hj_qr a:last-child{
				width:100% !important;
				background:#1AAD19 !important;
				color:#fff;
				line-height: 2rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="#" class="a1" id="goup"><img src="/images/fh_biao.png"
				class="fh_biao"></a>
		</div>
		<div class="djq">
			<div class="xxk xxk2">
				<ul>
					<li class="on" data-val="1"><em>|</em><span>待确认</span></li>
					<li data-val="2"><em>|</em><span>已确认</span></li>
					<li data-val="3"><span>待发货</span></li>
				</ul>
			</div>
			<div class="det_content2">
				<div class="dqr" id="Div_Temp_1">
					<div class="wddd_nr wddd_nr1" id="Div_Content_1">
					
					</div>
					
				</div>
				<div class="dqr hide" id="Div_Temp_2">
					<div class="wddd_nr wddd_nr1" id="Div_Content_2">

					</div>
				</div>
				<div class="dqr hide" id="Div_Temp_3">
					<div class="wddd_nr wddd_nr1" id="Div_Content_3">
						
					</div>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$("#goup").click(function(){
				window.history.go(-1);
			});
			$(function() {
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					$('.det_content2').children('div').hide();
					$('.det_content2').children('div').eq($(this).index()).show();
					for(var i = 1 ; i<=3 ; i++){
						$("#Div_Content_"+i).html("");
					}
					Loading($(this).data("val"));
				});
				Loading(1);
			});
			function Loading(type){
				$.ajax({
						type:"POST",
						url: "/usercenter/account/oDetail?type="+type+"&orderId="+'${orderId}',
						success: function(html){
						  $("#Div_Content_"+type).append(html);
						}
					});
			}
			function invoiceList(type,orderId,invoiceId){
				window.location.href="/usercenter/account/invoiceList?type="+type+"&orderId="+orderId+"&invoiceId="+invoiceId;
			}
			//修改订单状态
			function updOrderStatus(invoiceId){
				var invoiceIds=[];
				var orderId=0;
				$('input:checkbox:checked').each(function(){
					orderId = $(this).val();
					var v = $(this).data("val");
					console.log(v);
					if (invoiceIds.indexOf(v) == -1) {
						invoiceIds.push(v);
					}
				})
				/* $.each(,function(){
					for(var i = 0 ; i<$('input[type=checkbox]:checked').length ; i++ ){
						orderId = $(this).val();
						var v = $(this).data("val");
						if (invoiceIds.indexOf(v) == -1) {
							invoiceIds.push(v);
						}
					}
	            }); */
				var invoiceId = invoiceIds.join(',');
				var orderId = $('#orderId').val();
				console.log(invoiceIds)
				if(invoiceIds.length < 1){
					alert("请选择确定商品!");
				}else if(orderId == "" || orderId == null){
					alert("操作有误!请重新操作!!")
				}else{
					//window.location.href="/usercenter/account/upOStatus?orderId="+orderId+"&invoiceId="+invoiceId;
					$.ajax({
						type:"post",
						data:{orderId:orderId,invoiceId:invoiceId},
						url:"/usercenter/account/upOStatus",
						dataType:"json",
						success:function(data){
							if(data.result){
								tipinfo(data.msg);
								$('.xxk').find('li').eq(1).click();
							}
						}
					});
				}
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>