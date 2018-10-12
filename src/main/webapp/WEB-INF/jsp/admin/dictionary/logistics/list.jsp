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
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			物流设置
		</blockquote>
		<div class="layui-tab layui-tab-brief">
		  <ul class="layui-tab-title" id="tab_list">
		    <li  class="layui-this"><a href="/${applicationScope.adminprefix }/logistics/list">发货地址</a></li>
		    <li ><a href="/${applicationScope.adminprefix }/logisticsTemplate/listFace">物流模板</a></li>
		  </ul>
		</div>
			<div class="layui-inline">
				<div class="layui-form-item" style="padding-top: 10px; margin-bottom: 0;">
					<div  class="layui-form-item">
						<button class="layui-btn add">
							<i class="layui-icon">&#xe61f;</i>添加地址
						</button>	
					</div>
				</div>
			</div>
			<div class="layui-form">
				<table class="layui-table" lay-skin="line" id="consumer" lay-filter="tableContent"></table>
			</div>
	</div>
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edits">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="deletes">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		var userId = 0;
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			laydate.render({
				elem: '#registrationDate',
				range: true
			});
			//绑定表格
			var tableIns = table.render({
				id: 'consumer',
				elem: '#consumer',
				url: '/${applicationScope.adminprefix }/logistics/listData', //数据接口
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
					  	{
							type: 'isDefault',
							field: 'isDefault',
							title: '是否默认',
							width: "15%"
						}, 
						{
							field: 'userName',
							title: '联系人',
							width: "15%"
						}, 
						{
							field: 'address',
							title: '详细地址',
							width: "28%"
						}, 
						{
							field: 'phone',
							title: '联系电话',
							width: "20%"
						}, 
						{
							title: '操作',
							width: "20%",
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			//添加地址
			$(".add").click(function(){
				openwindow("logistics/turnAdd?number=Math.random()","添加-地址",1000,600,false,callback);
			})
			function callback(){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			//监听操作
			table.on('tool(tableContent)', function(obj){
				var data = obj.data; //获得当前行数据
				var Id = data.Id;
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'edits'){ 
					//编辑
					selMsg(Id);
			  	}else if(layEvent === 'deletes'){
			  		//删除
			  		deletes(Id);
			  	}
			});
			
			function selMsg(Id){
				openwindow("logistics/turnAdd?id="+Id+"&number=Math.random()","添加-地址",1000,600,true,callback);
			}
			//删除
			function deletes(Id){
				layer.confirm('确定删除吗？', {icon: 7}, function(){
					$.ajax({
						type : "POST",
						url : "/${applicationScope.adminprefix }/logistics/deletes",
						data : {"Id" : Id},
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
			/* $("#tab_list > li[data-type]").on("click",function(){
				$("#tab_list > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				//获取状态值
				var type = $("#tab_list > li.layui-this").data("type");
				//重新加载表格
				tableIns.reload({
					where: {
						type:type,
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
				
			}); */
			//页签切换
			/* $("#tab_btn > li[data-taburl]").on("click",function(){
				$("#tab_btn > li.layui-this").removeClass("layui-this");
				$(this).addClass("layui-this");
				changepage();
			}); */
			
			/* function changepage(){
				if(userId > 0){
					var url = $("#tab_btn > li.layui-this").data("taburl");
					//$("#ifr_b").css("display","none");
					//loading(true);
					$("#ifr_b").attr("src",url+"?userId="+userId);
				}
			} */
			/* $("#ifr_b").load(function(){
				loading(false);
				$("#ifr_b").css("display","block");
				setFrameHeight();
			}); */
			/* function setFrameHeight(){
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
			} */
			
		})
		
	</script>
</m:Content>
</m:ContentPage>
