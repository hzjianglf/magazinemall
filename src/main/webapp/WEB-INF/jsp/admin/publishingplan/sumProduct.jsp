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
			<input type="hidden" name="name" value="${name }"><!-- 期刊名字 -->
	      <table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td width="100"  align="right"><em>*</em>计划年份：</td>
		    <td  ><input type="text" style="width: 80px;" class="in1" name="year" lay-verify="required" autocomplete="off" /></td>
		  </tr>
		  <tr>
		    <td align="right"><em>*</em>基准总期数：</td>
		    <td>总第 <input type="text" style="width: 50px;" class="in1 in2" name="totalPeriod"  lay-verify="required" autocomplete="off"  onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9]+/,'');}).call(this)"/> 期      </td>
		  </tr>
		  <tr>
		    <td width="100"  align="right"><em>*</em>纸质版价格：</td>
		    <td  ><input type="text" style="width: 150px;" class="in1" name="paperPrice"  lay-verify="required" autocomplete="off" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9 .]+/,'');}).call(this)"/></td>
		  </tr>
		  <tr>
		    <td width="100"  align="right"><em>*</em>电子版价格：</td>
		    <td  ><input type="text" style="width: 150px;" class="in1" name="ebookPrice"  lay-verify="required" autocomplete="off" onkeyup="(this.v=function(){this.value=this.value.replace(/[^0-9 .]+/,'');}).call(this)"/></td>
		  </tr>
		</table>
	    </div>
	    <div class="dky_hf">
	    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td>
				<button class="layui-btn layui-btn-warm qr_biao" lay-submit lay-filter="saveBtn">批量生成</button>
		    </td>
		    <td><button class="layui-btn layui-btn-warm qx_biao">取消</button></td>
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
				ajax('/${applicationScope.adminprefix }/sumproduct/addPub', postData, success, 'post', 'json');
				return false;
			});
			$(".qx_biao").click(function(){
				var index = parent.layer.getFrameIndex(window.name);
				parent.layer.close(index);
			})
		})
	</script>
</pxkj:Content>
</pxkj:ContentPage>