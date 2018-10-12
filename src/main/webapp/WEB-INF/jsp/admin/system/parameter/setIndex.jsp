<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="pxkj"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<px:ContentPage materPageId="master">
	<px:Content contentPlaceHolderId="css">
	<style>
	
	.layui-form-label{
		width:130px!important;
	}
	.layui-input-inline{
		width:280px!important;
	}
	.layui-input-block{
	    margin-left: 160px!important;
	}
	</style>
	</px:Content>
	<px:Content contentPlaceHolderId="content">
		<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
			<div class="yw_cx">
				<blockquote class="layui-elem-quote  layui-bg-blue">参数设置</blockquote>
			</div>
			<div class="layui-tab">
				<ul class="layui-tab-title">
					<li class="layui-this">分成规则</li>
					<li>热搜词设置</li>
				</ul>
				<div class="layui-tab-content">
					<!-- 分成规则设置 -->
					<div class="layui-tab-item layui-show">
						<form class="layui-form" id="ruleForm">
							<div class="layui-form-item">
							    <div class="layui-inline">
								    <label class="layui-form-label">课销收入公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="ondemandSalesIncome" value="${ruleSetting.ondemandSalesIncome }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">课销增值税公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="ondemandSalesTax" value="${ruleSetting.ondemandSalesTax }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">课销分成公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="ondemandSalesSeparate" value="${ruleSetting.ondemandSalesSeparate }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							</div>
							<div class="layui-form-item">
								<div class="layui-inline">
								    <label class="layui-form-label">问答收入公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="questionSalesIncome" value="${ruleSetting.questionSalesIncome }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">问答增值税公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="questionSalesTax" value="${ruleSetting.questionSalesTax }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">问答分成公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="questionSalesSeparate" value="${ruleSetting.questionSalesSeparate }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							</div>
							<div class="layui-form-item">
								<div class="layui-inline">
								    <label class="layui-form-label">打赏收收入公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="rewardSalesIncome" value="${ruleSetting.rewardSalesIncome }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">打赏增值税公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="rewardSalesTax" value="${ruleSetting.rewardSalesTax }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">打赏分成公式</label>
								    <div class="layui-input-inline">
									    <input type="text" name="rewardSalesSeparate" value="${ruleSetting.rewardSalesSeparate }" autocomplete="off" class="layui-input">
								    </div>
							    </div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">应发总金额公式</label>
								<div class="layui-input-block">
									<input type="text" name="shouldPayment" value="${ruleSetting.shouldPayment }" autocomplete="off" class="layui-input">
								</div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">个税计算公式</label>
								<div id="btn_personal" class="layui-inline">
									<c:choose>
										<c:when test="${not empty ruleSetting.personalTaxList}">
											<c:forEach items="${ruleSetting.personalTaxList}" var="item" varStatus="status">
												<div class="layui-form-item">
													<span style="float: left;" class="layui-form-mid layui-word-aux">应发总金额</span>
													<div class="layui-input-inline">
														<select name="operator_${status.index+1}">
															<option value="大于等于" ${item.operator eq 'GreaterThanEqual'?"selected":""}>大于等于</option>
															<option value="大于" ${item.operator eq 'GreaterThan'?"selected":""}>大于</option>
															<option value="等于" ${item.operator eq 'Equal'?"selected":""}>等于</option>
															<option value="小于等于" ${item.operator eq 'LessThanEqual'?"selected":""}>小于等于</option>
															<option value="小于" ${item.operator eq 'LessThan'?"selected":""}>小于</option>
														</select>
													</div>
													<div class="layui-input-inline">
														<input type="text" name="money_${status.index+1}" onkeyup="value=value.replace(/[^\d\.]+?/g,'')"  value="${item.money}" autocomplete="off" class="layui-input">
													</div>
													<span class="layui-form-mid layui-word-aux" style="float: left;">元</span>
													<div class="layui-input-inline">
														<input type="text" name="formula_${status.index+1}"  value="${item.formula}" autocomplete="off" class="layui-input">
													</div>
													<div class="layui-input-inline" style="line-height: 36px;">
														<button type="button" onclick='add(this)' class="layui-btn layui-btn-xs layui-btn-normal" >添加</button>
														<c:if test="${status.index>0}">
															<button type="button" onclick='remove(this)' class="layui-btn layui-btn-xs  layui-btn-warm">删除</button>
														</c:if>
													</div>
												</div>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<div class="layui-form-item">
												<span style="float: left;" class="layui-form-mid layui-word-aux">应发总金额</span>
												<div class="layui-input-inline">
													<select name="operator_1">
														<option value="大于等于">大于等于</option>
														<option value="大于">大于</option>
														<option value="等于">等于</option>
														<option value="小于等于">小于等于</option>
														<option value="小于">小于</option>
													</select>
												</div>
												<div class="layui-input-inline">
													<input type="text" name="money_1" onkeyup="value=value.replace(/[^\d\.]+?/g,'')"  autocomplete="off" class="layui-input">
												</div>
												<span class="layui-form-mid layui-word-aux" style="float: left;">元</span>
												<div class="layui-input-inline">
													<input type="text" name="formula_1" autocomplete="off" class="layui-input">
												</div>
												<div class="layui-input-inline" style="line-height: 36px;">
													<button type="button" onclick='add(this)' class="layui-btn layui-btn-xs layui-btn-normal" >添加</button>
												</div>
											</div>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
							<div class="layui-form-item">
								<div class="layui-inline">
								    <label class="layui-form-label">打赏分成默认比例</label>
								    <div class="layui-input-inline">
									    <input type="text" name="defaultRewardRate" onkeyup="value=value.replace(/[^\d\.]+?/g,'')" value="${ruleSetting.defaultRewardRate }" autocomplete="off" class="layui-input">
								    </div>
								    <span class="layui-form-mid layui-word-aux" style="float: left;">%</span>
							    </div>
							    <div class="layui-inline">
								    <label class="layui-form-label">问答分成默认比例</label>
								    <div class="layui-input-inline">
									    <input type="text" name="defaultQuestionRate" onkeyup="value=value.replace(/[^\d\.]+?/g,'')" value="${ruleSetting.defaultQuestionRate }" autocomplete="off" class="layui-input">
								    </div>
								    <span class="layui-form-mid layui-word-aux" style="float: left;">%</span>
							    </div>
							</div>
							<div class="layui-form-item">
								<label class="layui-form-label">实发总金额公式</label>
								 <div class="layui-input-block">
									 <input type="text" name="actualPayment" value="${ruleSetting.actualPayment }" autocomplete="off" class="layui-input">
								 </div>
							</div>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button type="button" class="layui-btn" id="RuleSave">提交</button>
								</div>
							</div>
						</form>
					</div>
					<!-- 热搜词设置 -->
					<div class="layui-tab-item">
						<form class="layui-form" id="seacherForm">
							<div class="layui-form-item layui-form-text">
							    <div class="layui-input-block">
							    	<textarea placeholder="请输入内容" name="hotWords" class="layui-textarea">${hotWords }</textarea>
								    <p>多个热搜词之间用英文,号区分</p>
							    </div>
						    </div>
							<div class="layui-form-item">
								<div class="layui-input-block">
									<button type="button" class="layui-btn" id="seacherSave">提交</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<div id="div_temp" class="layui-hide">
			<div class="layui-form-item">
				<span style="float: left;" class="layui-form-mid layui-word-aux">应发总金额</span>
				<div class="layui-input-inline">
					<select name="operator_{index}">
						<option value="大于等于">大于等于</option>
						<option value="大于">大于</option>
						<option value="等于">等于</option>
						<option value="小于等于">小于等于</option>
						<option value="小于">小于</option>
					</select>
				</div>
				<div class="layui-input-inline">
					<input type="text" name="money_{index}" onkeyup="value=value.replace(/[^\d\.]+?/g,'')" autocomplete="off" class="layui-input">
				</div>
				<span class="layui-form-mid layui-word-aux" style="float: left;">元</span>
				<div class="layui-input-inline">
					<input type="text" name="formula_{index}" autocomplete="off" class="layui-input">
				</div>
				<div class="layui-input-inline" style="line-height: 36px;">
					<button type="button" onclick='add(this)' class="layui-btn layui-btn-xs layui-btn-normal">添加</button>
					<button type="button" onclick='remove(this)' class="layui-btn layui-btn-xs  layui-btn-warm">删除</button>
				</div>
			</div>
		</div>
	</px:Content>
	<px:Content contentPlaceHolderId="js">
		<script>
			var form=null;
			layui.use([ 'element', 'layer', 'form' ],function() {
				var element = layui.element;
				var layer = layui.layer;
				form = layui.form;
				//分成规则
				$("#RuleSave").click(function() {
					$.ajax({
							type : 'post',
							url : '/${applicationScope.adminprefix }/parameter/setRule',
							data : $("#ruleForm").serialize(),
							datatype : 'json',
							success : function(data) {
								tipinfo(data.msg);
								if(data.success){
									setTimeout(function(){
										location.reload();
									},1000);
								}
							},
							error : function() {
								tipinfo("出错了!");
							}
					})
				})
				//热搜词设置
				$("#seacherSave").click(function() {
					$.ajax({
							type : 'post',
							url : '/${applicationScope.adminprefix }/parameter/setSearch',
							data : $("#seacherForm").serialize(),
							datatype : 'json',
							success : function(data) {
								tipinfo(data.msg);
								if(data.success){
									setTimeout(function(){
										location.reload();
									},1000);
								}
							},
							error : function() {
								tipinfo("出错了!");
							}
					})
				})

			});
			var index=$("#btn_personal>div").length;
			
			function add(o){
				var $div=$(o).parents("div.layui-form-item:first");
				var html=$("#div_temp").html();
				
				html=html.replace(/{index}/g,++index);
				
				$(html).insertAfter($div);
				
				if(form!=null){
					form.render("select");
				}
			};
			
			function remove(o){
				$(o).parents("div.layui-form-item:first").remove();
			}
		</script>
	</px:Content>
</px:ContentPage>
