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
		<div class="xgzl">
			<ul>
				<li>
					<span>旧密码</span>
					<input type="password" class="in1" name="oldPwd" id="oldPwd" placeholder="请输入当前密码"/>
				</li>
				<li>
					<span>新密码</span>
					<input type="password" class="in1" name="newPwd" id="newPwd" placeholder="请输入新密码"/>
				</li>
				<li>
					<span>确认密码</span>
					<input type="password" class="in1" name="confirmNewPwd" id="confirmNewPwd" placeholder="请确认新密码"/>
				</li>
			</ul>
		</div>
        <button class="qr_biao1" type="button" onclick="savePwd();">确 认</button>
        <a href="/allow/toVerification" class="wjmm_biao">忘记密码？</a>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			function savePwd(){
				var oldPwd=$("#oldPwd").val();
				if(oldPwd==null||oldPwd==''){
					tipinfo("旧密码不能为空!");
				}
				var newPwd=$("#newPwd").val();
				if(newPwd==null||newPwd==''){
					tipinfo("新密码不能为空!");
				}
				var confirmNewPwd=$("#confirmNewPwd").val();
				if(confirmNewPwd==null||confirmNewPwd==''){
					tipinfo("确认新密码不能为空!");
				}
				if(oldPwd == newPwd){
					tipinfo("旧密码与新密码不能相同!");
					return;
				}
				$.ajax({
					type:'post',
					url:'/updatePwd',
					data:{"oldPwd":oldPwd,"newPwd":newPwd,"confirmNewPwd":confirmNewPwd},
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
