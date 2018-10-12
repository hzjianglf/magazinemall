<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
	 <style type="text/css">
		
	 </style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="checkOrder">
			<input type="hidden" name="userId" id="userId" value="${userId}"/>
			<div id="MainContent" class="dataList"></div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/js/jquery.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			var layer;
			layui.use('layer', function(){
				layer = layui.layer;
			});
			$(function(){
				interlucationList();
			});
			function interlucationList(){
				$.get("/home/question/interlucationList?type="+${type},{
					page:1,
					pageSize:8,
					r:Math.random()
				},function(html){
					$("#MainContent").html(html);
				},"html")
			}
			
			//旁听支付
			function payListen(price,questionId,auditType){/* quesOrAnswer 1提问支付 2旁听支付 */
				$.ajax({
					type:"get",
					url:"/home/question/webListenQuestion",
					data:{"money":price,"questionId":questionId,"auditType":auditType},
					datatype:"html",
					async:false,
					success:function(data){
						if(data.result==1){
							$("#content").val("");
							window.location.href = "/home/question/questionPay?payLogId="+data.payLogId+"&price="+price+"&content="+data.content+"&quesOrAnswer=2";
						}else{
							tipinfo(data.msg);
						}
					},
					
				})
			}
			//已支付的直接查看答案
			function lookAnswer(answertype,answer,userId){
				/* if(userId == null || userId == '' || userId == 0){
					tipinfo("请先登录");
					return false;
				} */
				if(answertype=='2'){
					tipinfo(answer);
				}else if(answertype=='1'){
					//tipinfo("别着急，随后给你加个播放器！");
				}
			}	
			
			function tipinfo(obj){
				layer.msg(obj);
			}
			
			
			
			
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
