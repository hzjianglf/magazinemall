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
			买即送
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
						<div  class="layui-form-item">
							<button class="layui-btn add">
								<i class="layui-icon">&#xe61f;</i> 添加活动
							</button>	
						</div>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="status" id="status">
							<option value="">全部</option>
							<option value="2">已结束</option>
							<option value="1">进行中</option>
							<option value="0">未开始</option>
							<option value="4">已暂停</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">活动名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" id="name" autocomplete="off" class="layui-input" placeholder="请输入活动名称">
					</div>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal reset" style="margin-left: -50px" >重置</button>
					</div> 
				</div>
			</div>
		</div>
	
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="express" lay-filter="tableContent"></table>
		</div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">详细</a>
		{{# if(d.status!=2){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="enable">编辑</a>
			<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
		{{# }else if(d.status==2){ }}
			<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="delete">删除</a>
		{{# } }}
		
	</script>
	<script type="text/html" id="state">
	{{# if(d.isFree==0){ }}
		已暂停
	{{# }else{}}
		{{# if(d.status==0){ }}
			未开始
		{{# }else if(d.status==1){ }}
			进行中
		{{# }else if(d.status==2){ }}
			已结束
		{{# } }}
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
				url: '/${applicationScope.adminprefix }/buyJisong/listData', //数据接口 
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
							field: 'name',
							title: '活动名称',
							width: "15%"
						}, 
						{
							field: 'startTime',
							title: '开始时间',
							width: "15%"
						}, 
						{
							field: 'endTime',
							title: '结束时间',
							width: "15%"
						},
						{
							field: 'remark',
							title: '买即送说明',
							width: "15%"
						}, 
						{
							field: 'status',
							title: '状态',
							templet:'#state',
							width: "10%"
						}, 
						{
							title: '操作',
							width: "15%",
							align: 'center',
							toolbar: '#caozuo',
								width: "20%"
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
				var id = data.id;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edits'){
					openwindow("buyJisong/turnAdd?id="+id+"&number=Math.random()&type=1","查看活动",650,500,true,callback);
			  	}else if(layEvent === 'enable'){
			  		openwindow("buyJisong/turnAdd?id="+id+"&number=Math.random()","查看活动",650,500,true,callback);
			  	}else if(layEvent === 'disable'){
			  		//禁用
			  		updateStatus(id,0);
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
			//重置
			$(".reset").click(function(){
				$("#name").val("");
				$("#status").val("");
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			
			//删除
			function deletes(id){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/buyJisong/deletes",
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
