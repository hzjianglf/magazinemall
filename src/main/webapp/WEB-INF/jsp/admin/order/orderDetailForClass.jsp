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
			<div class="layui-row" style="margin: 0px 50px; ">
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo grid-demo-bg1">
			    	订单编号：${orderNo}
			    </div>
			  </div>
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo">订单金额（元）：${totalprice}</div>
			  </div>
			  <div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo">下单时间：
					    ${addTime}
				    </div>
				  </div>
			  <div class="layui-col-xs6 layui-col-height">
			    <div class="grid-demo">订单状态：
			    	<c:if test="${orderstatus eq '1' }">待支付</c:if>
			    	<c:if test="${orderstatus eq '2' }">待发货</c:if>
			    	<c:if test="${orderstatus eq '3' }">待收货</c:if>
			    	<c:if test="${orderstatus eq '4' }">待评价</c:if>
			    	<c:if test="${orderstatus eq '5' }">已完成</c:if>
			    	<c:if test="${orderstatus eq '6' }">已取消</c:if>
			    	<c:if test="${orderstatus eq '7' }">退款中</c:if>
			    </div>
			  </div>
			</div>
			<div class="layui-row" style="margin: 0px 50px; ">
				<div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo grid-demo-bg1">买家：
					    ${userName }
				    </div>
				  </div>
				  <div class="layui-col-xs6 layui-col-height">
				    <div class="grid-demo grid-demo-bg1">支付方式：
				    <c:if test="${orderstatus!=1 && orderstatus!=6}">
					   ${payMethodName}
				    </c:if>
				    </div>
				  </div>
				  <div class="layui-col-xs6 layui-col-height">
				  <c:if test="${payTime!=null && orderstatus!=1 && orderstatus!=6}">
				    <div class="grid-demo">支付时间：
				    		 ${payTime }
				    </div>
				  </c:if>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="text-align: center;">
			<button class="layui-btn" style="width: 50%;margin-top: 10px;" id="closeWindow" onclick="setUpinfo();">关闭</button>
		</div>
	</m:Content>
	
	<m:Content contentPlaceHolderId="js">
		<script>
			function setUpinfo(){
				closewindow();
			}
		</script>
	</m:Content>

</m:ContentPage>