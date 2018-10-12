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
		.upload-img{
			width:120px;
			height:90px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-gray">
			用户信息
		</blockquote>
		<form class="layui-form" action="">
		<div class="layui-tab-content">
			<div class="layui-tab-item layui-show">
		    	<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
					<input type="hidden" name="userId" id="userId" value="${userId }" />
					<input type="hidden" name="userType" id="userType" value="${userType }" />
					<div class="layui-form-item">
						<label class="layui-form-label">昵称：</label>
						<div class="layui-input-block">
							<input type="text" name="nickName" value="${userMap.nickName }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
						<label class="layui-form-label" id="oneselfPic">更换头像</label>
						<div class="layui-input-block">
					    		<button type="button" class="layui-btn" id="test2"><i class="layui-icon"></i>上传文件</button>
					    		<%-- <label id="biaoti2">${KsMsg.fileName}</label> --%>
					    		<div class="layui-upload-list">
									<img class="layui-upload-img upload-img" src="${userMap.userUrl }" id="demo1">
								</div>
					    	<p style="color:gray;"><span style="color: red;">*</span>文件大小不超过1GB</p>
						</div>
					     <input type="hidden" name="userUrl" id="userUrl" value="${userMap.userUrl }"/>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">性别：</label>
						<div class="layui-input-block">
							<input type="radio" class="sex" name="sex" value="0" style="margin-top: 8px;" 
									${userMap.sex==0?"checked='checked'":"" }/> 男
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" class="sex" name="sex" value="1" style="margin-top: 8px;"
									${userMap.sex==1?"checked='checked'":"" }/> 女
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">出生日期：</label>
						<div class="layui-input-block">
							<input type="text" class="layui-input addtime" name="birthDate" id="birthDate" lay-verify="required" value="${userMap.birthDate }" placeholder="请选择日期范围">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">手机号：</label>
						<div class="layui-input-block">
							<input type="text" name="telenumber" value="${userMap.telenumber }" lay-verify="phone" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">注册时间：</label>
						<div class="layui-input-block">
							<input type="text" class="layui-input registrationDate" name="registrationDate" lay-verify="required" value="${userMap.registrationDate }" id="registrationDate" placeholder="请选择日期范围">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">积分：</label>
						<div class="layui-input-block">
							<input type="text" name="accountJF" value="${userMap.accountJF }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">余额：</label>
						<div class="layui-input-block">
							<input type="text" name="balance" value="${userMap.balance }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">学历：</label>
						<div class="layui-input-block">
							<input type="text" name="education" value="${userMap.education }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">行业：</label>
						<div class="layui-input-block">
							<input type="text" name="industry" value="${userMap.industry }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">职业：</label>
						<div class="layui-input-block">
							<input type="text" name="occupation" value="${userMap.occupation }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">简介：</label>
					    <div class="layui-input-block">
					      <textarea name="synopsis" placeholder="请输入内容" class="layui-textarea">${userMap.synopsis }</textarea>
					    </div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">密码：</label>
						<div class="layui-input-block">
							<input type="password" name="userPwd" value="${userMap.userPwd }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
					    <label class="layui-form-label">免购买用户:</label>
						<input type="checkbox" name="noPurchaseUser" id="noPurchaseUser"
						${userMap.noPurchaseUser==2?"checked='checked'":"" }/>
					</div>
				</div>
		    </div>
		</div>
		<c:if test="${userType == '2' }">
		<blockquote class="layui-elem-quote layui-bg-gray">
			认证信息
		</blockquote>
		<div class="layui-tab-content">
			<div class="layui-tab-item layui-show">
		    	<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
		    		<div class="layui-form-item">
						<label class="layui-form-label">证件类型：</label>
						<div class="layui-input-block">
							<input type="text" name="documentType" value="${userMap.documentType }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">证件号码：</label>
						<div class="layui-input-block">
							<input type="text" name="identitynumber" value="${userMap.identitynumber }" autocomplete="off" placeholder="" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">证件照片：</label>
						<div class="layui-input-block">
								<img class="layui-upload-img upload-img" src="${userMap.IDpic }">						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">审核：</label>
						<div class="layui-input-block">
							<input type="radio" class="sex" name="approve" value="1" style="margin-top: 8px;" disabled="disabled" 
									${userMap.approve==1?"checked='checked'":"" }/> 审核通过
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" class="sex" name="approve" value="2" style="margin-top: 8px;" disabled="disabled" 
									${userMap.approve==2?"checked='checked'":"" }/> 审核驳回
						</div>
					</div>
					<div class="layui-form-item layui-form-text">
					    <label class="layui-form-label">审核意见：</label>
					    <div class="layui-input-block">
					      <textarea name="opinion" placeholder="请输入内容" class="layui-textarea">${userMap.opinion }</textarea>
					    </div>
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
							<input type="text" name="rewardNum" value="${writerMsg.rewardNum }" autocomplete="off" placeholder="" class="layui-input">
							<p style="color:gray;">比如，设置为100，则前台作家详情页里面，就是打赏人数100，有2个人打赏就是102人打赏</p>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">是否推荐：</label>
						<div class="layui-input-block">
							<input type="radio" class="sex" name="IsRecommend" value="0" style="margin-top: 8px;" 
									${userMap.IsRecommend==0?"checked='checked'":"" }/> 不推荐
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" class="sex" name="IsRecommend" value="1" style="margin-top: 8px;"
									${userMap.IsRecommend==1?"checked='checked'":"" }/> 推荐
							<p style="color:gray;">推荐后可在app首页显示</p>
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label">问答价格:</label>
						<div class="layui-input-block">
							<input type="text" lay-verify="required"  name="questionPrice" value="${writerMsg.questionPrice }"  class="layui-input">
						</div>
					</div>
		    	</div>
		    </div>
		</div>
		</c:if>
		<div class="layui-form-item">
			<div class="layui-input-block">
				<button class="layui-btn" lay-submit="" lay-filter="savePost">提交</button>
				<button class="layui-btn " id="close">返回</button>
			</div>
		</div>
		</form>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use(['element', 'layer', 'form', 'laydate','upload'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			var upload = layui.upload;
			laydate.render({
		    	elem: '#birthDate'
		    });
			//自定义验证规则
			form.verify({
				title: function(value) {
					if(value.length < 3) {
						return '标题至少得3个字符';
					}
				},
				pass: [/(.+){6,12}$/, '密码必须6到12位']
			});
			$("#close").click(function(){
				var index = parent.layer.getFrameIndex(window.name);
				 parent.layer.close(index)
			})
			//监听提交
			form.on('submit(savePost)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {
							icon: 1
						}, function() {
							var index = parent.layer.getFrameIndex(window.name);
							 parent.layer.close(index)
							// parent.tableIns.reload({});
						});
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
							//parent.tableIns.reload({});
						});
					}
				}
				var postData = $(data.form).serialize();
				var noPurchaseUser = $("#noPurchaseUser").is(":checked");;
				var isPurchaseUser = 1;
				if(noPurchaseUser){
					isPurchaseUser = 2;
				}
				ajax('/${applicationScope.adminprefix }/consumer/editUser?isPurchaseUser='+isPurchaseUser, postData, success, 'post', 'json');
				return false;
			});
			
			upload.render({
			    elem: '#test2'
			    ,url: '/${applicationScope.adminprefix }/ondemand/uploadImg'
			   	,field: 'imgUrl'
			    ,accept: 'file' //视频
			    ,size: 1048576 //单位KB
			    ,before:function(obj){
			    	obj.preview(function(index, file, result){
				        $('#demo1').attr('src', result); //图片链接（base64）
					});
			    }
			    ,done: function(res){
			    	loading();
			    	//截取文件名称
			    	$("#userUrl").val(res.data);
			    	$("#biaoti2").text(res.fileName);
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
			
		})
	</script>
</m:Content>
</m:ContentPage>
