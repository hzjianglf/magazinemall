<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form" action="/${applicationScope.adminprefix }/system/dictionary/addOrUpDictionary" method="post">
				<input type="hidden" name="dictionaryId" value="${dic.dictionaryId }" />
            	<div class="layui-form-item">
					<label class="layui-form-label">项目名称：</label>
					<div class="layui-input-block">
						<input type="text" name="dictionaryName" lay-verify="required" autocomplete="off" class="layui-input" value="${dic.dictionaryName }"/>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">描述：</label>
					<div class="layui-input-block">
						<textarea class="layui-textarea" name="dictionaryDescription">${dic.dictionaryDescription }</textarea>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">类型：</label>
					<div class="layui-input-block" >
						<select name="dictionaryType">
						 	<option value="">无</option>
							<c:forEach items="${typeList}" var="item">
								<option value="${item.dictionaryType}" <c:if test="${item.dictionaryType eq dic.dictionaryType}"> selected="selected"</c:if>>
								${item.dictionaryType}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="layui-form-item" style="display: none;">
					<div class="layui-input-block">
						<button class="layui-btn submitBtn" lay-submit="" lay-filter="addEqBtn">立即提交</button>
						<button type="reset" class="layui-btn layui-btn-primary">重置</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use('form', function(){
			var form = layui.form;
			form.on('submit(addEqBtn)', function(){})
		})
	</script>
</m:Content>
</m:ContentPage>