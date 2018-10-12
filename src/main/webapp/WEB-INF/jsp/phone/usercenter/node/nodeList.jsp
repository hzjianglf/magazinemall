<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style type="text/css">
				
			
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>学习记录</h3>
		</div>
		<div class="jrxx" id="container">
			<div id="Div_data">
			</div>
			<div id="Div_Temp" style="display:none"></div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script>
		$(function(){
			layui.use('flow', function(){
				  var flow = layui.flow;
				  flow.load({
				    elem: '#container',  //流加载容器 
				    isAuto: true, 
	                isLazyimg: true ,
				    done: function(page, next){ //执行下一页的回调
				    	$.get("/usercenter/node/nodeList",{
							page:page,
							pageSize:6,
							r:Math.random()
						},function(html){
							$("#Div_data,#Div_Temp").append(html);
							var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
				        	$("#Div_Temp").html("");
							next("", page < totalPage);
						},"html")
				    }
				  });
			});
		})
		function cancelNode(id){
			confirminfo("确定删除此学习记录吗？",function(){
				$.post("/usercenter/node/cancelNode",{
					id:id,
					r:Math.random()
				},function(json){
					tipinfo(json.msg);
					if(json.result){
						$("#div_"+id).remove();
					}
				},"json").error(function(){
					tipinfo("删除失败,请稍后再试！");
				});
			})
		}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
