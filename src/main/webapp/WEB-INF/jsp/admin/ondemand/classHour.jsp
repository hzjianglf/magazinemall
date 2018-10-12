<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<link href="/manage/public/ondemand/css/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/ondemand/css/index.css" rel="stylesheet" type="text/css" />
	
	<link rel="stylesheet" href="/manage/zTree/css/zTreeStyle.css" />
	<link href="/manage/zTree/css/font-awesome.min.css" rel="stylesheet">
	<link href="/manage/zTree/css/templet_tree.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
		.uploadBox{
			width: 100%;
    		height: 500px;
    		text-align: center;
    		overflow-y: auto;
    		overflow-x: hidden;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
<div class="kc_top">
	<img src="${(empty tMsg.userUrl)?'/manage/public/ondemand/images/1.png':tMsg.userUrl }"  class="tx_img" />
	<P ><span class="p1">课程：${findById.name }</span><br /><span class="p2">教师：${tMsg.realname == null?tMsg.nickName:tMsg.realname }</span></P>
	<c:if test="${findById.status=='-1' }"><span class="wfb_biao"><span>未发布</span></span></c:if>
</div> 
<div class="kc_left">
	<ul>
		<li>
			<h3>课程信息</h3>
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=1&ondemandId=${findById.ondemandId }&classtype=${classtype}">基本信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=2&ondemandId=${findById.ondemandId }&classtype=${classtype}">详细信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=3&ondemandId=${findById.ondemandId }&classtype=${classtype}">课程图片</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=4&ondemandId=${findById.ondemandId }&classtype=${classtype}" class="on">课时管理</a> 
			<!-- <a href="#">文件管理</a>  -->
		</li>
		<li>
		    <h3>课程设置</h3>
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=6&ondemandId=${findById.ondemandId }&classtype=${classtype}">价格设置</a> 
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=7&ondemandId=${findById.ondemandId }&classtype=${classtype}">授课教师</a> 
		</li>
	<!-- 	<li>
		    <h3>课程运营</h3>
		    <a href="#">课程学习数据</a> 
		    <a href="#">课程订单查询</a> 
		</li> -->
	</ul>
</div>
<div class="kc_center">
	<div class="kc_nr">
		<h2>课时管理
			<c:if test="${classtype=='0' }">
				<select name="chapter" id="chapter" style="float: right;height: 30px;margin-right: 25px;">
					<option value="">添加  章节</option>
			        <option value="0">添加章</option>
			        <option value="1">添加节</option>
			    </select>
		    </c:if>
			<button class="layui-btn layui-btn-primary layui-btn-sm" style="float: right;margin-right: 30px;" id="addHour">
				<i class="layui-icon">&#xe654;</i>课时添加
			</button>
		</h2>
		<form>
		<input type="hidden" name="release" id="release" />
		<input type="hidden" name="ondemandId" id="ondemandId" value="${findById.ondemandId }" />
		<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<div class="uploadBox">
			<ul id="zuzhi_jiagou" class="ztree"></ul>
		</div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  	<tr>
			    <td align="right">
			    	<input type="button" id="up" value="上一步" class="xyb_biao" />
			    	<input type="button" value="存草稿" class="czg_biao" lay-submit lay-filter="draft"/>
			    	<input type="button" lay-submit lay-filter="next" value="下一步" class="xyb_biao" />
			    </td>
		  	</tr>
		</table>
		</form>
	</div>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/zTree/js/templet_tree.js"></script>
	<script src="/manage/zTree/js/jquery.ztree.core.js"></script>
	<script src="/manage/zTree/js/jquery.ztree.excheck.js"></script>
	<script src="/manage/zTree/js/jquery.ztree.exedit.js"></script>
	<script type="text/javascript">
		//下一步,保存信息
		layui.use(['form','layer'], function(){
		var form = layui.form;
		var layer = layui.layer;
		//监听提交
		form.on('submit(next)', function(data) {
			var success = function(response){
				if(response.success){
					var classtype = $("#classtype").val();
					window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+response.ondemandId+'&page=6'+'&classtype='+classtype;
				}else{
					layer.alert(response.msg, {icon: 2}, function(){
						layer.closeAll();
					})
				}
			}
			var postData = $(data.form).serialize();
			ajax('/${applicationScope.adminprefix }/ondemand/upBasic', postData, success, 'post', 'json');
			return false;
		});
		//监听存草稿按键
		form.on('submit(draft)', function(data){
			$("#release").val('0');
			var success = function(response){
				if(response.success){
					var classtype = $("#classtype").val();
					window.location.href = '/${applicationScope.adminprefix }/ondemand/list?classtype='+classtype;
				}else{
					layer.alert(response.msg, {icon: 2}, function(){
						layer.closeAll();
					})
				}
			}
			var postData = $(data.form).serialize();
			ajax('/${applicationScope.adminprefix }/ondemand/upBasic', postData, success, 'post', 'json');
			return false;
		});
		//上一步
		$("#up").click(function(){
			var ondemandId = $("#ondemandId").val();
			var classtype = $("#classtype").val();
			window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+ondemandId+'&page=3'+'&classtype='+classtype;
		});
		//添加章节
		$("#chapter").change(function(){
			if($("#chapter option:selected").val() === ''){
				return ;
			}
			//获取点击章或节
			var title = $("#chapter option:selected").text();
			var ondemandId = $("#ondemandId").val();
			layuiIframe(layer, title, '/${applicationScope.adminprefix }/ondemand/addchapter?ondemandId='+ondemandId+'&title='+title, '/${applicationScope.adminprefix }/ondemand/insertChapter');
		})
		//添加课时
		$("#addHour").click(function(){
			var ondemandId = $("#ondemandId").val();
			var classtype = $("#classtype").val();
			var kid = null;
			addOReditHour(ondemandId,kid,null,classtype);
		})
	})
	//添加章节
	var layuiIframe = function(layer, title, contentUrl, submitUrl){
			layer.open({
				type: 2,
				title: title,
				area: ['500px', '360px'],
				shade: 0.3,
				offset:'auto',
				content: [contentUrl,'no'],
				btn: ['确定', '取消'],
				btnAlign: 'c',
				yes: function(index, layero){
					var form = layer.getChildFrame('form', index);
					var data = form.serialize();
					$.ajax({
						type: "post",
						url: submitUrl,
						data: data,
						dataType: "json",
						success: function(data){
							if(data.success){
								layer.msg(data.msg, {icon: 1});
								//刷新目录
								treeInit();
							}else{
								layer.msg(data.msg, {icon: 2});
							}
						},
						error: function(){
							layer.msg('未知错误', {icon: 2});
						}
					})
					layer.close(index);
				}
			});
		}
		//添加或编辑课时
		function addOReditHour(ondemandId,kid,id,classtype){
			openwindow('/ondemand/toaddclassHour?ondemandId='+ondemandId+'&kid='+kid+'&parentId='+id+'&classtype='+classtype,"添加/编辑课时",1800,800,false,null);
			/* layer.open({
				type: 2,
				title: ['新增分组', 'font-size:18px;'],
				shadeClose: true,
				area: ['80%', '80%'],
				content: '/${applicationScope.adminprefix }/ondemand/toaddclassHour?ondemandId='+ondemandId+'&kid='+kid+'&parentId='+id+'&classtype='+classtype,
				success: function(layero, index) {
					layer.full(index);
				},
				end: function() { //销毁后触发
					
				}
			}); */
		}
		//加载事件
		$(document).ready(function(){
			treeInit();
		});
		//加载树ztree
		function treeInit(){
			var ondemandId = $("#ondemandId").val();
			$.ajax({
				type:'post',
				data:{"ondemandId":ondemandId},
				url:'/${applicationScope.adminprefix }/ondemand/selectTree',
				cache:false,
				dataType:"json",
				async:true,
				success:function(data){
					$.fn.zTree.init($("#zuzhi_jiagou"), setting, data.treeList);
					var treeObj = $.fn.zTree.getZTreeObj("zuzhi_jiagou");
					treeObj.expandAll(true);
				},
				error:function(data){
					
				}
			});	
		}
		//添加
		function addDom(id,pId,kid){
			var ondemandId = $("#ondemandId").val();
			var classtype = $("#classtype").val();
			var title = "";
			if(pId > 0){//子节点
				addOReditHour(ondemandId,kid,id,classtype);
			}else{
				//父节点
				title = "添加节";
				layuiIframe(layer, "编辑/"+title, '/${applicationScope.adminprefix }/ondemand/addchapter?chapterId='+id+'&title='+title+'&pId='+pId+'&ondemandId='+ondemandId, '/${applicationScope.adminprefix }/ondemand/insertChapter');
			}
		}
		/*编辑*/
		function EditNode(id,pId,kid) {
			var title = "";
			if(pId > 0){
				title = "添加节";
			}else{
				title = "添加章"
			}
			var ondemandId = $("#ondemandId").val();
			//判断是编辑章节还是课时
			if(kid == null || kid == '' || kid == 'undefined'){
				layuiIframe(layer, "编辑/"+title, '/${applicationScope.adminprefix }/ondemand/addchapter?chapterId='+id+'&title='+title+'&pId='+pId, '/${applicationScope.adminprefix }/ondemand/insertChapter');
			}else{
				var classtype = $("#classtype").val();
				addOReditHour(ondemandId,kid,id,classtype);
			}
			
		}
		/*删除*/
		function DeletNode(id,kid) {
			//判断点击的是章节还是课时
			var title = '';
			if(kid == null || kid == '' || kid == 'undefined'){
				title = '章节';
			}else{
				title = '课时';
			}
			layer.confirm('确定删除该'+title+'吗？', {icon: 7}, function(){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/ondemand/delChapter",
					data : {"chapterId" : id,"hourId":kid},
					success : function(data) {
						if(data.success){
							layer.msg(data.msg, {icon: 1});
							treeInit();
						}else{
							layer.msg(data.msg,{icon: 2});
						}
					},
					error : function(data) {
						layer.msg(data.msg,{icon: 2});
					}
				});
			})
		}
		//同一父级节点下的拖拽
		function upOrderIndex(dragId,fallId,KId){
			$.ajax({
				type : "POST",
				url : "/${applicationScope.adminprefix }/ondemand/upOrderIndex",
				data : {"dragId" : dragId,"fallId":fallId,"KId":KId},
				success : function(data) {
					treeInit();
				},
				error : function(data) {
					layer.msg("未知错误!",{icon: 2});
				}
			})
		}
		//不是同一父节点下的拖拽
		function upParentId(dragId,parentId,KId,type){
			$.ajax({
				type : "POST",
				url : "/${applicationScope.adminprefix }/ondemand/upParentId",
				data : {"dragId" : dragId,"parentId":parentId,"KId":KId,"type":type},
				success : function(data) {
					treeInit();
				},
				error : function(data) {
					layer.msg("未知错误!",{icon: 2});
				}
			})
		}
	</script>
</m:Content>
</m:ContentPage>
