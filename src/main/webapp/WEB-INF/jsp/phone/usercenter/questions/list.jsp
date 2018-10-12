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
			<a onclick="fanhui();" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>提问</h3>
		</div>
		<c:if test="${userType=='2' }">
			<div class="xxk">
				<ul>
					<li class="on" data-state="1"><em>|</em><span>我的提问</span></li>
					<li data-state="2"><span>提问我的</span></li>
				</ul>
			</div>
		</c:if>
		<div id="MainContent">
			<div class="wdtw" >
				<div id="content"></div>
			</div>
		</div>
		
		
			<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//加载我的提问
				myQuiz(1);
				
			});
			//切换效果
			$('.xxk').find('li').click(function() {
				$('.xxk').find('li').removeClass('on');
				$(this).addClass('on');
				myQuiz($(this).data("state"));
				$("#content,#Div_Temp").html("");
			});
			function myQuiz(type){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#MainContent' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/usercenter/account/myQuizData",{
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
			//查看答案
			function selectQues(count){
				//获取答案
				var content=$("#answer"+count).text();
				bottomwin(content);
			}
			function fanhui(){
				window.history.go(-1);
			}
			//专家点击回答按钮
			function toAnswerQues(id,lecturer){
				$("#iterlocationId").val(id);
				$("#lecturerId").val(lecturer);
				var show = document.getElementById("ans_ques");
				show.style.display = "block";
			}
			//关闭-专家回答弹框
			function deleteAnswer() {
				var del = document.getElementById("ans_ques");
				del.style.display = "none";
			}
			//回答弹框-点击确定
			function confirmToAns() {
				var id = $("#iterlocationId").val();
				var lecturerId = $("#lecturerId").val();
				var questionMsg = $("#questionMsg").val();
				if(questionMsg==null||questionMsg==''){
					tipinfo("请输入回答内容");
					return false;
				}
				//window.location.href="/api/question/answerQuestion?id="+id+"&answer="+questionMsg+"&userId="+lecturerId+"&answertype="+2;
				$.ajax({
					type:'post',
					data:{"id":id,"answer":questionMsg,"userId":lecturerId,"answertype":2},
					url:"/api/question/answerQuestion",
					datatype:'json',
					success:function(data){
						if(data.result == 1){
							var del = document.getElementById("ans_ques");
							del.style.display = "none";
							location.reload();
						}else{
							tipinfo(data.msg);
						}
					},
					error:function(){
						alert("出错了!");
					}
				})
				
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
