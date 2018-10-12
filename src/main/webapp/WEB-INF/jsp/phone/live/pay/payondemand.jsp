<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>结算</h3>
		</div>
		<div class="jxzf">
			<!--订阅结算-->
			<div class="jxzf_top">
				<div class="jxzf_nr">
					<img src="${data.picUrl }">
					<h3>${data.name }</h3>
					<h5>大咖：<em>${data.realname }</em></h5>
					<h4>￥${data.presentPrice }</h4>
					<input type="hidden" value=${data.presentPrice } id="price">
					<input type="hidden" value=${data.classtype } id="type">
					<input type="hidden" value=${data.ondemandId } id="productId">
					<div class="clear"></div>
				</div>
				<div class="jxzf_yh">
					<a href="javascript:void(0)" onclick="getCouponsByType()"><i id="coupon">优惠券<i></a>
					<input type="hidden" id="couponId" value=0>
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
			<div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
			<div class="jxzf_fs">
				<h3>支付方式：</h3>
				<ul>
					<c:forEach items="${paylist }" var="paylist" varStatus="cw">
						<li>
							<c:if test="${paylist.payType == '账户余额支付' }">
								<c:if test="${data.presentPrice > balance}">
									<a href="/usercenter/mymoney/trunRecharge" class="cz_biao">充 值</a>
								</c:if>
								<c:if test="${balance > data.presentPrice }">
									<span class="radio_box">
				                   		<input type="radio" id="radio_${cw.count }" ${cw.count==1?'checked':'' } name="radio" value="${paylist.id }" data-name="${paylist.methodName }" data-type="${paylist.payType }">
				                   		<label for="radio_${cw.count }"></label>
			                   		</span>
								</c:if>
							</c:if>
							<c:if test="${paylist.payType != '账户余额支付' }">
								<span class="radio_box">
			                   		<input type="radio" id="radio_${cw.count }" name="radio" value="${paylist.id }" data-name="${paylist.methodName }" data-type="${paylist.payType }">
			                   		<label for="radio_${cw.count }"></label>
		                   		</span>
	                   		</c:if>
							<img src="${paylist.picUrl }"> ${paylist.methodName }
							<c:if test="${paylist.payType == '账户余额支付' }">
								<em>￥${balance } ${(balance < data.presentPrice)?'（余额不足）':'' }</em>
							</c:if>
						</li>
					</c:forEach>
				</ul>
			</div>
			<div class="wxts">
				温馨提示：<br><em>商品购买完成后不可退回。</em>
			</div>
			<button class="qr_biao" type="button" onclick="pay('${data.ondemandId }','${data.classtype }');">确认支付   ￥<i id="totalprice">${data.presentPrice }</i></button>
			<input type="hidden" id="price" value="${data.presentPrice }">
			<div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			//确认支付（商品类型,点播课程4，直播课程8）
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
			}
			function deleteLogin() {
				var del = document.getElementById("login_box");
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
			//选择优惠券回显到页面
			function choose(id,name,price){
				$("#coupon").html(name);
				$("#couponId").val(id);
				var totalprice = $("#price").val()-price;
				totalprice = Number(totalprice).toFixed(2);
				$("#totalprice").html(totalprice);
				deleteLogin();
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
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
