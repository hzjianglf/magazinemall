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
			<div class="dfh">
				<h3>待发货期刊</h3>
				<div class="dfh_nr">
					<ul>
						<c:forEach items="${daifaQikan}" var="item">
							<c:choose>
								<c:when test="${not empty item.bookId}">
									<li class='xz_nr'>
										<img src="/manage/public/css/orderCss/u18490.png" width="30" height="30" class="xz_biao" />
										<img src="${item.picture}" width="76" height="100"/>
										<P>${item.qikanYear}年${item.name}${item.qici}</P>
										<P>数量${item.count}</P>
										<a href="javascript:void(0);" class="showMore" data-id="${item.planId}" ><span>选择</span></a>
									</li>
								</c:when>
								<c:otherwise>
									<li>
										<img src="/manage/public/css/orderCss/u18424.png" width="76" height="100" />
										<P>${item.qikanYear}年${item.name}${item.qici}</P>
										<P>数量${item.count}</P>
										<a href="javascript:void(0);">选择</a>
									</li>
								</c:otherwise>				
							</c:choose>
						</c:forEach>
					</ul>
					<input type="hidden" name="qiciId" id="qiciId">
				</div>
				<div class="clear"></div>
			</div>
			<div class="dfh">
				<h3>已发货期刊</h3>
				<div class="dfh_nr">
					<ul>
						<c:if test="${not empty yifaQikan}">
							<c:forEach items="${yifaQikan}" var="yifaList">
								<li><img src="${yifaList.picture}" width="76" height="100" /><P>${yifaList.publishYear}年${yifaList.name}${yifaList.qici}</P></li>
							</c:forEach>
						</c:if>
						<c:if test="${empty yifaQikan}">
							<li style="font-size: 35px;width: 100%;color: #949494;">暂无已发货期刊</li>
						</c:if>
					</ul>
				</div>
				<div class="clear"></div>
			</div>
			<div class="grxx">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
								<%-- ${infoList.receiver} --%>
									<input type="hidden" name="sendAddressId" id="sendAddressId" value="${infoList.Id}">
									<input readonly="readonly" id="f_userName" name="f_userName" type="text" value="${infoList.receiver}" style="width: 60px;" />
									<input readonly="readonly" id="f_phone" name="f_phone" type="text" value="${infoList.phone}" style="width: 95px;" />
									<select disabled="disabled" id="f_province" name="f_province"></select>  
									<select disabled="disabled" id="f_city" name="f_city" ></select>  
									<select disabled="disabled" id="f_county" name="f_county"></select>
									<!-- 隐藏域-省市县 -->
									<input type="hidden" name="provinceVal" id="provinceVal" value="${infoList.province}">
									<input type="hidden" name="cityVal" id="cityVal" value="${infoList.city}">
									<input type="hidden" name="countyVal" id="countyVal" value="${infoList.county}">
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
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
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
				</table>
			</div>
			<input type="hidden" name="orderNo" id="orderNo" value="${orderno}"> <!-- 订单号 -->
			<input type="hidden" name="orderId" id="orderId" value="${orderId}"> <!-- 大订单id -->
			<input type="hidden" name="orderItemId" id="orderItemId" value="${orderItemId}">
			
			<input type="button" id="qrsh_biao" class="qrsh_biao" value="确认发货" onclick="qikanFahuo();"/>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>	 
		<script src="/manage/public/js/areaf.js" type="text/javascript"></script>
		<script type="text/javascript">
		var arr=[];
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
			//添加期刊发货单
			function qikanFahuo(){
				if(check()){
					updBtn();
				}
			}
			function updBtn(){
				$("#qrsh_biao").removeAttr("onclick");
				$("#qrsh_biao").css("background","#949494");
				loading(true);
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/order/saveQikanOrderInfo",
					data : {
							"orderNo" :${orderno},
							"orderId":${orderId},
							"orderItem":${orderItemId},
							"senderId":"1",
							"sendAddressId":$("#updFUserInfoId").val()==""?$('#sendAddressId').val():$("#updFUserInfoId").val(),
							"expressId":$("#wuliuCompany").val(),
							"expressNum":$("#wuliuNum").val(),
							"receivedName":$("#s_userName").val(),
							"receivedPhone":$("#s_phone").val(),
							"publishPlanId":$("#qiciId").val(),
							"province":$("#s_province").val(),
							"city":$("#s_city").val(),
							"county":$("#s_county").val(),
							"detailAddress":$("#s_address").val(),
							"buyCount":${buyCount},
							"qikanId":${productid} 
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
