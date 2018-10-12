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
			出版计划
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">年份：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="year" id="year">
							<option value="">请选择</option>
							<c:forEach items="${list }" var="y">
								<option value="${y.year }" ${y.year==year?'selected':'' }>${y.year }</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">期次描述：</label>
					<div class="layui-input-inline">
						<input type="text" name="describes" id="describes" placeholder="请填写期次描述" autocomplete="off" class="layui-input">
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
						<button class="layui-btn layui-btn-normal" id="search">搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo">
				<button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>添加出版计划</button>
			</div>
			<div class="layui-inline" style="float: right" id="btn_div">
				<!-- <button class="layui-btn layui-btn-normal approve">合刊</button>
				<button class="layui-btn layui-btn-normal unapprove">取消合刊</button>
				-->
				<!-- <button class="layui-btn layui-btn-normal unlock">增刊</button>  -->
				<button class="layui-btn layui-btn-warm lock">返回</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="total">
  		总第{{d.totalPeriod}}期
	</script>
	<script type="text/html" id="checkMerge">
		{{ d.isMerge == 1 ? '是' : '否' }}
	</script>
	<script type="text/html" id="checkAdd">
		{{ d.isAdd == 1 ? '是' : '否' }}
	</script>
	<script type="text/html" id="checkApprove">
  		<input type="checkbox" value="{{d.id}}" title="启用" lay-filter="approveFilter" {{ d.state == 1 ? 'checked' : '' }}/>
	</script>
<!-- 		<a class="layui-btn layui-btn-xs" lay-event="column">栏目</a> -->
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		var perId='${perId}';
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
			var perId='${perId}';
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/publishingplan/listData?perId='+perId, //数据接口
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
							width: "6%",
						},
						{
							field: 'year',
							title: '年份',
							width: "12%"
						}, 
						{
							field: 'describes',
							title: '期次描述',
							width: "12%"
						},
						{
							field: 'totalPeriod',
							title: '总期次',
							width: "13%",
							templet: '#total',
							unresize: true
						},
						{
							field: 'isMerge',
							title: '是否合刊',
							width: "7%",
							templet: '#checkMerge',
							unresize: true
						},
						{
							field: 'isAdd',
							title: '是否增刊',
							width: "7%",
							templet: '#checkAdd',
							unresize: true
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
							width: "12%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				]
			});
			
			//新增
			$('#add').click(function(){
				layer.open({
		  			type: 2,
		  			title: '添加出版计划',
		  			area: ['50%', '80%'],
		  			content: ['/${applicationScope.adminprefix }/publishingplan/add?perId='+perId, 'no'],
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
			/* $("#add").click(function() {
				layer.open({
					type: 2,
					title: ['添加出版计划', 'font-size:18px;'],
					shadeClose: true,
					area: ['30%', '50%'],
					content: '/${applicationScope.adminprefix }/publishingplan/add?perId='+perId,
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
			}) */
			
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
						year:$('#year').val(),
						describes:$('#describes').val(),
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
			  	}else if(layEvent === 'column'){
					layer.open({
						type: 2,
						title: '板块栏目',
						shadeClose: false,
						area: ['50%', "65%"],
						content: '/${applicationScope.adminprefix }/periodical/turnColumn?id='+data.id,
						success: function(layero, index) {
							
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
			  			title: '编辑出版计划',
			  			area: ['50%', '80%'],
			  			content: ['/${applicationScope.adminprefix }/publishingplan/add?id=' + data.id+'&perId='+perId, 'no'],
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
			  		/* layer.open({
						type: 2,
						title: '编辑期刊档案',
						shadeClose: true,
						area: ['30%', "55%"],
						content:  ,
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
					}); */
			  	}
			})
			
			$('#btn_div .layui-btn').click(function(){
				if($(this).hasClass('lock')){//返回
					back(userIds, 0);
				}
				var checkStatus = table.checkStatus('buyerList');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var userIds = '';
				$.each(checkStatus.data, function(i){
					userIds = userIds + checkStatus.data[i].id + ',';
				})
				if($(this).hasClass('unlock')){//增刊
					unlockOrLock(userIds, 1);
				}
				if($(this).hasClass('unapprove')){//取消合刊
					unapproveOraprove(userIds, 0);
				}
				if($(this).hasClass('approve')){//合刊
					unapproveOraprove(userIds, 1);
				}
				
			})
			function back(ids, status){
				location.href='/${applicationScope.adminprefix }/periodical/list';
			}
			//增刊
			function unlockOrLock(ids, status){
				var text = '确定冻结当前所选用户吗？'
				if(status == 1){
					text = '确定解冻当前所选用户吗？';
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/publishingplan/lockOrUnlockBuyer",
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
				layer.confirm('确定删除当前所选出版计划吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/publishingplan/deletePeriodical",
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
			
			// 认证/反认证
			function unapproveOraprove(ids, status){
				var text = '确定禁用当前期刊吗？'
				if(status == 1){
					text = '确定启用当前期刊吗？';
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/publishingplan/upState",
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
