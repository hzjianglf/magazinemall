<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			.ddnr_r {
				    float: right;
				    height: 4.6rem;
				    width: 10.5rem;
				}
			.ddnr_r1{
				float: right;
			    height: 0.9rem;
			    width: 10.5rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a onclick="fanhui();" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>我的订单</h3>
		</div>
		<div class="wddd">
			<div class="wddd_top">
				<ul>
					<li><a href="javascript:;" class="handleItem on" data-status="-1">全部   </a></li>
					<li><a href="javascript:;" class="handleItem" data-status="1">待付款   </a></li>
					<li><a href="javascript:;" class="handleItem" data-status="5">已完成   </a></li>
					<li><a href="javascript:;" class="handleItem" data-status="6">已取消   </a></li>
				</ul>
			</div>
			<div class="wddd_lb" id="det_content2">
				<!-- 存放查询订单信息 -->
				<div id="orderContent"></div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function(){
				Loading(-1);
			})
			//样式选中
			$('.wddd_top').find('li>a').click(function() {
				$('.wddd_top').find('li>a').removeClass('on');
				$(this).addClass('on');
				//获取选中的tab值
				var status = $(this).data('status');
				$("#orderContent,#Div_Temp").empty().next().remove();
				Loading(status);
			});
			var flg = false;
			function Loading(type){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#det_content2' //流加载容器 
					    , isAuto: true
				       , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	if(flg){
					    		tipinfo("操作过于频繁");
					    		return ;
					    	}
					    	flg = true;
					    	$.get("/usercenter/account/selectPartOrder",{
								page:page,
								pageSize:6,
								orderstatus:type,
								r:Math.random()
							},function(html){
								$("#orderContent,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
								flg = false;
							},"html")
					    }
					  });
				});
			}
			
			//订单详情
			function orderDetail(orderId){
				//获取当前订单
				var status = $("div[data-status="+orderId+"]").prev().html();
				console.log(status+"--"+orderId);
				window.location.href="/usercenter/account/orderDetail?orderId="+orderId+"&status="+status;
			}
			function fanhui(){
				window.location.href="/usercenter/account/index";
			}
			
			function toDetails(status,orderId){
				window.location.href="/usercenter/account/toDetail?orderId="+orderId;
			}
			
			//删除订单
			function delOrder(orderId){
				$.ajax({
					type:"get",
					url:"/usercenter/account/delOrder",
					data:{"userId":${userId},"orderId":orderId},
					datatype:"html",
					async:false,
					success:function(data){
						tipinfo(data.msg);
						setTimeout(function() { 
							location.reload(); 
						},1000)
					},
					
				})
			}
			
			//取消订单
			function updOrderStatus(orderstatus,orderId){
				var data = {orderstatus:orderstatus,orderId:orderId}
				$.post("/usercenter/account/updOrderStatus",data);
				setTimeout(function(){tipinfo("取消成功");$('.handleItem.on').click();}, 800);
				
			}
			//支付
			function turnzhifu(orderId,paylogId,totalprice){
				var url = window.location.pathname;
				window.location.href="/order/toCreateOrder?orderId="+orderId+"&paylogId="+paylogId+"&totalPrice="+totalprice+"&url="+url;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
