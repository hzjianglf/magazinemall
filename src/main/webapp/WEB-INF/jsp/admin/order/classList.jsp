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
			<c:if test="${listType==3}">
				点播课程订单
			</c:if>
			<c:if test="${listType==4}">
				直播课程订单
			</c:if>
		</blockquote>
		<div class="yw_cx">
		<form class="layui-form" id="form">
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
					<label class="layui-form-label">课程类别：</label>
					<div class="layui-input-inline">
						<select class="layui-input" lay-filter="classtype" name="classtype" id="classtype">
							<option value="">请选择</option>
								<c:forEach var="classtype" items="${classtype }">
									<option value="${classtype.id }">${classtype.name }</option>
								</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">课程名称：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="name" id="name">
							<option value="">请选择</option>
						</select>
					</div>
				</div>
				<!-- <div class="layui-inline">
					<label class="layui-form-label">商品名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="goodsName" id="goodsName" placeholder="请填商品名称" autocomplete="off" class="layui-input">
					</div>
				</div> -->
				<div class="layui-inline">
					<label class="layui-form-label">买家：</label>
					<div class="layui-input-inline">
						<input type="text" name="Tbx_userName" id="Tbx_userName" placeholder="请填写买家姓名" autocomplete="off" class="layui-input">
					</div>
				</div>
			</div>
			<div class="layui-form-item">
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
		</form>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<a class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</a>
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
	
	<script type="text/html" id="barDemo">
		<a class="layui-btn  layui-btn-xs" lay-event="see">详情</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	
	<!-- 状态 -->
	<script type="text/html" id="typeText">
		{{# if(d.status==1){ }}
			待付款
		{{# }else if(d.status==2){ }}
			交易完成
		{{# }else if(d.status==3){ }}
			交易完成
		{{# }else if(d.status==4){ }}
			已收货，待评价
		{{# }else if(d.status==5){ }}
			交易完成
		{{# }else if(d.status==6){ }}
			已取消
		{{# }else if(d.status==7){ }}
			退款中
		{{# } }}
	</script>
	
	<!-- 有效期 -->
	<script type="text/html" id="effective">
		{{#if(d.effectiveTime==0){ }}
			永久
		{{# }else{ }}
			{{d.effectiveTime}}
		{{# } }}
	</script>
	<script type="text/html" id="userName">
		{{# if(d.nickName!=null){ }}
			{{ d.nickName }}
		{{# }else{ }}
			{{ d.telenumber }}
		{{# } }}
	</script>
	<script type="text/html" id="className">
		{{ d.productname}}
		{{# if(d.subType==5){ }}
			(<font color="red">赠品</font>)
		{{# }}}
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
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "5%"
						},
						{
							field: 'id',
							title: '订单ID',
						},
						{
							field: 'orderno',
							title: '订单编号',
							sort:true,
						},
						{
							//field: 'nickName',
							title: '买家',
							templet: '#userName'
						},
						{
							field: 'productname',
							title: '商品名称',
							width: "25%",
							templet:'#className'
						}, 
						{
							field: 'buyprice',
							title: '单价',
							width: "5%",
						},
						{
							field: 'buycount',
							title: '数量',
							width: "5%",
						},
						{
							field: 'money',
							title: '金额',
							width: "5%",
						},
						{
							field: 'buyTime',
							title: '下单时间',
							width: "18%",
						},
						{
							field: 'status',
							title: '状态',
							templet:'#typeText'
						},
						{
							field: 'effectiveTime',
							title: '有效期',
							templet: '#effective',
							width: "5%",
							//unresize: true
						},
						{
							fixed: 'right',
							title: '操作',
							width: "9%",
							align: 'center',
							toolbar: '#barDemo'
						}
					]
				],
				done: function(res, curr, count){
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
			
			form.on('select(classtype)', function(data){
    			console.log(data.elem); //得到select原始DOM对象
    			//console.log(data.othis); //得到美化后的DOM对象
    			var val = data.value; //得到被选中的值
    			$.post( "selClassNameBytype?classtype="+val, function( data ) {
    				var col =data.list;
    				var html = "<option value=''>请选择</option>";
    				if(col!=null){
	    				for(var i = 0 ; i < col.length ; i++){
	    					html+="<option value='"+col[i].ondemandId+"'>"+col[i].name+"</option>";
	    				}
    				}
    				$('#name').html(html);
    				form.render();
    			});
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
			
			
			$('#search').click(function() { //搜索，重置表格
				var type = $('#classtype option:selected').val();
				var ondemandId = $('#name option:selected').val();
				console.log(type+ondemandId)
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						orderStatus:$('#type').val(),
						orderNum:$('#orderNum').val(),
						goodsName:$('#goodsName').val(),
						startTime:$('#startTime').val(),
						endTime:$('#endTime').val(),
						userName:$('#Tbx_userName').val(),
						type:type,
						ondemandId:ondemandId 
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			
		/* 	table.render({ //其它参数在此省略
			  initSort: {
			    field: 'orderno', //排序字段，对应 cols 设定的各字段名
			    type: 'desc' //排序方式  asc: 升序、desc: 降序、null: 默认排序
			  }
			}); */
			
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				
				if(layEvent === 'see'){ //查看
					//openwindow('order/getOrderDetailForClass?orderId='+data.id+'&r='+Math.random(),"订单详情",690,380,false,null);
					openwindow('order/selOrderDetails?orderId='+data.id,"",1400,1200,false,null);
			  	}
				if(layEvent === 'del'){ //删除
					delOrderInfo(data.id);
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
		});
		
	</script>
</m:Content>
</m:ContentPage>
