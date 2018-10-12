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
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			内容管理${catName==null?"":catName }
		</blockquote>
		<div class="yw_cx">
			<input type="hidden" name="catId" value="${catId }" id="catId"/>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">标题：</label>
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
				<button class="layui-btn layui-btn-normal" onclick="addNews(${catId})">新增</button>
			</div>
			<div class="layui-inline" style="float: right">
				<button class="layui-btn layui-btn-danger" id="delete">批量删除</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="contentList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		var catId = '${catId}';
		layui.use(['laypage', 'layer', 'table'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			//绑定文章表格
			var tableIns = table.render({
				id: 'content',
				elem: '#contentList',
				url: '/${applicationScope.adminprefix }/content/selContentByCatId?catId='+catId, //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "5%"
						},
						{
							field: 'contentId',
							title: 'ID',
							width: "5%",
							sort: true
						},
						{
							field: 'title',
							title: '标题',
							width: "18%"
						}, 
						{
							field: 'subTitle',
							title: '副标题',
							width: "14%"
						}, 
						{
							field: 'author',
							title: '作者',
							width: "8%"
						}, 
						{
							field: 'keywords',
							title: '关键字',
							width: "14%"
						}, 
						{
							field: 'userName',
							title: '录入者',
							width: "8%"
						}, 
						{
							field: 'hits',
							title: '点击数',
							width: "8%"
						}, 
						{
							field: 'catName',
							title: '所属栏目',
							width: "10%"
						}, 
						{
							fixed: 'right',
							title: '操作',
							width: "10%",
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
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				 
				if(layEvent === 'del'){ //删除
			    	layer.confirm('确定删除当前数据吗？', {icon: 7}, function(index){
			      		obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
			      		layer.close(index);
			      		//向服务端发送删除指令
			      		delContent(data.contentId, layer, tableIns);
			    	});
			  	} else if(layEvent === 'edit'){ //编辑
			  		window.location.href = "/${applicationScope.adminprefix }/content/showContent?type=edit&contentId=" + data.contentId + "&catId=" + catId;
			  	}
			})
			
			$('#delete').click(function(){
				var checkStatus = table.checkStatus('content');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var contentIds = '';
				$.each(checkStatus.data, function(i){
					contentIds = contentIds + checkStatus.data[i].contentId + ',';
				})
				layer.confirm('确定删除当前所选数据吗？', {icon: 7}, function(index){
					delContent(contentIds, layer, tableIns);
				})
				
			})
			
		});
		
		function delContent(contentIds, layer, tableIns){
			$.ajax({
				type : "POST",
				url : "delContentInfo",
				async : false,
				data : {
					"contentId" : contentIds
				},
				success : function(data) {
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							title: $('input[name="title"]').val(),
							num:Math.random()
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
					layer.alert(data.message,{icon: 1});
				},
				error : function(data) {
					layer.alert(data.message,{icon: 2});
				}
			});
		}
		
		//跳转到添加新闻页面
		function addNews(catId) {
			window.location.href = "/${applicationScope.adminprefix }/content/showContent?type=add&catId=" + catId;
		}
	</script>
</m:Content>
</m:ContentPage>
