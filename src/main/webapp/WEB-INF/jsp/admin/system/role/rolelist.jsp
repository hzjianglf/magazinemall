<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<style>
	body {
		background: #f1f0f7;
	}
	.yw_cx {
		background: #fff;
		border-radius: 3px;
		padding: 30px 10px;
	}
	.layui-form-item .layui-input-inline{ width:162px; margin-right:0}
	.layui-form-label{ width:inherit}
	.layui-table th{ font-weight:700; background:#01AAED; color:#fff; text-align:center;}
	.layui-table td{ text-align:center;}
	.layui-laypage span{ background:none}
	.layui-laypage .layui-laypage-spr { background:#fff}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit"/>
		<blockquote class="layui-elem-quote layui-bg-blue">
			角色管理
		</blockquote>
	 <!--  <form class="layui-form" action=""> -->
	   <div class="layui-form-item" style=" padding-top:10px; margin-bottom:0;">
	     <div class="layui-inline">
	         <button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>新增角色</button>
	      </div>
	      <div style=" clear:both"></div>
	    </div>
	 <!--  </form> -->
	  <div class="layui-form">
		  <table class="layui-table" lay-filter="equipment" lay-data="{height:315, url:'/${applicationScope.adminprefix }/system/role/list/dataTable', page:true, id:'roleList_Id'}">
		    <thead>
		      <tr>
		        <th lay-data="{field:'roleName', width:350, sort: true}">角色名称</th>
		        <th lay-data="{field:'identify', width:350, sort: true}">角色分类</th>
		        <th lay-data="{field:'roleid', width:900, sort: true, toolbar: '#barDemo'}">操作</th>
		      </tr> 
		    </thead>
		  </table>
	  </div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="authorityEdit">权限设置</a>
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		{{# if(d.isFixation!=0){ }}
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a> 
		{{# } }} 
	</script>

	<script type="text/javascript">
		layui.use(['layer', 'table'], function(){
			//加载表格			
			var layer = layui.layer;
			var table = layui.table;
			table.init('equipment', {
				height: 315, //设置高度
				limit: 10 //注意：请务必确保 limit 参数（默认：10）是与你服务端限定的数据条数一致
			});
			
			//监听工具条
			table.on('tool(equipment)', function(obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var roleId = data.roleid;//角色ID
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				if(layEvent === 'edit') {
					layer.open({
						type: 2,
						title: ['编辑角色', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', "100%"],
						content: '/${applicationScope.adminprefix }/system/role/roleInfo?_op=update&roleId=' + roleId,
						success: function(layero, index) {
							console.log(layero, index);
							//layer.iframeAuto(index);
							layer.full(index);
						},
						end: function() { //销毁后触发
							//此方式为方法渲染重载表格
							//tableIns.reload({});  
							//此方式为自动渲染重载表格
							table.reload('roleList_Id', {
								height: 315
								,page: {
									curr: 1
								}
							});
						}
					});
				}else if(layEvent === 'authorityEdit') {
					layer.open({
						type: 2,
						title: [data.roleName+'-权限', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', "100%"],
						content: '/${applicationScope.adminprefix }/system/role/roleInfo?_op=limits&roleId='+roleId,
						success: function(layero, index) {
							console.log(layero, index);
							//layer.iframeAuto(index);
							layer.full(index);
						},
						end: function() { //销毁后触发
							//tableIns.reload({});
						}
					});
				}else if(layEvent === 'del') {
					layer.confirm('是否要删除?', function(index) {
						var success = function(response) {
							console.log('删除：' + JSON.stringify(response));
							var result = JSON.parse(response);
							if(result.success) {
								layer.msg(result.msg);
								table.reload('roleList_Id', {
									height: 315
									,page: {
										curr: 1
									}
								});
							} else {
								layer.alert(result.msg, {
									icon: 2
								});
							}
						}
						var AjaxData = {
							roleId: roleId,
							r: Math.random()
						}
						ajax("/${applicationScope.adminprefix }/system/role/roleDelete", AjaxData, success);
					}, function(index) {
						//layer.msg('确认1');
					});
				}
			});
			//新增分组
			$("#add").click(function() { 
				layer.open({
					type: 2,

					title: ['新增角色', 'font-size:18px;'],
					shadeClose: true,
					area: ['100%', '100%'],
					content: '/${applicationScope.adminprefix }/system/role/roleInfo?_op=add',
					success: function(layero, index) {
						console.log(layero, index);
						//layer.iframeAuto(index);
						layer.full(index);
					},
					end: function() { //销毁后触发
						table.reload('roleList_Id', {
							height: 315
							,page: {
								curr: 1
							}
						});
					}
				});
			})

			
		})
	</script>
</m:Content>
</m:ContentPage>
