<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="px"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<px:MasterPage id="WebMaster">
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<title>${SEO2 }${SEO.title }</title>
<meta name="apple-mobile-web-app-status-bar-style" content="black" />
<meta name="keywords" content="${SEO.metaKeywords}" />
<meta name="description" content="${SEO.metaDescription}" />
<link rel="stylesheet" href="/css/swiper.min.css" />
<link href="/public/layui/css/layui.css" rel="stylesheet">
<link rel="stylesheet" href="/css/global.css" />
<style type="text/css">
	.layui-m-layerbtn span[yes] {
		margin: 15px auto;
	}
	
	.layui-m-layer-footer .layui-m-layerbtn span {
		background-color: rgba(255, 255, 255, .8);
		height: 50px;
		line-height: 50px;
	}
	.fenleiList li{
		cursor:pointer;
	}
	#UserDataBox2 {
    width: 710px;
    height: 492px;
    background: #fff;
    position: fixed;
    z-index: 11;
    display: none;
	}
	#UserDataBox2>.title {
	    font-size: 3em;
	    color: #FF9966;
	    height: 92px;
	    line-height: 92px;
	    text-align: center;
	    position: relative;
	    width: 100%;
	}
	.closeWin2 {
	    position: absolute;
	    right: 15px;
	    top: 24px;
	}
	.layui-layer-content{
		color:#fff;
	}
	.friendslink {
		width: 100%;
		height: 60px;
		background: #007db8;
		text-align: center;
		margin-top: 120px;
	}
	.friendslink span , .friendslink a {
		font-size: 16px;
		color: #fff;
		line-height: 60px;
	}
	.footer {
		height: 140px;
		padding-top: 40px;
		background: #ccc;
		text-align: center;
	}
	
	.footer p,
	.footer a,
	.footer span {
		font-size: 15px;
		line-height: 36px;
		color: #333;
		text-align: center;
	}
	.yanZhengMa>input {
	    width: 165px;
	}
	.yanZhengMa>input {
	    width: 165px;
	}
	.footer {
	    height: 140px;
	    padding-top: 40px;
	    background: #ccc;
	    text-align: center;
	    position: absolute;
	    width: 100%;
	}
</style>
<px:ContentPlaceHolder id="css"></px:ContentPlaceHolder>
</head>
<body>
	<c:if test="${empty requestScope.headers || requestScope.headers }">
		<div class="topNav">
			<div class="navCon">
				<div class="logo">
					<a href="/home/index"><img src="/img/logo.png" alt="" /></a>
				</div>
				<ul class="navList">
					<li><a href="/home/index" data-val="/home/index">发现</a></li>
					<li><a href="javascript:void(0)" data-val="/usercenter/account/inspectUserId" id="myself">我的</a></li>
					<li><a href="/appLoad/appLoadSite" data-val="/appLoad/appLoadSite">APP下载</a></li>
					<li>商城</li>
				</ul>
				<div class="searchBox">
					<input type="text" id="searchName" placeholder="搜索专辑、声音、作家" />
					<span>
						<img onclick="search()" src="/img/searchBtn.png" alt="" />
					</span>
				</div>
			</div>
		</div>
		<div class="topFenLei">
			<div class="handleBox">
				<ul class="fenleiList">
					<li><a href="/home/index">热门推荐</a></li>
					<li><a href="/home/toClass">课程</a></li>
					<li><a href="/home/toQikan">期刊</a></li>
					<li><a href="/home/expert/toExpert">专栏作家</a></li>
				</ul>
				<div class="login">
					<c:if test="${sessionScope.nickName == null}">
						<a class="loginBtnItem" data-state="0" data-target="LoginBox" href="javascript:void(0)">登录</a>
						<b>|</b>
						<a class="loginBtnItem" data-state="0" data-target="RegisterBox" href="javascript:void(0)">注册</a>
					</c:if>
					<c:if test="${sessionScope.nickName != null}">
						<a href="/order/turnShopcart"><img src="/img/shopCarIcon.png"/></a>
						<a href="/usercenter/account/index" class="loginBtnItem" data-state="1"><%=request.getSession().getAttribute("nickName")%></a>
						<b>|</b>
						<a class="loginBtnItem" data-state="1" data-target="logout" onclick ="outlogin()">退出登录</a>
					</c:if>
				</div>
			</div>
		</div>
		<div id="dia"></div>
		<div id="UserDataBox">
			<h1 class="title">
				销售与市场
				<img class="closeWin" src="/img/closeWin.png"/>
			</h1>
			<div class="formCon">
				<div id="LoginBox" class="form-item">
					<ul class="loginType">
						<li class="active"><span>账号登录</span></li>
						<li><span>手机号登录</span></li>
					</ul>
					<div class="loginForm">
						<div class="loginItem show">
							<div class="inputItem">
								<span>
									<img src="/img/user.png" alt="" />
								</span>
								<input type="text" name="userName" id="userName" placeholder="手机号码/用户名" />
							</div>
							<div class="inputItem">
								<span>
									<img src="/img/pwd2.png" alt="" />
								</span>
								<input type="password" name="userPass" id="userPass" placeholder="密码" />
							</div>
							<div class="jiZhuMiMa">
								<!-- <input type="checkbox" />下次自动登录 -->
								<a class="forgetpwd" href="javascript:void(0)">忘记密码？</a>
							</div>
							<button id="loginBtn" onclick="loginByPC();">登录</button>
							<div class="jiZhuMiMa gotoRes">
								<a class="goToRegister" href="javascript:void(0)">注册</a>
								<span>没有账号？</span>
							</div>
						</div>
						<div class="loginItem">
							<div class="inputItem">
								<span>
									<img src="/img/user.png" alt="" />
									+86
								</span>
								<input type="text" id="Tbx_Phone" placeholder="请输入手机号码" />
							</div>
							<div class="inputItem yanZhengMa">
								<span>
									<img src="/img/pwd.png" alt="" />
								</span>
								<input type="text" id="Tbx_Code" placeholder="验证码" />
								<a class="getCode" href="javascript:void(0)" id="a_getCode">获取验证码</a>
							</div>
							<button id="loginBtn" onclick="quickLogin()">登录</button>
							<div class="jiZhuMiMa gotoRes">
								<a class="goToRegister" href="javascript:void(0)">注册</a>
								<span>没有账号？</span>
							</div>
						</div>
					</div>
				</div>
				<div id="RegisterBox" class="form-item">
					<div class="loginForm">
						<div class="inputItem">
							<span>
									<img src="/img/user.png" alt="" />
								</span>
							<input type="text" id="regis_Phone" placeholder="手机号码" />
						</div>
						<div class="inputItem">
							<span>
								<img src="/img/pwd2.png" alt="" />
							</span>
							<input type="password" id="regis_Password" placeholder="密码" />
						</div>
						<div class="inputItem">
							<span>
									<img src="/img/pwd2.png" alt="" />
								</span>
							<input type="password" id="regis_PasswordConfirm" placeholder="确认密码" />
						</div>
						<div class="inputItem yanZhengMa">
							<span>
									<img src="/img/pwd.png" alt="" />
								</span>
							<input type="text" id="regis_Code" placeholder="验证码" />
							<a class="getCode" href="javascript:void(0)" id="regis_Code1">获取验证码</a>
						</div>
						<div class="jiZhuMiMa">
							<input type="checkbox" id="agreement"/>已阅读用户协议
						</div>
						<button id="loginBtn" onclick="register();" type="button">注册</button>
						<div class="jiZhuMiMa gotoRes">
							<a class="goToLogin" href="javascript:void(0)">登录</a>
							<span>已有账号？</span>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 忘记密码弹框 -->
		<div id="UserDataBox2">
			<h1 class="title">
				销售与市场
				<img class="closeWin2" src="/img/closeWin.png"/>
			</h1>
			<div class="formCon">
				<div id="RegisterBox2">
					<div class="loginForm">
						<div class="inputItem">
							<span>
									<img src="/img/user.png" alt="" />
								</span>
							<input type="text" name="phoneNumber" id = "forg_phone" placeholder="手机号码" />
						</div>
						<div class="inputItem">
							<span>
									<img src="/img/pwd2.png" alt="" />
								</span>
							<input type="password" name="newPwd_forget" placeholder="新密码" />
						</div>
						<div class="inputItem">
							<span>
									<img src="/img/pwd2.png" alt="" />
								</span>
							<input type="password" name="password_forget" placeholder="确认新密码" />
						</div>
						<div class="inputItem yanZhengMa">
							<span>
									<img src="/img/pwd.png" alt="" />
								</span>
							<input type="text" name="code" placeholder="验证码" />
							<a class="getCode" href="javascript:void(0)" id="forget_getCode">获取验证码</a>
						</div>
						<button id="loginBtn" onclick="confirm_forget();" type="button">确认</button>
						<div class="jiZhuMiMa gotoRes">
							<a class="goToLoginPass" href="javascript:void(0)">注册</a>
							<span>没有账号？</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</c:if>
<px:ContentPlaceHolder id="content"></px:ContentPlaceHolder>
<c:if test="${empty requestScope.foots || requestScope.foots }">
	<c:if test="${requestScope.displayYou }">
	<div class="friendslink">
		<span>友情链接：</span>
		<!-- <a href="#">戴尔京东专卖店</a>  <a href="#">淘宝专卖店</a> <a href="#">戴尔京东专卖店</a>  <a href="#">淘宝专卖店</a> -->
	</div>
	</c:if>
	<div class="footer">
		<!-- <div>
			<a href="#">关于我们</a>　|
			<a href="#">联系我们</a>　|
			<a href="#">网站声明</a>　|
			<a href="#">广告案例</a>　|
			<a href="#">网站纠错</a>
		</div> -->
	</div>
</c:if>
	<script type="text/javascript" src="/public/js/jquery-1.11.3.js"></script>
	<script type="text/javascript" src="/public/layui/layui.js"></script>
	<script type="text/javascript">
	var layer;
	layui.use('layer', function(){
		layer = layui.layer;
	});
	function tipinfo(obj){
		layer.msg(obj);
	}
	$(function(){
		var wHeight = $(window).height();
		var wWidth = $(window).width();
		$('#UserDataBox').css({
			"top": (wHeight - 492) / 2,
			"left": (wWidth - 710) / 2
		})
		$('#UserDataBox2').css({
			"top": (wHeight - 492) / 2,
			"left": (wWidth - 710) / 2
		})
		$.each($('.fenleiList li a'),function(index,value){
			$(this)[0].pathname==location.pathname?$(this).css("color","orange"):'';
		})
		$.each($('.navList li a'),function(index,value){
			$(this).data('val').substring(0,5)==location.pathname.substring(0,5)?$(this).parent().css("background","#FF6633"):'';
		})
		var headers = '${headers}';
		if(headers != "false"){
			$('.navList li a').eq(0).data('val').substring(0,5)==location.pathname.substring(0,5)?$('.fenleiList').show():$('.fenleiList').hide();
		}
		//底部配置信息
		siteInfo();
		//栏目
		lanmu();
		//热点链接
		linkFirend();
	});
	//友情链接
	function linkFirend(){
		var foots = '${displayYou }';
		if(foots == "true"){
			$.ajax({
				type:'post',
				url:'/home/linkFriendData',
				dataType:'json',
				success:function(data){
					var html="";
					for(var i = 0 ; i < data.list.length ; i++ ){
						html += "<a href='"+data.list[i].LinkUrl+"'>"+data.list[i].LinkName+"</a>";
					}
					$('.friendslink').append(html);
				}
			});
		}
	}
	//获取配置信息
	function siteInfo(){
		var foots = '${foots}';
		if(foots==""){
			$.ajax({
				type:'post',
				url:'/home/setModel',
				dataType:'json',
				success:function(data){
					var html="<p>版权所有："+data.siteInfo.copyRight+"</p> <p>联系电话："+data.siteInfo.siteTel+" 办公地址："+data.siteInfo.address+"</p>";
					$('.footer').append(html);
				}
			});
		}
	}
	//获取关于我们栏目
	function lanmu(){
		var foots = '${foots}';
		if(foots==""){
			$.ajax({
				type:'post',
				url:'/home/columnList',
				datatype:'json',
				success:function(data){
					var clist = data.list;
					var content = "<div>";
					for(var i = 0 ; i < clist.length ; i++){
						content += "<a href=/home/selcolumn?catId="+clist[i].catId+">"+clist[i].catName+"</a> 　|";
					}
					content += "</div>"
					$(".footer").append(content);
				}
			});
		}
	}
	
	$('.goToQuicklyLogin').click(function(){
		$('.loginItem').removeClass('show');
		$(this).parents('.loginItem').siblings().addClass('show');
		$('.loginType li').removeClass('active');
		$('.loginType li:eq(0)').addClass('active');
	})
	$('#myself').click(function(){
		//异步检查是否登录
		$.ajax({
			type:'post',
			url:'/usercenter/account/inspectUserId',
			data:{},
			dataType:'json',
			success:function(data){
				if(!data.result){
					tipinfo(data.msg);
				}else{
					location.href="/usercenter/account/index"
				}
			}
		});
	});
	
	//注册
	function register(){
		//手机号
		var phone = $("#regis_Phone").val();
		if(phone==null || phone==""){
			tipinfo("请输入手机号！");
			return false;
		}else if(!(/^1[34578]\d{9}$/.test(phone))){
			tipinfo("请输入正确的手机号！");
			$("#regis_Phone").val("");
			return false;
		}
		var pwd = $("#regis_Password").val();
		if(pwd==null || pwd==""){
			tipinfo("请输入密码！");
			return false;
		}
		var pwdConfirm = $("#regis_PasswordConfirm").val();
		if(pwdConfirm==null || pwdConfirm==""){
			tipinfo("请输入密码！");
			return false;
		}
		var code = $("#regis_Code").val();
		if(code==null || code==""){
			tipinfo("请输入验证码！");
			return false;
		}
		var agreement = $("#agreement").is(":checked");
		if(!agreement){
			tipinfo("请勾选<<用户协议>>");
			return false;
		}
		
		$.ajax({
			type:'post',
			data:{"phone":phone,"pwd":pwd,"pwdConfirm":pwdConfirm,"code":code},
			url:'/login/registerSave',
			datatype:'json',
			success:function(data){
				if(data.result){
					tipinfo(data.msg);
					$('.formCon>div').removeClass("show");
					$('#LoginBox').addClass("show");
				}else{
					tipinfo(data.msg);
				}
			},
			error:function(){
				tipinfo("出错了!");
			}
		})
	}
	
	
	//忘记密码点击确定
	function confirm_forget(){
		var phone = $("input[name='phoneNumber']").val();
		if(phone==null || phone==""){
			tipinfo("请输入手机号！");
			return false;
		}else if(!(/^1[34578]\d{9}$/.test(phone))){
			tipinfo("请输入正确的手机号！");
			$("#Tbx_Phone").val("");
			return false;
		}
		var pwd = $("input[name='newPwd_forget']").val();
		if(pwd==null || pwd==""){
			tipinfo("请输入密码！");
			return false;
		}
		var pwdConfirm = $("input[name='password_forget']").val();
		if(pwdConfirm==null || pwdConfirm==""){
			tipinfo("请确认密码！");
			return false;
		}
		if(pwd!=pwdConfirm){
			tipinfo("两次密码不正确！");
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
				"newPwd":pwd,
				"password":pwdConfirm,
				"telenumber":phone,
				"code":code
			},
			url:'/login/findPassword',
			datatype:'json',
			success:function(data){
				if(data.success>0){
					//tipinfo(data.msg);
					$('#UserDataBox2').hide();
					$('#UserDataBox').show();
				}else{
					tipinfo(data.msg);
				}
			},
			error:function(){
				tipinfo("出错了!");
			}
		})
	} 
	//点击验证码
	$("#a_getCode").bind("click",function(){
		textCode();
	})
	//忘记密码-点击验证码
	$("#forget_getCode").bind("click",function(){
		textCode1();
	})
	//注册-点击验证码
	$("#regis_Code1").bind("click",function(){
		textCode2();
	})
	
	//忘记密码-点击验证码
	function textCode1() {
		var telenumber = $("#forg_phone").val();
		if(telenumber==null || telenumber==""){
			tipinfo("请输入手机号！");
			return false;
		}
		else if(!(/^1[34578]\d{9}$/.test(telenumber))){
			tipinfo("请输入正确的手机号！");
			$("#forg_phone").val("");
			return false;
		}
		else{
			 $("#forget_getCode").unbind("click");
	         time1 = 90;
	         sh1 = setInterval(changetime1rtext1, 1000);
	         $.get("/phone/allow/sendSms",{
	        	 type:2,
	        	 telenumber:telenumber,
	        	 r:Math.random()
	         },function(json){
	        	 tipinfo(json.msg);
	         },"json");
		}
	}
	var time1 = 0;
    var sh1;
    function changetime1rtext1() {
        if (time1 == 0) {
            $("#forget_getCode").text("获取验证码");
            $("#forget_getCode").bind("click",function(){
            	textCode1();
            });
            clearInterval(sh1);
            return;
        }
        $("#forget_getCode").text(time1-- + "后重新获取");
    }
	
	
	
    function textCode2() {
		var telenumber = $("#regis_Phone").val();
		if(telenumber==null || telenumber==""){
			tipinfo("请输入手机号！");
			return false;
		}
		else if(!(/^1[34578]\d{9}$/.test(telenumber))){
			tipinfo("请输入正确的手机号！");
			$("#regis_Phone").val("");
			return false;
		}
		else{
			 $("#regis_Code1").unbind("click");
	         time2 = 90;
	         sh2 = setInterval(changetime1rtext2, 1000);
	         $.get("/phone/allow/sendSms",{
	        	 type:1,
	        	 telenumber:telenumber,
	        	 r:Math.random()
	         },function(json){
	        	 tipinfo(json.msg);
	         },"json");
		}
	}
	var time2 = 0;
    var sh2;
    function changetime1rtext2() {
        if (time2 == 0) {
            $("#regis_Code1").text("获取验证码");
            $("#regis_Code1").bind("click",function(){
            	textCode2();
            });
            clearInterval(sh2);
            return;
        }
        $("#regis_Code1").text(time2-- + "后重新获取");
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
	         $.get("/phone/allow/sendSms",{
	        	 type:0,
	        	 telenumber:telenumber,
	        	 r:Math.random()
	         },function(json){
	        	 tipinfo(json.msg);
	         },"json");
		}
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
	//手机号登陆
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
			url : " /login/quickLoginRegister",
			data : {"telenumber" : telenumber,"code":code},
			success : function(data) {
				if(data.result==1){
					tipinfo('登录成功');
					/* setTimeout(function(){
						window.location.href='${redirectUrl}';
					},1000); */
					$('#UserDataBox').hide();
					window.location.href="/home/index";
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
	
	
	
	//帐号登陆
	function loginByPC(){
		if(check()){
			$.ajax({
				type : "POST",
				url : " /login/loginCheck",
				data : {"telenumber" : $("#userName").val(),"userPass":$("#userPass").val()},
				success : function(data) {
					if(data.result==1){
						tipinfo(data.msg);
						/* setTimeout(function(){
							window.location.href='${redirectUrl}';
						},1000); */
						$('#UserDataBox').hide();
						window.location.href="/home/index";
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
	$('.loginType li').click(function() {
		$(this).addClass('active').siblings().removeClass("active");
		var index = $(this).index();
		$('.loginForm>div:eq(' + index + ')').addClass('show').siblings().removeClass('show');
		$('#UserDataBox').css({
			"top": (wHeight - 492) / 2,
			"left": (wWidth - 710) / 2
		})
		$('#UserDataBox2').css({
			"top": (wHeight - 492) / 2,
			"left": (wWidth - 710) / 2
		})
	})
	window.onresize = function() {
		var wHeight = $(window).height();
		var wWidth = $(window).width();
		$('#UserDataBox').css({
			"top": (wHeight - 492) / 2,
			"left": (wWidth - 710) / 2
		})
		$('#UserDataBox2').css({
			"top": (wHeight - 492) / 2,
			"left": (wWidth - 710) / 2
		})
	}
	$('.login a.loginBtnItem').click(function(){
		if($(this).attr('data-state') == "0"){
			$('#dia').show();
			$('#UserDataBox').show();
			var TarName = $(this).attr('data-target');
			$('#'+TarName).addClass('show').siblings().removeClass("show");	
		}
	})
	$('.closeWin').click(function(){
		$('#dia').hide();
		$('#UserDataBox').hide();
	})
	$('.closeWin2').click(function(){
		$('#dia').hide();
		$('#UserDataBox2').hide();
	})
	$('.goToRegister').click(function(){
		$('.formCon>div').removeClass("show");
		$('#RegisterBox').addClass("show");
	})
	$('.goToRegister').click(function(){
		$('.formCon>div').removeClass("show");
		$('#RegisterBox').addClass("show");
	})
	$('.goToLoginPass').click(function(){
		$('#UserDataBox2').hide();
		$('#UserDataBox').show();
		$('.formCon>div').removeClass("show");
		$('#RegisterBox').addClass("show");
	})
	$('.goToLogin').click(function(){
		$('.formCon>div').removeClass("show");
		$('#LoginBox').addClass("show");
	})
	$('.forgetpwd').click(function(){
		$('#UserDataBox').hide();
		$('#UserDataBox2').show();
	})
	
	//退出登陆
	function outlogin(){
		$('#UserDataBox').hide();
		$('.formCon>div').removeClass("show");
		tipinfo("操作成功")
		setTimeout(function(){window.location.href="/login/outLogin";}, 600);
		
	}
	
	//搜索
	function search(){
		var name = $("#searchName").val();
		if(name == ""){
			tipinfo("请输搜索的内容");
			return ;
		}
		location.href = "/home/searchContentByName?name="+name;
	}
</script>
<px:ContentPlaceHolder id="js"></px:ContentPlaceHolder>
</body>
</html>
</px:MasterPage>