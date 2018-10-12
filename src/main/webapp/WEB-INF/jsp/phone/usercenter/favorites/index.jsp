<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			.zzbk_lb .qx_mk {
				bottom: -2.5rem;
			}
			html,body{
				height:100%;
			}
			.top{
				position:fixed;
				top:0;
				width:100%;
				
			}
			.qx_mk{
				position:fixed;
				bottom:0 !important;
			}
			.djq{
			width:100%;
				height:100%;
				
			}
			.det_content2{
			position:relative;
				top:2.25rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png"
				class="fh_biao"></a>
			<h3>我的收藏</h3>
		</div>
		<div class="djq">
			<!-- <div class="xxk">
				<ul>
					<li class="on" data-v="1"><span>纸质期刊</span></li>
					<li  data-v="2"><span>电子期刊</span></li>
				</ul>
			</div> -->
			<div class="det_content2">
				<div id="Div_Scoll_1">
					<div class="zzbk_lb" style="display: inline-block;">
						<div id="zzbk_lb_1"></div>
					</div>
				</div>
				<div id="Div_Scoll_2" style="display:none;">
					<div class="zzbk_lb" style="display: inline-block;">
						<div id="zzbk_lb_2"></div>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</div>
		<div id="Div_Temp" style="display:none"></div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
			<script type="text/javascript">
			$(function() {
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					
					var v=$(this).data("v");
					$("[id^='Div_Scoll']").hide();
					$("#Div_Scoll_"+v).show();
				});
				
				LoadPage(1);
				LoadPage(2);
			});
			
			function LoadPage(type){
				//信息流加载
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#Div_Scoll_'+type //流加载容器
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.ajax({
						        type:"get",
						        url:"/usercent/favorite/partialList?type="+type+"&pageNow="+page,
						        datatype:"html",
						        success:function(data){
						        	//将返回的数据添加到隐藏div中
						        	//两个id一个为了展示内容，一个找到里边的独有pagetotal的id，每次都会清空临时的这个div
						        	$("#zzbk_lb_"+type+",#Div_Temp").append(data);
						        	var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
						        	$("#Div_Temp").html("");
						        	initCheckBox();
		                            next("", page < totalPage);
						        },
						    });
					    }
					  });
				});
			}
			function initCheckBox(){
				$("#check_All").on("change",function(){
					var checked=$(this).is(":checked");
					$(".subCheck :checkbox").prop("checked",checked);
				})
				
				$(".subCheck :checkbox").on("change",function(){
					$("#check_All").prop("checked",$(".subCheck :checkbox").length==$(".subCheck :checkbox:checked").length);
				})
			}
			function turnOndemand(id){
				window.location.href="/product/classDetail?ondemandId="+id;
			}
			function deleteItem(){
				var arr=[];
				$(".subCheck :checkbox:checked").each(function(){
					var id=$(this).val();
					if(arr.indexOf(id)==-1){
						arr.push(id);
					}
				})
				if(arr.length==0){
					tipinfo("请选择要删除的数据！");
					return false;
				}
				var ids=arr.join(",");
				$.ajax({
			        type:"get",
			        url:"/usercent/favorite/delFavrites?ids="+ids+"&dataType=1",
			        datatype:"html",
			        success:function(data){
			        	alertinfo(data.msg,function(){
			        		location.reload();
			        	})
			        },
			    });
			}
			function delOndemanFavorite(id){
				$.ajax({
			        type:"get",
			        url:"/usercent/favorite/delFavrites?ids="+id+"&dataType=3",
			        datatype:"html",
			        success:function(data){
			        	alertinfo(data.msg,function(){
			        		location.reload();
			        	})
			        },
			    });
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
