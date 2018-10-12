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
			分账设置
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">专家姓名：</label>
					<div class="layui-input-inline">
						<input type="text" name="teacherName" id="teacherName" placeholder="请填写专家姓名" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">课程名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="className" id="className" placeholder="请填写课程名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="status" id="status">
							<option value="">全部</option>
							<option value="0" >启用</option>
							<option value="1" >禁用</option>
						</select>
					</div>
				</div>
				<div class="layui-inline" style="width: 15%;">
					<input type="checkbox" name="isNo" id="isNo"><span style="margin-left: 2%;">只展示有未设置分成的作家记录</span>
				</div>
				
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" style="background-color: #FF6633" id="reset"><i class="layui-icon">&#xe620;</i>重置</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="daochu">批量导出</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -4.5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="qiyong" >批量启用</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -4.5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="jinyong" >批量禁用</button>
					</div>
				</div>
				
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 未设置课程 -->
	<script type="text/html" id="noSetCount">
		{{# if(d.noSetCount==null){ }}
			未设置
		{{# }else{ }}
			{{d.noSetCount}}
		{{# } }}
	</script>
	<!-- 已设置课程 -->
	<script type="text/html" id="setCount">
		{{# if(d.setCount==null){ }}
			未设置
		{{# }else{ }}
			{{d.setCount}}
		{{# } }}
	</script>
	<!-- 问答分成 -->
	<script type="text/html" id="questionRate">
		{{# if(d.questionRate==null){ }}
			未设置
		{{# }else{ }}
			{{d.questionRate}}%
		{{# } }}
	</script>
	<!-- 打赏分成 -->
	<script type="text/html" id="rewardRate">
		{{# if(d.rewardRate==null){ }}
			未设置
		{{# }else{ }}
			{{d.questionRate}}%
		{{# } }}
	</script>
	<!-- 状态 -->
	<script type="text/html" id="infoStatus">
		{{# if(d.status==null){ }}
			未设置
		{{# }else if(d.status==0){ }}
			启用
		{{# }else{ }}
			禁用
		{{# } }}
	</script>
	<!-- 操作按钮 -->
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="update">设置</a>
		{{# if(d.status!=null){ }}
			{{# if(d.status==0){ }}
				<a class="layui-btn layui-btn-xs" style="background-color: red;" lay-event="delete">禁用</a>
			{{# }else{ }}
				<a class="layui-btn layui-btn-xs" lay-event="enable">启用</a>
			{{# } }}
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script src="/manage/public/js/jquery.form.min.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			laydate.render({
				elem: '#startTime',
				/* range: true  区间时间选择*/
			});
			laydate.render({
				elem: '#endTime',
			});
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/finance/cents/centsSetUpListData', //数据接口
				cellMinWidth: 100,
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[	
						//表头
						{
							type: 'checkbox',
							width: "5%",
						},
						{
							field: 'userId',
							title: '用户ID',
						},
						{
							field: 'realname',
							title: '专栏作家',
						},
						{
							field: 'userName',
							title: '账号',
						},
						{
							field: '',
							title: '未设置课程',
							toolbar:'#noSetCount',
						}, 
						{
							field: '',
							title: '已设置课程',
							toolbar:'#setCount',
						},
						{
							field: '',
							title: '问答分成',
							toolbar:'#questionRate',
						},
						{
							field: '',	
							title: '打赏分成',
							toolbar:'#rewardRate',
						},
						{
							field: '',
							title: '状态',
							toolbar: '#infoStatus',
							
						},
						{
							fixed: 'right',
							title: '操作',
							width:'15%',
							align: 'center',
							toolbar: '#barDemo',
							rowType:"operation",
						}
					]
				],
				done: function(res, curr, count){
					
				 }
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
			
			//监听锁定操作
			form.on('checkbox(approveFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unapproveOraprove(id, 1);
				}else{
					unapproveOraprove(id, 0);
				}
			});
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				
				if(layEvent === 'update'){ //设置
			      	setUp(data.userId);
			  	} else if(layEvent === 'delete'){ //禁用
			  		setUpStatus(1,data.userId);
			  	}else if(layEvent === 'enable'){//启用
			  		setUpStatus(0,data.userId);
			  	}
			})
			
			$('#search').click(function() { //搜索，重置表格
				var isNo = $("#isNo").is(":checked");
				var isNoType = 0; 
				if(isNo){//查询未设置的
					isNoType = 0;
				}else{//查询全部的
					isNoType = 1;
				}
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						teacherName:$('#teacherName').val(),
						className:$('#className').val(),
						status:$('#status').val(),
						isNoType:isNoType,
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			$('#reset').click(function(){//重置
				$('#teacherName').val(""),
				$('#className').val(""),
				$('#status').val(""),
				$("#isNo").attr("checked",false);
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						teacherName:"",
						className:"",
						status:"",
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			//添加分成设置信息
			function setUp(userId){
				openwindow("/finance/cents/setUpRate?userId="+userId,"设置分成",1200,1000,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			//批量导出
			/*  $("#daochu").click(function(){
				var str = [];
				var userId = '';
				var checkStatus = table.checkStatus('buyerList');
				var data = checkStatus.data; 
				for(var i = 0;i<data.length;i++){
					str.push(data[i].userId);
				}
				if(str.length>0){
					userId = str.join(","); 
				}
				window.location.href="/${applicationScope.adminprefix }/finance/cents/batchExport?userId="+userId;
			})  */
			
			$("#qiyong").click(function(){
				setUpStatus(0,0)
			})
			$("#jinyong").click(function(){
				setUpStatus(1,0)
			})
			//修改专家分成设置状态
			function setUpStatus(statusType,userId){
				var str = [];
				if(userId==0){
					var checkStatus = table.checkStatus('buyerList');
					var data = checkStatus.data; 
					for(var i = 0;i<data.length;i++){
						str.push(data[i].userId);
					}
					userId = str.join(","); 
				}
				if(str.length==0 && userId==0){
					layer.msg("请选择要操作的用户",{icon: 2});
				}else if(userId!=0 || str.length>0){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/finance/cents/setUpStatus",
						data : {"statusType" : statusType,"userId":userId},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
							if(data.result){
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
						},
						error : function(data) {
							layer.alert(data.msg,{icon: 2});
						}
					});
				}
			} 
		});
		
	</script>
</m:Content>
</m:ContentPage>
