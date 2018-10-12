<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
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
		.uploadBox{
			width:50%;
			margin-left:20%;
			margin-top:20px;
		}
		.listBox{
			width:79%;
			border:1px solid #ddd;
		}
		.deleteIcon{
			float: right;
			margin-top: 35px;
			color:#000;
			line-height: 60px;
		}
		.checkSec{
			position: relative;
			top:3px;
			left:15px;
		}
		.listBox ul li{
			padding:10px 15px;
			border-bottom: 1px solid #ddd;
		}
		.listBox ul li:last-child{
			border-bottom: none;
		}
		.avatar-small{
			width: 50px;
   			height: 50px;
   			margin-top: 40px;
		}
		.checkIns{
			display:inline-block;
			margin-bottom:0;
			margin-left:30px;
			
		}
		.layui-form-item .layui-form-checkbox[lay-skin=primary]{
			margin-top:-3px;
		}
		.layui-inline{
			width:66%;
			margin-right:0 !important;
			float:left;
		}
		.layui-input-inline{
			width:100% !important;
		}
		#addTeacher{
			width:13%;
			text-align:center;
			height:38px;
			float:left;
			margin-top:0;
			padding:0;
			line-height:38px;
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
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=6&ondemandId=${findById.ondemandId }&classtype=${classtype}">价格设置</a> 
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=7&ondemandId=${findById.ondemandId }&classtype=${classtype}" class="on">授课教师</a> 
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
		<h2>授课教师</h2>
		<form class="layui-form">
		<!-- 发布 -->
		<input type="hidden" name="release" id="release" value="1" />
		<input type="hidden" name="ondemandId" id="ondemandId" value="${ondemandId }" />
		<!-- 教师id -->
		<input type="hidden" name="teacherId" id="teacherId" value="${tMsg.teacherId}"/>
		<!-- 教师与课程中间表主键id -->
		<input type="hidden" name="id" id="id" value="${tMsg.id }" />
			<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<div class="uploadBox">
			<div class="listBox">
				<ul id="teacherMsg">
					<c:if test="${!empty tMsg }">
						<li id="${tMsg.teacherId }">
							<img src="${(empty tMsg.userUrl)?'/manage/public/ondemand/images/1.png':tMsg.userUrl }" class="avatar-small" /><span style="line-height:128px;margin-left: 50px;">${tMsg.nickName }</span>
							<div class="layui-form-item checkIns" pane="">
								 <input type="checkbox" name="display" lay-skin="primary" title="显示" ${tMsg.display=='1'?'checked':'' }>
							</div>
							<span class="fa fa-close deleteIcon"><a onclick="delUl(${tMsg.teacherId});"><i class="layui-icon" >&#x1006;</i></a></span>
						</li>
					</c:if>
				</ul>
			</div>
			<div>&nbsp;&nbsp;</div>
			<div class="layui-form-item">
			     <div class="layui-inline">
					 <div class="layui-input-inline">
						<select name="nteacherId" id="nteacherId" lay-search="">
							<option value="">直接选择或搜索选择</option>
							<c:forEach items="${teacher }" var="teacher">
									<option value="${teacher.userId }" ${tMsg.teacherId == teacher.userId ? 'selected':'' }>${(empty teacher.realname)?teacher.nickName:teacher.realname }</option>
							</c:forEach>
						</select>
					 </div>
				 </div>
			     <button type="button" class="layui-btn layui-btn-primary" id="addTeacher" >
					添加
				 </button>
			</div>
			
		</div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  	<tr>
			    <td>&nbsp;</td>
			    <td align="right">
			    	<input type="button" id="up" value="上一步" class="xyb_biao" />
			    	<input type="button" value="存草稿" class="czg_biao" lay-submit lay-filter="draft"/>
			    	<input type="button" lay-submit lay-filter="release" value="课程发布" class="xyb_biao" />
			    </td>
		  	</tr>
		</table>
		</form>
	</div>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//下一步,保存信息
		layui.use(['form','layer'], function(){
			var form = layui.form;
			var layer = layui.layer;
			form.on('submit(release)', function(data){
				var success = function(response){
					if(response.success){
						var classtype = $("#classtype").val();
						var msg = '';
						if(response.message!=null && response.message!=''){
							msg=response.msg+","+response.message;
						}else{
							msg=response.msg;
						}
						layer.alert(msg, {icon: 1}, function(){
							window.location.href = '/${applicationScope.adminprefix }/ondemand/list?classtype='+classtype;
						})
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
				window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+ondemandId+'&page=6'+'&classtype='+classtype;
			})
			//添加教师
			$("#addTeacher").click(function(){
				//获取选中的教师Id
				var teacherId = $("#nteacherId option:selected").val();
				if(teacherId==null || teacherId==''){
					alertinfo("请先选择教师!");
					return false;
				}
				//调用方法先把原有的教师删除
				delteacher();
				$.ajax({
					type: "post",
					url: '/${applicationScope.adminprefix }/ondemand/teacherMsg',
					data: {"teacherId":teacherId},
					dataType: "json",
					success: function(data){
						$("#teacherMsg").empty();
						var html = '';
						html+='<li id="'+data.userId+'">';
						if(data.userUrl==null || data.userUrl==''){
							html+='<img src="/manage/public/ondemand/images/1.png" class="avatar-small" /><span style="line-height:128px;margin-left: 50px;">'+data.nickName+'</span>';
						}else{
							html+='<img src="'+data.userUrl+'" class="avatar-small" /><span style="line-height:128px;margin-left: 50px;">'+data.nickName+'</span>';
						}
						html+='<div class="layui-form-item checkIns" pane="">';
						html+='<input type="checkbox" name="display" lay-skin="primary" title="显示">';
						html+='</div>';
						html+='<span class="fa fa-close deleteIcon"><a onclick="delUl('+data.userId+');"><i class="layui-icon" >&#x1006;</i></a></span>';
						html+='</li>';
						$("#teacherMsg").append(html);
						//赋值隐藏域
						$("#teacherId").val(data.userId);
						//清空关联表主键
						$("#id").val('');
						form.render();
					},
					error: function(data){
						layer.msg("未知错误", {icon: 2});
					}
				})
			})
		})
		//删除已选择的教师
		function delUl(id){
			//先删除数据库数据
			delteacher();
			var obj = document.getElementById(id);
	 		document.getElementById(id).parentNode.removeChild(obj);
	 		//清楚隐藏域中的教师Id值
	 		$("#teacherId").val('');
		}
		function delteacher(){
			var ondemandId = $("#ondemandId").val();
			var teacherId = $("#teacherId").val();
			$.ajax({
				type: "post",
				url: '/${applicationScope.adminprefix }/ondemand/delTeacher',
				data: {"ondemandId":ondemandId,"teacherId":teacherId},
				dataType: "json",
				success: function(data){
					
				},
				error: function(data){
					layer.msg("未知错误", {icon: 2});
				}
			})
		}
	</script>
</m:Content>
</m:ContentPage>
