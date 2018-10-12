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
		.shade {
			width: 100%;
			height: 100%;
			background: #000;
			opacity: 0.3;
			-webkit-opacity: 0.3;  
			-moz-opacity: 0.3;  
			-khtml-opacity: 0.3;  
			filter:alpha(opacity=30);  
			-ms-filter:"progid:DXImageTransform.Microsoft.Alpha(Opacity=30)";  
			filter:progid:DXImageTransform.Microsoft.Alpha(Opacity=30);  
			position: fixed;
			left: 0;
			top: 0;
			display: none;
		}
		.sh_win {
			width: 500px;
			height: 400px;
			position: fixed;
			top: 50%;
			left: 50%;
			margin-top: -190px;
			margin-left: -250px;
			background: #fff;
			border: 1px #e5e5e5 solid;
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
			问答管理
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">问题状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="questionState">
							<option value="0">未审核</option>
							<option value="1">审核通过</option>
							<option value="2">审核驳回</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">回答状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="answerState">
							<option value="">全部</option>
							<option value="2">已回答</option>
							<option value="1">待回答</option>
							<option value="0">已关闭</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">问答内容：</label>
					<div class="layui-input-inline">
						<input type="text" name="content" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">讲师：</label>
					<div class="layui-input-inline">
						<input type="text" name="teacher" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">买家：</label>
					<div class="layui-input-inline">
						<input type="text" name="questioner" autocomplete="off" class="layui-input">
					</div>
				</div><br/>
				<div class="layui-inline">
					<label class="layui-form-label">提问时间：</label>
					<div class="layui-input-inline" style="width: 234px;">
						<input type="text" name="registrationDate" id="registrationDate" readonly="readonly" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<button class="layui-btn layui-btn-normal search"><i class="layui-icon">&#xe615;</i> 搜索</button>
				</div>
			</div>
		</div>
		<!-- 选项卡 -->
		<div class="layui-tab layui-tab-brief" lay-filter="Demo">
		  <ul class="layui-tab-title" id="tab_list">
		    <li data-state="0" class="layui-this" lay-id="0">未审核</li>
		    <li data-state="1" lay-id="1">审核通过</li>
		    <li data-state="2" lay-id="2">审核驳回</li>
		  </ul>
		</div> 
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="interlocution" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<!-- 审核弹窗 -->
	<div class="shade"></div>
	<div class="sh_win">
		<ul>
			<li><span>审核意见：</span></li>
			<li><textarea name="remark" id="remark" style="margin-left: 50px;"></textarea></li>
		</ul>
		<input type="hidden" name="interlocutionId" id="interlocutionId" />
		<div class="btns">
			<a href="#" class="ok">审核通过</a>
			<a href="#" class="cancle">审核驳回</a>
		</div>
	</div>
	<div class="ds_nr" id="ans_ques" style="display: none;">
	  <h3>回答提问</h3>
	  <div class="clear"></div>
	  <input type="hidden" name="id" id="iterlocationId" />
	  <input type="hidden" name="lecturer" id="lecturerId" />
	  <textarea placeholder="请输入回答内容" name="rewardMsg" id="questionMsg"></textarea>
	  <button type="button" onclick="confirmToAns();">确认回答</button>
	  <a href="#" onClick="deleteAnswer()" class="gb_biao"><img src="/phone/images/gb_biao.png"></a>
    </div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		{{# if(d.questionState == 1){ }}
			  {{# if(d.answerState=='待回答'){ }}
			 		<a class="layui-btn layui-btn-xs layui-btn-xs" lay-event="answer" >回答</a>
              {{# } }}
			  <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="cancel">取消审核</a>
		{{# } }}
		{{# if(d.questionState == 0){ }}
			<a class="layui-btn layui-btn-xs layui-btn-xs" lay-event="shenhe" >审核</a>
		{{# } }}	
		{{# if(d.questionState == 2){ }}
			<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="delete">删除</a>
		{{# } }}	

	</script>
	<script type="text/html" id="state">
		{{# if(d.questionState==0){ }}
				未审核
		{{# }else if(d.questionState==1){ }}
				审核通过
		{{# }else if(d.questionState==2){ }}
				审核驳回
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate','element'], function(){
			var table = layui.table;
			var laydate = layui.laydate;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var element = layui.element;
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
			//绑定表格
			var tableIns = table.render({
				id: 'interlocution',
				elem: '#interlocution',
				url: '/${applicationScope.adminprefix }/interlocution/listData', //数据接口
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
							width: "5%"
						}, 
						{
							field: 'content',
							title: '提问内容',
							width: "23%"
						}, 
						{
							field: 'questioner',
							title: '买家',
							width: "10%"
						}, 
						{
							field: 'type',
							title: '类型',
							width: "10%"
						}, 
						{
							field: 'lecturer',
							title: '讲师',
							width: "8%"
						}, 
						{
							field: 'answerState',
							title: '回答状态',
							width: "7%"
						}, 
						{
							field: 'questionState',
							title: '问题状态',
							templet:'#state',
							width: "10%"
						}, 
						{
							field: 'inputDate',
							title: '提问时间',
							width: "12%"
						},
						{
							title: '操作',
							width: "10%",
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						teacher: $('input[name="teacher"]').val(),
						questioner : $('input[name="questioner"]').val(),
						content: $('input[name="content"]').val(),
						questionState: $('select[name="questionState"]').val(),
						answerState: $('select[name="answerState"]').val(),
						registrationDate: $('input[name="registrationDate"]').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
				//同步Tab切换
				element.tabChange('Demo', $('select[name="questionState"]').val());
			});

			//选项卡切换
			$("#tab_list > li[data-state]").on("click",function(){
				$("#tab_list > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				//获取状态值
				var status = $("#tab_list > li.layui-this").data("state");
				//重新加载表格
				tableIns.reload({
					where: {
						questionState:status,
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
				if(layEvent === 'shenhe'){//审核
					//先去查看是否已退款
					isRefund(id);
					
			  	}else if(layEvent === 'cancel'){
			  		cancelAuditIsRefund(id);
			  		//取消审核
			  		//cancel(id);
			  	}else if(layEvent === 'delete'){
			  		//删除
			  		deletes(id);
			  	}else if(layEvent === 'answer'){//回答
			  		toAnswerBeforeRefund(id);
			  		//openwindow("interlocution/toQuestionBySystem?id="+id,"回答提问",500,600,false,callback);
			  	}
			});
			function callback(){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			
			
			
			//审核通过
			$(".ok").click(function(){
				var id = $("#interlocutionId").val();
				var remark = $("#remark").val();
				if(remark==''){
					alertinfo("请填写审核意见！");
					return ;
				}
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/interlocution/toExamine",
					data : {"id" : id,"remark":remark,"status":1},
					success : function(data) {
						tableIns.reload({
							where: { //设定异步数据接口的额外参数，任意设
								questionState:0,
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
						$('.sh_win').hide();
						$('.shade').hide();
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			})
			//审核驳回
			$(".cancle").click(function(){
				var id = $("#interlocutionId").val();
				var remark = $("#remark").val();
				if(remark==''){
					alertinfo("请填写审核意见！");
					return ;
				}
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/interlocution/toExamine",
					data : {"id" : id,"remark":remark,"status":2},
					success : function(data) {
						tableIns.reload({
							where: { //设定异步数据接口的额外参数，任意设
								questionState:0,
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
						$('.sh_win').hide();
						$('.shade').hide();
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
						url : "/${applicationScope.adminprefix }/interlocution/cancels",
						data : {"id" : id},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									questionState:status,
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
				var status = $("#tab_list > li.layui-this").data("state");
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/interlocution/deletes",
						data : {"id" : id},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									questionState:status,
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
			//先去查看是否已退款
			function isRefund(id){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/interlocution/selIsRefund",
						data : {"id" : id},
						success : function(data) {
							if(data.refundIsSuccess == 1){//余额退款是否成功: 0-未成功(默认) , 1-退款成功
								layer.alert('该问答记录已退款,无法点击审核按钮');
							}else if(data.refundIsSuccess == 0){
								//审核
								$('.sh_win').show();
								$('.shade').show();
								$("#interlocutionId").val(id);
							}
						}
					});
			}
			
			function toAnswerBeforeRefund(id){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/interlocution/selIsRefund",
					data : {"id" : id},
					success : function(data) {
						if(data.refundIsSuccess == 1){//余额退款是否成功: 0-未成功(默认) , 1-退款成功
							layer.alert('该问答记录已退款,无法点击回答按钮');
						}else if(data.refundIsSuccess == 0){
							openwindow("interlocution/toQuestionBySystem?id="+id,"回答提问",500,600,false,callback);
						}
					}
				});
		  }
			
		function cancelAuditIsRefund(id){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/interlocution/selIsRefund",
					data : {"id" : id},
					success : function(data) {
						if(data.refundIsSuccess == 1){//余额退款是否成功: 0-未成功(默认) , 1-退款成功
							layer.alert('该问答记录已退款,无法点击取消审核按钮');
						}else if(data.refundIsSuccess == 0){
							cancel(id);
						}
					}
				});
		  }
			
		})
		
	</script>
</m:Content>
</m:ContentPage>
