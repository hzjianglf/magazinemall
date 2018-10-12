<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-form-mid {
			margin-left: 10px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			合辑
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
				<label class="layui-form-label">合辑状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="state" id="state">
							<option value="">选择</option>
							<option value="1">上架</option>
							<option value="2">下架</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">合辑类型：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="classtype" id="classtype">
							<option value="">选择</option>
							<option value="0">点播课程</option>
							<option value="1">直播课程</option>
							<option value="2">期刊</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">合辑名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" id="name" placeholder="请填写合辑名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">创建者：</label>
					<div class="layui-input-inline">
						<input type="text" name="founder" id="founder" placeholder="请填写创建者" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>创建合辑</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="userNameTemp">
		{{ d.userName==null||d.userName==''?d.nickName:d.userName }}
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
         {{# if(d.status==0){ }}
		 	<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="upd">上架</a>
	     {{# }else{}}
			<a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="upd1">下架</a>
		 {{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			laydate.render({
				elem: '#regTime1',
				range: true
			});
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/sumproduct/listData', //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "5%"
						},
						{
							field: 'ondemandId',
							title: '合辑编号',
							width: "6%",
						},
						{
							field: 'name',
							title: '合辑名称',
							width: "12%"
						}, 
						{
							field: 'classtypes',
							title: '类型',
							width: "12%"
						},
						{
							field: 'presentPrice',
							title: '合辑价格',
							width: "13%",
							templet: '#total',
						},
						{
							field: 'studentNum',
							title: '已售',
							width: "7%",
						},
						{
							field: 'sumstatus',
							title: '状态',
							width: "7%",
						},
						{
							title: '创建者',
							width: "8%",
							templet:'#userNameTemp'
						}, 
						{
							field: 'time',
							title: '创建时间',
							width: "18%"
						}, 
						{
							fixed: 'right',
							title: '操作',
							width: "12%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				]
			});
			
			//新增
			$("#add").click(function() {
				
				openwindow("/sumproduct/addSum","创建合辑",1000,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				})
			})
			
			
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						classtype:$('#classtype').val(),
						state:$('#state').val(),
						name:$('#name').val(),
						founder:$('#founder').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'upd'){ //上架
			      	delBuyer(data.ondemandId,1);
			  	} else if(layEvent === 'edit'){
			  		layer.open({
						type: 2,
						title: ['编辑合辑', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', '100%'],
						content: '/${applicationScope.adminprefix }/sumproduct/addSum?id=' + data.ondemandId+"&classtype="+data.classtype+"&classtypes="+data.classtypes,
						success: function(layero, index) {
							console.log(layero, index);
							//layer.iframeAuto(index);
							layer.full(index);
						},
						end: function() { //销毁后触发
							tableIns.reload({
								page: {
									curr: 1
								}
							});
						}
					});
			  	}else if(layEvent === 'upd1'){
			  		delBuyer(data.ondemandId,0);
			  	}
			})
			
			//上下架
			function delBuyer(ids,status){
				var msgs='上架';
				if(status==0){
					msgs='下架';
				}
				layer.confirm('确定'+msgs+'当前商品吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/sumproduct/updStatus",
						data : {"id" : ids,"status":status},
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
		});
		
	</script>
</m:Content>
</m:ContentPage>
