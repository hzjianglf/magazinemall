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
			物流设置
		</blockquote>
		<div class="layui-tab layui-tab-brief">
		  <ul class="layui-tab-title" id="tab_list">
		    <li  ><a href="/${applicationScope.adminprefix }/logistics/list">发货地址</a></li>
		    <li class="layui-this"><a href="/${applicationScope.adminprefix }/logisticsTemplate/listFace">物流模板</a></li>
		  </ul>
		 </div>
		<div class="layui-inline">
			<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
				<div  class="layui-form-item">
					<button class="layui-btn add" id="addBtn">
						<i class="layui-icon">&#xe61f;</i>添加模板
					</button>	
				</div>
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="consumer" lay-filter="tableTemp"></table>
		</div>
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="setUp" data-templateids="{{d.templateId}}">地区设置</a>
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="deletes" data-rowspannum="{{d.columnNum}}">删除</a>
	</script>
	<!-- 模板操作 -->
	<script type="text/html" id="templateCaozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="tempSetUp" ><i class="layui-icon">&#xe715;</i>新增指定地区城市运费</a>
		<a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="tempDel">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		var userId = 0;
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
			//绑定表格
			var tableIns = table.render({
				id: 'consumer',
				elem: '#consumer',
				url: '/${applicationScope.adminprefix }/logisticsTemplate/listData', //数据接口
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
					  {
							field: 'templateName',
							title: '运费模板名称',
							width: "15%"
						}, 
						{
							field: 'firstGoods',
							title: '首件（个）',
							width: "9%",
							edit: 'text'
						}, 
						{
							field: 'firstFreight',
							title: '运费（元）',
							width: "9%",
							edit: 'text'
						}, 
						{
							field: 'secondGoods',
							title: '续件（个）',
							width: "9%",
							edit: 'text'
						},
						{
							field: 'secondFreight',
							title: '运费（元）',
							width: "9%",
							edit: 'text'
						}, 
						{
							field: 'addressName',
							title: '配送地址',
							width: "19%"
						}, 
						{
							title: '操作',
							width: "15%",
							align: 'center',
							toolbar: '#caozuo'
						},
						{
							title: '模板操作',
							width: "15%",
							align: 'center',
							toolbar: '#templateCaozuo'
						}
					]
				],
				done: function(){
					InitToolTips();
					mergeCell();
				}
			});
			//添加模板
			$("#addBtn").click(function(){
				openwindow("/logisticsTemplate/addTemplateFace","添加模板",1000,1500,false,callback);
			})
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
			//监听操作
			table.on('tool(tableTemp)', function(obj){
				var data = obj.data; //获得当前行数据
				var Id = data.Id;
				var tempId = data.templateId;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'setUp'){ //运费编辑地址
					addressSetUp(Id,2);
			  	}else if(layEvent === 'deletes'){ //运费删除
			  		delTemp(Id,1);
			  	}else if(layEvent === 'tempSetUp'){ //模板编辑新增地址
			  		addressSetUp(tempId,3);
			  	}else{ //模板删除
			  		delTemp(tempId,2);
			  	}
			});
			
			//删除
			function delTemp(Id,type){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/logisticsTemplate/delInfo",
						data : {"Id" : Id,"type":type},
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
			
			//地区选择页面
			function addressSetUp(msgId,type){
				openwindow("/logisticsTemplate/addressSetUp?msgId="+msgId+"&type="+type,"选择区域",800,750,false,callback);
			}
			
			
			//监听单元格可编辑
			table.on('edit(tableTemp)', function(obj){
			    var value = obj.value, //得到修改后的值
			    data = obj.data, //得到所在行所有键值
			    msgId = data.Id; //item的Id
			    field = obj.field; //得到字段
			    //tipinfo('[ID: '+ data.Id +'] ' + field + ' 字段更改为：'+ value);
			    updPrice(msgId,value,field);
			});
			
			//修改费用
			function updPrice(msgId,newValue,fieldName){
				var priceType = 0;
				if(fieldName=="firstGoods"){
					priceType=1;
				}else if(fieldName=="firstFreight"){
					priceType=2;
				}else if(fieldName=="secondGoods"){
					priceType=3;
				}else{
					priceType=4;
				}
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/logisticsTemplate/updPrice",
					data : {"msgId" : msgId,"newValue":newValue,"priceType":priceType},
					success : function(data) {
						tableIns.reload({
			 				where: { //设定异步数据接口的额外参数，任意设
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
						tipinfo(data.msg);
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			
			}
			
		})
		
		//合并单元格
		function mergeCell(){
			var lastId = '';
			var templateTD = $(".layui-table-main .layui-table tr").each(function(){//.layui-table tr td[data-field='orderno']
				var rowspanNum = $(this).find("a[lay-event='deletes']").data("rowspannum");//需合并单元格数量
				var templateId = $(this).find("a[lay-event='setUp']").data("templateids");//模板id
				//var trNo = $(this).attr("data-index");//行号
				if(rowspanNum>1){
					$(this).find("td[data-field='templateName']").attr("rowspan",rowspanNum);//订单编号列合并单元格
					$(this).find("td[data-field='7']").attr("rowspan",rowspanNum);//订单编号列合并单元格
					if(lastId!='' && lastId==templateId){
						$(this).find("td[data-field='templateName']").remove();
						$(this).find("td[data-field='7']").remove();
					}
					
				}
				lastId = templateId;
			});
		}
	</script>
</m:Content>
</m:ContentPage>
