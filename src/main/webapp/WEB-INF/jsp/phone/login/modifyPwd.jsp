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
			<h3>修改密码</h3>
		</div>
		<div class="zc">
			<ul>
				<li><input type="password" name="newPwd" placeholder="请输入密码" class="in1 "><em><img src="/images/zc_biao1.png"></em></li>
				<li><input type="password" name="password" placeholder="请确认密码" class="in1 "><em><img src="/images/zc_biao2.png"></em></li>
				<li><button onclick="confirm();" type="button">确 认</button></li>
				<li class="li1" ><a href="/usercenter/account/index">马上登录</a></li>
			</ul>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			//修改密码
			function confirm(){
				var pwd = $("input[name='newPwd']").val();
				if(pwd==null || pwd==""){
					tipinfo("请输入密码！");
					return false;
				}
				var pwdConfirm = $("input[name='password']").val();
				if(pwdConfirm==null || pwdConfirm==""){
					tipinfo("请确认密码！");
					return false;
				}
				if(pwd!=pwdConfirm){
					tipinfo("两次密码不正确！");
					return false;
				}
				$.ajax({
					type:'post',
					data:{
						"telenumber":${telenumber },
						"newPwd":pwd,
						"password":pwdConfirm
					},
					url:'/allow/findPassword',
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
			
		</script>
	</pxkj:Content>
</pxkj:ContentPage>