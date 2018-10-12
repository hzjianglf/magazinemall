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
			期刊档案
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">期刊名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" id="name" placeholder="请填写期刊名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">创建者：</label>
					<div class="layui-input-inline">
						<input type="text" name="founder" id="founder" placeholder="请填写创建者" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">杂志社：</label>
					<div class="layui-input-inline">
						<input type="text" name="magazine" id="magazine" placeholder="请填写杂志社" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search">搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>创建期刊档案</button>
			</div>
			<!-- <div class="layui-inline" style="float: right" id="btn_div">
				<button class="layui-btn layui-btn-normal approve">批量通过认证</button>
				<button class="layui-btn layui-btn-warm unapprove">批量解除认证</button>
				<button class="layui-btn layui-btn-normal unlock">批量解冻</button>
				<button class="layui-btn layui-btn-warm lock">批量冻结</button>
				<button class="layui-btn layui-btn-danger delete">批量删除</button>
			</div> -->
			<div style="clear: both"></div>
			<c:if test="{{d.cycle==1}}"></c:if>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="checkIsFreeze">
  		<input type="checkbox" value="{{d.id}}" title="活跃" lay-filter="freezeFilter" {{ d.isFreeze == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="checkApprove">
  		<input type="checkbox" value="{{d.id}}" title="启用" lay-filter="approveFilter" {{ d.state == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-xs" lay-event="reset">出版计划</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="checkCycle">
		{{ d.cycle == 1 ? '周刊' : '' }}
		{{ d.cycle == 2 ? '半月刊' : '' }}
		{{ d.cycle == 3 ? '月刊' : '' }}
	    {{ d.cycle == 4 ? '双月刊' : '' }}
	    {{ d.cycle == 5 ? '季刊' : '' }}
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
			/* laydate.render({
				elem: '#regTime2'
			}); */
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/periodical/listData', //数据接口
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
							title: '期刊编号',
							width: "6%",
						},
						{
							field: 'name',
							title: '期刊名称',
							width: "15%"
						}, 
						{
							field: 'magazine',
							title: '杂志社',
							width: "10%"
						},
						{
							field: 'cycle',
							title: '出版周期',
							width: "7%",
							templet: '#checkCycle',
							unresize: true
						},
						{
							field: 'editor',
							title: '主编',
							width: "7%"
						},
						{
							field: 'issn',
							title: 'ISSN',
							width: "7%"
						},
						{
							field: 'state',
							title: '状态',
							width: "8%",
							templet: '#checkApprove',
							unresize: true
						},
						{
							field: 'founder',
							title: '创建者',
							width: "8%"
						}, 
						{
							field: 'date',
							title: '创建时间',
							width: "10%"
						}, 
						{
							fixed: 'right',
							title: '操作',
							width: "17%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				]
			});
			
			//新增
			$("#add").click(function() {
				layer.open({
					type: 2,
					title: ['创建期刊档案', 'font-size:18px;'],
					shadeClose: true,
					area: ['100%', '100%'],
					content: '/${applicationScope.adminprefix }/periodical/add',
					success: function(layero, index) {
						console.log(layero, index);
						//layer.iframeAuto(index);
						layer.full(index);
					},
					end: function() { //销毁后触发
						tableIns.reload({
							height: 315
							,page: {
								curr: 1
							}
						});
					}
				});
			})
			
			//监听锁定操作
			form.on('checkbox(freezeFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unlockOrLock(id, 1);
				}else{
					unlockOrLock(id, 0);
				}
			});
			
			//监听锁定操作
			form.on('checkbox(approveFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unapproveOraprove(id, 1);
				}else{
					unapproveOraprove(id, 0);
				}
			});
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						name:$('#name').val(),
						magazine:$('#magazine').val(),
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
				
				if(layEvent === 'del'){ //删除
			      	delBuyer(data.id);
			  	}else if(layEvent === 'edit'){ //编辑
			  		layer.open({
						type: 2,
						title: '编辑期刊档案',
						shadeClose: true,
						area: ['100%', "100%"],
						content: '/${applicationScope.adminprefix }/periodical/add?id=' + data.id ,
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
			  	} else if(layEvent === 'reset'){
			  		resetPwd(data.id);
			  	}
			})
			
			// 启用/禁用
			function unlockOrLock(ids, status){
				var text = '确定冻结当前所选用户吗？'
				if(status == 1){
					text = '确定解冻当前所选用户吗？';
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/buyer/lockOrUnlockBuyer",
				        data:{"id":ids, "isFreeze":status},
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
			
			// 删除
			function delBuyer(ids){
				layer.confirm('删除当前所选期刊,会一并删除期刊下的所有期次,确定要删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/periodical/deletePeriodical",
						data : {"id" : ids},
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
			
			// 跳转期刊计划
			function resetPwd(id){
				location.href='/${applicationScope.adminprefix }/publishingplan/list?id='+id;
				/* layer.confirm('确定要重置当前用户的密码吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/buyer/resetPwd",
						data : {"userId" : userId},
						success : function(data) {
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
				}) */
				
				
			}
			
			// 认证/反认证
			function unapproveOraprove(ids, status){
				var text = '确定禁用当前期刊吗？'
				if(status == 1){
					text = '确定启用当前期刊吗？';
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/periodical/upState",
				        data:{"id":ids, "state":status},
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
			
		});
		
	</script>
</m:Content>
</m:ContentPage>
