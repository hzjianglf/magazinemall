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
			交易统计表
		</blockquote>
		<div class="yw_cx">
				<div class="layui-form-item">
					<div class="layui-inline">
						<label class="layui-form-label">统计日期：</label>
						<div class="layui-input-inline">
							<input type="text" name="startTime" id="startTime"
								lay-verify="date" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-inline">
						<label class="layui-form-label">-</label>
					</div>
					<div class="layui-inline">
						<input type="text" name="endTime" id="endTime"
							lay-verify="endTime" autocomplete="off" class="layui-input">
					</div>
					<div class="layui-inline">
					   <div class="layui-inline" style="display:none" id="changeBookType">
					   		<div class="layui-input-inline">
							<input type="checkbox" name="magazine" id="magazine"
								style="width: 10%; margin-top: 8%;">
							</div>
							<label class="layui-form-label" style="margin-left: -150px;">期刊</label>
					        
					        
					        <div class="layui-input-inline">
							<input type="checkbox" name="electronic" id="electronic"
								style="width: 10%; margin-top: 8%;">
							</div>
							<label class="layui-form-label" style="margin-left: -150px;">电子书</label>
					   </div>
						
						<div class="layui-inline">
							<label class="layui-form-label">年份：</label>
							<div class="layui-input-inline">
								<select class="layui-input" name="year" id="year" onchange="changeYear()">
									<option value="">请选择</option>
									<c:forEach items="${year }" var="item">
										<option value="${item}"><%-- ${book.year } --%>${item }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="layui-inline">
							<label class="layui-form-label">期刊列表：</label>
							<div class="layui-input-inline">
								<select class="layui-input" name="productid" id="productid" onchange="changeEleOrBook(this.value)">
									<option value="">请选择</option>
									<c:forEach items="${bookList }" var="book">
										<option value="${book.id }"><%-- ${book.year } --%>${book.name }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						
						
						
						<div class="layui-input-inline">
							<input type="checkbox" name="questionAndAnswer"
								id="questionAndAnswer" style="width: 10%; margin-top: 8%;">
						</div>
						<label class="layui-form-label" style="margin-left: -150px;">问答(含旁听)</label>
						<div class="layui-inline">
							<label class="layui-form-label">课程类别：</label>
							<div class="layui-input-inline">
								<select class="layui-input" name="courseState" onchange="getCourseTypeItems(this.value)">
									<option value="">请选择</option>
									<c:forEach items="${ondemandTypeList }" var="ondemandType">
										<option value="${ondemandType.id }">${ondemandType.name }</option>
									</c:forEach>
								</select>
							</div>
							
							<label class="layui-form-label">课程列表：</label>
							<div class="layui-input-inline">
								<select class="layui-input" name="ondemandId" id="ondemandId">
									<option value="">请选择</option>
									<c:forEach items="${ondemandList }" var="ondemand">
										<option value="${ondemand.ondemandId }" data-val="${ondemand.type }">${ondemand.name }</option>
									</c:forEach>
								</select>
							</div>
							<select class="layui-input" name="ondemandIdDisplay" id="ondemandIdDisplay" style="display:none">
									<option value="">请选择</option>
									<c:forEach items="${ondemandList }" var="ondemand">
										<option value="${ondemand.ondemandId }" data-val="${ondemand.type }">${ondemand.name }</option>
									</c:forEach>
							</select>
							
							
						</div>
						<div class="layui-input-inline">
							<input type="checkbox" name="reward" id="reward"
								style="width: 10%; margin-top: 8%;">
						</div>
						<label class="layui-form-label" style="margin-left: -150px;">打赏</label>
						<!-- <div class="layui-input-inline">
							<input type="checkbox" name="weChatPay" id="weChatPay"
								style="width: 10%; margin-top: 8%;">
						</div>
						<label class="layui-form-label" style="margin-left: -150px;">微信支付</label>
						<div class="layui-input-inline">
							<input type="checkbox" name="alipay" id="alipay"
								style="width: 10%; margin-top: 8%;">
						</div>
						<label class="layui-form-label" style="margin-left: -150px;">支付宝</label>
						<div class="layui-input-inline">
							<input type="checkbox" name="balance" id="balance"
								style="width: 10%; margin-top: 8%;">
						</div>
						<label class="layui-form-label" style="margin-left: -150px;">余额</label> -->
						<div class="layui-inline" id="layerDemo">
							<div class="layui-input-inline">
								<button class="layui-btn layui-btn-normal" id="search">
									<i class="layui-icon">&#xe615;</i>搜索
								</button>
							</div>
						</div>
						 <div class="layui-inline" id="layerDemo"
							style="margin-left: -0.5%;">
							<div class="layui-input-inline">
								<button class="layui-btn layui-btn-normal" data-val='1' id="statisticsExport">
									<i class="layui-icon">&#xe61e;</i>批量导出
								</button>
							</div>
						</div>
					</div>
					<div class="layui-tab layui-tab-brief">
						<ul class="layui-tab-title" id="type1">
							<li class="totallist layui-this" data-val='1'>汇总</li>
							<li class="orderlist" data-val='2'>订单</li>
							<!-- <li class="productlist" data-val='3'>商品</li> -->
						</ul>
						<div class="layui-tab-content" style="height: 100px;">
							<div class="layui-tab-item layui-show">
								<table class="layui-table" lay-skin="line" id="buyerList"
									lay-filter="tableContent"></table>
							</div>
							<div class="layui-tab-item">
							    <table class="layui-table" lay-skin="line" id="orderList" 
							           lay-filter="tableContent"></table>
							</div>
							<!-- <div class="layui-tab-item">
							    <table class="layui-table" lay-skin="line" id="productList" 
							           lay-filter="tableContent"></table>
							</div> -->
						</div>
					</div>
				</div>
			</div>
	</div>
	<!-- 汇总-订单类型 -->
	<script type="text/html" id="ordertypeForTotal">
		{{# if(d.ordertype==1){ }}
			期刊
		{{# }else if(d.ordertype==2){ }}
			课程
		{{# }else if(d.ordertype==3){ }}
			问答
		{{# }else if(d.ordertype==4){ }}
			打赏
        {{# }else if(d.ordertype==5){ }}
			合计
		{{# }else if(d.ordertype==6){ }}
			电子书
		{{# }else if(d.ondemandType!=null && d.ondemandType!='' ){ }}
			{{ d.name }}
		{{# } }}
			
 			  
	</script>
	<!-- 汇总-优惠券展示格式'-或值' -->
	<script type="text/html" id="couponPriceTypeForTotal">
		{{# if(d.ordertype==1){ }}
			{{ d.couponPrice }}
		{{# }else if(d.ordertype==2){ }}
			{{ d.couponPrice }}
		{{# }else if(d.ordertype==3){ }}
			-
		{{# }else if(d.ordertype==4){ }}
			-
        {{# }else if(d.ordertype==5){ }}
			{{ d.couponPrice }}
		{{# }else if(d.ordertype==6){ }}
			{{ d.couponPrice }}
		{{# } }}

			  {{# if(d.ondemandType ==1){ }}
			         {{ d.couponPrice }}
				{{# }else if(d.ondemandType ==2){ }}
			         {{ d.couponPrice }}
				{{#}else if(d.ondemandType ==3){ }}
			         {{ d.couponPrice }}
				{{#}else if(d.ondemandType ==4){ }}
			         {{ d.couponPrice }}
				{{# }else if(d.ondemandType ==8){ }}
			         {{ d.couponPrice }}
				{{# }else if(d.ondemandType ==9){ }}
			         {{ d.couponPrice }}
              {{# } }}
	</script>
	<!-- 订单,商品-订单类型 -->
	<script type="text/html" id="ordertypeForOrder">
        {{# if(d.source==1){ }} 
              
		{{# }else if(d.source==3 || d.source==4){ }}
			问答
		{{# }else if(d.source==5){ }}
			打赏
		{{# } }}
				{{# if(d.ordertype==2){ }}
			          期刊
              {{# }else if(d.ordertype==4){ }}
			         点播课程
			  {{# }else if(d.ordertype==8){ }}
			         直播课程
			  {{# }else if(d.ordertype==16){ }}
			         电子书
			  {{# }else if(d.ondemandType!=null && d.ondemandType!='' ){ }}
			   {{ d.name }}
              {{# } }}


	</script>
	<!-- 商品-商品类型类型 -->
	<script type="text/html" id="productTypeForProduct">
        {{# if(d.producttype==1){ }} 
                           实物
		{{# }else if(d.producttype==2){ }}
			期刊
		{{# }else if(d.producttype==4){ }}
			点播
         {{# }else if(d.producttype==8){ }}
			直播
         {{# }else if(d.producttype==16){ }}
			电子书
		{{# } }}

	</script>
	<!-- 商品-是否是赠品 -->
	<script type="text/html" id="subTypeForProuduct">
		{{# if(d.subType==5){ }} 
                           是
		{{# }else if(d.subType!=2){ }}
		{{# } }}
	</script>
	<!-- 商品-发货状态 -->
	<script type="text/html" id="deliverstatusForProuduct">
		{{# if(d.producttype==1 || d.producttype==2){ }} 
        {{# if(d.deliverstatus==0){ }} 
                           未发货
		{{# }else if(d.deliverstatus==1){ }}
                          已发货
        {{# }else if(d.deliverstatus==2){ }}
                          部分发货
        {{# }else if(d.deliverstatus==3){ }}
                          已完成
		{{# } }}  
          
		{{# } }}


		{{# if(d.producttype==4 || d.producttype==8 || d.producttype==16){ }} 
        {{# if(d.deliverstatus==0){ }} 
                           已完成
		
        {{# } }}  
		{{# } }}

	</script>
	<script type="text/html" id="address">
		{{ d.receiverProvince+ d.receiverCity +d.receiverCounty+ d.receiverAddress  }}
	</script>
	<script type="text/html" id="paytypeForOrder">
		{{# if(d.paytype==1){ }} 
          APP支付宝即时到账
		{{# }else if(d.paytype==2){ }}
                          微信App支付
        {{# }else if(d.paytype==3){ }}
                         支付宝即时到账
        {{# }else if(d.paytype==4){ }}
                          手机支付宝即时到账
		{{# }else if(d.paytype==5){ }}
                          账户余额支付
		{{# }else if(d.paytype==6){ }}
                          微信公众号支付
		{{# }else if(d.paytype==7){ }}
                          微信扫码支付
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//选择课程类别下对应的课程列表 
		function getCourseTypeItems(type){
			 var option = "";
			 if(type != ''){
				 option = "<option value=''>请选择</option>";
			 }
			  $("#ondemandIdDisplay option").each(function(){
				  var ondemandType = $(this).attr("data-val");
				  var ondemandId = $(this).val();
				  var ondemandName = $(this).text();
				  if(type != ''){
					  if(ondemandType == type){
						  option += "<option value='"+ondemandId+"'>"+ondemandName+"</option>";
					  }
				  }else{
					  option += "<option value='"+ondemandId+"'>"+ondemandName+"</option>";
				  }
			  });
			 $("#ondemandId").html(option);
		}
		function changeYear(){
			var year = $("#year option:selected").val();
			$.ajax({
				type:"post",
				data:{"year":year},
				url:"/${applicationScope.adminprefix }/statistics/getBookByYear",
				success:function(data){
					var list=data.bookList;
					$("#productid").empty();
					var html='<option>请选择</option>';
					for(var i=0;i<list.length;i++){
						html+='<option value="'+list[i].id+'">'+list[i].name+'</option>';
					}
					$("#productid").append(html);
				}
			})
		}
		function changeEleOrBook(value){
			if(value == null || value == ''){
				$("#changeBookType").hide();
			}else{
				$("#changeBookType").show();
			}
		}
		
		
	
	
	
		//批量导出--点击导出的是汇总,订单,商品
		 $("#type1 li").click(function(){//点击事件  
			 var statisticsValue=$(this).attr("data-val");
		     //点击汇总,订单,商品 对批量导出分别赋不同值,用来区分导出的是哪个模块.
			 if(statisticsValue == '1'){
				 $("#statisticsExport").attr("data-val","1");
			 }else if(statisticsValue == '2'){
				 $("#statisticsExport").attr("data-val","2");
			 }else if(statisticsValue == '3'){
				 $("#statisticsExport").attr("data-val","3");
			 }
		   }) 
		 //导出 - 订单,商品  公共传参方法
		 function payMeh(){
			    var payMehod = "";
				var alipay = $("#alipay").is(":checked");
				if(alipay){
					payMehod +="支付宝支付"+",";
				}
				var weChat = $("#weChatPay").is(":checked");
				if(weChat){
					payMehod +="微信支付"+",";
				}
				var balan = $("#balance").is(":checked");
				if(balan){
					payMehod += "余额支付"
				}
			   return payMehod;
		   }
		 function orderType(){
			    var orderTypeList = "";
				var magazine = $("#magazine").is(":checked");;
				if(magazine){
					orderTypeList +=2+",";
				}
				var course = $("#course").is(":checked");
				if(course){
					orderTypeList +=4+",";
					orderTypeList +=8;
				}
			   return orderTypeList;
		   }
		 function question(){
				var questionAnswer = "";
				var questionAndAnswer = $("#questionAndAnswer").is(":checked");
				if(questionAndAnswer){
					questionAnswer +=4+",";
					questionAnswer +=3+",";
				}
				var reward = $("#reward").is(":checked");
				if(reward){
					questionAnswer +=5+",";
				}
			   return questionAnswer;
		   }
	       //批量导出
		   $("#statisticsExport").click(function(){
	           var exportValues = $("#statisticsExport").attr("data-val");
			   if(exportValues == '1'){//批量导出汇总
				    //选中的ordertype checkbox
				    var checkStatus = table.checkStatus('buyerList');
					//勾选框
					var ordertype = '';
					$.each(checkStatus.data, function(i){
						ordertype = ordertype + checkStatus.data[i].ordertype + ',';
					}) 
					//是否勾选期刊(含电子刊)
	                var magazine = $("#magazine").is(":checked");
					//是否勾选课程(含直播)
					var course = $("#course").is(":checked");
					//是否勾选问答(含旁听)
					var questionAndAnswer = $("#questionAndAnswer").is(":checked");
					//是否勾选打赏
					var reward = $("#reward").is(":checked");
					if(magazine){
						ordertype += 1 + ',';
					}
					if(course){
						ordertype += 2 + ',';
					}
					if(questionAndAnswer){
						ordertype += 3 + ',';
					}
					if(reward){
						ordertype += 4 + ',';
					}
					//是否勾选微信支付
					var weChat = $("#weChatPay").is(":checked");
					//是否勾选支付宝
					var ali = $("#alipay").is(":checked");
					//是否勾选余额
					var balan = $("#balance").is(":checked");
					var weChatPay = '';
					if(weChat){
						weChatPay = '微信支付'
					}
					var alipay = '';
					if(ali){
						alipay = '支付宝支付'
					}
					var balance = '';
					if(balan){
						balance = '余额支付'
					}
					 window.location.href = "/${applicationScope.adminprefix }/statistics/statisticsExport?"+
					        "ordertype="+ordertype+"&startTime="+$('#startTime').val()+"&endTime="+$('#endTime').val()
					         +"&weChatPay="+weChatPay+"&alipay="+alipay+"&balance="+balance+"&courseState="+$('select[name="courseState"]').val()
			   }else if(exportValues == '2'){//批量导出订单
					//选中的order表id checkbox
				    var checkStatus = table.checkStatus('orderList');
					var orderId = '';
					$.each(checkStatus.data, function(i){
						orderId = orderId + checkStatus.data[i].orderId + ',';
					}) 
					var questionAnswer = question();
					var payMehod = payMeh();
					var orderTypeList = orderType();
					var courseState = $('select[name="courseState"]').val();
					var productid = $('select[name="productid"]').val();
					var ondemandId = $('select[name="ondemandId"]').val();
					window.location.href = "/${applicationScope.adminprefix }/statistics/statisticsExportForOrder?"+
					        "orderId="+orderId+"&startTime="+$('#startTime').val()+"&endTime="+$('#endTime').val()
					        +"&orderTypeList="+orderTypeList+"&questionAnswer="+questionAnswer+"&payMehod="+payMehod
					        +"&courseState="+courseState+"&productid="+productid+"&ondemandId="+ondemandId
		       }else if(exportValues == '3'){//批量导出商品
					//选中的orderitem表id checkbox
				    var checkStatus = table.checkStatus('productList');
					var productId = '';
					$.each(checkStatus.data, function(i){
						productId = productId + checkStatus.data[i].productId + ',';
					})
					var questionAnswer = question();
					var payMehod = payMeh();
					var orderTypeList = orderType();
					window.location.href = "/${applicationScope.adminprefix }/statistics/statisticsExportForProuduct?"+
					"productId="+productId+"&startTime="+$('#startTime').val()+"&endTime="+$('#endTime').val()
					+"&orderTypeList="+orderTypeList+"&questionAnswer="+questionAnswer+"&payMehod="+payMehod
			   }
			})
		//var perId='${perId}';
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate','element'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			/* laydate.render({
				elem: '#startTime',
			});
			laydate.render({
				elem: '#endTime',
			}); */
			//var perId='${perId}';
			//汇总列表
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/statistics/statisticOrderTotals', //数据接口
				cellMinWidth: 100,
				page: false, //false:关闭分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[	
						{
							type: 'checkbox',
							width: "5%",
						},
						{
							field: 'ordertype',
							title: '订单类型',
							templet: '#ordertypeForTotal',
						}, 
						/* {
							field: 'nickName',
							title: '专家',
						}, */
						{
							field: 'totalprice',
							title: '商品金额',
						}, 
						{
							field: 'couponPrice',
							title: '优惠券代金券(折让)金额',
							templet: '#couponPriceTypeForTotal',
						},
						{
							field: 'actualPayPrice',
							title: '实际支付金额',
						}
					]
				],
			});
			//搜索汇总
			$('#search').click(function() {
				var orderTypeTotal = "";//问答和打赏
				var bookAndElectronic = "";//期刊和电子书
                var magazine = $("#magazine").is(":checked");//期刊
                var electronic = $("#electronic").is(":checked");//电子书
				var course = $("#course").is(":checked");//课程(直播)
				var questionAndAnswer = $("#questionAndAnswer").is(":checked");//问答(含旁听)
				var reward = $("#reward").is(":checked");//打赏
				/* if(magazine){
					orderTypeTotal += 1+",";
				} */
				if(course){
					orderTypeTotal += 2+",";
				}
				if(questionAndAnswer){
					orderTypeTotal += 3+",";
				}
				if(reward){
					orderTypeTotal += 4+",";
				}
				/* if(electronic){
					orderTypeTotal += 6+",";
				} */
				if(magazine){
					bookAndElectronic += 1+",";
				}
				if(electronic){
					bookAndElectronic += 2+",";
				}
				
				
				var weChatPay = '';
				var weChat = $("#weChatPay").is(":checked");
				
				var alipay = '';
				var ali = $("#alipay").is(":checked");
				
				var balance = '';
				var balan = $("#balance").is(":checked");
				
				if(weChat){
					weChatPay = '微信支付'
				}
				if(ali){
					alipay = '支付宝支付'
				}
				if(balan){
					balance = '余额支付'
				}
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						startTime:$('#startTime').val(),
						endTime:$('#endTime').val(),
						orderTypeTotal:orderTypeTotal,
						bookAndElectronic:bookAndElectronic,
						weChatPay:weChatPay,
						alipay:alipay,
						balance:balance,
						courseState:$('select[name="courseState"]').val(),
						productid:$('select[name="productid"]').val(),
						ondemandId:$('select[name="ondemandId"]').val(),
					},
				});
			})
		});
		/* function mergeCell(){
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
		} */
		//订单列表
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate','element'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			//var index = layer.load(1)
			laydate.render({
				elem: '#startTime',
				/* range: true  区间时间选择*/
			});
			laydate.render({
				elem: '#endTime',
			});
			var perId='${perId}';
			//订单表格
			var tableIns = table.render({
				id: 'orderList',
				elem: '#orderList',
				//loading:true,
				url: '/${applicationScope.adminprefix }/statistics/statisticAboutOrders', //数据接口
				cellMinWidth: 100,
				page: true, //开启分页
				limits: [10,20,50,100],
				cols: [
					[	
						//表头
						{
							type: 'checkbox',
							fixed: 'left',
							width: "5%",
						},
						{
							field: 'orderId',
							title: '订单ID',
							 fixed: 'left',
							width: "10%",
						},
						{
							field: 'time',
							title: '下单时间',
							 fixed: 'left',
							width: "20%",
						},
						
						{
							field: 'ordertype',
							title: '订单类型',
							templet: '#ordertypeForOrder',
							width:'10%'
						}, 
						{
							field: 'orderno',
							title: '订单编号',
							width:'10%'
						},
						{
							field: 'userTel',
							title: '用户信息',
						},
						{
							field: 'receivername',
							title: '收货人信息',
							width:'10%'
						},
						{
							field: 'receiverphone',
							title: '收货人电话',
							width:'10%'
						},
						{
							field: 'userTel',
							title: '收货人地址',
							templet: '#address',
							width:'35%'
						},
						{
							field: 'productName',
							title: '订单商品',
						},
						
						{
							field: 'productCount',
							title: '商品数量',
						},
						{
							field: 'orderprice',
							title: '价格',
						}, 
						{
							field: 'totalprice',
							title: '金额',
						}, 
						{
							field: 'jianprice',
							title: '优惠券(折让)金额',
							width:'10%'
						},
						{
							field: 'paytype',
							title: '支付方式',
							templet: '#paytypeForOrder',
							width:'10%'
						},
						/* {
							field: 'payTime',
							title: '支付日期',
						}, */
						{
							field: 'actualPrice',
							fixed: 'right',
							 align:'center',
							title: '实际支付金额',
							width:'10%'
						}
					]
				],
				/*  done: function(res, curr, count){
					layer.close(index);
				 }  */
			});
			//监听锁定操作
			/* form.on('checkbox(freezeFilter)', function(obj){
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
			}); */
			
			//搜索订单
			$('#search').click(function() { 
				var magazineAndCourse = "";
				var questionAnswer = "";
				var bookAndElectronic = "";//期刊和电子书
				var magazine = $("#magazine").is(":checked");;
				if(magazine){
					//magazineAndCourse +=2+",";
					bookAndElectronic +=2+",";
				}
				var electronic = $("#electronic").is(":checked");//电子书
				if(electronic){
					//magazineAndCourse += 16+",";
					bookAndElectronic += 16+",";
				}
				/* var course = $("#course").is(":checked");
				if(course){
					magazineAndCourse +=4+",";
					//magazineAndCourse +=8;
				} */
				
				var questionAndAnswer = $("#questionAndAnswer").is(":checked");
				if(questionAndAnswer){
					questionAnswer +=4+",";
					questionAnswer +=3+",";
				}
				var reward = $("#reward").is(":checked");
				if(reward){
					questionAnswer +=5+",";
				}
				var payName = "";
				var alipay = $("#alipay").is(":checked");
				if(alipay){
					payName +=1+",";
				}
				var weChat = $("#weChatPay").is(":checked");
				if(weChat){
					payName +=2+",";
				}
				var balan = $("#balance").is(":checked");
				if(balan){
					payName += 3
				}
				
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						startTime:$('#startTime').val(),
						endTime:$('#endTime').val(),
						magazineAndCourse:magazineAndCourse,
						bookAndElectronic:bookAndElectronic,
						questionAnswer:questionAnswer,
						payName:payName,
						courseState:$('select[name="courseState"]').val(),
						productid:$('select[name="productid"]').val(),
						ondemandId:$('select[name="ondemandId"]').val(),
					},
					 page: {
						curr: 1 //重新从第 1 页开始
					} 
				});
			})
		});
		//商品列表
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate','element'], function(){
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
			//商品表格
			var tableIns = table.render({
				id: 'productList',
				elem: '#productList',
				url: '/${applicationScope.adminprefix }/statistics/statisticAboutProducts', //数据接口
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
							field: 'ordertype',
							title: '订单类型',
							templet: '#ordertypeForOrder',
						}, 
						{
							field: 'orderno',
							title: '订单编号',
						},
						{
							field: 'userTel',
							title: '用户信息',
						},
						{
							field: 'receivername',
							title: '收货人信息',
						},
						{
							field: 'receiverphone',
							title: '收货人电话',
						},
						{
							field: 'userTel',
							title: '收货人地址',
							templet: '#address',
						},
						{
							field: 'productname',
							title: '商品名称',
						},
						{
							field: 'producttype',
							title: '商品类型',
							templet: '#productTypeForProduct',
							
						}, 
						{
							field: 'totalprice',
							title: '商品价格',
						},
						{
							field: 'count',
							title: '数量',
						},
						{
							field: 'subType',
							title: '是否赠品',
							templet: '#subTypeForProuduct',
						},
						{
							field: 'deliverstatus',
							title: '状态',
							templet: '#deliverstatusForProuduct',
						}
					]
				],
				/* done: function(res, curr, count){
					mergeCell();
				 } */
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
			//搜索商品
			$('#search').click(function() {
				var magazineAndCourse = "";
				var bookAndElectronic = "";//期刊和电子书
				var magazine = $("#magazine").is(":checked");;
				if(magazine){
					//magazineAndCourse +=2+",";
					bookAndElectronic +=2+",";
				}
				var electronic = $("#electronic").is(":checked");//电子书
				if(electronic){
					//magazineAndCourse += 16+",";
					bookAndElectronic += 16+",";
				}
				var course = $("#course").is(":checked");
				if(course){
					magazineAndCourse +=4+",";
					//magazineAndCourse +=8;
				}
				var questionAnswer = "";
				var questionAndAnswer = $("#questionAndAnswer").is(":checked");
				if(questionAndAnswer){
					questionAnswer +=4+",";
					questionAnswer +=3+",";
				}
				var reward = $("#reward").is(":checked");
				if(reward){
					questionAnswer +=5+",";
				}
			   
				var payName = "";
				var alipay = $("#alipay").is(":checked");
				if(alipay){
					payName +=1+",";
				}
				var weChat = $("#weChatPay").is(":checked");
				if(weChat){
					payName +=2+",";
				}
				var balan = $("#balance").is(":checked");
				if(balan){
					payName += 3
				}
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						startTime:$('#startTime').val(),
						endTime:$('#endTime').val(),
						magazineAndCourse:magazineAndCourse,
						bookAndElectronic:bookAndElectronic,
						questionAnswer:questionAnswer,
						payName:payName,
						courseState:$('select[name="courseState"]').val(),
						productid:$('select[name="productid"]').val(),
						ondemandId:$('select[name="ondemandId"]').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
		});
		
	</script>
</m:Content>
</m:ContentPage>
