<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a onclick="fanhui();" class="a1"><img src="/images/fh_biao.png" class="fh_biao"> </a>
			<!-- <a href="#" class="a2"><img src="/images/fx_biao.png" class="fx_biao"></a> -->
		</div>
		<div class="wgxq">
			<h3>${title }</h3>
			<div class="wgxq_nr">
				${presentation }
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			function fanhui(){
				window.history.go(-1);
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
