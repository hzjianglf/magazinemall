<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
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
			<a href="#" class="a2"><img src="/images/ss_biao.png" class="ss_biao"></a>
		</div>
		<div class="hdlb">
			<div class="det_content2">
				<div class="zzwd" id="questionList">
					<div id="ques_content"></div>
				</div>
			</div>
		</div>
		<!-- 回复弹窗 -->
		<div class="pj_nr" id="login_box3" style="display: none;">
		    <div class="pj_nr_xq">
		        <h3>向大咖提问</h3>
				<textarea name="content" id="content" placeholder="大咖将在72小时内语音回答提问，否则全额退款。问答被他人旁听你将获得分成收益。"></textarea>
				<div class="nmpj"><button onclick="addQuestion('${price}');">提问</button><input type="checkbox" id="niming" name="niming">匿名评论<span style="color: red;margin-left: 40%;font-size: 17px;">￥${price}</span></div>
			</div>
		</div>
		<input type="hidden" name="type" id="type"><!-- 向专家2/课程1提问  -->
		<input type="hidden" name="beAskedId" id="beAskedId"><!-- 被提问的课程或者专家id -->
		<input type="hidden" name="price" id="price" value="${price}"><!-- 提问价格 -->
		<div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
		<div id="Div_Temp" style="display: none;"></div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script>
			
			//提交提问
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
			function showBox3(type,beAskedId) {
				confirminfo("提问需要支付"+${price}+"元,确认提问？",function(){
					var show = document.getElementById("login_box3");
					var bg_filter = document.getElementById("bg_filter3");
					show.style.display = "block";
					bg_filter.style.display = "block";
					
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
			
			$(function(){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#questionList' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/question/questionList",{
								page:page,
								pageSize:6,
								teacherId:'${teacherId}',
								r:Math.random()
							},function(html){
								$("#ques_content,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			})
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
		</script>
	</m:Content>
</m:ContentPage>
