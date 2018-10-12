<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>已购</h3>
		</div>
		<div class="djq">
			<div class="xxk xxk1">
				<ul>
					<li class="on" data-type="1"><span>商品</span></li>
					<li data-type="2"><span>电子书刊</span></li>
					<li data-type="3"><span>点播课程</span></li>
					<li data-type="4"><span>直播课程</span></li>

				</ul>
			</div>
			<div class="det_content2">
				<div class="zzjx_lb" id="product_content">
					<div id="pro_Content">
						
					</div>
					<div id="Div_Temp1"></div>
				</div>
				<div class="zzjx_lb hide" id="Ebook_Content">
					<div id="E_Content">
					</div>
						<div id="Div_Temp2"></div>
				</div>
				<div class="zzjx_lb hide" id="class_Content1">
					<div id="class_con1">
					</div>
						<div id="class_Temp1"></div>
				</div>
				<div class="zzjx_lb hide" id="class_Content2">
					<div id="class_con2">
					</div>
						<div id="class_Temp2"></div>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//$("#pro_Content,#Div_Temp1").html('');
				$('#pro_Content,#E_Content,#class_con1,#class_con2').html('');
				product();
			});
			//样式选中
			$('.xxk').find('li').click(function() {
				$('#pro_Content,#E_Content,#class_con1,#class_con2').html('');
				$('.xxk').find('li').removeClass('on');
				$(this).addClass('on');
				$('.det_content2').children('div').hide();
				$('.det_content2').children('div').eq($(this).index()).show();
				var type=$(this).data('type');
				if(type=='1'){
					product();//商品
				}else if(type=='2'){
					zineBook();//电子书
				}else if(type=='3'){
					ondemand(0);//点播课程
				}else if(type=='4'){
					ondemand(1);//直播课程
				}
			});
			//期刊
			function product(){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#product_content' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/usercenter/order/selectProduct",{
								page:page,
								pageSize:6,
								r:Math.random()
							},function(html){
								$("#pro_Content,#Div_Temp1").append(html);
								var totalPage =$("#Div_Temp1").find("#Hid_TotalPage1").val();
					        	$("#Div_Temp1").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			//电子书
			function zineBook(){
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#Ebook_Content' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/usercenter/order/selectEbook",{
								page:page,
								pageSize:6,
								r:Math.random()
							},function(html){
								$("#E_Content,#Div_Temp2").append(html);
								var totalPage =$("#Div_Temp2").find("#Hid_TotalPage2").val();
					        	$("#Div_Temp2").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			//课程
			function ondemand(type){
				var count=1;
				if(type=='0'){
					count=1;
				}else if(type=='1'){
					count=2;
				}
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#class_Content'+count //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/usercenter/order/selectOndemand",{
								page:page,
								pageSize:6,
								type:type,
								r:Math.random()
							},function(html){
								$("#class_con"+count+",#class_Temp"+count+"").append(html);
								var totalPage =$("#class_Temp"+count+"").find("#Hid_TotalPage3").val();
					        	$("#class_Temp"+count+"").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			function readEBook(pubId){
				window.location.href="/usercenter/order/getEBookContent?pubId="+pubId+"&geren=1&type=1&pageNow=1"+"&pageSize=10";
			}
			function openEBook(id){
				window.location.href="/usercenter/order/getEbookListById?id="+id;
			}
			function toDetails(status,orderId){
				window.location.href="/usercenter/account/toDetail?orderId="+orderId;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
