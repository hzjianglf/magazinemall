<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			p{
				    /*每个P段落，首行空出两个空格，即缩进两个字符*/
				text-indent:2em;
				line-height:30px !important;
			}
			img {
				max-width: 95%; /*图片自适应宽度*/
				margin:15px auto;
			}
			p img {
				 position: relative;
				 text-indent:0em;
				 left: -10%;
			}
			p strong{
				 position: relative;
			}
			body {
				overflow-y: scroll !important;
			}
			.view {
				word-break: break-all;
			}
			.vote_area {
				display: block;
			}
			.vote_iframe {
				background-color: transparent;
				border: 0 none;
				height: 100%;
			}
			#edui1_imagescale{display:none !important;} /*去除点击图片后出现的拉伸边框*/
			element.style {
				text-indent:0em;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a onclick="back();" class="a1" style="margin-top: -13px;"><img src="/images/fh_biao.png" class="fh_biao"></a>
		</div>
		<h4 style="margin: 5% auto;text-align: center;width:95%;">${Title}</h4>
		<div style="margin:0px auto;font-size: 18px;margin-top: 6%;width:85% ;">
			${MainText}
		</div>
		<%-- <div>
			<img alt="" src="${FinalPic}">
		</div> --%>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script>
			function back(){
				window.history.go(-1);  	
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
