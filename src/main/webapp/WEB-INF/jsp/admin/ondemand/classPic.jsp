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
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=3&ondemandId=${findById.ondemandId }&classtype=${classtype}" class="on">课程图片</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=4&ondemandId=${findById.ondemandId }&classtype=${classtype}">课时管理</a> 
			<!-- <a href="#">文件管理</a>  -->
		</li>
		<li>
		    <h3>课程设置</h3>
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=6&ondemandId=${findById.ondemandId }&classtype=${classtype}">价格设置</a> 
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
		<h2>课程图片</h2>
		<form>
		<input type="hidden" name="release" id="release" />
		<input type="hidden" name="ondemandId" id="ondemandId" value="${ondemandId }" />
		<input type="hidden" name="picUrl" id="picUrl" value="${findById.picUrl }"/>
			<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<div class="uploadBox">
			<img src="${(empty findById.picUrl)?'/manage/public/ondemand/u4844.png':findById.picUrl }" id="imgShow" />
			<button type="button" class="layui-btn" id="test1" style="display:block;margin:10px 0;">
				<i class="layui-icon">&#xe67c;</i>上传图片
			</button>
			<p>你可以上传jpg，gif，png格式的文件，图片建议尺寸至少为480x270.
			    	文件大小不能超过2M</p>
		</div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  	<tr>
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
	<script type="text/javascript">
		//下一步,保存信息
		layui.use(['upload', 'form'], function(){
		var upload = layui.upload;
		var form = layui.form;
		
		//监听提交
		form.on('submit(next)', function(data) {
			var success = function(response){
				if(response.success){
					var classtype = $("#classtype").val();
					window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+response.ondemandId+'&page=4'+'&classtype='+classtype;
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
		//监听存草稿
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
			window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+ondemandId+'&page=2'+'&classtype='+classtype;
		})
		
		//执行实例
		var uploadInst = upload.render({
			elem: '#test1', //绑定元素
			url: '/${applicationScope.adminprefix }/ondemand/uploadImg', //上传接口
			field: 'imgUrl',
			before: function(obj){
			    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
			    obj.preview(function(index, file, result){
			    	//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
			      	$("#imgShow").attr("src", result);
			      	//这里还可以做一些 append 文件列表 DOM 的操作
			      	//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
			      	//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
			    });
			},
			done: function(res){
				//上传完毕回调
				$('#picUrl').val(res.data);
			},
			error: function(){
				//请求异常回调
			}
		});
	})
	</script>
</m:Content>
</m:ContentPage>
