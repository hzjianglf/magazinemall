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
	<input type="hidden" name="periodId" value=${id }>
		<div class="layui-form-item">
			<div class="layui-form-item">
				<div class="layui-inline">
				    <div class="layui-input-inline">
						<input type="checkbox" name="isFree" id="isFree" autocomplete="off" > 仅展示启用目录
					</div>
				</div>
				<div class="layui-inline" style="float: right" id="btn_div">
					<button class="layui-btn layui-btn-normal addCategory">添加板块</button>
					<button class="layui-btn layui-btn-normal addColumns">添加栏目</button>
				</div>
			</div>
		</div>
			<table class="layui-table" lay-skin="line" id="product" lay-filter="tableContent"></table>
		<div id="demo7"></div>
		<div class="layui-inline" style="margin-left: 40%;">
			<div class="layui-input-inline">
				<button class="layui-btn layui-btn-normal" style="width:100px;" id="Determine">确定</button>
			</div>
		</div>
	</div>
<!-- 	<table border="5">
		<tr>
			<td rowspan="3">dfgdgdfgdfgAAA</td>
			<td>dsfds1</td>
			<td>dsfdsf1</td>
		</tr>
		<tr>
			<td>dsfds2</td>
			<td>dsfdsf2</td>
		</tr>
		<tr>
			<td>dsfds3</td>
			<td>dsfdsf3</td>
		</tr>
	</table> -->
	<script type="text/html" id="type">
		{{ d.type == 1 ? '板块' : '栏目' }}
	</script>
	<script type="text/html" id="statustool">
		{{# if(d.status==1){ }}
		 	启用
	    {{# }else{}}
			禁用
		{{# } }}
	</script>
	<script type="text/html" id="isShowtool">
		{{# if(d.isShow==1){ }}
		 	是
	    {{# }else{}}
			否
		{{# } }}
	</script>
	<script type="text/html" id="barDemo">
		
		<a class="layui-btn layui-btn-xs " lay-event="edit">编辑</a>
		{{# if(d.status==0){ }}
		 	<a class="layui-btn layui-btn-xs open" lay-event="status">启用</a>
	    {{# }else{}}
			<a class="layui-btn layui-btn-xs close" lay-event="status">禁用</a>
		{{# } }}
		
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		var periodId = '${id}';
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			//绑定表格
			var tableIns = table.render({
				id: 'product',
				elem: '#product',
				url: '/${applicationScope.adminprefix }/periodical/selectColumns?id='+periodId, //数据接口
				height:400,
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						/* {
							type: 'checkbox',
							width: "10%"
						}, */
						{
							field: 'type',
							title: '类型',
							templet: '#type',
							width: "10%"
						},
						{
							field: 'CategoryName',
							title: '名称',
							width: "15%"
						},
						{
							field: 'parent',
							title: '所属父级',
							width: "15%"
						},
						{
							title: '排序',
							field: 'OrderNo',
							width: "10%"
						},
						{
							field: 'isShow',
							toolbar: '#isShowtool',
							title: '展示',
							width: "10%"
						},
						{
							field: 'status',
							title: '状态',
							toolbar: '#statustool',
							width: "10%"
						},
						{
							title: '操作',
							width: "30%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				],
				done: function(res, curr, count){

				}
			});
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'del'){ //删除
					delColumns(data.id,data.type);
			  	}else if(layEvent === 'status'){//启用禁用
			  		if($(this).hasClass('open')){
			  			updStatus(data.id,data.type,1);
			  		}else{
			  			updStatus(data.id,data.type,0);
			  		}
			  	}else if(layEvent === 'edit'){ //编辑
		  			updCategoryOrColumns(data.IssueID,data.id,data.type);
			  	} else if(layEvent === 'reset'){
			  		resetPwd(data.id);
			  	}
			})
			
			//重置表格
			$('#isFree').click(function() {
				var isChecked = $("#isFree").is(":checked");
				var isFree = 0;
				if(isChecked){
					isFree=1;
				}
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						isFree: isFree,
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			$("#Determine").click(function(){
				
				
				//关闭
				var index = parent.layer.getFrameIndex(window.name);
				parent.layer.close(index);
			})
			
			
			$('#btn_div .layui-btn').click(function(){
				if($(this).hasClass('addCategory')){
					add(1);//添加板块
				}
				if($(this).hasClass('addColumns')){
					add(2);//添加栏目
				}
			})
			
		function updStatus(id,type,status){
			var success = function(response){
				if(response.success){
					layer.alert(response.msg, {
						icon: 1
					}, function() {
						layer.closeAll();
						 tableIns.reload({
								page: {
									curr: 1
								}
							});
					});
				}else{
					layer.alert(response.msg, {
						icon: 2
					}, function() {
						layer.closeAll();
					});
				}
			}
			ajax('/periodical/updStatus',data={id:id,type:type,status:status},success, 'post', 'json');
			return false;
		}
			function add(type){
				var title='添加板块';
				if(type==2){
					title='添加栏目';
				}
				openwindow("/periodical/turnAddCategoryOrColumns?publishId="+${id}+"&type=" + type 
					,title,600,400,false,function(){
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
			
			function updCategoryOrColumns(IssueID,id,type){
				var title='编辑板块';
				if(type==2){
					title='编辑栏目';
				}
				openwindow("/periodical/turnAddCategoryOrColumns?publishId="+IssueID+"&id="+id+"&type=" + type 
						,title,600,400,false,function(){
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
			function delColumns(id,type){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {
							icon: 1
						}, function() {
							layer.closeAll();
							 tableIns.reload({
									page: {
										curr: 1
									}
								});
						});
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
						});
					}
				}
				ajax('/periodical/delCategoryOrColumns',data={id:id,type:type},success, 'post', 'json');
				return false;
			}
		})
	</script>

</m:Content>
</m:ContentPage>
