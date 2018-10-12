<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	<style>
		.zzbk_lb ul li p {
	    margin-top: 0.35rem;
	    line-height: 0.8rem;
	    font-size: 0.6rem;
	    height: 3.2rem;
	    color: #4C4C4C;
		}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="/home/index" class="a1">
				<img src="/images/fh_biao.png" class="fh_biao">
			</a>
			<!-- <div class="ss_div ss_div1" onclick="turnSel()">
				<img src="/images/ss_biao.png"> 
				<input type="text" class="in1" />
			</div> -->
		</div>
		<div class="sclb">
			<div class="find_nav_left">
				<div class="find_nav_list">
					<ul>
						<c:forEach items="${years}" var="item">
							<li><a href="javascript:void(0)" data-v="${item}">${item}</a></li>
						</c:forEach>
					</ul>
				</div>
			</div>
			<div id="Div_Scoll">
				<div class="zzbk_lb" style="display: inline-block;">
					<div id="zzbk_lb"></div>
				</div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
		function turnSel(){
			window.location.href = "/home/turnSearche";
		}
		var type;
		//改变顶部的样式
		$(function() {		
			$(".find_nav_list a").on("click",function(){
				$(this).parent().siblings().find("a").removeClass("hover");
				$(this).addClass("hover");
				$("#zzbk_lb,#Div_Temp").html("");
				type=$(this).data("v");
				LoadPage();
			})
			
			$(".find_nav_list li a:last").addClass("sideline");
			$(".find_nav_list li a:first").click();
		});
		var flg = false;
		function LoadPage(){
			//信息流加载
			layui.use('flow', function(){
				  var flow = layui.flow;
				  flow.load({
				    elem: '#Div_Scoll' //流加载容器
				    , isAuto: true
	                , isLazyimg: true
				    ,done: function(page, next){ //执行下一页的回调
						console.log(type)
				    	if(flg){
				    		return ;
				    	}
				    	flg = true;
				    	$.ajax({
					        type:"get",
					        url:"/product/partialList?type="+type+"&pageNow="+page,
					        datatype:"html",
					        success:function(data){
					        	//将返回的数据添加到隐藏div中
					        	//两个id一个为了展示内容，一个找到里边的独有pagetotal的id，每次都会清空临时的这个div
					        	$("#zzbk_lb,#Div_Temp").append(data);
					        	var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
	                            next("", page < totalPage);
	                            flg = false;
					        },
					    });
				    }
				  });
			});
		}
		//搜索
		
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
