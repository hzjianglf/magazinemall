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
.upload-img{
	width:120px;
	height:90px;
}
.layui-input-block{
	margin-left:190px;
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div id="bodyId" style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>专家手机号：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="" name="telenumber"
				        lay-verify="required"  class="layui-input" id="telenumber">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>密码：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="" name="password"  lay-verify="required"  class="layui-input" id="password">
				    </div>
				</div>
				<div class="layui-form-item layui-form-text">
					<label class="layui-form-label" id="oneselfPic">头像</label>
					<div class="layui-input-block">
						<button type="button" class="layui-btn" id="test3"><i class="layui-icon"></i>上传头像</button>
						<div class="layui-upload-list">
							<img class="layui-upload-img upload-img" id="demo1">
							<p id="demoText"></p>
						</div>
						<%-- <label id="biaoti3">${KsMsg.fileName}</label> --%>
						<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
					</div>
					<input type="hidden" name="userUrl" id="userUrl" value=""/>
					<input type="hidden" name="fileName3" id="fileName3" value="${KsMsg.fileName }"/>
				</div>
				
				
				<blockquote class="layui-elem-quote layui-bg-gray">
					认证信息
				</blockquote>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>真实姓名：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="" name="realname"  lay-verify="required"  class="layui-input" id="realname">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>证件类型：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="" name="documentType"  lay-verify="required"  class="layui-input" id="documentType">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>身份证号：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="" name="identitynumber"  lay-verify="identity"  class="layui-input" id="identitynumber">
				    </div>
				</div>
				<div class="layui-form-item layui-form-text">
					<label class="layui-form-label" id="IDpic">身份证照片</label>
					<div class="layui-input-block">
				    		<button type="button" class="layui-btn" id="test1"><i class="layui-icon"></i>身份证照片</button>
				    		<div class="layui-upload-list">
							    <img class="layui-upload-img upload-img" id="demo2">
							    <p id="demoText"></p>
							</div>
				    		<%-- <label id="biaoti1">${KsMsg.fileName}</label> --%>
				    	<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
					</div>
				     <input type="hidden" name="IDpic" id="IDpicUrl" value=""/>
					 <input type="hidden" name="fileName1" id="fileName1" value="${KsMsg.fileName }"/>
				</div>
				<div class="layui-form-item layui-form-text">
					<label class="layui-form-label" id="oneselfPic">本人照片</label>
					<div class="layui-input-block">
				    		<button type="button" class="layui-btn" id="test2"><i class="layui-icon"></i>上传本人照片</button>
				    		<div class="layui-upload-list">
							    <img class="layui-upload-img upload-img" id="demo3">
							    <p id="demoText"></p>
							</div>
				    		<%-- <label id="biaoti2">${KsMsg.fileName}</label> --%>
				    	<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
					</div>
				     <input type="hidden" name="oneselfPic" id="oneselfPicUrl" value=""/>
					 <input type="hidden" name="fileName2" id="fileName2" value="${KsMsg.fileName }"/>
				</div>
				<div class="layui-form-item">
						<div class="layui-inline">
							<label class="layui-form-label">专家等级：</label>
							<div class="layui-input-inline">
								<select class="layui-input" name="vipGrade">
									<option value="0">请选择</option>
									<option value="1" ${writerMsg.vipGrade==1?'selected':'' }>一级</option>
									<option value="2" ${writerMsg.vipGrade==2?'selected':'' }>二级</option>
								</select>
							</div>
						</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">打赏基数：</label>
					<div class="layui-input-block">
						<input type="text" name="rewardNum" value="${writerMsg.rewardNum }" autocomplete="off" placeholder="请只输入数字" class="layui-input"
						   id="rewardNumValue" onkeyup="if (!(/^[\d]+?\d*$/.test(this.value)) ){tipinfo('请输入数字');this.value='1';this.focus();}">
						<p style="color:gray;">比如，设置为100，则前台作家详情页里面，就是打赏人数100，有2个人打赏就是102人打赏</p>
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
			
			//身份证照片-上传文件
			upload.render({
			    elem: '#test1'
			    ,url: '/${applicationScope.adminprefix }/ondemand/uploadImg'
			   	,field: 'imgUrl'
			    ,accept: 'file' //视频
			    ,size: 1048576 //单位KB
			    ,before:function(obj){
					//预读本地文件示例，不支持ie8
					obj.preview(function(index, file, result){
				        $('#demo2').attr('src', result); //图片链接（base64）
					});
				},done: function(res){
			    	loading();
			    	//截取文件名称
			    	$("#IDpicUrl").val(res.data);
			    	$("#biaoti1").text(res.fileName);
			    	$("#fileName1").val(res.fileName);
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
			//身份证照片-上传文件
			upload.render({
			    elem: '#test2'
			    ,url: '/${applicationScope.adminprefix }/ondemand/uploadImg'
			   	,field: 'imgUrl'
			    ,accept: 'file' //视频
			    ,size: 1048576 //单位KB
			    ,before:function(obj){
					//预读本地文件示例，不支持ie8
					obj.preview(function(index, file, result){
				        $('#demo3').attr('src', result); //图片链接（base64）
					});
				},done: function(res){
			    	loading();
			    	//截取文件名称
			    	$("#oneselfPicUrl").val(res.data);
			    	$("#biaoti2").text(res.fileName);
			    	$("#fileName2").val(res.fileName);
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
			
			//上传头像
			upload.render({
			    elem: '#test3'
			    ,url: '/${applicationScope.adminprefix }/ondemand/uploadImg'
			   	,field: 'imgUrl'
			    ,accept: 'file' //视频
			    ,size: 1048576 //单位KB
			    ,before:function(obj){
					//预读本地文件示例，不支持ie8
					obj.preview(function(index, file, result){
				        $('#demo1').attr('src', result); //图片链接（base64）
					});
				},done: function(res){
			    	loading();
			    	//截取文件名称
			    	$("#userUrl").val(res.data);
			    	$("#biaoti3").text(res.fileName);
			    	$("#fileName3").val(res.fileName);
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
				
				var telenumber = $("#telenumber").val();
				if(telenumber == null || telenumber == ''){
					alert("请输入手机号");
					return false;
				}
				if(password == null || password == ''){
					alert("请输入密码");
					return false;
				}
				var rewardNumValue = $("#rewardNumValue").val();
				//alert(rewardNumValue);
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/consumer/expertRegisterToSave', postData, success, 'post', 'json');
				return false;
			})
			
		});
			
		
	</script>
</m:Content>
</m:ContentPage>