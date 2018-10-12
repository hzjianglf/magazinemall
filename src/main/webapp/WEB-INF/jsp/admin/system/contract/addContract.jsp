<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib  uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="master">
<pxkj:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<link rel="stylesheet" href="/manage/public/js/themes/default/css/ueditor.css" />
	<style type="text/css">
		body{
			height: 100%;
		}
	</style>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 10px;" class="layui-anim layui-anim-upbit">
		<%-- <blockquote class="layui-elem-quote layui-bg-blue">
			合同${contract.id==null?'添加':'修改' }
		</blockquote> --%>
		<form id="contentInfo" class="layui-form">
		<div class="layui-tab">
			<div class="layui-tab-content" style="background: #FFFFFF;">
				<input type="hidden" name="id" value="${contract.id }"/>
				<div class="layui-form">
	            	<div class="layui-form-item" style="margin-left: 135px;">
	            		<div class="layui-form-inline">
							<label class="layui-form-label">合同名称：</label>
							<div class="layui-input-inline">
								<input type="text" name="title" id="title" value="${contract.title }" lay-verify="required" autocomplete="off" class="layui-input"/>
							</div>
						</div>
						<div class="layui-form-inline">
							<label class="layui-form-label">启用状态：</label>
							<div class="layui-input-inline">
							    <select name="status" id="status" lay-verify="required">
							    	<option value="1" ${contract.status==1?"selected='selected'":"" }>启用</option>
									<option value="0" ${contract.status==0?"selected='selected'":"" }>禁用</option>
							    </select>
						    </div>
					    </div>
					</div>
					<div class="layui-form-item">
						<div class="layui-input-block" style="z-index: 1">
							<script id="editor" type="text/plain" style="width:70%;height:500px;margin-left: 40px;">
								${contract.content }
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
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/ueditor.all.js"> </script>
	<script type="text/javascript" charset="utf-8" src="/manage/public/js/lang/zh-cn/zh-cn.js"></script>
	<script type="text/javascript">
		layui.use('form', function(){
			var form = layui.form;
			form.on('submit(saveBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {icon: 1}, function(){
							var index = parent.layer.getFrameIndex(window.name);
							parent.layer.close(index);
						})
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/system/contract/saveContract', postData, success, 'post', 'json');
				return false;
			});
		})
		//实例化编辑器
	    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
	    var ue = UE.getEditor('editor');
	    function disableBtn(str) {
	        var div = document.getElementById('btns');
	        var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
	        for (var i = 0, btn; btn = btns[i++];) {
	            if (btn.id == str) {
	                UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
	            } else {
	                btn.setAttribute("disabled", "true");
	            }
	        }
	    }
	    function enableBtn() {
	        var div = document.getElementById('btns');
	        var btns = UE.dom.domUtils.getElementsByTagName(div, "button");
	        for (var i = 0, btn; btn = btns[i++];) {
	            UE.dom.domUtils.removeAttributes(btn, ["disabled"]);
	        }
	    }
	</script>
</pxkj:Content>
</pxkj:ContentPage>