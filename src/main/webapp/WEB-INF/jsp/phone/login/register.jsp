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
			<h3>注册</h3>
		</div>
		<div class="zc">
			<ul>
				<li><input type="text" placeholder="国家与地区" class="in1 in2"><select><option>中国</option></select></li>
				<li><input type="number" id="Tbx_Phone" placeholder="请输入手机号" class="in1 "><em>+86</em></li>
				<li><input type="password" id="Tbx_Password" placeholder="请输入密码" class="in1 "><em><img src="/images/zc_biao1.png"></em></li>
				<li><input type="password" id="Tbx_PasswordConfirm" placeholder="请确认密码" class="in1 "><em><img src="/images/zc_biao2.png"></em></li>
				<li><input type="text" id="Tbx_Code" placeholder="请输入验证码" class="in1 "><em><img src="/images/zc_biao3.png"></em>
					<a href="javascript:void(0);" id="a_getCode" class="wjmm" >获取验证码</a></li>
			    <li><button onclick="register();" type="button">注 册</button></li>
			    <li class="li1" ><a href="/usercenter/account/index">马上登录</a></li>
			</ul>
			<div class="tksm"><input type="checkbox" id="agreement">《销售与市场杂志注册协议及版权声明》</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$(function() {
				$("#a_getCode").bind("click",function(){
					textCode();
				})
			});
			
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
			         $.get("/allow/sendSms",{			        	 type:1,
			        	 telenumber:telenumber,
			        	 r:Math.random()
			         },function(json){
			        	 tipinfo(json.msg);
			         },"json");
				}
			}
			//注册
			function register(){
				//手机号
				var phone = $("#Tbx_Phone").val();
				if(phone==null || phone==""){
					tipinfo("请输入手机号！");
					return false;
				}else if(!(/^1[34578]\d{9}$/.test(phone))){
					tipinfo("请输入正确的手机号！");
					$("#Tbx_Phone").val("");
					return false;
				}
				var pwd = $("#Tbx_Password").val();
				if(pwd==null || pwd==""){
					tipinfo("请输入密码！");
					return false;
				}
				var pwdConfirm = $("#Tbx_PasswordConfirm").val();
				if(pwdConfirm==null || pwdConfirm==""){
					tipinfo("请输入密码！");
					return false;
				}
				var code = $("#Tbx_Code").val();
				if(code==null || code==""){
					tipinfo("请输入验证码！");
					return false;
				}
				var agreement = $("#agreement").is(":checked");
				if(!agreement){
					tipinfo("请勾选<<销售与市场杂志注册协议及版权声明>>");
					return false;
				}
				
				$.ajax({
					type:'post',
					data:{"phone":phone,"pwd":pwd,"pwdConfirm":pwdConfirm,"code":code},
					url:'/allow/registerSave',
					datatype:'json',
					success:function(data){
						if(data.result){
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
			
		</script>
	</pxkj:Content>
</pxkj:ContentPage>