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
			限时折扣
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="type" id="status">
							<option value="-1">全部</option>
							<option value="0">未开始</option>
							<option value="1">进行中</option>
							<option value="2">已结束</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">活动名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" id="name" autocomplete="off" class="layui-input" placeholder="评论内容">
					</div>
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal reset" style="background-color: #FF6633"><i class="layui-icon">&#xe620;</i>重置</button>
					</div> 
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div  class="layui-form-item">
				<div class="layui-inline">
					<button id="add" class="layui-btn" ><i class="layui-icon">&#xe654;</i>添加活动</button>
				</div>	
			</div>
		</div>
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="sharesales" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs" lay-event="details">详细</a>
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="deletes">删除</a>
	</script>
	<script type="text/html" id="state">
		<!-- 0 活动有误 1活动未开启 2活动进行中  2.1已启动 2.2已暂停 3活动结束 -->
		{{# if(d.state == 0){ }}
			<a href="javascript:void(0)" style="color:red">活动有误</a>
		{{# }else if(d.state == 1){ }}
			<a href="javascript:void(0)" style="color:#888">未开始</a>
		{{# }else if(d.state == 2){ }}
			{{# if(d.status == 1){ }}
				<a href="javascript:void(0)" style="color:green">已启动</a>
			{{# }else if (d.status == 0) { }}
				<a href="javascript:void(0)" style="color:orange">已暂停</a>
			{{# } }}
		{{# }else if(d.state == 3){ }}
			<a href="javascript:void(0)" style="color:#888">已结束</a>
		{{# }else{ }}
			-
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
		  	laydate.render({
		   		elem: '#dateTime',
		   		range:true
		  	});
			//绑定表格
			var tableIns = table.render({
				id: 'sharesales',
				elem: '#sharesales',
				url: '/${applicationScope.adminprefix }/discount/listData', //数据接口
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
						},
						{
							field: 'id',
							title: '活动编号',
						},
						{
							field: 'name',
							title: '活动名称',
						}, 
						{
							field: 'startTime',
							title: '开始时间',
						}, 
						{
							field: 'endTime',
							title: '结束时间',
						},
						/* {
							field: 'lowerlimit',
							title: '购买下限',
							width: "10%"
						},
						{
							field: 'uppperlimit',
							title: '购买上限',
							width: "10%"
						}, */
						{
							title: '状态',
							templet:'#state',
						}, 
						{
							title: '操作',
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
						status: $('#status').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//重置
			$('.reset').click(function() { 
				$("#name").val('');
				$("#type").val('-1');
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
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
				if(layEvent === 'details'){
			  		//详细
					openwindow("discount/toaddOrUp?id="+id+"&detail=1","详细",600,700,true,callback);
			  	}else if(layEvent === 'edits'){
			  		//编辑
			  		openwindow("discount/toaddOrUp?id="+id,"新增/编辑活动",600,700,true,callback);
			  	}else if(layEvent === 'deletes'){
			  		//删除
			  		deletes(id);
			  	}
			});
			//添加营销活动
			$("#add").click(function(){
				openwindow("/discount/toaddOrUp","添加活动",600,700,true,callback);
			})
			
			//删除
			function deletes(id){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/discount/delDiscount",
						data : {"id" : id},
						success : function(data) {
							callback();
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
		})
		
		
	</script>

</m:Content>
</m:ContentPage>
