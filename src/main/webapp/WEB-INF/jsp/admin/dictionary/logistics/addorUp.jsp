<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
     <link rel="stylesheet" href="/manage/logistics/layui/css/layui.css" /> 
<link rel="stylesheet" href="/manage/zTree/css/metro.css" type="text/css"/>
<style>
ul.ztree{
    margin-top: 10px;
    border: 1px solid #ddd;
    background: #F4F7FD;
    min-width: 235px;
    height: 360px;
    overflow-y: scroll;
    overflow-x: auto;
    z-index:99999;
}
.layui-form-label{
	width: 150px;
	margin-left: 10px;
	text-align:left;
}
#bodyId{
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div id="bodyId" style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<!-- 物流地址添加或编辑 -->
				<input type="hidden" name="Id" value="${Id }" />
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>发货人姓名：</label>
					 <div class="layui-input-inline">
						<input type="text" name="userName" value="${userName }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>发货人昵称：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="${receiver }" name="receiver"  lay-verify="required"  class="layui-input">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>发货人电话：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="${phone }" name="phone"  lay-verify="required"  class="layui-input">
				    </div>
				</div>
				
			<div class="layui-form-item">
                <label class="layui-form-label"><span style="color:red;">*</span>选择地区</label>
                <div class="layui-input-inline">
                    <select name="provid" id="provid" lay-filter="provid" lay-verify="required">
                        <option value="">请选择省</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="cityid" id="cityid" lay-filter="cityid" lay-verify="required">
                        <option value="">请选择市</option>
                    </select>
                </div>
                <div class="layui-input-inline">
                    <select name="areaid" id="areaid" lay-filter="areaid" lay-verify="required">
                        <option value="">请选择县/区</option>
                    </select>
                </div>
            </div>
            
            <div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>详细地址：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="${detailedAddress }" name="detailedAddress"  lay-verify="required"  class="layui-input">
				    </div>
				</div>
				
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>是否默认</label>
				    <div class="layui-input-block">
				      <input type="radio" name="isDefault" value="1" title="是" ${isDefault==1?'checked':'' } checked>
				      <input type="radio" name="isDefault" value="0" title="否" ${isDefault==0?'checked':'' } >
				    </div>
				</div>
				<div class="layui-form-item" style="text-align: center;">
					<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
				</div>
			</form>
		</div>
	</div>
	<div id="menuContent" class="menuContent" data-target="parentId" style="display:none; position: absolute;z-index:9999">
		<ul id="tree" class="ztree" style="margin-top:0; min-width:200px; height: 300px;"></ul>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.all.min.js"></script>

    <script type="text/javascript" src="/manage/logistics/assets/data.js"></script>
    <script type="text/javascript" src="/manage/logistics/assets/province.js"></script>
  <script type="text/javascript">
        var defaults = {
            s1: 'provid',
            s2: 'cityid',
            s3: 'areaid',
            v1: '${province}',
            v2: '${city}',
            v3: '${county}'
        };
 
    </script>
	<script type="text/javascript">
	
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var form = layui.form;
			var laydate = layui.laydate;
			//监听首页展示
			form.on('switch(Isdisplay)', function(obj){
				if(obj.elem.checked){
					$("#weight").show();
				}else{
					$("#weight").hide();
				}
			});
			
			//监听提交
			form.on('submit(addEqBtn)', function(data){
				
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {
							icon: 1
						}, function() {
							var index = parent.layer.getFrameIndex(window.name);
							 parent.layer.close(index)
						});
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
						});
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/logistics/addOrUp', postData, success, 'post', 'json');
				return false;
			})
		})	
	</script>
</m:Content>
</m:ContentPage>