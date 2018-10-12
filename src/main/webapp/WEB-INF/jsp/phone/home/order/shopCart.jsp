<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style type="text/css">
			.top{
				position: fixed;
			    top: 0;
			    left: 0;
			    z-index: 100000;
			}
			.top + *{
				top: 60px;
			}
			.check_box em{
			   margin-left:1rem;
			   line-height:1.4rem
			}
			.hj_qr {
			    position: fixed;
			    width: 100%;
			    height: 3.2rem;
			    border-top: 0.025rem solid #E5E5E5;
			    background: #FFFFFF;
			    left: 0;
			    bottom: 2.1rem;
			}
			.qx_mk {
				position: fixed;
			    width: 100%;
			    height: 1.5rem;
			    border-top: 0.025rem solid #E5E5E5;
			    background: #eee;
			    left: 0;
			    bottom: 2.1rem;
			}
			.qx_mk a {
				background:orange;
				margin-right: 1.5rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="/home/index" class="a1"><img src="/images/fh_biao.png"
				class="fh_biao"></a>
			<h3>购物车</h3>
			<a id="a_edit" data-flag="2" href="javascript:void(0);" class="a2 wc_biao">编辑</a>
		</div>
		<div class="gwc">
			<div class="gwc_lb">
				<div id="Div_Scoll">
					<div id="Div_content">
					</div>
				</div>
			</div>
			<div class="qx_mk" style="display:none">
				<span class="check_box">
				<input type="checkbox" id="check_All" style="display:none">
				<label for="check_All"></label> <em>全选</em>
				</span> <a href="javascript:deleteItem();">删除</a><!-- <a href="#">移入收藏</a> -->
			</div>
			<div class="hj_qr">
				<a href="javascript:void(0)" onclick="turnOrder()" class="ljzf_biao">立即支付 &nbsp;&nbsp;<i id="totalprice">￥0.00</i></a>
			</div>
		</div>
		<div id="Div_Temp" style="display:none">
		
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			//改变顶部的样式
			$(function() {		
				LoadPage();
				
				$("#check_All").on("change",function(){
					var checked=$(this).is(":checked");
					$(".gwc_nr :checkbox").prop("checked",checked);
				})
				
				$("#a_edit").on("click",function(){
					var flag=$(this).data("flag");
					if(flag==1){
						$(".qx_mk").hide(100);
						$(".hj_qr").show(200);
						$(this).html("编辑");
						var totalprice=0;
						$(".gwc_nr :checkbox:checked").each(function(){
							var price = $(this).data("price").toFixed(2);
							var count = $(this).parent().parent().find("input[name='count']").val()
							totalprice+=price*count;
						})
						totalprice="￥"+totalprice.toFixed(2);
						$("#totalprice").html(totalprice);
						$(this).data("flag",2);
					}else{
						$(".qx_mk").show(200);
						$(".hj_qr").hide(100);
						$(this).html("完成");
						$(this).data("flag",1);
					}
				})
				
			});
			function LoadPage(){
				//信息流加载
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#Div_Scoll' //流加载容器
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.ajax({
						        type:"get",
						        url:"/order/shopcartList?&pageNow="+page,
						        datatype:"html",
						        success:function(data){
						        	//将返回的数据添加到隐藏div中
						        	//两个id一个为了展示内容，一个找到里边的独有pagetotal的id，每次都会清空临时的这个div
						        	$("#Div_content,#Div_Temp").append(data);
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
			
		function change(id,ycount){
			var count =parseInt($("#c"+id).val());
			count = count+ycount;
			if(count==0){
				
				return ;
			}
			$.ajax({
		        type:"get",
		        url:"/order/changeShopCart?id="+id+"&count="+count,
		        datatype:"html",
		        success:function(data){
		        	if(data.result==1){
		        		var id =data.shopCartId;
		        		$("#c"+id).val(count);
		        	}else{
		        		tipinfo(data.msg);
		        	}
		        	var totalprice=0;
		        	$(".gwc_nr :checkbox:checked").each(function(){
						var price = $(this).data("price").toFixed(2);
						var count = $(this).parent().parent().find("input[name='count']").val();
						totalprice+=price*count;
					})
					totalprice="￥"+totalprice.toFixed(2);
					$("#totalprice").html(totalprice);	
		        },
		    });
		}
		
		function initCheckBox(){
			$(".gwc_nr :checkbox").on("change",function(){
				$("#check_All").prop("checked",$(".gwc_nr :checkbox").length==$(".gwc_nr :checkbox:checked").length);
				var totalprice=0;
				$(".gwc_nr :checkbox:checked").each(function(){
					var price = $(this).data("price").toFixed(2);
					var count = $(this).parent().parent().find("input[name='count']").val()
					totalprice+=price*count;
				})
				totalprice="￥"+totalprice.toFixed(2);
				$("#totalprice").html(totalprice);				
			})
		}
		function turnOrder(){
			var arr=[];
			$(".gwc_nr :checkbox:checked").each(function(){
				var id=$(this).val();
				if(arr.indexOf(id)==-1){
					arr.push(id);
				}
			})
			if(arr.length==0){
				tipinfo("请选择要购买的数据！");
				return false;
			}
			var ids=arr.join(",");
			var url = window.location.pathname;
			window.location.href="/order/turnJieSuan?shoppingIds="+ids+"&url="+url;
		}
		function deleteItem(){
			var arr=[];
			$(".gwc_nr :checkbox:checked").each(function(){
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
		        url:"/order/delShopCartItem?ids="+ids,
		        datatype:"html",
		        success:function(data){
		        	tipinfo(data.msg);
		        	$.each(arr,function(i,v){
		        		$("#div_"+v).remove();
		        	})
		        },
		    });
		}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
