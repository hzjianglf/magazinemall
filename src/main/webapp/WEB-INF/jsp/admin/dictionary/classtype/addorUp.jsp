<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
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
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<!-- 类型 -->
				<input type="hidden" name="type" id="type" value="${type }" />
				<input type="hidden" name="id" value="${id }" />
            	<div class="layui-form-item">
					<label class="layui-form-label">类别编号：</label>
					<div class="layui-input-block">
						<input type="text" name="" value="${reqMap.id }"  autocomplete="off" class="layui-input" placeholder="保存时系统自动生成" disabled="disabled"/>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">上级类别：</label>
				    <div class="layui-input-block">
				    	<input type="hidden" name="parentId" id="parentId" value="${(empty reqMap.parentId)?'0':reqMap.parentId }">
						<input type="text" value="${reqMap.parentName }" style="width:80%;float:left;" name="parentIdShow" onclick="showMenu('parentId')" disabled='disabled' class="layui-input layui-unselect" id="parentIdShow"/>
						<button type="button" class="layui-btn" style="width:20%;float:left;" onclick="showMenu('parentId')">选择</button>
				    </div>
				    <!-- 层级 -->
				    <input type="hidden" name="hierarchy" id="hierarchy" value="${(empty reqMap.hierarchy)?'1':reqMap.hierarchy }" />
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">类别名称：</label>
					<div class="layui-input-block">
						<input type="text" name="name" value="${reqMap.name }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<c:if test="${type!='2' }">
					<div class="layui-form-item">
					    <label class="layui-form-label">首页展示：</label>
					    <div class="layui-input-block">
					      <input type="checkbox" name="Isdisplay" lay-filter="Isdisplay" lay-skin="switch" lay-text="是|否" ${reqMap.Isdisplay==1?'checked':'' }>
					      <input type="hidden" id="Isdisplay" value="${reqMap.Isdisplay }" />
					    </div>
					</div>
				</c:if>
				<div id="weight" class="layui-form-item" style="display: none;">
					<label class="layui-form-label">${type=='1'?'展示权重':'排序号' }：</label>
					<div class="layui-input-block">
						<input type="text" name="orderIndex" value="${reqMap.orderIndex }" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">状态：</label>
					<div class="layui-input-block">
						<select name="status" lay-verify="required">
							<option value="">无</option>
							<option value="1" ${reqMap.status==1?'selected':'' }>启用</option>
							<option value="0" ${reqMap.status==0?'selected':'' }>禁用</option>
						</select>
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
	<script type="text/javascript">
		$(function(){
			//类型
			var type = '${type}';
			if(type=='1'){
				var v = $("#Isdisplay").val();
				if(v=='0'){
					$("#weight").hide();
				}else if(v=='1'){
					$("#weight").show();
				}
			}else{
				$("#weight").show();
			}
			tree();
		});
		layui.use('form', function(){
			var form = layui.form;
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
				ajax('/${applicationScope.adminprefix }/classtype/addOrUp', postData, success, 'post', 'json');
				return false;
			})
		})
		
		function tree(){
			var setting = {
				check: {
					enable: false
				},
				view: {
					dblClickExpand: false
				},
				data:{
					 simpleData: {
				         enable: true,
				         idKey: "id",
				         pidKey: "pId",
				         cengji: "hierarchy",
				         rootPId: "0"
				     }
				},
				callback: {
					onDblClick: onDblClick
				}
			};
			function onDblClick(event, treeId, treeNode) {
				var zTree = $.fn.zTree.getZTreeObj("tree");
				var nodes = zTree.getSelectedNodes();
				if(nodes.length>0 && Number(nodes[0].id)) {
					$("#parentId").val(nodes[0].id);
					$("#parentIdShow").val(nodes[0].name);
					$("#hierarchy").val(nodes[0].hierarchy+1);
					hideMenu();
				}
				return false;
			}
			var zNodes=${list};
			$.fn.zTree.init($("#tree"), setting,zNodes);
			var treeObj = $.fn.zTree.getZTreeObj("tree"); 
			treeObj.expandAll(true); 
		}
		var currentShowMenu='';
		function showMenu(t) {
			currentShowMenu=t;
			
			var obj = $("#"+t+"Show");
			var objOffset = obj.offset();
			$("div[data-target='"+t+"']:first").css({left:objOffset.left + "px", top:objOffset.top + obj.outerHeight() + "px"}).slideDown("fast");
			$("body").bind("mousedown", onBodyDown);
		}
		function hideMenu() {
			$("div[data-target='"+currentShowMenu+"']:first").fadeOut("fast");
			$("body").unbind("mousedown", onBodyDown);
		}
		function onBodyDown(event) {
			var id = $("div[data-target='"+currentShowMenu+"']:first").attr("id");
			if (!(event.target.id == (currentShowMenu+"Show") || event.target.id == id || $(event.target).parents("#"+id).length>0)) {
				hideMenu();
			}
		}
	</script>
</m:Content>
</m:ContentPage>