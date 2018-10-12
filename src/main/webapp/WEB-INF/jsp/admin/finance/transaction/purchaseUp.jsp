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
				订单状态
			</blockquote>
			<div class="layui-row" style="margin: 0px 50px; ">
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo grid-demo-bg1">订单编号：
			    	<c:if test="${source eq '1'}">
			    		${data[0].orderNo }
			    	</c:if>
			    	<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
			    		${data.orderNo }
			    	</c:if>
			    </div>
			  </div>
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo">运费（元）：0.00</div>
			  </div>
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo grid-demo-bg1">订单金额（元）：
			    	<span class="layui-col-color"><c:if test="${source eq '1'}">
			    		${data[0].price }
			    	</c:if>
			    	<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
			    		${data.price }
			    	</c:if></span>
			    </div>
			  </div>
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo">订单状态：
			    	<c:if test="${data[0].orderstatus eq '1' }">待支付</c:if>
			    	<c:if test="${data[0].orderstatus eq '2' }">待发货</c:if>
			    	<c:if test="${data[0].orderstatus eq '3' }">待收货</c:if>
			    	<c:if test="${data[0].orderstatus eq '4' }">待评价</c:if>
			    	<c:if test="${data[0].orderstatus eq '5' }">已完成</c:if>
			    	<c:if test="${data[0].orderstatus eq '6' }">已取消</c:if>
			    	<c:if test="${data[0].orderstatus eq '7' }">退款中</c:if>
			    	<c:if test="${source eq '3'||source eq '4'||source eq '5' }">已完成</c:if>
			    </div>
			  </div>
			</div>
			<blockquote class="layui-elem-quote layui-bg-gray" style="padding-left: 45px;font-size: 17px;">
				订单详情
			</blockquote>
			<div style="padding-left:50px;line-height: 30px; height:30px;font-size: 16px;" class="layui-col-border">
				订单信息
			</div>
			<div class="layui-row" style="margin: 0px 50px; ">
				<div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo grid-demo-bg1">买家：
					    <c:if test="${source eq '1'}">
				    		${data[0].userName }
				    	</c:if>
				    	<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
				    		${data.userName }
				    	</c:if>
				    </div>
				  </div>
				  <div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo">下单时间：
					    <c:if test="${source eq '1'}">
				    		${data[0].addtime }
				    	</c:if>
				    	<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
				    		${data.inputDate }
				    	</c:if>
				    </div>
				  </div>
				  <div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo grid-demo-bg1">支付方式：
					    <c:if test="${source eq '1'}">
				    		${data[0].orderNo }
				    	</c:if>
				    	<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
				    		${data.orderNo }
				    	</c:if>
				    </div>
				  </div>
				  <div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo">支付时间：
					    <c:if test="${source eq '1'}">
				    		${data[0].payTime }
				    	</c:if>
				    	<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
				    		${data.payTime }
				    	</c:if>
				    </div>
				</div>
			</div>
			<div style="padding-left:50px;line-height: 30px; height:30px;font-size: 16px;" class="layui-col-border">
				收货人及发货信息
			</div>
			<div class="layui-row" style="margin: 0px 50px; ">
				
				<div class="layui-col-xs6 layui-col-height">
					<c:if test="${source eq '1'}">
					    <div class="grid-demo grid-demo-bg1">收货人姓名：${data[0].receivername }</div>
					  </div>
					  <div class="layui-col-xs6 layui-col-height">
					    <div class="grid-demo">电话号码：${data[0].receiverphone }</div>
					  </div>
					  <div class="layui-col-xs12 layui-col-height">
					    <div class="grid-demo grid-demo-bg1">详细地址：${data[0].receiverAddress }</div>
				    </c:if>
					<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
						无
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
			      <th>单价(元)</th>
			      <th>实际支付金额(元)</th>
			      <th>数量</th>
			    </tr> 
			  	<c:if test="${source eq '1'}">
			  	 <c:forEach var="ent" items="${data }">
				    <tr>
				      <td>
				      <c:if test="${not empty ent.productpic }">
				      	<image  src="${ent.productpic}" title="${ent.productname }"  width="45" height="45"/>
				      </c:if>
				      ${ent.productname }
				      
				      </td>
				      <td>
				      	<c:if test="${ent.producttype eq '1' }">实物</c:if>
				      	<c:if test="${ent.producttype eq '2' }">期刊</c:if>
				      	<c:if test="${ent.producttype eq '4' }">点播</c:if>
				      	<c:if test="${ent.producttype eq '8' }">直播</c:if>
				      	<c:if test="${ent.producttype eq '16' }">电子书</c:if>
				      </td>
				      <td>${ent.dprice }</td>
				      <td>${ent.buyprice }</td>
				      <td>${ent.count }</td>
				    </tr> 
				 </c:forEach>
				 </c:if>
				<c:if test="${source eq '3'||source eq '4'||source eq '5'}">
				<tr>
					<c:if test="${source eq '3'||source eq '4'}">
				      <td>${data.content }</td>
				    </c:if>
				    <c:if test="${source eq '5'}">
				      <td>给&nbsp;${data.content }&nbsp;的打赏</td>
				    </c:if>
				      <td>
				      	<c:if test="${source eq '3'}">提问</c:if>
				      	<c:if test="${source eq '4'}">旁听</c:if>
				      	<c:if test="${source eq '5'}">打赏</c:if>
				      </td>
				      <td>${data.dprice }</td>
				      <td>${data.price }</td>
				      <td>1</td>
				</tr> 
				</c:if>
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