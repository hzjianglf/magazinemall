<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<input type="hidden" name="id" value="${id }" />
            	<div class="layui-form-item">
					<label class="layui-form-label">标签编号：</label>
					<div class="layui-input-block">
						<input type="text" name="" value="${id }"  autocomplete="off" class="layui-input" placeholder="保存时系统自动生成" disabled="disabled"/>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">标签名称：</label>
					<div class="layui-input-block">
						<input type="text" name="name" value="${name }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">适用类型：</label>
				    <div class="layui-input-block">
				      <select name="classification" lay-verify="required">
				        <option value=""></option>
				        <option value="图书" ${classification=='图书'?'selected':'' }>图书</option>
						<option value="作家" ${classification=='作家'?'selected':'' }>作家</option>
						<option value="课程" ${classification=='课程'?'selected':'' }>课程</option>
						<option value="专家答疑" ${classification=='专家答疑'?'selected':'' }>专家答疑</option>
				      </select>
				    </div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">标签状态：</label>
					<div class="layui-input-block">
						<select name="status">
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
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use('form', function(){
			var form = layui.form;
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
				ajax('/${applicationScope.adminprefix }/labels/addOrUp', postData, success, 'post', 'json');
				return false;
			})
		})
	</script>
</m:Content>
</m:ContentPage>