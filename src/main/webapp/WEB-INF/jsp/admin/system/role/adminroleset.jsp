<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<style>
body {
	background: #f1f0f7;
}
.yw_cx {
	background: #fff;
	border-radius: 3px;
	padding: 30px 10px;
}
.layui-form-item .layui-input-inline{ width:162px; margin-right:0}
.layui-form-label{ width:inherit}

.layui-laypage span{ background:none}
.layui-laypage .layui-laypage-spr { background:#fff}
/*..弹出框样式..*/
body .layui-layer-btn a{ width:120px; height:40px; line-height:40px;}
body .layui-layer-title{background-color:#01AAED; color:#fff; font-size:14px; }
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
<!-- 内容主体区域 -->
<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
  
<form action="">
  <div class="layui-form">
	  	<input type="hidden" value="${roleId }" id="roleId" />
		<c:forEach items="${authorityList }" var="li">
			<input type="hidden" value="${li.AuthorityID }" class="AuthorityID" />
		</c:forEach>
	  <table class="layui-table" >
	    <colgroup>
	      
	    </colgroup>
	    <thead>
	      <tr>
	        
	        <th><strong>模块</strong></th>
	        <th><strong>操作</strong></th>
	        
	      </tr> 
	    </thead>
	    <tbody>
	    <c:forEach items="${settings }" var="sett">
	      <tr>
	        <td align="right" width="120">${sett.key }
	        	<input type="checkbox" class="allCheck" lay-skin="primary" lay-filter="allChoose2" name="allchecker" value="${sett.key }">
	        </td>
	        <td>
	        	<c:forEach items="${sett.value }" var="val">
	        		<input type="checkbox" class="allCheck" lay-skin="primary" lay-filter="itemChoose" name="actions-1" value="${val }" data-role="${sett.key }">
	        		<span class="priv">${val }</span>
	        	</c:forEach>
	        </td>
	      </tr>
	     </c:forEach>
	      <tr>
	        <td align="right" width="120">全选
	        	<input type="checkbox" lay-skin="primary" lay-filter="allChoose" id="ckall" class="ckall">
	        </td>
	      </tr>
	    </tbody>
	  </table>
		<%-- <px:authorize setting="角色-角色权限">
			<button type="button" style="width: 82px; height: 34px; margin-left: 12px"
				onclick="addRoleAuthority();" class="col-lg-3 btn btn-warning">
					<i class="fa fa-save"></i>保存
			</button> 
		</px:authorize>--%>
		<button type="button" style="width: 82px; height: 34px; margin-left: 12px"
			onclick="addRoleAuthority();" class="col-lg-3 btn btn-warning">
				<i class="fa fa-save"></i>保存
		</button> 
	</div>
</form>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script>

		$(function() {
			window.onload=function(){
				var AuthorityArr = $(".AuthorityID");
				if (AuthorityArr.length > 0) {
					for (var i = 0; i < AuthorityArr.length; i++) {
						//给checkbox增加选中效果，以便在判定是否全选时使用
						$("input[type=checkbox][name='actions-1'][value='"+$(AuthorityArr[i]).val()+"']").attr("checked", true);
						//增加显示的选中效果，div层
						$("input[type=checkbox][name='actions-1'][value='"+$(AuthorityArr[i]).val()+"']").next().addClass('layui-form-checked','layui-form-checked');
					}
				}
				
				$("tbody > tr").each(function(){
					if($(this).find("td:eq(1)").find("input").length==$(this).find("td:eq(1)").find("input:checked").length){
						$(this).find("td:eq(0)").find("input").next().addClass('layui-form-checked','layui-form-checked');
					}
				});
			};
		});
		//保存角色权限
		function addRoleAuthority(){
			 var spCodesTemp = "";
			 var spCodesTemp2 = "";
		      $('input:checkbox[name=actions-1]:checked').each(function(i){
		  	   spCodesTemp2=$(this).data("role");
		       if(0==i){
		       		spCodesTemp = spCodesTemp2+"-"+$(this).val();
		       }else{
		       		spCodesTemp += (","+spCodesTemp2+"-"+$(this).val());
		       }
		      });
		      var roleId=$("#roleId").val();
		      $.ajax({  
		          type: "post",  
		          url: "/${applicationScope.adminprefix }/system/role/saveRoleAuthority",  
		          data:{"roleId":roleId,"spCodesTemp":spCodesTemp},  
		          dataType: "json",  
		          success: function(data){  
						if(data.success){
							window.location.reload();
						}else{
							alert(data.msg);
						}
		           
		          },  
		           error: function(){  
		            alert("系统异常，请联系管理员！");  
		           }  
		      });  
		}
		//JavaScript代码区域
		layui.use(['element', 'layer', 'form', 'laydate'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			//一些事件监听
			element.on('tab(demo)', function(data) {
				layer.msg('切换了：' + this.innerHTML);

			});

			laydate.render({
				elem: '#date'
			});

			//自定义验证规则
			form.verify({
				title: function(value) {
					if(value.length < 5) {
						return '标题至少得5个字符啊';
					}
				},
				pass: [/(.+){6,12}$/, '密码必须6到12位']
			});

			//监听提交
			form.on('submit(formDemo)', function(data) {
				layer.msg(JSON.stringify(data.field));
				return false;
			});
			//控制所有checkbox全选
			form.on('checkbox(allChoose)', function(data){
			    var child = $(data.elem).parents('table').find('tbody input[class="allCheck"]');
			    child.each(function(index, item){
			        item.checked = data.elem.checked;
			    });
			    form.render('checkbox');
			});
			//控制每一行checkbox全选
			form.on('checkbox(allChoose2)', function(data){
			    var child = $(data.elem).parents('td').siblings().find('input[name="actions-1"]');
			    child.each(function(index, item){
			        item.checked = data.elem.checked;
			    });
			    form.render('checkbox');
			});
			/* form.on('checkbox(itemChoose)',function(data){
			    var sib = $(data.elem).parents('table').find('tbody input[type="checkbox"]:checked').length;
			    var total = $(data.elem).parents('table').find('tbody input[type="checkbox"]').length;
			    if(sib == total){
			        $(data.elem).parents('table').find('thead input[type="checkbox"]').prop("checked",true);
			        form.render();
			    }else{
			        $(data.elem).parents('table').find('thead input[type="checkbox"]').prop("checked",false);
			        form.render();
			    }
			});  */

		});
	</script>
    <script>
		layui.use('layer', function(){ //独立版的layer无需执行这一句
		  var $ = layui.jquery, layer = layui.layer; //独立版的layer无需执行这一句
		  
		  //触发事件
		  var active = {
		    setTop: function(){
		      var that = this; 
		      //多窗口模式，层叠置顶
		      layer.open({
		        type: 2 //此处以iframe举例
		        ,title: '添加 -角色'
		        ,area: ['500px', '460px']
		        ,shade: 0.3
		        
		        ,offset:'auto'
		        ,content: ['添加角色.html','no']
		        ,btn: ['确定', '取消'] //只是为了演示
		        ,btnAlign: 'c'
		        
		        
		        
		      });
		    }
		    
		    
		    
		  };
		  
		  $('#layerDemo .layui-btn').on('click', function(){
		    var othis = $(this), method = othis.data('method');
		    active[method] ? active[method].call(this, othis) : '';
		  });
		  
		});
	</script>
</m:Content>
</m:ContentPage>