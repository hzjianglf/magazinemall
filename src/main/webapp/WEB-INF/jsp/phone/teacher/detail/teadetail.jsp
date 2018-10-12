<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	<style>
		.ds_nr ul li a.on{
		    border: 0.025rem solid #e08500;
            color: #E08500;
		}
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
		.wd_nr {
		    background: #FFFFFF;
		    padding: 0.5rem 0.5rem 2rem;
		    border-bottom: 0.025rem solid #e5e5e5;
		}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="zlzj_top">
			<a href="javascript:history.go(-1)"><img src="/images/fh_biao3.png" class="fh_biao"></a>
		<!-- 	<a href="#"><img src="/images/fx_biao3.png" class="fx_biao"></a> -->
			<div class="zlzj_xq">
				 <div class="zj_tx">
				 	<img src="${data.teacherUrl }" class="tx_tu">
				 	<img src="/images/rz_biao.png" class="rz_biao">
				 	<p>${data.nickName }</p>
				 </div>
				 <div class="gz_biao"><a style="width: auto;padding: 0.1rem 0.3rem;color:#e08500;border: 1px #e08500 solid;" onclick="follow('${data.userId}');" id="follow">${(data.Isfoolow==0||! empty data.Isfoollow)?'关注':'取消关注' }</a></div>
				 <div class="ggs">关注：${(empty data.followNum)?'0':data.followNum } &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;粉丝：${(data.fansNum > 10000)?(data.fansNum/10000):(data.fansNum) }${(data.fansNum>10000)?'万':'' }</div>
				 <div class="dsb">
				 	<div class="dsb_l">
				 		<h3>打赏榜<br><em>已拥有${(empty data.rewardNum)?'0':data.rewardNum }位打赏人</em></h3>
				 		<div class="dsr_tx" onclick="rewardlog('${data.userId}');">
				 			<c:forEach items="${data.userurl }" var="userurl" varStatus="count">
				 				<img src="${userurl.userUrl }" class="tx_tu${count.count }">
				 			</c:forEach>
				 		</div>
				 	</div>
				 	<a  class="ds_biao" href="javascript:void(0)" onClick="showBox()">打赏</a>
				 </div>
			</div>
		    
		</div>
		<div class="kcxq_di">
			<div class="xxk xxk2">
				<ul>
					<li class="on"><em>|</em><span>课程</span></li>
					<li><em>|</em><span>资料</span></li>
					<li><span>问答</span></li>
				</ul>
			</div>
			<div class="det_content2">
				<div class="qbkc_lb">
					<a class="gd_biao" href="/home/getRecommend?recommend=0&teacherId=${data.userId }">更多</a>
					<c:forEach items="${data.teacherlist }" var="teacherlist">
						<div class="qbkc_nr" onclick="classDetail('${teacherlist.ondemandId}');">
							<img src="${teacherlist.picUrl }">
							<div class="qbkc_nr_r">
								<h3>${teacherlist.name } 
									<c:if test="${teacherlist.serialState!='0' }"><!-- <em class="lz_biao">连载</em> --> </c:if>
									<c:if test="${teacherlist.IsRecommend=='1' }">
										<em class="tj_biao">推荐</em>
									</c:if>
								</h3>
								<h4>${teacherlist.studentNum }人订阅</h4>
								<h5><img src="/images/bf_biao2.png">${teacherlist.hits} &nbsp;&nbsp;&nbsp;&nbsp;    已更新${teacherlist.count }课时</h5>
							</div>
							<div class="clear"></div>
						</div>
					</c:forEach>
				</div>
				<div class="zlnr hide">
					<h3>TA的信息</h3>
				<%-- 	<P>昵称：${data.nickName }<br> 性别：${data.sex } --%>
						<%-- <br> 学历：${data.education }
						<br> 行业：${(empty data.industry)?'未知':data.industry } --%>
						<P> 简介：${data.synopsis }</P>
				</div>
				<div class="zzwd hide">
					<div class="hdts">问答（${data.twCount }）
						<a href="/question/questionFace?teacherId=${data.userId}">更多</a>
					</div>
					<c:forEach items="${data.auditlist }" var="auditlist">
						<div class="wd_nr">
							<h3><span>${auditlist.auditCount }人听过</span> <em>${auditlist.nickName }  </em> 提问</h3>
							<P>${auditlist.content }</P>
							<%-- <div class="bf_mk">
								<img src="${auditlist.userUrl }" class="tx_biao">
								<div class="bf_biao">
									<img src="/images/yp_biao.png"> ${(auditlist.isBugAudit>0)?'':'1.5元' }旁听
								</div>
								<em>01'56''</em>
							</div> --%>
							<c:if test="${auditlist.isBugAudit=='0'}">
								<a onclick="payListen(${auditlist.money},'${auditlist.questionId}',1);">
									<c:if test="${auditlist.answertype=='1'}">
										<div class="bf_biao">
										<img src="/images/yp_biao.png">
											${auditlist.money}元&nbsp;旁听<!-- <em>01'56''</em> -->
										</div>
									</c:if>
									
									<c:if test="${auditlist.answertype=='2'}">
										<div class="bf_biao2">
										${auditlist.money}元&nbsp; 查看
										</div>
									</c:if>
								 </a>
							</c:if>
							<c:if test="${auditlist.isBugAudit!='0'}">
								<%-- <a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
									<c:if test="${auditlist.answertype=='1'}">
										<div class="bf_biao">
										<img src="/images/yp_biao.png">
											 1.5元&nbsp;旁听<em>01'56''</em>
										</div>
									</c:if>
									
									<c:if test="${auditlist.answertype=='2'}">
										<div class="bf_biao2">
										 查看
										</div>
									</c:if>
								</a> --%>
								<c:if test="${auditlist.answertype=='2'}">
									<a onclick="lookAnswer('${auditlist.answertype}','${auditlist.answer}');">
										<div class="bf_biao2">
												查看
										</div>
									</a> 
								</c:if>
								<c:if test="${auditlist.answertype=='1'}">
									<audio src="${auditlist.musicurl}" controls="controls">
								    </audio>
								</c:if>
							</c:if>
						</div>
					</c:forEach>
					<!-- 当前专家id -->
					<input type="hidden" id="UserID" value="${data.userId }" />
					<c:if test="${myUserId!=data.userId }">
						<div class="hj_qr">
							<em>提问也能赚钱哦！</em>
							<a onClick="showBox3(2,'${data.userId}','${data.money}');" class="ljgm_biao">向TA提问</a>
						</div>
					</c:if>
				</div>

			</div>
		</div>
		<!-- 回复弹窗 -->
		<div class="pj_nr" id="login_box3" style="display: none;">
		    <div class="pj_nr_xq">
		        <h3>向大咖提问</h3>
				<textarea name="content" id="content" placeholder="请输入您要提问的问题"></textarea>
				<div class="nmpj"><button onclick="addQuestion('${data.money}');">发表提问</button><input type="checkbox" id="niming" name="niming">匿名评论<span style="color: red;margin-left: 30%;font-size: 17px;">￥${data.money}</span></div>
			</div>
		</div>
		<input type="hidden" name="type" id="type"><!-- 向专家2/课程1提问  -->
		<input type="hidden" name="beAskedId" id="beAskedId"><!-- 被提问的课程或者专家id -->
		<input type="hidden" name="price" id="price" value="${data.money}"><!-- 提问价格 -->
		<div class="bg_color" onClick="deleteLogin3()" id="bg_filter3" style="display: none;"></div>
		
		<!--列表弹框-->
		<div class="ds_nr" id="DS_box" style="display: none;">
		  <h3>请选择打赏金额</h3>
		  <ul>
		  	<li>
		  		<a onclick="shang(1);" class="on">￥1</a>
		  	</li>
		  	<li>
		  		<a onclick="shang(5);">￥5</a>
		  	</li>
		  	<li>
		  		<a onclick="shang(10);">￥10</a>
		  	</li>
		  	<li>
		  		<a onclick="shang(15);">￥15</a>
		  	</li>
		  	<li>
		  		<a onclick="shang(20);">￥20</a>
		  	</li>
		  	<li>
		  		<a onclick="shang('任意');">任意赏</a>
		  	</li>
		  </ul>
		  <div style="float:right;margin-top:-1.2rem; margin-right:0.5rem;font-size: 0.45rem;color: #CCCCCC;line-height: 1.25rem;">
		  	<span>不得低于￥1</span>
		  </div>
		  <div class="clear"></div>
		  <!-- 打赏金额 -->
		  <input type="hidden" name="rewardMoney" id="rewardMoney" />
		  <input type="text" class="in1" placeholder="请输入金额" style="display: none;" oninput="change();"/>
		  <textarea placeholder="请输入打赏内容" name="rewardMsg" id="rewardMsg"></textarea>
		  <button type="button" onclick="confirm('${data.userId}');">确认打赏</button>
          <a href="#" onClick="deleteLogin()" class="gb_biao"><img src="/images/gb_biao.png"></a>

		</div>
        
        <div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					$('.det_content2').children('div').hide();
					$('.det_content2').children('div').eq($(this).index()).show();
				});
				//打赏金额的选中效果
				$('.ds_nr').find('li').click(function(){
					$('.ds_nr').find('li>a').removeClass('on');
					$(this).find('a').addClass('on');
				})
				
				//专家id
				var teacherId=$("#UserID").val();
				var myUserId='${myUserId}';
				if(myUserId!=teacherId){
					var height = $(".zzwd").height();
					var heigth2=$(".hj_qr").height();
					$(".zzwd").css('height',height+heigth2+'px');
				}
				
			});
			function deleteLogin() {
				var del = document.getElementById("DS_box");
				var bg_filter = document.getElementById("bg_filter");
				bg_filter.style.display = "none";
				del.style.display = "none";
			}

			function showBox() {
				var show = document.getElementById("DS_box");
				var bg_filter = document.getElementById("bg_filter");
				show.style.display = "block";
				bg_filter.style.display = "block";
				shang(1);
			}
			//打赏金额选择
			function shang(msg){
				if(msg=='任意'){
					$(".in1").show();
				}else{
					$(".in1").hide();
					$("#rewardMoney").val(msg);
				}
			}
			//输入金额
			function change(){
				var v = $(".in1").val();
				$("#rewardMoney").val(v);
			}
			
			//课程详情
			function classDetail(ondemandId){
				window.location.href="/product/classDetail?ondemandId="+ondemandId;
			}
			//确认打赏
			function confirm(userId){
				var money = $("#rewardMoney").val();
				if(money==null||money==''){
					tipinfo("请选择打赏金额");
					return false;
				}
				if(money<1){
					tipinfo("不得低于￥1");
					return false;
				}
				var rewardMsg = $("#rewardMsg").val();
				if(rewardMsg==null||rewardMsg==''){
					rewardMsg="这才是大师该有的样子！";
				}
				window.location.href="/reward/payReward?teacherId="+userId+"&money="+money+"&rewardMsg="+rewardMsg;
			}
			//关注
			function follow(userId){
				var str=$("#follow").html();
				var msg=str.replace("+","");
				var url='';
				if(msg=='关注'){
					//去关注
					url='/home/addFoolow';
				}else{
					//取消关注
					url='/home/cancelFoolow';
				}
				$.ajax({
					type:'post',
					data:{"teacherId":userId},
					url:url,
					datatype:'json',
					success:function(data){
						if(data.success){
							tipinfo(data.msg);
							if(msg=='关注'){
								$("#follow").html("取消关注");
							}else{
								$("#follow").html("关注");
							}
						}else{
							tipinfo(data.msg);
						}
					},
					error:function(){
						alert("出错了!");
					}
				})
			}
			//提问弹窗
			function showBox3(type,beAskedId,price) {
				/* confirminfo("提问需要支付"+price+"元,确认提问？",function(){ */
					var show = document.getElementById("login_box3");
					var bg_filter = document.getElementById("bg_filter3");
					show.style.display = "block";
					bg_filter.style.display = "block";
					
					$("#type").val(type);
					$("#beAskedId").val(beAskedId);
				/* }) */
			}
			//关闭弹窗
			function deleteLogin3() {
				var del = document.getElementById("login_box3");
				var bg_filter = document.getElementById("bg_filter3");
				bg_filter.style.display = "none";
				del.style.display = "none";
			}
			//提交提问
			function addQuestion(price){
				var niming = $("#niming").is(":checked");
				var isNi = 0;
				if(niming){
					isNi = 1;
				}
				if($("#content").val()==null||$("#content").val()==''){
					tipinfo("请输入提问问题!");
					return false;
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
			function rewardlog(userId){
				window.location.href="/usercenter/account/rewardLog?userId="+userId;
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
				}else{
					//tipinfo("别着急，随后给你加个播放器！");
				}
			}
			
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
