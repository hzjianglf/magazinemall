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
					<label class="layui-form-label">问答内容：</label>
					<div class="layui-input-inline">
						<input type="text" name="content" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">分成状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="divideStatus">
							<option value="">全部</option>
							<option value="0">无效</option>
							<option value="1">有效</option>
						</select>
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
	
	<script type="text/html" id="state">
		{{# if(d.divideStatus==0){ }}
				无效
		{{# }else if(d.divideStatus==1){ }}
				有效
		{{# } }}
	</script>
	<script type="text/html" id="state">
		{{# if(d.divideStatus==0){ }}
				<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="effective">有效</a>
		{{# }else if(d.divideStatus==1){ }}
				<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="invalid">无效</a>
		{{# } }}
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
		   		elem: '#payTime',
		   		range:true
		  	});
			//绑定表格
			var tableIns = table.render({
				id: 'classlog',
				elem: '#classlog',
				url: '/${applicationScope.adminprefix }/division/questionlog/listData?userId=${userId}&year=${year}&month=${month}', //数据接口
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
							title: '支付记录号',
							width: "10%"
						}, 
						{
							field: 'userName',
							title: '买家账号',
							width: "10%"
						}, 
						{
							field: 'content',
							title: '问答信息',
							width: "10%"
						},
						{
							field: 'questionPrice',
							title: '应付',
							width: "10%"
						},
						{
							field: 'price',
							title: '实际支付',
							width: "10%"
						},
						{
							field: 'payMethodName',
							title: '支付方式',
							width: "10%"
						}, 
						{
							field: 'ratePrice',
							title: '分成金额',
							width: "10%"
						},
						{
							field: 'ratePrice',
							title: '状态',
							templet:'#state',
							width: "10%"
						},
						{
							title: '操作',
							width: "15%",
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
						content: $('input[name="content"]').val(),
						payTime: $('input[name="payTime"]').val(),
						divideStatus:$('select[name="divideStatus"]').val(),
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
				var id = data.id;//问答记录id
				var userId = data.userId;//教师id
				var ratePrice = data.ratePrice;//分成金额
				var payTime = data.payTime;//当前时间年-月
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'effective'){
			  		//有效
					effective(id,userId,ratePrice,payTime);
			  	}else if(layEvent === 'invalid'){
			  		//无效
			  		invalid(id,userId,ratePrice,payTime);
			  	}
			});
			//有效
			function effective(id,userId,ratePrice,payTime){
				$.ajax({
					type:'post',
					data:{"id":id,"userId":userId,"ratePrice":ratePrice,"status":1,"payTime":payTime,"statusType":"1"},
					url:'/${applicationScope.adminprefix }/division/effective',
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
						reload();
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
			}
			//无效
			function invalid(id,userId,ratePrice,payTime){
				$.ajax({
					type:'post',
					data:{"id":id,"userId":userId,"ratePrice":ratePrice,"status":0,"payTime":payTime,"statusType":"1"},
					url:'/${applicationScope.adminprefix }/division/invalid',
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
						reload();
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
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
			
		})
		
		
		
	</script>

</m:Content>
</m:ContentPage>
