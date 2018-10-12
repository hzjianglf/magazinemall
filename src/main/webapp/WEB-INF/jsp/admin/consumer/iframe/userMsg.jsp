<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
		.layui-input, .layui-textarea {
		    display: block;
		    width: 100%;
		    padding-left: 10px;
		    background: #f1f0f7;
		    border: none;
		}
		.layui-input-block {
		    margin-left: 76px;
		    min-height: 36px;
		}
		.layui-form-item>.layui-inline{
			width:262px;
		}
		.layui-form-item>.layui-inline .layui-form-label{
			width:100px;
			padding:0;
			text-align:left;
			text-indent:15px;
			line-height:38px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div class="layui-tab">
		<div class="layui-tab-content">
			<div class="layui-form-item">
			    <div class="layui-inline">
			    	<label class="layui-form-label">昵称：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="nickName" disabled="disabled" value="${nickName }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">性别 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="sex" disabled="disabled" value="${sex }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">出生年份 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="birthDate" disabled="disabled" value="${birthDate }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">手机号 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="telenumber" disabled="disabled" value="${telenumber }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">注册时间 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="registrationDate" disabled="disabled" value="${registrationDate }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
			    	<label class="layui-form-label">积分 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="accountJF" disabled="disabled" value="${accountJF }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">余额 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="balance" disabled="disabled" value="${balance }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">学历 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="education" disabled="disabled" value="${education }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">行业 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="industry" disabled="disabled" value="${industry }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			    <div class="layui-inline">
			    	<label class="layui-form-label">职业 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="occupation" disabled="disabled" value="${occupation }" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
			    	<label class="layui-form-label">状态 ：</label>
			        <div class="layui-input-inline">
			        	<input type="tel" name="phone" disabled="disabled" autocomplete="off" class="layui-input">
			        </div>
			    </div>
			</div>
			<div class="layui-form-item">
				<div class="layui-form-item layui-form-text">
				    <label class="layui-form-label">简介：</label>
				    <div class="layui-input-block">
				      <textarea name="synopsis" disabled="disabled" placeholder="请输入内容" class="layui-textarea">${synopsis }</textarea>
				    </div>
				</div>
			</div>
			
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
</m:Content>
</m:ContentPage>
