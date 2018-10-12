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
			广告管理
		</blockquote>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn layui-btn-normal" id="add_btn">添加广告</button>
			</div>
			<div class="layui-inline" style="float: right" id="btn_div">
				<button class="layui-btn layui-btn-warm unused">批量停用</button>
				<button class="layui-btn layui-btn-normal used">批量启用</button>
				<button class="layui-btn layui-btn-danger delete">批量删除</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="advList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="checkboxTpl">
  		<input type="checkbox" value="{{d.aDID}}" title="启用" lay-filter="lockDemo" {{ d.passed == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		var zoneID = '${zoneID}';
		layui.use(['laypage', 'layer', 'table', 'form'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			//绑定文章表格
			var tableIns = table.render({
				id: 'content',
				elem: '#advList',
				url: '/${applicationScope.adminprefix }/adver/dataList?zoneID='+zoneID, //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "5%"
						},
						{
							type: 'numbers',
							title: '序号',
							width: "5%",
							sort: true
						},
						{
							field: 'aDName',
							title: '广告名称',
							width: "18%"
						}, 
						{
							field: 'advType',
							title: '类型',
							width: "10%",
							templet: function(obj){
								var type = "";
								switch(obj.advType){
								case 1: type = "图片"; break;
								}
								return type;
							}
						}, 
						{
							field: 'priority',
							title: '权重',
							width: "8%"
						}, 
						{
							field: 'aDIntro',
							title: '广告介绍',
							width: "14%"
						}, 
						{
							field: 'clicks',
							title: '点击数',
							width: "8%"
						}, 
						{
							field: 'passed',
							title: '审核状态',
							width: "8%",
							templet: '#checkboxTpl',
							unresize: true
						}, 
						{
							field: 'updateTime',
							title: '更新时间',
							width: "14%"
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
			
			//监听锁定操作
			form.on('checkbox(lockDemo)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					useOrUnuse(id, layer, tableIns, 1);
				}else{
					useOrUnuse(id, layer, tableIns, 0);
				}
			});
			
			
			$('.search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
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
			  		layer.open({
			  			type: 2,
			  			title: '广告修改',
			  			area: ['100%', '100%'],
			  			content: ['/${applicationScope.adminprefix }/adver/update?aDID=' + data.aDID + '&zoneID=' + zoneID, 'no'],
			  			end: function(){
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
			  	}
			})
			
			// 添加
			$('#add_btn').click(function(){
				layer.open({
		  			type: 2,
		  			title: '广告添加',
		  			area: ['100%', '100%'],
		  			content: ['/${applicationScope.adminprefix }/adver/add?&zoneID=' + zoneID, 'no'],
		  			end: function(){
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
			})
			
			$('#btn_div .layui-btn').click(function(){
				var checkStatus = table.checkStatus('content');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var aIds = '';
				$.each(checkStatus.data, function(i){
					aIds = aIds + checkStatus.data[i].aDID + ',';
				})
				if($(this).hasClass('delete')){
					delContent(aIds, layer, tableIns);
				}
				if($(this).hasClass('unused')){
					useOrUnuse(aIds, layer, tableIns, 0);
				}
				if($(this).hasClass('used')){
					useOrUnuse(aIds, layer, tableIns, 1);
				}
				
			})
			
		});
		
		// 删除
		function delContent(aIds, layer, tableIns){
			layer.confirm('确定删除当前所选数据吗？', {icon: 7}, function(){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/adver/deletes",
					async : false,
					data : {"delitems" : aIds, "zoneID" : zoneID},
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
		
		// 启用/禁用
		function useOrUnuse(aIds, layer, tableIns, status){
			var url = '/${applicationScope.adminprefix }/adver/upadtePassed1';
			var text = '确定停用当前所选数据吗？'
			if(status == 1){
				url = '/${applicationScope.adminprefix }/adver/upadtePassed2';
				text = '确定启用当前所选数据吗？';
			}
			layer.confirm(text, {icon: 7}, function(){
				$.ajax({
			        type:"post",
			        url:url,
			        data:{"delitems":aIds,"zoneID":zoneID},
			        dataType:"json",
			        success:function(data){
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
			        error:function(data){
			        	layer.alert(data.msg,{icon: 2});
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
		
	</script>
</m:Content>
</m:ContentPage>
