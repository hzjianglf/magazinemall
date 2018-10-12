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
						<input type="hidden" id="zoneID" value="${adZoneInfo.zoneID }" />
						<div class="layui-form-item">
							<label class="layui-form-label">名称：</label>
							<div class="layui-input-block">
								<input type="text" name="zoneName" value="${adZoneInfo.zoneName }" lay-verify="" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">说明：</label>
							<div class="layui-input-block">
								<input type="text" name="zoneIntro" value="${adZoneInfo.zoneIntro }" lay-verify="" autocomplete="off" placeholder="" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">类型：</label>
							<div class="layui-input-block">
								<select name="zoneType">
									<option value="">请选择</option>
									<c:forEach items="${list }" var="item">
										<option value="${item.itemName }" ${adZoneInfo.zoneType==item.itemName?'selected':'' }>${item.itemName }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">尺寸：</label>
							<div class="layui-inline">
								<label class="layui-form-label">宽：</label>
								<div class="layui-input-inline">
									<input type="text" name="zoneWidth" lay-verify="required" value="${adZoneInfo.zoneWidth }" placeholder="" autocomplete="off" class="layui-input">
								</div>
							</div>
							<div class="layui-inline">
								<label class="layui-form-label">高：</label>
								<div class="layui-input-inline">
									<input type="text" name="zoneHeight" lay-verify="required" value="${adZoneInfo.zoneHeight }" placeholder="" autocomplete="off" class="layui-input">
								</div>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">激活：</label>
							<div class="layui-input-block">
								<input type="hidden" name="active" id="active" value="${adZoneInfo.active>0?adZoneInfo.active:0 }">
								<input type="checkbox" id="checkboxId" checked="" name="open" lay-skin="switch" lay-filter="filter" lay-text="ON|OFF">
							</div>
						</div>
						<c:if test="${_op=='add' }">
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="addRole">提交</button>
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
		  //选中按钮
		  $(function(){
			  var val = $("#active").val();
			  if(val==0){//无效
				  $("#checkboxId").attr('checked',false);
			  }else if(val==1){//有效
				  $("#checkboxId").attr('checked',true);
			  }
		  })
		
		//JavaScript代码区域
		layui.use(['element', 'layer', 'form', 'laydate'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			zoneID
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
			
			form.on('switch(filter)', function(data){
				  //赋值到隐藏域
				  var val = data.elem.checked;
				  if(val){//有效
					  $("#active").val(1);
				  }else{//无效
					  $("#active").val(0);
				  }
			});
			
			//修改
			form.on('submit(updateRole)', function(data) {
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
				var zoneID = $("#zoneID").val();
				var active = $("#active").val();
				var data = {
					zoneID: zoneID,
					zoneName: data.field.zoneName,
					zoneIntro: data.field.zoneIntro,
					zoneType: data.field.zoneType,
					zoneWidth: data.field.zoneWidth,
					zoneHeight: data.field.zoneHeight,
					active: active,
					r:Math.random()
				}
				ajax("/${applicationScope.adminprefix }/adZone/updateAdZone", data, success, 'post', 'json');
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
				var active = $("#active").val();
				var data = {
					zoneName: data.field.zoneName,
					zoneIntro: data.field.zoneIntro,
					zoneType: data.field.zoneType,
					zoneWidth: data.field.zoneWidth,
					zoneHeight: data.field.zoneHeight,
					active: active,
					r:Math.random()
				}
				ajax("/${applicationScope.adminprefix }/adZone/addAdZone", data, success, 'post', 'json');
				return false;
			});
			
		});
		
	</script>
</m:Content>
</m:ContentPage>