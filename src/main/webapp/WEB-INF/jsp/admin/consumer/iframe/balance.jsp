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
						<th colspan="3">当前余额(元)：${account.balance }</th>
					</tr>
					<tr style="border:2px solid gray;border-right-style:none;border-left-style:none;">
						<th style="text-align: center;">日期</th>
						<th style="text-align: center;">摘要</th>
						<th style="text-align: right;">金额（元）</th>
						<th style="text-align: right;">余额（元）</th>
					</tr>
					<c:forEach items="${list }" var="list">
						<tr>
							<th style="text-align: center;">${list.time }</th>
							<th style="text-align: center;">${list.remark }</th>
							<th style="text-align: right;">${list.money }</th>
							<th style="text-align: right;">${list.balance }</th>
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
