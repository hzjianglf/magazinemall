<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<!-- <link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/> -->
	<link href="/manage/public/ondemand/css/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/ondemand/css/index.css" rel="stylesheet" type="text/css" />
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
<div class="kc_top">
	<img src="${(empty tMsg.userUrl)?'/manage/public/ondemand/images/1.png':tMsg.userUrl }"  class="tx_img" />
	<P ><span class="p1">课程：${findById.name }</span><br /><span class="p2">教师：${tMsg.realname == null?tMsg.nickName:tMsg.realname }</span></P>
	<c:if test="${findById.status=='-1' }"><span class="wfb_biao"><span>未发布</span></span></c:if>
</div> 
<div class="kc_left">
	<ul>
		<li>
			<h3>课程信息</h3>
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=1&ondemandId=${findById.ondemandId }&classtype=${classtype}">基本信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=2&ondemandId=${findById.ondemandId }&classtype=${classtype}">详细信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=3&ondemandId=${findById.ondemandId }&classtype=${classtype}">课程图片</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=4&ondemandId=${findById.ondemandId }&classtype=${classtype}">课时管理</a> 
			<!-- <a href="#">文件管理</a>  -->
		</li>
		<li>
		    <h3>课程设置</h3>
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=6&ondemandId=${findById.ondemandId }&classtype=${classtype}" class="on">价格设置</a> 
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=7&ondemandId=${findById.ondemandId }&classtype=${classtype}">授课教师</a> 
		</li>
	<!-- 	<li>
		    <h3>课程运营</h3>
		    <a href="#">课程学习数据</a> 
		    <a href="#">课程订单查询</a> 
		</li> -->
	</ul>
</div>
<div class="kc_center">
	<div class="kc_nr">
		<h2>价格设置</h2>
		<form id="saveBasic">
		<input type="hidden" name="release" id="release" />
		<input type="hidden" name="ondemandId" id="ondemandId" value="${ondemandId }" />
			<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		    	<td align="right"><strong>课程原价</strong></td>
		    	<td><input type="text" class="in1" name="originalPrice" value="${findById.originalPrice }"/></td>
		  	</tr>
		 	<tr>
			    <td align="right"><strong>课程现价</strong></td>
			    <td><input type="text" class="in1" name="presentPrice" value="${findById.presentPrice }"/>&nbsp;&nbsp;<input type="checkbox" name="IsGratis" id="IsGratis" value="${findById.IsGratis }" ${findById.IsGratis=='1'?'checked':'' } /> 免费课程 </td>
		  	</tr>
		  	<tr>
			    <td align="right"><strong>课程订单有效期</strong></td>
			    <td><input type="text" class="in1" name="effective" value="${findById.effective }"/><p>单位：天，留空则表示购买后永久可观看</p></td>
		  	</tr>
		  	
		  	<tr>
			    <td>&nbsp;</td>
			    <td align="right">
			    	<input type="button" id="up" value="上一步" class="xyb_biao" />
			    	<input type="button" value="存草稿" class="czg_biao" lay-submit lay-filter="draft"/>
			    	<input type="button" lay-submit lay-filter="next" value="下一步" class="xyb_biao" />
			    </td>
		  	</tr>
		</table>
		</form>
	</div>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<!-- <script type="text/javascript" src="/manage/public/js/ToolTip.js"></script> -->
	<script type="text/javascript">
		//下一步,保存信息
		layui.use('form', function(){
			var form = layui.form;
			form.on('submit(next)', function(data){
				var success = function(response){
					if(response.success){
						var classtype = $("#classtype").val();
						window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+response.ondemandId+'&page=7'+'&classtype='+classtype;
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/ondemand/upBasic', postData, success, 'post', 'json');
				return false;
			});
			//监听存草稿按键
			form.on('submit(draft)', function(data){
				$("#release").val('0');
				var success = function(response){
					if(response.success){
						var classtype = $("#classtype").val();
						window.location.href = '/${applicationScope.adminprefix }/ondemand/list?classtype='+classtype;
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/ondemand/upBasic', postData, success, 'post', 'json');
				return false;
			});
			//上一步
			$("#up").click(function(){
				var ondemandId = $("#ondemandId").val();
				var classtype = $("#classtype").val();
				window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+ondemandId+'&page=4'+'&classtype='+classtype;
			})
			$("#IsGratis").click(function(){
				if($('#IsGratis').is(':checked')){
					$("#IsGratis").val("1");
				} else{
					$("#IsGratis").val("0");
				}
			})
		})
	</script>
</m:Content>
</m:ContentPage>
