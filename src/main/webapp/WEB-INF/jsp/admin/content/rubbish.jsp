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
			内容回收站
		</blockquote>
		<div class="yw_cx">
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
			<div class="layui-inline" style="float: right">
				<button class="layui-btn layui-btn-normal optionBtn" data-id="revert">还原所选</button>
				<button class="layui-btn layui-btn-danger optionBtn" data-id="delete">彻底删除</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="contentList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
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
				url: '/${applicationScope.adminprefix }/content/rubbishData', //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "10%"
						},
						{
							field: 'title',
							title: '标题',
							width: "20%"
						}, 
						{
							field: 'subTitle',
							title: '副标题',
							width: "15%"
						}, 
						{
							field: 'author',
							title: '作者',
							width: "10%"
						}, 
						{
							field: 'keywords',
							title: '关键字',
							width: "15%"
						}, 
						{
							field: 'userName',
							title: '录入者',
							width: "10%"
						}, 
						{
							field: 'hits',
							title: '点击数',
							width: "10%"
						}, 
						{
							field: 'catName',
							title: '所属栏目',
							width: "10%"
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
			
			$('.optionBtn').click(function(){
				var checkStatus = table.checkStatus('content');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var contentIds = '';
				$.each(checkStatus.data, function(i){
					contentIds = contentIds + checkStatus.data[i].contentId + ',';
				})
				if($(this).attr('data-id') == 'delete'){
					layer.confirm('确定删除当前所选数据吗？', {icon: 7}, function(){
						delContent(contentIds, layer, tableIns);
					})
				}else{
					layer.confirm('确定还原当前所选数据吗？', {icon: 7}, function(){
						restore(contentIds, layer, tableIns);
					})
				}
				
			})
			
		});
		
		function delContent(contentIds, layer, tableIns){
			$.ajax({
				type : "POST",
				url : "delRubbish",
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
		function restore(contentIds, layer, tableIns){
			$.ajax({
				type : "POST",
				url : "restoreRubbishInfo",
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
	</script>
</m:Content>
</m:ContentPage>
