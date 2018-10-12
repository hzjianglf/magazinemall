<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style>
			.drawing_top{
				margin:10px auto 0px;
				width:70%;
				border:3px solid #ddd;
				border-radius:10px;
				height: 72px;
			}
			.layui-form-item{
				width:70%;
				margin:10px auto 0px;
			}
			.layui-form-label{
				text-align:left;
				
			}
			input{
				text-align:center;
			}
		</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="drawing_top">
			<div style="margin:10px 0px 10px 20px;">专栏作家:${realname }</div>
			<div>
				<div style="float:left;margin:0px 0px 0px 20px">
					应发金额: ￥<label id="shouldMoney">${shouldMoney }</label>
				</div>
				<div style="float:left;margin:0px 0px 0px 50px">
					个税: ￥<label id="personalTax">${personalTax }</label>
				</div>
			</div>
		</div>
		
		<div class="layui-form-item">
			<label class="layui-form-label">扣款金额:</label>
			<div class="layui-input-block">
				<input type="text" name="cutMoney" maxlength="8" value="${cutMoney eq 'undefined'?'0':cutMoney }" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">扣款原因:</label>
			<div class="layui-input-block">
				<textarea placeholder="请输入内容" name="cutRemark" onchange="cutRemarkChange()" class="layui-textarea">${cutRemark eq 'undefined'?'':cutRemark }</textarea>
			</div>
		</div>
		<div class="layui-form-item">
			<label class="layui-form-label">实发金额:</label>
			<div class="layui-input-block">
				<input type="text" name="actualMoney" id="actualMoney" value="${actualMoney }" class="layui-input" disabled="">
			</div>
		</div>
		<div class="layui-form-item" style="text-align:center;margin:20px auto;">
			<button class="layui-btn" onclick="saveAgain()">保存并重新计算</button>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script>
			function cutRemarkChange(){
				$("input[name='cutMoney']").keyup();
			}
		 	$("input[name='cutMoney']").keyup(function(){
		 	var e = $("input[name='cutMoney']");
	 		var regu = /^[0-9]+\.?[0-9]*$/;
	        if (e.val() != "") {
	            if (!regu.test(e.val())) {
	                tipinfo("请输入正确的数字");
	                e.val(e.val().substring(0, e.length-1));
	                e.focus();
	            } 
	        }
			var shouldMoney = $("input[name='shouldMoney']").val();
		 	var cutMoney = $("input[name='cutMoney']").val();
			var year = ${year};
			var month = ${month};
			var id = ${id};
			var userId = ${userId};
			$.ajax({
					type:"post",
					url:"withDrawing",
					data:{
						"biID":${biID },
						"id":id,
						"userId":userId,
						"cutMoney":cutMoney,
						"year":year,
						"month":month,
						"shouldMoney":shouldMoney
					},
					dataType:"json",
					success:function(data){
						if(data.success){
							var should = data.data.shouldMoney;
							var person = data.data.personalTax;
							var actual = data.data.actualMoney;
							if(should<=0){
								should = 0;
							}
							if(person<=0){
								person = 0;
							}
							if(actual<=0){
								actual = 0;
							}
							$('#shouldMoney').html(should);
							$('#personalTax').html(person);
							$('#actualMoney').val(actual);
						}
					}
				});
			 });
		 	function saveAgain (){
		 		var cutRemark = $('textarea[name="cutRemark"]').val();
		 		$.ajax({
		 				type:"POST",
		 				url:"updBillReckonItem",
		 				data:{
		 					"year":${year},
							"month":${month},
		 					"cutRemark":cutRemark
		 				},
		 				success:function(data){
		 					tipinfo(data);
		 					closewindow();
		 				}
		 		});
		 	}
		</script>
	</m:Content>
</m:ContentPage>