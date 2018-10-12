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
		<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		
			<blockquote class="layui-elem-quote layui-bg-blue">
				购买记录列表
			</blockquote>
			
			<div class="yw_cx">
			<div class="layui-form-item">
			
				<div class="layui-inline">
					<div class="layui-input-inline">
						<input type="text" name="orderNumber" id="orderNumber" placeholder="订单编号" autocomplete="off" class="layui-input">
					</div>
				</div>
				
				<div class="layui-inline">
					<div class="layui-input-inline">
						<input type="text" name="buyer" id="buyer" placeholder="买家" autocomplete="off" class="layui-input">
					</div>
				</div>
				
				<div class="layui-inline">
					<label class="layui-form-label">下单时间：</label>
					<div class="layui-input-inline">
						<input type="text" name="dateStart" id="dateStart" autocomplete="off" class="layui-input" placeholder="yyyy-MM-dd">
					</div>
					<label class="layui-form-label">-</label>
					<div class="layui-input-inline">
						<input type="text" name="dateEnd" id="dateEnd" autocomplete="off" class="layui-input" placeholder="yyyy-MM-dd">
					</div>
				</div>
				
				<div class="layui-inline">
					<div class="layui-input-inline">
						<select class="layui-input" name="status" id="status" lay-verify="required">
							<option value="">全部</option>
							<option value="余额支付" >余额支付</option>
							<option value="微信" >微信</option>
							<option value="支付宝" >支付宝</option>
						</select>
					</div>
				</div>
				
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" type="button" id="daochu">导出EXCEL</button>
					</div>
				</div>
					
			</div>
			
			<table id="demo" lay-filter="tableContent"></table>
			
		</div>
			
		</div>
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="selectID">查看</a>
	</script>
	</m:Content>
	
	<m:Content contentPlaceHolderId="js">
		
		<script type="text/javascript">
			  layui.use(['table','laydate'], function(){
				  var table = layui.table;
				  var laydate = layui.laydate;
				  laydate.render({
				    elem: '#dateStart'
				  });
				  laydate.render({
				    elem: '#dateEnd'
				 });
				  //第一个实例
				var tableIns = table.render({
				    elem: '#demo'
				    ,url: '/${applicationScope.adminprefix }/finance/transaction/purchaseListData' //数据接口
				    ,page: true //开启分页
				    ,cols: [[ //表头
				              {		
				            	    field: 'left',
									type: 'checkbox',
									width: "5%",
								},
				      		  {
									field: 'orderNo', 
									title: '订单编号', 
							  },
							  {
								    field: 'userName', 
									title: '买家', 
							  },
							  {
								    field: 'payTime', 
									title: '下单时间', 
							  },
							  {
								    field: 'price', 
									title: '订单金额（元）', 
							  },
							  {
								    field: 'payMethodName', 
									title: '支付方式', 
							  },
							  {
								    fixed: 'right',
									title: '操作',
									align: 'center',
									toolbar: '#barDemo',
							  }
						]]
					});
				
				table.on('tool(tableContent)', function(obj){
					var data = obj.data; //获得当前行数据
					var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
					var tr = obj.tr; //获得当前行 tr 的DOM对象
					
					if(layEvent === 'selectID'){ //详细信息
				      	/* layer.msg('ID:'+data.paylogid); */
				      	openwindow('finance/transaction/purchaseDataUp?paylogid='+data.paylogid+'&source='+data.source,"",1400,1200,false,null);
				  	}
				});
				
				  $('#search').click(function() { //搜索，重置表格
					  tableIns.reload({
							where: { //设定异步数据接口的额外参数，任意设
								orderNumber:$('#orderNumber').val(),
								buyer:$('#buyer').val(),
								dateStart:$('#dateStart').val(),
								dateEnd:$('#dateEnd').val(),
								status:$('#status').val()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
					});
				 });
				 $('#daochu').click(function(){
						location.href="/${applicationScope.adminprefix }/finance/transaction/downPurchaseData?";
					});
			});
			 
		</script>
		
	</m:Content>
	
</m:ContentPage>
