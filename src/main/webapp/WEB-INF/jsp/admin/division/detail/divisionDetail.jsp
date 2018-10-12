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
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">作家信息：</label>
					<div class="layui-input-inline">
						<input type="text" name="realname" autocomplete="off" class="layui-input" placeholder="作家ID或姓名">
					</div>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="divisionDetail" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="cut">扣款</a>
	</script>
	<script type="text/html" id="teacherDetail">
		<a style="color:blue;" lay-event="teacherDetail">{{ d.ondemandMoney}}</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		/*layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			//绑定表格
			var tableIns = table.render({
				id: 'divisionDetail',
				elem: '#divisionDetail',
				url: '/${applicationScope.adminprefix }/division/divisionDetail/listData?batchId=${batchId}', //数据接口
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
							field: 'realname',
							title: '作家信息',
							width: "10%"
						}, 
						{
							field: 'ondemandMoney',
							title: '销课金额',
							templet:'#teacherDetail',
							width: "10%"
						}, 
						{
							field: 'questionMoney',
							title: '问答金额',
							width: "10%"
						},
						{
							field: 'rewardMoney',
							title: '打赏金额',
							width: "10%"
						},
						{
							field: 'salesTax',
							title: '增值税',
							width: "10%"
						}, 
						{
							field: 'cutMoney',
							title: '其他扣款',
							width: "10%"
						}, 
						{
							field: 'shouldMoney',
							title: '应发金额',
							width: "10%"
						}, 
						{
							field: 'personalTax',
							title: '个税',
							width: "5%"
						}, 
						{
							field: 'actualMoney',
							title: '实发金额',
							width: "10%"
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
				}
			});
			
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						realname: $('input[name="realname"]').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			
			//监听操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var id = data.id;
				var realname=data.realname;//姓名
				var shouldMoney=data.shouldMoney;//应发金额
				var personalTax=data.personalTax;//个税
				var actualMoney=data.actualMoney;//实发金额
				var salesTax=data.salesTax;//营业额
				//教师id
				var userId=data.userId;
				//年月
				var year=data.year;
				var month=data.month;
				
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'cut'){//扣款
			  		cutMoney(id,realname,shouldMoney,personalTax,actualMoney,salesTax);
			  	}else if(layEvent === 'teacherDetail'){//专家分成明细
			  		openwindow("division/toTeacherDetail?userId="+userId+"&realname="+realname+"&year="+year+"&month="+month,realname+"-分成详细",1500,800,false,reload);
			  	}
			});
			//扣款弹窗
			function cutMoney(id,realname,shouldMoney,personalTax,actualMoney,salesTax){
				openwindow("division/toCutMoney?id="+id+"&realname="+realname+"&shouldMoney="+shouldMoney+"&personalTax="+personalTax+"&actualMoney="+actualMoney+"&salesTax="+salesTax,"扣款",650,550,false,reload);
			}
			
			
			
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
			
		})*/
		
		
		
	</script>

</m:Content>
</m:ContentPage>
