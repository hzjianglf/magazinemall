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
					<label class="layui-form-label">支付日期：</label>
					<div class="layui-input-inline">
						<input type="text" name="payTime" id="payTime" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">课程名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" autocomplete="off" class="layui-input">
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
			<table class="layui-table" lay-skin="line" id="classlog" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	
	
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
		   		elem: '#payTime',
		   		range:true
		  	});
			//绑定表格
			var tableIns = table.render({
				id: 'classlog',
				elem: '#classlog',
				url: '/${applicationScope.adminprefix }/division/teacherOndemand/listData?userId=${userId}&year=${year}&month=${month}', //数据接口
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
							field: 'orderno',
							title: '订单支付记录',
							width: "10%"
						}, 
						{
							field: 'userName',
							title: '买家账号',
							width: "10%"
						}, 
						{
							field: 'name',
							title: '课程信息',
							width: "10%"
						},
						{
							field: 'presentPrice',
							title: '应付',
							width: "10%"
						},
						{
							field: 'daijinquan',
							title: '代金券',
							width: "10%"
						}, 
						{
							field: 'price',
							title: '实际支付',
							width: "10%"
						}, 
						{
							field: 'rate',
							title: '分成比例%',
							width: "10%"
						}, 
						{
							field: 'payMethodName',
							title: '支付方式',
							width: "10%"
						}, 
						{
							field: 'ratePrice',
							title: '应发分成',
							width: "10%"
						},
						{
							field: 'shui',
							title: '增值税',
							width: "5%"
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
						name: $('input[name="name"]').val(),
						payTime:$('input[name="payTime"]').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			
			
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
			
		})
		
		
		
	</script>

</m:Content>
</m:ContentPage>
