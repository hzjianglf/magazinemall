<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<link rel="stylesheet" href="/manage/public/js/themes/default/css/ueditor.css" />
	<style type="text/css">
		.margSub{
			margin:30px auto;
			width:200px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 10px;" class="layui-anim layui-anim-upbit">
	<form class="layui-form" method="post">
		<div class="layui-tab">
			<div class="layui-tab-content" style="background: #FFFFFF;">
		 		<input type="hidden" name="Id" id="Id" value="${Id }"/>
				<div class="layui-form">
	            	<div class="layui-form-item">
						<label class="layui-form-label">站点名称：</label>
						<div class="layui-input-block">
							<input type="text" name="LinkName" id="LinkName" value="${LinkName }" lay-verify="required" autocomplete="off" class="layui-input"/>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">网址：</label>
						<div class="layui-input-block" >
							 <input type="text" name="LinkUrl" id="LinkUrl" value="${LinkUrl }" autocomplete="off" class="layui-input"/>
						</div>
					</div>
					
					<div class="layui-form-item layui-form-text">
						<label class="layui-form-label">描述</label>
						<div class="layui-input-block">
							<textarea placeholder="请输入内容" name="Description" id="Description" class="layui-textarea">${Description }</textarea>
						</div>
					</div>
					
					<div class="layui-form-item">
						<label class="layui-form-label">联系电话：</label>
						<div class="layui-input-block">
							<input type="text" name="TelePhone" id="TelePhone" value="${TelePhone }" autocomplete="off" class="layui-input"/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="margSub">
			<button class="layui-btn" style="width:200px" lay-submit lay-filter="saveBtn">保存内容</button>
		</div>
	</form>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript">
	layui.use(['laydate' , 'form'], function(){
		var laydate = layui.laydate;
		var form = layui.form;
		//电话是否验证
		$("#TelePhone").change(function(){
			$("#TelePhone").val()==""?$("#TelePhone").removeAttr("lay-verify"):$("#TelePhone").attr('lay-verify','phone')
		})
		//修改
		form.on('submit(saveBtn)', function(data) {
			layer.load(2, {
				shade: [0.8, '#393D49']
			});
			var success = function(response) {
				var result = response;
				if(result.success) {
					layer.alert(result.msg, {
						icon: 1
					}, function() {
						var index = parent.layer.getFrameIndex(window.name);
						console.log(index);
						parent.layer.close(index)
					});
				} else {
					layer.alert(result.msg, {
						icon: 2
					}, function() {
						layer.closeAll();
					});
				}
			}
			var data = {
				Id: data.field.Id,
				LinkName: data.field.LinkName,
				LinkUrl: data.field.LinkUrl,
				Description: data.field.Description,
				TelePhone: data.field.TelePhone
			}
			console.log(data);
			ajax("/${applicationScope.adminprefix }/link/addLink", data, success, 'post', 'json');
			return false;
		});
		
	})

	
</script>
</m:Content>
</m:ContentPage>
