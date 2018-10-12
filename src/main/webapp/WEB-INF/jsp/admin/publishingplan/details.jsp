<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib  uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="master">
<pxkj:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		body {
			height: 100%;
		}
		.layui-form-select {
			width: 240px!important;
		}
	</style>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
<%-- 	<div style="padding: 10px 40px;background: #FFF;margin: 20px;" class="layui-anim layui-anim-upbit">
		<form id="carTagInfo" class="layui-form">
			<input type="hidden" name="perId" value="${perId }"/><!-- 期刊id -->
			<input type="hidden" name="cycle" value="${cycle }"/><!-- 出版周期 -->
			<input type="hidden" name="id" value="${id }"/>
			<div class="layui-form">
           		<div class="layui-form-item">
					<label class="layui-form-label">计划年份：</label>
					<div class="layui-input-inline">
						<input type="text" name="year" value="${contentMap.year }" class="layui-input" />
					</div>
				</div>
           		<div class="layui-form-item">
					<label class="layui-form-label">基准总期次：</label>
					<div class="layui-input-inline">
						<input type="text" name="totalPeriod" value="${contentMap.totalPeriod }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
			</div>
			<div style="text-align: center;margin-top: 40px;">
				<c:if test="${type=='add' }">
				<button class="layui-btn" lay-submit lay-filter="saveBtn">批量生成</button>
				</c:if>
				<c:if test="${type=='edit' }">
				<button class="layui-btn" lay-submit lay-filter="saveBtn">保存内容</button>
				</c:if>
			</div>
		</form>
	</div> --%>
	
	<div class="cbjh">
	    <div class="dkyx_jbxx">
	      <h3>期刊信息</h3>
	      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td>期刊名称:${name }</td>
		    <td align="right">出版周期：  
		    	<c:if test="${cycle==1 }">周刊</c:if>
		    	<c:if test="${cycle==2 }">半月刊</c:if>
		    	<c:if test="${cycle==3 }">月刊</c:if>
		    	<c:if test="${cycle==4 }">双月刊</c:if>
		    	<c:if test="${cycle==5 }">季刊</c:if>
		    </td>
		  </tr>
		 </table>
	   </div>
	   <form id="carTagInfo" class="layui-form">
	    <div class="dkcp_t1">
	    	<input type="hidden" name="perId" value="${perId }"/><!-- 期刊id -->
			<input type="hidden" name="cycle" value="${cycle }"/><!-- 出版周期 -->
	      <table width="100%" border="0" cellspacing="0" cellpadding="0">
	      <c:if test="${type=='edit' }">
		      <tr>
			    <td width="100"  align="right"><em>*</em>期次编号：</td>
			    <td  ><input type="text" style="width: 80px;" class="in1" name="id" value="${contentMap.id }" lay-verify="required" autocomplete="off" readonly="readonly"/></td>
			  </tr>
		  </c:if>
		  <tr>
		    <td width="100"  align="right"><em>*</em>计划年份：</td>
		    <td  ><input type="text" style="width: 80px;" class="in1" name="year" value="${contentMap.year }" lay-verify="required" autocomplete="off" ${type=='edit'?'readonly':'' }/></td>
		  </tr>
		  <tr>
		    <td align="right"><em>*</em>基准总期数：</td>
		    <td>总第 <input type="text" style="width: 30px;" class="in1 in2" name="totalPeriod" value="${contentMap.totalPeriod }" lay-verify="required" autocomplete="off" ${type=='edit'?'readonly':'' }/> 期      </td>
		  </tr>
		  <c:if test="${type=='edit' }">
		      <tr>
			    <td width="100"  align="right"><em>*</em>期次描述：</td>
			    <td  ><input type="text" style="width: 80px;" class="in1" name="describes" value="${contentMap.describes }" lay-verify="required" autocomplete="off" /></td>
			  </tr>
		  </c:if>
		</table>
	    </div>
	    <div class="dky_hf">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
	  
		  <tr>
		    <td>
		    	<c:if test="${type=='add' }">
				<button class="qr_biao" lay-submit lay-filter="saveBtn">批量生成</button>
				</c:if>
				<c:if test="${type=='edit' }">
				<button class="qr_biao" lay-submit lay-filter="upBtn">保存内容</button>
				</c:if>
		    </td>
		    <td><button class="qx_biao">保存内容</button></td>
		  </tr>
		</table>
	  </div>
	  </form>
  </div>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use('form', function(){
			var form = layui.form;
			form.on('submit(saveBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {icon: 1}, function(){
							var index = parent.layer.getFrameIndex(window.name);
							parent.layer.close(index);
						})
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/publishingplan/adds', postData, success, 'post', 'json');
				return false;
			});
			form.on('submit(upBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {icon: 1}, function(){
							var index = parent.layer.getFrameIndex(window.name);
							parent.layer.close(index);
						})
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/publishingplan/ups', postData, success, 'post', 'json');
				return false;
			});
		})
	</script>
</pxkj:Content>
</pxkj:ContentPage>