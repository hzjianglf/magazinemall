<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.layui-form-label{
			      padding: 9px 0;
			    text-align: left;
			    font-size: 16px;
			    width: 100px;
			}
			.layui-form-item .layui-input-inline {
			    float: left;
			    width: 94px;
			    margin-right: 6px;
			}
			.inputAllBox {
			    width: 500px;
			    margin: 30px auto;
			}
			.inputAllBox>.input-item>input{
			        width: 390px;
			}
			.layui-form-item .layui-input-inline{
			      width: 127px;
			}
			
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="checkOrder">
			<p class="title">确认订单</p>
			<c:if test="${id>0 }">
				<div class="shouJianRenIns">
					<div class="orderCon">
						<p class="title">
							收件人信息
							<a class="addShoouJianRen" href="javascript:void(0)">新增收件人信息></a>
						</p>
							<c:forEach items="${address }" var="item">
								<c:if test="${item.isDefault eq 1 }">
									<div class="orderCon" id="orderCon">
										<div class="oContent">
											收件人姓名：<span class="sjrName">${item.receiver }</span> 电话：
											<span>${item.phone }</span>
											<p>地址：${item.province }${item.city }${item.county }${item.detailedAddress }</p>
										</div>
									</div>
								</c:if>
							</c:forEach>
					</div>
					<p>
						<a data-state="0" class="allShoouJianRen" href="javascript:void(0)">
							全部收件人
							<img class="foldImg" src="/img/down.png" alt="" />
						</a>
					</p>
				</div>
				</c:if>
				<div class="AllAddressee">
					<c:forEach items="${address }" var="item">
						<div class="orderCon">
							<input type="radio" name="checkAds" ${item.isDefault==1?checked:'' } data-val="${item.Id }" />
							<div class="oContent">
								收件人姓名：<span class="sjrName">${item.receiver }</span> 电话：
								<span>${item.phone }</span>
								<p>地址：${item.province }${item.city }${item.county }${item.detailedAddress }</p>
							</div>
						</div>
					</c:forEach>
				</div>
			
			<div class="orderSec">
				<div class="orderCon">
					<p class="title">商品信息</p>
					<c:forEach items="${list }" var="item">
						<div class="oContent">
							<img src="${item.productpic }" alt="" />
							<div class="oRightCon">
								<h2 class="oName">${item.productname }</h2>
								<c:if test="${item.producttype==16}">
									<span>电子期刊</span>
								</c:if>
								<c:if test="${item.producttype==2}">
									<span>纸媒版</span>
								</c:if>
								<c:if test="${item.subType==1 }">
									<span>单期 &nbsp; ${item.names }</span>
								</c:if>
								<c:if test="${item.subType==2 }">
									<span>上半年刊</span>
								</c:if>
								<c:if test="${item.subType==3 }">
									<span>下半年刊</span>
								</c:if>
								<c:if test="${item.subType==4 }">
									<span>全年</span>
								</c:if> 
								
								<p class="priceAndNum">
									<span>￥${item.buyprice}</span>
									<span>X${item.count }</span>
								</p>
							</div>
						</div>
					</c:forEach>
					<div class="youHuiJuan">
						<p>
							<span>优惠券</span><c:if test="${fn:length(couponsDataList.lists) < 1 }" > 暂无可用优惠券</c:if>
							<div class="youHuiJuanList">
								<input type="hidden" id="coupons" value="" data-val="" />
								<ul>
								<c:forEach items="${couponsDataList.lists }" var="item">
									<li>
										<span>￥${item.jianprice }</span>
										<p>满${item.manprice }元可用</p>
										<p>
											<span>${item.startTime }</span>-
											<span>${item.endTime }</span>
											<input name="coupons" onclick="couponsInput(${item.jianprice },${item.Id },this)" type="radio" />
										</p>
									</li>
								</c:forEach>
								</ul>
							</div>
						</p>
						<p>
							<span>代金券</span><c:if test="${fn:length(voucherDataList.lists) < 1 }" >暂无可用代金券</c:if>
							<div class="youHuiJuanList">
							<input type="hidden" id="voucher" value="" data-val="" />
								<ul>
								<c:forEach items="${voucherDataList.lists }" var="item">
									<li>
										<span>￥${item.price }</span>
										<p>
											<span>${item.startTime }</span>-
											<span>${item.endTime }</span>
											<input name="voucher" onclick="voucherInput(${item.price },${item.Id },this)" type="radio" />
										</p>
									</li>
								</c:forEach>
								</ul>
							</div>
						</p>
					</div>
					<div class="totlanum">
						<p>总金额：<span>￥${price }</span></p>
						<c:if test="${id!=null && yunfei > 0 }">
						<p>运费：<span>￥${yunfei }</span></p></c:if>
						<p>应付：<span class="yingFu">￥${price + yunfei }</span></p>
						<button class="submitOrder">提交订单</button>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" id="addressId" value="${id }">
		<input type="hidden" id="shoppingIds" value="${ids }"/>
		<input type="hidden" id="yunfei" value="${yunfei }"/>
		<input type="hidden" id="price" value="${price }">
		<div id="dia"></div>
		<div id="addressIns">
			<img class="closeThat" src="/img/closedia.png" alt="" />
			<div class="inputAllBox">
				<div class="input-item oh">
					<span>收件人姓名：</span>
					<input type="text" id="receiver" placeholder="请输入收件人姓名" />
				</div>
				<div class="input-item oh">
					<span>电话：</span>
					<input type="text" id="phone" placeholder="请输入手机号" />
				</div>
				<form class="layui-form">
						<div class="layui-form-item">
			                <label class="layui-form-label">选择地区</label>
			                <div class="layui-input-inline">
			                    <select name="provid" id="provid" lay-filter="provid" lay-verify="required">
			                        <option value="">请选择省</option>
			                    </select>
			                </div>
			                <div class="layui-input-inline">
			                    <select name="cityid" id="cityid" lay-filter="cityid" lay-verify="required">
			                        <option value="">请选择市</option>
			                    </select>
			                </div>
			                <div class="layui-input-inline">
			                    <select name="areaid" id="areaid" lay-filter="areaid" lay-verify="required">
			                        <option value="">请选择县/区</option>
			                    </select>
			                </div>
			            </div>
	            </form>
				<div class="input-item oh">
					<span></span>
					<input type="text" id="detailedAddress" placeholder="请输入详细地址" />
				</div>
			</div>
			<div class="handleBtnBox">
				<button class="queDing" onclick="saveAddress()">保存</button>
				<button class="cancel" onclick="closeThat()">取消</button>
			</div>
			<input type="hidden" id="addressId" value="">
			<input type="hidden" id=isDefault value="">
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/logistics/assets/data.js"></script>
    	<script type="text/javascript" src="/manage/logistics/assets/province.js"></script>
		<script type="text/javascript">
			var form;
			layui.use(['laydate','form'], function(){
				  var laydate = layui.laydate;
				  form = layui.form;
			
			});
			var wHeight = $(window).height();
			var wWidth = $(window).width();
			$(function() {
				$('#addressIns').css({
					"top": (wHeight - 300) / 2,
					"left": (wWidth - 600) / 2
				})
			})
			window.onresize = function() {
				var wHeight = $(window).height();
				var wWidth = $(window).width();
				$('#addressIns').css({
					"top": (wHeight - 300) / 2,
					"left": (wWidth - 600) / 2
				})
			}
			//获取优惠券
			function couponsInput(pic,id,Obj){
				if(Obj.checked){
					$('#coupons').val(id).data("val",pic);
				}else{
					$('#coupons').val('').data("val","");
				}
				calculation();
			}
			//获取代金券
			function voucherInput(pic,id,Obj){
				if(Obj.checked){
					$('#voucher').val(id).data("val",pic);
				}else{
					$('#voucher').val('').data("val","");
				}
				calculation();
			}
			//订单提交
			$('.submitOrder').click(function(){
				var data = {"addressId":$("#addressId").val(),"shopCartIds":$('#shoppingIds').val(),
						"couponId":$("#coupons").val(),"voucherId":$("#voucher").val()};
				toSave(data);
			});
			
			function toSave(data){
				$.ajax({
					type : "POST",
					url : "judgeCreateOrder",
					data : data,
					success : function(data) {
						if(data.totalPrice!=''&&data.totalPrice!=null){
							price = data.totalPrice;
						}
						if(data.orderId==0){
							tipinfo("支付成功！");
							setTimeout(function(){window.location.href="/home/index"},1000);
						}else if (data.orderId>0){
							window.location.href="/order/toCreateOrder?paylogId="+data.orderId
													+"&totalPrice="+data.totalPrice;
						}else{
							tipinfo("操作失败！！");
						}
					},
					error : function(data) {
						/* tipinfo("网络连接失败..") */
					}
				});
			}
			//重新计算金额
			function calculation(){
				var yunfei = Number($('#yunfei').val());
				var price = Number($('#price').val());
				var coupons = Number($('#coupons').data('val'));
				var voucher = Number($('#voucher').data('val'));
				var pic = yunfei + price - coupons - voucher;
				pic<1?pic=0.00:pic;
				$('.yingFu').html("￥"+pic.toFixed(2));
			}
			$('.allShoouJianRen').click(function(){
				if($(this).attr('data-state') == "0"){
					$(this).attr('data-state',"1");
					$(this).find("img").attr('src',"/img/up.png");
					$('.AllAddressee').addClass('show');
				}else if($(this).attr('data-state') == "1"){
					$(this).attr('data-state',"0");
					$(this).find("img").attr('src',"/img/down.png");
					$('.AllAddressee').removeClass('show');
				}
			})
			$('.addShoouJianRen').click(function(){
				$('#dia').show();
				$('#addressIns').show();
			})
			$('.closeThat').click(function(){
				$('#dia').hide();
				$('#addressIns').hide();
			});
			function closeThat(){
				$('.closeThat').click();
			}
			$('input[name="checkAds"]').click(function(){
				$('#addressId').val($(this).data('val'));
				$('#orderCon').html($(this).parent().html()).find('input').remove();
				yunfeiAjax($(this).data('val'));
			});
			//重新计算运费
			function yunfeiAjax(id){
				$.ajax({
					type:'post',
					url:'calculationYunfei',
					data:{ids:$('#shoppingIds').val(),addressId:id},
					success:function(data){
						$('#yunfei').val(data.data);
						calculation();
					}
				});
			}
			//添加收货地址
			function saveAddress(){
				var provid = $("#provid").val();
				var cityid = $("#cityid").val();
				var areaid = $("#areaid").val();
				var receiver = $("#receiver").val();
				var phone = $("#phone").val();
				if(provid==''||provid==null ||cityid==''||cityid==null ||areaid==''||areaid==null ||receiver==''||receiver==null ||phone==''||phone==null){
					tipinfo("请填写数据");
					return false;
				}
				var reg = /^1[0-9]{10}$/;
				if( !reg.test(phone)){
					tipinfo("手机号有误");
					return false;
				}
				data = { Id:"",
						province:provid,
						city:cityid,
						county:areaid,
						receiver:receiver,
						phone:phone,
						detailedAddress:$("#detailedAddress").val(),
						isDefault:$('#isDefault').val()
					}
				console.log(data);
				$.ajax({
					type : "POST",
					url : "/usercenter/account/saveAddress",
					async : false,
					data : data,
					success : function(data) {
						tipinfo(data.msg);
						setTimeout(function(){ location.reload(); },600);
					},
					error : function(data) {

					}
				});
			}
		</script>
		
	</pxkj:Content>
</pxkj:ContentPage>
