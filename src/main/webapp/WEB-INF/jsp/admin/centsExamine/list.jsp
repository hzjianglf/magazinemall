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
			分账审核
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">提交时间：</label>
					<div class="layui-input-inline" style="width: 234px;">
						<input type="text" name="submitTime" id="submitTime" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">批次ID：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">提交人：</label>
					<div class="layui-input-inline">
						<input type="text" name="inputer" autocomplete="off" class="layui-input">
					</div>
				</div>
				
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<!-- 选项卡 -->
		<div class="layui-tab layui-tab-brief">
		  <ul class="layui-tab-title" id="tab_list">
		    <li data-state="2" class="layui-this" id="start">未审核</li>
		    <li data-state="4">审核通过</li>
		    <li data-state="3">审核驳回</li>
		  </ul>
		</div> 
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="centsExamine" lay-filter="tableContent"></table>
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
		<!-- 1--初审 2--复审 -->
		<input type="hidden" id="type" />
		<!-- id -->
		<input type="hidden" id="id" />
		<div class="btns">
			<a href="#" class="ok">审核通过</a>
			<a href="#" class="cancle">审核驳回</a>
		</div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		{{# if(d.status == 2){ }}
			{{# if(d.trialStatus == 1){ }}
				<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="firstTrial">初审</a>
				<a class="layui-btn layui-btn-disabled layui-btn-xs">复审</a>
			{{# }else if(d.trialStatus == 3){ }}
				<a class="layui-btn layui-btn-disabled layui-btn-xs">初审</a>
				<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="reviewCase">复审</a>
			{{# } }}
		{{# }else if(d.status == 4){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" onclick="opinion('{{d.id}}')">审核意见</a>
		{{# }else if(d.status == 3){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" onclick="opinion('{{d.id}}')">审核意见</a>
		{{# } }}
	</script>
	<script type="text/html" id="totalShouldMoneyType">
		{{d.totalShouldMoney==null?'0.0':d.totalShouldMoney }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
		  	laydate.render({
		   		elem: '#submitTime',
		   		range: true
		  	});
			//绑定表格
			var tableIns = table.render({
				id: 'centsExamine',
				elem: '#centsExamine',
				url: '/${applicationScope.adminprefix }/cents/listData', //数据接口
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							field: 'id',
							title: 'ID',
							width: "20%"
						},
						{
							field: 'name',
							title: '批次',
							width: "20%"
						}, 
						{
							field: 'userCount',
							title: '专家数量',
							width: "20%"
						},
						{
							toolbar: '#totalShouldMoneyType',
							title: '应付金额',
							width: "20%"
						},
						{
							title: '操作',
							width: "20%",
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
			$('#start').click();
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						submitTime: $('input[name="submitTime"]').val(),
						name: $('input[name="name"]').val(),
						inputer: $('select[name="inputer"]').val(),
						status : $("#tab_list > li.layui-this").data("state"),
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
				if(layEvent === 'firstTrial'){
			  		//审核
			  		$("#type").val('1');
			  		$("#id").val(id);
			  		/* $(".shade").show();
			  		$(".sh_win").show(); */
			  		div_index=layer.open({
						type:1,
						area:['450px','400px'],
						title:"审核",
						content:$("#div_SH")
					})
			  	}else if(layEvent === 'reviewCase'){
			  		//复审
			  		$("#id").val(id);
			  		$("#type").val('2');
			  		/* $(".shade").show();
			  		$(".sh_win").show(); */
			  		div_index=layer.open({
						type:1,
						area:['450px','400px'],
						title:"审核",
						content:$("#div_SH")
					})
			  	}
			});
			
			//审核通过
			$(".ok").click(function(){
				var remark = $("#remark").val();
				if(remark==null || remark==''){
					tipinfo("请填写审核意见!");
					return false;
				}
				var type = $("#type").val();
				var status;
				var trialStatus;
				if(type=='1'){
					status = '2';
					trialStatus='3';
				}else if(type=='2'){
					status = '4';
					trialStatus='5';
				}
				var id = $("#id").val();
				$.ajax({
					type:'post',
					url:'/${applicationScope.adminprefix }/cents/examineResult',
					data:{"remark":remark,"type":type,'trialStatus':trialStatus,"status":status,"id":id},
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
						$(".shade").hide();
				  		$(".sh_win").hide();
				  		reload();
					},
					error:function(){
						tipinfo("出错了!");
					}
				});
				$('#remark').val('');
			})
			//审核驳回
			$(".cancle").click(function(){
				var remark = $("#remark").val();
				if(remark==null || remark==''){
					tipinfo("请填写审核意见!");
					return false;
				}
				var type = $("#type").val();
				var status = '3';
				var trialStatus;
				if(type=='1'){
					trialStatus='2';
				}else if(type=='2'){
					trialStatus='4';
				}
				var id = $("#id").val();
				$.ajax({
					type:'post',
					url:'/${applicationScope.adminprefix }/cents/examineResult',
					data:{"remark":remark,"type":type,'trialStatus':trialStatus,"status":status,"id":id},
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
						$(".shade").hide();
				  		$(".sh_win").hide();
				  		reload();
					},
					error:function(){
						tipinfo("出错了!");
					}
				});
				$('#remark').val('');
			})
			//表格加载事件
			function reload(){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						status : $("#tab_list > li.layui-this").data("state"),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			
		})
		function opinion(id){
			openwindow('/cents/opinion?id='+id,"审核意见",600,600,false,null);
		}
	</script>

</m:Content>
</m:ContentPage>
