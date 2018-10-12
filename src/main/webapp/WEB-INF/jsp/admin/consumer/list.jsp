<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
		.layui-a-blue{
			color:#1E9FFF;
			font-weight:700;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			用户管理
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">用户状态：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="isFreeze">
							<option value="">全部</option>
							<option value="0">禁用</option>
							<option value="1">启用</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">用户类型：</label>
					<div class="layui-input-inline">
						<select class="layui-input" name="userType">
							<option value="">全部</option>
							<option value="1">普通用户</option>
							<option value="2">专家</option>
						</select>
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="name" placeholder="用户名/真实姓名/手机号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">注册日期：</label>
					<div class="layui-input-inline" style="width: 234px;">
						<input type="text" name="registrationDate" id="registrationDate" readonly="readonly" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">openId：</label>
					<div class="layui-input-inline">
						<input type="text" name="openId" placeholder="openId" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<button class="layui-btn layui-btn-normal search"><i class="layui-icon">&#xe615;</i> 搜索</button>
				</div>
			</div>
		</div>
		<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
			<div class="layui-inline">
				<button class="layui-btn download"><i class="layui-icon">&#xe601;</i>导出EXCEL</button>
			</div>
			<div class="layui-inline">
				<button id="deleteId" class="layui-btn layui-btn-danger" ><i class="layui-icon">&#xe640;</i>批量删除</button>
			</div>	
			<div class="layui-inline">
				<button id="expertRegister" class="layui-btn layui-btn-expertRegister" ><i class="layui-icon">&#xe640;</i>注册专家</button>
			</div>	
			<div style="clear: both"></div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="consumer" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
		
		<div class="layui-tab layui-tab-brief" id="detailPanel" style="display: none;">
		  <ul class="layui-tab-title" id="tab_btn">
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/selUserMsg" class="layui-this">会员信息</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/selUserOrder">订单</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/selUserAccountJF">积分</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/selBalance">用户余额</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/interlocution">问答</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/attend">旁听</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/comment">评论</li>
		    <li data-taburl="/${applicationScope.adminprefix }/consumer/selReward">打赏</li>
		    <li style="float: right;font-weight:bold;font-size: 15px;" onclick="CloseIframe();">X</li>
		  </ul>
		  <iframe id="ifr_b" name="ifr_b" src="" frameborder="no" scrolling="no"
							width="100%" height="100%" allowtransparency="true"></iframe>
		</div> 
		
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<input type="hidden" name="userId" id="userId" value="{{ d.userId }}" />
		<input type="hidden" name="userType" id="userType" value="{{ d.userType }}" />
		{{# if (d.userId != null && d.userId != ''){ }}
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
			<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="deletes">删除</a>
		{{# }else { }}
			老数据
		{{# } }}
	</script>
	<!-- 用户类型 -->
	<script type="text/html" id="type">
		{{# if(d.userType == 1){ }}
			普通用户
		{{# }else{ }}
			专家
		{{# } }}
	</script>
	<!-- 是否推荐 -->
	<script type="text/html" id="tuijian">
		{{# if(d.IsRecommend == 1){ }}
			推荐
		{{# }else if(d.IsRecommend == 0){ }}
			不推荐
		{{# }else{ }}
			-
		{{# } }}
	</script>
	<script type="text/html" id="nickNameTem">
		<a href="javascript:void(0)" class="layui-a-blue" onclick="orderListItem('{{ (d.userId==''||d.userId==undefined)?0:d.userId }}','{{ (d.nickName==''||d.nickName==undefined)?d.telenumber:d.nickName }}','{{ d.openId==''||d.openId==undefined?'':d.openId }}')">
			{{# if(d.nickName != null && d.nickName != ''){ }}
				{{ d.nickName }}
			{{# }else{ }}
				{{ (d.telenumber == '' || d.telenumber == null)?'-':d.telenumber }}
			{{# } }}
		</a>
	</script>
	<script type="text/html" id="telenumberTem">
			{{# if(d.telenumber != null && d.telenumber != ''){ }}
				{{ d.telenumber }}
			{{# }else{ }}
				{{ (d.openId!=''&&d.openId!=null)?d.openId:'-' }}
			{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		var userId = 0;
		var yhType = 0;
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			var index = layer.load(1);
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
			//绑定表格
			var tableIns = table.render({
				id: 'consumer',
				elem: '#consumer',
				url: '/${applicationScope.adminprefix }/consumer/listData', //数据接口
				where: {},
				loading:true,
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
					  	{
							type: 'checkbox',
							width: "5%",
							fixed: 'left',
						}, 
						{
							field: 'nickName',
							title: '昵称',
							templet:'#nickNameTem',
							width: "10%",
							fixed: 'left',
						}, 
						{
							field: 'telenumber',
							title: '手机号码/openId',
							templet: '#telenumberTem',
							width: "18%"
						}, 
						{
							field: 'sex',
							title: '性别',
							width: "8%"
						}, 
						{
							field: 'accountJF',
							title: '积分',
							width: "10%"
						}, 
						{
							field: 'balance',
							title: '余额',
							width: "10%"
						}, 
						{
							field: 'registrationDate',
							title: '注册日期',
							width: "10%"
						}, 
						{
							field: 'isFreeze',
							title: '用户状态',
							width: "7%"
						}, 
						{
							field: 'userType',
							title: '用户类型',
							templet:'#type',
							width: "10%"
						},
						{
							field: 'IsRecommend',
							title: '是否推荐',
							templet:'#tuijian',
							width: "10%"
						},
						{
							field: 'noPurchaseUser',
							title: '免购买用户',
							width: "10%"
						},
						{
							title: '操作',
							width: "10%",
							fixed: 'right',
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					//行点击事件
					$('tbody').on('click',"td",function() {
						if($(this).index() > 9 || $(this).index() < 1){
							return ;
						}
						//获取当前行的id值
						var id = $(this).parents('tr').find('td:eq(10)').find('input[name="userId"]').val();
						//点击的用户类型
						var type = $(this).parents('tr').find('td:eq(10)').find('input[name="userType"]').val();
						if(id != null){
							$("#detailPanel").css("display", "block");
							userId=id;
							yhType=type;
							changepage();
						}
					})
					layer.close(index);
					//清空搜索数据
					
				}
			});
			//导出excel
			$(".download").click(function(){
				var name=$('input[name="name"]').val(),
				isFreeze=$('select[name="isFreeze"]').val(),
				registrationDate=$("#registrationDate").val(),
				userType=$("select[name='userType']").val();
				//选中的id checkbox
				var checkStatus = table.checkStatus('consumer');
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].userId + ',';
				})
				window.location.href="/${applicationScope.adminprefix }/consumer/download?name="+name+"&isFreeze="+isFreeze+"&registrationDate="+registrationDate+"&userType="+userType+"&ids="+ids;
			})
			//搜索，重置表格
			$('.search').click(function() { 
				index = layer.load(1);
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						name: $('input[name="name"]').val(),
						isFreeze: $('select[name="isFreeze"]').val(),
						registrationDate: $("#registrationDate").val(),
						userType:$("select[name='userType']").val(),
						openId:$('input[name="openId"]').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//监听操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var userId = data.userId;
				var userType = data.userType;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edits'){ 
					//编辑
			  		updateUser(userId,userType);
			  	}else if(layEvent === 'deletes'){
			  		//删除
			  		deletes(userId);
			  	}
			});
			//批量删除
			$('#deleteId').click(function(){
				var checkStatus = table.checkStatus('consumer');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids = '';
				$.each(checkStatus.data, function(i){
					ids = ids + checkStatus.data[i].userId + ',';
				})
				layer.confirm('确定将所选全部删除吗？', function(index){
					deleteid(ids,layer, tableIns);
				})
			});
			//批量删除
			function deleteid(ids,layer, tableIns){
				$.ajax({
					type : "POST",
					url : "/${applicationScope.adminprefix }/consumer/deleteids",
					async : false,
					data : {
						"ids" : ids
					},
					success : function(data) {
						tableIns.reload({
							where: {
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
						layer.alert(data.msg,{icon: 1});
					},
					error : function(data) {
						layer.alert(data.msg,{icon: 2});
					}
				});
			}
			//删除
			function deletes(userId){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/consumer/deletes",
						data : {"userId" : userId},
						success : function(data) {
							tableIns.reload({
								where: { //设定异步数据接口的额外参数，任意设
									num:Math.random()
								},
								page: {
									curr: 1 //重新从第 1 页开始
								}
							});
							if(data.success){
								layer.alert(data.msg,{icon: 1});
							}else{
								layer.alert(data.msg,{icon: 2});
							}
						},
						error : function(data) {
							layer.alert(data.msg,{icon: 2});
						}
					});
				})
			}
			//编辑/查看
			function updateUser(userId,userType){
				layer.open({
					type: 2,
					title: ['用户信息', 'font-size:18px;'],
					shadeClose: true,
					area: ['100%', "100%"],
					content: '/${applicationScope.adminprefix }/consumer/UpConsumer?userType='+userType+'&userId=' + userId ,
					success: function(layero, index) {
						layer.full(index);
						table.reload('consumer', {
							where: { //设定异步数据接口的额外参数，任意设
								name: $('input[name="name"]').val(),
								isFreeze: $('select[name="isFreeze"]').val(),
								registrationDate: $("#registrationDate").val(),
								userType:$("select[name='userType']").val(),
								num:Math.random()
							},
							page: {
								curr: 1 //重新从第 1 页开始
							}
						});
					},
					end: function() { //销毁后触发
						index = layer.load(1);
						table.reload('consumer', {
							page: {
								curr: 1
							}
						});
					}
				});
			}
			//页签切换
			$("#tab_btn > li[data-taburl]").on("click",function(){
				$("#tab_btn > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				changepage();
			});
			
			function changepage(){
				if(userId > 0){
					var url = $("#tab_btn > li.layui-this").data("taburl");
					$("#ifr_b").css("display","none");
					//loading(true);
					$("#ifr_b").attr("src",url+"?userId="+userId+"&userType="+yhType);
				}
			}
			$("#ifr_b").load(function(){
				loading(false);
				$("#ifr_b").css("display","block");
				setFrameHeight();
			});
			function setFrameHeight(){
				var iframe = document.getElementById("ifr_b");
				var height = $("#tab_btn > li.select_tab").data("height");
				if(height){
					iframe.height=$(window).height();
					$("#ifr_b").contents().find("#maincontent").css("padding-bottom",iframe.height+"px");
					$("#ifr_b").contents().find(".target_menu,.sidebar").height(iframe.height);
					return;
				}
				
				try{
					iframe.height=0;
					var bHeight = iframe.contentWindow.document.body.scrollHeight;
					var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
					var height = Math.max(bHeight, dHeight);
					iframe.height = height+150;
					
				}catch (ex){}
			}
			
			
			//注册专家
			$("#expertRegister").click(function(){
				openwindow("/consumer/expertRegister","注册专家",1000,600,false,callback);
			})
			window.callback = function (){
				index = layer.load(1);
				$('input[name="name"]').val(""),
				$('select[name="isFreeze"]').val(""),
				$("#registrationDate").val(""),
				$("select[name='userType']").val(""),
				$('input[name="openId"]').val(""),
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
		})
		function CloseIframe(){
			$("#detailPanel").hide();
		}
		function orderListItem( userId , userName , openId ){
			openwindow('/consumer/userOrderByUserId?userId='+userId+'&openId='+openId,userName+" - 历史订单",1150,650,false,false);
		}
	</script>
</m:Content>
</m:ContentPage>
