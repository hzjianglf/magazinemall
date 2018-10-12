<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<link rel="stylesheet"
			href="/manage/public/css/layui_public/layui_dyx.css" />
		<style type="text/css">
body {
	height: 100%;
}

.layui-form-mid {
	margin-left: 10px;
}
.layui-color-green{
	color:green;
}
.layui-color-red{
	color:red;
}
</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<!-- 内容主题区域 -->
		<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
			<blockquote class="layui-elem-quote layui-bg-blue"></blockquote>
			<div class="yw_cx">
				<div class="layui-form-item">
					<div class="layui-inline">

						<div class="layui-input-inline">
							<input type="text" name="teacherName" id="teacherName"
								placeholder="会员名称" autocomplete="off" class="layui-input">
						</div>
					</div>
				<div class="layui-inline">
					<label class="layui-form-label">创建时间：</label>
					<div class="layui-input-inline">
						<input type="text" name="dateStart" id="dateStart" autocomplete="off" class="layui-input" placeholder="yyyy-MM-dd">
					</div>
				</div>
					<div class="layui-inline">
						<label class="layui-form-label"></label>
						<div class="layui-input-inline">
							<select class="layui-input" name="status" id="status">
								<option value="">支付状态</option>
								<option value="0" ${type=='1'?'selected':'' }>未支付</option>
								<option value="1" ${type=='2'?'selected':'' }>已支付</option>
							</select>
						</div>
						<div class="layui-inline" id="layerDemo">
							<div class="layui-input-inline">
								<button class="layui-btn layui-btn-normal" id="search">
									<i class="layui-icon">&#xe615;</i>搜索
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList"
				lay-filter="tableContent"></table>
			
		</div>

		</div>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="selectIDs">查看</a>
	</script>
	<script type="text/html" id="statusType">
		{{# if(d.status >0) { }}
			<lable class="layui-color-green">已支付</lable>
		{{# }else { }}
			<lable class="layui-color-red">未支付</lable>
		{{# } }}
	</script>
	</m:Content>


	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script type="text/javascript">
			//JavaScript代码区域
			layui.use(
							[ 'laypage', 'layer', 'table', 'form', 'laydate' ],
							function() {
								var table = layui.table;
								var laypage = layui.laypage;
								var layer = layui.layer;
								var form = layui.form;
								var laydate = layui.laydate;

								laydate.render({
									elem : '#dateStart',
								/* range: true  区间时间选择*/
								});
								laydate.render({
									elem : '#endTime',
								});
								//绑定文章表格
								var tableIns = table
										.render({
											id : 'buyerList',
											elem : '#buyerList',
											url : '/${applicationScope.adminprefix }/finance/Recharge/rechargeListData', //数据接口
											cellMinWidth : 100,
											page : true, //开启分页
											limits : [ 10, 20, 30, 40, 50 ],
											cols : [ [
											//表头
											{
												type : 'checkbox',
												width : "3%",
											}, {
												field : 'orderno',
												title : '充值单号',
											}, {
												field : 'realName',
												title : '会员名称',
											}, {
												field : 'time',
												title : '创建时间',
											}, {
												field : 'payTime',
												title : '付款时间',

											}, {
												field : 'payMethodName',
												title : '支付方式',

											}, {
												field : 'price',
												title : '充值金额 (元)',
											}, {
												toolbar : '#statusType',
												title : '支付状态',
											}, {
												field : 'right',
												title : '操作',
												align: 'center',
												toolbar: '#barDemo',

											},

											] ],
											done : function(res, curr, count) {

											}
										});

								//监听锁定操作
								form.on('checkbox(freezeFilter)',
										function(obj) {
											var id = obj.value;
											if (obj.elem.checked) {
												unlockOrLock(id, 1);
											} else {
												unlockOrLock(id, 0);
											}
										});

								//监听锁定操作
								form.on('checkbox(approveFilter)',
										function(obj) {
											var id = obj.value;
											if (obj.elem.checked) {
												unapproveOraprove(id, 1);
											} else {
												unapproveOraprove(id, 0);
											}
										});
								table.on('tool(tableContent)', function(obj) {
									var data = obj.data; //获得当前行数据
									var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
									var tr = obj.tr; //获得当前行 tr 的DOM对象

									if(layEvent === 'selectIDs'){ //详细信息
								      	/* layer.msg('ID:'+data.paylogid); */
								      	openwindow('finance/Recharge/purchaseDataUp?paylogid='+data.id,"充值详情",340,440,false,null);
								  	}
								})

								$('#search').click(function() { //搜索，重置表格
									tableIns.reload({
										where : { //设定异步数据接口的额外参数，任意设
											teacherName : $('#teacherName').val(),
											dateStart : $('#dateStart').val(),
											status : $('#status').val()
											
										},
										page : {
											curr : 1
										//重新从第 1 页开始
										}
									});
								})
								$('#reset').click(
										function() {//重置
											$('#teacherName').val(""), $(
													'#className').val(""), $(
													'#status').val(""), $(
													"#isNo").attr("checked",
													false);
											tableIns.reload({
												where : { //设定异步数据接口的额外参数，任意设
													teacherName : "",
													className : "",
													status : "",
												},
												page : {
													curr : 1
												//重新从第 1 页开始
												}
											});
										})
							});
		</script>


	</m:Content>
</m:ContentPage>