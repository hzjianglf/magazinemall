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
					<input type="hidden" name="roleid" id="roleid" value="${roleid }" />
					<input type="hidden" name="isFixation" id="isFixation" value="${isFixation }" />
						<div class="layui-form-item">
							<label class="layui-form-label">角色名称：</label>
							<div class="layui-input-block">
								<input type="text" name="roleName" value="${roleName }" lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">角色类别：</label>
							<div class="layui-input-block" >
								 <select id="identify" name="identify" lay-verify="required" class="form-control">
									<option value="">请选择</option>
									<option value="0" ${identify==0?"selected='selected'":"" }>管理端角色</option>
									<option value="1" ${identify==1?"selected='selected'":"" }>会员端角色</option>
									<option value="2" ${identify==2?"selected='selected'":"" }>讲师端角色</option>
								</select>
							</div>
						</div>
						<!-- <div class="layui-form-item">
							<label class="layui-form-label">是否为固定角色配置：</label>
							<div class="layui-input-block">
								<input type="checkbox" name="zzz" lay-skin="switch" lay-text="是|否">
								
							</div>
						</div> -->
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
	//class="layui-unselect layui-form-switch layui-form-onswitch"  选中
	//layui-unselect layui-form-switch  非选中
// 	$(function(){
// 		var value = $(".layui-unselect").children('em').html();
// 		alert(value);
// 	});
		//JavaScript代码区域
		layui.use(['element', 'layer', 'form', 'laydate'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			//一些事件监听
			element.on('tab(demo)', function(data) {
				layer.msg('切换了：' + this.innerHTML);

			});

			//日期选择
			laydate.render({
				elem: '#date'
			});

			//自定义验证规则
			/* form.verify({
				title: function(value) {
					if(value.length < 5) {
						return '标题至少得5个字符啊';
					}
				},
				pass: [/(.+){6,12}$/, '密码必须6到12位']
			}); */
			//监听提交
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
							 parent.tableIns.reload({});
						});
					} else {
						layer.alert(result.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
							parent.tableIns.reload({});
						});
					}

				}
				var data = {
					roleName: data.field.roleName,
					identify: data.field.identify,
					roleid: data.field.roleid,
					r:Math.random()
				}
				ajax("/${applicationScope.adminprefix }/system/role/roleUpdate", data, success);
				return false;
			});
			//新增
			form.on('submit(addRole)', function(data) {
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
							 parent.tableIns.reload({});
						});
					} else {
						layer.alert(result.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
							parent.tableIns.reload({});
						});
					}

				}
				var data = {
					roleName: data.field.roleName,
					identify: data.field.identify,
					r:Math.random()
				}
				ajax("/${applicationScope.adminprefix }/system/role/roleAdd", data, success);
				return false;
			});
		});
		
	</script>
</m:Content>
</m:ContentPage>