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
			优惠券
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">优惠券名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="couponName" id="couponName" placeholder="请填写优惠券名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="state" id="state">
							<option value="">请选择</option>
								<option value="0" ${type=='0'?'selected':'' }>未开始</option>
								<option value="1" ${type=='1'?'selected':'' }>进行中</option>
								<option value="2" ${type=='2'?'selected':'' }>已结束</option>
								<option value="3" ${type=='3'?'selected':'' }>已暂停</option>
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
						<button class="layui-btn layui-btn-normal" id="addCoupon"><i class="layui-icon">&#xe654;</i>添加优惠券</button>
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
  		{{# if(d.effectiveDate==0){ }}
			{{d.startDate}}/{{d.endDate}}	
		{{# }else{ }}
			{{d.effectiveDate}}
		{{# } }}
	</script>
	<script type="text/html" id="barDemo">
			<a class="layui-btn layui-btn-xs" lay-event="detail">详情</a>
		{{# if(d.state==0){ }}
			{{# if(d.surplusCount==0){ }}
				<a class="layui-btn layui-btn-xs"  lay-event="update">编辑</a>
				<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
				<a class="layui-btn layui-btn-xs"  lay-event="delete">删除</a>
			{{# }else{ }}
					<a class="layui-btn layui-btn-xs"  lay-event="update">编辑</a>
					{{# if(new Date(d.endDate).getTime() > new Date().getTime()) { }}
						<a class="layui-btn layui-btn-xs"  lay-event="grant">发放</a>
					{{# } else { }}
						<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
					{{# } }}
					<a class="layui-btn layui-btn-xs"  lay-event="delete">删除</a>
			{{# } }}	 
		{{# }else{ }}
			<a class="layui-btn layui-btn-xs" lay-event="update">编辑</a>
			{{# if(new Date(d.endDate).getTime() > new Date().getTime()) { }}
				<a class="layui-btn layui-btn-xs"  lay-event="grant">发放</a>
			{{# } else { }}
				<a class="layui-btn layui-btn-xs" style="background-color: #949494;" lay-event="">发放</a>
			{{# } }}
			<a class="layui-btn layui-btn-xs" style="background-color: red;" lay-event="delete">删除</a>
		{{# } }}
		
	</script>
	<!-- exceedTime:1未开始  2进行中 3已结束 -->
	<script type="text/html" id="stateName">
		{{# if(d.state==0){ }}
				{{# if(d.exceedTime!=0){ }}
						{{# if(d.exceedTime==1){ }}
							未开始
						{{# }else if(d.exceedTime==2){ }}
							进行中
						{{# }else{ }}
							已结束
						{{# } }}
				{{# } }}	 			
		{{# }else{ }}
			已暂停
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
		满 {{d.manprice}} 减 {{d.jianprice}} 
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
				url: '/${applicationScope.adminprefix }/coupon/couponListData', //数据接口
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
							title: '优惠券名称',
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
			  	}else if(layEvent === 'grant'){//发放优惠券
			  		grantCoupon(data.Id);
			  	}else if(layEvent === 'delete'){ //删除
			  		delCouponInfo(data.Id);
			  	}else if(layEvent === 'yifa'){//已发列表
			  		grantDetail(0,data.Id);
			  	}else if(layEvent === 'yiyong'){//已用列表
			  		grantDetail(1,data.Id);
			  	}
			})
			
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						couponName:$('#couponName').val(),
						state:$('#state').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			$('#reset').click(function(){//重置
				$('#couponName').val('');
				$('#state').val('');
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
			//添加优惠券
			$("#addCoupon").click(function(){
				openwindow("/coupon/addCouponFace?type=1&couponId=","添加优惠券",1000,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			})
			
			//编辑优惠券/详情
			function couponDetail(type,Id){
				openwindow("/coupon/addCouponFace?type="+type+"&couponId="+Id,"查看优惠券信息",1000,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			//发放优惠券
			function grantCoupon(couponId){
				openwindow("/coupon/grantCouponFace?couponId="+couponId,"发放优惠券",1200,800,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				});
			}
			//删除操作
			function delCouponInfo(couponId){
				layer.confirm('确定删除该优惠券吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/coupon/delCouponInfo",
						data : {"couponId" : couponId},
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
			//已发优惠券列表
			function grantDetail(type,couponId){
				var msg = '已发优惠券列表';
				if(type==1){
					msg = '已使用优惠券列表';
				}
				openwindow("/coupon/alreadyGrant?type="+type+"&couponId="+couponId,msg,1000,600,false,function(){
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
