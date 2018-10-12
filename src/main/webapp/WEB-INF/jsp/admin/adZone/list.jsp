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
	<blockquote class="layui-elem-quote layui-bg-blue">广告位管理</blockquote>
	   <div class="layui-form-item" style=" padding-top:10px; margin-bottom:0;">
	     <div class="layui-inline">
	         <button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>添加广告位</button>
	      </div>
	      <div style=" clear:both"></div>
	    </div>
	  <div class="layui-form">
		  <table class="layui-table" lay-filter="adZoneId" lay-data="{url:'/${applicationScope.adminprefix }/adZone/getAdZoneList', page:true, id:'adZoneList_Id'}">
		    <thead>
		      <tr>
		        <th lay-data="{field:'zoneName', width:'20%', sort: true}">名称</th>
		        <th lay-data="{field:'zoneIntro', width:'17%', sort: true}">说明</th>
		        <th lay-data="{field:'size', width:'17%', sort: true}">大小</th>
		        <th lay-data="{field:'zoneType', width:'17%', sort: true}">类型</th>
		        <th lay-data="{field:'active', width:'17%', sort: true, templet: '#barDemo1'}">状态</th>
		        <th lay-data="{field:'zoneID', width:'12%', sort: true, toolbar: '#barDemo'}">操作</th>
		      </tr> 
		    </thead>
		  </table>
	 </div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/html" id="barDemo1">
		<input type="checkbox" value="{{d.zoneID}}" title="启用" lay-filter="lockDemo"  {{ d.active == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-xs" lay-event="advertise">广告管理</a>
	</script>
	<script type="text/html" id="titleTpl">
		{{# if(Number(d.amount) >= Number(d.warn)){ }} {{d.amount}}{{# } else { }}
		<a style="color: #FF5722;" class="layui-table-link">{{d.amount}}</a> {{# } }}
	</script>
	<script type="text/javascript">
		layui.use(['layer', 'table', 'form'], function(){
			var layer = layui.layer;
			var table = layui.table;
			var form = layui.form;
			table.init('adZoneId');
			
			//新增
			$("#add").click(function() {
				layer.open({
					type: 2,
					title: ['添加广告位', 'font-size:18px;'],
					shadeClose: true,
					area: ['100%', '100%'],
					content: '/${applicationScope.adminprefix }/adZone/addAdZoneInfo',
					success: function(layero, index) {
						
						//layer.iframeAuto(index);
						layer.full(index);
					},
					end: function() { //销毁后触发
						table.reload('adZoneList_Id', {
							height: 315
							,page: {
								curr: 1
							}
						});
					}
				});
			})
			
			//监听锁定操作
			form.on('checkbox(lockDemo)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					var title = obj.elem.title;
					useOrUnuse(id, layer, table, 1);
				}else{
					var title = obj.elem.title;
					useOrUnuse(id, layer, table, 0);
				}
			});
			
			function useOrUnuse(id, layer, table, status){
				var url = '/${applicationScope.adminprefix }/adZone/updateAdZoneStatus';
				var text = '确定停用当前所选数据吗？'
				if(status == 1){
					text = '确定启用当前所选数据吗？';
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:url,
				        data:{"id":id,"status":status},
				        dataType:"json",
				        success:function(data){
				        	table.reload('adZoneList_Id', {
				        		where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								height: 315,
								page: {
									curr: 1
								}
							});
				        	if(data.success){
								layer.alert(data.msg,{icon: 1});
							}else{
								layer.alert(data.msg,{icon: 2});
							}
				        },
				        error:function(data){
				        	layer.alert(data.msg,{icon: 2});
				        }
				    });
				}, function(){
					table.reload('adZoneList_Id', {
						where: { //设定异步数据接口的额外参数，任意设
							num:Math.random()
						}
						,height: 315
						,page: {
							curr: 1
						}
					});
				})
			}
			
			//监听工具条
			table.on('tool(adZoneId)', function(obj) {
				var data = obj.data; //获得当前行数据
				var zoneID = data.zoneID;
				var layEvent = obj.event;
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				if(layEvent === 'edit') {//修改
					layer.open({
						type: 2,
						title: ['广告位编辑', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', "100%"],
						content: '/${applicationScope.adminprefix }/adZone/updateAdZoneInfo?zoneID='+zoneID ,
						success: function(layero, index) {
							//layer.iframeAuto(index);
							layer.full(index);
						},
						end: function() { //销毁后触发
							table.reload('adZoneList_Id', {
								height: 315
								,page: {
									curr: 1
								}
							});
						}
					});
				}else if(layEvent === 'advertise') {//广告管理
					window.location.href = '/${applicationScope.adminprefix }/adver/list?zoneID='+zoneID;
				}
			});
			
			
		});
		
	</script>
</m:Content>
</m:ContentPage>
