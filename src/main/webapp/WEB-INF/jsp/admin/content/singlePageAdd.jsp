<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/js/themes/default/css/ueditor.css" />
	<style type="text/css">
		body {
			background: #f1f0f7;
		}
		
		.yw_cx {
			background: #fff;
			border-radius: 3px;
			padding: 30px 10px;
		}
		
		.layui-form-item .layui-input-inline {
			width: 162px;
			margin-right: 0
		}
		
		.layui-form-label {
			width: inherit
		}
		
		.layui-table th {
			font-weight: 700;
			background: #01AAED;
			color: #fff;
			text-align: center;
		}
		
		.layui-table td {
			text-align: center;
		}
		
		.layui-laypage span {
			background: none
		}
		
		.layui-laypage .layui-laypage-spr {
			background: #fff
		}
		
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
		<blockquote class="layui-elem-quote layui-bg-blue">
			内容管理
		</blockquote>
	<form action="/${applicationScope.adminprefix }/content/saveContent?num=<%=Math.random() %>" id="contentInfo" class="layui-form" method="post">
		<div class="layui-tab">
			<div class="layui-tab-content" style="background: #FFFFFF;">
				<input type="hidden" name="catId" value="${catId!=null?catId:contentList[0].catId }"/>
		 		<input type="hidden" name="contentId" value="${contentList[0].contentId }"/>
		 		 <input type="hidden" name="oldPicUrl" id="oldPicUrl" value="${contentList[0].picUrl }"/>
		 		<input type="hidden" name="picUrl" id="imgUrl" value=""/>
				<div class="layui-form">
					<div class="layui-form-item">
						<label class="layui-form-label">所属栏目：</label>
					    <select name="parentId" id="parentId" lay-search lay-verify="required">
					    	<option value="">--请选择--</option>
					    	 <option value="0" <c:if test="${catId==null }">selected="selected"</c:if>>${catId==null?"根栏目":"/" }</option>
							 <c:forEach items="${columnList }" var="item">
	 							<c:if test="${item.parentId==0 }">
		 							<option value="${item.catId }" <c:if test="${item.catId==catId }">selected="selected"</c:if>>|-${item.catName }</option>
		 							<c:forEach items="${columnList }" var="items">
		 								<c:if test="${item.catId==items.parentId }">
		 									<option value="${items.catId }" <c:if test="${items.parentId!=0 }">style="text-indent:2em;"</c:if> 
		 										<c:if test="${items.catId==catId }">selected="selected"</c:if>>|-${items.catName }</option>
					    					<c:forEach items="${columnList }" var="itemss">
			    								<c:if test="${items.catId==itemss.parentId }">
 													<option value="${itemss.catId }" <c:if test="${itemss.parentId!=0 }">style="text-indent:4em;"</c:if> 
 														<c:if test="${itemss.catId==catId }">selected="selected"</c:if>>|-${itemss.catName }</option>
			    								</c:if>
						    				</c:forEach>
					    				</c:if>
					    			</c:forEach>
				    			</c:if>
				    		</c:forEach>
					    </select>
					</div>
	            	<div class="layui-form-item">
						<label class="layui-form-label">标题：</label>
						<div class="layui-input-block">
							<input type="text" name="title" id="title" value="${contentList[0].title }" lay-verify="required" autocomplete="off" class="layui-input"/>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">副标题：</label>
						<div class="layui-input-block">
							<input type="text" name="subTitle" id="subTitle" value="${contentList[0].subTitle }" autocomplete="off" class="layui-input"/>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">简介：</label>
						<div class="layui-input-block">
							<textarea id="summary" name="summary" class="layui-textarea">${contentList[0].summary}</textarea>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">展示图：</label>
						<div class="layui-input-block" >
							<button type="button" class="layui-btn" id="test1">
								<i class="layui-icon">&#xe67c;</i>上传图片
							</button>
							<div style="margin-top: 7px;padding: 0;height: 100px;">
                                <img src="${contentList[0].picUrl }" id="imgShow" width="100px" style="margin-left: 40px;"/>
                                <input type="button" value="删除图片" onclick="deleteImg()" id="delImg" style="display: none;"/>
                            </div>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">页面标题：</label>
						<div class="layui-input-block">
							<input type="text" name="webTitle" id="webTitles" value="${contentList[0].webTitle}" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">页面关键字：</label>
						<div class="layui-input-block">
							<input type="text" name="keywords" id="key" value="${contentList[0].keywords}"  autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">页面描述：</label>
						<div class="layui-input-block">
							<textarea id="webDescription" name="webDescription" class="layui-textarea">${contentList[0].webDescription}</textarea>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">详细内容：</label>
						<div class="layui-input-block">
							<script id="editor" type="text/plain" name="mainContent" style="width:97.4%;height:500px;margin-left: 40px;">
								${contentList[0].mainContent }
							</script>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div>
			<button class="layui-btn" lay-submit lay-filter="saveBtn">保存内容</button>
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
		form.on('submit(saveBtn)', function(data) {
		});
		
		//执行实例
		var uploadInst = upload.render({
			elem: '#test1', //绑定元素
			url: '/${applicationScope.adminprefix }/column/uploadImg', //上传接口
			field: 'imgUrl',
			before: function(obj){
			    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
			    obj.preview(function(index, file, result){
			    	//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
			    	$("#imgShow").show();
			      	$("#imgShow").attr("src", result);
			      	//这里还可以做一些 append 文件列表 DOM 的操作
			      	//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
			      	//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
			    });
			},
			done: function(res){
				//上传完毕回调
				$('#imgUrl').val(res.data);
			},
			error: function(){
				//请求异常回调
			}
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
    	        serverUrl: '/${applicationScope.adminprefix }/content/uploadimage'
    });

	$(function(){
		var imgUrl = "${contentList[0].picUrl }";
		if(imgUrl!=""){
			$("#delImg").show();
		}
	})
	
	//删除图片
	function deleteImg(){
		$("#imgShow").attr("src", "");
		$("#oldPicUrl").val("");
		$("#delImg").hide();
	}
	
</script>
</m:Content>
</m:ContentPage>
