<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/zTree/css/metro.css"/>
	<link rel="stylesheet" href="/manage/zTree/css/demo.css"/>
	<link rel="stylesheet" href="/manage/zTree/css/zTreeStyle.css"/>
	<style type="text/css">
		html,body{
			height: 100%;
		}
		.left_wrap{
			float:left;
			width:15%;
		}
		.left_wrap,.jklr wrapper{
			display:inline-block;
			height:100%;
		}
		.layui-layout-admin .layui-body{
			bottom:0;
		}
		#treeDemo,.zTreeDemoBackground {
			width:100% !important;
			height:100% !important;
		}
		#treeDemo{
			border:none;
			padding:0;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div class="left_wrap">
		<div class="jklr wrapper animated fadeInRight">
			<div class="zTreeDemoBackground left">
				<ul id="treeDemo" class="ztree" style="margin-top: 15px;"></ul>
			</div>
		</div>
	</div>
	<iframe id="ifr" src="/${applicationScope.adminprefix }/content/contentList" frameborder="no" scrolling="auto" 
		width="85%" height="100%" allowtransparency="true" ></iframe>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/zTree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.core-3.4.js"></script>
	<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.excheck-3.4.js"></script>
	<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.exedit-3.4.js"></script>
	<script type="text/javascript">	
		var IDMark_A = "_a";
		var zTree;  
		var demoIframe;
		var zNodes ; 
		var setting = {
			view: {
				addDiyDom: addDiyDom,
				dblClickExpand: false,
				selectedMulti: false
			},
			
			edit: {
				enable: true,
				showRemoveBtn: false,
				showRenameBtn: false
			},
			data: {
				keep:{
					leaf:true, // 子节点属性锁,true就是不能将子节点变为父节点
					parent:true // 父节点属性锁,true就是不能将父节点变为子节点
					},
				simpleData: {
					enable: true
				}
			},
			callback: {
				onClick: onClick,
			}
		};	
		
		function onClick(event, treeId, treeNode){
			 var treeInfo = treeNode.id;
			 var treeType = treeNode.catType;
			 $('#ifr').attr('src','/${applicationScope.adminprefix }/content/contentList?catId='+treeInfo+"&type="+treeType);
		}
	    
		function setCheck() {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo"),
			isCopy = $("#copy").attr("checked"),
			isMove = $("#move").attr("checked"),
			prev = $("#prev").attr("checked"),
			inner = $("#inner").attr("checked"),
			next = $("#next").attr("checked");
			zTree.setting.edit.drag.isCopy = isCopy;
			zTree.setting.edit.drag.isMove = isMove;
			showCode(1, ['setting.edit.drag.isCopy = ' + isCopy, 'setting.edit.drag.isMove = ' + isMove]);
		
			zTree.setting.edit.drag.prev = prev;
			zTree.setting.edit.drag.inner = inner;
			zTree.setting.edit.drag.next = next;
			showCode(2, ['setting.edit.drag.prev = ' + prev, 'setting.edit.drag.inner = ' + inner, 'setting.edit.drag.next = ' + next]);
		}
		function showCode(id, str) {
			var code = $("#code" + id);
			code.empty();
			for (var i=0, l=str.length; i<l; i++) {
				code.append("<li>"+str[i]+"</li>");
			}
		}
		
		function addDiyDom(treeId, treeNode) {
			if (treeNode.parentNode && treeNode.parentNode.id!=2) return;
			var aObj = $("#" + treeNode.tId + IDMark_A);
			 var treeInfo = treeNode.id;
				var editStr = "";
				aObj.after(editStr);
		}
		function selectAll() {
			var zTree = $.fn.zTree.getZTreeObj("treeDemo");
			zTree.setting.edit.editNameSelectAll =  $("#selectAll").attr("checked");
		}
		
		var curStatus = "init", curAsyncCount = 0, goAsync = false; 
		function expandAll() {  
		    if (!check()) {  
		        return;  
		    }  
		    var zTree = $.fn.zTree.getZTreeObj("treeDemo");  
		    expandNodes(zTree.getNodes());  
		    if (!goAsync) {  
		        curStatus = "";  
		    }  
		}  
		function expandNodes(nodes) {  
		    if (!nodes) return;  
		    curStatus = "expand";  
		    var zTree = $.fn.zTree.getZTreeObj("treeDemo");  
		    for (var i=0, l=nodes.length; i<l; i++) {  
		        zTree.expandNode(nodes[i], true, false, false);//展开节点就会调用后台查询子节点  
		        if (nodes[i].isParent && nodes[i].zAsync) {  
		            expandNodes(nodes[i].children);//递归  
		        } else {  
		            goAsync = true;  
		        }  
		    }  
		}
		function check() {  
		    if (curAsyncCount > 0) {  
		        return false;  
		    }  
		    return true;  
		}  
		
		$(document).ready(function(){
			$("#treeDemo").height($(document).height()-80);
			$.ajax({
				type:'get',
				url:'/${applicationScope.adminprefix }/content/selectColumnList',
				cache:false,
				dataType:"json",
				async:true,
				success:function(data){
					var arr = [];
					$.each(data.list,function(n, item){
						arr.push({
							id:item.catId,
							pId:item.parentId,
							name:item.catName,
							catType:item.catType
						});
						
					});
					$.fn.zTree.init($("#treeDemo"), setting, arr);
					$("#prev").bind("change", {},setCheck);
					$("#inner").bind("change", {},setCheck);
					$("#next").bind("change", {},setCheck);
					$("#selectAll").bind("click", selectAll);
					 setTimeout(function(){
			                expandAll("treeDemo");  
			            },0);//延迟加载  
				},
				error:function(data){
					
				}
			});	
		});
	</script>
</m:Content>
</m:ContentPage>