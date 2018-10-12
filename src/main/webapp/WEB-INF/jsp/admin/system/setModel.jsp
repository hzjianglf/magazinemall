<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="pxkj"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<px:ContentPage materPageId="master">
	<px:Content contentPlaceHolderId="css">
	<style>
	
	.layui-form-label{
		width:100px!important;
	}
	.layui-input-block{
	    margin-left: 140px!important;
	}
	</style>
	</px:Content>
	<px:Content contentPlaceHolderId="content">
		<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
			<div class="yw_cx">
				<blockquote class="layui-elem-quote  layui-bg-blue">基本信息</blockquote>
			</div>
			<div class="layui-tab">
				<ul class="layui-tab-title">
					<li class="layui-this">网站设置</li>
					<li>短信设置</li>
					<li>微信设置</li>
					<li>网易设置</li>
					<li>后台地址前缀配置</li>
				</ul>
				<div class="layui-tab-content">
					<!-- 网站设置 -->
					<div class="layui-tab-item layui-show">
						<form class="layui-form" action="" id="WebSetForm">
							<input type="hidden" value="" name="imgUrl" id="imgUrl" />
			    			<input type="hidden" value="${siteInfo.imgUrl }" id="oldImgUrl"/>
							<div class="layui-form-item">
								<label class="layui-form-label">网站域名：</label>
								<div class="layui-input-block">
									<input type="text" name="siteUrl" value="${siteInfo.siteUrl }" autocomplete="off" placeholder="网站域名" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">网站名称：</label>
								<div class="layui-input-block">
									<input type="text" name="siteName" value="${siteInfo.siteName }" autocomplete="off" placeholder="网站名称" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">网站标题：</label>
								<div class="layui-input-block">
									<input type="text" name="siteTitle" value="${siteInfo.siteTitle }" autocomplete="off" placeholder="网站标题" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">网站LOGO：</label>
								<div class="layui-input-block">
									<button type="button" class="layui-btn" id="test1">
										<i class="layui-icon">&#xe67c;</i>上传图片
									</button>
									<div style="margin-top: 7px;padding: 0;height: 100px;">
		                                <img src="${siteInfo.imgUrl }" id="imgShow" width="100px"/>
		                                <input type="button" value="删除图片" onclick="deleteImg()" id="delImg" style="display: none;" class="layui-btn layui-btn-warm"/>
		                            </div>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">联系电话：</label>
								<div class="layui-input-block">
									<input type="text" name="siteTel" value="${siteInfo.siteTel }" autocomplete="off" placeholder="服务热线" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">电子邮件：</label>
								<div class="layui-input-block">
									<input type="text" name="email" value="${siteInfo.email }" autocomplete="off" placeholder="电子邮件" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">ICP证书号：</label>
								<div class="layui-input-block">
									<input type="text" name="icpNO" value="${siteInfo.icpNO }" autocomplete="off" placeholder="ICP证书号，若为空显示备案信息" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">版权所有：</label>
								<div class="layui-input-block">					
									<textarea placeholder="网站版权信息" name="copyRight" class="layui-textarea">${siteInfo.copyRight}</textarea>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">办公地址：</label>
								<div class="layui-input-block">	
									<textarea placeholder="办公地址" name="address" id="address" class="layui-textarea">${siteInfo.address}</textarea>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">网站关键字：</label>
								<div class="layui-input-block">
								 	<textarea placeholder="网站关键字" name="metaKeywords" class="layui-textarea">${siteInfo.metaKeywords}</textarea>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">网站描述：</label>
								<div class="layui-input-block">
									<textarea placeholder="网站描述" name="metaDescription" class="layui-textarea">${siteInfo.metaDescription}</textarea>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label" >站点状态：</label>
								<div class="layui-input-block">
									<input type="checkbox" name="siteStatus" lay-skin="switch" lay-text="开启|关闭" ${siteInfo.siteStatus==true?'checked="checked"':'' }>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">关闭提示：</label>
								<div class="layui-input-block">
									<textarea placeholder="站点关闭时提示信息" name="closeTip" class="layui-textarea">${siteInfo.closeTip}</textarea>
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">二维码标题：</label>
								<div class="layui-input-block">
									<input type="text" name="pcSiteTitle" value="${siteInfo.pcSiteTitle }" autocomplete="off" placeholder="PC网站标题" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="WebSave">提交</button>
								</div>
							</div>
						</form>
					</div>
					<!-- 短信设置 -->
					<div class="layui-tab-item">
						<form class="layui-form" action="" id="SmsSetForm">
							<div class="layui-form-item">
								<label class="layui-form-label" >服务器地址：</label>
								<div class="layui-input-block">
									<input type="text" name="server" value="${smsSetting.server }" autocomplete="off" placeholder="服务器地址" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">账户：</label>
								<div class="layui-input-block">
									<input type="text" name="account" value="${smsSetting.account }" autocomplete="off" placeholder="服务器地址" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">密码：</label>
								<div class="layui-input-block">
									<input type="text" name="password" value="${smsSetting.password }" autocomplete="off" placeholder="密码" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">特服号：</label>
								<div class="layui-input-block">
									<input type="text" name="serviceNumber" value="${smsSetting.serviceNumber }" autocomplete="off" placeholder="特服号" class="layui-input">
								</div>
							</div>
							<c:forEach items="${smsMsgList}" var="item">
								<div class="layui-form-item">
									<label class="layui-form-label">${item.name }：</label>
									<div  class="layui-input-block">
										<textarea placeholder="短信模板内容" name="msg" data-name="${item.name }" class="layui-textarea msg">${item.messge}</textarea>
									</div>
								</div>
							</c:forEach>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="SmsSave">提交</button>
								</div>
							</div>
						</form>
					</div>
					<!-- 微信设置 -->
					<div class="layui-tab-item">
						<form action="" class="layui-form" id="WechatSettingForm">
							<div class="layui-form-item">
								<label class="layui-form-label">AppId：</label>
								<div class="layui-input-block">
									<input type="text" name="appId" value="${wechatSetting.appId }" autocomplete="off" placeholder="appId" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">AppSecret：</label>
								<div class="layui-input-block">
									<input type="text" name="appSecret" value="${wechatSetting.appSecret }" autocomplete="off" placeholder="appSecret" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">Token：</label>
								<div class="layui-input-block">
									<input type="text" name="token" value="${wechatSetting.token }" autocomplete="off" placeholder="token" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="WechatSettingSave">提交</button>
								</div>
							</div>
						</form>
					</div>
					<!-- 网易设置 -->
					<div class="layui-tab-item">
						<form action="" class="layui-form" id="VcloudSettingForm">
							<div class="layui-form-item">
								<label class="layui-form-label">AppKey：</label>
								<div class="layui-input-block">
									<input type="text" name="appKey" value="${vcloudSetting.appKey}" autocomplete="off" placeholder="appKey" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">AppSecret：</label>
								<div class="layui-input-block">
									<input type="text" name="appSecret" value="${vcloudSetting.appSecret }" autocomplete="off" placeholder="appSecret" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="VcloudSettingSave">提交</button>
								</div>
							</div>
						</form>
					</div>
					<!-- 后台地址前缀配置 -->
					<div class="layui-tab-item">
						<form class="layui-form" action="" id="adminPreFixSetForm">
							<div class="layui-form-item">
								<label class="layui-form-label" >后台地址前缀：</label>
								<div class="layui-input-block">
									<input type="text" name="adminUrl" lay-verify="required" value="${adminPreFixSetting.adminUrl }" autocomplete="off" placeholder="后台地址前缀" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button class="layui-btn" lay-submit="" lay-filter="adminPreFixSetSave">提交</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</px:Content>
	<px:Content contentPlaceHolderId="js">
		<script>
		layui.use(['element', 'layer', 'form', 'laydate', 'upload'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			var upload = layui.upload;
			//网站设置
			form.on('submit(WebSave)', function(data) {
				//layer.msg(JSON.stringify(data.field));
				layer.load(2, {
					shade: [0.8, '#393D49']
				});
				var success = function(response) {
					var result = response;
					if(result.success) {
						layer.alert(result.msg, {
							icon: 1
						}, function() {
							location.reload();
						});
					} else {
						layer.alert(result.msg, {
							icon: 2
						}, function() {
							location.reload();
						});
					}

				}
				var imgUrl = $('#imgUrl').val();
				if (imgUrl == ''){
					imgUrl = $('#oldImgUrl').val();
				}
				var data = {
					siteName: data.field.siteName,
					siteTitle: data.field.siteTitle,
					siteUrl: data.field.siteUrl,
					siteTel: data.field.siteTel,
					metaKeywords: data.field.metaKeywords,
					metaDescription: data.field.metaDescription,
					imgUrl: imgUrl,
					address:$('#address').val(),
					email: data.field.email,
					icpNO: data.field.icpNO,
					siteStatus: data.field.siteStatus,
					closeTip: data.field.closeTip,
					copyRight: data.field.copyRight,
					pcSiteTitle: data.field.pcSiteTitle,
					r:Math.random()
				}
				ajax("/${applicationScope.adminprefix }/system/set/saveSetting", data, success);
				return false;
			});
			//后台地址前缀
			form.on('submit(adminPreFixSetSave)', function(data) {
				//layer.msg(JSON.stringify(data.field));
				layer.load(2, {
					shade: [0.8, '#393D49']
				});
				var success = function(response) {
					var result = response;
					if(result.success) {
						layer.alert(result.msg, {
							icon: 1
						}, function() {
							window.parent.location.href="/"+result.adminUrl+"/index";
						});
					} else {
						layer.alert(result.msg, {
							icon: 2
						}, function() {
							location.reload();
						});
					}

				}
			
				var data = {
					adminUrl: data.field.adminUrl
				}
				ajax("/${applicationScope.adminprefix }/system/set/saveAdminPreFixSetting", data, success);
				return false;
			});
			//短信配置
			form.on('submit(SmsSave)', function(data) {
				//layer.msg(JSON.stringify(data.field));
				layer.load(2, {
					shade: [0.8, '#393D49']
				});
				var success = function(response) {
					var result = response;
					if(result.success) {
						layer.alert(result.msg, {
							icon: 1
						}, function() {
							location.reload();
						});
					} else {
						layer.alert(result.msg, {
							icon: 2
						}, function() {
							location.reload();
						});
					}

				}
				var arr=[];
    			$(".msg").each(function(){
    				var v=$(this).val();
    				var n=$(this).data("name");
    				arr.push({
    					name:n,
    					message:v
    				});
    			})
				var data = {
					server: data.field.server,
					account: data.field.account,
					password: data.field.password,
					serviceNumber: data.field.serviceNumber,
					message:JSON.stringify(arr)
				}
				ajax("/${applicationScope.adminprefix }/system/set/saveSmsSetting", data, success);
				return false;
			});
			//微信设置
			form.on('submit(WechatSettingSave)', function(data) {
				loading(true);
				ajax(getUrl("system/set/saveWechatSetting"),{
					appId:data.field.appId,
					appSecret:data.field.appSecret,
					token:data.field.token
				},function(json){
					alertinfo(json.msg,json.success);
					if(json.success){
						location.reload();
					}
				})
				return false;
			});
			//网易设置
			form.on('submit(VcloudSettingSave)', function(data) {
				loading(true);
				ajax(getUrl("system/set/saveVcloudSetting"),{
					appKey:data.field.appKey,
					appSecret:data.field.appSecret,
					token:data.field.token
				},function(json){
					alertinfo(json.msg,json.success);
					if(json.success){
						location.reload();
					}
				})
				return false;
			});
			
			//执行实例
			var uploadInst = upload.render({
				elem : '#test1', //绑定元素
				url: '/${applicationScope.adminprefix }/system/set/uploadImg', //上传接口
				field : 'imgUrl',
				before : function(obj) {
					//预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
					obj.preview(function(index, file, result) {
						//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
						$("#imgShow").show();
						$("#imgShow").attr("src", result);
						//这里还可以做一些 append 文件列表 DOM 的操作
						//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
						//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
					});
				},
				done : function(res) {
					//上传完毕回调
					$('#imgUrl').val(res.data);
				},
				error : function() {
					//请求异常回调
				}
			});
			
		});
		
		$(function() {
			var imgUrl = "${siteInfo.imgUrl }";
			if (imgUrl != "") {
				$("#delImg").show();
			}
		})

		//删除图片
		function deleteImg() {
			$("#imgShow").attr("src", "");
			$("#imgShow").hide();
			$("#oldPicUrl").val("");
			$("#delImg").hide();
		}
          
        </script>
	</px:Content>
</px:ContentPage>
