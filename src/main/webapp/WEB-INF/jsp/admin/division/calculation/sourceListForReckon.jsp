<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style>
			#width_input{
				width:100px;
			}
			.layui-btn{
				background-color: #009688 !important;
			}
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="yw_cx" style="margin-top:20px;overflow:hidden;">
			<div class="layui-form-item">
			 
				<div class="layui-inline">
					<label class="layui-form-label">支付时间：</label>
					<div class="layui-input-inline" id="width_input">
						<input type="text" name="dateStart" id="dateStart" autocomplete="off" class="layui-input" placeholder="yyyy-MM-dd">
					</div>
					<label style="width:5px;margin-right:8px;padding:10px 0px;float: left;display: block;text-align: content;">-</label>
					<div class="layui-input-inline" id="width_input">
						<input type="text" name="dateEnd" id="dateEnd" autocomplete="off" class="layui-input" placeholder="yyyy-MM-dd">
					</div>
				</div>
				
				<div class="layui-inline">
					<div class="layui-input-inline" id="width_input">
						<input type="text" name="key" id="key" placeholder="课程名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				
				<div class="layui-inline">
					<div class="layui-input-inline" id="width_input">
						<input type="text" name="userName" id="userName" placeholder="买家账号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline" id="width_input">
						<select class="layui-input" name="status" id="status" lay-verify="required">
							<option value="">全部</option>
							<option value="1" >有效</option>
							<option value="0" >无效</option>
						</select>
					</div>
				</div>
				
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline" id="width_input">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div>
		<div style="margin:0px 10px;widht:100px;heigth:20px;">
			<div class="layui-tab layui-tab-brief" lay-filter="tabType">
			  <ul class="layui-tab-title">
			    <li class="layui-this" lay-id="1">课程销售记录</li>
			    <li lay-id="2">问答记录</li>
			    <li lay-id="3">打赏记录</li>
			  </ul>
			  <div class="layui-tab-content">
			    <div class="layui-tab-item layui-show">
			    	<table id="demo" lay-filter="tableContent"></table>
			    </div>
			    <div class="layui-tab-item">
			    	<table id="table2" lay-filter="tableContent2"></table>
			    </div>
			    <div class="layui-tab-item">
			    	<table id="table3" lay-filter="tableContent3"></table>
			    </div>
			  </div>
			</div> 
		</div>
		<script type="text/html" id="statusTemp">
			{{# if(d.status==0){ }}
				<font color="red">无效</font>
			{{# }else{ }}
				<font color="green">有效</font>
			{{# } }}
		</script>
		<script type="text/html" id="questionTemp">
			{{ d.questionId }}  {{ d.content }}
		</script>
		<script type="text/html" id="rewardTemp">
			{{ d.rewardId }}  {{ d.remark }}
		</script>
		
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			  layui.use(['table','laydate','element'], function(){
				  var table = layui.table;
				  var table2 = layui.table;
				  var table3 = layui.table;
				  var laydate = layui.laydate;
				  var element = layui.element;
				  laydate.render({
				    elem: '#dateStart'
				  });
				  laydate.render({
				    elem: '#dateEnd'
				 });
				 element.tabChange('tabType',${sourceType});
				 var tableIndex=${sourceType};
				 element.on('tab(tabType)', function(){
					 tableIndex=this.getAttribute('lay-id');
				 });
				
				 $('#search').click(function() { //搜索，重置表格
					var whereObj={
						 dateStart:$('#dateStart').val(),
						 dateEnd:$('#dateEnd').val(),
						 key:$('#key').val(),
						 userName:$('#userName').val(),
						 status:$('#status').val(),
					};
					table.reload("table"+tableIndex,{
						where: whereObj,
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});	
				})
				//第一个实例
				var tableIns1 = table.render({
				    elem: '#demo'
				    ,id:"table1"
				    ,page: true //开启分页
					,limits: [10, 20, 30, 40, 50]
				    ,url: '/${applicationScope.adminprefix }/bill/ruestionListData?id='+${id}+'&sourceType=1' //数据接口
				    ,cols: [[ //表头
				      		  {
									field: 'orderNo', 
									title: '订单/支付记录',
									align: 'center'
							  },
							  {
								    field: 'userName', 
									title: '买家账号', 
									align: 'center'
							  },
							  {
								    field: 'productName', 
									title: '课程信息',
									align: 'center'
							  },
							  {
								    field: 'totalPrice', 
									title: '应付',
									align: 'center'
							  },
							  {
								  	field: 'payPrice',
									title: '实际支付',
									align: 'center'
							  },
							  {
								  	field: 'rate',
									title: '分成比例',
									align: 'center'
							  },
							  {
								  	field: 'payMethodName',
									title: '支付方式',
									align: 'center'
							  },
							  {
								  	field: 'salesTax',
									title: '增值税',
									align: 'center'
							  },
							  {
								  	field: 'money',
									title: '课销分成',
									align: 'center'
							  },
							  {
									title: '状态',
									align: 'center',
									templet: '#statusTemp'
							  }
							  
						]]
				});
				 var tableIns2 = table.render({
					    elem: '#table2'
					    ,id:"table2"
					    ,page: true //开启分页
						,limits: [10, 20, 30, 40, 50]
					    ,url: '/${applicationScope.adminprefix }/bill/ruestionListData?id='+${id}+'&sourceType=2' //数据接口
					    ,cols: [[ //表头
					      		  {
										field: 'orderNo', 
										title: '支付记录号',
										align: 'center'
								  },
								  {
									    field: 'userName', 
										title: '买家账号', 
										align: 'center'
								  },
								  { 
										title: '问题ID',
										align: 'center',
										templet:'#questionTemp'
								  },
								  {
									    field: 'totalPrice', 
										title: '应付',
										align: 'center'
								  },
								  {
									  	field: 'payPrice',
										title: '实际支付',
										align: 'center'
								  },
								  {
									  	field: 'payMethodName',
										title: '支付方式',
										align: 'center'
								  },
								  {
									  	field: 'salesTax',
										title: '增值税',
										align: 'center'
								  },
								  {
									  	field: 'money',
										title: '问题分成',
										align: 'center'
								  },
								  {
										title: '状态',
										align: 'center',
										templet: '#statusTemp'
								  }
							]]
					});
				 var tableIns3 = table.render({
					    elem: '#table3',
					    id:"table3",
					    page: true, //开启分页
						limits: [10, 20, 30, 40, 50],
					    url: '/${applicationScope.adminprefix }/bill/ruestionListData?id='+${id}+'&sourceType=3', //数据接口
					    cols: [[ //表头
					      		  {
										field: 'orderNo', 
										title: '支付记录号',
										align: 'center'
								  },
								  {
									    field: 'userName', 
										title: '买家账号', 
										align: 'center'
								  },
								  {
										title: '打赏记录ID',
										align: 'center',
										templet:'#rewardTemp'
								  },
								  {
									    field: 'totalPrice', 
										title: '应付',
										align: 'center'
								  },
								  {
									  	field: 'payPrice',
										title: '实际支付',
										align: 'center'
								  },
								  {
									  	field: 'payMethodName',
										title: '支付方式',
										align: 'center'
								  },
								  {
									  	field: 'salesTax',
										title: '增值税',
										align: 'center'
								  },
								  {
									  	field: 'money',
										title: '打赏分成',
										align: 'center'
								  },
								  {
										title: '状态',
										align: 'center',
										templet: '#statusTemp'
								  }
							]]
					});
				 
			});
			 
		</script>
	</m:Content>
</m:ContentPage>