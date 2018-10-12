<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="zhdl zhdl_2">
			<ul>
			   <li><input type="text" id="Tbx_Phone" placeholder="请输入手机号" class="in1 in2"><em>+86</em></li>
			   <li><input type="text" id="Tbx_Code" placeholder="短信验证码" class="in1"> <a href="javascript:void(0);" id="a_getCode" class="wjmm hqyzm " >获取验证码</a></li>
			   <li><button onclick="quickLogin()">登 录</button></li>
			   <li class="li1" ><a href="/allow/login">账号密码登录</a></li>
			</ul>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$(function() {
				$("#a_getCode").bind("click",function(){
					textCode();
				})
			});
			function quickLogin(){
				var telenumber = $("#Tbx_Phone").val();
				var code = $("#Tbx_Code").val();
				if(telenumber==null || telenumber==""){
					tipinfo("请输入手机号！");
					return false;
				}
				else if(!(/^1[34578]\d{9}$/.test(telenumber))){
					tipinfo("请输入正确的手机号！");
					$("#Tbx_Phone").val("");
					return false;
				}
				if(code==null || code==""){
					tipinfo("请输入验证码！");
					return false;
				}
				$.ajax({
					type : "POST",
					url : " /allow/quickLoginRegister",
					data : {"telenumber" : telenumber,"code":code},
					success : function(data) {
						if(data.result==1){
							tipinfo('登录成功');
							setTimeout(function(){
								window.location.href='${redirectUrl}';
							},1000);
						}else{
							tipinfo('登录失败');
							$("#Tbx_Phone").focus();
						}
					},
					error : function(data) {
						tipinfo("连接错误");
					}
				});
			}
			var time = 0;
	        var sh;
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
	        
			//获取短信验证码
			function textCode() {
				var telenumber = $("#Tbx_Phone").val();
				if(telenumber==null || telenumber==""){
					tipinfo("请输入手机号！");
					return false;
				}
				else if(!(/^1[34578]\d{9}$/.test(telenumber))){
					tipinfo("请输入正确的手机号！");
					$("#Tbx_Phone").val("");
					return false;
				}
				else{
					 $("#a_getCode").unbind("click");
			         time = 90;
			         sh = setInterval(changetimertext, 1000);
			         $.get("/allow/sendSms",{
			        	 type:1,
			        	 telenumber:telenumber,
			        	 r:Math.random()
			         },function(json){
			        	 tipinfo(json.msg);
			         },"json");
				}
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>