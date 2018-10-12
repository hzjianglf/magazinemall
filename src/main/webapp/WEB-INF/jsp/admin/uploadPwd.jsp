<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib  uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="px"%>
<px:ContentPage materPageId="master">
	<px:Content contentPlaceHolderId="css">
		<style>
			.layui-layer-title{
				background: 009688;
			}
		</style>
	</px:Content>
	<px:Content contentPlaceHolderId="content">
		<form>
			<div style="width:300px;heigth:50px;margin:0 auto;text-align: center;line-height: 50px;"><h2>${userName }</h2></div>
			<div style="width:340px;margin:0px auto;">
				<div class="layui-inline">
					<label class="layui-form-label">原密码：</label>
					<div class="layui-input-inline">
					<input type="text" name="userPwd" placeholder="请输入原密码" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">修改密码：</label>
					<div class="layui-input-inline">
					<input type="password" name="userPwdNew" placeholder="请输入修改密码" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">确认密码：</label>
					<div class="layui-input-inline">
					<input type="password" name="password" placeholder="确认密码" class="layui-input">
					</div>
				</div>
			</div>
		</form>
		<div style="width:100px;margin:20px auto;">
			 <button class="layui-btn" style="width:100px" id="subPwd">立即提交</button>
		</div>
	</px:Content>
	<px:Content contentPlaceHolderId="js">
		<script>
			$('#subPwd').click(function(){
				var userPwdOld = $("input[name='userPwd']").val();
				if(userPwdOld ==null || userPwdOld == ''){
					tipinfo("原密码不能为空");
					return;
				}
				var userPwd = $("input[name='userPwdNew']").val();
				if(userPwd ==null || userPwd == ''){
					tipinfo("新密码不能为空");
					return;
				}
				var password = $("input[name='password']").val();
				if(password ==null || password == ''){
					tipinfo("请填入确认密码");
					return;
				}
				$.ajax({
					type:'post',
					url:getUrl('login/upPwd'),
					data:$('form').serialize()+"&userId="+${userId},
					success:function(data){
						if(data.success){
							alert(data.msg);
							closewindow();
						}else{
							tipinfo(data.msg);
						}
					}
				})
			});
		</script>
	</px:Content>
</px:ContentPage>