<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style type="text/css">
		.typeclass{
			    font-size: 0.6rem;
			    line-height: 1.45rem;
			    color: #999999;
		}
		.lb_nr1 .lb_nr_xq{
			    height: 10.5rem;
		}
		.lb_nr1 {
			    height: 12.3rem;
		}
		.lb_nr_xq ul li {
		    line-height: 1.725rem;
		    font-size: 0.55rem;
		    border: none; */
		    padding: 0 0.25rem;
		}
		.lb_nr_xq ul.ul1 li {
		    padding: 0rem 0.25rem;
		    line-height: 0.725rem;
		}
		.yf{
			font-size:12px;
			padding-left:10px;
			color:#888;
		}
		.yf p{
			margin:10px 0px;
		}
		jxzf_yh a span{
			font-size:12px;
			padding-left:10px;
			color:#888;
		}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>确认订单</h3>
		</div>
			<input type="hidden" id="addressId" value="${Id }">
			<input type="hidden" id="detailedAddress" value="${detailedAddress }">
			<input type="hidden" id="paylogId" value="${paylogId }">
			<input type="hidden" id="yunfei" value="${yunfei }"/>
			<input type="hidden" id="totalprice">
			<input type="hidden" id="price" value="${price }">
			<!-- 代金券的价格 -->
			<input type="hidden" id="voucherPrice"/>
			<!-- 代金券减去的价格 -->
			<input type="hidden" id="catVoucherPrice"/>
			<!-- 优惠券的价格 -->
			<input type="hidden" id="couponPrice"/>
		<div class="jxzf">
			<div class="jxzf_top">
			<c:if test="${Id!=null }">
				<div class="gwc_top">
					<div id="MyAddress">
						<h3>收货人：${receiver }  <em>${phone } </em></h3>
						<h4><img src="/images/dw_biao.png">收货地址：${province }${city }${county }${detailedAddress }</h4>
					</div>
				</div>
			</c:if>
				<c:forEach items="${list }" var="item">
					<div class="jxzf_nr">
						<input type="hidden" value="${item.id }" name="shopcart">
						<img src="${item.productpic }">
						<h3>
							${item.productname }
						</h3>
						<br>
						<h5 class="typeclass">
							<%-- <c:if test="${item.producttype==16}">
								电子版
							</c:if>
							<c:if test="${item.producttype==2}">
								纸媒版
							</c:if>
							<c:if test="${item.subType==1 }">
								单期 &nbsp; ${item.names }
							</c:if>
							<c:if test="${item.subType==2 }">
								上半年刊
							</c:if>
							<c:if test="${item.subType==3 }">
								下半年刊
							</c:if>
							<c:if test="${item.subType==4 }">
								全年
							</c:if>  --%>
							<span style="
    font-size: 0.65rem;
    color:  red;
"><i style="
    font-size: 0.3rem;
">￥</i>${item.buyprice}</span>
    <span style="
    float:  right;
    line-height: 0.9rem;
    font-size: 0.3rem;
">x${item.count }</span>
						</h5>
						<%-- <div class="cpsl">
							<p>单价：￥${item.buyprice}<br>数量：${item.count }<br>总价：￥<span id="zhifuPrice">${item.buyprice*item.count }</span></p>
						</div> --%>
						<input name="subprice" type="hidden" data-subprice="${item.buyprice*item.count}">
						<div class="clear"></div>
					</div>
					<p style="
    text-align: right;
    line-height: 1.65rem;
    background: #fff;
    margin-bottom: 0.5rem;
    font-size: 0.5rem;
    color:  #333;
">共${item.count }件商品 小计：<span style="
    margin-right: 0.5rem;
    font-size: 0.65rem;
    color: red;
"><i>￥</i>${item.buyprice*item.count }</span></p>
				</c:forEach>
				
				<div class="jxzf_yh" style="margin-left: -15px;">
					<a href="javascript:void(0)" onclick="getCouponsByType()">
						<i id="coupon">优惠券</i>
						<!-- <span id="couponDisplay">￥0.00</span> -->
					</a>
					<input type="hidden" id="couponId" value=0>
				</div>
				<div class="jxzf_yh" style="margin-left: -15px;">
					<a href="javascript:void(0)" onclick="getVoucherByType()"> 
						<i id="voucher">代金券</i>
						<!-- <span id="voucherDisplay">0.00</span> -->
					</a>
					<input type="hidden" id="voucherId" value=0>
				</div>
			</div>
			<div class="lb_nr lb_nr1" id="login_box" style="display: none;">
				  <div class="lb_nr_xq">
				  	<h3>优惠券</h3>
				  	<ul class="ul1">
				  		
				  	</ul>
				  </div>	
		         <a href="javascript:void(0)" onClick="deleteLogin()" class="gb_biao">关闭</a>
			</div>
			<div class="lb_nr lb_nr1" id="login_box2" style="display: none;">
				  <div class="lb_nr_xq">
				  	<h3>代金券</h3>
				  	<ul class="ul2 ul1">
				  		
				  	</ul>
				  </div>
				<a href="javascript:void(0)" onClick="deleteLogin2()" class="gb_biao">关闭</a>
			</div>
			<div class="yf">
				<p>运费：<span id="yunFeiDisplay" style="float: right;margin-right:20px;color:red;">￥${yunfei==""?0.0:yunfei }</span></p>
			</div>
		<div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
			<%-- <div class="jxzf_fs">
				<h3>支付方式：</h3>
				<ul>
					<c:forEach var="item" items="${payMethods }" varStatus="c">
						<c:if test="${item.payType == '账户余额支付' }">
							<li>
								<c:if test="${price > balan}">
									<a href="/usercenter/mymoney/trunRecharge" class="cz_biao">充 值</a><img src="${item.picUrl }"> 余额支付 <em>￥${balan }（余额不足）</em>
								</c:if>
								<c:if test="${price <= balan}">
										<img src="${item.picUrl }">余额支付 <em>￥${balan }</em>
										<span class="radio_box">
											<input type="radio" id="radio_${c.count }" name="radio" value="${item.id }" data-name="${item.methodName }" data-type="${item.payType }">
						                    <label for="radio_${c.count }"></label>
					                    </span>
								</c:if>
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
			</div> --%>
		</div>
			<!-- <button onclick="toSave()" class="qr_biao">提交订单  </button> -->
			<div style="
    width: 100%;
    position:  fixed;
    left: 0;
    bottom: 0;
    height: 2rem;
    background: #fff;
">

<a href="#" style="
    float:  right;
    width: 4rem;
    height: 100%;
    text-align:  center;
    line-height: 2rem;
    background: #eb5629;
    color:  #fff;
    font-size: 0.6rem;
" onclick="toSave()">提交订单</a>
    <p style="
    font-size: 0.6rem;
    float: right;
    line-height: 2rem;
    margin-right: 0.5rem;
    color: #666;
">合计金额：<span style="
    color: red;
"><i style="
    font-size: 0.3rem;
">￥</i>${price + yunfei }</span></p>
</div>
			
			<div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
		$("#MyAddress").click(function(){
			var url = window.location.href;
			window.location.href="/usercenter/account/toChoiceAddress?ids=${ids }&url="+url;
		});
		$(function(){
			var totalprice = 0;
			$("input[name='subprice']").each(function(){
				var sub = Number($(this).data("subprice").toFixed(2));
				totalprice+=sub;
			})
			totalprice = Number(totalprice).toFixed(2);
			$("#totalprice").val(totalprice);
			$("#price").val(totalprice);
		});
		function toSave(){
			var arr=[];
			var inputs = $(".jxzf_top").find("input[name=shopcart]");
			$(inputs).each(function(){
				arr.push($(this).val());
			})
			var url = '${url}';
			var price = $("#totalprice").val()
			var shopCartIds=arr.join(",");
			var paylogId = $("#paylogId").val();
			if(paylogId==null || paylogId==''){
				$.ajax({
					type : "POST",
					url : "judgeCreateOrder",
					data : {
							"addressId":$("#addressId").val(),
							"shopCartIds":shopCartIds,
							"couponId":$("#couponId").val(),
							"voucherId":$("#voucherId").val()
					},
					success : function(data) {
						if(data.totalPrice!=''&&data.totalPrice!=null){
							price = data.totalPrice;
						}
						if(data.orderId==0){
							tipinfo("支付成功！");
							setTimeout(function(){window.location.href="/order/turnShopcart"},1000);
						}else if (data.orderId>0){
							window.location.href="/order/toCreateOrder?paylogId="+data.orderId
													+"&totalPrice="+data.totalPrice+"&url="+url;
						}else{
							tipinfo("操作失败！！");
						}
					},
					error : function(data) {
						tipinfo("网络连接失败..")
					}
				});
			}else{
				window.location.href="/order/toCreateOrder?paylogId="+paylogId
									+"&price="+$("#totalprice").val();
			}
				
		}
		/* function save(){
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
				$.ajax({
					type : "POST",
					url : "/order/createOrder",
					data : {
							"addressId":$("#addressId").val(),
							"shopCartIds":shopCartIds,
							"paytype":paytype,
							"couponId":$("#couponId").val(),
							"voucherId":$("#voucherId").val()
					},
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
			}else{
				window.location.href="/pay/waittingPay?paylogId="+paylogId+"&paytype="+paytype;
			}
			
		} */
		
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
			$("#coupon").html(name);
			$("#couponId").val(id);
			//代金券减免的价格
			var catVoucherPrice = Number($("#catVoucherPrice").val());
			var yunfei = Number($("#yunfei").val());
			//总的价格
			var price2 = Number($("#price").val());
			//支付的价格
			var totalprice = price2+yunfei-catVoucherPrice-price;
			totalprice = Number(totalprice).toFixed(2);
			if(totalprice<=0){
				totalprice = "0.00";
			}else if (totalprice == "undefined"){
				tipinfo("操作有误请重新操作！")
			}
			$("#priceAllDisplay").html(totalprice);
			$("#couponPrice").val(price);
			$("#couponDisplay").html(price);
			deleteLogin();
		}
		//选择代金券回显到页面
		function voucher(id,name,price){
			var addressId = $("#addressId").val();
			if(id>0){
				var arr=[];
				var inputs = $(".jxzf_top").find("input[name=shopcart]");
				$(inputs).each(function(){
					arr.push($(this).val());
				})
				var shopCartIds=arr.join(",");
				$.ajax({
					type : "post",
					url : "/order/catPrice",
					data : { "shopCartIds":shopCartIds , "voucherId" : id , "addressId" : addressId},
					async : false,
					success : function(data){
						if(!data.success){
							tipinfo(data.msg);
						}
						$("#catVoucherPrice").val(data.data);
					}
				});
			}else{
				$("#catVoucherPrice").val("0");
			}
			$("#voucher").html(name);
			$("#voucherId").val(id);
			var couponPrice = Number($("#couponPrice").val());
			var yunfei = Number($("#yunfei").val());
			//商品总价格
			var price2 = Number($("#price").val());
			//代金券减免的价格
			var catVoucherPrice = $("#voucherPrice").val();
			//支付的价格
			var totalprice = yunfei + price2 - price - couponPrice;
			voucherPrice = Number(totalprice).toFixed(2);
			if(voucherPrice<=0){
				voucherPrice = "0.00";
			}else if (voucherPrice == "undefined"){
				tipinfo("操作有误请重新操作！")
			}
			$("#priceAllDisplay").html(voucherPrice);
			$("#voucherPrice").val(price);
			price = Number(price).toFixed(2);
			$("#voucherDisplay").html(price);
			deleteLogin2();
		}
		//弹出可用优惠券
		function getCouponsByType(){
			var arr=[];
			var inputs = $(".jxzf_top").find("input[name=shopcart]");
			$(inputs).each(function(){
				arr.push($(this).val());
			})
			var shopCartIds=arr.join(",");
			$.ajax({
				type : "GET",
				url : "/order/getCouponsByType",
				data : {"type":2,"productId":shopCartIds,"price":$("#price").val()},
				success:function(obj){
					if(obj.result==1){
						$(".ul1").html('');
						if(obj.lists!=null){
							$.each(obj.lists,function(i,val){
								var type = "定向券";
								if(this.couponType==1){
									type="品类券";
								}
								$(".ul1").append("<li onclick=choose(\'"+this.Id+"\',\'"+this.name+"\',\'"+this.jianprice+"'\)>"+this.name+","+type+"<br>有效期至"+this.endTime+"</li>");
								$(".ul1").append("<br>")
							})
						}
						if(obj.lists!=null){
							$(".ul1").append("<li onclick=choose(0,\'不使用优惠券\',0)><strong>不使用优惠券</strong></li> ")
						}else{
							$(".ul1").append("<li onclick=choose(0,\'无可用优惠券\',0)><strong>无可用优惠券</strong></li> ")
						}
						showBox();
					}else{
						tipinfo(obj.msg)
					}
				},
				error:function(obj){
					tipinfo("网络连接失败..")
				}
			});
		}
		//弹出可用代金券
		function getVoucherByType(){
			var arr=[];
			var inputs = $(".jxzf_top").find("input[name=shopcart]");
			$(inputs).each(function(){
				arr.push($(this).val());
			});
			var shopCartIds=arr.join(",");
			$.ajax({
				type : "GET",
				url : "/order/getVoucherByType",
				data : {"type":2,"productId":shopCartIds,"price":$("#price").val()},
				success:function(obj){
					if(obj.result==1){
						$(".ul2").html('');
						if(obj.lists!=null){
							$.each(obj.lists,function(i,val){
								var type = "";
								if(this.couponType==1){
									type="品类券";
								}else if(this.couponType==2){
									type = "定向券";
								}
								$(".ul2").append("<li onclick=voucher("+this.Id+",\'"+this.name+"\',\'"+this.price+"'\)>"+this.name+","+type+"<br>有效期至"+this.endTime+"</li>");
								$(".ul2").append("<br>");
							})
						}
						if(obj.lists!=null && obj.lists.length>0){
							$(".ul2").append("<li onclick=voucher(0,\'不使用代金券\',0)><strong>不使用代金券</strong></li> ");
						}else{
							$(".ul2").append("<li onclick=voucher(0,\'无可用代金券\',0)><strong>无可用代金券</strong></li> ");
						}
						showBox2();
					}else{
						tipinfo(obj.msg)
					}
				},
				error:function(obj){
					tipinfo("网络连接失败..")
				}
			})
		}
		</script>
		
	</pxkj:Content>
</pxkj:ContentPage>
