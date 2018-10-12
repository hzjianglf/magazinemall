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
		<div class="yw_cx">
			<blockquote class="layui-elem-quote layui-bg-blue">
				友情链接管理
			</blockquote>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">链接名字：</label>
					<div class="layui-input-inline">
						<input type="text" name="LinkName" autocomplete="off" class="layui-input" placeholder="请输入链接名字">
					</div>
				</div>
				<div class="layui-inline">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
			<div class="layui-inline">
				<div class="layui-input-inline">
					<button name="addLink" class="layui-btn layui-btn-normal" >添加友情链接</button>
				</div>
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="linkDataList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
	</div>
	
	<!-- 操作按钮 -->
	<script type="text/html" id="caozuo">
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
		<a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="del">删除</a>
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//如期格式化
		function createTime(v){
			var date = new Date(v);
		    var y = date.getFullYear();
		    var m = date.getMonth()+1;
		    m = m<10?'0'+m:m;
		    var d = date.getDate();
		    d = d<10?("0"+d):d;
		    var h = date.getHours();
		    h = h<10?("0"+h):h;
		    var M = date.getMinutes();
		    M = M<10?("0"+M):M;
		    var str = y+"-"+m+"-"+d+" "+h+":"+M;
		    return str;
		}
		//JavaScript代码区域
		layui.use(['layer','table'], function(){
			var table = layui.table,
			layer = layui.layer;
			
			//绑定表格
			var tableIns = table.render({
				id: 'linkDataList',
				elem: '#linkDataList',
				url: '/${applicationScope.adminprefix }/link/list', //数据接口
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							field: 'LinkName',
							title: '站点名称'
						}, 
						{
							field: 'TelePhone',
							title: '联系电话'
						}, 
						{
							field: 'InputDate',
							title: '加入时间',
							templet :function (row){
		                        return createTime(row.InputDate);
		                        }
						},
						{
							field: 'Description',
							title: '描述'
						},
						{
							title: '操作',
							align: 'center',
							toolbar: '#caozuo'
						}
					]
				],
				done: function(){
					//获取数据结束后的操作
				}
			});
			
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						LinkName: $('input[name="LinkName"]').val(),
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
				var id = data.Id;
				
				var layEvent = obj.event; //获得 lay-event 对应的值（区分点击的按钮）
				if(layEvent === 'del'){//删除
					layer.confirm('真的删除行么', function(index){
						ajax("/${applicationScope.adminprefix }/link/delete", {Id:id } , function(data){
							tipinfo(data.msg);
							layer.close(index);
							reload();
						}, 'post', 'json');
					});
			  	}else if(layEvent === 'edit'){//专家分成明细
			  		openwindow("link/selFriByID?id="+id,"编辑",800,500,false,reload);
			  	}
			});
			//扣款弹窗
			$('button[name="addLink"]').click(function(){
				openwindow("link/add","添加",800,500,false,reload);
			});
			
			//表格加载事件
			function reload(){
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
		
	</script>

</m:Content>
</m:ContentPage>
