<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="zhdl zhdl_1">
			<img src="/images/dl_tu.png">
			<ul>
			   <li><input type="text" name="userName" id="userName" placeholder="手机号码/用户名" class="in1"></li>
			   <li><input type="password" name="userPass" id="userPass" placeholder="密码" class="in1"> <a href="/allow/toVerification" class="wjmm">忘记密码？</a></li>
			   <li><button onclick="login();">登 录</button></li>
			   <li><a href="/allow/quickLogin?redirectUrl=${redirectUrl }" class="a1">手机快速登录 </a><a href="/allow/register">注册</a></li>
			</ul>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			function login(){
				if(check()){
					$.ajax({
						type : "POST",
						url : " /allow/loginCheck",
						data : {"telenumber" : $("#userName").val(),"userPass":$("#userPass").val()},
						success : function(data) {
							if(data.result==1){
								tipinfo(data.msg);
								setTimeout(function(){
									window.location.href='${redirectUrl}';
								},1000);
							}else{
								tipinfo(data.msg);
								$("#userName").focus();
							}
						},
						error : function(data) {
							tipinfo("连接错误");
						}
					});
				}
			}
			function check(){
				var userName = $("#userName").val();
				var userPass = $("#userPass").val();
				var r = /^\+?[1-9][0-9]*$/;　　//正整数 
				var checkPhone = /^1[34578]\d{9}$/;//手机号格式
				if(userName==null || userName==""){
					tipinfo("请输入用户名或手机号！");
					$("#userName").focus();
					return false;
				}
				/* if(r.test(userName)){
					if(!(checkPhone.test(userName))){
						tipinfo("请输入正确的手机号！");
						$("#userName").val("").focus();
						return false;
					}
				} */
				if(userPass==null || userPass==""){
					tipinfo("请输入密码！");
					$("#userPass").focus();
					return false;
				}
				if(userPass.length<6){
					tipinfo("请输入六位以上密码！");
					$("#userPass").focus();
					return false;
				}
				return true;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>