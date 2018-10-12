<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<style>
.uploadBox{
	border: 1px solid gray;
    width: 72%;
    height:220px;
    margin-left: 110px;
    margin-top: 0;
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<input type="hidden" name="id" value="${id }" />
            	<div class="layui-form-item">
					<label class="layui-form-label">问题：</label>
					<div class="layui-input-block">
						<input type="text" name="content" lay-verify="required" autocomplete="off" class="layui-input" value="${content }"/>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">分类：</label>
					<div class="layui-input-block" >
						<select name="type" lay-search="">
							<option value="">直接选择或搜索选择</option>
							<c:forEach items="${label }" var="label">
								<option value="${label.id }" ${label.id==meetType?'selected':'' }>${label.name }</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">作者：</label>
					<div class="layui-input-block" >
						<select name="teacher" lay-search="">
							<option value="">直接选择或搜索选择</option>
							<c:forEach items="${teacher }" var="list">
								<option value="${list.userId }" ${list.userId==lecturer?'selected':'' }>${list.name }</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">答案：</label>
					<div class="uploadBox">
						<input type="radio" name="answertype" value="1" ${answertype==1?'checked':'' } checked lay-filter="xuanze" title="音频"/>
						<input type="radio" name="answertype" value="2" ${answertype==2?'checked':'' } lay-filter="xuanze" title="文字"/>
						<div class="layui-input-block" style="margin-left: 20px;width: 85%;height: 160px;">
							<textarea class="layui-textarea" id="answer" name="answer" style="display:none;margin-top: 0px;margin-bottom: 0px;height: 162px;">${answer }</textarea>
							<input type="hidden" name="musicurl" id="musicurl" value="${musicurl }" />
							<div id="div_audio">
								<c:if test="${ not empty musicurl}">
									<audio  controls style="width: 250px;">
										  <source id="audio_url" src="${musicurl}" type="audio/mpeg">
									</audio>
								</c:if>
								<button type="button" class="layui-btn" id="test1" style="margin:10px 0;">
									<i class="layui-icon">&#xe67c;</i>上传
								</button>
							</div>
						</div>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">价格：</label>
					<div class="layui-input-block">
						<input type="text" name="price" lay-verify="required" autocomplete="off" class="layui-input" value="${money }"/>
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" lay-filter="addEqBtn">提交</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		$(function(){
			var check = $("input[name='answertype']:checked").val();
			if(check==2){
				$("#answer").show();
				$("#div_audio").hide();
			}else{
				$("#answer").hide();
				$("#div_audio").show();
			}
		})
		layui.use(['form','upload'], function(){
			var form = layui.form;
			var upload = layui.upload;
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
				ajax('/${applicationScope.adminprefix }/meetprofessor/addOrUp', postData, success, 'post', 'json');
				return false;
			})
			//监听单选框选择事件
			form.on('radio(xuanze)', function(){
				var v = $(this).val();
				if(v==1){
					$("#answer").hide();
					$("#div_audio").show();
				}else if(v==2){
					$("#answer").show();
					$("#div_audio").hide();
				}
			})
			
			//上传音频
			var uploadInst = upload.render({
				elem: '#test1', //绑定元素
				url: '/${applicationScope.adminprefix }/ondemand/uploadImg', //上传接口
				accept: 'audio', //音频
				field:'imgUrl',
				before: function(obj){
				    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
				    obj.preview(function(index, file, result){
				    	//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
				      	//这里还可以做一些 append 文件列表 DOM 的操作
				      	//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
				      	//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
				    });
				},
				done: function(res){
					//上传完毕回调
					$('#musicurl').val(res.data);
					tipinfo("音频上传成功！");
				},
				error: function(){
					//请求异常回调
				}
			});
		})
	</script>
</m:Content>
</m:ContentPage>