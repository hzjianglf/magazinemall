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
			百科列表
		</blockquote>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div  class="layui-form-item">
				<div class="layui-inline">
					<button class="layui-btn" id="add"><i class="layui-icon">&#xe608;</i>新增百科</button>
				</div>	
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="interlocution" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-xs" lay-event="edit" >编辑</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laydate = layui.laydate;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
			//绑定表格
			var tableIns = table.render({
				id: 'interlocution',
				elem: '#interlocution',
				url: '/${applicationScope.adminprefix }/meetprofessor/listData', //数据接口
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
							width: "10%"
						}, 
						{
							field: 'content',
							title: '提问内容',
							width: "25%"
						}, 
						{
							field: 'realname',
							title: '讲师',
							width: "10%"
						}, 
						{
							field: 'name',
							title: '分类',
							width: "15%"
						}, 
						{
							field: 'money',
							title: '价格',
							width: "10%"
						}, 
						{
							field: 'inputDate',
							title: '回答时间',
							width: "15%"
						}, 
						{
							title: '操作',
							width: "10%",
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			//操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var id = data.id;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edit'){
					//编辑
					openwindow("meetprofessor/toaddOrUp?id="+id,"编辑百科",500,600,false,callback);
			  	}else if(layEvent === 'delete'){
			  		//删除
			  		deletes(id);
			  	}
			});
			//删除
			function deletes(id){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/meetprofessor/deletes",
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
			//新增
			$("#add").click(function(){
				openwindow("meetprofessor/toaddOrUp","新增百科",500,600,false,callback);
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
		})
		
	</script>
</m:Content>
</m:ContentPage>
