<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage  materPageId="master">

	<m:Content contentPlaceHolderId="css">
	
		<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
		<style type="text/css">
			body{
				height: 100%;
			}
			.layui-col-height{
				height:50px;
				line-height: 40px;
			}
			.layui-col-border{
				border-bottom: 1px dashed #aaa;
			}
			.layui-col-color{
				color:#F00;
			}
		</style>
	</m:Content>
	
	<m:Content contentPlaceHolderId="content" >
		<div style="padding: 30px;" class="layui-anim layui-anim-upbit">
			<blockquote class="layui-elem-quote layui-bg-gray" style="padding-left: 45px;font-size: 17px;">
				订单详情
			</blockquote>
			<div style="padding-left:50px;line-height: 30px; height:30px;font-size: 16px;" class="layui-col-border">
				订单信息
			</div>
			<div class="layui-row" style="margin: 0px 50px; ">
				<div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo grid-demo-bg1">订单编号：
					    ${data[0].orderno }
				    </div>
				</div>
				<div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo">下单时间：
					   ${data[0].addtime }
				    </div>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					    <div class="grid-demo">商品总额：
						   ¥${data[0].totalprice - data[0].postage }
					    </div>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					<c:if test="${data[0].postage != null }">
						<div class="grid-demo">运费金额：
						   <span class="layui-col-color">¥${(empty data[0].postage)?'0':data[0].postage }</span>
					    </div>
					</c:if>
					    
				</div>
				<div class="layui-col-xs6 layui-col-height">
					    <div class="grid-demo">订单状态：
						   <c:if test="${data[0].orderstatus=='1' }">
								等待买家付款
							</c:if>
							<c:if test="${data[0].orderstatus=='2' }">
								等待卖家发货
							</c:if>
							<c:if test="${data[0].orderstatus=='3' }">
								已发货，待收货
							</c:if>
							<c:if test="${data[0].orderstatus=='4' }">
								待评价
							</c:if>
							<c:if test="${data[0].orderstatus=='5' }">
								订单已完成
							</c:if>
							<c:if test="${data[0].orderstatus=='6' }">
								订单已取消
							</c:if>
							<c:if test="${data[0].orderstatus=='7' }">
								退款中
							</c:if>
					    </div>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					    <div class="grid-demo">支付金额(包含运费)：
						   ¥${status eq "等待买家付款"?0:data[0].payprice }
					    </div>
				</div>
				<div class="layui-col-xs6 layui-col-height">
				    <c:if test="${data[0].methodName != null }">
						<div class="grid-demo">支付方式：
						   ${data[0].methodName }
					    </div>
					</c:if>
				</div>
				<div class="layui-col-xs6 layui-col-height">
				    <c:if test="${data[0].payTime != null }">
						<div class="grid-demo">支付时间：
						   ${data[0].payTime }
					    </div>
					</c:if>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					 <c:if test="${data[0].jianprice != null }">
						<div class="grid-demo">优惠券金额：
						   ¥${data[0].jianprice }
					    </div>
					</c:if>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					 <c:if test="${data[0].voucherPrice != null }">
						<div class="grid-demo">代金券金额：
						   ¥${data[0].voucherPrice }
					    </div>
					</c:if>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					<c:forEach items="${data[0].itemList }" var="itemby">
						<c:if test="${itemby.delivername != '' && itemby.delivername != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }">
							<div class="grid-demo">快递公司：
							   ${itemby.delivername }
						    </div>
						</c:if>
					</c:forEach>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					<c:forEach items="${data[0].itemList }" var="itemby">
						<c:if test="${itemby.expressNum != '' && itemby.expressNum != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }">
							<div class="grid-demo">快递单号：
							   ${itemby.expressNum }
						    </div>
						</c:if>
					</c:forEach>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					<c:if test="${data[0].receivername != null }">
						<div class="grid-demo">收货人：
						   ${data[0].receivername }
					    </div>
					</c:if>
				</div>
				<div class="layui-col-xs6 layui-col-height">
					<c:if test="${data[0].receiverphone != null }">
						<div class="grid-demo">联系方式：
						   ${data[0].receiverphone }
					    </div>
					</c:if>
					    
				</div>
				<div class="layui-col-xs6 layui-col-height">
					<c:if test="${data[0].receiverAddress != null }">
						<div class="grid-demo">地址：
						   ${data[0].receiverAddress }
					    </div>
					</c:if>
					    
				</div>
			</div>
			<div style="padding-left:50px;line-height: 30px; height:30px;font-size: 16px;" class="layui-col-border">
				商品信息
			</div>
			
				<table class="layui-table">
				  <thead>
				    <tr>
				      <th>商品信息</th>
				      <th>商品类型</th>
				      <th>商品单价</th>
				      <th>数量</th>
				    </tr> 
				  		<c:forEach items="${data[0].itemList }" var="item">
						  	<tr>
						  		<td>
						  			${item.year }${item.productname }
						  		</td>
						  		<td>
						  			<c:if test="${item.producttypes==2}">
										<h4>纸媒版</h4>
									</c:if>
									<c:if test="${item.producttypes==4}">
										<h4>点播</h4>
									</c:if>
									<c:if test="${item.producttypes==8}">
										<h4>直播</h4>
									</c:if>
									<c:if test="${item.producttypes==16}">
										<h4>电子版</h4>
									</c:if>
						  		</td>
								<td>${item.buyprice }</td>
						  		<td>${item.count }</td>
						  	</tr>
						  	<c:forEach items="${item.buySendList }" var="sub">
						  		<tr>
							  		<td>
							  			${sub.year }${sub.productname }
							  		</td>
							  		<td>
							  			<c:if test="${sub.subType==5}">
											<h4>赠品</h4>
										</c:if>
							  		</td>
							  		<td>${sub.buyprice }</td>
									<td>${sub.count }</td>
							  	</tr>
						  	</c:forEach>
				  		</c:forEach>
				  		
				</thead>
			</table>
			
			
			
		</div>
		<div class="layui-form-item" style="text-align: center;">
			<button class="layui-btn" style="width: 50%;margin-top: 10px;" id="closeWindow" onclick="setUpinfo();">关闭</button>
		</div>
	</m:Content>
	
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script>
			function setUpinfo(){
				closewindow();
			}
		</script>
	</m:Content>

</m:ContentPage>