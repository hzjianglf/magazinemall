<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<form class="layui-form" id="form">
		<input type="hidden" name="type" value="${type }" id="type" />
		<input type="hidden" name="publishId" value="${publishId }" id="publishId" />
		
			<c:if test="${type==2 }"><!-- 1代表添加板块2代表添加栏目 -->
				<div class="layui-form-item">
					<label class="layui-form-label"><em style="color: #f00;">*</em> 所属板块：</label>
					<div class="layui-input-block"  style="width: 200px;">
						<select id="category" name="category" lay-verify="required" class="form-control">
							<option value="" >请选择</option>
							<c:forEach var="item" items="${list }">
								<option   value="${item.CategoryID }" ${item.CategoryID==CategoryID? 'selected':'' }>${item.CategoryName }</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</c:if>
			<div class="layui-form-item">
				<c:if test="${type==1 }"><!-- 1代表添加板块2代表添加栏目 -->
					<label class="layui-form-label"><em style="color: #f00;">*</em>板块名称：</label>
				</c:if>
				<c:if test="${type==2 }"><!-- 1代表添加板块2代表添加栏目 -->
					<label class="layui-form-label"><em style="color: #f00;">*</em>栏目名称：</label>
				</c:if>
				<div class="layui-input-block">
					<input type="text"  value="${name }"  name="name" id="name" class="layui-input" lay-verify="required" style="width: 288px;">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label"><em style="color: #f00;">*</em> 排序：</label>
				<div class="layui-input-block">
					<input type="text"  placeholder="" lay-verify="required"  onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9]+/,'');}).call(this)"  value="${OrderNo }" name="OrderNo" id="OrderNo" class="layui-input"  style="width: 85px; display: inline-block;">
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label"><em style="color: #f00;">*</em> 展示：</label>
				<div class="layui-input-block">
					<input type="radio" name="isShow" value="1" title="是" lay-filter="isShow" ${isShow==1?'checked':'' } checked>
					<input type="radio" name="isShow" value="0" title="否" lay-filter="isShow" ${isShow==0?'checked':'' } >
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label"><em style="color: #f00;">*</em>状态：</label>
				<div class="layui-input-block">
					<input type="radio" name="status" value="1" title="启用"  ${status==1?'checked':'' } checked>
					<input type="radio" name="status" value="0" title="禁用"  ${status==0?'checked':'' } >
				</div>
			</div>
			<input type="hidden" name="id" value="${id} " id="id" />
			<div class="layui-form-item" style="text-align: center;">
					<button class="layui-btn" style="width: 50%;margin-top: 30px;" lay-submit="" lay-filter="addEqBtn">保存</button>
			</div>
	</form>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
	layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
		var table = layui.table;
		var laypage = layui.laypage;
		var layer = layui.layer;
		var form = layui.form;
		form.on('submit(addEqBtn)', function(data) {
			var success = function(response){
				if(response.success){
					layer.alert(response.msg, {
						icon: 1
					}, function() {
						var index = parent.layer.getFrameIndex(window.name);
						 parent.layer.close(index);
						 tableIns.reload({
								page: {
									curr: 1
								}
							});
					});
				}else{
					layer.alert(response.msg, {
						icon: 2
					}, function() {
						layer.closeAll();
					});
				}
			}
			ajax('periodical/addCategoryOrColumns',$("#form").serialize(),success, 'post', 'json');
			return false;
		})
	})
	</script>

</m:Content>
</m:ContentPage>
