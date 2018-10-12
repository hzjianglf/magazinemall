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
			<h3>专栏设置</h3>
		</div>
		<div class="sz_lb">
			<ul>
				<li><span><input type="text" id="realname" style="border: none;text-align: right;" value="${realname }"/></span>真实姓名</li>
				<li><span><input type="text" id="identitynumber" style="border: none;text-align: right;" value="${identitynumber }"/></span>身份证号</li>
				<li><span><input type="text" id="questionPrice" style="border: none;text-align: right;" value="${questionPrice }"/></span>问答价格(￥)</li>
				<li><span><input type="text" id="bankCard" style="border: none;text-align: right;width: 200px;" value="${cardNo }"/></span>银行卡号</li>
			</ul>
		</div>
		<button class="qr_biao1" type="button" onclick="savePost();">确 认</button>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			/* $("#bankCard").on("keyup",function(){
		         //获取当前光标的位置
		         var caret = this.selectionStart;
		         //获取当前的value
		         var value = this.value;
		         //从左边沿到坐标之间的空格数
		         var sp =  (value.slice(0, caret).match(/\s/g) || []).length;
		         //去掉所有空格
		         var nospace = value.replace(/\s/g, '');
		         //重新插入空格
		         var curVal = this.value = nospace.replace(/\D+/g,"").replace(/(\d{4})/g, "$1 ").trim();
		         //从左边沿到原坐标之间的空格数
		         var curSp = (curVal.slice(0, caret).match(/\s/g) || []).length;
		         //修正光标位置
		         this.selectionEnd = this.selectionStart = caret + curSp - sp;
		     }); */
		     function savePost(){
		    	 var realname=$("#realname").val();
		    	 var identitynumber=$("#identitynumber").val();
		    	 var questionPrice=$("#questionPrice").val();
		    	 var cardNo=$("#bankCard").val();
		    	 $.ajax({
		    		 type:'post',
		    		 url:'/setting/addSet',
		    		 data:{"realname":realname,"identitynumber":identitynumber,"questionPrice":questionPrice,"cardNo":cardNo},
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
