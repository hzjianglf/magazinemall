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
						<th style="text-align: center;width: 40%;">评论内容</th>
						<th style="text-align: center;width:10%;">作者</th>
						<th style="text-align: center;width:10%;">评论类型</th>
						<th style="text-align: center;width:20%;">名称</th>
						<th style="text-align: center;width:15%;">评论日期</th>
						<th style="text-align: center;width:5%;">状态</th>
					</tr>
					<c:forEach items="${list }" var="list">
						<tr>
							<th style="text-align: center;width: 40%;">${list.content }</th>
							<th style="text-align: center;width:10%;">${(empty list.teacherName)?'-':list.teacherName }</th>
							<th style="text-align: center;width:10%;">${list.commentType }</th>
							<th style="text-align: center;width:20%;">${list.className }</th>
							<th style="text-align: center;width:15%;">${list.dateTime }</th>
							<th style="text-align: center;width:5%;">审核通过</th>
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
