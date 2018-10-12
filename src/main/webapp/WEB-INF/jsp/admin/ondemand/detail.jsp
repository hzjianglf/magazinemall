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
	<link rel="stylesheet" href="/manage/public/js/themes/default/css/ueditor.css" />
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
		.edui-editor{
			width: 100%;
		}
		table tbody tr td:first-child{
		    width:10%;
		}
		.edui-default{
			margin-left: 0 !important;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
<div class="kc_top">
	<img src="${(empty tMsg.userUrl)?'/manage/public/ondemand/images/1.png':tMsg.userUrl }"  class="tx_img" />
	<P ><span class="p1">课程：${findById.name }</span><br /><span class="p2">教师：
	${(empty tMsg.realname)?tMsg.nickName:tMsg.realname }</span></P>
	<c:if test="${findById.status=='-1' }"><span class="wfb_biao"><span>未发布</span></span></c:if>
</div> 
<div class="kc_left">
	<ul>
		<li>
			<h3>课程信息</h3>
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=1&ondemandId=${findById.ondemandId }&classtype=${classtype}">基本信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=2&ondemandId=${findById.ondemandId }&classtype=${classtype}" class="on">详细信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=3&ondemandId=${findById.ondemandId }&classtype=${classtype}">课程图片</a> 
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
		<h2>详细信息</h2>
		<form>
		<input type="hidden" name="release" id="release" />
		<input type="hidden" name="ondemandId" id="ondemandId" value="${ondemandId }" />
			<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		 	<tr>
			    <td align="right"><strong>课程详情：</strong></td>
			    <td>
					<div class="layui-input-block" style="margin-left: 0;">
						<script id="editor" type="text/plain" name="introduce" style="width:75%;height:200px;margin-left: 40px;">
							${findById.introduce}
						</script>
					</div>
			    </td>
		  	</tr>
		  	<tr>
			    <td align="right"><strong>课程目录：</strong></td>
			    <td>
					<div class="layui-input-block" style="margin-left: 0;">
						<script id="editor2" type="text/plain" name="menu" style="width:75%;height:200px;margin-left: 40px;">
							${findById.menu}
						</script>
					</div>
			    </td>
		  	</tr>
		  	<tr>
			    <td align="right"><strong>适应人群</strong></td>
			    <td><input type="text" class="in1" name="IntendedFor" value="${findById.IntendedFor}"/></td>
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
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.all.js"> </script>
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/lang/zh-cn/zh-cn.js"></script>
	<script type="text/javascript">
		//下一步,保存信息
		layui.use('form', function(){
			var form = layui.form;
			form.on('submit(next)', function(data){
				var success = function(response){
					if(response.success){
						var classtype = $("#classtype").val();
						window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+response.ondemandId+'&page=3'+'&classtype='+classtype;
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
		})
		//上一步
		$("#up").click(function(){
			var ondemandId = $("#ondemandId").val();
			var classtype = $("#classtype").val();
			window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+ondemandId+'&page=1'+'&classtype='+classtype;
		})
		
	/**文本编辑器**/
    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
     var ue = UE.getEditor('editor', {
    		"enterTag":"",
    	 	"imageActionName": "uploadimage", /* 执行上传图片的action名称 */
    	    "imageFieldName": "upfile", /* 提交的图片表单名称 */
    	    "imageMaxSize": 2048000, /* 上传大小限制，单位B */
    	    "imageAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 上传图片格式显示 */
    	    "imageCompressEnable": false, /* 是否压缩图片,默认是true */
    	    "imageCompressBorder": 1600, /* 图片压缩最长边限制 */
    	    "imageInsertAlign": "none", /* 插入的图片浮动方式 */
    	    "imageUrlPrefix": "", /* 图片访问路径前缀 */
    	    "imagePathFormat": "/upload/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    	                                /* {filename} 会替换成原文件名,配置这项需要注意中文乱码问题 */
    	                                /* {rand:6} 会替换成随机数,后面的数字是随机数的位数 */
    	                                /* {time} 会替换成时间戳 */
    	                                /* {yyyy} 会替换成四位年份 */
    	                                /* {yy} 会替换成两位年份 */
    	                                /* {mm} 会替换成两位月份 */
    	                                /* {dd} 会替换成两位日期 */
    	                                /* {hh} 会替换成两位小时 */
    	                                /* {ii} 会替换成两位分钟 */
    	                                /* {ss} 会替换成两位秒 */
    	                                /* 非法字符 \ : * ? " < > | */
    	                                /* 具请体看线上文档: fex.baidu.com/ueditor/#use-format_upload_filename */
    	                                
			    	   /* 上传视频配置 */
			    "videoActionName": "uploadvideo", /* 执行上传视频的action名称 */
			    "videoFieldName": "upfile", /* 提交的视频表单名称 */
			    "videoPathFormat": "/upload/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
			    "videoUrlPrefix": "", /* 视频访问路径前缀 */
			    "videoMaxSize": 1024000000000, /* 上传大小限制，单位B，默认100MB */
			    "videoAllowFiles": [
			        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
			        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid"], /* 上传视频格式显示 */
    	        
    	        /* 上传文件配置 */
    	        "fileActionName": "uploadfile", /* controller里,执行上传视频的action名称 */
    	        "fileFieldName": "upfile", /* 提交的文件表单名称 */
    	        "filePathFormat": "/upload/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    	        "fileUrlPrefix": "", /* 文件访问路径前缀 */
    	        "fileMaxSize": 51200000, /* 上传大小限制，单位B，默认50MB */
    	        "fileAllowFiles": [
    	            ".png", ".jpg", ".jpeg", ".gif", ".bmp",
    	            ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
    	            ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid",
    	            ".rar", ".zip", ".tar", ".gz", ".7z", ".bz2", ".cab", ".iso",
    	            ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".pdf", ".txt", ".md", ".xml"
    	        ], /* 上传文件格式显示 */
    	        serverUrl: '/${applicationScope.adminprefix }/ondemand/uploadimage'
    });
	 var ue = UE.getEditor('editor2', {
    	 	"imageActionName": "uploadimage", /* 执行上传图片的action名称 */
    	    "imageFieldName": "upfile", /* 提交的图片表单名称 */
    	    "imageMaxSize": 2048000, /* 上传大小限制，单位B */
    	    "imageAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 上传图片格式显示 */
    	    "imageCompressEnable": false, /* 是否压缩图片,默认是true */
    	    "imageCompressBorder": 1600, /* 图片压缩最长边限制 */
    	    "imageInsertAlign": "none", /* 插入的图片浮动方式 */
    	    "imageUrlPrefix": "", /* 图片访问路径前缀 */
    	    "imagePathFormat": "/upload/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    	                                /* {filename} 会替换成原文件名,配置这项需要注意中文乱码问题 */
    	                                /* {rand:6} 会替换成随机数,后面的数字是随机数的位数 */
    	                                /* {time} 会替换成时间戳 */
    	                                /* {yyyy} 会替换成四位年份 */
    	                                /* {yy} 会替换成两位年份 */
    	                                /* {mm} 会替换成两位月份 */
    	                                /* {dd} 会替换成两位日期 */
    	                                /* {hh} 会替换成两位小时 */
    	                                /* {ii} 会替换成两位分钟 */
    	                                /* {ss} 会替换成两位秒 */
    	                                /* 非法字符 \ : * ? " < > | */
    	                                /* 具请体看线上文档: fex.baidu.com/ueditor/#use-format_upload_filename */
    	                                
			    	   /* 上传视频配置 */
			    "videoActionName": "uploadvideo", /* 执行上传视频的action名称 */
			    "videoFieldName": "upfile", /* 提交的视频表单名称 */
			    "videoPathFormat": "/upload/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
			    "videoUrlPrefix": "", /* 视频访问路径前缀 */
			    "videoMaxSize": 1024000000000, /* 上传大小限制，单位B，默认100MB */
			    "videoAllowFiles": [
			        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
			        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid"], /* 上传视频格式显示 */
    	        
    	        /* 上传文件配置 */
    	        "fileActionName": "uploadfile", /* controller里,执行上传视频的action名称 */
    	        "fileFieldName": "upfile", /* 提交的文件表单名称 */
    	        "filePathFormat": "/upload/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    	        "fileUrlPrefix": "", /* 文件访问路径前缀 */
    	        "fileMaxSize": 51200000, /* 上传大小限制，单位B，默认50MB */
    	        "fileAllowFiles": [
    	            ".png", ".jpg", ".jpeg", ".gif", ".bmp",
    	            ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
    	            ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid",
    	            ".rar", ".zip", ".tar", ".gz", ".7z", ".bz2", ".cab", ".iso",
    	            ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".pdf", ".txt", ".md", ".xml"
    	        ], /* 上传文件格式显示 */
    	        serverUrl: '/${applicationScope.adminprefix }/ondemand/uploadimage'
    });
	</script>
</m:Content>
</m:ContentPage>
