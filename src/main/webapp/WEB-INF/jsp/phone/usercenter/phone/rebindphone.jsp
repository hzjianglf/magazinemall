<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>手机绑定</h3>
		</div>
		<div class="xgzl">
			<ul>
				<li>
					<span>旧手机号</span>
					<input type="text" class="in1" name="oldPhone" id="oldPhone" placeholder="请输入当前手机号"/>
				</li>
				<li>
					<span>新手机号</span>
					<input type="text" class="in1" name="newPhone" id="newPhone" placeholder="请输入新手机号"/>
				</li>
				<li><input type="text" id="Tbx_Code" placeholder="请输入验证码" class="in1 "><em><img src="/images/zc_biao3.png"></em>
					<a href="javascript:void(0);" id="a_getCode" class="wjmm" >获取验证码</a></li>
			</ul>
		</div>
        <button class="qr_biao1" type="button" onclick="savePhone();">确 认</button>
        <!-- <a href="" class="wjmm_biao">忘记密码？</a> -->
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			function savePhone(){
				
				var oldPhone=$("#oldPhone").val();
				if(oldPhone==null||oldPhone==''){
					tipinfo("旧手机号不能为空!");
					return false;
				}else if(!(/^1[34578]\d{9}$/.test(oldPhone))){
					tipinfo("请输入正确的手机号！");
					$("#oldPhone").val("");
					return false;
				}
				var newPhone=$("#newPhone").val();
				if(newPhone==null||newPhone==''){
					tipinfo("新手机号不能为空!");
					return false;
				}else if(!(/^1[34578]\d{9}$/.test(newPhone))){
					tipinfo("请输入正确的手机号！");
					$("#newPhone").val("");
					return false;
				}
				var Tbx_Code=$("#Tbx_Code").val();
				if(Tbx_Code==null||Tbx_Code==''){
					tipinfo("验证码不能为空!");
				}
				
				$.ajax({
					type:'post',
					url:'/usercenter/account/updatePhone',
					data:{"oldPhone":oldPhone,"newPhone":newPhone,"Tbx_Code":Tbx_Code},
					datatype:'json',
					success:function(data){
						if(data.success){
							tipinfo(data.msg);
							window.location.href="/usercenter/account/index";
						}else{
							tipinfo(data.msg);
						}
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
				
			}
			
			
			$(function() {
				$("#a_getCode").bind("click",function(){
					textCode();
				})
				
			}); 
			
			var time = 0;
	        var sh;
	        
			//获取短信验证码
			function textCode() {
				
				var telenumber = $("#oldPhone").val();
				var newTelenumber = $("#newPhone").val();
				if(telenumber==null || telenumber==""){
					tipinfo("请输旧入手机号！");
					return false;
				}
				else if(!(/^1[34578]\d{9}$/.test(telenumber))){
					tipinfo("请输入正确的手机号！");
					$("#oldPhone").val("");
					return false;
				}else if(newTelenumber==null || newTelenumber==""){
					tipinfo("请输入新手机号！");
					return false;
				}
				else if(!(/^1[34578]\d{9}$/.test(newTelenumber))){
					tipinfo("请输入正确的手机号！");
					$("#newPhone").val("");
					return false;
				}
				else{
					 $("#a_getCode").unbind("click");
			         time = 90;
			         sh = setInterval(changetimertext, 1000);
			         $.get("/usercenter/account/sendSms",{
			        	 type:1,
			        	 telenumber:telenumber,
			        	 r:Math.random()
			         },function(json){
			        	 tipinfo(json.msg);
			         },"json");
				}
			}
			
			function changetimertext() {
	            if (time == 0) {
	                $("#a_getCode").text("获取验证码");
	                $("#a_getCode").bind("click",function(){
	                	textCode();
	                });
	                clearInterval(sh);
	                return;
	            }
	            $("#a_getCode").text(time-- + "后重新获取");
	        }
		</script>
	</pxkj:Content>
</pxkj:ContentPage>


