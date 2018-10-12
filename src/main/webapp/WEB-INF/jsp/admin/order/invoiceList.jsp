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
			发货单
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">发货单号：</label>
					<div class="layui-input-inline">
						<input type="text" name="fahuoNum" id="fahuoNum" placeholder="请填写发货单号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">订单编号：</label>
					<div class="layui-input-inline">
						<input type="text" name="orderNum" id="orderNum" placeholder="请填写订单编号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">买家账号：</label>
					<div class="layui-input-inline">
						<input type="text" name="userName" id="userName" placeholder="请填写买家账号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">收货人：</label>
					<div class="layui-input-inline">
						<input type="text" name="receivedInfo" id="receivedInfo" placeholder="请填写买家账号/手机号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">商品名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="goodsName" id="goodsName" placeholder="请填商品名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">订单状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="type" id="type">
							<option value="">请选择</option>
								<option value="0" ${type=='0'?'selected':'' }>待签收</option>
								<option value="1" ${type=='1'?'selected':'' }>已签收</option>
								<option value="2" ${type=='2'?'selected':'' }>丢件</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline">
						<input type="checkbox" name="period"  value="17" title="管理版"  checked > 管理版
						<input type="checkbox" name="period"  value="18" title="渠道版"  > 渠道版
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">发货类型：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="invoicetypes" id="invoicetypes">
							<option value="">请选择</option>
								<option value="1" ${invoicetypes=='1'?'selected':'' }>非批量发货</option>
								<option value="2" ${invoicetypes=='2'?'selected':'' }>批量发货</option>
						</select>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
				<c:if test="${invoiceType==2}">
					<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
						<div class="layui-input-inline">
							<button class="layui-btn layui-btn-normal" id="import"><i class="layui-icon">&#xe60a;</i>批量导入</button>
						</div>
					</div>
				</c:if>
				<c:if test="${invoiceType==1}">
					<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
						<div class="layui-input-inline">
							<button class="layui-btn layui-btn-normal" id="export"><i class="layui-icon">&#xe61e;</i>批量导出</button>
						</div>
					</div>
				</c:if>
				<c:if test="${invoiceType==2}">
					<div class="layui-inline" id="layerDemo" style="margin-left: -3.3%;">
						<div class="layui-input-inline">
							<button class="layui-btn layui-btn-normal" id="export"><i class="layui-icon">&#xe61e;</i>批量导出</button>
						</div>
					</div>
				</c:if>
				<div class="layui-inline" id="layerDemo" style="margin-left: -3.3%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" style="background-color: #949494" id="returnBtn"><i class="layui-icon">&#xe633;</i>返回</button>
					</div>
				</div>
				
				
			</div>
			
		</div>
		<input type="hidden" name="invoiceType" id="invoiceType" value="${invoiceType}">
		<!-- excel批量导入 -->
		<form action="/${applicationScope.adminprefix }/order/batchImport" enctype="multipart/form-data" id="excelForm" method="post" style="display: none;">
			<input type="file" id="excelFile" name="excelFile" value="" onchange="submitExcel();">
		</form>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="receiveder">
  		<div>{{d.receivername}}/{{d.receiverphone}}</div>
	</script>
	<script type="text/html" id="address">
		<div>{{d.receiverProvince}}-{{d.receiverCity}}-{{d.receiverCounty}}-{{d.receiverAddress}}</div>
	</script>
	<script type="text/html" id="consignoraddress">
		<div>{{d.consignorProvince}}-{{d.consignorCity}}-{{d.consignorCounty}}-{{d.consignordetailedAddress}}</div>
	</script>
	<script type="text/html" id="kuaidi">
  		<div>{{d.name}}-{{d.expressNum}}</div>
	</script>
	<script type="text/html" id="goodsNameSubtype">
		{{# if(d.subType==2 || d.subType==3 || d.subType==4){ }}
			<div>{{d.goodsName}}--{{d.describes}}</div>
		{{# }else{ }}	
			<div>{{d.goodsName}}</div>
		{{# } }}
	</script>
	
	<script type="text/html" id="barDemo">
		{{# if(d.deliveryStatus==0 ){ }}
			<a class="layui-btn layui-btn-xs" lay-event="lose">标记为丢件</a>
		{{# }else{ }}	
			<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">标记为丢件</a>
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script src="/manage/public/js/jquery.form.min.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
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
			//绑定文章表格
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/order/invoiceList?invoiceType='+$("#invoiceType").val(), //数据接口
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
							field: 'liushuiNum',
							title: '发货流水号',
						},
						{
							field: 'orderno',
							title: '订单编号',
						},
						{
							field: 'userName',
							title: '买家',
						},
						{
							field: '',
							title: '快递单号',
							templet: '#kuaidi',
						},
						{
							field: 'goodsName',
							title: '商品名称',
							templet: '#goodsNameSubtype',
						},
						{
							field: 'count',
							title: '数量',
							width: "5%"
						},
						{
							field: 'receivername',
							title: '收件人姓名',
							//templet: '#receiveder',
							//unresize: true
						},
						
						{
							field: '',
							title: '收件人地址',
							templet: '#address',
						},
						{
							field: 'receiverphone',
							title: '收件人手机号',
						},
						{
							field: 'consignor',
							title: '发件人姓名',
						},
						/* {
							field: 'consignorPhone',
							title: '发件人手机号',
						}, */
						{
							field: 'consignordetailedAddress',
							title: '发件人地址',
							templet: '#consignoraddress',
						},
						{
							field: 'postage',
							title: '运费',
						},
						{
							field: 'statusName',
							title: '快递单状态',
							//templet:'#orderStatus',
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
					var invoiceType = "${invoiceType}";
					if(invoiceType==1){
						$("[data-field='goodsName']").css('display','none');
					}
					orderItemIdsVal(res.orderItemIds);
				 }
			});
			
			function orderItemIdsVal(orderItemIds){
				$("#orderItemIds").val(orderItemIds);
			}
			
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
				var period = [];
				$('input[name="period"]').each(function(){
					if($(this).is(":checked")){
						period.push($(this).val());
					}
				});
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						fahuoNum:$('#fahuoNum').val(),
						orderNum:$('#orderNum').val(),
						userName:$('#userName').val(),
						receivedInfo:$('#receivedInfo').val(), 
						goodsName:$('#goodsName').val(),
						orderStatus:$('#type').val(),
						invoicetypes:$("#invoicetypes").val(),
						period:period.join(",")
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			//批量导出
			$("#export").click(function(){
				window.location.href = "/${applicationScope.adminprefix }/order/batchExportInvoice?"+
					"invoiceType="+${invoiceType}+"&fahuoNum="+$('#fahuoNum').val()+"&orderNum="+$('#orderNum').val()
					+"&userName="+$('#userName').val()+"&receivedInfo="+$("#receivedInfo").val()+"&goodsName="+$("#goodsName").val()+
					"&orderStatus="+$("#orderStatus").val();
			})
			
			//批量导入事件
			$("#import").click(function(){
				$("#excelFile").click();
			})
			//提交excel文件
			$("#excelFile").change(function(){
				$("#excelForm").ajaxSubmit({
			      		success: function (data) {
			      			if(data.result){
								layer.msg(data.msg,{icon: 1});
							}else{
								layer.msg(data.msg,{icon: 2});
							}
			       	    }
			       	}) 
			})
			$("#returnBtn").click(function(){
				var invoiceType = "${invoiceType}";
				window.location.href = "/${applicationScope.adminprefix }/order/orderListFace?listType="+invoiceType;
			})
			
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'lose'){ //标记为丢件
			      	loseGoods(data.invoiceId);
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
			//标记为丢件
			function loseGoods(invoiceId){
				layer.confirm('确定标记为丢失吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/order/loseGoods",
						data : {"invoiceId" : invoiceId},
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
			
		});
		
	</script>
</m:Content>
</m:ContentPage>
