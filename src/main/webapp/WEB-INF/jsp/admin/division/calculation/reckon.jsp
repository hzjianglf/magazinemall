<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style>
		.content{
			width: 300px;
		    height: 150px;
		    text-align: center;
		    margin-left: 70px;
		    margin-top: 20px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div class="content">
		<p style="font-size: 18px;">请选择要计算生成的分成月度</p> 
		<br/>
		<br/>
		<span>
			<select id="year" style="width: 85px;height: 25px;" onchange="change();">
				<option value="">请选择</option>
				<c:forEach items="${year }" var="item">
					<option value="${item }">${item }</option>
				</c:forEach>
			</select>
			<select id="month" style="width: 85px;height: 25px;">
				<option value="">请选择</option>
			</select>
		</span>
		<br/>
		<br/>
		<br/>
		<button style="width:125px;" class="layui-btn" id="start">开始计算</button>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//开始计算
		$("#start").click(function(){
			var year=$("#year").val();
			var month=$("#month").val();
			if(year==null || year==''){
				tipinfo("请选择年份");
				return false;
			}
			if(month==null || month==''){
				tipinfo("请选择月份");
				return false;
			}
			parent.next(year,month);
			closewindow();
		})
		//动态改变月份
		function change(){
			var myDate = new Date();
			var now = myDate.getFullYear();
			
			var year=$("#year").val();
			var uplist =${upmonth };
			var newlist = ${newmonth };
			var html = '<option value="">请选择</option>';
			if(year==now){
				for(var i=0;i<newlist.length;i++){
					html+='<option value="'+newlist[i]+'">'+newlist[i]+'月份</option>';
				}
			}else if (year == ''){
				
			}else if (year == (now-1)){
				for(var i=0;i<uplist.length;i++){
					html+='<option value="'+uplist[i]+'">'+uplist[i]+'月份</option>';
				}
			}
			$("#month").html(html);
			
		}
		
	</script>
</m:Content>
</m:ContentPage>
