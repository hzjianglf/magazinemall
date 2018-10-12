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
			代金券
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">代金券名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="voucherName" id="voucherName" placeholder="请填写代金券名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="state" id="state">
							<option value="">请选择</option>
								<option value="0" ${type=='0'?'selected':'' }>启用</option>
								<option value="1" ${type=='1'?'selected':'' }>禁用</option>
						</select>
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
						<button class="layui-btn layui-btn-normal" id="addCoupon"><i class="layui-icon">&#xe654;</i>添加代金券</button>
					</div>
				</div>
				
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	<script type="text/html" id="effectiveDate">
			{{d.startDate}}/{{d.endDate}}	
	</script>
	<!-- <script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
		{{# if(d.state==0){ }}
			{{# if(d.surplusCount==0){ }}
				<a class="layui-btn layui-btn-xs"  lay-event="update">编辑</a>
				<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
				<a class="layui-btn layui-btn-xs"  lay-event="delete">删除</a>
			{{# }else{ }}
				{{# if(d.exceedTime!=0){ }}
						{{# if(d.exceedTime==1){ }}
							<a class="layui-btn layui-btn-xs" lay-event="update">编辑</a>
							<a class="layui-btn layui-btn-xs" lay-event="grant">发放</a>
							<a class="layui-btn layui-btn-xs" style="background-color: red;" lay-event="delete">删除</a>
						{{# }else if(d.exceedTime==2){ }}
							<a class="layui-btn layui-btn-xs" lay-event="update">编辑</a>
							<a class="layui-btn layui-btn-xs" lay-event="grant">发放</a>
							<a class="layui-btn layui-btn-xs" style="background-color: red;" lay-event="delete">删除</a>
						{{# }else{ }}
							<a class="layui-btn layui-btn-xs"  lay-event="update">编辑</a>
							<a class="layui-btn layui-btn-xs"  lay-event="grant">发放</a>
							<a class="layui-btn layui-btn-xs"  lay-event="delete">删除</a>
						{{# } }}
				{{# } }}	 			
			{{# } }}	 
		{{# }else{ }}
			<a class="layui-btn layui-btn-xs" lay-event="update">编辑</a>
			<a class="layui-btn layui-btn-xs" lay-event="grant">发放</a>
			<a class="layui-btn layui-btn-xs" style="background-color: red;" lay-event="delete">删除</a>
		{{# } }}
		
	</script> -->
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
		{{# if(d.state==0){ }}
			{{# if(d.surplusCount==0){ }}
				<a class="layui-btn layui-btn-xs"  lay-event="update">编辑</a>
				<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
				<a class="layui-btn layui-btn-xs"  lay-event="delete">删除</a>
			{{# }else{ }}
					<a class="layui-btn layui-btn-xs"  lay-event="update">编辑</a>
					{{# if(d.timeStart == 1){ }}
						<a class="layui-btn layui-btn-xs"  lay-event="grant">发放</a>
					{{# }else{ }}
						<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
					{{# } }}
					<a class="layui-btn layui-btn-xs"  lay-event="delete">删除</a>
			{{# } }}	 
		{{# }else{ }}
			<a class="layui-btn layui-btn-xs" lay-event="update">编辑</a>
			{{# if(new Date(d.endDate).getTime() > new Date().getTime()){ }}
				<a class="layui-btn layui-btn-xs"  lay-event="grant">发放</a>
			{{# }else{ }}
				<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
			{{# } }}
			<a class="layui-btn layui-btn-xs" style="background-color: red;" lay-event="delete">删除</a>
		{{# } }}
	</script>
	<!-- exceedTime:1未开始  2进行中 3已结束 -->
	<script type="text/html" id="stateName">
		{{# if(d.state==0){ }}
				<!-- <a class="layui-btn layui-btn-xs" lay-event="offState">启用</a> -->
				启用
		{{# }else{ }}
				<!-- <a class="layui-btn layui-btn-xs" lay-event="openState">禁用</a> -->
				禁用
		{{# } }}
	</script>
	<!-- 已发放列表 -->
	<script type="text/html" id="alreadyIssued">
		<a class="layui-btn layui-btn-xs" lay-event="yifa">{{d.alreadyIssued}}</a>
	</script>
	<!-- 已使用列表 -->
	<script type="text/html" id="alreadyUse">
		<a class="layui-btn layui-btn-xs" lay-event="yiyong">{{d.useCount}}</a>
	</script>
	<!-- 已使用列表 -->
	<script type="text/html" id="price">
	 {{d.price}}
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
				url: '/${applicationScope.adminprefix }/voucher/voucherList', //数据接口
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
							field: 'name',
							title: '代金券名称',
						},
						{
							field: '',
							width:'10%',
							title: '面值(元)',
							toolbar:"#price",
						},
						{
							
							width:'15%',
							toolbar:"#effectiveDate",	
							title: '有效期',
						},
						{
							field: 'totalCount',
							title: '总数量(张)',
						}, 
						{
							title: '已发放(张)',
							toolbar: '#alreadyIssued',
						},
						{
							field: 'surplusCount',
							title: '剩余(张)',
						},
						{
							title: '已使用(张)',
							toolbar:'#alreadyUse',
						},
						{
							//field: 'stateName',
							title: '状态',
							toolbar: '#stateName',
							
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
				
				if(layEvent === 'detail'){ //详情
			      	couponDetail(3,data.Id);
			  	} else if(layEvent === 'update'){ //编辑
			  		couponDetail(2,data.Id);
			  	}else if(layEvent === 'grant'){//发放代金券
			  		grantCoupon(data.Id);
			  	}else if(layEvent === 'delete'){ //删除
			  		delCouponInfo(data.Id);
			  	}else if(layEvent === 'yifa'){//已发列表
			  		grantDetail(0,data.Id);
			  	}else if(layEvent === 'yiyong'){//已用列表
			  		grantDetail(1,data.Id);
			  	}else if(layEvent === 'openState'){//启用
			  		changeState(0,data.Id);
			  	}else if(layEvent === 'offState'){//禁用
			  		changeState(1,data.Id);
			  	}
			})
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						voucherName:$('#voucherName').val(),
						state:$('#state').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			$('#reset').click(function(){//重置
				$('#voucherName').val('');
				$('#state').val('');
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						voucherName:"",
						state:"",
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			//添加代金券
			$("#addCoupon").click(function(){
				openwindow("/voucher/turnVoucher?type=1&voucherId=","添加代金券",1000,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			})
			//编辑代金券/详情
			function couponDetail(type,Id){
				openwindow("/voucher/turnVoucher?type="+type+"&voucherId="+Id,"查看代金券信息",1000,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			//发放代金券
			function grantCoupon(voucherId){
				openwindow("/voucher/grantVoucherFace?voucherId="+voucherId,"发放代金券",1200,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			//删除操作
			function delCouponInfo(voucherId){
				layer.confirm('确定删除该代金券吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/voucher/delVoucherById",
						data : {"voucherId" : voucherId},
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
			//已发代金券列表
			function grantDetail(type,voucherId){
				var msg = '已发代金券列表';
				if(type==1){
					msg = '已使用代金券列表';
				}
				openwindow("/voucher/alreadyGrant?type="+type+"&voucherId="+voucherId,msg,1000,600,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			//启用禁用
			function changeState(type,voucherId){
				var msg = '确定禁用该代金券吗？';
				if(type==0){
					msg='确定启用该代金券吗?';
				}
				layer.confirm(msg, {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/voucher/changeStateById",
						data : {"voucherId" : voucherId,"type":type},
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
