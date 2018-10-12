<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
		.uploadBox{
			width: 10%;
		    margin-left: 10%;
		    margin-top: -55px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<form class="layui-form" action="">
		<div class="layui-tab-content">
			<div class="layui-tab-item layui-show">
		    	<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
					<input type="hidden" name="id" id="id" value="${id }" />
					<div class="layui-form-item">
						<label class="layui-form-label"><span style="color:red;">*</span>名称：</label>
						<div class="layui-input-block">
							<input type="text" name="methodName" value="${methodName }" lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">账户ID：</label>
						<div class="layui-input-block">
							<input type="text" name="accountId" value="${accountId }" lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">MD5密钥：</label>
					    <div class="layui-input-block">
					      <textarea name="encryptionKey" placeholder="请输入内容" class="layui-textarea">${encryptionKey }</textarea>
					    </div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">展示图：</label>
						<div class="layui-input-block">
							<input type="hidden" name="picUrl" id="picUrl" value="${picUrl }" />
							<button type="button" class="layui-btn" id="test1" style="display:block;margin:10px 0;">
								<i class="layui-icon">&#xe67c;</i>上传图片
							</button>
							<div class="uploadBox">
								<img src="${picUrl }" id="imgShow" />
							</div>
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">介绍：</label>
					    <div class="layui-input-block">
					      <textarea name="methodIntro" placeholder="请输入内容" class="layui-textarea">${methodIntro }</textarea>
					    </div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">支付接口类型：</label>
						<div class="layui-input-block">
							<select name="payType">
								<option value="">--请选择--</option>
								<c:forEach items="${list }" var="list">
									<option value="${list.name }" ${payType==list.name?'selected':'' }>${list.name }</option>
								</c:forEach>
							</select>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">应用平台：</label>
						<div class="layui-input-block">
							<select name="platformType">
								<option value="1" ${platformType==1?'selected':'' }>所有</option>
								<option value="2" ${platformType==2?'selected':'' }>PC</option>
								<option value="3" ${platformType==3?'selected':'' }>PHONE</option>
								<option value="4" ${platformType==4?'selected':'' }>APP</option>
								<option value="5" ${platformType==5?'selected':'' }>微信公众号</option>
							</select>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">是否默认：</label>
						<div class="layui-input-block">
							<input type="checkbox" name="isDefault" ${isDefault==1?'checked':'' } id="isDefault" lay-skin="switch" lay-text="是|否">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">是否禁用：</label>
						<div class="layui-input-block">
							<input type="checkbox" name="isfreeze"  ${isfreeze==1?'checked':'' } id="isfreeze" lay-skin="switch" lay-text="是|否">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">手续费：</label>
						<div class="layui-input-block">
							<input type="text" name="rate" value="${rate }" lay-verify="required" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block">
							<button class="layui-btn" lay-submit="" lay-filter="savePost">提交</button>
						</div>
					</div>
				</div>
		    </div>
		</div>
		</form>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use(['layer', 'form', 'laydate','upload'], function() {
			var layer = layui.layer;
			var form = layui.form;
			var upload = layui.upload;
			//监听提交
			form.on('submit(savePost)', function(data){
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
				ajax('/${applicationScope.adminprefix }/system/paymethod/savePayment', postData, success, 'post', 'json');
				return false;
			});
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
