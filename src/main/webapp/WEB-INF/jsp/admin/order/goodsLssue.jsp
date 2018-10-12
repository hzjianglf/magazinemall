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
			a{ color:#006600; text-decoration:none;}
			a:hover{color:#990000;}
			.top{ margin:5px; color:#990000; text-align:center;}
			.info select{ border:1px #A9A9A9 solid; background:#FFFFFF;width: 14%;}
			.info{ margin-top:-38px;margin-left:24%;}
			.info #show{ color:#3399FF; }
			.bottom{ text-align:right; font-size:12px; color:#CCCCCC; width:1000px;}
			.btn{
				float: right;
			    margin: 8px 1%;
			    width: 5%;
			}
			.qrsh_biao{
				cursor:pointer;
			}
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="qkfh">
			<div class="bz_nr">
				<h3>
					<span>第一步</span><strong>确认收货信息及交易详情</strong>
				</h3>
				<div class="ddxx">
					<h4>订单编号：${orderno} 下单时间：${buyTime}</h4>
					<div class="dd_xx">
						<c:forEach items="${shopList}" var="list">
							<img src="/manage/public/css/orderCss/u25691.png" width="30" height="40" />
							<P>
								<span>${list.productname}</span><br />￥${list.buyprice} X${list.count}件
							</P>
						</c:forEach>
					</div>
					<div class="dd_xx1">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="right" width="80">运费：</td>
								<td>${postage}</td>
							</tr>
							<tr>
								<td align="right">发货备忘：</td>
								<td><textarea name="remarks" id="remarks"></textarea></td>
							</tr>
						</table>

					</div>
					<div class="clear"></div>
					<div class="dd_sh">
						<strong>收货人信息：</strong>
  						<span id="receivInfo">${receivername},${receiverphone}&nbsp;${receiverProvince}&nbsp;${receiverCity}&nbsp;${receiverCounty}&nbsp;${receiverAddress}</span>
						<span id="updReceivInfo" style="display:none;">
							<input type="text" name="receivedName" id="receivedName" placeholder="姓名" style="width: 5%;" value="${receivername}">
							<input type="text" name="receivedPhone" id="receivedPhone" placeholder="电话" style="width: 10%;" value="${receiverphone}">
							<div class="info">
								<div>
								<select id="s_province" name="s_province"></select>  
							    <select id="s_city" name="s_city" ></select>  
							    <select id="s_county" name="s_county"></select>
							    </div>
							    <div id="show"></div>
							</div>
							<input type="text" name="detailAddress" id="detailAddress" value="${receiverAddress}" placeholder="详细地址" style="float:right; width: 20%;margin-right: 21.5%; margin-top: -29px;">
						</span>
						<input type="hidden" name="userId" id="userId" value="${userId}">
						<button class="btn" id="updReceivBtn" type="button" onclick="updReceivFace();">编辑</button>
					</div>
				</div>
			</div>
			<div class="bz_nr">
				<h3>
					<span>第二步</span><strong>确认发货信息</strong>
				</h3>
				<div class="ddxx">

					<div class="dd_sh" style="border-top: none;">
						<strong>我的发货信息：</strong>
						<c:forEach items="${senderInfo}" var="infoList">
							<c:if test="${infoList.isDefault==1}">
								<input type="hidden" name="senderId" id="senderId" value="${infoList.userId}">
								<input type="hidden" name="sendAddId" id="sendAddId" value="${infoList.Id}">
								<span id="senderInfo">${infoList.receiver},${infoList.phone}&nbsp;${infoList.province}&nbsp;${infoList.city}&nbsp;${infoList.county}&nbsp;${infoList.detailedAddress}</span>
							</c:if>
						</c:forEach>
						<span id="updSenderInfo" style="display: none;">
							<select style="width: 50%;" id="newSenderInfo" name="newSenderInfo">
								<option value="">请选择</option>
								<c:forEach items="${senderInfo}" var="sender">
									<option value="${sender.Id}">${sender.receiver},${sender.phone}&nbsp;${sender.province}&nbsp;${sender.city}&nbsp;${sender.county}&nbsp;${sender.detailedAddress}</option>
								</c:forEach>
							</select>
						</span>
						<button class="btn" id="updSendBtn" type="button" onclick="updSenderInfoFace();">编辑</button>
					</div>
				</div>
			</div>
			<div class="bz_nr">
				<h3>
					<span>第三步</span><strong>选择物流服务</strong>
				</h3>
				<div class="hywl">
					您可以通过“物流设置 -><span>默认物流公司</span>”添加或修改常用货运物流。
				</div>
				<div class="tx_xx">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>公司名称：
								<select id="wuliuCompany">
									<option value="">请选择</option>
									<c:forEach items="${wuliuCompany}" var="wuliu">
										<option value="${wuliu.Id }">${wuliu.name }</option>
									</c:forEach>
								</select>
							</td>
							<td>物流单号： <input type="text" name="wuliuNum" id="wuliuNum"/></td>
							<td>备忘： <input type="text" name="wuliuRemarks" id="wuliuRemarks"/></td>
						</tr>
					</table>

				</div>
			</div>
			<input type="button" id="qrsh_biao" class="qrsh_biao" value="确定" onclick="saveShopOrderInfo();"/>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>	 
		<script class="resources library" src="/manage/public/js/areaf.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(function(){
				_init_area();
				$("#s_province").val("${receiverProvince}").trigger("change");
				$("#s_city").val("${receiverCity}").trigger("change");
				$("#s_county").val("${receiverCounty}").trigger("change");
			})
		
		</script>
		<script>
		//修改收货人的信息
		function updReceivFace(){
			var btnType = $("#updReceivBtn").html();
			if(btnType=="编辑"){
				$("#receivInfo").attr("style","display:none");
				$("#updReceivInfo").css("display","inline");
				$("#updReceivBtn").css("margin"," -30px 1%");
				$("#updReceivBtn").html("保存");
			}else{
				if(check()){
					saveReceivInfo();
				}
			}
		}
		//校验收货人信息
		function check(){
			var receivedName = $("#receivedName").val();
			var receivedPhone = $("#receivedPhone").val();
			var province = $("#s_province").val();
			var city = $("#s_city").val();
			var county = $("#s_county").val();
			var detailAddress = $("#detailAddress").val();
			
			if(receivedName==""){
				tipinfo("请输入姓名！","#receivedName");
				$("#receivedName").focus();
				return false;
			}
			if(!(/^1[34578]\d{9}$/.test(receivedPhone)) || receivedPhone==""){
				tipinfo("请输入正确手机号！","#receivedPhone");
				$("#receivedPhone").focus();
				return false;
			}
			if(province=="省份"){
				tipinfo("请选择省份！","#s_province");
				return false;
			}
			if(city=="地级市"){
				tipinfo("请选择城市！","#s_city");
				return false;
			}
			if(county=="区/县"){
				tipinfo("请选择区/县！","#s_county");
				return false;
			}
			if(detailAddress==""){
				tipinfo("请输入详细地址","#detailAddress");
				$("#detailAddress").focus();
				return false;
			}
			return true;
		}
		//保存编辑后的收货人信息
		function saveReceivInfo(){
			loading(true);
			$.ajax({
				type : "POST",
				url : "/${applicationScope.adminprefix }/order/updReceivInfo",
				data : {"orderId" : ${orderId},"receivedName":$("#receivedName").val(),"receivedPhone":$("#receivedPhone").val(),
						"province":$("#s_province").val(),"city":$("#s_city").val(),"county":$("#s_county").val(),"detailAddress":$("#detailAddress").val()},
				success : function(data) {
					loading(false);
					tipinfo(data.msg);
					saveReceivInfoSuccess();
				},
				error : function(data) {
					
				}
			});
		} 
		
		//修改收货人信息样式
		function saveReceivInfoSuccess(){
			$("#receivInfo").attr("style","display:inline");
			$("#updReceivInfo").css("display","none");
			$("#updReceivBtn").css("margin"," 8px 1%");
			$("#updReceivBtn").html("编辑");
			$("#receivInfo").html($("#receivedName").val()+",&nbsp;"+$("#receivedPhone").val()+"&nbsp;"+$("#s_province").val()+"&nbsp;"+$("#s_city").val()+"&nbsp;"+$("#s_county").val()+"&nbsp;"+$("#detailAddress").val());
		}
		//修改发货人信息样式
		function updSenderInfoFace(){
			var btnType = $("#updSendBtn").html();
			if(btnType=="编辑"){
				$("#senderInfo").attr("style","display:none");
				$("#updSenderInfo").css("display","inline");
				$("#updSendBtn").html("保存");
			}else{
				$("#senderInfo").attr("style","display:inline");
				$("#updSenderInfo").css("display","none");
				$("#updSendBtn").html("编辑");
				var selectInfo = $("select[name=newSenderInfo] option:selected").html();
				$("#senderInfo").html(selectInfo);
				$("#sendAddId").val($("#newSenderInfo").val());
			}
		}
		//保存商品订单信息
		function saveShopOrderInfo(){
			var jsonOrderList = ${jsonOrderItem};
			var orderItemId ="";
			for(var i = 0;i<jsonOrderList.length;i++){
				orderItemId += jsonOrderList[i].id+",";
			}	
			if(checkShopInfo()){
				$("#qrsh_biao").removeAttr("onclick");
				$("#qrsh_biao").css("background","#949494");
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/order/saveShopOrderInfo",
					data : {"orderNo" :${orderno},"orderId":${orderId},"orderItem":orderItemId,"senderId":$("#senderId").val(),
							"sendAddressId":$("#sendAddId").val(),"expressId":$("#wuliuCompany").val(),"expressNum":$("#wuliuNum").val(),
							"remarks":$("#remarks").val(),"wuliuRemarks":$("#wuliuRemarks").val(),"receivedName":$("#receivedName").val(),"receivedPhone":$("#receivedPhone").val(),
							"province":$("#s_province").val(),"city":$("#s_city").val(),"county":$("#s_county").val(),"detailAddress":$("#detailAddress").val()},
					success : function(data) {
						closewindow();
						alertinfo(data.msg,data.result);
					},
					error : function(data) {
						
					}
				});
			} 
			
		}	
		function checkShopInfo(){
			var wuliuCompany = $("#wuliuCompany").val();
			var wuliuNum = $("#wuliuNum").val();
			if(wuliuCompany==""){
				tipinfo("请选择快递公司！","#wuliuCompany");
				$("#wuliuCompany").focus();
				return false;
			}
			if(wuliuNum==""){
				tipinfo("请填写物流单号！","#wuliuNum");
				$("#wuliuNum").focus();
				return false;
			}
			return true;
		}
		</script>
	</m:Content>
</m:ContentPage>
