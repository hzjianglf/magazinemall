<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style type="text/css">
</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
	<div class="layui-inline">
		<label class="layui-form-label">充值单号:</label>
		<div class="layui-input-inline">
			<input type="text" value=${ orderNo} name="dateStart" disabled="disabled" id="dateStart" autocomplete="off" class="layui-input"  style="color:#ff6633">
		</div>
	</div>
	<br>
	<div class="layui-inline">
		<label class="layui-form-label">会员名称:</label>
		<div class="layui-input-inline">
			<input type="text" value=${ realName} name="dateStart" disabled="disabled" id="dateStart" autocomplete="off" class="layui-input"  style="color:#ff6633">
		</div>
	</div>	
	<br>
	<div class="layui-inline">
		<label class="layui-form-label">充值金额(元):</label>
		<div class="layui-input-inline">
			<input type="text" value=${ price} name="dateStart" disabled="disabled" id="dateStart" autocomplete="off" class="layui-input"  style="color:#ff6633">
		</div>
	</div>
	<br>
	<div class="layui-inline">
		<label class="layui-form-label">创建时间:</label>
		<div class="layui-input-inline">
			<input type="text" value=${ time} name="dateStart" disabled="disabled" id="dateStart" autocomplete="off" class="layui-input" placeholder="yyyy-MM-dd" style="color:#ff6633">
		</div>
	</div>	
	<br>
	<div class="layui-inline">
		<label class="layui-form-label">付款时间:</label>
		<div class="layui-input-inline">
			<input type="text"  disabled="disabled"   class="layui-input" value=${ payTimes}  style="color:#ff6633" >
		</div>
	</div>	
	<br>
	<div class="layui-inline">
		<label class="layui-form-label">支付方式:</label>
		<div class="layui-input-inline">
			<input type="text"  name="dateStart" disabled="disabled" id="dateStart" autocomplete="off" class="layui-input"  style="color:#ff6633" value=${ payMethodName} >
		</div>
	</div>	
	<br>
	<div class="layui-inline">
		<label class="layui-form-label">支付流水号:</label>
		<div class="layui-input-inline">
			<input type="text" name="dateStart" disabled="disabled" id="dateStart1" autocomplete="off" class="layui-input"   style="color:#ff6633" value=${ tradeNo}  >
		</div>
	</div>
	<br>
	<div class="layui-inline" >
		<label class="layui-form-label">支付状态:</label>
		<div class="layui-input-inline">
			<c:if test="${status!=1 }">
				<input type="text" value='未支付'  class="layui-input"  disabled="disabled" style="color:#ff6633">
			</c:if>
			<c:if test="${status==1 }">
				<input type="text" value='已支付'  disabled="disabled" class="layui-input"  style="color:#ff6633">
			</c:if>
		</div>
	</div>		
	<div class="layui-form-item" style="text-align: center;">
			<button class="layui-btn" style="width: 50%;margin-top: 10px;" id="closeWindow" onclick="setUpinfo();">关闭</button>
		</div>							
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script>
		function setUpinfo(){
			closewindow();
		}
		</script>
	</m:Content>

</m:ContentPage>