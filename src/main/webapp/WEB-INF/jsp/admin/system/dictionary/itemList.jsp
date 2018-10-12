<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
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
			数据字典配置	>	${dictionaryName }
		</blockquote>
		<input type="hidden" id="dictId" name="dictId" value="${dictId}" />
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn add_btn"><i class="layui-icon">&#xe61f;</i>新增</button>
				<button class="layui-btn layui-btn-normal back_btn"><i class="layui-icon">&#xe633;</i>返回</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="dictionary" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">修改</a>
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		var dictId = $('#dictId').val();
		layui.use(['laypage', 'layer', 'table'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			//绑定文章表格
			var tableIns = table.render({
				id: 'content',
				elem: '#dictionary',
				url: '/${applicationScope.adminprefix }/system/dictionary/dataInfo', //数据接口
				where: {'dictId': dictId},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'numbers',
							title: '序号',
							width: "20%"
						}, 
						{
							field: 'itemName',
							title: '名称',
							width: "20%"
						}, 
						{
							field: 'itemValue',
							title: '值',
							width: "20%"
						}, 
						{
							field: 'orderIndex',
							title: '排序号',
							width: "20%"
						},  
						{
							fixed: 'right',
							title: '操作',
							width: "20%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				]
			});
			
			
			$('#layerDemo .add_btn').on('click', function(){
				layuiIframe(layer, '添加字典详情', '/${applicationScope.adminprefix }/system/dictionary/addOrUpItemModel?itemId=0&dictId='+dictId, '/${applicationScope.adminprefix }/system/dictionary/addOrUpItem', tableIns);
			});
			
			$('#layerDemo .back_btn').click(function(){
				window.location.href = "/${applicationScope.adminprefix }/system/dictionary/list";
			})
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				 
				if(layEvent === 'del'){ //删除
					layer.confirm('确定删除当前数据吗？', function(index){
			      		obj.del(); //删除对应行（tr）的DOM结构，并更新缓存
			      		layer.close(index);
			      		//向服务端发送删除指令
			      		delItem(data.itemId, layer, tableIns);
			    	});
			  	} else if(layEvent === 'edit'){ //编辑
			  		layuiIframe(layer, '修改字典详情', '/${applicationScope.adminprefix }/system/dictionary/addOrUpItemModel?itemId='+data.itemId+'&dictId='+dictId, '/${applicationScope.adminprefix }/system/dictionary/addOrUpItem', tableIns);
			  	}
			})
			
		});
	
		var layuiIframe = function(layer, title, contentUrl, submitUrl, tableIns){
			//多窗口模式，层叠置顶
			layer.open({
				type: 2,
				title: title,
				area: ['500px', '460px'],
				shade: 0.3,
				offset:'auto',
				content: [contentUrl,'no'],
				btn: ['确定', '取消'],
				btnAlign: 'c',
				yes: function(index, layero){
					var form = layer.getChildFrame('form', index);
					var data = form.serialize();
					$.ajax({
						type: "post",
						url: submitUrl,
						data: data,
						dataType: "json",
						success: function(data){
							if(data.success){
								layer.msg(data.msg, {icon: 1});
								tableIns.reload({
									where: { //设定异步数据接口的额外参数，任意设
										dictId: dictId,
										num:Math.random()
									},
									page: {
										curr: 1 //重新从第 1 页开始
									}
								});
							}else{
								layer.msg(data.msg, {icon: 2});
							}
						},
						error: function(){
							layer.msg('未知错误', {icon: 2});
						}
					})
					layer.close(index);
				}
			});
		}
		
		//删除
		function delItem(itemId, layer, tableIns){
			$.post("/${applicationScope.adminprefix }/system/dictionary/delDictInfo",{"itemId":itemId,"dictId":dictId},
			function(data){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						dictId: dictId,
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
			});
		}
	</script>
</m:Content>
</m:ContentPage>






<%-- 
		<div id="wrapper" class="container">
			<div id="list" class="wrapper wrapper-content animated fadeInRight">
				<h3 style="float:left;display:inline-block;">数据字典配置</h3>
				<button type="button" onclick="fh();" style="float: right;margin-top:-8px;margin-left:10px" class="btn btn-success">
					<i class="fa fa-step-backward"></i>返回
				</button>
				<px:authorize setting="字典-添加字典详细">
					<button type="button" onclick="addOrUpItem('0');"
						class="btn btn-warning" style="float: right;margin-top:-8px;">
						<i class="fa fa-plus" style="margin-left: 5px;margin-top:-8px"></i>新增
					</button>
				</px:authorize>
				<div class="right_box" style="margin-top:36px;">
					<input type="hidden" style="width: 180px" id="dictId" name="dictId" value="${dictId}" />
					<!--表格部分-->
					<div class="ibox-content" style="margin-top: 20px;">
						<div class="row">
							<div class="col-sm-12">
								<table
									class="table table-striped table-bordered table-hover dataTables-example dataTables">
									<thead>
										<tr>
											<th width="11%">序号</th>
											<th width="12%">名称</th>
											<th width="11%">值</th>
											<th width="12%">排序号</th>
											<th width="11%">常规操作</th>
										</tr>
									</thead>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		//$.fn.dataTable.ext.errMode = 'none'; //不显示任何错误信息
		$(function(){
			datatable = $(".dataTables").DataTable({
	            "processing": true,
	            "serverSide": true,
	            "filter": false,
	            "dom": '<"toolbar">frtip',
	            "ordering":false,
	            "iDisplayLength":10000,
	            "language": {
	                "sProcessing": "处理中...",
	                "sLengthMenu": "显示 _MENU_ 项结果",
	                "sZeroRecords": "没有匹配结果",
	                "sInfo": "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
	                "sInfoEmpty": "显示第 0 至 0 项结果，共 0 项",
	                "sInfoFiltered": "(由 _MAX_ 项结果过滤)",
	                "sInfoPostFix": "",
	                "sSearch": "搜索:",
	                "sUrl": "",
	                "sEmptyTable": "表中数据为空",
	                "sLoadingRecords": "载入中...",
	                "sInfoThousands": ",",
	                "oPaginate": {
	                    "sFirst": "首页",
	                    "sPrevious": "上页",
	                    "sNext": "下页",
	                    "sLast": "末页"
	                },
	                "oAria": {
	                    "sSortAscending": ": 以升序排列此列",
	                    "sSortDescending": ": 以降序排列此列"
	                }
	            },
	            "rowCallback":function(row, data, index){
	            	$('td:eq(0)', row).attr("data-id",data.roleid);
	            },
	            "columnDefs": [
	            	{
	                    "targets": 0,
	                    "data": null,
	                    "render": function (data, type, row,meta) {
	                    	var page= datatable.page();
	                    	
	                        return page*5 + meta.row+1;
	                    }
	                },
	                {
	                    "targets": 4,
	                    "data": null,
	                    "render": function (data, type, row) {
	                    	var html = '';
	                    	//
	                    	html += '<a onclick="addOrUpItem('+row.itemId+')">修改</a>&nbsp;&nbsp;&nbsp;';
	                    	html += '<a onclick="delItem('+row.itemId+')">删除</a>';
	                        return html;
	                    }
	                }
	            ],
	            "columns": [
	                { "data": null, "orderable": false },
	                { "data": "itemName",defaultContent:"" },
	                { "data": "itemValue",defaultContent:"" },
	                { "data": "orderIndex",defaultContent:"" },
	            ],
	            
	            "ajax": {
	                "url": "/${applicationScope.adminprefix }/system/dictionary/showDictInfo/dataTable",
	                "method": "post",
	                "data": function (obj) {
	                	obj.dictId=$("#dictId").val();
	                }
	            }
	            
	        });
			
		});
		
		//返回
		function fh() {
			window.location.href = "/${applicationScope.adminprefix }/system/dictionary/list";
		}
		
		//添加或者修改
		function addOrUpItem(itemId){
			var dictId = $("#dictId").val();
			var a = 0;//为了限制多次提交
			var info = '';//弹窗标题
			if(itemId==0){
				info = '添加字典详细';
			}else{
				info = '修改字典详细';
			}
			$.dialog({
				title: info,
				width: 600,
				height: 380,
				lock : true,
				content: 'url:/${applicationScope.adminprefix }/system/dictionary/addOrUpItemModel?itemId='+itemId+'&dictId='+dictId,
				init: function() {
					var iframe = this.iframe.contentWindow;
				},
				button: [{
					name: '保存',
					callback: function() {
						//iframe
					 	var iframe = this.iframe.contentWindow;
						//获取子页面的form表单
						var saveClient = $(iframe.document.body).find('#saveClient');
						 //为了限制多次提交
						if(a==0){
							//获取点击事件
							var btn = iframe.document.getElementById('checkBtn').click();
						}
						 if (btn == true) {
							
						} else {
							  if(iframe.document.getElementById('checkTF').value==1){
								 //为了限制多次提交
								 a = 1;
								 iframe.document.getElementById('checkTF').value = 0;
								 //ajax提交(文件请求需要换)
								 $.ajax({
							        type:"post",
							        data:saveClient.serialize(),
							        dataType:"json",
							        url:"/${applicationScope.adminprefix }/system/dictionary/addOrUpItem",
							        success:function(data){
							        	if(data.success){
							        		parent.alertNew(data.msg,true);
						        			datatable.draw();
						        			iframe.document.getElementById('closeModelBtn').click();
							        	}else{
							        		parent.alertNew(data.msg,false);
						        			datatable.draw();
						        			iframe.document.getElementById('closeModelBtn').click();
							        	}
							        	
							        },
							        error:function(data){
							        	parent.alertNew(data.msg,false)
						        		datatable.draw();
						        		iframe.document.getElementById('closeModelBtn').click();
							        }
							    });
							}  
							return false;
						} 
					},
					focus: true

				}, {
					name: '取消',
					callback: function() {

					}
				}]
			});
		}
		//删除
		function delItem(itemId){
			var dictId = $("#dictId").val();
			$.dialog.confirm("确定要删除吗？", function(){
				$.post("/${applicationScope.adminprefix }/system/dictionary/delDictInfo",{"itemId":itemId,"dictId":dictId},
				function(data){
					if(data.success){
						alertNew(data.msg,true);
					}else{
						alertNew(data.msg,false);
					}
					datatable.draw();
				});
						    
			});
		}
		</script> --%>
