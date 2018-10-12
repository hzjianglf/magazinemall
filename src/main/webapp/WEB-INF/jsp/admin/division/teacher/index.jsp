<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<!-- 选项卡 -->
		<div class="layui-tab layui-tab-brief">
			<ul class="layui-tab-title" id="tab_list">
				<li data-taburl="/${applicationScope.adminprefix }/division/teacherOndemand?userId=${userId}&year=${year}&month=${month}" class="layui-this">课程销售记录</li>
				<li data-taburl="/${applicationScope.adminprefix }/division/teacherQueslog?userId=${userId}&year=${year}&month=${month}">问答记录</li>
				<li data-taburl="/${applicationScope.adminprefix }/division/teacherRewardlog?userId=${userId}&year=${year}&month=${month}">打赏记录</li>
			</ul>
			<iframe id="ifr_b" name="ifr_b" src="" frameborder="no" scrolling="no" width="100%" height="100%" allowtransparency="true"></iframe>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		$(function(){
			$("ul>li:eq(0)").click();
		})
		//页签切换
		$("#tab_list > li[data-taburl]").on("click",function(){
			$("#tab_list > li.layui-this").removeClass("layui-this");
			$(this).addClass("layui-this");
			changepage();
		});
		
		function changepage(){
			var url = $("#tab_list > li.layui-this").data("taburl");
			$("#ifr_b").css("display","none");
			$("#ifr_b").attr("src",url);
		}
		$("#ifr_b").load(function(){
			loading(false);
			$("#ifr_b").css("display","block");
			setFrameHeight();
		});
		function setFrameHeight(){
			var iframe = document.getElementById("ifr_b");
			var height = $("#tab_btn > li.select_tab").data("height");
			if(height){
				iframe.height=$(window).height();
				$("#ifr_b").contents().find("#maincontent").css("padding-bottom",iframe.height+"px");
				$("#ifr_b").contents().find(".target_menu,.sidebar").height(iframe.height);
				return;
			}
			
			try{
				iframe.height=0;
				var bHeight = iframe.contentWindow.document.body.scrollHeight;
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				var height = Math.max(bHeight, dHeight);
				iframe.height = height+150;
				
			}catch (ex){}
		}
	</script>

</m:Content>
</m:ContentPage>
