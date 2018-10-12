<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
     <link rel="stylesheet" href="/manage/logistics/layui/css/layui.css" /> 
<link rel="stylesheet" href="/manage/zTree/css/metro.css" type="text/css"/>
<style>
ul.ztree{
    margin-top: 10px;
    border: 1px solid #ddd;
    background: #F4F7FD;
    min-width: 235px;
    height: 360px;
    overflow-y: scroll;
    overflow-x: auto;
    z-index:99999;
}
.layui-form-label{
	width: 150px;
	margin-left: 10px;
	text-align:left;
}
#bodyId{
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div id="bodyId" style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<!-- 物流地址添加或编辑 -->
				<input type="hidden" name="Id" value="${id}" />
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>编号：</label>
					 <div class="layui-input-inline">
						<input type="text" name="versionNum" value="系统自动生成" lay-verify="required" 
						autocomplete="off" class="layui-input" disabled="disabled"/>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>APP名称：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="销售与市场" name="versionName"
				        lay-verify="required"  class="layui-input" disabled="disabled">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>版本号：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="${versionNum }" name="versionNum"  lay-verify="required"  class="layui-input">
				    </div>
				</div>
				
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>APP类型</label>
				    <div class="layui-input-block">
				      <input type="radio" name="versionType" value="1" title="安卓版" ${type=='安卓版'?'checked':'' } checked>
				      <input type="radio" name="versionType" value="2" title="ios版" ${type=='ios版'?'checked':'' } >
				    </div>
				</div>
				<%-- <div class="layui-form-item layui-form-text">
					<label class="layui-form-label" id="video">安装包</label>
					<div class="layui-input-block">
				    	<span>
				    		<button type="button" class="layui-btn" id="test3"><i class="layui-icon"></i>上传文件</button>
				    		<label id="biaoti">${KsMsg.fileName}</label>
				    	</span>
				    	<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
					</div>
				     <input type="hidden" name="videoUrl" id="videoUrl" value="1111"/>
					 <input type="hidden" name="fileName" id="fileName" value="${KsMsg.fileName }"/>
				</div> --%>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>状态</label>
				    <div class="layui-input-block">
				      <input type="radio" name="versionStatus" value="0" title="禁用" ${status=='禁用'?'checked':'' } checked>
				      <input type="radio" name="versionStatus" value="1" title="启用" ${status=='启用'?'checked':'' } >
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>是否强制升级</label>
				    <div class="layui-input-block">
				      <input type="radio" name="isForceUpdate" value="0" title="否" ${isForceUpdate=='否'?'checked':'' } checked>
				      <input type="radio" name="isForceUpdate" value="1" title="是" ${isForceUpdate=='是'?'checked':'' } >
				    </div>
				</div>
				<div class="layui-form-item" style="text-align: center;">
					<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
				</div>
			</form>
		</div>
	</div>
	<div id="menuContent" class="menuContent" data-target="parentId" style="display:none; position: absolute;z-index:9999">
		<ul id="tree" class="ztree" style="margin-top:0; min-width:200px; height: 300px;"></ul>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.all.min.js"></script>

    <script type="text/javascript" src="/manage/logistics/assets/data.js"></script>
    <script type="text/javascript" src="/manage/logistics/assets/province.js"></script>
  <script type="text/javascript">
        var defaults = {
            s1: 'provid',
            s2: 'cityid',
            s3: 'areaid',
            v1: '${province}',
            v2: '${city}',
            v3: '${county}'
        };
 
    </script>
	<script type="text/javascript">
	
		layui.use(['element', 'layer', 'table', 'form', 'laydate','upload'], function(){
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			var upload = layui.upload;
			//监听首页展示
			form.on('switch(Isdisplay)', function(obj){
				if(obj.elem.checked){
					$("#weight").show();
				}else{
					$("#weight").hide();
				}
			});
			
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
			
			
			//监听提交
			form.on('submit(addEqBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {
							icon: 1
						}, function() {
							var index = parent.layer.getFrameIndex(window.name);
							 parent.layer.close(index)
						});
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
						});
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/version/newVersionToSave', postData, success, 'post', 'json');
				return false;
			})
			
		});
			
		
	</script>
</m:Content>
</m:ContentPage>