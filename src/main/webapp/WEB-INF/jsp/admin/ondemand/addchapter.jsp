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
			<form class="layui-form" action="/${applicationScope.adminprefix }/ondemand/savaChapter" method="post">
				<input type="hidden" name="ondemandId" id="ondemandId"  value="${ondemandId }" />
				<!-- 父id -->
				<input type="hidden" name="parentId" id="parentId"  value="${parentId }" />
				<!-- 章节id -->
				<input type="hidden" name="chapterId" id="chapterId"  value="${chapterId }" />
            	<div class="layui-form-item">
					<label class="layui-form-label">${title }标题：</label>
					<div class="layui-input-block">
						<input type="text" name="title" lay-verify="required" autocomplete="off" class="layui-input" value="${msg.title }"/>
					</div>
				</div>
				<div class="layui-form-item" style="display: none;">
					<div class="layui-input-block">
						<button class="layui-btn submitBtn" lay-submit="" lay-filter="addEqBtn">立即提交</button>
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