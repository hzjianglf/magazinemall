<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style>
			* {
				margin: 0;
				padding: 0;
			}
			
			body {
				font-size: 12px;
				font-family: "宋体", Arial, Verdana;
				color: #000;
			}
			
			a:link {
				text-decoration: none;
			}
			
			.title {
				text-align: center;
				font-size: 18px;
				line-height: 50px;
				font-weight: normal;
			}
			
			.detail {
				width: 960px;
				margin: 0 auto;
				border: 1px #c2c7cd solid;
				padding: 20px;
				line-height: 24px;
				position: relative;
			}
			
			.text1 {
				text-align: center;
				border-bottom: 1px #44709d dotted;
				padding-bottom: 20px;
			}
			
			.text1 h3 {
				font-size: 22px;
				line-height: 30px;
				font-weight: 100;
			}
			
			.copyright {
				float: right;
				color: #476fa0;
				margin-bottom: 10px;
			}
			
			#main {
				line-height: 2.2em;
				zoom: 1;
			}
			
			#main p {
				margin-bottom: 10px;
				text-indent: 2em;
				font-size: 1.2em;
			}
			
			.footer {
				width: 1000px;
				margin: 10px auto 0;
				border-top: 2px #4071b3 solid;
				padding-top: 10px;
				text-align: center;
				line-height: 30px;
			}
			img {
				max-width: 100%; /*图片自适应宽度*/
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
		</style>
		
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<h1 class="title">预览</h1>
		<div class="detail">
			<div class="text1">
				<h4 style="font-size: 14px; font-weight: 100;">${CategoryName }——</h4>
				<h3>${Title }</h3>
				<p style="font-size: 14px; line-height: 24px; text-align: right;">
				</p>
				<p style="font-weight: bold; line-height: 24px;">${Author }</p>
			</div>
			<span style="float: left; font-size: 14px; margin-top: 2px;"></span>
			<!-- <span class="copyright">《XXX报》2018年第63期(总第3200期) 第1版 要闻版</span> -->
			<div class="cl"></div>
			<div id="main">
				<div id="ozoom" style="zoom: 100%">
					${MainText }
				</div>
			</div>
		</div>
		<div class="footer">
			 © 版权所有 XXXX
			<br> 技术支持：鹏翔科技
		</div>
		
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		
	</m:Content>
</m:ContentPage>