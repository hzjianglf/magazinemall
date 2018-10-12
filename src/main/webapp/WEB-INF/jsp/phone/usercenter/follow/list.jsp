<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1);" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>关注</h3>
		</div>
		<c:if test="${userType=='2' }">
			<div class="xxk">
				<ul>
					<li class="on" data-state="1"><em>|</em><span>我的关注</span></li>
					<li data-state="2"><span>关注我的</span></li>
				</ul>
			</div>
		</c:if>
		
		<div class="wdtw" id="MainContent">
			<div id="content"></div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//加载我的关注
				myAudit(1);
			});
			//切换效果
			$('.xxk').find('li').click(function() {
				$('.xxk').find('li').removeClass('on');
				$(this).addClass('on');
				myAudit($(this).data("state"));
				$("#content,#Div_Temp").html("");
			});
			function myAudit(type){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#MainContent' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/usercenter/account/myfollow",{
								page:page,
								pageSize:6,
								state:type,
								r:Math.random()
							},function(html){
								$("#content,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			//取消关注
			function cancelFollow(userId){
				
				confirminfo("确定不关注此人?",function(){
					$.ajax({
						type:'post',
						data:{"teacherId":userId},
						url:'/home/cancelFoolow',
						datatype:'json',
						success:function(data){
							tipinfo(data.msg);
							if(data.success){
								$("#div_"+userId).remove();
							}
						},
						error:function(){
							tipinfo("取消失败,请稍后再试!");
						}
					})
				})
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
