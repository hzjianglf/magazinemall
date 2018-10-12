<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>个人认证</h3>
		</div>
		<div class="grrz">
			<ul>
				<li><span>真实姓名</span> <input type="text" name="realname" id="realname" class="in1" value="${apply.realname }" placeholder="请填写您的真实姓名"></li>
				<li><span>证件类型</span> <select id="documentType"><option value="二代身份证">二代身份证</option></select></li>
				<li><span>身份证号</span> <input type="text" name="identitynumber" id="identitynumber" class="in1" value="${apply.identitynumber }" placeholder="请填写您的身份证号"></li>
				<li>
					<span style=" display: block; width:14rem;">请上传照片</span>
					<button class="sc_biao" id="test1">请上传身份证</button>
					<!-- 身份证 -->
					<input type="hidden" name="IDpic" id="IDpic" value="${apply.IDpic }"/>
					<img id="IDpicUrl" style="width: 7.2rem;height: 4.45rem;border-radius: 0.2rem;border: 0.025rem solid #d2d2d2;display: none;" src="${apply.IDpic }">
					<button class="sc_biao" style=" float: right;" id="test2">请上传本人照</button>
					<img id="selfPicUrl" style="width: 7.2rem;height: 4.45rem;border-radius: 0.2rem;border: 0.025rem solid #d2d2d2;display: none;float: right;" src="${apply.oneselfPic }"/>
					<!-- 本人 -->
					<input type="hidden" name="oneselfPic" id="oneselfPic" value="${apply.oneselfPic }"/>
					<div class="clear"></div>
				</li>
			</ul>
		</div>
        <button class="qr_biao" type="button" onclick="saveApply();">确 定</button>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function(){
				var oneselfPic=$("#oneselfPic").val();
				if(oneselfPic!=null && oneselfPic!=''){
					$("#IDpicUrl").show();
					$("#selfPicUrl").show();
					$("#test1").hide();
					$("#test2").hide();
				}
			})
			layui.use('upload', function(){
				var upload=layui.upload;
				//点击图片
				$("#IDpicUrl").click(function(){
					$("#test1").click();
				})
				
				//执行实例
				var uploadInst = upload.render({
					elem: '#test1', //绑定元素
					url: '/SpecialColumn/uploadImg', //上传接口
					field: 'imgUrl',
					before: function(obj){
					    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
					    obj.preview(function(index, file, result){
					    	$("#test1").hide();
					    	$("#IDpicUrl").show();
					      	$("#IDpicUrl").attr("src", result);
					    });
					},
					done: function(res){
						//上传完毕回调
						$('#IDpic').val(res.data);
					},
					error: function(){
						//请求异常回调
					}
				});
				var uploadInst = upload.render({
					elem: '#test2', //绑定元素
					url: '/SpecialColumn/uploadImg', //上传接口
					field: 'imgUrl',
					before: function(obj){
					    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
					    obj.preview(function(index, file, result){
					    	$("#test2").hide();
					    	$("#selfPicUrl").show();
					      	$("#selfPicUrl").attr("src", result);
					    });
					},
					done: function(res){
						//上传完毕回调
						$('#oneselfPic').val(res.data);
					},
					error: function(){
						//请求异常回调
					}
				});
			});

			//提交
			function saveApply(){
				var realname=$("#realname").val();
				if(realname==null || realname==''){
					tipInfo("请填写真实姓名!");
					return ;
				}
				var documentType=$("#documentType").val();
				if(documentType==null || documentType==''){
					tipInfo("请选择证件类型!");
					return ;
				}
				var identitynumber=$("#identitynumber").val();
				if(identitynumber==null || identitynumber==''){
					tipInfo("请填写身份证号!");
					return ;
				}
				var IDpic=$("#IDpic").val();
				if(IDpic==null || IDpic==''){
					tipInfo("请上传证件照!");
					return ;
				}
				var oneselfPic=$("#oneselfPic").val();
				if(oneselfPic==null || oneselfPic==''){
					tipInfo("请上传本人照片!");
					return ;
				}
				$.ajax({
					type:'post',
					url:'/SpecialColumn/saveApply',
					data:{"documentType":documentType,"identitynumber":identitynumber,"IDpic":IDpic,"oneselfPic":oneselfPic,"realname":realname},
					datatype:'json',
					success:function(data){
						tipInfo(data.msg);
						window.location.href="/usercenter/account/index";
					},
					error:function(){
						tipInfo("出错了!");
					}
				})
			}
			
			function tipInfo(msg){
				layui.use('layer', function(){
					 var layer = layui.layer;
					 layer.msg('<font style="color:#fff" width="100%">' + msg+ '</font>', {
							time : 3000,
							offset : 'auto',
					 });
				});
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
