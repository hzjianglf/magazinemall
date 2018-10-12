<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-form-mid {
			margin-left: 10px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			商城订单
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">订单状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="type" id="type">
							<option value="">请选择</option>
								<option value="1" ${type=='1'?'selected':'' }>待付款</option>
								<option value="5" ${type=='5'?'selected':'' }>交易完成</option>
								<option value="6" ${type=='6'?'selected':'' }>已取消</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">订单编号：</label>
					<div class="layui-input-inline">
						<input type="text" name="orderNum" id="orderNum" placeholder="请填写订单编号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">商品名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="goodsName" id="goodsName" placeholder="请填商品名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
						<label class="layui-form-label">下单时间：</label>
						<div class="layui-input-inline">
							<input type="text" name="startTime" id="startTime" lay-verify="date" autocomplete="off" class="layui-input">
						</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">-</label>
				</div>
				<div class="layui-inline">
					<input type="text" name="datetime2" id="endTime" lay-verify="endTime" autocomplete="off" class="layui-input">
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="invoice"><i class="layui-icon">&#xe60a;</i>发货单列表</button>
					</div>
				</div>
			</div>
		</div>
		<input type="hidden" name="listType" id="listType" value="${listType}">
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="total">
  		<span style="color: blue;">{{d.sales}} |</span> {{d.stock}}
	</script>
	<!-- orderstatus订单状态（1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中）  -->
	<!-- paystatus支付状态 0未支付 1已支付  -->
	<!-- deliverstatus 发货状态 0未发货 1已发货 2部分发货 -->
	<script type="text/html" id="orderStatus">
		{{# if(d.status==1){ }}
			待付款
		{{# }else if(d.status==2){ }}
			待发货
		{{# }else if(d.status==3){ }}
			{{# if(d.deliverstatus==1){ }}
				已发货
			{{# }else if(d.deliverstatus==2){ }}
				部分发货
			{{# } }}
		{{# }else if(d.status==4){ }}
			已收货，待评价
		{{# }else if(d.status==5){ }}
			交易完成
		{{# }else if(d.status==6){ }}
			订单已取消
		{{# }else if(d.status==7){ }}
			退款中
		{{# } }}

	</script>
	<script type="text/html" id="checkApprove">
  		<input type="checkbox" value="{{d.id}}" title="上架" lay-filter="approveFilter" {{ d.state == 1 ? 'checked' : '' }}/>
	</script>
	<script type="text/html" id="barDemo">
		{{# if(d.status==2 && d.deliverstatus!=1 && d.paystatus==1 && d.orderItemDeliverstatus==0){ }}
			<a class="layui-btn layui-btn-xs" lay-event="Issue">发货</a>
		{{# } }}
		<a class="layui-btn layui-btn-danger layui-btn-xs" data-rowspanNum="{{d.rowspanNum}}" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="userName">
		{{# if(d.nickName!=null){ }}
			{{ d.nickName }}
		{{# }else{ }}
			{{ d.telenumber }}
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		var perId='${perId}';
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			laydate.render({
				elem: '#startTime',
				/* range: true  区间时间选择*/
			});
			laydate.render({
				elem: '#endTime',
			});
			var perId='${perId}';
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/order/orderListData?listType='+$("#listType").val(), //数据接口
				cellMinWidth: 100,
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[	
						//表头
						{
							type: 'checkbox',
							width: "5%",
						},
						{
							field: 'productname',
							title: '商品名称',
						}, 
						{
							field: 'buyprice',
							title: '单价',
						},
						{
							field: 'buycount',
							title: '数量',
							/* templet: '#total', */
							unresize: true
						},
						{
							field: 'orderno',
							title: '订单编号',
							sort:true,
						},
						{
							field: 'buyTime',
							title: '下单时间',
						}, 
						{
							//field: 'userName',
							title: '买家',
							templet: '#userName',
						},
						{
							field: 'totalPrice',
							title: '总价',
						},
						{
							field: 'status',
							title: '状态',
							templet:'#orderStatus',
						},
						{
							fixed: 'right',
							title: '操作',
							align: 'center',
							toolbar: '#barDemo',
							rowType:"operation",
						}
					]
				],
				done: function(res, curr, count){
					mergeCell();
				 }
			});
			
			//排序-升序
			$(".layui-table-sort-asc").click(function(){
				sortFunction('1');
			})
			//降序
			$(".layui-table-sort-desc").click(function(){
				sortFunction('2');
			})
			function sortFunction(sortType){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						sortType:sortType,
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			
			//发货单列表
			$("#invoice").click(function(){
				window.location.href = "/${applicationScope.adminprefix }/order/invoiceListFace?invoiceType=1";
			})
			
			//监听锁定操作
			form.on('checkbox(freezeFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unlockOrLock(id, 1);
				}else{
					unlockOrLock(id, 0);
				}
			});
			
			//监听锁定操作
			form.on('checkbox(approveFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unapproveOraprove(id, 1);
				}else{
					unapproveOraprove(id, 0);
				}
			});
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						orderStatus:$('#type').val(),
						orderNum:$('#orderNum').val(),
						goodsName:$('#goodsName').val(),
						startTime:$('#startTime').val(),
						endTime:$('#endTime').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'del'){ //删除
			      	delOrderInfo(data.id);
			  	} else if(layEvent === 'edit'){ //编辑
			  		layer.open({
						type: 2,
						title: ['编辑图书期刊', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', '100%'],
						content: '/${applicationScope.adminprefix }/book/add?id=' + data.id,
						success: function(layero, index) {
							console.log(layero, index);
							//layer.iframeAuto(index);
							layer.full(index);
						},
						end: function() { //销毁后触发
							tableIns.reload({
								height: 315
								,page: {
									curr: 1
								}
							});
						}
					});
			  	}else if(layEvent ==='Issue'){//发货
			  		deliverGoods(data.id,data.orderno);
			  	}
			})
			
			$('#btn_div .layui-btn').click(function(){
				var checkStatus = table.checkStatus('buyerList');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var userIds = '';
				$.each(checkStatus.data, function(i){
					userIds = userIds + checkStatus.data[i].id + ',';
				})
				if($(this).hasClass('unlock')){//增刊
					unlockOrLock(userIds, 1);
				}
				if($(this).hasClass('unapprove')){//取消合刊
					unapproveOraprove(userIds, 0);
				}
				if($(this).hasClass('approve')){//合刊
					unapproveOraprove(userIds, 1);
				}
				
			})
			
			
			// 删除
			function delOrderInfo(orderId){
				layer.confirm('确定删除当前订单吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/order/delOrderInfo",
						data : {"orderId" : orderId},
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
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
						},
						error : function(data) {
							layer.alert(data.msg,{icon: 2});
						}
					});
				})
			}
			//修改发货状态	
			function deliverGoods(orderId,orderno){
				openwindow("/order/deliverGoodsFace?orderId="+orderId,"发货商品",1200,700,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			
			function close(){
				layer.close;
			}
			
		});
		
		
		function mergeCell(){
			var lastOrderNo = '';
			var orderNoTD = $(".layui-table-main .layui-table tr").each(function(){//.layui-table tr td[data-field='orderno']
				var rowspanNum = $(this).find("a[lay-event='del']").data("rowspannum");//需合并单元格数量
				var orderNo =  $(this).find("td[data-field='orderno'] div").html();//订单编号
				//var trNo = $(this).attr("data-index");//行号
				if(rowspanNum>1){
					$(this).find("td[data-field='orderno']").attr("rowspan",rowspanNum);//订单编号列合并单元格
					$(this).find("td[data-field='userName']").attr("rowspan",rowspanNum);//买家列合并
					$(this).find("td[data-field='buyTime']").attr("rowspan",rowspanNum);//下单时间
					$(this).find("td[data-field='totalPrice']").attr("rowspan",rowspanNum);//总价
					$(this).find("td[data-field='status']").attr("rowspan",rowspanNum);//状态
					$(this).find("td[data-field='9']").attr("rowspan",rowspanNum);//操作栏
					if(lastOrderNo!='' && lastOrderNo==orderNo){
						$(this).find("td[data-field='orderno']").remove();
						$(this).find("td[data-field='userName']").remove();
						$(this).find("td[data-field='buyTime']").remove();
						$(this).find("td[data-field='totalPrice']").remove();
						$(this).find("td[data-field='status']").remove();
						$(this).find("td[data-field='9']").remove();
					}
					
				}
				lastOrderNo = orderNo;
			});
		}
		
	</script>
</m:Content>
</m:ContentPage>
