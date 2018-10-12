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
		.sh_win {
			background: #fff;
			display: none;
		}
		.sh_win ul {
			margin: 20px 0 0 20px;
		}
		.sh_win ul li {
			margin-bottom: 20px;
		}
		.sh_win ul li span {
			width: 80px;
			display: inline-block;
			text-align: right;
			vertical-align: top;
			font-size: 16px;
			color: #333;
			line-height: 30px;
			margin-right: 20px;
		}
		.sh_win ul li textarea {
			width: 330px;
			height: 150px;
			resize: none;
			padding: 10px;
			font-size: 14px;
			color: #333;
			line-height: 20px;
		}
		.sh_win ul li input {
			height: 30px;
			line-height: 30px;
			width: 340px;
			padding-left: 10px;
			font-size: 14px;
			color: #333;
		}
		.btns {
			text-align: center;
		}
		.btns a {
			width: 100px;
			height: 35px;
			line-height: 35px;
			display: inline-block;
			text-decoration: none;
			margin: 0 20px;
		}
		.btns a.ok {
			background: #55b2ff;
			color: #fff;
		}
		.btns a.cancle {
			background: #e5e5e5;
			color: #999;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			评论管理
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">评论状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="status">
							<option value="">全部</option>
							<option value="0">未审核</option>
							<option value="1">审核通过</option>
							<option value="2">审核驳回</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">评论内容：</label>
					<div class="layui-input-inline">
						<input type="text" name="content" autocomplete="off" class="layui-input" placeholder="评论内容">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">买家：</label>
					<div class="layui-input-inline">
						<input type="text" name="poster" autocomplete="off" class="layui-input" placeholder="买家">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">评论时间：</label>
					<div class="layui-input-inline" style="width: 234px;">
						<input type="text" name="dateTime" id="dateTime" readonly="readonly" class="layui-input">
					</div>
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div  class="layui-form-item">
				<div class="layui-inline">
					<button id="deleteId" class="layui-btn layui-btn-danger" ><i class="layui-icon">&#xe640;</i>批量删除</button>
				</div>	
			</div>
		</div>
		<!-- 选项卡 -->
		<div class="layui-tab layui-tab-brief">
		  <ul class="layui-tab-title" id="tab_list">
		    <li data-state="0" class="layui-this">未审核</li>
		    <li data-state="1">审核通过</li>
		    <li data-state="2">审核驳回</li>
		  </ul>
		</div> 
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="comment" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 审核弹窗 -->
	<div class="shade"></div>
	<div class="sh_win" id="div_SH">
		<ul>
			<li><span>审核意见：</span></li>
			<li><textarea name="remark" id="remark" style="margin-left: 50px;"></textarea></li>
		</ul>
		<input type="hidden" name="commentId" id="commentId" />
		<div class="btns">
			<a href="#" class="ok">审核通过</a>
			<a href="#" class="cancle">审核驳回</a>
		</div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		{{# if(d.status == 0){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="shenhe">审核</a>
		{{# }else{ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="cancel">取消审核</a>
		{{# } }}
		{{# if(d.status != 0){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="deletes">删除</a>
		{{# } }}
	</script>
	<script type="text/html" id="state">
		{{# if(d.status==0){ }}
				未审核
		{{# }else if(d.status==1){ }}
				审核通过
		{{# }else if(d.status==2){ }}
				审核驳回
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		var div_index;
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
				id: 'comment',
				elem: '#comment',
				url: '/${applicationScope.adminprefix }/comment/listData', //数据接口
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
							title: '评论内容',
							width: "20%"
						}, 
						{
							field: 'poster',
							title: '买家',
							width: "10%"
						},
						{
							field: 'commentType',
							title: '类型',
							width: "10%"
						},
						{
							field: 'status',
							title: '状态',
							templet:'#state',
							width: "10%"
						}, 
						{
							field: 'dateTime',
							title: '评论时间',
							width: "20%"
						}, 
						{
							title: '操作',
							width: "15%",
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			

			$("#tab_list > li[data-state]").on("click",function(){
				$("#tab_list > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				//获取状态值
				var status = $("#tab_list > li.layui-this").data("state");
				//重新加载表格
				tableIns.reload({
					where: {
						status:status,
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						content: $('input[name="content"]').val(),
						poster: $('input[name="poster"]').val(),
						status: $('select[name="status"]').val(),
						dateTime: $('input[name="dateTime"]').val(),
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
				if(layEvent === 'shenhe'){
			  		//审核
					//$('.sh_win').show();
					//$('.shade').show();
					$("#remark").val("");
					div_index=layer.open({
						type:1,
						area:['450px','400px'],
						title:"审核",
						content:$("#div_SH")
					})
					
					$("#commentId").val(id);
			  	}else if(layEvent === 'cancel'){
			  		//取消审核
			  		cancel(id);
			  	}else if(layEvent === 'deletes'){
			  		//删除
			  		deletes(id);
			  	}
			});
			
			//审核通过
			$(".ok").click(function(){
				var id = $("#commentId").val();
				var remark = $("#remark").val();
				if(remark==''){
					alertinfo("请填写审核意见！");
					return ;
				}
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/comment/toExamine",
					data : {"id" : id,"remark":remark,"status":1},
					success : function(data) {
						tableIns.reload({
							where: { //设定异步数据接口的额外参数，任意设
								status:0,
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
						if(data.success){
							layer.msg(data.msg,{icon: 1});
						}else{
							layer.msg(data.msg,{icon: 2});
						}
						layer.close(div_index);
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			})
			//审核驳回
			$(".cancle").click(function(){
				var id = $("#commentId").val();
				var remark = $("#remark").val();
				if(remark==''){
					alertinfo("请填写审核意见！");
					return ;
				}
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/comment/toExamine",
					data : {"id" : id,"remark":remark,"status":2},
					success : function(data) {
						tableIns.reload({
							where: { //设定异步数据接口的额外参数，任意设
								status:0,
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
						layer.close(div_index);
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			})
			//取消审核
			function cancel(id){
				//获取当前点击选项卡的状态值
				var status = $("#tab_list > li.layui-this").data("state");
				layer.confirm('确定取消审核吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/comment/cancels",
						data : {"id" : id},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									status:status,
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
			
			//删除
			function deletes(id){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/comment/deletes",
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
			//批量删除
			$('#deleteId').click(function(){
				
				var checkStatus = table.checkStatus('comment');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].id + ',';
				})
				layer.confirm('确定将所选全部删除吗？', function(index){
					deleteid(ids,layer, tableIns);
				})
			});
			function deleteid(ids,layer, tableIns){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/comment/deleteids",
					async : false,
					data : {
						"ids" : ids
					},
					success : function(data) {
						tableIns.reload({
							where: {
								content: $('input[name="content"]').val(),
								poster: $('input[name="poster"]').val(),
								status: $('select[name="status"]').val(),
								dateTime: $('input[name="dateTime"]').val(),
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
						layer.alert(data.msg,{icon: 1});
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			}
		})
		
		
	</script>

</m:Content>
</m:ContentPage>
