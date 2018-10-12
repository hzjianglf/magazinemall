<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>添加角色</title>
	<link rel="stylesheet" href="/manage/public/layui/css/layui.css">
</head>
<body>
	<!-- 内容主体区域 -->
	<div style="padding: 0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box"
			style="border-color: #666; border-radius: 3px; padding: 10px;">
			<form class="layui-form" action="">
				<div class="layui-form-item">
					<label class="layui-form-label">原密码：</label>
					<div class="layui-input-block">
						<input type="password" name="oldPwd" lay-verify="oldPwd"
							autocomplete="off" placeholder="请输入原密码" class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">新密码：</label>
					<div class="layui-input-block">
						<input type="password" name="newPwd" lay-verify="newPwd"
							autocomplete="off" placeholder="请输入新密码" class="layui-input">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">确认密码：</label>
					<div class="layui-input-block">
						<input type="password" lay-verify="confirmPwd"
							autocomplete="off" placeholder="请输入新密码" class="layui-input">
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
<script type="text/javascript" src="/manage/public/js/jquery-1.11.3.js"></script>
<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
<script>
	//JavaScript代码区域
	layui.use([ 'element', 'layer', 'form', 'laydate' ], function() {
		var element = layui.element;
		var layer = layui.layer;
		var form = layui.form;
		var laydate = layui.laydate;
		//一些事件监听
		element.on('tab(demo)', function(data) {
			layer.msg('切换了：' + this.innerHTML);

		});

		laydate.render({
			elem : '#date'
		});

		//自定义验证规则
		form.verify({
			oldPwd : function(value) {
				if (value.length = 0) {
					return '请输入原密码！';
				}
			},
			newPwd : [ /(.+){6,12}$/, '密码必须6到12位！' ],
			confirmPwd : function(value) {
				if (value != $('input[name="newPwd"]').val()) {
					return '两次新密码不相同！';
				}
			}
		});

		//监听提交
		form.on('submit(formDemo)', function(data) {
			layer.msg(JSON.stringify(data.field));
			return false;
		});

	});
</script>
    
</html>