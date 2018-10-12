<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">

</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	
	<div class="layui-tab layui-tab-brief" lay-filter="docDemoTabBrief">
		<ul class="layui-tab-title">
			<li class="layui-this">历史订单</li>
			<li>收件地址</li>
		</ul>
		<div class="layui-tab-content" style="height: 100px;">
			<div class="layui-tab-item layui-show">
				<div class="layui-form">
					<table class="layui-table" lay-skin="line" id="consumer" lay-filter="tableContent"></table>
				</div>
			</div>
			<div class="layui-tab-item">
				<div class="layui-form">
					<table class="layui-table" id="address"></table>
				</div>
			</div>
		</div>
	</div> 
	<script type="text/html" id="productnameTmp">
		{{# if(d.subType == 5){ }}
			{{ d.productname }}<lable style="color:red">(增品)</lable>
		{{# }else{ }}
			{{ d.productname }}
		{{# } }}
		<a class="layui-btn layui-hide" lay-event="rowspan" data-rowspannum="{{d.rowspan}}">合并行数</a>
		<a class="layui-btn layui-hide" lay-event="templateids" data-templateids="{{d.orderId}}">ID</a>
	</script>
	<script type="text/html" id="buypriceRideCount">
		{{ d.buyprice * d.count }}
	</script>
	<script type="text/html" id="addressTmp">
		{{ d.province==null?'':d.province }} {{ d.city==null?'':d.city }}  {{ d.county==null?'':d.county }}
	</script>
	<script type="text/html" id="phoneTem">
		{{ (d.phone == '' || d.phone == null)?'-':d.phone }}
	</script>
	<script type="text/html" id="orderPrice">
		{{ d.orderPrice }}
	</script>
	<style type="text/html" id="paystatusTem">
		{{# if(d.paystatus==1){ }}
			<lable style="color:green;">已支付</lable>
		{{# }else if(d.paystatus==0){ }}
			<lable style="color:red">未支付</lable>
		{{# } }}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		var userId = 0;
		var yhType = 0;
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate', 'element'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			var element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
			var lodingIndex = layer.load(1);
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
			//绑定表格
			var tableIns = table.render({
				id: 'consumer',
				elem: '#consumer',
				url: '/${applicationScope.adminprefix }/consumer/selUserOrderList?userId=${userId}&openId=${openId}', //数据接口
				where: {},
				page: true, //开启分页
				limits: [5, 10, 50, 100, 200 , 500],
				cols: [
					[ //表头
						{
							field: 'orderId',
							title: '订单ID',
							align: 'center',
							width: '8%',
							fixed: 'left'
						}, 
						{
							field: 'orderno',
							title: '订单标号',
							width:'16%',
							align:'center',
							fixed: 'left'
						},
						{
							field: 'orderPrice',
							title: '订单总价(元)',
							align:'center',
							width:'10%',
							tempelt:'#orderPriceTem'
						},
						{
							field: 'buyprice',
							title: '单价(元)',
							width:'10%',
							align:'center'
						},
						{
							field: 'count',
							title: '数量',
							width:'8%',
							align:'center'
						},
						{
							title: '总价(元)',
							width:'10%',
							templet:'#buypriceRideCount'
						},
						{
							field: 'postage',
							title: '邮费(元)',
							width:'8%',
							align:'center'
						},
						{
							field: 'paystatus',
							title: '支付状态',
							width:'8%',
							templet:'#paystatusTem',
							fixed: 'right'
						},
						{
							field: 'productname',
							title: '商品名称',
							width:'30%',
							templet:'#productnameTmp',
							fixed: 'right'
						}
					]
				],
				done: function(){
					layer.close(lodingIndex);
					mergeCell();
				}
			});
			
			//历史收货地址  selUserAddressList
			var tableIns2 = table.render({
				id: 'address',
				elem: '#address',
				url: '/${applicationScope.adminprefix }/consumer/selUserAddressList?userId=${userId}&openId=${openId}', //数据接口
				where: {},
				page: true, //开启分页
				limits: [5, 10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							field: 'receiver',
							title: '收货人',
							align:'center'
						}, 
						{
							field: 'phone',
							title: '联系电话',
							align:'center',
							templet: '#phoneTem'
						}, 
						{
							title: '收货地址',
							templet:'#addressTmp',
							align:'center'
						},
						{
							field:'detailedAddress',
							title: '详细地址',
						}
					]
				],
				done: function(){
					layer.close(lodingIndex);
				}
			});
			
		});
		function mergeCell(){
			var lastId = '';
			var templateTD = $(".layui-table-main .layui-table tr").each(function(){//.layui-table tr td[data-field='orderno']
				var rowspanNum = $(this).find("a[lay-event='rowspan']").data("rowspannum");//需合并单元格数量
				var templateId = $(this).find("a[lay-event='templateids']").data("templateids");//模板id
				//var trNo = $(this).attr("data-index");//行号
				if(rowspanNum>1){
					$(this).find("td[data-field='orderId']").attr("rowspan",rowspanNum);//订单编号列合并单元格
					$(this).find("td[data-field='orderno']").attr("rowspan",rowspanNum);//订单编号列合并单元格
					$(this).find("td[data-field='orderPrice']").attr("rowspan",rowspanNum);
					$(this).find("td[data-field='paystatus']").attr("rowspan",rowspanNum)
					if(lastId!='' && lastId==templateId){
						$(this).find("td[data-field='orderId']").remove();
						$(this).find("td[data-field='orderno']").remove();
						$(this).find("td[data-field='orderPrice']").remove();
						$(this).find("td[data-field='paystatus']").remove();
					}
					
				}
				lastId = templateId;
			});
		}
	</script>
</m:Content>
</m:ContentPage>
