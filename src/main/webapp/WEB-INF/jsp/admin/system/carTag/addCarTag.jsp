<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib  uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="master">
<pxkj:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body {
			height: 100%;
		}
		input {
			width: 240px!important;
		}
		.layui-form-select {
			width: 240px!important;
		}
	</style>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 10px 40px;background: #FFF;margin: 20px;" class="layui-anim layui-anim-upbit">
		<form id="carTagInfo" class="layui-form">
			<input type="hidden" name="id" value="${id }"/>
			<div class="layui-form">
           		<div class="layui-form-item">
					<label class="layui-form-label">标签编号：</label>
					<div class="layui-input-inline">
						<input type="text" name="code" value="${requestScope.code }" class="layui-input" readonly="readonly"/>
					</div>
				</div>
           		<div class="layui-form-item">
					<label class="layui-form-label">标签名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" value="${requestScope.name }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">适用类型：</label>
					<div class="layui-input-inline">
					    <select name="type" lay-verify="required">
					    	<option value="">请选择</option>
					    	<option value="1" ${type==1?"selected='selected'":"" }>品牌</option>
							<option value="2" ${type==2?"selected='selected'":"" }>车系</option>
							<option value="3" ${type==3?"selected='selected'":"" }>车型</option>
					    </select>
				    </div>
			    </div>
				<div class="layui-form-item">
					<label class="layui-form-label">标签状态：</label>
					<div class="layui-input-inline">
					    <select name="status" id="status" lay-verify="required">
					    	<option value="">请选择</option>
					    	<option value="1" ${status==1?"selected='selected'":"" }>启用</option>
							<option value="0" ${status==0?"selected='selected'":"" }>禁用</option>
					    </select>
				    </div>
			    </div>
			</div>
			<div style="text-align: center;margin-top: 40px;">
				<button class="layui-btn" lay-submit lay-filter="saveBtn">保存内容</button>
			</div>
		</form>
	</div>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use('form', function(){
			var form = layui.form;
			form.on('submit(saveBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {icon: 1}, function(){
							var index = parent.layer.getFrameIndex(window.name);
							parent.layer.close(index);
						})
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/system/carTag/saveCarTag', postData, success, 'post', 'json');
				return false;
			});
		})
	</script>
</pxkj:Content>
</pxkj:ContentPage>