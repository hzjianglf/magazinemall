<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<style>


</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
		<!-- 内容主体区域 -->
		<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
			

			<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
					<form class="layui-form" action="">
					<input type="hidden" name="userId" id="userId" value="${userMap.userId }" />
					<input type="hidden" id="userType" value="${userType }" />
						<div class="layui-form-item">
							<label class="layui-form-label">用户名：</label>
							<div class="layui-input-block">
								<input type="text" name="userName" value="${userMap.userName }" lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">密码：</label>
							<div class="layui-input-block">
								<input type="password" name="userPwd" value="" lay-verify="pass" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">手机号：</label>
							<div class="layui-input-block">
								<input type="text" name="telenumber" value="${userMap.telenumber }" lay-verify="phone" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">邮箱：</label>
							<div class="layui-input-block">
								<input type="text" name="email" value="${userMap.email }" lay-verify="email" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">所属角色：</label>
							<div class="layui-input-block" >
								 <c:forEach items="${role }" var="item">
									<input type="checkbox" style="width: 60px" class="roleId" value="${item.roleid }" name="roleId" data-role="${item.identify }"/>
									<span>${item.roleName }</span>
								</c:forEach>
							</div>
						</div>
						<input type="hidden" value="${userMap.roleId }" id="roleHidden" />
						<div class="layui-form-item">
							<label class="layui-form-label">真实姓名：</label>
							<div class="layui-input-block">
								<input type="text" name="realname" value="${userMap.realname }" lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">身份证号：</label>
							<div class="layui-input-block">
								<input type="text" name="identitynumber" value="${userMap.identitynumber }" lay-verify="identity" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">出生日期：</label>
							<div class="layui-input-block">
								<input type="text" class="layui-input addtime" name="birthDate" lay-verify="required" value="${userMap.birthDate }" id="addtime" placeholder="请选择日期范围">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">性别：</label>
							<div class="layui-input-block">
								<input type="radio" class="sex" name="sex" value="0" style="margin-top: 8px;" 
										${userMap.sex==0?"checked='checked'":"" }/> 男
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" class="sex" name="sex" value="1" style="margin-top: 8px;"
										${userMap.sex==1?"checked='checked'":"" }/> 女
							</div>
						</div>
						<c:if test="${_op=='add' }">
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="addRole">新增</button>
								</div>
							</div>
						</c:if>
						<c:if test="${_op=='update' }">
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="updateRole">修改</button>
								</div>
							</div>
						</c:if>
					</form>
				</div>
            
		</div>
	</m:Content>
<m:Content contentPlaceHolderId="js">
	<script>
	$(function(){
			window.onload = function() {
				var checkeds = $("#roleHidden").val();
				if (checkeds.length > 0) {
					var roleArr = checkeds.split(',');
					$.each(roleArr, function(index, roleid) {
						$("input[type=checkbox][name='roleId']").each(
							function() {
								if ($(this).val() == roleid) {
									$(this).attr("checked", true);
									//layui-unselect layui-form-checkbox layui-form-checked
									$(this).siblings().addClass("layui-form-checked");
								}
							}
						);
					});
				}
			};
			
		});
		//JavaScript代码区域
		layui.use(['element', 'layer', 'form', 'laydate'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			//日期范围
			laydate.render({
				elem: '#addtime',
				//range: "~"
			});

			//一些事件监听
			element.on('tab(demo)', function(data) {
				layer.msg('切换了：' + this.innerHTML);

			});

			//自定义验证规则
			form.verify({
				title: function(value) {
					if(value.length < 3) {
						return '标题至少得3个字符';
					}
				},
				pass: [/(.+){6,12}$/, '密码必须6到12位']
			});
			
			//监听提交
			if(${_op=='update' }){
				//修改
				form.on('submit(updateRole)', function(data) {
					layer.load(2, {
						shade: [0.8, '#393D49']
					});
					var success = function(response) {
						var result = response
						if(result.success) {
							layer.alert(result.msg, {
								icon: 1
							}, function() {
								var index = parent.layer.getFrameIndex(window.name);
								 parent.layer.close(index)
								// parent.tableIns.reload({});
							});
						} else {
							layer.alert(result.msg, {
								icon: 2
							}, function() {
								layer.closeAll();
								//parent.tableIns.reload({});
							});
						}

					}
					//获取多选框值
					var val = "";
					$("input:checkbox[name='roleId']:checked").each(function() { // 遍历name=standard的多选框
						val += $(this).val() + ',';
					});
					var data = {
						userId: data.field.userId,
						userName: data.field.userName,
						userPwd: data.field.userPwd,
						telenumber: data.field.telenumber,
						email: data.field.email,
						//roleId: data.field.roleId,
						roleId: val,
						realname: data.field.realname,
						identitynumber: data.field.identitynumber,
						birthDate: data.field.birthDate,
						sex: data.field.sex,
						r:Math.random()
					}
					ajax("/${applicationScope.adminprefix }/system/user/editAdminUser", data, success);
					return false;
				});
			}else if(${_op=='add' }){
				//新增
				form.on('submit(addRole)', function(data) {
					var userType = $("#userType").val();
					layer.load(2, {
						shade: [0.8, '#393D49']
					});
					var success = function(response) {
						var result = response
						if(result.success) {
							layer.alert(result.msg, {
								icon: 1
							}, function() {
								var index = parent.layer.getFrameIndex(window.name);
								 parent.layer.close(index)
								// parent.tableIns.reload({});
							});
						} else {
							layer.alert(result.msg, {
								icon: 2
							}, function() {
								layer.closeAll();
								//parent.tableIns.reload({});
							});
						}

					}
					//获取多选框值
					var val = "";
					$("input:checkbox[name='roleId']:checked").each(function() {
						val += $(this).val() + ',';
					});
					var data = {
							userName: data.field.userName,
							userPwd: data.field.userPwd,
							telenumber: data.field.telenumber,
							email: data.field.email,
							roleId: val,
							realname: data.field.realname,
							identitynumber: data.field.identitynumber,
							birthDate: data.field.birthDate,
							sex: data.field.sex,
							userType: userType,
						r:Math.random()
					}
					ajax("/${applicationScope.adminprefix }/system/user/addAdmin", data, success);
					return false;
				});
			}
			
		});
		
	</script>
</m:Content>
</m:ContentPage>