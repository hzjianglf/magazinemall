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
		<blockquote class="layui-elem-quote layui-bg-blue">
			物流设置
		</blockquote>
		<div class="layui-tab layui-tab-brief">
		  <ul class="layui-tab-title" id="tab_list">
		    <li data-taburl="/${applicationScope.adminprefix }/logistics/list" data-type="1" class="layui-this">发货地址</li>
		    <li data-taburl="/${applicationScope.adminprefix }/logisticsTemplate/listFace" data-type="2">物流模板</li>
		  </ul>
		  <iframe id="ifr_b" name="ifr_b" src="/${applicationScope.adminprefix }/logistics/list" frameborder="no" scrolling="no" width="100%" height="700px;" allowtransparency="true"></iframe>
		</div> 
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="deletes">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		var userId = 0;
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
	
			$("#tab_list > li[data-type]").on("click",function(){
				$("#tab_list > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				//获取状态值
				var type = $("#tab_list > li.layui-this").data("type");
				//重新加载表格
				
			});
			//页签切换
			$("#tab_list > li[data-taburl]").on("click",function(){
				$("#tab_list > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				changepage();
			});
			
			function changepage(){
					var url = $("#tab_list > li.layui-this").data("taburl");
					$("#ifr_b").css("display","none");
					loading(true);
					$("#ifr_b").attr("src",url);
			}
			$("#ifr_b").load(function(){
				loading(false);
				$("#ifr_b").css("display","block");
			});
			
		})
		
	</script>
</m:Content>
</m:ContentPage>
