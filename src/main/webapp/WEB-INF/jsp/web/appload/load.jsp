<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.xzBtn {
				width: 194px;
			}
		</style>
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="content">
		<div class="downloadContainer">
			<div class="downloadCon">
				<div class="topCon">
					<span>销售与市场</span>
					<a class="xiaZaiBtn" href="javascript:void(0)">下载应用</a>
					<a href="/home/index">首页</a>
				</div>
				<h1>随时随地，想听就听</h1>
				<p>销售与市场——一个专业的电子报刊平台，4.5亿用户的选择</p>
				<img class="mibileImg" src="/img/mobile.png" alt="" />
				<div class="ewmBox">
					<p>扫一扫安卓二维码下载，苹果或选择右方下载方式</p>
					<!-- <img src="/img/xiazaierweima.png" alt="" /> -->
					<div id="qrcode" style="width:100px;heigth:100px;border: 3px solid #fff; float: left;"></div>
					
					<div class="xzBtn" style="float: left;">
						<div class="xzItem oh">
							<img src="/img/appstore.png" alt="" />
							<a href="http://www.pgyer.com/fGw8"><p>App Store<br>IOS版下载</p></a>
						</div>
						<div class="xzItem oh">
							<img src="/img/android.png" alt="" />
							<a href="http://tzxl.kuguanyun.net/images/xsysc.apk"><p>Android<br>安卓版下载</p></a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</pxkj:Content>
	
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/jquery.qrcode.min.js"></script>
		<script type="text/javascript">
			//jQuery('#qrcode').qrcode("http://tzxl.kuguanyun.net/images/xsysc.apk");
			jQuery('#qrcode').qrcode({
			    /* render: "table", */
			    width: 100,
			    height: 100,
			    text: "http://tzxl.kuguanyun.net/images/xsysc.apk"
			});
		</script>
	</pxkj:Content>
</pxkj:ContentPage>