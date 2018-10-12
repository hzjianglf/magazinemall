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
			<h3>短信验证</h3>
		</div>
		<div class="zc">
			<ul>
				<li><input type="number" name="phoneNumber" placeholder="请输入手机号" class="in1 "><em>+86</em></li>
				<li><input type="text" name="code" placeholder="请输入验证码" class="in1 "><em><img src="/images/zc_biao3.png"></em>
					<a href="javascript:void(0);" id="a_getCode" class="wjmm" >获取验证码</a></li>
			    <li><button onclick="confirm();" type="button">确 认</button></li>
			    <li class="li1" ><a href="/usercenter/account/index">马上登录</a></li>
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
				var telenumber = $("input[name='phoneNumber']").val();
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
			        	 type:2,
			        	 telenumber:telenumber,
			        	 r:Math.random()
			         },function(json){
			        	tipinfo(json.msg);
			         },"json");
				}
			}
			//验证
			function confirm(){
				var phone = $("input[name='phoneNumber']").val();
				if(phone==null || phone==""){
					tipinfo("请输入手机号！");
					return false;
				}else if(!(/^1[34578]\d{9}$/.test(phone))){
					tipinfo("请输入正确的手机号！");
					$("#Tbx_Phone").val("");
					return false;
				}
				var code = $("input[name='code']").val();
				if(code==null || code==""){
					tipinfo("请输入验证码！");
					return false;
				}
				$.ajax({
					type:'post',
					data:{
						"telenumber":phone,
						"code":code
					},
					url:'/allow/Verification',
					datatype:'json',
					success:function(data){
						if(data.success>0){
							if(data.success==2){
								tipinfo(data.msg);
								window.location.href="/allow/register";
							}
							tipinfo(data.msg);
							window.location.href="/allow/toFindPassword?telenumber="+phone;
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