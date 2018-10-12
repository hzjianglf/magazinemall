<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	<link href="/js/video/css/video-js.css" rel="stylesheet">
	<link href="/css/swiper-3.3.1.min.css" rel="stylesheet">
	<style>
		/* .vjs-fullscreen-control{
			display:none !important;
		} */
		.kspj h3 a img {
			margin: 0rem 0.25rem 0 0;
		}
		#login_box{
			height: 19.2rem;
		}
		.vjs-remaining-time-display{
			margin-top: 10px;
		}
		.vjs-big-play-button{
			margin-top: 2rem;
			margin-left: 5rem;
		}
		img {
			max-width: 100%; /*图片自适应宽度*/
		}
		body {
			overflow-y: scroll !important;
		}
		.view {
			word-break: break-all;
		}
		.vote_area {
			display: block;
		}
		.vote_iframe {
			background-color: transparent;
			border: 0 none;
			height: 100%;
		}
		#edui1_imagescale{display:none !important;} /*去除点击图片后出现的拉伸边框*/
		.zbj_nr {
			width: 12.5rem;
			height: 7.5rem;
			background: #fff;
			border-radius: 0.375rem;
			position: fixed;
			top: 5rem;
			left: 1.75rem;
			z-index: 999;
		}
		.ksxq1{
			padding-bottom:30px;
		}
		.swiper-slide{
			height: 300px;
		}
		.swiper-slide img{
			width: 100%;
			height:300px;
		}
		.ksxq1 p {
			line-height: 1.5em;
		}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<!-- <a href="#" class="a2"><img src="/images/fx_biao.png" class="fx_biao"></a> -->
			<h3>音频播放</h3>
		</div>
		<div class="kcxq_top">
			<a href="javascript:history.go(-1)"><img src="/images/fh_biao1.png" class="fh_biao"></a>
			<a href="#"><img src="/images/fx_biao2.png" class="fx_biao"></a>
			<div style="width: 100%;height: 7rem;" >
				<audio id="my-video" class="video-js" controls="controls"
					  poster="${data.picUrl }"  data-setup="{}" style="width:16rem;height:7rem;">
				      <source src="${data.videoUrl }" type="video/mp4">
			    </audio>
			</div>
			
			<div class="bfnr">
				<a href="javascript:void(0)" onClick="showBox('${data.ondemandId}','${data.hourId }')" class="lb_biao"><img src="/images/lb_biao.png"><br>列表</a>
				<div class="bf_an">
					<!-- <a href="#"><img src="/images/shang_biao.png" class="shang_biao"></a>
					<a onclick="bofang();"><img src="/images/bo_biao.png" class="bo_biao"></a>
					<a href="#"><img src="/images/xia_biao.png" class="xia_biao"></a> -->
				</div>
				<a href="javascript:void(0)" onClick="showBox1()" class="bj_biao"><img src="/images/biji_biao.png"><br>做笔记</a>
				<div class="clear"></div>
			</div>
		</div>
		<div class="kcxq_di">
			<div class="xxk ">
				<ul>
					<li class="on"><span>详情</span></li>
					<li><span>评论</span></li>
				</ul>
			</div>
			<div class="det_content2">
				<div class="ksxq1">
					<!-- 此处ppt滑动 -->
					<c:if test="${dataPPT.data != null && dataPPT.data != '' }">
					<section class="main">
						<div class="swiper-container" id="registerCont">
							<div class="swiper-wrapper">
								<c:forEach var="item" items="${dataPPT.data }">
									<div class="swiper-slide"><img src="${item.picurl }"></div>
								</c:forEach>
							</div>
						</div>
					</section>
					</c:if>
					<!-- 课程详情先注释，展示ppt -->
					<h3>${data.title }</h3>
					<h4>${data.hits }次播放    &nbsp;&nbsp;&nbsp;&nbsp;     ${data.addTime }</h4>
					<div>
						${data.content }
					</div>
				</div>
				<div class="kspj hide " id="det_content2">
					<h3><a onClick="showBox2('${data.hourId}',2);"><img src="/images/pl_biao.png"> 发表评论</a>听众点评<em>（${data.commentCount }）</em></h3>
					<div id="content"></div>
					<div id="Div_Temp" style="display:none"></div>
				</div>
			</div>
		</div>
		<!--列表弹框(课时列表)-->
		<div class="lb_nr" id="login_box" style="display: none;">
		  <div class="lb_nr_xq">
		  	<h3>顺序播放 </h3>
		  	<div id="hourContent">
		  		<div id="hourAll"></div>
		  	</div>
		  	<div id="Div_Temp2" style="display:none"></div>
		  	
		  </div>	
         <a href="#" onClick="deleteLogin()" class="gb_biao">关闭</a>

		</div>
        <!--做笔记弹框-->
		<div class="zbj_nr" id="login_box1" style="display: none;">
		    <h3 id="node_Time">2分17秒笔记</h3>	
		    <!-- 笔记时间节点 -->
		    <input type="hidden" name="nodeTime" id="nodetime" />
            <textarea name="node" id="node" placeholder="请输入笔记内容"></textarea>
            <button type="button" onclick="saveNode('${data.hourId}');">确 定</button>
		</div>
        <!--评价弹框-->
		<div class="pj_nr" id="login_box2" style="display: none;">
		    <div class="xxk_pj ">
				<ul>
					<li class="on"><span>评论</span></li>
					<li><span>向大咖提问</span></li>

				</ul>
			</div>
			<div class="det_content1">
				<div class="pj_nr_xq">
					<textarea name="commentContent" id="commentContent" placeholder="请输入您的评论···"></textarea>
					<div class="nmpj"><button type="button" onclick="comment();">发表评论</button><input id="niming" type="checkbox">匿名评论</div>
				</div>
				<div class="pj_nr_xq hide">
					<textarea name="dkComment" id="dkComment" placeholder="请输入您要提问的问题"></textarea>
					<div class="nmpj">
						<button type="button" onclick="quiz('${data.ondemandId}','${data.questionPrice }','${data.teacherId }');">提问</button>
						<input type="checkbox" id="tiwen">匿名提问
						<span style="color:red;margin-left: 85px;">￥${data.questionPrice }元</span>
					</div>
				</div>
			</div>
			<!-- 评论的parentId -->
			<input type="hidden" id="commentParent" value="0" />
			<!-- 评论类型 -->
			<input type="hidden" id="comType" name="comType" />
			<!-- 对象id -->
			<input type="hidden" id="domId" name="domId" />
		</div>
		<!--回复弹框-->
		<div class="pj_nr" id="login_box3" style="display: none;">
		    <div class="pj_nr_xq">
	    	    <h3>回复评论</h3>
	    	    <form id="publishComment">
					<textarea name="content" id="neirong" placeholder="请输入您的评论···"></textarea>
					<!-- 父级id -->
					<input type="hidden" name="parentId" id="parentId" value=""/>
					<!-- 评论类型 -->
					<input type="hidden" name="commentType" id="commentType" value="" />
					<!-- 对象id -->
					<input type="hidden" name="contentId" id="contentId" value=""/>
					<div class="nmpj">
						<button onclick="Publish();" type="button" >发表评论</button>
						<input type="checkbox" name="anonymous">
						匿名评论
					</div>
				</form>
			</div>
		</div>
       <div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
       <div class="bg_color" onClick="deleteLogin1()" id="bg_filter1" style="display: none;"></div>
       <div class="bg_color" onClick="deleteLogin2()" id="bg_filter2" style="display: none;"></div>
       <div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript" src="/js/Addpolicy.js"></script>
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/swiper-3.3.1.jquery.min.js"></script>
		<script src="/js/video/js/video.min.js"></script> 
		<script type="text/javascript">
		 	var myPlayer;
			$(function() {
					myPlayer = videojs('my-video');
					videojs("my-video").ready(function(){
						var myPlayer = this;
					});
					//页面存储
					localStorage.setItem('url','/product/hourDetail?hourId=${data.hourId}');
				//样式选中
				$('.xxk_pj').find('li').click(function() {
					$('.xxk_pj').find('li').removeClass('on');
					$(this).addClass('on');
					$('.det_content1').children('div').hide();
					$('.det_content1').children('div').eq($(this).index()).show();
				});
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					$('.det_content2').children('div').hide();
					var index=$(this).index();
					$('.det_content2').children('div').eq(index).show();
					$(".kspj_nr").remove();
					if(index==1){
						getComment(${data.hourId},2);
					}
				});
			});
			
			function deleteLogin() {
				var del = document.getElementById("login_box");
				var bg_filter = document.getElementById("bg_filter");
				bg_filter.style.display = "none";
				del.style.display = "none";
			}

			function showBox(ondemandId,hourId) {
				var show = document.getElementById("login_box");
				var bg_filter = document.getElementById("bg_filter");
				show.style.display = "block";
				bg_filter.style.display = "block";
				//查询课时列表
				classHour(ondemandId,hourId);
			}
			//关闭笔记弹窗
			function deleteLogin1() {
				var del = document.getElementById("login_box1");
				var bg_filter = document.getElementById("bg_filter1");
				bg_filter.style.display = "none";
				del.style.display = "none";
				//视频开始播放
				//myPlayer.play();
			}
			//打开笔记弹窗
			function showBox1() {
				var show = document.getElementById("login_box1");
				var bg_filter = document.getElementById("bg_filter1");
				show.style.display = "block";
				bg_filter.style.display = "block";
				//播放暂停
				myPlayer.pause();
				//获取当时音视频的时间节点
				//秒转换为时分秒
				var theTime = parseInt(myPlayer.currentTime());// 秒 
				var theTime1 = 0;// 分 
				var theTime2 = 0;// 小时 
				if(theTime > 60) { 
					theTime1 = parseInt(theTime/60); 
					theTime = parseInt(theTime%60); 
					if(theTime1 > 60) { 
						theTime2 = parseInt(theTime1/60); 
						theTime1 = parseInt(theTime1%60); 
					} 
				} 
				var nowTime = ""+parseInt(theTime)+"秒"; 
				if(theTime1 > 0) { 
					nowTime = ""+parseInt(theTime1)+"分"+nowTime; 
				} 
				if(theTime2 > 0) { 
					nowTime = ""+parseInt(theTime2)+"小时"+nowTime; 
				} 
				$("#node_Time").text(nowTime+"笔记");
				$("#nodetime").val(theTime*1000);
			}
			//保存笔记
			function saveNode(hourId){
				var nodetime=$("#nodetime").val();
				var node=$("#node").val();
				if(node == null || node == ''){
					tipinfo("请输入笔记内容!");
					return false;
				}
				$.ajax({
					type:'post',
					data:{"hourId":hourId,"nodetime":nodetime,"content":node},
					url:'/product/saveNode',
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
						deleteLogin1();
					},
					error:function(){
						tipinfo("添加失败!");
					}
				})
			}
			
			function deleteLogin2() {
				var del = document.getElementById("login_box2");
				var bg_filter = document.getElementById("bg_filter2");
				bg_filter.style.display = "none";
				del.style.display = "none";
				getComment(${data.hourId},2);
			}
			//发表评论（或向大咖提问）
			function showBox2(hourId,commentType) {
				var show = document.getElementById("login_box2");
				var bg_filter = document.getElementById("bg_filter2");
				show.style.display = "block";
				bg_filter.style.display = "block";
				//隐藏域赋值
				$("#comType").val(commentType);
				$("#domId").val(hourId);
			}
			//发表评论
			function comment(){
				// 评论的parentId 
				var parentId=$("#commentParent").val();
				// 评论类型 
				var commentType=$("#comType").val();
				//对象id 
				var contentId=$("#domId").val();
				//评论内容
				var commentContent=$("#commentContent").val();
				//是否匿名
				var anonymous="";
				if($("#niming").is(":checked")){
					anonymous="on";
				}else{
					anonymous="off";
				}
				if(commentContent == '' || commentContent == null){
					tipinfo("内容不能为空");
					return false;
				}
				
				$.ajax({
			        type:'post',
			        data:{"parentId":parentId,"commentType":commentType,"contentId":contentId,"content":commentContent,"anonymous":anonymous},
			        url:'/product/saveComment',
			        datatype:'json',
			        success:function(data){
			        	tipinfo(data.msg);
			        	//关闭评价弹框
			        	deleteLogin2();
						$("#commentContent").val('');
			        },
			        error:function(){
			        	
			        }
			    });
			}
			function quiz(ondemandId,money,teacherId){
				//提问内容
				var content = $("#dkComment").val();
				var type = 1;
				//是否匿名
				var isAnonymity=0;
				if($("#tiwen").is(":checked")){
					isAnonymity=1;
				}
				if(content == '' || content == null){
					tipinfo("提问内容不能为空");
					return false;
				}
				$.ajax({
			        type:'post',
			        data:{"content":content,"type":type,"isAnonymity":isAnonymity,"money":money,"teacherId":teacherId,"ondemandId":ondemandId},
			        url:'/product/addQuiz',
			        datatype:'json',
			        success:function(data){
			        	tipinfo(data.msg);
			        	//关闭评价弹框
			        	deleteLogin2();
						$("#dkComment").val('');
						window.location.href="/question/questionPay?payLogId="+data.payLogId+"&price="+money+"&quesOrAnswer=1";
			        },
			        error:function(){
			        	tipinfo("出错了!");
			        }
			    });
			}
			
			function deleteLogin3() {
				var del = document.getElementById("login_box3");
				var bg_filter = document.getElementById("bg_filter3");
				bg_filter.style.display = "none";
				del.style.display = "none";
			}
			//回复 (父id，评论类型,对象id)
			function showBox3(parentId,commentType,contentId) {
				var show = document.getElementById("login_box3");
				var bg_filter = document.getElementById("bg_filter3");
				show.style.display = "block";
				bg_filter.style.display = "block";
				//存储隐藏域中
				$("#parentId").val(parentId);
				$("#commentType").val(commentType);
				$("#contentId").val(contentId);
			}
			//提交回复评论
			function Publish(){
				$.ajax({
			        type:'post',
			        data:$('#publishComment').serialize(),
			        url:'/product/saveComment',
			        datatype:'json',
			        success:function(data){
			        	tipinfo(data.msg);
			        	$("div.xxk li:eq(1)").click();
			        	//关闭回复框
			        	deleteLogin3();
						//清空表单
						$("#neirong").val('');
			        },
			        error:function(){
			        	
			        }
			    });
			}
		</script>
		<script type="text/javascript">
			//课时列表
			function classHour(ondemandId,hourId){
				$("#hourAll,#Div_Temp2").html("");
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#hourContent' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/product/commentHourlist",{
								page:page,
								pageSize:6,
								ondemandId:ondemandId,
								hourId:hourId,
								r:Math.random()
							},function(html){
								$("#hourAll,#Div_Temp2").append(html);
								var totalPage =$("#Div_Temp2").find("#Hid_TotalPage2").val();
					        	$("#Div_Temp2").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			//评论列表
			function getComment(hourId,commentType){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#det_content2' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/product/commentList",{
								page:page,
								pageSize:6,
								hourId:hourId,
								commentType:commentType,
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
	</pxkj:Content>
</pxkj:ContentPage>
