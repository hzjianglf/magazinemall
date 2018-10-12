<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
		<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
		<link rel="StyleSheet" href="/manage/select/css/multsel.css" type="text/css" />
		<style type="text/css">
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="cbjh">
		<br>
			<div class="cjhj_top">
				<div class="cjhj_nr">
					<form class="layui-form" id="form">
					<input type="hidden" name="id" value="${DocID }" />
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em>文章标题：</label>
							<div class="layui-input-block">
								<input type="text"  value="${Title }"  name="Title" id="Title" class="layui-input" lay-verify="required" style="width: 288px;">
							</div>

								<label class="layui-form-label"> 文章ID：</label>
								<div class="layui-input-block">
									<input type="text"  placeholder=""  value="${DocID }"   class="layui-input"  style="background-color:#D9D9D9; width: 85px; display: inline-block;" readOnly>
								</div>
								<input type="hidden" id="ytotalprice" name="ytotalprice"/>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em> 所属期次：</label>
							<div class="layui-input-block"  style="width: 250px;">
								<select lay-filter="publish" id="publish" style="width: 125px;height: 25px;">
									<c:forEach items="${publishlist }" var="item">
										<option value="${item.id }" data-v="${item.period }" ${item.id == IssueOfPublication ?'selected':''}>${item.year }年${item.name }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em> 所属板块：</label>
							<div class="layui-input-block"  style="width: 200px;">
								<select lay-filter="Category" id="Category" style="width: 85px;height: 25px;">
									<c:forEach items="${Category }" var="item">
										<option value="${item.CategoryID }" ${item.CategoryName == CategoryName ?'selected':''}>${item.CategoryName }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em> 所属栏目：</label>
							<div class="layui-input-block"  style="width: 200px;">
								<select lay-filter="Columns" id="Columns" style="width: 85px;height: 25px;">
									<option value="">请选择</option>
									<c:forEach items="${Columns }" var="item">
										<option value="${item.ColumnID }" ${item.ColumnID == ColumnID ?'selected':''}>${item.ColumnName }</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"> 作者：</label>
							<div class="layui-input-block">
								<input type="text"  value="${Author }" name="Author" id="Author" class="layui-input" style="width: 288px;">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em> 排序：</label>
							<div class="layui-input-block">
								<input type="text"  value="${OrderNo }" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9]+/,'');}).call(this)" name="orderNo" id="orderNo" class="layui-input" lay-verify="required" style="width: 288px;">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em>状态：</label>
							<div class="layui-input-block">
								<input type="radio" name="status" value="1" title="启用"  ${status==1?'checked':'' } checked>
								<input type="radio" name="status" value="0" title="禁用"  ${status==0?'checked':'' } >
							</div>
						</div>
						<br>
						<br>
						<br>
						<br>
						<br>
						<script id="editor" type="text/plain" name="describes" style="width: 97.4%; height: 500px; margin-left: 40px;">
									${MainText }
						</script>
				</form>
				</div>
			</div>
			<div class="layui-form-item" style="text-align: center;">
				<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
			</div>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.js"></script>
		<script type="text/javascript" src="/manage/select/js/multsel.js"></script>
		<script type="text/javascript">
		 /**文本编辑器**/
	       //实例化编辑器
	       //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
	        var ue = UE.getEditor('editor', {
	        	"initialFrameWidth":750,
	        	"initialFrameHeight": 200,
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
		 
	        layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
	    		var table = layui.table;
	    		var laypage = layui.laypage;
	    		var layer = layui.layer;
	    		var form = layui.form;
	     		form.on('select(publish)', function(data){
	    			console.log(data.elem); //得到select原始DOM对象
	    			//console.log(data.othis); //得到美化后的DOM对象
	    			var val = data.data("v"); //得到被选中的值
	    			$.post( "selEbookdoc?publishId="+val, function( data ) {
	    				var col =data.Category;
	    				var html = "<option value=''>请选择</option>";
	    				if(col!=null){
		    				for(var i = 0 ; i < col.length ; i++){
		    					html+="<option value='"+col[i].PublicationID+"'>"+col[i].CategoryName+"</option>";
		    				}
	    				}
	    				$('#Category').html(html);
	    				form.render();
	    			});
	    		});
	    		form.on('select(Category)', function(data){
	    			console.log(data.elem); //得到select原始DOM对象
	    			//console.log(data.othis); //得到美化后的DOM对象
	    			var val = data.value; //得到被选中的值
	    			$.post( "categoryAsColumnID?CategoryID="+val, function( data ) {
	    				var col =data.Columns;
	    				var html = "<option value=''>请选择</option>";
	    				if(col!=null){
		    				for(var i = 0 ; i < col.length ; i++){
		    					html+="<option value='"+col[i].ColumnID+"'>"+col[i].ColumnName+"</option>";
		    				}
	    				}
	    				$('#Columns').html(html);
	    				form.render();
	    			});
	    		});
	    		form.on('submit(addEqBtn)', function(data) {
	    			var orderNo = $("#orderNo").val();
					if(orderNo==null || orderNo==''){
						tipinfo("排序号不能为空");
						return false;
					}else{
						var success = function(response){
		    				if(response.success){
		    					layer.alert(response.msg, {
		    						icon: 1
		    					}, function() {
		    						var index = parent.layer.getFrameIndex(window.name);
		    						 parent.layer.close(index);
		    						 tableIns.reload({
		    								page: {
		    									curr: 1
		    								}
		    							});
		    					});
		    				}else{
		    					layer.alert(response.msg, {
		    						icon: 2
		    					}, function() {
		    						layer.closeAll();
		    					});
		    				}
		    			}
						var Category = $('#Category option:selected').val();
						var Columns = $('#Columns option:selected').val();
						var IssueOfPublication = $('#publish option:selected').val();
						var params = { CatID:Category, ColumnID:Columns,IssueOfPublication:IssueOfPublication };
						var str = jQuery.param(params);
						var json = $("#form").serialize();
		    			$.post('updDoc',str+"&"+json,success, 'json');
		    			return false;
					}
	    			
	    		})
	    	})
		</script>
	</m:Content>
</m:ContentPage>
