<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			[contenteditable = "true"], input, textarea {
			    -webkit-user- select: auto!important;
			    -khtml-user-select: auto!important;
			    -moz-user-select: auto!important;
			    -ms-user-select: auto!important;
			    -o-user-select: auto!important;
			    user-select: auto!important;
			}
			.bjzl_nr ul li .in1{
				width:11rem;
				border:1px solid #333;
				line-height: 1.25rem;
				user-select: auto;
				font-size:0.65rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>编辑资料</h3>
		</div>
		<div class="bjzl">
			<div class="bjzl_top">
				<img src="${userUrl }" style="border-radius:50%;">
				<h3>头像会用做公开资料</h3>
			</div>
			<div class="bjzl_nr">
				<ul>
					<li>
						<span>昵称：</span>
						<input type="text" name="nickName" id="nickName" value="${nickName }" class="in1" />
					</li>
					<li>
						<span>性别：</span>
						<select class="in1" name="sex" id="sex">
							<option value="0" ${sex=='0'?'selected':'' }>男</option>
							<option value="1" ${sex=='1'?'selected':'' }>女</option>
							<option value="2" ${sex=='2'?'selected':'' }>未知</option>
						</select>
					</li>
					<li>
						<span>出生日期：</span>
						<input type="text" name="birthDate" id="birthDate" value="${birthDate }" class="in1" />
					</li>
				</ul>
				
			</div>
			<div class="bjzl_nr">
				<ul>
					<li>
						<span>学历：</span>
						<input type="text" name="education" id="education" value="${education }" class="in1" />
					</li>
					<li>
						<span>行业：</span>
						<input type="text" name="industry" id="industry" value="${industry }" class="in1" />
					</li>
					<li>
						<span>职业：</span>
						<input type="text" name="occupation" id="occupation" value="${occupation }" class="in1" />
					</li>
					<li>
						<span>简介：</span>
						<textarea name="synopsis" id="synopsis">${synopsis }</textarea>
					</li>
				</ul>
				<button class="qr_biao" type="button" onclick="savePost();">保存</button>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			layui.use('laydate', function(){
				var laydate=layui.laydate;
				laydate.render({
			   		elem: '#birthDate'
			  	});
			})
			function savePost(){
				var nickName=$("#nickName").val();
				var sex=$("#sex").val();
				var birthDate=$("#birthDate").val();
				var education=$("#education").val();
				var industry=$("#industry").val();
				var occupation=$("#occupation").val();
				var synopsis=$("#synopsis").val();
				
				$.ajax({
					type:'post',
					data:{"nickName":nickName,"sex":sex,"birthDate":birthDate,"education":education,"industry":industry,"occupation":occupation,"synopsis":synopsis},
					url:'/usercenter/account/saveUserMsg',
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
				
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
