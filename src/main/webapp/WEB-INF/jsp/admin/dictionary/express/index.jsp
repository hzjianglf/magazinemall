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
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			快递公司
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">编号：</label>
					<div class="layui-input-inline">
						<input type="text" name="num" id="num" autocomplete="off" class="layui-input" placeholder="请输入编号">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">快递公司名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" id="name" autocomplete="off" class="layui-input" placeholder="请输入快递公司名称">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">联系人：</label>
					<div class="layui-input-inline">
						<input type="text" name="userName" id="userName" autocomplete="off" class="layui-input" placeholder="请输入联系人名称">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="status" id="status">
							<option value="">全部</option>
							<option value="0">禁用</option>
							<option value="1">启用</option>
						</select>
					</div>
				</div>
				
				<div class="layui-inline">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div  class="layui-form-item">
				<button class="layui-btn add">
					<i class="layui-icon">&#xe61f;</i> 创建快递公司
				</button>	
				<button class="layui-btn layui-btn-danger deletecheck">
					<i class="layui-icon">&#xe640;</i> 批量删除
				</button>
				<button class="layui-btn layui-btn-normal enablecheck">
					<i class="layui-icon">&#xe6af;</i> 批量启用
				</button>
				<button class="layui-btn layui-btn-normal disablecheck">
					<i class="layui-icon">&#xe69c;</i> 批量禁用
				</button>
				<button class="layui-btn layui-btn-normal download">
					<i class="layui-icon">&#xe601;</i> 批量导出
				</button>
			</div>
		</div>
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="express" lay-filter="tableContent"></table>
		</div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
		{{# if(d.status==0){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="enable">启用</a>
		{{# }else if(d.status==1){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="disable">禁用</a>
		{{# } }}
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
	</script>
	<script type="text/html" id="state">
		{{# if(d.status==0){ }}
			禁用
		{{# }else if(d.status==1){ }}
			启用
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			//绑定表格
			var tableIns = table.render({
				id: 'express',
				elem: '#express',
				url: '/${applicationScope.adminprefix }/express/listData', //数据接口 
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "10%"
						},
						{
							field: 'Id',
							title: '编号',
							width: "10%"
						}, 
						{
							field: 'name',
							title: '快递公司名称',
							width: "20%"
						}, 
						{
							field: 'userName',
							title: '联系人',
							width: "10%"
						},
						{
							field: 'telenumber',
							title: '联系电话',
							width: "10%"
						},
						{
							field: 'address',
							title: '地址',
							width: "8%"
						},
						{
							field: 'remark',
							title: '备注',
							width: "10%"
						},
						{
							field: 'status',
							title: '状态',
							templet:'#state',
							width: "5%"
						}, 
						{
							title: '操作',
							width: "15%",
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						name: $('input[name="name"]').val(),
						num:$("#num").val(),
						userName: $("#userName").val(),
						status: $('select[name="status"]').val(),
						number:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var id = data.Id;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edits'){
					openwindow("express/turnAdd?id="+id+"&number=Math.random()","编辑快递公司",650,500,false,callback);
			  	}else if(layEvent === 'enable'){
			  		//启用
			  		updateStatus(id,1);
			  	}else if(layEvent === 'disable'){
			  		//禁用
			  		updateStatus(id,0);
			  	}else if(layEvent === 'delete'){
			  		//删除
			  		deletes(id);
			  	}
			});
			//创建标签
			$(".add").click(function(){
				openwindow("express/turnAdd?number=Math.random()","新增-快递公司",650,600,false,callback);
			})
			function callback(){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			//批量启用
			$(".enablecheck").click(function(){
				var checkStatus = table.checkStatus('express');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].Id + ',';
				})
				layer.confirm('确定将所选全部启用吗？', function(index){
					batchUpStatus(ids,1,layer, tableIns);
				})
				
			})
			//批量禁用
			$(".disablecheck").click(function(){
				var checkStatus = table.checkStatus('express');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].Id + ',';
				})
				layer.confirm('确定将所选全部禁用吗？', function(index){
					batchUpStatus(ids,0,layer, tableIns);
				})
			})
			//批量启用禁用
			function batchUpStatus(ids,status,layer, tableIns){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/express/batchUpStatus",
					async : false,
					data : {"ids" : ids,"status":status},
					success : function(data) {
						tableIns.reload({
							where: {
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
						layer.alert(data.msg,{icon: 1});
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			}
			
			//启用禁用
			function updateStatus(id,status){
				var text = "";
				if(status==1){
					text = "确定要启用吗?";
				}else{
					text = "确定要禁用吗?";
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/express/updateStatus",
						data : {"id" : id,"status":status},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
							if(data.success){
								layer.alert(data.msg,{icon: 1});
							}else{
								layer.alert(data.msg,{icon: 2});
							}
						},
						error : function(data) {
							layer.alert(data.msg,{icon: 2});
						}
					});
				})
			}
			
			//删除
			function deletes(id){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/express/deletes",
						data : {"id" : id},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
							if(data.success){
								layer.alert(data.msg,{icon: 1});
							}else{
								layer.alert(data.msg,{icon: 2});
							}
						},
						error : function(data) {
							layer.alert(data.msg,{icon: 2});
						}
					});
				})
			}
			//批量删除
			$('.deletecheck').click(function(){
				var checkStatus = table.checkStatus('express');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].Id + ',';
				})
				layer.confirm('确定将所选全部删除吗？', function(index){
					deleteid(ids,layer, tableIns);
				})
			});
			function deleteid(ids,layer, tableIns){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/express/deleteids",
					async : false,
					data : {
						"ids" : ids
					},
					success : function(data) {
						tableIns.reload({
							where: {
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
						layer.alert(data.msg,{icon: 1});
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			}
			//批量导出
			$(".download").click(function(){
				//获取复选框
				var checkStatus = table.checkStatus('labels');
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].Id + ',';
				})
				window.location.href="/${applicationScope.adminprefix }/express/download?ids="+ids;
			})
		})
		
		
	</script>

</m:Content>
</m:ContentPage>
