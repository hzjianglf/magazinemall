<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			.lb_nr_xq ul li {
			    line-height: 0.725rem;
			    font-size: 0.55rem;
			    border: none;
			    padding: 0 0.25rem;
			}
			.gwc_top h4 img {
			    width: 0.6rem;
			    height: 0.8rem;
			    margin: -0.2rem 0.25rem 0 0;
			}
			.yf{
			font-size:12px;
			padding-left:10px;
			color:#888;
			}
			.yf p{
				margin:10px 0px;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>结算</h3>
		</div>
		<c:if test="${data.isAddress!=0 }">
			<div class="gwc_top">
				<div id="MyAddress">
					<h3>收货人：${address.receiver }  <em>${address.phone } </em></h3>
					<h4><img src="/images/dw_biao.png">收货地址：${address.province }${address.city }${address.county }${address.detailedAddress }</h4>
				</div>
			</div>
		</c:if>
		<div class="jxzf">
			<!--订阅结算-->
			<div class="jxzf_top">
				<div class="jxzf_nr">
					<img src="${data.picUrl }">
					<h3>${data.name }</h3>
					<h5>大咖：<em>${data.realname }</em></h5>
					<h4>￥${data.presentPrice }</h4>
					<input type="hidden" value=${data.presentPrice } id="price2">
					<input type="hidden" value=${data.presentPrice + yunfei } id="price">
					<input type="hidden" value=${data.classtype } id="type">
					<input type="hidden" value=${data.ondemandId } id="productId">
					<input type="hidden" value="${addressId }" id="addressId"> 
					<input type="hidden" value="${yunfei }" id="yunfei" />
					<input type="hidden" id="voucherPrice" value="0" />
					<input type="hidden" id="couponPrice" value="0"/>
					<input type="hidden" id="couponId" />
					<input type="hidden" id="voucherId" />
					<div class="clear"></div>
				</div>
				<div class="jxzf_yh">
					<a href="javascript:void(0)" onclick="getCouponsByType()"><i id="coupon">优惠券<i></a>
					<a href="javascript:void(0)" onclick="getVoucherByType()"><i id="voucher">代金券<i></a>
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
				  	<ul class="ul2">
				  		
				  	</ul>
				  </div>	
		         <a href="javascript:void(0)" onClick="deleteLogin2()" class="gb_biao">关闭</a>
			</div>
			<div class="yf">
				<c:if test="${data.isAddress!=0 }">
					<p>运费：￥<span id="yunFeiDisplay">${yunfei }</span></p>
					<c:set var="exitId" value="1"/>
				</c:if>
				<p>优惠券：￥<span id="couponDisplay">0.00</span></p>
				<p>代金券：￥<span id="voucherDisplay">0.00</span></p>
				<p>总支付金额：￥<span id="priceAllDisplay"><i id="totalprice">${data.presentPrice + yunfei }</i></span></p>
			</div>
			<div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
			<div class="wxts">
				温馨提示：<br><em>商品购买完成后不可退回。</em>
			</div>
			<button class="qr_biao" type="button" onclick="pay('${data.ondemandId }','${data.classtype }');">确认订单 </button>
			<input type="hidden" id="price" value="${data.presentPrice }">
			<div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			//选择地址
			$("#MyAddress").click(function(){
				var url = window.location.href;
				window.location.href="/usercenter/account/toChoiceAddress?ids=${address.ids }&url="+url;
			});
			//判断并转
			function pay(ondemandId,classtype){
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
					url:'/product/judgePayOndemand',
					datatype:'json',
					success:function(data){
						var paylogId = data.data.paylogId;
						if( paylogId == 0){
							tipinfo("支付成功！");
							setTimeout(function(){window.location.href="/product/classList"},1000); 
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
		
			/* //确认支付（商品类型,点播课程4，直播课程8）
			function pay(ondemandId,classtype){
				//获取支付方式id
				var paytype = $("input[type='radio']:checked").val();
				//支付方式类型
				var type = $("input[type='radio']:checked").data('type');
				if(paytype==null || paytype==''){
					tipinfo("请选择支付方式");
					return false;
				}
				var producttype = 0;
				if(classtype=='0'){
					producttype=4;
				}else{
					producttype=8;
				}
				$.ajax({
					type:'post',
					data:{"productId":ondemandId,"producttype":producttype,"couponId":$("#couponId").val()},
					url:'/pay/generateOrder',
					datatype:'json',
					success:function(data){
						if(data.success){
							//跳转支付等待页面
							window.location.href="/pay/waittingPay?paylogId="+data.paylogId+"&paytype="+paytype+"&typeName="+type;
						}
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
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
						if(obj.result==1){
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
							tipinfo(obj.msg)
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
						if(obj.result==1){
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
