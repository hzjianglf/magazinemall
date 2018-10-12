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
			版本管理
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
			   <div class="layui-inline">
					<label class="layui-form-label">版本编号：</label>
					<div class="layui-input-inline">
						<input type="text" name="versionNum" id="versionNum" autocomplete="off" class="layui-input" placeholder="请输入版本编号">
					</div>
				</div>
			    <div class="layui-inline">
					<label class="layui-form-label">版本名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="versionName" id="versionName" autocomplete="off" class="layui-input" placeholder="请输入版本名称">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">类型：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="versionType" id="versionType">
							<option value="">全部</option>
							<option value="1">安卓版</option>
							<option value="2">ios版</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="versionStatus" id="versionStatus">
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
	    <div class="layui-inline">
			<div class="layui-input-inline">
				<button class="layui-btn layui-btn-normal releaseNewVersion" ><i class="layui-icon">&#xe61f;</i>发布新版本</button>
			</div>
		</div>
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="version" lay-filter="tableContent"></table>
		</div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="operate">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
		{{# if(d.status=='禁用'){ }}
			<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="startUsing">启用</a>
		{{# }else if(d.status=='启用'){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="enable">禁用</a>
		{{# } }}
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
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
				id: 'version',
				elem: '#version',
				url: '/${applicationScope.adminprefix }/version/versionListData', //数据接口 
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "5%"
						},
						{
							field: 'id',
							title: '编号',
							width: "5%"
						}, 
						{
							field: 'name',
							title: 'APP版本名称',
							width: "15%"
						}, 
						{
							field: 'type',
							title: '类型',
							width: "10%"
						},
						{
							field: 'time',
							title: '发布日期',
							width: "15%"
						}, 
						{
							field: 'status',
							title: '状态',
							templet:'#state',
							width: "10%"
						}, 
						{
							field: 'isForceUpdate',
							title: '是否强制升级',
							templet:'#state',
							width: "10%"
						}, 
						{
							title: '操作',
							width: "15%",
							align: 'center',
							toolbar: '#operate',
								width: "20%"
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			//发布新版本
			$(".releaseNewVersion").click(function(){
				openwindow("version/releaseNewVersion","发布新版本",1000,600,false,callback);
			})
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						versionNum:$("#versionNum").val(),
						versionName: $("#versionName").val(),
						versionType: $('select[name="versionType"]').val(),
						versionStatus: $('select[name="versionStatus"]').val()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var id = data.id;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edit'){
					openwindow("version/releaseNewVersion?id="+id,"编辑",650,500,false,callback);
			  	}else if(layEvent === 'startUsing'){//启用
			  		setIsEnable(id,1,'启用')//status=1
			  	}else if(layEvent === 'enable'){//禁用
			  		setIsEnable(id,0,'禁用')//status=0
			  	}else if(layEvent === 'delete'){
			  		//删除
			  		deletes(id);
			  	}
			});
			//添加活动
			$(".add").click(function(){
				openwindow("buyJisong/turnAdd?number=Math.random()","添加-活动",650,600,true,callback);
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
			
			//设置禁启用
			function setIsEnable(id,status,message){
				layer.confirm('确定'+message+'吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/version/setIsEnable",
						data : {"Id" : id,"versionStatus" : status},
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
						url : "/${applicationScope.adminprefix }/version/deleteVersionRecord",
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
			
		})
		
	</script>

</m:Content>
</m:ContentPage>
