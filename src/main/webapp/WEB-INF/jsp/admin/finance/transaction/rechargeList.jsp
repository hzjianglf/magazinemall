<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
	
	<m:Content contentPlaceHolderId="css">
		<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
		<style type="text/css">
		body{
			height: 100%;
		}
		.layui-form-mid {
			margin-left: 10px;
		}
	</style>
	</m:Content>
	
	<m:Content contentPlaceHolderId="content">
		<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		
			<blockquote class="layui-elem-quote layui-bg-blue">
				充值记录列表
			</blockquote>
			
		</div>
	</m:Content>
	
	<m:Content contentPlaceHolderId="js">
	
	</m:Content>
	
</m:ContentPage>