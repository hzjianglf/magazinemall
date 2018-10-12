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
			支付管理
		</blockquote>
		<!-- <div class="yw_cx">
			
		</div> -->
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline">
				<button class="layui-btn add"><i class="layui-icon">&#xe654;</i>添加支付方式</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="payment" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="deletes">删除</a>
	</script>
	<script type="text/html" id="Default">
		<input type="checkbox" value="{{d.id}}" title="默认" lay-filter="defaultFilter" {{ d.isDefault == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="freeze">
		<input type="checkbox" value="{{d.id}}" title="启用" lay-filter="freezeFilter" {{ d.isfreeze == 1 ? 'checked' : '' }}/>
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
				id: 'payment',
				elem: '#payment',
				url: '/${applicationScope.adminprefix }/system/paymethod/listData', //数据接口
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							field: 'methodName',
							title: '名称',
							width: "15%"
						}, 
						{
							field: 'accountId',
							title: '账户ID',
							width: "15%"
						}, 
						{
							field: 'encryptionKey',
							title: 'MD5密钥',
							width: "30%"
						}, 
						{
							field: 'payType',
							title: '接口类型',
							width: "10%"
						}, 
						{
							field: 'isDefault',
							title: '是否默认',
							templet: '#Default',
							width: "10%"
						}, 
						{
							field: 'isfreeze',
							title: '是否禁用',
							templet: '#freeze',
							width: "10%"
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
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//监听默认按钮操作
			form.on('checkbox(defaultFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					updateDefault(id, 1, null);
				}else{
					updateDefault(id, 0, null);
				}
			});
			//监听启用禁用操作
			form.on('checkbox(freezeFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					updateDefault(id, null, 1);
				}else{
					updateDefault(id, null, 0);
				}
			});
			//监听操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var id = data.id;
				var userType = data.userType;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edits'){ 
					//编辑
					addPayment(id);
			  	}else if(layEvent === 'deletes'){
			  		//删除
			  		deletes(id);
			  	}
			});
			//添加支付方式
			$(".add").click(function(){
				addPayment(null);
			})
			//更改
			function updateDefault(id,isDefault,isfreeze){
				var text = "";
				if(isDefault == '1'){
					text = "确定要设为默认吗？";
				}else if(isDefault == '0'){
					text = "确定取消默认吗？";
				}else if(isfreeze == '1'){
					text = "确定要设为启用吗？";
				}else if(isfreeze == '0'){
					text = "确定要设为禁用吗？";
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/system/paymethod/updateDefault",
				        data:{"id":id, "isDefault":isDefault,"isfreeze":isfreeze},
				        dataType:"json",
				        success:function(data){
				        	if(data.success){
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
				        	tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
				        },
				        error:function(data){
				        	layer.msg(data.msg,{icon: 2});
				        }
				    });
				}, function(){
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							num:Math.random()
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
				})
			}
			//删除
			function deletes(id){
				layer.confirm("确定要删除吗?", {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/system/paymethod/deletes",
				        data:{"id":id},
				        dataType:"json",
				        success:function(data){
				        	if(data.success){
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
				        	tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
				        },
				        error:function(data){
				        	layer.msg(data.msg,{icon: 2});
				        }
				    });
				}, function(){
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							num:Math.random()
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
				})
			}
			//添加支付方式
			function addPayment(id){
				openwindow("/system/paymethod/addOrUp?id="+id,"添加/编辑支付方式",null,null,true,reload);
			}
			function reload(){
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
