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
	.layui-table th{ font-weight:700; background:#01AAED; color:#fff; text-align:center;}
	.layui-table td{ text-align:center;}
	.layui-laypage span{ background:none}
	.layui-laypage .layui-laypage-spr { background:#fff}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit"/>
		<blockquote class="layui-elem-quote layui-bg-blue">
			${userType==0?'管理员管理':userType==1?'会员管理':'业务员管理' }
		</blockquote>
	  <div class="yw_cx">
	    <!-- <form class="layui-form" action=""> -->
	    <div class="layui-form-item">
	      <div class="layui-inline">
	        <label class="layui-form-label">用户：</label>
	        <div class="layui-input-inline">
	          <input type="text" name="userName" id="userName" placeholder="" autocomplete="off" class="layui-input">
	        </div>
	      </div>
	      <div class="layui-inline">
	        <label class="layui-form-label">角色：</label>
	        <div class="layui-input-inline">
	          <input type="text" name="roleName" id="roleName" autocomplete="off" class="layui-input">
	        </div>
	      </div>
	      <div class="layui-inline">
	      	<input type="hidden" id="userType" value="${userType }" />
	         <button class="layui-btn layui-btn-normal search" lay-submit lay-filter="formDemo">搜索</button>
	      </div>
	    </div>
	   <!--  </form> -->
	  </div>
	  <!-- <form class="layui-form" action=""> -->
	   <div class="layui-form-item" style=" padding-top:10px; margin-bottom:0;">
	     <div class="layui-inline">
	         <button class="layui-btn" id="add" lay-filter="add"><i class="layui-icon">&#xe608;</i>新增</button>
	      </div>
	     <!--  <div class="layui-inline">
	         <button class="layui-btn layui-btn-warm" lay-submit lay-filter="formDemo">导出</button>
	      </div> -->
	      <div style=" clear:both"></div>
	    </div>
	  <!-- </form> -->
	  <div class="layui-form">
		  <table class="layui-table" lay-filter="equipment" lay-data="{url:'/${applicationScope.adminprefix }/system/user/adminlistData?userType=${userType }', page:true, id:'adminList_Id'}">
		    <thead>
		      <tr>
		        <th lay-data="{field:'userId', sort: true}">编号</th>
		        <th lay-data="{field:'userName', sort: true}">用户名</th>
		        <th lay-data="{field:'realname', sort: true}">真实姓名</th>
		        <th lay-data="{field:'sex', sort: true}">性别</th>
		        <th lay-data="{field:'email', sort: true}">邮箱</th>
		        <th lay-data="{field:'telenumber', sort: true}">手机号码</th>
		        <th lay-data="{field:'registrationDate', sort: true}">注册日期</th>
		        <th lay-data="{field:'roleName', sort: true}">所属角色</th>
		        <th lay-data="{field:'userId', sort: true, toolbar: '#barDemo'}">操作</th>
		      </tr> 
		    </thead>
		  </table>
	  </div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/html" id="barDemo">
		<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<script type="text/html" id="titleTpl">
		{{# if(Number(d.amount) >= Number(d.warn)){ }} {{d.amount}}{{# } else { }}
		<a style="color: #FF5722;" class="layui-table-link">{{d.amount}}</a> {{# } }}
	</script>
	<script type="text/javascript">
		layui.use(['layer', 'table'], function(){
			var layer = layui.layer;
			var table = layui.table;
			var userType = $("#userType").val();
			table.init('equipment');
			
			//搜索
			$('.search').click(function() { //搜索，重置表格
					table.reload('adminList_Id', {
						where: {
							userName: $("#userName").val(),
							roleName: $("#roleName").val()
						}
						,height: 315
						,page: {
							curr: 1
						}
					});
			})

			
			//新增
			$("#add").click(function() {
				layer.open({
					type: 2,
					title: ['用户信息', 'font-size:18px;'],
					shadeClose: true,
					area: ['100%', '100%'],
					content: '/${applicationScope.adminprefix }/system/user/adds?userType='+userType,
					success: function(layero, index) {
						console.log(layero, index);
						//layer.iframeAuto(index);
						layer.full(index);
					},
					end: function() { //销毁后触发
						table.reload('adminList_Id', {
							height: 315
							,page: {
								curr: 1
							}
						});
					}
				});
			})
			
			//监听工具条
			table.on('tool(equipment)', function(obj) { //注：tool是工具条事件名，test是table原始容器的属性 lay-filter="对应的值"
				var data = obj.data; //获得当前行数据
				var userId = data.userId;
				var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
				var tr = obj.tr; //获得当前行 tr 的DOM对象
				if(layEvent === 'edit') {//修改
					layer.open({
						type: 2,
						title: ['用户信息', 'font-size:18px;'],
						shadeClose: true,
						area: ['100%', "100%"],
						content: '/${applicationScope.adminprefix }/system/user/adminUpdate?userType='+userType+'&userId=' + userId ,
						success: function(layero, index) {
							console.log(layero, index);
							//layer.iframeAuto(index);
							layer.full(index);
						},
						end: function() { //销毁后触发
							table.reload('adminList_Id', {
								height: 315
								,page: {
									curr: 1
								}
							});
						}
					});
				}else if(layEvent === 'del') {//删除
					layer.confirm('是否要删除?', function(index) {
						var success = function(response) {
							console.log('删除：' + JSON.stringify(response));
							var result = JSON.parse(response);
							if(result.success) {
								layer.msg(result.msg);
								table.reload('adminList_Id', {
									height: 315
									,page: {
										curr: 1
									}
								});
							} else {
								layer.alert(result.msg, {
									icon: 2
								});
							}
						}
						var AjaxData = {
							userId: userId,
							r: Math.random()

						}
						ajax("/${applicationScope.adminprefix }/system/user/delAdminUser", AjaxData, success);

					}, function(index) {
						//layer.msg('确认1');
					});
				}
			});
			
			
		});
		
	</script>
</m:Content>
</m:ContentPage>
