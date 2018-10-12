<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			数据字典配置
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="title" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<button class="layui-btn layui-btn-normal search">查询</button>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn layui-btn-normal" data-method="setTop">新增</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="dictionary" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="add">数据字典项管理</a>
		<a class="layui-btn layui-btn-xs" lay-event="edit">修改</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use(['laypage', 'layer', 'table'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			//绑定文章表格
			var tableIns = table.render({
				id: 'content',
				elem: '#dictionary',
				url: '/${applicationScope.adminprefix }/system/dictionary/listData', //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'numbers',
							title: '序号',
							width: "10%"
						}, 
						{
							field: 'dictionaryId',
							title: 'ID',
							width: "10%"
						}, 
						{
							field: 'dictionaryName',
							title: '名称',
							width: "20%"
						}, 
						{
							field: 'dictionaryDescription',
							title: '描述',
							width: "30%"
						}, 
						{
							field: 'dictionaryType',
							title: '类型',
							width: "15%"
						},  
						{
							fixed: 'right',
							title: '操作',
							width: "15%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				]
			});
			
			$('.search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						title: $('input[name="title"]').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			
			$('#layerDemo .layui-btn').on('click', function(){
				layuiIframe(layer, '添加字典项', '/${applicationScope.adminprefix }/system/dictionary/addDictModel', '/${applicationScope.adminprefix }/system/dictionary/addOrUpDictionary', tableIns);
				
			});
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				 
				if(layEvent === 'add'){ //管理字典详情
			    	window.location.href='/${applicationScope.adminprefix }/system/dictionary/showDictInfo?dictId='+data.dictionaryId;
			  	} else if(layEvent === 'edit'){ //编辑
			  		layuiIframe(layer, '修改字典项', '/${applicationScope.adminprefix }/system/dictionary/updateDict?dictId='+data.dictionaryId, '/${applicationScope.adminprefix }/system/dictionary/addOrUpDictionary', tableIns);
			  	}
			})
			
		});
	
		var layuiIframe = function(layer, title, contentUrl, submitUrl, tableIns){
			//多窗口模式，层叠置顶
			layer.open({
				type: 2,
				title: title,
				area: ['500px', '460px'],
				shade: 0.3,
				offset:'auto',
				content: [contentUrl,'no'],
				btn: ['确定', '取消'],
				btnAlign: 'c',
				yes: function(index, layero){
					var form = layer.getChildFrame('form', index);
					var data = form.serialize();
					$.ajax({
						type: "post",
						url: submitUrl,
						data: data,
						dataType: "json",
						success: function(data){
							if(data.success){
								layer.msg(data.msg, {icon: 1});
								tableIns.reload({
									where: { //设定异步数据接口的额外参数，任意设
										num:Math.random()
									},
									page: {
										curr: 1 //重新从第 1 页开始
									}
								});
							}else{
								layer.msg(data.msg, {icon: 2});
							}
						},
						error: function(){
							layer.msg('未知错误', {icon: 2});
						}
					})
					layer.close(index);
				}
			});
		}
	</script>
</m:Content>
</m:ContentPage>
