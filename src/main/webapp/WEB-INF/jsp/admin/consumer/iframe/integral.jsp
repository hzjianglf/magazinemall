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
					<tr>
						<th>当前积分：${accountJF }</th>
						<th></th>
						<th style="float: right;"><button class="layui-btn layui-btn-sm">增减积分</button></th>
					</tr>
					<tr style="border:2px solid gray;border-right-style:none;border-left-style:none;">
						<th style="text-align: center;">日期</th>
						<th style="text-align: center;">摘要</th>
						<th style="text-align: center;">积分</th>
					</tr>
					<c:forEach items="${list }" var="list">
						<tr>
							<th style="text-align: center;">${list.time }</th>
							<th style="text-align: center;">${list.reason }</th>
							<c:if test="${list.income=='1' }">
								<th style="text-align: center;">+${points }</th>
							</c:if>
							<c:if test="${list.income=='0' }">
								<th style="text-align: center;">-${points }</th>
							</c:if>
						</tr>
					</c:forEach>
				</thead>
			</table>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript">
	layui.use(['layer','form'], function(){
		var layer = layui.layer;
		var form = layui.form;
		
	})
</script>
</m:Content>
</m:ContentPage>
