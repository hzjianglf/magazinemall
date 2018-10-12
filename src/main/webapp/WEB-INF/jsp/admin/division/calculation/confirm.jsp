<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style>
			.top_margin{
				margin-top:20px;
			}
			.layui-a-blue{
				color:#1E9FFF;
				font-weight:700;
			}
			.layui-layer-title{
			    background-color: #009688 !important;
			    color:#fff !important;
			}
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="layui-inline top_margin">
			<label class="layui-form-label">作家信息：</label>
			<div class="layui-input-inline">
				<input type="text" name="Tbx_userName" id="Tbx_userName" placeholder="请填写作家姓名" autocomplete="off" class="layui-input">
			</div>
		</div>
		<div class="layui-inline top_margin" id="layerDemo">
			<div class="layui-input-inline">
				<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
			</div>
		</div>
		<div class="layui-form">
		
			<table class="layui-table" id="division" lay-filter="tableContent"></table>
		</div>
		<script type="text/html" id="demo">
			<input type="text" style="width:50px" onkeyup="value=value.replace(/[^\d\.]+?/g,'')" class="rate" name = "rate_{{d.ondemandId}}" data-status="{{d.status}}" data-id="{{d.ondemandId}}" value="{{d.rate}}" />%
		</script>
		<script type="text/html" id="status">
			{{# if(d.status==0){ }}
				<font color="red">禁用</font>
			{{# }else{ }}
				<font color="green">启用</font>
			{{# } }}
		</script>
		<script type="text/html" id="Withdrawing">
			<a href="javascript:void(0)" class="layui-a-blue" onclick="toWithdrawing('{{d.realname}}',{{d.shouldMoney}},{{d.personalTax}},{{d.actualMoney}},{{d.id}},{{d.userId}},{{d.cutMoney}},'{{d.cutRemark}}')" >扣款</a>
		</script>
		<script type="text/html" id="cutMoneyTemp">
			{{ d.cutMoney==null?'0.0':d.cutMoney}}
		</script>
		<script type="text/html" id="ondemandMoneyTemp">
			<a href="javascript:void(0)" class="layui-a-blue" onclick="moneyType('1','{{d.realname}}',{{d.id}})" >{{d.ondemandMoney}}</a>
		</script>
		<script type="text/html" id="questionMoneyTemp">
			<a href="javascript:void(0)" class="layui-a-blue" onclick="moneyType('2','{{d.realname}}',{{d.id}})" >{{d.questionMoney}}</a>
		</script>
		<script type="text/html" id="rewardMoneyTemp">
			<a href="javascript:void(0)" class="layui-a-blue" onclick="moneyType('3','{{d.realname}}',{{d.id}})" >{{d.rewardMoney}}</a>
		</script>
		<script type="text/html" id="realnameTemp">
			{{d.realname}}
		</script>
		<div class="layui-col-xs6 layui-col-sm6 layui-col-md4 " style="position: absolute;bottom: 40px;left: 40%;">
			<button class="layui-btn layui-btn-normal layui-col-xs12 layui-col-sm8 layui-col-md8 " id="ok">完成</button>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script type="text/javascript">
		var tableIns;
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			$('#search').click(function() { //搜索，重置表格
				table.reload("division",{
					where: {
						userName:$.trim($("#Tbx_userName").val()),
						r:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});	
			});
			
			//绑定表格
			tableIns = table.render({
				id: 'division',
				elem: '#division',
				page:true,
				limits: [10, 20, 30, 40, 50],
				url: '/${applicationScope.adminprefix }/bill/dataList?id='+${id }, //数据接口
				cols: [
					[ //表头
						{
							title: '作家信息',
							align: 'center',
							templet: '#realnameTemp'
						}, 
						{
							title: '销课金额',
							align: 'center',
							templet: '#ondemandMoneyTemp'
						}, 
						{
							title: '问答金额',
							align: 'center',
							templet: '#questionMoneyTemp'
						},
						{
							title: '打赏金额',
							align: 'center',
							templet:'#rewardMoneyTemp'
						},
						{
							field: 'salesTax',
							title: '增值税',
							align: 'center'
						},
						{
							title: '其他扣款',
							align: 'center',
							templet:'#cutMoneyTemp'
						},
						{
							field: 'shouldMoney',
							title: '应发金额',
							align: 'center'
						},
						{
							field: 'personalTax',
							title: '个税',
							align: 'center'
						},
						{
							field: 'actualMoney',
							title: '实发金额',
							align: 'center'
						},
						{
							title: '操作',
							align: 'center',
							templet:'#Withdrawing'
						}
					]
				]
			});
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
		$('#ok').click(function(){
			closewindow();
		});
		function moneyType(sourceType,userName,id){
			openwindow('bill/sourceListForReckon?sourceType='+sourceType+"&id="+id,userName+" - 分成详情",1150,650,false,reload);
		}
		function toWithdrawing(realname,shouldMoney,personalTax,actualMoney,id,userId,cutMoney,cutRemark){
			openwindow("bill/toWithdrawing?realname="+realname+"&cutRemark="+cutRemark+"&shouldMoney="+shouldMoney+"&personalTax="+personalTax+"&actualMoney="+actualMoney+"&id="+id+"&userId="+userId+"&cutMoney="+cutMoney+"&year="+${year}+"&month="+${month}+"&biID="+${id },"扣款",560,430,false,reload);
		}
		function reload(){
			$.post("clearBillReckonItem");
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