<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<link rel="stylesheet" href="/manage/zTree/css/metro.css" type="text/css"/>
<style>
ul.ztree{
    margin-top: 10px;
    border: 1px solid #ddd;
    background: #F4F7FD;
    min-width: 235px;
    height: 360px;
    overflow-y: scroll;
    overflow-x: auto;
    z-index:99999;
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<!-- 快递公司添加或编辑 -->
				<input type="hidden" name="id" value="${Id }" />
            	<div class="layui-form-item">
					<label class="layui-form-label">编号：</label>
					<div class="layui-input-block">
						<input type="text" name="" value="${Id }"  autocomplete="off" class="layui-input" placeholder="保存时系统自动生成" disabled="disabled"/>
					</div>
				</div>
				
				<div class="layui-form-item">
					<label class="layui-form-label">快递公司名称：</label>
					<div class="layui-input-block">
						<input type="text" name="name" value="${name }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">联系人：</label>
				    <div class="layui-input-block">
				      <input type="text" value="${userName }" name="userName" class="layui-input">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">联系电话：</label>
				    <div class="layui-input-block">
				      <input type="text" value="${telenumber }" name="telenumber" class="layui-input" >
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">地址：</label>
				    <div class="layui-input-block">
				      <input type="text" value="${address }" name="address" class="layui-input">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">备注：</label>
				    <div class="layui-input-block">
				      <input type="text" value="${remark }" name="remark" class="layui-input">
				    </div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-block">
						<select name="status" lay-verify="required">
							<option value="">无</option>
							<option value="1" ${status==1?'selected':'' }>启用</option>
							<option value="0" ${status==0?'selected':'' }>禁用</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item" style="text-align: center;">
					<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
				</div>
			</form>
		</div>
	</div>
	<div id="menuContent" class="menuContent" data-target="parentId" style="display:none; position: absolute;z-index:9999">
		<ul id="tree" class="ztree" style="margin-top:0; min-width:200px; height: 300px;"></ul>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.all.min.js"></script>
	<script type="text/javascript">
		layui.use('form', function(){
			var form = layui.form;
			//监听首页展示
			form.on('switch(Isdisplay)', function(obj){
				if(obj.elem.checked){
					$("#weight").show();
				}else{
					$("#weight").hide();
				}
			});
			//监听提交
			form.on('submit(addEqBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {
							icon: 1
						}, function() {
							var index = parent.layer.getFrameIndex(window.name);
							 parent.layer.close(index)
						});
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
						});
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/express/addOrUp', postData, success, 'post', 'json');
				return false;
			})
		})
		
	</script>
</m:Content>
</m:ContentPage>