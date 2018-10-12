<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="PhoneMaster">
	<m:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			.bf_biao2 {
			    float: left;
			    height: 1.45rem;
			    line-height: 1.45rem;
			    border-radius: 0.75rem;
			    border: 0.025rem solid #e08500;
			    font-size: 0.6rem;
			    color: #E08500;
			    position: relative;
			    text-indent: 0.7rem;
			    padding-right: 0.55rem;
			}
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>问答列表</h3>
			<a href="/home/turnSearche" class="a2"><!-- <img src="/images/ss_biao.png" class="ss_biao"> --></a>
		</div>
		<div class="hdlb">
			<div class="xxk">
				<ul>
					<li class="on"><em>|</em><span>在线问答</span></li>
					<li><span>营销百科</span></li>
				</ul>
			</div>
			<div class="det_content2">
				<!-- 问答列表 -->
				<div class="zzwd" id="question_0">
					<div id="que_content_0"></div>
				</div>
				<!-- 专家答疑  -->
				<div class="zzwd hide" id="question_1">
					<div class="zjjd_fl" id="questionType">
						
					</div>
					<div id="que_content_1"></div>
				</div>
			</div>
		</div>
		<div id="Div_Temp" style="display: none;"></div>
		<!-- 回复弹窗 -->
		<div class="pj_nr" id="login_box3" style="display: none;">
		    <div class="pj_nr_xq">
		        <h3>向大咖提问</h3>
				<textarea name="content" id="content" placeholder="大咖将在72小时内语音回答提问，否则全额退款。问答被他人旁听你将获得分成收益。"></textarea>
				<div class="nmpj"><button id="addQues" >提问</button><input type="checkbox" id="niming" name="niming">匿名评论<span style="color: red;margin-left: 30%;font-size: 17px;" id="redPrice"></span></div>
			</div>
		</div>
		<input type="hidden" name="type" id="type"><!-- 向专家2/课程1提问  -->
		<input type="hidden" name="beAskedId" id="beAskedId"><!-- 被提问的课程或者专家id -->
		<div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script>
			$(function() {
				//样式选中
				$('.xxk').find('li').click(function() {
					$(this).addClass('on').siblings().removeClass("on");
					var liIndex = $(this).index();
					if(liIndex==0){ //questionList onlyAnswer
						$("#question_0").show();
						$("#question_1").hide();
					}else{
						$("#question_0").hide();
						$("#question_1").show();
					}
				});
				
				findQuestionType();
				LoadPage(0,'');
				LoadPage(1,'');
				
				//获取答疑的类型
				$('#questionType').find('a').click(function(){
					$(this).addClass('on').siblings().removeClass("on");
					var a = $(this).data('val');
					$('#que_content_1').html('');
					LoadPage(1,a);
				});
				
			});
			
			
			//流加载
			function LoadPage(type,nType){
				layui.use('flow', function(){
						var flow = layui.flow;
						flow.load({
						elem: '#question_'+type //流加载容器 
						, isAuto: true
						, isLazyimg: true
						,done: function(page, next){ //执行下一页的回调
							$.get("/question/phoneQuestionList",{
								page:page,
								pageSize:6,
								type:type,
								nType:nType,
								r:Math.random()
							},function(html){
								$("#que_content_"+type+",#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
								$("#Div_Temp").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			
			//专家答疑的类型data取值
			function findQuestionType(){
				$.ajax({
					type:"post",
					url:"/api/question/getMeetTypeList",
					async:false,
					success:function(data){
						var html = "<a href='javascript:void(0)' class='on'  data-val=''>全部</a>";
						var list = data.data;
						for(var i=0 ; i<list.length ; i++){
							html += "<a href='javascript:void(0)' data-val='"+list[i].id+"'>"+list[i].name+"</a>";
						}
						html += "<div class='clear'></div>";
						$('#questionType').html('');
						$('#questionType').append(html);
					},
				})
			}
			
			//添加提问
			function addQuestion(price){
				var niming = $("#niming").is(":checked");
				var isNi = 0;
				if(niming){
					isNi = 1;
				}
				$.ajax({
					type:"get",
					url:"/question/addQuestionInfo",
					data:{"content":$("#content").val(),"type":$("#type").val(),"teacherId":$("#beAskedId").val(),"money":price,"isAnonymity":isNi},
					datatype:"html",
					async:false,
					success:function(data){
						if(data.result==1){
							$("#content").val("");
							window.location.href = "/question/questionPay?payLogId="+data.payLogId+"&price="+price+"&quesOrAnswer=1";
						}
					},
					
				})
			}
			//提问弹窗
			function showBox3(type,beAskedId,price) {
				confirminfo("提问需要支付"+price+"元,确认提问？",function(){
					var show = document.getElementById("login_box3");
					var bg_filter = document.getElementById("bg_filter3");
					show.style.display = "block";
					bg_filter.style.display = "block";
					
					$("#addQues").attr("onclick","addQuestion("+price+")");
					$("#redPrice").html("￥"+price);
					$("#type").val(type);
					$("#beAskedId").val(beAskedId);
				})
			}
			//关闭弹窗
			function deleteLogin3() {
				var del = document.getElementById("login_box3");
				var bg_filter = document.getElementById("bg_filter3");
				bg_filter.style.display = "none";
				del.style.display = "none";
			}
			//旁听支付
			function payListen(price,questionId,auditType){/* quesOrAnswer 1提问支付 2旁听支付 */
				$.ajax({
					type:"get",
					url:"/question/phoneListenQuestion",
					data:{"money":price,"questionId":questionId,"auditType":auditType},
					datatype:"html",
					async:false,
					success:function(data){
						if(data.result==1){
							$("#content").val("");
							window.location.href = "/question/questionPay?payLogId="+data.payLogId+"&price="+price+"&content="+data.content+"&quesOrAnswer=2";
						}else{
							tipinfo(data.msg);
						}
					},
					
				})
			}
			//已支付的直接查看答案
			function lookAnswer(answertype,answer){
				if(answertype=='2'){
					bottomwin(answer);
				}else if(answertype=='1'){
					//tipinfo("别着急，随后给你加个播放器！");
				}
			}
			 function playNoBuy(musicurl,idIndex){
				 var audio =$("#myaudio"+idIndex+"");
				 var au=audio [0];
				 au.play();
			}
			
		</script>
	</m:Content>
</m:ContentPage>
