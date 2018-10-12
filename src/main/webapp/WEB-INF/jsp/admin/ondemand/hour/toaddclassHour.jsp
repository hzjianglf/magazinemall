<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<link rel="stylesheet" href="/manage/public/js/themes/default/css/ueditor.css" />
<style>
.edui-editor{
	width: 100%;
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
		<!-- 内容主体区域 -->
		<div style="padding:0 30px" class="layui-anim layui-anim-upbit">

			<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
					<form class="layui-form" action="">
					<input type="hidden" name="ondemandId" id="ondemandId" value="${ondemandId }" />
					<input type="hidden" name="parentId" id="parentId" value="${parentId }" />
					<input type="hidden" name="hourId" id="hourId" value="${KsMsg.hourId }" />
					<!-- 课程类型 -->
					<input type="hidden" name = "classtype" id="classtype" value="${classtype }" />
						<div class="layui-form-item">
						    <label class="layui-form-label">类型</label>
						    <div class="layui-input-block">
						      <input type="radio" name="type" value="0" title="视频" checked="checked" lay-filter="danxuan" ${KsMsg.type=='0'?'checked':'' }/>
						      <input type="radio" name="type" value="1" title="音频" lay-filter="danxuan" ${KsMsg.type=='1'?'checked':'' }/>
						      <c:if test="${classtype=='0' }">
						    	 <%--  <input type="radio" name="type" value="2" title="图文" lay-filter="danxuan" ${KsMsg.type=='2'?'checked':'' }/> --%>
						      </c:if>
						    </div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">标题</label>
							<div class="layui-input-block">
								<input type="text" name="title" id="title" value="${KsMsg.title }" lay-verify="required" autocomplete="off" class="layui-input"/>
								<input type="checkbox" name="IsAudition" lay-skin="primary" title="试听课程" ${KsMsg.IsAudition=='1'?'checked':'' }/>
							</div>
						</div>
						<div class="layui-form-item layui-form-text">
						    <label class="layui-form-label">详情</label>
						    <div class="layui-input-block">
						      <%-- <textarea placeholder="请输入内容" name="abstracts" class="layui-textarea">${KsMsg.content }</textarea> --%>
						      <script id="editor3" type="text/plain" name="abstracts" style="width:75%;height:200px;margin-left: 40px;">
									${KsMsg.content}
						       </script>
						    </div>
						</div>
						 <c:if test="${classtype=='0' }">
							<div id="music">
								<div class="layui-form-item layui-form-text">
								    <label class="layui-form-label" id="video">视频</label>
								    <div class="layui-input-block">
								    	<span>
								    		<button type="button" class="layui-btn" id="test3"><i class="layui-icon"></i>上传文件</button>
								    		<label id="biaoti">${KsMsg.fileName}</label>
								    	</span>
								    	<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
								    </div>
								    <input type="hidden" name="videoUrl" id="videoUrl" value="${KsMsg.videoUrl }"/>
								    <input type="hidden" name="fileName" id="fileName" value="${KsMsg.fileName }"/>
								</div>
								<div class="layui-form-item layui-form-text">
								    <label class="layui-form-label" id="ppt">ppt</label>
								    <div class="layui-input-block">
								    	<span>
								    		<button type="button" class="layui-btn" id="test4"><i class="layui-icon"></i>上传ppt文件</button>
								    		<label id="pptbiaoti">${KsMsg.pptfileName}</label>
								    	</span>
								    	<input type="hidden" name="pptUrl" id="pptUrl" value="${KsMsg.pptUrl }"/>
								    	<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
								    </div>
								    <input type="hidden" name="pptfileName" id="pptfileName" value="${KsMsg.pptfileName }"/>
								</div>
								<div class="layui-form-item">
								    <div class="layui-inline">
								      <label class="layui-form-label">时长</label>
								      <div class="layui-input-inline" style="width: 100px;">
								        <input type="text" name="minute" value="${KsMsg.minute }" autocomplete="off" class="layui-input">
								      </div>
								      <div class="layui-form-mid">分</div>
								      <div class="layui-input-inline" style="width: 100px;">
								        <input type="text" name="second" value="${KsMsg.second }" autocomplete="off" class="layui-input">
								      </div>
								      <div class="layui-form-mid">秒</div>
								    </div>
								   <div class="layui-inline" style="color:gray;"><span style="color: red;">*</span>时长必须为整数</div>
								</div>
							</div>
							<div id="pic" style="display: none;">
								<div class="layui-form-item layui-form-text">
								    <label class="layui-form-label">内容</label>
								    <div class="layui-input-block">
								    	<script id="editor" type="text/plain" name="content" style="width:75%;height:200px;margin-left: 40px;">
											${KsMsg.content}
						           		</script>
								    </div>
								</div>
							</div>
						</c:if>
						<c:if test="${classtype=='1' }">
							<div>
								<div class="layui-form-item layui-form-text">
								    <label class="layui-form-label">开始时间</label>
								    <div class="layui-input-block" style="width: 15%;">
								    	<input type="text" name="starttime" id="starttime" value="${KsMsg.starttime }" lay-verify="datetime" placeholder="yyyy-MM-dd hh:mm:ss" autocomplete="off" class="layui-input">
								    </div>
								</div>
								<div class="layui-form-item layui-form-text">
								    <label class="layui-form-label">结束时间</label>
								    <div class="layui-input-block" style="width: 15%;">
								    	<input type="text" name="endtime" id="endtime" value="${KsMsg.endtime }" lay-verify="datetime" placeholder="yyyy-MM-dd hh:mm:ss" autocomplete="off" class="layui-input">
								    </div>
								</div>
							</div>
						</c:if>
						<div class="layui-form-item">
							<div class="layui-input-block">
								<button class="layui-btn" lay-submit="" lay-filter="add">添加</button>
							</div>
						</div>
					</form>
				</div>
            
		</div>
	</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.all.js"> </script>
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/lang/zh-cn/zh-cn.js"></script>	
	<script>
		//JavaScript代码区域
		layui.use(['element', 'layer', 'form' ,'upload', 'laydate'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var upload = layui.upload;
			var laydate = layui.laydate;
			laydate.render({
				elem:'#starttime',
				type:'datetime'
			});
			laydate.render({
				elem:'#endtime',
				type:'datetime'
			});
			//监听单选框事件
			form.on('radio(danxuan)', function(data){
				var val = data.value;
				if(val==='0'){
					$("#pic").hide();
					$("#music").show();
					$("#video").text("视频");
				}else if(val==='1'){
					$("#pic").hide();
					$("#music").show();
					$("#video").text("音频");
				}else if(val==='2'){
					//隐藏上传及时间
					$("#pic").show();
					$("#music").hide();
				}
			});
			
			//监听提交事件
			form.on('submit(add)',function(data){
				var classtype = $("#classtype").val();
				if(classtype=='1'){
					var starttime = $("#starttime").val();
					var endtime = $("#endtime").val();
					if(starttime==null||starttime==''){
						layer.msg("开始时间不能为空！", {icon: 2});
						 return false;
					}
					if(endtime==null||endtime==''){
						layer.msg("开始时间不能为空！", {icon: 2});
						 return false;
					}
					var d1 = new Date(starttime.replace(/\-/g, "\/"));  
					var d2 = new Date(endtime.replace(/\-/g, "\/"));  
					if(d1 >= d2){
						 layer.msg("开始时间不能大于结束时间！", {icon: 2});
						 return false;
					}
				}
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {icon: 1}, function(){
							window.parent.location.reload();
						})
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/ondemand/addClassHour', postData, success, 'post', 'json');
				return false;
			})
			//上传文件
			upload.render({
			    elem: '#test3'
			    ,url: '/${applicationScope.adminprefix }/ondemand/uploadImg'
			   	,field: 'imgUrl'
			    ,accept: 'file' //视频
			    ,size: 1048576 //单位KB
			    ,before:function(){
			    	loading(true);
			    }
			    ,done: function(res){
			    	loading();
			    	//截取文件名称
			    	$("#videoUrl").val(res.data);
			    	$("#biaoti").text(res.fileName);
			    	$("#fileName").val(res.fileName);
			    	//时长
			    	var min = res.min;
			    	var sec = res.sec;
			    	if(min!=null && sec!=null ){
			    		$("input[name='minute']").val(min);
			    		$("input[name='second']").val(sec);
			    	}
			    },error:function(index, upload){
			    	loading();
			    }
			});
			//上传ppt文件
			upload.render({
			    elem: '#test4'
			    ,url: '/${applicationScope.adminprefix }/ondemand/uploadPpt'
			   	,field: 'imgUrl'
			    ,accept: 'file' //视频
			    ,size: 1048576 //单位KB
			    ,before:function(){
			    	loading(true);
			    }
			    ,done: function(res){
			    	loading();
			    	//截取文件名称
			    	$("#pptUrl").val(res.pptUrl);
			    	$("#pptbiaoti").text(res.pptfileName);
			    	$("#pptfileName").val(res.pptfileName);
			    },error:function(index, upload){
			    	loading();
			    }
			});
		});
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
		//文稿编辑
	     var ue = UE.getEditor('editor2', {
	    	 	"wordCount":false,  /*关闭字符统计*/
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
		
	     var ue = UE.getEditor('editor3', {
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