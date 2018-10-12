<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
	 <style type="text/css">
		.shangCon input{
			display: inline-block;
			width: 70%;
			margin: 10px 15% 0;
			padding: 5px;
		}
		
		.closeDia{
			top:10px;
			right:10px;
			text-align:center;
		}
		
		.defaultData{
			background:#eee;
			height:50px;
			text-align: center;
			font-size: 30px;
			color:#888;
		}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="checkOrder">
			<div id="MainContent" class="dataList"></div>
		</div>
		<div id="dia"></div>
		<div id="shangDialog">
			<p class="title">打赏<a class="closeDia" href="javascript:void(0)">X</a></p>
			<div class="shangCon">
				<img src="img/zuoJiatx.png" alt="" />
				<p class="gongSiName">鹏翔科技</p>
				<ul class="shangList oh">
					<li class="on" onclick="shang(1);">￥1</li>
					<li onclick="shang(5);">￥5</li>
					<li onclick="shang(10);">￥10</li>
					<li onclick="shang(15);">￥15</li>
					<li onclick="shang(20);">￥20</li>
					<li onclick="shang('任意');">任意赏</li>
				</ul>
				<input type="hidden" name="rewardMoney" id="rewardMoney" />
				 <input type="text" class="in1" placeholder="请输入金额,不得低于￥1" style="display: none;" oninput="change();"/>
				<textarea name="" rows="" cols="" placeholder="请输入打赏内容" name="rewardMsg" id="rewardMsg"></textarea>
				<div class="daShangBtn">
					<button onclick="confirm();">确认打赏</button>
					打赏无悔，概不退款
				</div>
			</div>
		</div>
		<input type="hidden" name="teacherId" id="teacherId" value=""/>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/js/jquery.js"></script>
		<script type="text/javascript">
			var wHeight = $(window).height();
			var wWidth = $(window).width();
			var layer;
			layui.use('layer', function(){
				layer = layui.layer;
			});
			function tipinfo(obj){
				layer.msg(obj);
			}
			$(function(){
				expertCourseList();
				$('#shangDialog').css({
					"top": (wHeight - 400) / 2,
					"left": (wWidth - 540) / 2
				})
			});
			window.onresize = function() {
				var wHeight = $(window).height();
				var wWidth = $(window).width();
				$('#shangDialog').css({
					"top": (wHeight - 400) / 2,
					"left": (wWidth - 540) / 2
				})
			}
			function expertCourseList(){
				$.get("/home/expert/expertDetail?userId="+${userId},{
					page:1,
					pageSize:8,
					r:Math.random()
				},function(html){
					$("#MainContent").html(html);
				},"html")
			}
			
			//确认打赏
			function confirm(){
				var userId = $("#teacherId").val();
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
				$.ajax({
					type:'post',
					data:{"teacherId":userId},
					url:'/home/expert/Islogin',
					datatype:'json',
					success:function(data){
						if(data.success){
							tipinfo(data.msg);
							window.location.href="/home/expert/payReward?teacherId="+userId+"&money="+money+"&rewardMsg="+rewardMsg;
						}else{
							tipinfo(data.msg);
						}
					},
					error:function(){
						alert("出错了!");
					}
				})
			}
			
			
			$('.shangList li').click(function(){
				$(this).addClass('on').siblings().removeClass('on');
			})
			//关注
			function followByPC(userId){
				var str=$("#follow").html();
				var msg=str.replace("+","");
				var url='';
				if(msg=='关注'){
					//去关注
					url='/home/expert/addFoolow';
				}else{
					//取消关注
					url='/home/expert/cancelFoolow';
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
								$("#follow").html("+取消关注");
							}else{
								$("#follow").html("+关注");
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
			function showBoxByPC(teacherId){
				$("#teacherId").val(teacherId);
				$('#dia').show();
				$('#shangDialog').show();
				shang(1);
			}
			$('.closeDia').click(function(){
				$('#dia').hide();
				$('#shangDialog').hide();
			})
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
