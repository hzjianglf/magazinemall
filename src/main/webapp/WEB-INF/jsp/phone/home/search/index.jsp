<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<%@ taglib  uri="http://java.sun.com/jsp/jstl/functions"   prefix="fn"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style type="text/css">
			body{
	        		background: #fff;
	        	}
	        
			.countColor{
				color:red;
			}
			.xxk{
			     text-align:center;
			}
			.xxk ul li{
			      display: inline-block;
		          width:auto;
		          float:inherit;
			}
			.xxk ul li span{
			       padding:0 0.45rem
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="#" onclick="window.history.back();" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>搜索列表</h3>
		</div>
		<div class="sslb">
			<div class="sslb_top">
				<div class="ss_div ss_div1">
					<img src="/images/ss_biao.png" id="searchName">
					<input type="text" class="in1" placeholder="请输入关键字" />
				</div>
				<button id="refresh">取消</button>
			</div>
			<div class="clear"></div>
			<div class="rmss">
				<h3>热门搜索：</h3>
				<div class="rmss_nr">
					<c:forEach var="item" items="${list }">
						<a href="javascript:search('${item }');">${item}</a>
					</c:forEach>
				</div>
			</div>
		</div>
		<div class="djq hide">
			<div class="xxk">
				<ul>
					<li class="on" data-val="2"><span>期刊</span></li>
					<li data-val="0"><span>点播课程</span></li>
					<li data-val="1"><span>直播课程</span></li>
					<li data-val="3"><span>专家</span></li>
					<li data-val="4"><span>商品</span></li>
				</ul>
			</div>
			<div class="det_content2">
				<div id="Div_Scoll_1" style="display:none;">
					<div class="zzbk_lb">
						<div id="zzbk_lb_1"></div>
					</div>
				</div>
				<div id="Div_Scoll_2">
					<div class="zzbk_lb">
						<div id="zzbk_lb_2"></div>
					</div>
				</div>
				<div id="Div_Scoll_3" style="display:none;">
					<div class="zzbk_lb">
						<div id="zzbk_lb_3"></div>
					</div>
				</div>
				<div id="Div_Scoll_0" style="display:none;">
					<div class="zzbk_lb">
						<div id="zzbk_lb_0"></div>
					</div>
				</div>
				<div id="Div_Scoll_4" style="display:none;">
					<div class="zzbk_lb">
						<div id="zzbk_lb_4"></div>
					</div>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function(){
				$('.in1').focus();
			})
			$('#refresh').click(function(){
				window.location.href="/home/turnSearche";
			});
			$('#searchName').click(function(){
				$("[id^='zzbk_lb']").html("");
				var name = $(".in1").val();
				$(".rmss").addClass("hide");
				$(".djq").removeClass("hide");
				var num=2;
				var obj = $('.xxk').find('.on').data("val");
				if(obj != null){
					num = obj;
				}
				LoadPage(num,name);
			});
			function search(name){
				$(".in1").val(name);
				$(".rmss").addClass("hide");
				$(".djq").removeClass("hide");
				LoadPage(2,name);
			}
			$('.xxk').find('li').click(function() {
				$("[id^='zzbk_lb']").html("");
				$('.xxk').find('li').removeClass('on');
				$(this).addClass('on');
				var type = $(this).data("val");
				var name = $(".in1").val();
				
				for(var i = 0 ; i <= 4 ; i++ ){
					$("#Div_Scoll_"+i).css("display","none");
				}
				$("#Div_Scoll_"+type).css("display","inline");
				$(".rmss").addClass("hide");
				$(".djq").removeClass("hide");
				LoadPage(type,name);
			});
			
			function LoadPage(type,name){
				//信息流加载
				layui.use('flow', function(){
					var flow = layui.flow;
					flow.load({
					elem: '#Div_Scoll_'+type //流加载容器
					, isAuto: true
					,isLazyimg: true
					,done: function(page,next){ //执行下一页的回调
					    	$.ajax({
								type:"get",
								url:"/home/searchContentByName?type="+type+"&page="+page+"&name="+name,
								datatype:"html",
								success:function(data){
									//将返回的数据添加到隐藏div中
									//两个id一个为了展示内容，一个找到里边的独有pagetotal的id，每次都会清空临时的这个div
									$("#zzbk_lb_"+type,"#Div_Scoll_"+type).append(data);
									var totalPage =$("#Div_Scoll_"+type).find("#Hid_TotalPage").val();
									next ("", page < totalPage);
						        },
						    });
					    }
					  });
				});
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
