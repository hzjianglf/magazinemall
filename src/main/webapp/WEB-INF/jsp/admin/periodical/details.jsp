<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<link rel="stylesheet" href="/manage/public/js/themes/default/css/ueditor.css" />
	<style type="text/css">
		.layui-tab-title .layui-this:after {
			border-bottom-color: #f1f0f7
		}
		
		.layui-form-select {
			width: 85.8%;
			float: left;
		}
		
		div.layui-form {
			width: 1150px;
			margin-left: 6%;
			margin-top: 20px;
		}
		
		.layui-form-label {
			width: 120px !important;
		}
		
		.layui-input-block input,.layui-input-block textarea {
			width: 95%;
		}
		.edui-editor{
			width: 100%;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 10px;" class="layui-anim layui-anim-upbit">
	<form <%-- action="/${applicationScope.adminprefix }/periodical/adds" --%> id="contentInfo" class="layui-form" method="post">
		<div class="layui-tab">
			<div class="layui-tab-content" style="background: #FFFFFF;">
		 		<input type="hidden" name="id" id="id" value="${contentMap.id }"/>
				<div class="layui-form">
	            	<%-- <div class="layui-form-item">
						<label class="layui-form-label">期刊编号：</label>
						<div class="layui-input-block">
							<input type="text" name="id" id="id" value="${contentMap.id }" readonly="readonly" lay-verify="required" autocomplete="off" class="layui-input"/>
						</div>
					</div> --%>
					<div class="layui-form-item">
						<label class="layui-form-label">期刊名称：</label>
						<div class="layui-input-block">
							<input type="text" name="name" id="name" value="${contentMap.name }" autocomplete="off" class="layui-input"/>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">杂志社：</label>
						<div class="layui-input-block" >
							 <input type="text" name="magazine" id="magazine" value="${contentMap.magazine }" autocomplete="off" class="layui-input"/>
						</div>
					</div>
					<%-- <div class="layui-form-item">
						<label class="layui-form-label">时间：</label>
						<div class="layui-input-block" >
							 <input type="text" name="createTime" id="createTime" value="${contentMap.createTime }" class="layui-input" placeholder="yyyy-MM-dd"/>
						</div>
					</div> --%>
					<div class="layui-form-item">
						<label class="layui-form-label">期刊周期：</label>
						<div class="layui-input-block" >
							<select class="layui-input" name="cycle" id="cycle">
								<option value="">请选择</option>
								<option value="1" ${contentMap.cycle=='1'?'selected':'' }>周刊</option>
								<option value="2" ${contentMap.cycle=='2'?'selected':'' }>半月刊</option>
								<option value="3" ${contentMap.cycle=='3'?'selected':'' }>月刊</option>
								<option value="4" ${contentMap.cycle=='4'?'selected':'' }>双月刊</option>
								<option value="5" ${contentMap.cycle=='5'?'selected':'' }>季刊</option>
							</select>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">状态：</label>
						<div class="layui-input-block">
							<%-- <select class="layui-input" name="state" id="state">
								<option value="1" ${contentMap.state=='1'?'selected':'' }>启用</option>
								<option value="0" ${contentMap.state=='0'?'selected':'' }>禁用</option>
							</select> --%>
							<input type="checkbox" title="启用" name="state" id="state" autocomplete="off"  ${contentMap.state=='1'?'checked':'' } />
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">主编：</label>
						<div class="layui-input-block" >
							 <input type="text" name="editor" value="${contentMap.editor }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">ISSN：</label>
						<div class="layui-input-block">
							<input type="text" name="issn" id="issn" value="${contentMap.issn }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<br>
					<br>
					<br>
					<br>
					<div class="layui-form-item">
						<label class="layui-form-label">详细内容：</label>
						<div class="layui-input-block">
							<script id="editor" type="text/plain" name="describes" style="width:97.4%;height:500px;margin-left: 40px;">
								${contentMap.describes }
							</script>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div>
			<c:if test="${type=='add' }">
			<button class="layui-btn" lay-submit lay-filter="addBtn">保存内容</button>
			</c:if>
			<c:if test="${type=='edit' }">
			<button class="layui-btn" lay-submit lay-filter="upBtn">修改内容</button>
			</c:if>
		</div>
	</form>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.all.js"> </script>
<script type="text/javascript" charset="utf-8" src="/manage/public/js/lang/zh-cn/zh-cn.js"></script>
<script type="text/javascript">
	layui.use(['laydate', 'upload', 'form'], function(){
		var laydate = layui.laydate;
		var upload = layui.upload;
		var form = layui.form;
		
		laydate.render({
			elem: '#createTime',
			value: new Date()
		});
		
		//监听提交
/* 		form.on('submit(saveBtn)', function(data) {
			if(data.success){
				layer.alert(data.msg,{icon: 1});
			}else{
				layer.alert(data.msg,{icon: 2});
			}
		}); */
		
		//修改
		form.on('submit(upBtn)', function(data) {
			layer.load(2, {
				shade: [0.8, '#393D49']
			});
			var success = function(response) {
				var result = response;
				if(result.success) {
					layer.alert(result.msg, {
						icon: 1
					}, function() {
						var index = parent.layer.getFrameIndex(window.name);
						 parent.layer.close(index)
						// parent.tableIns.reload({});
					});
				} else {
					layer.alert(result.msg, {
						icon: 2
					}, function() {
						layer.closeAll();
						//parent.tableIns.reload({});
					});
				}
			}
			var data = {
				id: data.field.id,
				name: data.field.name,
				magazine: data.field.magazine,
				cycle: data.field.cycle,
				editor: data.field.editor,
				issn: data.field.issn,
				state: data.field.state,
				describes:data.field.describes
			}
			ajax("/${applicationScope.adminprefix }/periodical/ups", data, success, 'post', 'json');
			return false;
		});
		//新增
		form.on('submit(addBtn)', function(data) {
			layer.load(2, {
				shade: [0.8, '#393D49']
			});
			var success = function(response) {
				var result = response
				if(result.success) {
					layer.alert(result.msg, {
						icon: 1
					}, function() {
						var index = parent.layer.getFrameIndex(window.name);
						parent.layer.close(index)
						// parent.tableIns.reload({});
					});
				} else {
					layer.alert(result.msg, {
						icon: 2
					}, function() {
						layer.closeAll();
						//parent.tableIns.reload({});
					});
				}

			}
			var active = $("#active").val();
			var data = {
				id: data.field.id,
				name: data.field.name,
				magazine: data.field.magazine,
				cycle: data.field.cycle,
				editor: data.field.editor,
				issn: data.field.issn,
				state: data.field.state,
				describes:data.field.describes
			}
			ajax("/${applicationScope.adminprefix }/periodical/adds", data, success, 'post', 'json');
			return false;
		});
	})

	
    /**文本编辑器**/
    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
     var ue = UE.getEditor('editor', {
    	 	"imageActionName": "uploadimage", /* 执行上传图片的action名称 */
    	    "imageFieldName": "upfile", /* 提交的图片表单名称 */
    	    "imageMaxSize": 2048000, /* 上传大小限制，单位B */
    	    "imageAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 上传图片格式显示 */
    	    "imageCompressEnable": false, /* 是否压缩图片,默认是true */
    	    "imageCompressBorder": 1600, /* 图片压缩最长边限制 */
    	    "imageInsertAlign": "none", /* 插入的图片浮动方式 */
    	    "imageUrlPrefix": "", /* 图片访问路径前缀 */
    	    "imagePathFormat": "/upload/content/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
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
			    "videoPathFormat": "/upload/content/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
			    "videoUrlPrefix": "", /* 视频访问路径前缀 */
			    "videoMaxSize": 1024000000000, /* 上传大小限制，单位B，默认100MB */
			    "videoAllowFiles": [
			        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
			        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid"], /* 上传视频格式显示 */
    	        
    	        /* 上传文件配置 */
    	        "fileActionName": "uploadfile", /* controller里,执行上传视频的action名称 */
    	        "fileFieldName": "upfile", /* 提交的文件表单名称 */
    	        "filePathFormat": "/upload/content/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
    	        "fileUrlPrefix": "", /* 文件访问路径前缀 */
    	        "fileMaxSize": 51200000, /* 上传大小限制，单位B，默认50MB */
    	        "fileAllowFiles": [
    	            ".png", ".jpg", ".jpeg", ".gif", ".bmp",
    	            ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
    	            ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid",
    	            ".rar", ".zip", ".tar", ".gz", ".7z", ".bz2", ".cab", ".iso",
    	            ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".pdf", ".txt", ".md", ".xml"
    	        ], /* 上传文件格式显示 */
    	        serverUrl: '/${applicationScope.adminprefix }/periodical/uploadimage'
    });

	$(function(){
		var imgUrl = "${contentMap.picUrl }";
		if(imgUrl!=""){
			$("#delImg").show();
		}
	})
	

	
</script>
</m:Content>
</m:ContentPage>
