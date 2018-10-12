<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			.jLeft img{
				width:140px;
				heigth:140px;
				border-radius:25px;
			}
			.layui-layer-content{
				color:#fff;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="checkOrder">
			<p class="title">支付中心</p>
			<div class="orderSec zhiFuCon">
				<div class="orderCon">
					<!-- <p class="title">订单：2018071009140001</p> -->
					<div class="oContent">
						<img src="${picUrl }" alt="" />
						<span class="oName">${name }</span>
						<span class="priceCon">需要支付金额:￥${price }</span>
					</div>
					<div class="youHuiJuan zhifuType">
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
										<a href="/phone/usercenter/mymoney/trunRecharge" class="cz_biao">充 值</a><img src="${item.picUrl }"> 余额支付 <em>￥${balance }</em>
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
					<div class="totlanum">
						<button class="submitOrder" type="button" onclick="payForPC('${data.ondemandId }','${data.classtype }');">提交订单</button>
					</div>
				</div>
				
			</div>
		</div>
		
		<input type="hidden" name="userId" id="userId" value="${userId}"/>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript">
			var layer;
			layui.use('layer', function(){
				layer = layui.layer;
			});
			function tipinfo(obj){
				layer.msg(obj);
			}
			//选择地址
			$("#MyAddress").click(function(){
				var url = window.location.href;
				tipinfo("跳转到收货地址选择页面")
				//window.location.href="/phone/usercenter/account/toChoiceAddress?ids=${address.ids }&url="+url;
			});	
			function deleteLogin() {
				var del = document.getElementById("login_box");
				var del2 = document.getElementById("login_box2");
				var bg_filter = document.getElementById("bg_filter");
				bg_filter.style.display = "none";
				del.style.display = "none";
				del2.style.display = "none";
			}
			
			function deleteLogin2() {
				var del = document.getElementById("login_box2");
				var bg_filter = document.getElementById("bg_filter");
				bg_filter.style.display = "none";
				del.style.display = "none";
			}
			function showBox() {
				var show = document.getElementById("login_box");
				var bg_filter = document.getElementById("bg_filter");
				show.style.display = "block";
				bg_filter.style.display = "block";
			}
			
			function showBox2() {
				var show = document.getElementById("login_box2");
				var bg_filter = document.getElementById("bg_filter");
				show.style.display = "block";
				bg_filter.style.display = "block";
			}
			//选择优惠券回显到页面
			function choose(id,name,price){
				//页面显示优惠券的价格
				$("#couponDisplay").html(Number(price).toFixed(2));
				//页面储存优惠券的价格
				$("#couponPrice").val(price);
				//页面显示优惠券的名字
				$("#coupon").html(name);
				//页面储存代金券的id
				$("#couponId").val(id);
				//计算需要支付的价格（随时计算的）课程价格+运费-代金券-优惠券
				var price2 = Number($("#price2").val());
				var yunfei = Number($("#yunfei").val());
				var voucherPrice = Number($("#voucherPrice").val());
				var totalprice = price2+yunfei-price-voucherPrice;
				
				totalprice = Number(totalprice).toFixed(2);
				$("#totalprice").html(totalprice);
				$("#price").val(totalprice);
				deleteLogin();
			}
			//选择代金券回显到页面
			function voucher(id,name,price){
				//页面显示的代金券的价格
				$("#voucherDisplay").html(Number(price).toFixed(2));
				//页面储存代金券的价格
				$("#voucherPrice").val(price);
				//页面显示代金券的名字
				$("#voucher").html(name);
				//页面储存代金券的id
				$("#voucherId").val(id);
				//计算需要支付的价格（随时计算的）课程价格+运费-代金券-优惠券
				var price2 = Number($("#price2").val());
				var yunfei = Number($("#yunfei").val());
				var couponPrice = Number($("#couponPrice").val());
				var totalprice = price2+yunfei-price-couponPrice;
				totalprice = Number(totalprice).toFixed(2);
				
				if(totalprice <= 0){
					totalprice = 0;
				}
				$("#totalprice").html(totalprice);
				$("#price").val(totalprice);
				deleteLogin2();
			}
			//弹出可用优惠券
			function getCouponsByType(){
				var types = $("#type").val();
				var type = 4;
				if(types==0){
					//点播
					type=3;
				}
				$.ajax({
					type : "GET",
					url : "/order/getCouponsByType",
					data : {"type":type,"productId":$("#productId").val(),"price":$("#price").val()},
					success:function(obj){
						if(obj.success){
							$(".ul1").html('');
							$.each(obj.lists,function(i,val){
								var type = "定向券";
								if(this.couponType==1){
									type="品类券";
								}
								$(".ul1").append("<li onclick=choose(\'"+this.Id+"\',\'"+this.name+"\',\'"+this.jianprice+"'\)>"+this.name+","+type+"<br>有效期至"+this.endTime+"</li>");
								$(".ul1").append("<br>")
							})
							if(obj.lists!=null && obj.lists.length>0){
								$(".ul1").append("<li onclick=choose(0,\'不使用优惠券\',0)><strong>不使用优惠券</strong></li> ")
							}else{
								$(".ul1").append("<li onclick=choose(0,\'无可用优惠券\',0)><strong>无可用优惠券</strong></li> ")
							}
							showBox();
						}else{
							tipinfo("获取失败...")
						}
					},
					error:function(obj){
						tipinfo("网络连接失败..")
					}
				})
			}
			//弹出可用代金券
			function getVoucherByType(){
				var types = $("#type").val();
				var type = 4;
				if(types==0){
					//点播
					type=3;
				}
				$.ajax({
					type : "GET",
					url : "/order/getVoucherByType",
					data : {"type":type,"productId":$("#productId").val(),"price":$("#price").val()},
					success:function(obj){
						if(obj.success){
							$(".ul2").html('');
							$.each(obj.lists,function(i,val){
								var type = "定向券";
								if(this.couponType==1){
									type="品类券";
								}
								$(".ul2").append("<li onclick=voucher(\'"+this.Id+"\',\'"+this.name+"\',\'"+this.price+"'\)>"+this.name+","+type+"<br>有效期至"+this.endTime+"</li>");
								$(".ul2").append("<br>")
							})
							if(obj.lists!=null && obj.lists.length>0){
								$(".ul2").append("<li onclick=voucher(0,\'不使用代金券\',0)><strong>不使用代金券</strong></li> ")
							}else{
								$(".ul2").append("<li onclick=voucher(0,\'无可用代金券\',0)><strong>无可用代金券</strong></li> ")
							}
							showBox2();
						}else{
							tipinfo("获取失败...")
						}
					},
					error:function(obj){
						tipinfo("网络连接失败..")
					}
				})
			}
			//判断并转
			function payForPC(ondemandId,classtype){
				var addressId = $("#addressId");
				if(addressId>1){
					var gwc_top = $('.gwc_top').text();
					if(gwc_top==null||gwc_top==''){
						tipinfo("订阅内容涉及到发货，请填入收件地址！");
					}
				}
				var producttype = 0;
				if(classtype=='0'){
					producttype=4;
				}else{
					producttype=8;
				}
				$.ajax({
					type:'post',
					data:{"productId":ondemandId,"producttype":producttype,"couponId":$("#couponId").val(),"voucherId":$("#voucherId").val(),"addressId":$("#addressId").val()},
					url:'/home/product/judgePayOndemand',
					datatype:'json',
					success:function(data){
						var paylogId = data.data.paylogId;
						if( paylogId == 0){
							tipinfo("支付成功！");
							setTimeout(function(){window.location.href="/home/product/toClass?type=1"},1000); 
						}else if ( paylogId > 0){
							window.location.href="/product/toPayOndemand?paylogId="+paylogId+"&money="+$('#totalprice').text()+"&ondemandId="+${ondemandId };
						}else{
							tipinfo("操作有误，请重新操作")
						}
					},
					error:function(){
						tipinfo("出错了!");
					}
				}) 
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
