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
					<tr id="title">
						<th colspan="5">
							<button class="layui-btn layui-btn-radius layui-btn-primary mytw">我的旁听</button>
							<button class="layui-btn layui-btn-radius layui-btn-primary twmy">旁听我的</button>
						</th>
					</tr>
					<tr class="tr1" style="border:2px solid gray;border-right-style:none;border-left-style:none;">
						<th style="text-align: center;">旁听日期</th>
						<th style="text-align: center;">旁听者</th>
						<th style="text-align: center;">被提问者</th>
						<th style="text-align: center;">问题</th>
						<th style="text-align: center;">旁听金额（元）</th>
					</tr>
					<c:forEach items="${Myaudit }" var="list">
						<tr class="tr1">
							<th style="text-align: center;">${list.inputTime }</th>
							<th style="text-align: center;">${list.realname }</th>
							<th style="text-align: center;">${list.name }</th>
							<th style="text-align: center;">${list.content }</th>
							<th style="text-align: center;">${list.price }</th>
						</tr>
					</c:forEach>
					<tr class="tr2" style="border:2px solid gray;border-right-style:none;border-left-style:none;">
						<th style="text-align: center;">旁听日期</th>
						<th style="text-align: center;">旁听者</th>
						<th style="text-align: center;">被提问者</th>
						<th style="text-align: center;">问题</th>
						<th style="text-align: center;">旁听金额（元）</th>
					</tr>
					<c:forEach items="${list2 }" var="list2">
						<tr class="tr2">
							<th style="text-align: center;">${list2.inputTime }</th>
							<th style="text-align: center;">${list2.realname }</th>
							<th style="text-align: center;">${list2.name }</th>
							<th style="text-align: center;">${list2.content }</th>
							<th style="text-align: center;">${list2.price }</th>
						</tr>
					</c:forEach>
				</thead>
			</table>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript">
	$(function(){
		var type = '${userType}'; 
		if(type=='1'){
			$("#title").hide();
			$(".tr1").show();
			$(".tr2").hide();
		}else{
			$(".tr1").show();
			$(".tr2").hide();
		}
		//我的提问
		$(".mytw").click(function(){
			$(".tr1").show();
			$(".tr2").hide();
		})
		//提问我的
		$(".twmy").click(function(){
			$(".tr1").hide();
			$(".tr2").show();
		})
	})
</script>
</m:Content>
</m:ContentPage>
