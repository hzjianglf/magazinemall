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
		.layui-body{overflow-y: scroll;}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			${classtype=='0'?'点播课程管理':'直播课程管理' }
		</blockquote>
		<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">课程分类：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="type">
							<option value="">全部</option>
							<c:forEach items="${typeList }" var="typeList">
								<option value="${typeList.id }">${typeList.name }</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">课程状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="status">
							<option value="">全部</option>
							<option value="-1">未发布</option>
							<option value="1">已发布</option>
							<option value="0">已关闭</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">课程名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" placeholder="请填写课程名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">创建者：</label>
					<div class="layui-input-inline">
						<input type="text" name="founder" placeholder="请填写创建者名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">讲师：</label>
					<div class="layui-input-inline">
						<input type="text" name="teacher" placeholder="请填写讲师名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				
				<div class="layui-inline">
					<button class="layui-btn layui-btn-normal search"><i class="layui-icon">&#xe615;</i> 搜索</button>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline">
				<button class="layui-btn add"><i class="layui-icon">&#xe608;</i> ${classtype=='0'?'创建点播课程':'创建直播课程' }</button>
			</div>
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="ondemand" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
		{{# if(d.status == '已发布' || d.status == '未开始' || d.status == '直播中'){ }}
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="close">关闭</a>
		{{# }else if(d.classtype == '0'){ }}
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="release">发布</a>
		{{# } }}	
		{{# if(d.status == '未发布' || d.status == '未开始' || d.status == '已关闭' || d.status == '已结束'){ }}
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="deletes">删除</a>
		{{# } }}
	</script>
	<script type="text/html" id="checkApprove">
  		<input type="checkbox" value="{{d.ondemandId}}" title="推荐" lay-filter="approveFilter" {{ d.IsRecommend == 1 ? 'checked' : '' }}/>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			//绑定表格
			var tableIns = table.render({
				id: 'ondemand',
				elem: '#ondemand',
				cellMinWidth: 80,
				url: '/${applicationScope.adminprefix }/ondemand/listData?classtype=${classtype}', //数据接口
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
							field: 'ondemandId',
							title: '课程编号',
							width: "8%",
						}, 
						{
							field: 'name',
							title: '课程名称',
							width: "20%"
						}, 
						{
							field: 'serialName',
							title: '连载状态',
							width: "8%"
						}, 
						{
							field: 'teacherName',
							title: '讲师',
							width: "5%"
						}, 
						{
							field: 'studentNum',
							title: '学员数量',
							width: "6%"
						}, 
						/* {
							field: 'shouru',
							title: '收入'
						},  */
						{
							field: 'status',
							title: '状态',
							width: "5%"
						}, 
						{
							field: 'founder',
							title: '创建者',
							width: "20%"
						}, 
						{
							field: 'IsRecommend',
							title: '是否推荐',
							templet: '#checkApprove',
							unresize: true,
							width: "10%"
						},
						{
							title: '操作',
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					var classtype = '${classtype}';
					if(classtype=='1'){
						$("[data-field='serialName']").css('display','none');
						$("[data-field='IsRecommend']").css('display','none');
					}else{
						$("[data-field='starttime']").css('display','none');
					}
					InitToolTips();
				}
			});
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						teacher: $('input[name="teacher"]').val(),
						founder: $('input[name="founder"]').val(),
						name: $('input[name="name"]').val(),
						type: $('select[name="type"]').val(),
						status: $('select[name="status"]').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//监听锁定操作
			form.on('checkbox(approveFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					updateIsRecommend(id, 1);
				}else{
					updateIsRecommend(id, 0);
				}
			});
			//创建点播课程
			$('.add').click(function() { 
				var classtype = $("#classtype").val();
				window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?page=1&classtype='+classtype;
			});
			//操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var ondemandId = data.ondemandId;
				//获取当前课程类型
				var classtype = data.classtype;
				//获得 lay-event 对应的值（区分点击的按钮）
				var layEvent = obj.event; 
				if(layEvent === 'edits'){ 
					//编辑
			  		window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+ondemandId+'&page=1&classtype='+classtype;
			  	}else if(layEvent === 'close'){
			  		//关闭
			  		upStatus(ondemandId,0);
			  	}else if(layEvent === 'release'){
			  		//发布
			  		upStatus(ondemandId,1);
			  	}else if(layEvent === 'deletes'){
			  		//删除
			  		deletes(ondemandId);
			  	}
			});
			//修改状态
			function upStatus(ondemandId,type){
				var text = '';
				if(type == '0'){
					text = '关闭';
				}else if(type == '1'){
					text = '发布'
				}
				layer.confirm('确定'+text+'吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/ondemand/upStatus",
						data : {"ondemandId" : ondemandId,"status" : type},
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
			//删除
			function deletes(ondemandId){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/ondemand/deletes",
						data : {"ondemandId" : ondemandId},
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
			//设置推荐不推荐
			function updateIsRecommend(id,type){
				var text = "确定设为推荐课程吗？";
				if(type == '0'){
					text = "确定设为不推荐课程吗？";
				}
				layer.confirm(text, {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/ondemand/updateIsRecommend",
						data : {"ondemandId" : id,"IsRecommend":type},
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
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
						},
						error : function(data) {
							layer.msg(data.msg,{icon: 2});
						}
					});
				})
			}
			
		})
		
	</script>
</m:Content>
</m:ContentPage>
