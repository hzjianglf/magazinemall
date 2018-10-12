<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<link href="/manage/public/css/orderCss/default.css" rel="stylesheet" type="text/css" />
		<link href="/manage/public/css/orderCss/index.css" rel="stylesheet" type="text/css" />
		<style>
			select{ border:1px #A9A9A9 solid; background:#FFFFFF;width: 15%;}
			.qrsh_biao{
				cursor:pointer;
			}
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="qkfh">
		<form class="layui-form" id="form"> 
			<div class="dfh">
				<div class="dfh_nr">
					<div class="layui-inline" >
						<div class="layui-input-inline" >
							<select class="layui-input" name="year"  id="year" lay-filter="year">
								<c:forEach items="${year}" var="item">
									<option value="${item }">${item }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<input type="checkbox" name="period" checked id="ceshi" value="17" title="管理版" lay-filter="periods" >
					<div class="layui-inline">
						<div class="layui-input-inline">
							<select class="layui-input" name="publish" id="publish1" lay-filter="publish">
								<option>请选择</option>
							</select>
						</div>
					</div>
					<input type="checkbox" name="period" value="18" title="渠道版" lay-filter="periods" >
					<div class="layui-inline">
						<div class="layui-input-inline">
							<select class="layui-input" name="publish" id="publish2" lay-filter="publish">
								<option>请选择</option>
							</select>
						</div>
					</div>
					<div class="layui-inline">
						<div class="layui-input-inline">
							<b onclick="search()" class="layui-btn layui-btn-normal"><i class="layui-icon layui-icon-search"></i>搜索</b>
						</div>
					</div>
					
					<%-- <c:forEach items="${periods}" var="item" varStatus="count">
						<input type="checkbox" name="period" value="${item.id }" title="${item.name }" lay-filter="periods"  ${count.index==0?'checked':'' }>
					</c:forEach> --%>
					<!-- <a class="layui-btn" style="float: right;" id="search"><i class="layui-icon">&#xe615;</i>搜索</a> -->
				</div>
				<div class="clear"></div>
			</div>
			</form>
			<div class="qkfh">
				<table class="layui-hide" id="test"></table>
			</div>
			<div class="grxx">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" style="display: none">
					<tr>
						<td align="right" width="90"><strong>收货人信息：</strong></td>
						<td>
							<input readonly="readonly" id="s_userName" name="s_userName" type="text" value="${receivername}" style="width: 60px;" /> 
							<input readonly="readonly" id="s_phone" name="s_phone" type="text" value="${receiverphone}" style="width: 95px;" />
							<select disabled="disabled" id="s_province" name="s_province"></select>  
							<select disabled="disabled" id="s_city" name="s_city" ></select>  
							<select disabled="disabled" id="s_county" name="s_county"></select>
							<input readonly="readonly" id="s_address" name="s_address" type="text" value="${receiverAddress}" style="width: 232px;" />
						</td>
						<td><button id="sBtn" onclick="updInfo('s');">编辑</button></td>
					</tr>
				</table>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					
						<tr>
							<td align="right" width="90"><strong>发货人信息：</strong></td>
							<td>
								<c:forEach items="${senderInfo}" var="infoList" begin="0" end="0">
								<div id="fUserInfo" style="display:inline;">
									<input type="hidden" name="sendAddressId" id="sendAddressId" value="${infoList.Id}">
									<select disabled="disabled" id="f_province" name="f_province"></select>  
									<select disabled="disabled" id="f_city" name="f_city" ></select>  
									<select disabled="disabled" id="f_county" name="f_county"></select>
									<!-- 隐藏域-省市县 -->
									<input type="hidden" name="provinceVal" id="provinceVal" value="${infoList.province}">
									<input type="hidden" name="cityVal" id="cityVal" value="${infoList.city}">
									<input type="hidden" name="countyVal" id="countyVal" value="${infoList.county}">
									
									<input readonly="readonly" id="f_userName" name="f_userName" type="text" value="${infoList.receiver}" style="width: 60px;" />
									<input readonly="readonly" id="f_phone" name="f_phone" type="text" value="${infoList.phone}" style="width: 95px;" />
									<input readonly="readonly" id="f_address" name="f_address" type="text" value="${infoList.detailedAddress}" style="width: 232px;" />
									
								</div>
								</c:forEach>
								<div id="updFUserInfo" style="display:none;">
									<select style="width: 100%;" id="updFUserInfoId">
										<option value="">请选择</option>
										<c:forEach items="${senderInfo}" var="fList">
											<option value="${fList.Id}">
												${fList.receiver}&nbsp;${fList.phone}&nbsp;${fList.province}&nbsp;${fList.city}&nbsp;${fList.county}&nbsp;${fList.detailedAddress}
											</option>
										</c:forEach>
									</select>
								</div>
								
							</td>
							<td><button id="fBtn" onclick="updInfo('f');">编辑</button></td>
						</tr>
				</table>
				<%-- <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="right" width="90"><strong>快递信息：</strong></td>
						<td>
							<select id="wuliuCompany">
								<option value="">请选择</option>
								<c:forEach items="${wuliuCompany}" var="wuliu">
									<option value="${wuliu.Id }">${wuliu.name }</option>
								</c:forEach>
							</select>
							<input type="text" id="wuliuNum" name="wuliuNum" placeholder=" 快递单号" /></td>
						<td>&nbsp;</td>
					</tr>
				</table> --%>
			</div>
			<input type="hidden" name="orderNo" id="orderNo" value="${orderno}"> <!-- 订单号 -->
			<input type="hidden" name="orderId" id="orderId" value="${orderId}"> <!-- 大订单id -->
			<input type="hidden" name="orderItemId" id="orderItemId" value="${orderItemId}">
			
			<input type="button" id="qrsh_biao" class="qrsh_biao" value="确认发货" onclick="qikanFahuo();" />
			
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>	 
		<script src="/manage/public/js/areaf.js" type="text/javascript"></script>
		<script>
			//通过 year 年份,period 刊物id 获取 期次列表
			function publishList (year , period , Obj){
				console.log(year + "_" + period + "_" + Obj);
				if(year == null || period == null){
					$(Obj).html("<option value=''>请选择</option>");
					//search();
					render();
					return ;
				}
				$.ajax({
					type:"post",
					data:{year:year,period:period},
					url:"/${applicationScope.adminprefix }/order/getPubByYear",
					dataType:"json",
					async:false,
					success:function(data){
						var html = "";
						var list = data.publishs;
						$('#publish').html(html);
						for ( var i = 0 ; i < list.length ; i++ ){
							html += "<option value='"+list[i].id+"' >"+list[i].describes+"</option>";
						}
						$(Obj).html(html);
						//渲染
						render();
						//search();
					},
					error:function(){
						tipinfo("链接网络异常!");
					}
				})
			}
			
			//页面加载完后默认数据
			function publishList2 (year , period , Obj){
				$.ajax({
					type:"post",
					data:{year:year,period:period},
					url:"/${applicationScope.adminprefix }/order/getPubByYear",
					dataType:"json",
					async:false,
					success:function(data){
						var html = "";
						var list = data.publishs;
						$('#publish').html(html);
						for ( var i = 0 ; i < list.length ; i++ ){
							html += "<option value='"+list[i].id+"' >"+list[i].describes+"</option>";
						}
						console.log($(Obj).html());
						$(Obj).html(html);
					},
					error:function(){
						tipinfo("链接网络异常!");
					}
				})
			}
			
			//获取提交的数据 year period publish
			function dataParam(){
				var year = $('#year').val();
				var period = [];
				var publish = [];
				$('input[name="period"]').each(function(){
					var Obj = $(this).next().next().find('select');
					if($(this).next().hasClass('layui-form-checked')){
						var val = $(this).val();
						if(period.indexOf(val) == -1){
							period.push(val);
						}
						if(publish.indexOf($(Obj).val()) == -1){
							publish.push($(Obj).val());
						}
					}
				});
				return data = {year:year,period:period.join(","),publish:publish.join(",")};
			}
			
		</script>
		<script type="text/javascript">
		var arr=[];
		var tableData;
		$(function(){
				
				_init_area();
			
				$("#s_province option[value^='${receiverProvince}']").prop("selected",true).trigger("change");
				$("#s_city option[value^='${receiverCity}']").prop("selected",true).trigger("change");
				$("#s_county option[value^='${receiverCounty}']").prop("selected",true).trigger("change");
				
				$("#f_province option[value^='"+$("#provinceVal").val()+"']").prop("selected",true).trigger("change");
				$("#f_city option[value^='"+$("#cityVal").val()+"']").prop("selected",true).trigger("change");
				$("#f_county option[value^='"+$("#countyVal").val()+"']").prop("selected",true).trigger("change");
			
				var $category = $('.xz_biao').hide();
				
				$('.showMore').each(function(){
					$(this).on("click",function(){
						
						var $biao=$(this).parents("li:first").find(".xz_biao");
						
						var id=$(this).data("id");
						var index= arr.indexOf(id);
						
						if($(this).hasClass("on")){
							
							if(index!=-1){
								arr.splice(index,1);
							}
							
							$biao.hide();
							$(this).find("span").html("选择");
							$(this).removeClass("on");
						}else{
							
							if(index==-1){
								arr.push(id);
							}
							
							$biao.show();
							$(this).find("span").html("取消选择");
							$(this).addClass("on");
						}
						
						$("#qiciId").val(arr.toString());
					})
				})
				
		})
		</script>
		<script type="text/javascript">
			//切换收发人信息样式
			function updInfo(infoType){
				var btnType = $("#"+infoType+"Btn").html();
				if(btnType=="保存"){
					$("#"+infoType+"_userName").attr("readonly","readonly");
					$("#"+infoType+"_phone").attr("readonly","readonly");
					$("#"+infoType+"_province").attr("disabled","disabled");
					$("#"+infoType+"_city").attr("disabled","disabled");
					$("#"+infoType+"_county").attr("disabled","disabled");
					$("#"+infoType+"_address").attr("readonly","readonly");
					if(infoType=="f"){
						updFUserInfo();
						$("#updFUserInfoId").val()==""?"":$('#sendAddressId').val($("#updFUserInfoId").val());
						$("#fUserInfo").css("display","inline");
						$("#updFUserInfo").css("display","none");
					}
					$("#"+infoType+"Btn").html("编辑");
				}else{
					$("#"+infoType+"_userName").attr("readonly",false);
					$("#"+infoType+"_phone").attr("readonly",false);
					$("#"+infoType+"_province").attr("disabled",false);
					$("#"+infoType+"_city").attr("disabled",false);
					$("#"+infoType+"_county").attr("disabled",false);
					$("#"+infoType+"_address").attr("readonly",false);
					$("#"+infoType+"_userName").focus();
					if(infoType=="f"){
						$("#fUserInfo").css("display","none");
						$("#updFUserInfo").css("display","inline");
					}
					$("#"+infoType+"Btn").html("保存");
				}
			}
			
			layui.use(['element', 'layer','upload','form','table','laydate'], function() {
				var element = layui.element;
				var layer = layui.layer;
				var form = layui.form;
				var laydate = layui.laydate;
				var upload = layui.upload;
				var talbe = layui.table;
				
				//监听期次
				form.on('select(publish)', function(data){
					//查询接口
					//search();
				});
				
				//监听年份
				form.on('select(year)', function(data){
					var year = data.value;
					$('input[name="period"]').each(function(){
						var Obj = $(this).next().next().find('select');
						if($(this).next().hasClass('layui-form-checked')){
							var val = $(this).val();
							publishList(year,val,Obj);
						}else{
							var val = $(this).val();
							publishList(null,null,Obj);
						}
					})
					//查询接口
					//search();
				});
				//监听复选框
				form.on('checkbox(periods)', function(data){
					var val = data.value; //复选框value值，也可以通过data.elem.value得到
					var Obj = $(data.elem).next().next().find('select');
					var year = $('#year').val();
					if(data.elem.checked){
						publishList(year,val,Obj);
					}else{
						publishList(null,null,Obj);
					}
					//查询接口
					//search();
				});
				
				
				//数据类表
				var tableIns = table.render({
						elem: '#test'
						,url:'/${applicationScope.adminprefix }/order/bathSendSearch?needDelive=1&listType=2'
						,cellMinWidth: 80 //全局定义常规单元格的最小宽度，layui 2.2.1 新增
						,page: true //是否显示分页
			            ,limits: [10,50,100,1000]
						,where: { //设定异步数据接口的额外参数，任意设
							period:17,
							publish:25
						}
						,cols: [[
							{type:'checkbox'}
							,{field:'orderno', title: '订单标号',sort: true}
							,{field:'nickName', title: '买家'}
							,{field:'productname', title: '期刊名称'}
							,{field:'buyTime', title: '下单时间'}
						]]
				});
				
				window.search = function() { //搜索，重置表格
					var data = dataParam();
					if(data.period==''){
						tipinfo("至少选择一个版本!");
						return ;
					}
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							period:data.period,
							publish:data.publish
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
					form.render();
				}
				
				//渲染
				window.render = function(){
					form.render();
				}
				
				//添加期刊发货单
				window.qikanFahuo = function (){
					var checkStatus = table.checkStatus('test');
					var ids = [];
					$.each(checkStatus.data, function(i){
						var v = checkStatus.data[i].orderItemId;
						if(ids.indexOf(v) == -1){
							ids.push(v);
						}
					})
					//发货
					updBtn(ids.join(","));
				}
				
				$(function(){
					var Obj = $("#publish1");
					var year = $("#year").val();
					publishList2(year,$("#ceshi").val(),Obj)
					form.render();
				})
				
			});
			
			//修改发货人信息
			var jsonSenderInfo = ${jsonSenderInfo};
			function updFUserInfo(){
			var sInfoId = $("#updFUserInfoId").val();
				for(var i = 0;i<jsonSenderInfo.length;i++){
					
					if(jsonSenderInfo[i].Id==sInfoId){
						$("#f_userName").val(jsonSenderInfo[i].receiver);
						$("#f_phone").val(jsonSenderInfo[i].phone);
						$("#provinceVal").val(jsonSenderInfo[i].province);
						$("#cityVal").val(jsonSenderInfo[i].city);
						$("#countyVal").val(jsonSenderInfo[i].county);
						$("#f_address").val(jsonSenderInfo[i].detailedAddress);
						
						/* $("#f_province").val($("#provinceVal").val()).trigger("change");
						$("#f_city").val($("#cityVal").val()).trigger("change");
						$("#f_county").val($("#countyVal").val()).trigger("change"); */
						$("#f_province option[value^='"+$("#provinceVal").val()+"']").prop("selected",true).trigger("change");
						$("#f_city option[value^='"+$("#cityVal").val()+"']").prop("selected",true).trigger("change");
						$("#f_county option[value^='"+$("#countyVal").val()+"']").prop("selected",true).trigger("change");
						
					}
				}
			}
			
			//批量发货
			function updBtn(ids){
				var data = dataParam();
				loading(true);
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/order/bathSend",
					data : {
							"needDelive":1,
							"sendAddressId":$("#updFUserInfoId").val()==""?$('#sendAddressId').val():$("#updFUserInfoId").val(),
							"sendStatus":2,
							"listType":2,
							"ids":ids,
							"period":data.period,
							"publish":data.publish
					},
					success : function(data) {
						loading();
						closewindow();
						alertinfo(data.msg,data.result);
					},
					error : function(data) {
						loading();
						alertinfo("网络异常，请稍后再试！");
					}
				});
			}
			//校验
			function check(){
				var wuliuCompany = $("#wuliuCompany").val();
				var wuliuNum = $("#wuliuNum").val();
				var qiciId = $("#qiciId").val();
				if(qiciId==''){
					tipinfo("请选择要发货的期刊！");
					return false;
				}
				if(wuliuCompany==""){
					tipinfo("请选择快递公司","#wuliuCompany");
					return false;
				}
				/* if(wuliuNum==''){
					tipinfo("请填写物流单号","#wuliuNum");
					$("#wuliuNum").focus();
					return false;
				} */
				return true;
			}
			
		</script>
	</m:Content>
</m:ContentPage>
