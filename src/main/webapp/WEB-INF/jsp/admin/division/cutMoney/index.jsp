<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style>
		.content{
			width: 100%;
		    height: 100%;
		    text-align: center;
		}
		.topIns{
			width:80%;
			margin-left:10%;
			margin-top:20px;
			border:1px solid #ddd;
			border-radius:5px;
			padding:10px 15px;
			margin-bottom:10px;
		}
		.insItem{
			text-align:left;
			padding:10px 0;
		}
		.insItem>span{
			font-size:13px;
			display:inline-block;
			width:45%;
			color:#949494;
		}
		.layui-form-item{
			padding:0 15px;
			width:80%;
			margin-left:10%;
		}
		.insItem>span>b{
			font-weight:normal;
		}
		.layui-form-label{
			width:20%;
			float:left;
		}
		.layui-inline{
			width:100%;
			overflow:hidden;
		}
		.layui-form-item .layui-input-inline{
			width:50%;
			float:left;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div class="content">
		<div class="topIns">
			<p class="insItem"><span>专栏作家:<b>${realname }</b></span></p>
			<p class="insItem">
				<span>应发金额:<b id="shouldMoney">￥${shouldMoney }</b></span>
				<span>个税:<b id="personalTax">￥${personalTax }</b></span>
			</p>
		</div>
		<div class="layui-form-item">
		    <div class="layui-inline">
		      <label class="layui-form-label">扣款金额(元):</label>
		      <div class="layui-input-inline">
		        <input type="text" name="cutMoney" id="cutMoney" oninput="changeMoney();" lay-verify="required|number" autocomplete="off" class="layui-input">
		      </div>
		    </div>
		    <div class="layui-inline">
		      <label class="layui-form-label">扣款原因</label>
		      <div class="layui-input-inline">
		        <textarea placeholder="请输入内容" name="cutRmark" id="cutRmark" class="layui-textarea"></textarea>
		      </div>
		    </div>
		    <div class="layui-inline">
		      <label class="layui-form-label">实发金额(元):</label>
		      <div class="layui-input-inline">
		        <input type="text" name="actualMoney" id="actualMoney" lay-verify="required|number" value="${actualMoney }" autocomplete="off" class="layui-input">
		      </div>
		    </div>
    	</div>
		<!-- 营业税 -->
		<input type="hidden" id="salesTax" value="${salesTax }" />
		<input type="hidden" id="id" value="${id }" />
		<button style="width:125px;" class="layui-btn" id="start">保存并重新计算</button>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		function changeMoney(){
			//扣款金额
			var cutMoney=Number($("#cutMoney").val());
			//应发金额
			var shouldMoney=Number($("#shouldMoney").text().replace("￥",""));
			//营业税
			var salesTax = Number($("#salesTax").val());
			//个税
			var personalTax = Number($("#personalTax").text().replace("￥",""));
			var actualMoney=(shouldMoney-cutMoney-salesTax-personalTax).toFixed(2);
			if(actualMoney<=0){
				actualMoney=0;
			}
			$("#actualMoney").val(actualMoney);
			
			
		}
		
		//保存并重新计算
		$("#start").click(function(){
			//id
			var id = $("#id").val();
			//扣款金额
			var cutMoney=Number($("#cutMoney").val());
			if(cutMoney==null||cutMoney==''){
				tipinfo("请输入扣款金额");
				return false;
			}
			//扣款原因
			var cutRmark = $("#cutRmark").val();
			if(cutRemark==null||cutRemark==''){
				tipinfo("请输入扣款原因");
				return false;
			}
			//实发金额
			var actualMoney = $("#actualMoney").val();
			
			$.ajax({
				type:'post',
				data:{"id":id,"cutMoney":cutMoney,"cutRmark":cutRmark,"actualMoney":actualMoney},
				url:'/${applicationScope.adminprefix }/division/cutMoney',
				datatype:'json',
				success:function(data){
					tipinfo(data.msg);
					closewindow();
				},
				error:function(){
					tipinfo("出错了!");
				}
			})
		})
		
	</script>
</m:Content>
</m:ContentPage>
