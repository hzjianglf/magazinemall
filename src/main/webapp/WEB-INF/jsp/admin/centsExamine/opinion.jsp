<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style>
.layui_margin {
	margin: 20px;
}
</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="layui-form layui_margin">
			<c:if test="${trialStatus>1 }">
				<div class="layui-form-item">
					<label class="layui-form-label">初审结果</label>
					<div class="layui-input-block">
						<input type="radio" name="chushen" value="通过" title="通过" ${(trialStatus>2)?'checked':'disabled' }> 
						<input type="radio" name="chushen" value="拒绝" title="拒绝" ${(trialStatus==2)?'checked':'disabled' }>
					</div>
				</div>
				<div class="layui-form-item layui-form-text">
					<label class="layui-form-label">初审意见</label>
					<div class="layui-input-block" style="width: 60%">
						<textarea placeholder="请输入内容" class="layui-textarea" disabled="">${fistTrialRemark }</textarea>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">初审时间</label>
					<div class="layui-form-label">${fistTrialTime }</div>
					<div class="layui-form-label">${fistTralUser }</div>
				</div>
			</c:if>
			<c:if test="${trialStatus>3 }">
				<hr />
				<div class="layui-form-item">
					<label class="layui-form-label">复审结果</label>
					<div class="layui-input-block">
						<input type="radio" name="fushen" value="通过" title="通过" ${(trialStatus>4)?'checked':'disabled' }>
						<input type="radio" name="fushen" value="拒绝" title="拒绝" ${(trialStatus==4)?'checked':'disabled' }>
					</div>
				</div>
				<div class="layui-form-item layui-form-text">
					<label class="layui-form-label">复审意见</label>
					<div class="layui-input-block" style="width: 60%">
						<textarea placeholder="请输入内容" class="layui-textarea" disabled="">${reTrialRemark }</textarea>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">复审时间</label>
					<div class="layui-form-label">${reTrialTime }</div>
					<div class="layui-form-label">${reTralUser }</div>
				</div>
			</c:if>
		</div>
		<div style="margin: 0px auto; width: 30%">
			<button class="layui-btn layui-btn-normal" style="width: 100%;"
				id="close">关闭</button>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$('#close').click(function() {
				closewindow();
			});
		</script>
	</m:Content>
</m:ContentPage>