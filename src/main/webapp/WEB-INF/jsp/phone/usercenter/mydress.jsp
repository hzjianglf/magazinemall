<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="/usercenter/account/turnUserSet" class="a1">
			<img src="/images/fh_biao.png"class="fh_biao"></a>
			<h3>设置</h3>
		</div>
		<input type="hidden" value="${ids }" id="ids"></input>
		<div class="wddz_lb" style="margin-bottom: 80px;">
		<c:forEach items="${list }" var="item">
				<div class="wddz_nr" >
					<div onclick="turn()">
						<h3>
							<em>${item.phone }</em>${item.receiver }
						</h3>
						<h4>${item.province }${item.city }${item.county }${item.detailedAddress }</h4>
					</div>
					<h5>
						<a onclick="del(${item.Id})"><img src="/images/sc_biao.png" > 删除</a>
						<a onclick="edit(${item.Id})"><img src="/images/bj_biao.png" > 编辑</a>
						<span class="radio_box">
							<input type="radio" onclick="changeAddress(${item.Id})" id="radio_${item.Id }" name="radio" ${item.isDefault==1?'checked':'' } style="display:none">
							<label for="radio_${item.Id }"></label>
							&nbsp;&nbsp;
						</span>默认地址
					</h5>
				</div>
			</c:forEach>
		</div>
		<button class="qr_biao" onclick="add()">添加新地址</button>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			function turn(){
				if($("#ids").val()==null||$("#ids").val()==''){
					return ;
				}
			}
			function edit(id){
				window.location.href="/usercenter/account/turnAddAddress?id="+id;
			}
			function add(){
				window.location.href="/usercenter/account/turnAddAddress";
			}
			function del(id){
				var del = confirminfo("确定要删除吗？",function (){
					$.ajax({
						type : "POST",
						url : "/usercenter/account/delAddress",
						async : false,
						data : {
							"id" : id
						},
						dataType:"json",
						success : function(data) {
							if(data.success>0){
								tipinfo(data.msg);
								setTimeout(function(){ window.location.href="/usercenter/account/turnMyAddress"; },600);
							}
						},
						error : function(data) {
						}
					})
				},"json");
				
			}
			
			function changeAddress(id){
				$.ajax({
					type : "POST",
					url : "/usercenter/account/changeAddressDefault",
					async : false,
					data : {
						"id" : id
					},
					success : function(data) {
						tipinfo(data.msg);
					},
					error : function(data) {

					}
				});
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
