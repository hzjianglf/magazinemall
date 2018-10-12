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
			图书期刊
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">文章标题：</label>
					<div class="layui-input-inline">
						<input type="text" name="Title" id="Title" placeholder="请填写文章标题" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">板块名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="CategoryName" id="CategoryName" placeholder="请填写板块名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">编辑日期：</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input" id="time" name="time" placeholder="yyyy-MM-dd"	>
					</div>
				</div>
				<div class="layui-inline layui-form" id="layerDemo3">
					<input type="checkbox" name="status" title="仅展示启用记录" id="statusChange">
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form book">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="total">
  		<span style="color: blue;">{{d.sales}} |</span> {{d.stock}}
	</script>
	<script type="text/html" id="checkMerge">
		{{ d.isMerge == 1 ? '是' : '否' }}
	</script>
	<script type="text/html" id="checkAdd">
		{{ d.isAdd == 1 ? '是' : '否' }}
	</script>
	<script type="text/html" id="ebookStatus">
		{{ d.status == 1 ? '启用' : '禁用' }}
	</script>
	<script type="text/html" id="checkApprove">
  		<input type="checkbox" value="{{d.id}}" title="上架" lay-filter="approveFilter" {{ d.state == '0' ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="preview">预览</a>
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		{{# if(d.status==0){ }}
			<a class="layui-btn layui-btn-xs" lay-event="enable">启用</a>
		{{# }else{ }}
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="disable">禁用</a>
		{{# } }}
		<a class="layui-btn layui-btn-xs" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		var id='${id}';
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			laydate.render({
				elem: '#time'
			});

			var id='${id}';
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/book/ebookContent?id='+id, //数据接口
				page: false, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "5%"
						},
						{
							field: 'DocID',
							title: '文章ID',
							width: "10%"
						},
						{
							field: 'CategoryName',
							title: '板块',
							width: "10%"
						}, 
					   {
							field: 'ColumnName',
							title: '栏目',
							width: "10%"
						},
						 {
							field: 'Title',
							title: '文章标题',
							width: "10%"
						},
						{
							field: 'OrderNo',
							title: '排序',
								width: "5%"
						},
						{
							field: 'status',
							title: '状态',
							templet: '#ebookStatus',
								width: "10%"
						},
						{
							field: 'time',
							title: '最后编辑日期',
								width: "20%"
						},
						{
							fixed: 'right',
							title: '操作',
							align: 'center',
							toolbar: '#barDemo',
								width: "20%"
						}
					]
				]
			});
			
			//监听锁定操作
			form.on('checkbox(freezeFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unlockOrLock(id, 1);
				}else{
					unlockOrLock(id, 0);
				}
			});
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						Title:$('#Title').val(),
						CategoryName:$('#CategoryName').val(),
						time:$('#time').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			$('#layerDemo3').click(function(){
				var status = $('#statusChange').prop('checked');
				if(status){
					tableIns.reload({
						where:{
							status:'1'
						},
						page:{
							curr: 1 //重新从第 1 页开始
						}
					});
				}else{
					tableIns.reload({
						where:{
							status:''
						},
						page:{
							curr: 1 //重新从第 1 页开始
						}
					});
				}
			});
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				var id = data.DocID;
				
				if(layEvent === 'preview'){ //预览
					layer.open({
						type: 2,
						title: ['预览文章', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', '100%'],
						content: '/${applicationScope.adminprefix }/book/previewDoc?id=' + data.DocID,
						success: function(layero, index) {
							console.log(layero, index);
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
					
			  	} else if(layEvent === 'edit'){ //编辑
			  		layer.open({
						type: 2,
						title: ['编辑文章', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', '100%'],
						content: '/${applicationScope.adminprefix }/book/turneditDoc?id=' + data.DocID,
						success: function(layero, index) {
							console.log(layero, index);
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
			  	}
				//启用
				if(layEvent=="enable"){
					changeBookStatus(id,1);
				}
				//禁用
				if(layEvent=="disable"){
					changeBookStatus(id,0);
				}
				//禁用
				if(layEvent=="del"){
					deleteDoc(id);
				}
			});
			
			//更新用户分成状态
			function changeBookStatus(id,type){
				var t="禁用";
				if(type==1){
					t="启用";
				}
				confirminfo("您确定进行"+t+"操作?",function(){
					var url=getUrl("book/updDocIDByID");
					$.post(url,{
						id:id,
						status:type,
						r:Math.random()
					},function(obj){
						tipinfo(obj.msg);
						if(obj.result){
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									r:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
						}
					},"json")
				})
			}
			//删除
			function deleteDoc(id){
				confirminfo("您确定进行删除操作?",function(){
					var url=getUrl("book/delDocIDByID");
					$.post(url,{
						id:id,
						r:Math.random()
					},function(obj){
						tipinfo(obj.msg);
						if(obj.result){
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									r:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
						}
					},"json")
				})
			}
			
		});
	</script>
</m:Content>
</m:ContentPage>
