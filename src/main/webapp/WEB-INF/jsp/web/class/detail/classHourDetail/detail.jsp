<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<link rel="stylesheet" href="/css/global.css" />
		<link type="text/css" rel="stylesheet" href="/css/jquery.galleryview-3.0-dev.css" />
		<link rel="stylesheet" type="text/css" href="/css/video-js.min.css">
		<style>
			.jLeft img{
				width:140px;
				heigth:140px;
			}
			.tabItem ul li{
				cursor:pointer;
			}
			.tiwenItem>img {
				width:53px;
				heigth:51px;
			}
			.replayText{
				overflow:hidden;
				padding:10px 0;
				display:none;
			}
			.replayText.active{
				display:block;
			}
			.replayText textarea{
				width:1140px;
				min-height:40px;
				resize:none;
				padding:10px 0;
				text-indent:10px;
				margin-left:56px;
				margin-bottom:10px;
			}
			.huiFuBtn{
				padding: 3px 15px;
				color: #fff;
				background: #FF6633;
				border: 1px solid #FF6633;
				border-radius: 5px;
			}
			.styhide{
				 display: none;
			}
			.lunBoBox {
				margin: 20px auto;
			}
			
			.videoBox {
				text-align: center;
			}
			
			.gv_galleryWrap {
				margin: 0 auto;
			}
			
			.menuFoldBox {
				width: 100%;
				height: 240px;
				background: rgba(0, 0, 0, 0.6);
				border-radius: 5px;
				position: absolute;
				top: 56px;
				left: 0;
				z-index: 1000;
				padding: 15px 0px;
				display: none;
			}
			.menuFoldBox.show{
				display: block;
			}
			.listMenuBox {
				width: 1000px;
				margin-left: 100px;
			}
			
			.menuFoldBox .title {
				font-size: 18px;
				color: #fff;
				padding: 10px 0;
				border-bottom: 1px solid #fff;
			}
			.listMenuBox ul li{
				padding:10px 15px;
				cursor: pointer;
			}
			.listMenuBox ul li span {
				color: #fff;
				font-size: 14px;
			}
			
			.listMenuBox ul li.active span {
				color: #ff6633;
				font-size: 14px;
			}
			
			.bfName {
				display: inline-block;
				width: 600px;
			}
			.bfzuozhe{
				display: inline-block;
				width: 300px;
			}
			.shiPin{
				text-align: center;
			}
			.videoPlay{
				width: 740px;
				height: 445px;
				display: inline-block;
				border:1px solid #333;
				position: relative;
			}
			.videoPlay p{
				position: absolute;
				bottom:0;
				background: #F2F2F2;
				width: 100%;
				padding:10px 0;
				text-align: left;
			}
			.videoPlay p a{
				margin-left: 10px;
			}
			.playBox{
				text-align: center;
			}
			.playBox .playIns,.playBox .playProgress{
				display: inline-block;
				width: 800px;
			}
			.playBox .playProgress>.progressBar{
				width: 600px;
			}
			.listMenuBox{
				width: 800px;
			}
			.bfName {
			    display: inline-block;
			    width: 300px;
			}
			.bfzuozhe {
			    display: inline-block;
			    width: 200px;
			}
			.listMenuBox {
			     margin-left: 0px; 
			}
			.listMenuBox ul li span{
				text-align: left;
			}
			.videoMenu{
				position: absolute;
				top:445px;
			}
			.m{ width: 800px; height: 400px;}
			.m{ text-align: center; }
			.vjs-big-play-button {
				left: 50% !important;
				top: 50% !important;
				margin-left: -2em;
				margin-top: -1.3em;
				}
				.vjs-icon-placeholder{
				color:#fff;
				}
				.vjs-remaining-time-display{
				color:#fff;
				}
				.vjs-progress-control vjs-control{
				color:#fff;
				}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="jianJie">
			<div class="jLeft">
				<img src="${details.data.picUrl }" alt="" />
			</div>
			<div class="jMiddle">
				<span class="kName kSName">${data.title }</span>
				<p>
					类别：<span><c:if test="${details.data.serialState eq 0 }">非连载课程</c:if>
					<c:if test="${details.data.serialState eq 1 }">更新中</c:if>
					<c:if test="${details.data.serialState eq 2 }">已完结</c:if></span> 作者：
					<span>${details.data.nickName }</span>
				</p>
				<p class="boFang ksBoFang">
					<img src="/img/play.png" alt="" />
					<span>${data.hits }</span>
				</p>
			</div>
		</div>
		
		<div class="playBox shiPin">
			<div class="videoPlay">
					<video id="my-video" class="video-js" controls preload="auto" width="740" height="400" poster="${data.picUrl }" data-setup="{}">
						<source src="${data.videoUrl }" type="video/mp4">
				  	</video>
				
				<p class="boFang ksBoFang">
					<a class="menuBox videoBtn" href="javascript:void(0)">
						<img src="/img/vmenu.png" alt="">
					</a>
				</p>
				<div class="menuFoldBox videoMenu">
					<div class="listMenuBox" id="listMenuBox">
						<!-- 播放列表 -->
					</div>
				</div>
			</div>
		</div>

		<!-- <div class="playBox">
			<div class="playIns oh">
				<span>第20课 如何识破伪品类？</span>
				<p>
					<span>00:00</span>/
					<span>20:05</span>
					<img src="img/play.png" alt="" />
					<span>8523</span>
				</p>
			</div>
			<div class="playProgress">
				<img src="/img/video.png" alt="" />
				<div class="progressBar">

					<p></p>
				</div>
			</div>
		</div> -->
		<c:if test="${fn:length(dataPPT.data) > 0 }">
		<div class="lunBoBox">
			<ul id="myGallery">
				<c:forEach var="imgUrl" items="${dataPPT.data }">
					<li><img src="${imgUrl.picurl }" alt="" /></li>
				</c:forEach>
			</ul>
		</div>
		</c:if>
		<div class="jianJieCon">
			<span>课时文稿：</span>
			<p>${data.content }</p>
		</div>
		<div class="commentBox">
			<div class="tabItem">
				<ul>
					<li class="active">评论</li>
					<li>向大咖提问</li>
				</ul>
			</div>
			
			<input type="hidden" name="parentId" id="parentId" value=""/>
			<!-- 评论类型 -->
			<input type="hidden" name="commentType" id="commentType" value="" />
			<!-- 对象id -->
			<input type="hidden" name="contentId" id="contentId" value=""/>
			
			<div class="templateInput">
				<div>
					<img src="/img/start.png" alt="" />
					<textarea name="" rows="" id="commentContent" placeholder="请输入内容" cols=""></textarea>
				</div>
				<p>
					<span>还剩<b class="sheng" style="font-weight: normal;">150</b>字</span>
					<span id="tiwen1" class="styhide" style="color:red;margin-left: 85px;">￥${data.questionPrice==null?0.00:data.questionPrice }元</span>
					<button id="tiwen2" class="styhide" style="cursor:pointer;"  onclick="quiz('${data.ondemandId}','${data.questionPrice==null?0.00:data.questionPrice }','${data.teacherId }');">提问</button>
					<button id="pinglun" style="cursor:pointer;" onclick="comment()">评论</button>
				</p>
			</div>
			<div class="commentContent">
				<div class="pinglunList dataItem show" id="pinglunList"></div>
				<div class="tiwenList dataItem" id="tiwenList"></div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/jquery-ui.min.js"></script>
		<script src="/js/jquery.timers-1.2.js"></script>
		<script src="/js/jquery.easing.1.3.js"></script>
		<script src="/js/jquery.galleryview-3.0-dev.js"></script>
		
		<script type="text/javascript">
			$('.tabItem ul li').click(function(){
				var index = $(this).index();
				$(this).addClass('active').siblings().removeClass("active");
				$('.dataItem:eq('+ index +')').addClass('show').siblings().removeClass('show');
				if($(this).text()=="向大咖提问"){
					getQuestion(${details.data.teacherId });
					$('#pinglun').addClass("styhide");
					$('#tiwen1').removeClass("styhide");
					$('#tiwen2').removeClass("styhide");
				}else{
					getComment(${data.hourId });
					$('#pinglun').removeClass("styhide");
					$('#tiwen1').addClass("styhide");
					$('#tiwen2').addClass("styhide");
				}
			});
			//评论列表
			function getComment(hourId){
				$.get("/product/commentList",{
					page:1,
					pageSize:3,
					hourId:hourId,
					commentType:2,
					r:Math.random()
				},function(html){
					$(".pinglunList").html(html);
				},"html")
			}
			
			//问答类表
			function getQuestion(teacherId){
				$.get("/product/questionList",{
					page:1,
					pageSize:3,
					teacherId:teacherId,
					teacherName:'${details.data.nickName }',
					r:Math.random()
				},function(html){
					$(".tiwenList").html(html);
				},"html")
			}
			
			$(function(){
				//轮播
				$('#myGallery').galleryView();
				
				getComment(${data.hourId });
				//页面存储
				localStorage.setItem('hourIdUrl','?hourId=${data.hourId}&ondemandId=${data.ondemandId}');
				
			});
			//发表评论
			function comment(){
				// 评论的parentId 
				var parentId=0;
				// 评论类型 
				var commentType=2;
				//对象id 
				var contentId=${data.hourId };
				//评论内容
				var commentContent=$("#commentContent").val();
				
				if(commentContent == '' || commentContent == null){
					tipinfo("内容不能为空");
					return false;
				}
				data = {"parentId":parentId,"commentType":commentType,"contentId":contentId,"content":commentContent,"anonymous":"off"};
				$.ajax({
			        type:'post',
			        data:{"parentId":parentId,"commentType":commentType,"contentId":contentId,"content":commentContent,"anonymous":"off"},
			        url:'/product/saveComment',
			        datatype:'json',
			        success:function(data){
			        	tipinfo(data.msg+",请等待审核");
			        	setTimeout(function(){ location.reload(); }, 600);
			        },
			        error:function(){
			        	
			        }
			    });
			}
			//提交回复评论
			function Publish(obj){
				var content = $(obj).parent().prev().val();
				var data = {parentId:$('#parentId').val(),commentType:$('#commentType').val(),contentId:$('#contentId').val(),content:content}
				$.ajax({
			        type:'post',
			        data:data,
			        url:'/product/saveComment',
			        datatype:'json',
			        success:function(data){
			        	tipinfo(data.msg+"，请等待审核");
			        	setTimeout(function(){ location.reload(); }, 600);
			        },
			        error:function(){
			        	
			        }
			    });
			}
			//回复 (父id，评论类型,对象id)
			function showBox3(e,parentId,commentType,contentId) {
				//存储隐藏域中
				$("#parentId").val(parentId);
				$("#commentType").val(commentType);
				$("#contentId").val(contentId);
				$(e).parents('.pl-sec').siblings('.replayText').toggleClass('active');
			}
			//提问
			function lookAnswer(type,content){
				tipinfo(content);
			}
			//旁听支付
			function payListen(price,questionId,auditType){/* quesOrAnswer 1提问支付 2旁听支付 */
				$.ajax({
					type:"post",
					url:"/home/question/phoneListenQuestion",
					data:{"money":price,"questionId":questionId,"auditType":auditType},
					async:false,
					success:function(data){
						if(data.result==1){
							window.location.href = "/home/question/questionPay?payLogId="+data.payLogId+"&price="+price+"&content="+data.content+"&quesOrAnswer=2";
						}
					},
					
				})
			}
			//向大咖提问
			function quiz(ondemandId,money,teacherId){
				//提问内容
				var content = $("#commentContent").val();
				var type = 1;
				//是否匿名
				/* var isAnonymity=0;
				if($("#tiwen").is(":checked")){
					isAnonymity=1;
				} */
				if(content == '' || content == null){
					tipinfo("提问内容不能为空");
					return false;
				}
				$.ajax({
			        type:'post',
			        data:{"content":content,"type":type,"isAnonymity":0,"money":money,"teacherId":teacherId,"ondemandId":ondemandId},
			        url:'/product/addQuiz',
			        datatype:'json',
			        success:function(data){
			        	tipinfo(data.msg);
						$("#commentContent").val('');
						window.location.href="/home/question/questionPay?payLogId="+data.payLogId+"&price="+money+"&quesOrAnswer=1";
			        },
			        error:function(){
			        	tipinfo("出错了!");
			        }
			    });
			}
			$('#commentContent').keyup(function() { //输入字符后键盘up时触发事件
				var txtLeng = $(this).val().length; //把输入字符的长度赋给txtLeng
				//拿输入的值做判断
				if(txtLeng > 150) {
					//输入长度大于300时span显示0
					$('.sheng').html('0');
					//截取输入内容的前300个字符，赋给fontsize
					var fontsize = $('#commentContent').val().substring(0, 150);
					//显示到textarea上
					$('#commentContent').val(fontsize);
				} else {
					//输入长度小于300时span显示300减去长度
					$('.sheng').html(150 - txtLeng);
				}
			});
			//课时列表
			$('.videoBtn').click(function(){
				$(this).parent().siblings('.videoMenu').toggleClass("show");
			})
			
			$(function() {
				var ondemandId = ${data.ondemandId};
				classHout(ondemandId);
			});
			
			function classHout(ondemandId){
				$.get("/product/selClassHour2",{
					page:1,
					pageSize:4,
					ondemandId:ondemandId,
					r:Math.random()
				},function(html){
					$("#listMenuBox").html(html);
				},"html")
			}
			//播放课时	IsBuyOndemand 是否购买了该课程（1是0否） IsAudition 是否是试听课时(1是0否)
			function playVideo(hourId,ondemandId,IsBuyOndemand,IsAudition){
				//先判断是否购买了
				if(IsBuyOndemand=='0'){
					//未购买，判断是否是试听课时
					if(IsAudition=='0'){
						//跳转到购买页面
						window.location.href="/product/payOndemand?ondemandId="+ondemandId;
					}else{
						//未购买，但是是试听课时，则跳转播放界面
						window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
					}
				}else{
					//购买了
					window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
				}
			}
		</script>
		<script type="text/javascript" src="/js/video.min.js"></script>
		<script type="text/javascript">
			var myPlayer = videojs('my-video');
			videojs("my-video").ready(function(){
				var myPlayer = this;
				myPlayer.play();
			});
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
