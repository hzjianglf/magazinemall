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
			<a href="/usercenter/account/index" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>设置</h3>
		</div>
		<div class="sz_lb">
			<ul>
				<li><a href="/usercenter/account/turnMyphone">账号绑定</a></li>
				<li><a href="/setting/UpPassword">修改密码</a></li>
				<li><a href="/usercenter/account/turnMyAddress">我的地址</a></li>
			</ul>
			<ul>
				<li><a onclick="SpecialSet();">专栏设置</a></li>
				<li><input class="mui-switch" type="checkbox"> 推送设置</li>
			</ul>
			<ul>
				<li><input class="mui-switch" type="checkbox"> 断电续听</li>
				<li><input class="mui-switch" type="checkbox"> 2G/3G/4G播放和下载</li>
			</ul>
		</div>
		<button class="qr_biao" type="button" onclick="outlogin();">退出登录</button>
	</body>
      <div  id="login_box" style="display: none;" class="login_box"> 
   	 <ul>
   	 	<li><a href="#">不开启</a></li>
   	 	<li><a href="#">播完当前声音</a></li>
   	 	<li><a href="#">播完2集声音</a></li>
   	 	<li><a href="#">播完3集声音</a></li>
   	 	<li><a href="#">10分钟后</a></li>
   	 	<li><a href="#">20分钟后</a></li>
   	 	<li><a href="#">30分钟后</a></li>
   	 	<li><a href="#" onClick="deleteLogin()" class="gb_biao">关闭</a> </li>
   	 </ul>
   </div>

<div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript">
			//专栏设置
			function SpecialSet(){
				var userType = ${userType};
				if(userType=='1'){
					tipinfo("只有专栏作家才可以进行专栏设置");
					return false;
				}
				window.location.href="/setting/SpecialSet";
			}
			//退出登陆
			function outlogin(){
				window.location.href="/outLogin";
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
