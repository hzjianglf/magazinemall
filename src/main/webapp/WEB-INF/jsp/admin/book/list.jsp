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
		<div class="yw_cx search1" id="yw_cx_search1">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">期刊类别：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="periodId" id="periodId">
							<option value="">请选择</option>
							<c:forEach items="${periodList}" var="item">
								<option value="${item.id }">${item.name }</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">出版年份：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="year" id="year">
							<option value="">请选择</option>
							<c:forEach items="${years}" var="item">
								<option value="${item}">${item}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">课程状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="state" id="state">
							<option value="">请选择</option>
							<option value="1" ${state=='1'?'selected':'' }>下架</option>
							<option value="0" ${state=='0'?'selected':'' }>上架</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">书刊名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="Tbx_name" id="Tbx_name" placeholder="请填写书刊名称" autocomplete="off" class="layui-input">
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
		
		<div class="yw_cx search2" id="yw_cx_search2" style="display: none">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">期刊名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" id="name" placeholder="请填写期刊名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">出版年份：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="years" id="years">
							<option value="">请选择</option>
							<c:forEach items="${years}" var="item">
								<option value="${item}">${item}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">出版社：</label>
					<div class="layui-input-inline">
						<input type="text" name="magazine1" id="magazine1" placeholder="请填写出版社" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">生成日期：</label>
					<div class="layui-input-inline">
						<input type="text" class="layui-input" id="time" name="time" placeholder="yyyy-MM-dd"	>
					</div>
				</div>
				<div class="layui-inline layui-form" id="layerDemo3">
					<input type="checkbox" name="status" title="仅展示启用记录" id="statusChange">
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search2"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline" id="layerDemo1">
				<button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>创建图书期刊</button>
				<button class="layui-btn" id="ebook" lay-filter="ebook">电子版期刊</button>
			</div>
			<div class="layui-inline" id="layerDemo2" style="display: none">
				<button class="layui-btn" id="back" lay-filter="back">返回</button>
			</div>
			<!-- <div class="layui-inline" style="float: right" id="btn_div">
				<button class="layui-btn layui-btn-normal approve">合刊</button>
				<button class="layui-btn layui-btn-normal unapprove">取消合刊</button>
				<button class="layui-btn layui-btn-normal unlock">增刊</button>
				<button class="layui-btn layui-btn-warm lock">返回</button>
			</div> -->
			<div style="clear: both"></div>
		</div>
		<div class="layui-form book">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent1"></table>
		</div>
		<div class="layui-form ebook" style="display: none">
			<table class="layui-table" lay-skin="line" id="ebooklist"  lay-filter="tableContent2"></table>
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
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="barDemo2">
		<a class="layui-btn layui-btn-xs" lay-event="editebook">详情</a>
		{{# if(d.status==0){ }}
			<a class="layui-btn layui-btn-xs" lay-event="enable">启用</a>
		{{# }else{ }}
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="disable">禁用</a>
		{{# } }}
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
			var perId='${perId}';
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/book/listData?perId='+perId, //数据接口
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
							title: '书刊编号',
							width: "8%"
						},
						{
							field: 'name',
							title: '书刊名称',
							width: "20%"
						}, 
	 					{
							field: 'year',
							title: '出版年份',
							width: "8%"
						}, 
						{
							field: 'sales',
							title: '已售|库存',
							templet: '#total',
							unresize: true
						},
						{
							field: 'paperPrice',
							title: '纸质版价格',
							width: "8%"
						},
						{
							field: 'ebookPrice',
							title: '电子版价格',
							width: "8%"
						},
						{
							field: 'state',
							title: '状态',
							templet: '#checkApprove',
							unresize: true
						},
						{
							field: 'founder',
							title: '创建者'
						}, 
						{
							field: 'date',
							title: '创建时间'
						}, 
						{
							fixed: 'right',
							title: '操作',
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				]
			});
			
			//新增
			$("#add").click(function() {
				
				openwindow("/book/add","创建图书期刊",800,600,true,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				})
			})
			//电子版期刊
			$("#ebook").click(function() {
				$("#yw_cx_search2").css("display","");
				$("#yw_cx_search1").css("display","none");
				$(".book").css("display","none");
				$("#layerDemo1").css("display","none");
				$(".ebook").css("display","");
				$("#layerDemo2").css("display","");
			})
			$("#back").click(function(){
				$("#yw_cx_search2").css("display","none");
				$("#yw_cx_search1").css("display","");
				$(".ebook").css("display","none");
				$("#layerDemo2").css("display","none");
				$(".book").css("display","");
				$("#layerDemo1").css("display","");
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
					unapproveOraprove(id, 0);
				}else{
					unapproveOraprove(id, 1);
				}
			});
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						type:$('#type').val(),
						name:$("#Tbx_name").val(),
						state:$('#state').val(),
						magazine:$('#magazine').val(),
						founder:$('#founder').val(),
						periodId:$("#periodId").val(),
						year:$("#year").val()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			table.on('tool(tableContent1)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'del'){ //删除
			      	delBuyer(data.id);
			  	} else if(layEvent === 'edit'){ //编辑
			  		layer.open({
						type: 2,
						title: ['编辑图书期刊', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', '100%'],
						content: '/${applicationScope.adminprefix }/book/add?id=' + data.id,
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
			  	}
			})
			
			/* $('#btn_div .layui-btn').click(function(){
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
				
			}) */
			//增刊
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
				layer.confirm('确定删除当前所选出版计划吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/book/deleteBook",
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
			
			//上架/下架
			function unapproveOraprove(ids, status){
				var text = '确定上架当前商品吗？'
				if(status == 1){
					text = '确定下架当前商品吗？';
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
				        type:"post",
				        url:"/${applicationScope.adminprefix }/book/upState",
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
		
		
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			laydate.render({
				elem: '#time'
			});
			
			var perId='${perId}';
			//绑定文章表格
			var tableIns2 = table.render({
				id: 'ebooklist',
				elem: '#ebooklist',
				url: '/${applicationScope.adminprefix }/book/ebookListData?perId='+perId, //数据接口
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
							title: '电子期刊ID',
							width: "8%"
						},
						{
							field: 'name',
							title: '期刊名称',
							width: "25%"
						}, 
						{
							field: 'year',
							title: '年份',
							width: "8%"
						},
						{
							field: 'magazine',
							title: '出版社',
						},
						{
							field: 'status',
							title: '状态',
							templet: '#ebookStatus'
						},
						{
							field: 'time',
							title: '生成日期'
						}, 
						{
							fixed: 'right',
							title: '操作',
							align: 'center',
							toolbar: '#barDemo2'
						}
					]
				]
			});
			$('#search2').click(function(){
				tableIns2.reload({
					where:{
						name:$('#name').val(),
						magazine:$('#magazine1').val(),
						year:$('#years').val(),
						time:$('#time').val()
					},
					page:{
						curr: 1 //重新从第 1 页开始
					}
				})
			});
			$('#layerDemo3').click(function(){
				var status = $('#statusChange').prop('checked');
				if(status){
					tableIns2.reload({
						where:{
							status:'1'
						},
						page:{
							curr: 1 //重新从第 1 页开始
						}
					});
				}else{
					tableIns2.reload({
						where:{
							status:''
						},
						page:{
							curr: 1 //重新从第 1 页开始
						}
					});
				}
			});
			table.on('tool(tableContent2)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				var id = data.id;
				
				if(layEvent === 'del'){ //删除
			      	delBuyer(data.id);
			  	} else if(layEvent === 'editebook'){ //编辑
			  		layer.open({
						type: 2,
						title: ['电子书内容', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', '100%'],
						content: '/${applicationScope.adminprefix }/book/turnebookContent?id=' + data.id,
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
			  	}
				//启用
				if(layEvent=="enable"){
					changeBookStatus(id,1);
				}
				//禁用
				if(layEvent=="disable"){
					changeBookStatus(id,0);
				}
			});
			//更新用户分成状态
			function changeBookStatus(id,type){
				var t="禁用";
				if(type==1){
					t="启用";
				}
				confirminfo("您确定进行"+t+"操作?",function(){
					var url=getUrl("book/upBookStatus");
					$.post(url,{
						id:id,
						status:type,
						r:Math.random()
					},function(obj){
						tipinfo(obj.msg);
						if(obj.result){
							tableIns2.reload({
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
