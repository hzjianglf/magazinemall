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
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			标签管理
		</blockquote>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn layui-btn-normal" id="add_btn">新增</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="carTagList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="checkboxTpl">
  		<input type="checkbox" value="{{d.id}}" title="启用" lay-filter="lockDemo" {{ d.status == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			//绑定文章表格
			var tableIns = table.render({
				id: 'carTag',
				elem: '#carTagList',
				url: '/${applicationScope.adminprefix }/system/carTag/getCarTagList', //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							title: '序号',
							type: 'numbers',
							width: "10%"
						},
						{
							field: 'code',
							title: '标签编号',
							width: "10%"
						}, 
						{
							field: 'name',
							title: '标签名称',
							width: "20%"
						}, 
						{
							field: 'type',
							title: '适用类型',
							width: "20%"
						}, 
						{
							field: 'times',
							title: '使用次数',
							width: "10%"
						}, 
						{
							field: 'status',
							title: '启用状态',
							width: "15%",
							templet: '#checkboxTpl',
							unresize: true
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
			
			//监听锁定操作
			form.on('checkbox(lockDemo)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					modifyStatus(id, 1, layer, tableIns);
				}else{
					modifyStatus(id, 0, layer, tableIns);
				}
			});
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				 
				if(layEvent === 'del'){ //删除
			    	layer.confirm('确定删除当前数据吗？', {icon: 7}, function(index){
			      		obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
			      		layer.close(index);
			      		//向服务端发送删除指令
			      		delCarTag(data.id, layer, tableIns);
			    	});
			  	} else if(layEvent === 'edit'){ //编辑
			  		layer.open({
			  			type: 2,
			  			title: '标签修改',
			  			area: ['30%', '50%'],
			  			content: ['/${applicationScope.adminprefix }/system/carTag/getCarTagInfo?id=' +data.id, 'no'],
			  			end: function(){
			  				tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
			  			}
			  		})
			  	}
			})
			
			$('#add_btn').click(function(){
				layer.open({
		  			type: 2,
		  			title: '标签添加',
		  			area: ['30%', '50%'],
		  			content: ['/${applicationScope.adminprefix }/system/carTag/add', 'no'],
		  			end: function(){
		  				tableIns.reload({
							where: { //设定异步数据接口的额外参数，任意设
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
		  			}
		  		})
			})
			
		});
		
		// 删除
		function delCarTag(id, layer, tableIns){
			$.ajax({
				type : "POST",
				url : "delCarTag",
				async : false,
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
					layer.alert(data.msg,{icon: 1});
				},
				error : function(data) {
					layer.alert(data.msg,{icon: 2});
				}
			});
		}
		
		//禁用/启用标签
		function modifyStatus(id, status, layer, tableIns){
			var text = '确定要禁用此标签吗？';
			if(status ==1 ){
				text = '确定要启用此标签吗？';
			}
			layer.confirm(text, {icon: 7}, function(){
				$.post("modifyStatus",{"id":id,"status":status}, function(data){
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							num:Math.random()
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
					if (data.success) {
						layer.alert(data.msg,{icon: 1});
					} else {
						layer.alert(data.msg,{icon: 2});
					}
				})
			}, function(){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
		}
	</script>
</m:Content>
</m:ContentPage>
