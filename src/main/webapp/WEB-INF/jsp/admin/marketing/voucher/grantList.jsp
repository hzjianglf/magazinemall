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
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">用户：</label>
					<div class="layui-input-inline">
						<input type="text" name="userName" id="userName" placeholder="请填写用户名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">积分：</label>
					<div class="layui-input-inline">
						<input type="text" name="minJF" id="minJF" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">-</label>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline">
						<input type="text" name="maxJF" id="maxJF" autocomplete="off" class="layui-input">
					</div>
				</div>
				
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" style="background-color: #FF6633" id="reset"><i class="layui-icon">&#xe620;</i>重置</button>
					</div>
				</div>
				<div class="layui-inline" id="layerDemo" style="margin-left: -5%;">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="batchGrant"><i class="layui-icon"></i>批量发放</button>
					</div>
				</div>
				
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
		
		<!-- 隐藏域 代金券id-->
		<input type="hidden" name="voucherId" id="voucherId" value="${voucherId}">
	</div>
	<script type="text/html" id="receiveder">
  		<div>{{d.receivername}}/{{d.receiverphone}}</div>
	</script>
	<script type="text/html" id="address">
		<div>{{d.receiverProvince}}-{{d.receiverCity}}-{{d.receiverCounty}}-{{d.receiverAddress}}</div>
	</script>
	<script type="text/html" id="kuaidi">
  		<div>{{d.name}}-{{d.expressNum}}</div>
	</script>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="grant">发放</a>
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
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/voucher/userinfoList?voucherId='+$("#voucherId").val(), //数据接口
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
							field: 'realname',
							title: '会员',
						},
						{
							field: 'accountJF',
							title: '积分',
						},
						{
							fixed: 'right',
							title: '操作',
							width:'15%',
							align: 'center',
							toolbar: '#barDemo',
							rowType:"operation",
						}
					]
				],
				done: function(res, curr, count){
					
				}
			});
			
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
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'grant'){ //发放优惠券
					grantCoupon(data.userId,1);
			  	}
			})
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						userName:$('#userName').val(),
						minJF:$('#minJF').val(),
						maxJF:$('#maxJF').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			$('#reset').click(function(){//重置
				$('#userName').val(''),
				$('#minJF').val(''),
				$('#maxJF').val(''),
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						couponName:"",
						state:"",
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			//批量操作
			$("#batchGrant").click(function(){
				var couponCount = ${voucherCount};
				var checkStatus = table.checkStatus('buyerList');
				var checkLength = checkStatus.data.length;
				if(checkLength == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				if(checkLength > couponCount){
					layer.msg('发放数量超过代金券剩余数量！', {icon: 7});
					return false;
				}
				var userIds = '';
				$.each(checkStatus.data, function(i){
					userIds = userIds + checkStatus.data[i].userId + ',';
				})
				grantCoupon(userIds,checkLength);	
					
			})
			//发放优惠券
			function grantCoupon(userId,grantCount){//用户id，发放数量
				layer.confirm('确定发放代金券吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/voucher/grantVoucher",
						data : {"userIds":userId,"grantCount":grantCount,"voucherId":$("#voucherId").val()},
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
