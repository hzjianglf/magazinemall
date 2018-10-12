<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<link type="text/css" href="manage/public/layui/css/layui.css" />
		<link type="text/css" href="manage/public/layui/css/layui.mobile.css" />
		<style>
.content {
	width: 80%;
	border: 1px solid #ccc;
	margin: 0 auto;
	padding: 30px 20px;
}
</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
			<legend>计算公式设置</legend>
		</fieldset>
		<form class="layui-form" id="savePost">
			<div class="content">
				<input type="hidden" name="year" value="${year}"> <input type="hidden" name="month" value="${month }">
				<div class="layui-form-item">
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">课销收入计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="ondemandSalesIncome" value="${setting.ondemandSalesIncome }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">问答收入计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="questionSalesIncome" value="${setting.questionSalesIncome }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">打赏收入计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="rewardSalesIncome" value="${setting.rewardSalesIncome }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">课销营业税计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="ondemandSalesTax" value="${setting.ondemandSalesTax }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">问答营业税计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="questionSalesTax" value="${setting.questionSalesTax }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">打赏营业税计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="rewardSalesTax" value="${setting.rewardSalesTax}" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">课销分成计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="ondemandSalesSeparate" value="${setting.ondemandSalesSeparate }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">问答分成计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="questionSalesSeparate" value="${setting.questionSalesSeparate }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">打赏分成计算公式</label>
						<div class="layui-input-inline" style="width: 50%">
							<input type="text" name="rewardSalesSeparate" value="${setting.rewardSalesSeparate }" autocomplete="off" class="layui-input">
						</div>
					</div>
					<div class="layui-form-item">
						<label class="layui-form-label" style="width: 130px;">应发总金额公式</label>
						<div class="layui-input-inline" style="width: 75%">
							<input type="text" name="shouldPayment" value="${setting.shouldPayment }" autocomplete="off" class="layui-input">
						</div>
					</div>
					
					<div id="needSaveAndDel">
						<c:choose>
							<c:when test="${not empty setting.personalTaxList}">
								<c:forEach items="${setting.personalTaxList}" var="item" varStatus="status">
									<div class="layui-form-item">
										<label class="layui-form-label" style="width: 130px;">
											<c:if test="${status.index==0}">
												个税计算公式
											</c:if>
										</label>
										<span style="float: left;" class="layui-form-mid layui-word-aux">应发总金额</span>
										<div class="layui-input-inline">
											<select name="operator" lay-verify="required" lay-search="">
												<option value="大于等于" ${item.operator eq 'GreaterThanEqual'?"selected":""}>大于等于</option>
												<option value="大于" ${item.operator eq 'GreaterThan'?"selected":""}>大于</option>
												<option value="等于" ${item.operator eq 'Equal'?"selected":""}>等于</option>
												<option value="小于等于" ${item.operator eq 'LessThanEqual'?"selected":""}>小于等于</option>
												<option value="小于" ${item.operator eq 'LessThan'?"selected":""}>小于</option>
											</select>
										</div>
										<div class="layui-fluid">
											<input style="width: 10%; float: left" type="text" name="money" value="${item.money}" autocomplete="off" class="layui-input layui-input-inline">
											<span class="layui-form-mid layui-word-aux" style="float: left;">元</span>
											<input style="width: 40%; float: left" type="text" name="formula" value="${item.formula}" autocomplete="off" class="layui-input layui-input-inline">
										</div>
										
										<c:if test="${status.index==0}">
										<a href="javascript:void(0)" onclick='addhtml(this)' class="layui-form-mid layui-word-aux" id="addhtml">添加</a>
										</c:if>
										<c:if test="${status.index!=0}">
										<a href="javascript:void(0)" id="addhtml" onclick='addhtml(this)' class="layui-form-mid layui-word-aux">添加</a>&nbsp;<a href="javascript:void(0)" onclick="delhtml(this)" class="layui-form-mid layui-word-aux" id="delhtml">删除</a>
										</c:if>
									</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
								<div class="layui-form-item">
									<label class="layui-form-label" style="width: 130px;">个税计算公式</label>
									<span style="float: left;" class="layui-form-mid layui-word-aux">应发总金额</span>
									<div class="layui-input-inline">
										<select name="operator" lay-verify="required" lay-search="">
											<option value="大于等于">大于等于</option>
											<option value="大于">大于</option>
											<option value="等于">等于</option>
											<option value="小于等于">小于等于</option>
											<option value="小于">小于</option>
										</select>
									</div>
									<div class="layui-fluid">
										<input style="width: 10%; float: left" type="text" name="money" autocomplete="off" class="layui-input layui-input-inline">
										<span class="layui-form-mid layui-word-aux" style="float: left;">元</span>
										<input style="width: 40%; float: left" type="text" name="formula" autocomplete="off" class="layui-input layui-input-inline">
									</div>
									<a href="javascript:void(0)" id="addhtml" onclick='addhtml(this)' class="layui-form-mid layui-word-aux">添加</a>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				
				<div id="loop" class="layui-hide">
					<div class="layui-form-item" id="geren">
						<label class="layui-form-label" style="width: 130px;"></label>
						<span style="float: left;" class="layui-form-mid layui-word-aux">应发总金额</span>
						<div class="layui-input-inline">
							<select name="operator" lay-verify="required" lay-search="">
								<option value="大于等于">大于等于</option>
								<option value="大于">大于</option>
								<option value="等于">等于</option>
								<option value="小于等于">小于等于</option>
								<option value="小于">小于</option>
							</select>
						</div>
						<div class="layui-fluid">
							<input style="width: 10%; float: left" type="text" name="money" autocomplete="off" class="layui-input layui-input-inline">
							<span class="layui-form-mid layui-word-aux" style="float: left;">元</span>
							<input style="width: 40%; float: left" type="text" name="formula" autocomplete="off" class="layui-input layui-input-inline">
						</div>
						<a href="javascript:void(0)" id="addhtml" onclick='addhtml(this)' class="layui-form-mid layui-word-aux">添加</a>&nbsp;<a href="javascript:void(0)" onclick="delhtml(this)" class="layui-form-mid layui-word-aux" id="delhtml">删除</a>
					</div>
				</div>
				
				<div class="layui-form-item">
					<label class="layui-form-label" style="width: 130px;">实发总金额公式</label>
					<div class="layui-input-inline" style="width: 70%">
						<input type="text" name="actualPayment" value="${setting.actualPayment }" autocomplete="off" class="layui-input">
					</div>
				</div>
				
			</div>
			<input type="hidden" id="personalTaxList" name="personalTaxList" />
		</form>
		<div style="width: 200px; margin: 20px auto;">
			<button class="layui-btn layui-btn-normal" id="savenext" style="width: 230px;">下一步</button>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script>
			$('#savenext').click(
				function() {
				var arr = [];
				$("#needSaveAndDel>div").each(function() {
							var operator = $(this).find(
									"select[name='operator']").val();
							var money = $(this).find(
									"input[name='money']").val();
							var formula = $(this).find(
									"input[name='formula']").val();
							arr.push({
								operator : operator,
								money : money,
								formula : formula
							});
						});
				$("#personalTaxList").val(JSON.stringify(arr));
				$.ajax({
					type : 'get',
					data : $('#savePost').serialize(),
					url : 'saveCalcRuleSetting',
					datatype : 'json',
					success : function(data) {
						if (data.success) {
							parent.nextP('${year}','${month }');
							closewindow();
						}
						tipinfo(data.msg);
					},
					error : function() {
						tipinfo("出错了!");
					}
				})
			});
			
			var form=null;
			layui.use(['form'], function(){
				form = layui.form;
			});
			
			function addhtml(obj){
				$('#needSaveAndDel').append($('#loop').html());
				if(form!=null){
					form.render("select");
				}
			};
			
			function delhtml(obj){
				obj.parentNode.parentNode.removeChild(obj.parentNode);
			}
			
		</script>
	</m:Content>
</m:ContentPage>