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
		<blockquote class="layui-elem-quote layui-bg-blue">
			分账计算
		</blockquote>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div  class="layui-form-item">
				<div class="layui-inline">
					<button id="calculation" class="layui-btn layui-btn-warm" >分成计算</button>
				</div>	
				<div class="layui-inline">
					<button class="layui-btn layui-btn-normal" >批量导出</button>
				</div>	
				<div class="layui-inline">
					<button id="batchSubmit" class="layui-btn layui-btn-normal" >批量提交</button>
				</div>	
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="division" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">修改</a>
		{{# if(d.status != 0){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="delete">作废</a>
		{{# } }}
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="submit">提交</a>
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
		var tableIns;
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			//绑定表格
			tableIns = table.render({
				id: 'division',
				elem: '#division',
				url: '/${applicationScope.adminprefix }/division/listData', //数据接口
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
							field: 'xh',
							title: '编号',
							width: "5%"
						}, 
						{
							field: 'name',
							title: '批次',
							width: "10%"
						}, 
						{
							field: 'userCount',
							title: '专栏作家',
							width: "10%"
						},
						{
							field: 'totalOndemandMoney',
							title: '课程金额',
							width: "10%"
						},
						{
							field: 'totalQuestionMoney',
							title: '问答金额',
							width: "10%"
						}, 
						{
							field: 'totalRewardMoney',
							title: '打赏金额',
							width: "10%"
						}, 
						{
							field: 'totalSalesTax',
							title: '营业税金额',
							width: "10%"
						}, 
						{
							field: 'totalPersonalTax',
							title: '个人所得税金额',
							width: "10%"
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
				}
			});
			//监听操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var id = data.id;
				var month = data.month;
				var year = data.year;
				var name=data.name;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				
				if(layEvent === 'edits'){//修改
					nextConfirm(id,month,year);
			  	}else if(layEvent === 'delete'){//作废操作
			  		updateStatus(id,0);
			  	}else if(layEvent === 'submit'){//提交审核
			  		handIn(id);
			  	}
			});
			
			//作废操作
			function updateStatus(id,status){
				confirm('确定作废吗？', ok);
				function ok(){
					$.ajax({
						type:'post',
						data:{"id":id,"status":status},
						url:'/${applicationScope.adminprefix }/division/updateStatus',
						datatype:'post',
						success:function(data){
							if(data.success){
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
							reload();
						},
						error:function(data){
							tipinfo("出错了!");
						}
					})
				}
			}
			//批量提交
			$("#batchSubmit").click(function(){
				tipinfo("submit");
				var checkStatus = table.checkStatus('division');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].id + ',';
				})
				handIn(ids);
			})
			//提交审核
			function handIn(id){
				confirm('您确定要提交此月度的分成记录？', function(){
					$.ajax({
						type:'post',
						data:{"id":id,"status":2,"trialStatus":1,},
						url:'/${applicationScope.adminprefix }/division/handInDivisonlog',
						datatype:'post',
						success:function(data){
							if(data.success){
								tipinfo(data.msg);
							}else{
								tipinfo(data.msg);
							}
							reload();
						},
						error:function(data){
							tipinfo("出错了!");
						}
					})
				})
			}
			
			//分成计算
			$("#calculation").click(function(){
				openwindow('bill/monthList',"分成计算",450,250,false,reload);
			})
			//修改
			/*function selDetails(id,name){
				openwindow('division/divisionDetail?batchId='+id,"分成详情-"+name,1500,800,false,reload);
			}*/
			
			//表格加载事件
			function reload(){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			
		});
		
		function next(year,month){
			openwindow('bill/SetUpFormula?year='+year+'&month='+month,"分成计算",1500,800,false,reload);
		};
		
		function nextP(year,month){
			openwindow('bill/toProportions?year='+year+'&month='+month,"设置分成比例",1500,800,false,reload);
		};
		
		function nextConfirm(id,month,year){
			openwindow('bill/toConfirmYE?id='+id+"&month="+month+"&year="+year,"分成确认",1500,800,false,reload);
		}
		
		function reload(){
			tableIns.reload({
				where: { //设定异步数据接口的额外参数，任意设
					num:Math.random()
				},
				page: {
					curr: 1 //重新从第 1 页开始
				}
			});
		}
		
	</script>

</m:Content>
</m:ContentPage>
