<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<style>
.uploadBox{
	border: 1px solid gray;
    width: 72%;
    height:220px;
    margin-left: 110px;
    margin-top: 0;
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<input type="hidden" name="id" value="${id }" />
				<div class="layui-form-item">
					<label class="layui-form-label">内容：</label>
					<div class="layui-input-block">
						<textarea placeholder="请输入回答内容" name="answer" id="questionMsg"  rows="10" cols="40"></textarea>
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" lay-filter="addEqBtn">提交</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use(['form'], function(){
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
						window.parent.location.reload();
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
						});
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/interlocution/answerContentToSave', postData, success, 'post', 'json');
				return false;
			})
		})
	</script>
</m:Content>
</m:ContentPage>