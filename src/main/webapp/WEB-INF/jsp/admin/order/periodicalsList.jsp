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
			期刊订单
		</blockquote>
		<div class="yw_cx">
		<form class="layui-form" id="form">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">订单状态：</label>
					<div class="layui-input-inline">
					<!-- 1，新订单，待支付；2，已支付，待发货；3，已发货，待收货；4，已收货，待评价；5，已完成；6，已取消；7，退款中 -->
						<select class="layui-input" name="type" id="type">
							<option value="">请选择</option>
								<option value="1" ${type=='1'?'selected':'' }>待付款</option>
								<option value="2" ${type=='2'?'selected':'' }>待发货</option>
								<option value="8" ${type=='8'?'selected':'' }>部分发货</option>
								<option value="3" ${type=='3'?'selected':'' }>待收货</option>
								<%-- <option value="4" ${type=='4'?'selected':'' }>已收货,待评价</option> --%>
								<option value="5" ${type=='5'?'selected':'' }>交易完成</option>
								<option value="6" ${type=='6'?'selected':'' }>已取消</option>
								<option value="7" ${type=='7'?'selected':'' }>退款中</option>
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
					<label class="layui-form-label">刊物：</label>
					<div class="layui-input-inline">
						<select  lay-filter="periodfi" name="period" id="period">
							<option value="">请选择</option>
								<c:forEach var="period" items="${periods }">
									<option value="${period.id }" >${period.name }</option>
								</c:forEach>
						</select>
					</div>
				</div>
			<!-- 	<div class="layui-inline">
					<label class="layui-form-label">期次：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="publish" id="publish" lay-filter="publish">
							<option value="">请选择</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">期刊名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="goodsName" id="goodsName" placeholder="请填写商品名称" autocomplete="off" class="layui-input">
					</div>
				</div> -->
				<div class="layui-inline">
					<label class="layui-form-label">收货人：</label>
					<div class="layui-input-inline">
						<input type="text" name="realname" id="realname" placeholder="请填写收货人姓名" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">下单时间：</label>
					<div class="layui-input-inline">
						 <input type="text" class="layui-input" id="buyTime" placeholder="yyyy-MM-dd">
					</div>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline">
						<input type="checkbox" name="needDelive" id="needDelive" style="width: 10%;margin-top: 8%;">
					</div>
					<label class="layui-form-label" style="margin-left: -135px;">仅展示需发货的订单记录</label>
				</div>
			</div>
			</form>
			</div>
			<div class="layui-form-item">
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
				<div class="layui-inline" id="layerDemo" style="margin-left: -2.5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="export"><i class="layui-icon">&#xe61e;</i>批量导出</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -2.5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="bathSend"><i class="layui-icon">&#xe61e;</i>批量发货</button>
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
	<script type="text/html" id="orderStatus">
		{{# if(d.status==1){ }}
			待付款
		{{# }else if(d.status==2){ }}
			{{# if(d.deliverstatus==0){ }}
				待发货
			{{# }else if(d.deliverstatus==1){ }}
				已发货
			{{# }else if(d.deliverstatus==2){ }}
				部分发货
			{{# } else { }}
				已收货
			{{# }}}
		{{# }else if(d.status==3){ }}
			已发货
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
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="lookDetails">详情</a>
		{{# if(d.waitDeliv>0 && d.producttypes==2){ }}
			<a class="layui-btn layui-btn-xs" lay-event="Issue">发货</a>
		{{# } }}
		
		<a class="layui-btn layui-btn-danger layui-btn-xs" data-rowspanNum="{{d.rowspanNum}}" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="goodsType">
		{{d.goorsType}}
		{{# if(d.subType==5){ }}
			(<font color="red">赠品</font>)
		{{# }}}
	</script>
	<script type="text/html" id="userName">
		{{# if(d.nickName!=null){ }}
			{{ d.nickName }}
		{{# }else{ }}
			{{ d.telenumber }}
		{{# } }}
	</script>
	<script type="text/html" id="myAddress">
		{{# if(d.receiverProvince!=null && d.receiverProvince!=''){ }}
			{{ d.receiverProvince }}-
		{{# } }}
		{{# if(d.receiverCity!=null && d.receiverCity!=''){ }}
			{{ d.receiverCity }}-
		{{# } }}
		{{# if(d.receiverCounty!=null && d.receiverCounty!=''){ }}
			{{ d.receiverCounty }}-
		{{# } }}
		{{# if(d.receiverAddress!=null && d.receiverAddress!=''){ }}
			{{ d.receiverAddress }}-
		{{# } }}
		{{# if(d.receiverphone!=null && d.receiverphone!=''){ }}
			{{ d.receiverphone }}
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
			//日期范围
			laydate.render({
				elem: '#buyTime'
				,range: true
			});
			
		/* 	laydate.render({
				elem: '#buyTime',
			}); */
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
							width: "5%"
						},
						{
							field: 'id',
							title: '订单ID',
							sort:true,
							width:'5%'
						},
						{
							field: 'orderno',
							title: '订单编号',
							sort:true,
							width:'10%'
						},
						{
							field: 'receivername',
							title: '收货人',
							/* templet: '#receiverName', */
							width:'6%'
						},
						{
							title: '收货地址',
							templet: '#myAddress'
						},
						{
							field: 'productname',
							title: '期刊名称',
							width: "8%",
						},
						{
							field: 'buyTime',
							title: '下单时间',
						},
						{
							field: 'goorsType',
							title: '媒体类型',
							templet:'#goodsType',
							width: "6%",
						}, 
						{
							field: 'buycount',
							title: '数量',
							width: "5%",
							/* templet: '#total', */
							unresize: true
						},
						{
							field: 'buyprice',
							title: '单价',
							width: "5%",
						},
						{
							field: 'totalPrice',
							title: '应付金额',
							width: "6%",
						},
						{
							//field: 'status',
							title: '状态',
							templet:'#orderStatus',
							width:'6%'
							
						},
						{
							fixed: 'right',
							title: '操作',
							align: 'center',
							toolbar: '#barDemo',
							rowType:"operation",
							width:'10%'
						}
					]
				],
				done: function(res, curr, count){
				 }
			});
		
			
			/* //监听锁定操作
			form.on('checkbox(freezeFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unlockOrLock(id, 1);
				}else{
					unlockOrLock(id, 0);
				}
			}); */

			form.on('select(periodfi)', function(data){
    			console.log(data.othis); //得到美化后的DOM对象
    			var val = data.value; //得到被选中的值
    			$.post( "selPublishByPeriod?id="+val, function( data ) {
    				var col =data.list;
    				var html = "<option value=''>请选择</option>";
    				if(col!=null){
	    				for(var i = 0 ; i < col.length ; i++){
	    					html+="<option value='"+col[i].id+"'>"+col[i].name+"</option>";
	    				}
    				}
    				$('#publish').html(html);
    				form.render();
    			});
    		});
		
			/* //监听锁定操作
			form.on('checkbox(approveFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unapproveOraprove(id, 1);
				}else{
					unapproveOraprove(id, 0);
				}
			});
			 */
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
			
			$('#search').click(function() { //搜索，重置表格
				var isChecked = $("#needDelive").is(":checked");
				var needDelive = 0;
				if(isChecked){
					needDelive = 1;
				} 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						orderStatus:$('#type').val(),
						orderNum:$('#orderNum').val(),
						goodsName:$('#goodsName').val(),
						userName:$("#realname").val(),
						publish:$("#publish").val(),
						period:$("#period").val(),
						buyTime:$('#buyTime').val(),
						needDelive:needDelive,
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			//批量导出
			$("#export").click(function(){
				var isChecked = $("#needDelive").is(":checked");
				var needDelive = 0;
				if(isChecked){
					needDelive = 1;
				}
				//选中的id checkbox
				var checkStatus = table.checkStatus('buyerList');
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].id + ',';
				})
				window.location.href = "/${applicationScope.adminprefix }/order/batchExport?"+
						"needDelive="+needDelive+"&orderStatus="+$('#type').val()+"&orderNum="+$('#orderNum').val()
						+"&goodsName="+$('#goodsName').val()+"&realname="+$("#realname").val()+
						"&ids="+ids+"&listType="+$("#listType").val()+"&period="+$("#period").val()+"&publish="+$("#publish").val();
			})
			//批量发货
			$("#bathSend").click(function(){
				openwindow('order/turnBathSend',"批量发货",900,580,false,null);
				/* layer.confirm('确定要批量发货吗？', {icon: 7}, function(){
					var isChecked = $("#needDelive").is(":checked");
					var needDelive = 0;
					if(isChecked){
						needDelive = 1;
					}
					//选中的id checkbox
					var checkStatus = table.checkStatus('buyerList');
					var ids = '';
					$.each(checkStatus.data, function(i){
						ids = ids + checkStatus.data[i].orderItemId + ',';
					})
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/order/bathSend",
						data : {
							"needDelive" : needDelive,
							"orderStatus" : $('#type').val(),
							"orderNum" : $('#orderNum').val(),
							"goodsName" : $('#goodsName').val(),
							"realname" : $("#realname").val(),
							"ids" : ids,
							"listType" : $("#listType").val(),
							"period" : $("#period").val(),
							"publish" : $("#publish").val(),
						},
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
							layer.alert("网络中断,稍后重试...",{icon: 2});
						}
					});
				}) */
				
				
				/* 
				window.location.href = "/${applicationScope.adminprefix }/order/bathSend?"+
						"needDelive="+needDelive+"&orderStatus="+$('#type').val()+"&orderNum="+$('#orderNum').val()
						+"&goodsName="+$('#goodsName').val()+"&realname="+$("#realname").val()+
						"&ids="+ids+"&listType="+$("#listType").val()+"&period="+$("#period").val()+"&publish="+$("#publish").val(); */
			});
			//发货单列表
			$("#invoice").click(function(){
				window.location.href = "/${applicationScope.adminprefix }/order/invoiceListFace?invoiceType=2";
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
			  		deliverQiKan(data.id,data.orderItemId,data.openId);
			  	}else if(layEvent ==='lookDetails'){//查看订单详情
			  		openwindow('order/selOrderDetails?orderId='+data.id,"",1400,1200,false,null);
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
			function deliverQiKan(orderId,orderItemId,openId){
				if(openId!=null){
					tipinfo("老数据暂不提供发货");
					return ;
				}
				openwindow("/order/deliverQiKanFece?orderItemId="+orderItemId,"发货商品",1400,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			
		});
	</script>
</m:Content>
</m:ContentPage>
