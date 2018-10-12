<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div class="layui-tab">
		<div class="layui-tab-content">
			<table style="width: 100%;">
				<thead>
					<tr style="border:2px solid gray;border-right-style:none;border-left-style:none;">
						<th style="text-align: center;">订单编号</th>
						<th style="text-align: center;">订单状态</th>
						<th style="text-align: center;">下单时间</th>
						<th style="text-align: center;">支付状态</th>
						<th style="text-align: center;">订单金额(元)</th>
						<th style="text-align: center;">发货状态</th>
					</tr>
					<c:forEach items="${list }" var="list">
						<tr>
						<th style="text-align: center;">${list.orderno }</th>
						<th style="text-align: center;">${list.orderstatus }</th>
						<th style="text-align: center;">${list.addtime }</th>
						<th style="text-align: center;">${list.paystatus }</th>
						<th style="text-align: center;">${list.totalprice }</th>
						<th style="text-align: center;">${list.deliverstatus }</th>
					</tr>
					</c:forEach>
				</thead>
			</table>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
</m:Content>
</m:ContentPage>
