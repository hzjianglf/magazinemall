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
		<div class="layui-form-item">
		<form class="layui-form">
			<div class="layui-form-item">
			    <label class="layui-form-label">分类：</label>
			    <div class="layui-input-block">
			      <input type="checkbox" name="type" value="2" title="杂志" lay-skin="primary" lay-filter="Choice"/>
			      <input type="checkbox" name="type" value="1" title="期刊" lay-skin="primary" lay-filter="Choice"/>
			      <input type="checkbox" name="type" value="4" title="视频" lay-skin="primary" lay-filter="Choice"/>
			      <input type="checkbox" name="type" value="3" title="图书" lay-skin="primary" lay-filter="Choice"/>
			    </div>
			</div>
		</form>
		</div>
		<div class="layui-form-item">
			<div class="layui-inline">
				<div class="layui-input-inline">
					<input type="text" name="name" autocomplete="off" class="layui-input" placeholder="输入商品名称">
				</div>
			</div>
			<div class="layui-inline">
				<div class="layui-input-inline">
					<button class="layui-btn layui-btn-normal search" ><i class="layui-icon">&#xe615;</i>搜索</button>
				</div>
			</div>
		</div>
		
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="product" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
		<div class="layui-inline" style="margin-left: 40%;">
			<div class="layui-input-inline">
				<button class="layui-btn layui-btn-normal" style="width:100px;" id="Determine">确定</button>
			</div>
		</div>
	</div>
	<script type="text/html" id="picUrl">
		<img alt="" src="{{d.url}}" style="width:50px;height:50px;">
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/javascript">
		//父级隐藏域(商品id集)
		var values = '${values}';
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			//绑定表格
			var tableIns = table.render({
				id: 'product',
				elem: '#product',
				url: '/${applicationScope.adminprefix }/sharesales/selectProduct', //数据接口
				height:400,
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
							width: "10%"
						},
						{
							field: 'url',
							templet:'#picUrl',
							width: "20%"
						},
						{
							field: 'name',
							title: '商品名称',
							width: "35%"
						}, 
						{
							field: 'price',
							title: '价格',
							width: "35%"
						}
					]
				],
				done: function(){
					InitToolTips();
				}
			});
			//搜索，重置表格
			$('.search').click(function() { 
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						name: $('input[name="name"]').val(),
						productType: $('input[name="type"]:checked').val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//监听单选框事件
			form.on('checkbox(Choice)', function(data){
				var str = '';
				//获取当前勾选的分类
				$("input[name=type]:checked").each(function(){
					var v = $(this).val();
					str = str + v + ',';
				})
				tablereload(str);
			});
			//加载table
			function tablereload(type){
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						strs: type,
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
			//点击确定关闭当前弹窗并向父页面赋值
			$("#Determine").click(function(){
				//var arr = [{type:1,str:[1,2,3]},{type:2,str:[1,2,3]}];
				//获取复选框
				var checkStatus = table.checkStatus('product');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var ids1 = '';
				var ids2 = '';
				$.each(checkStatus.data, function(i){
					//获取当前选中的类型
					if(checkStatus.data[i].type == '1' || checkStatus.data[i].type == '2' || checkStatus.data[i].type == '3'){
						ids1 = ids1 + checkStatus.data[i].id + ',';
					}else{
						ids2 = ids2 + checkStatus.data[i].id + ',';
					}
				})
				var arr=[{type:1,str:ids1},{type:2,str:ids2}];
				parent.$("#"+values+"").val(JSON.stringify(arr));
				//关闭
				var index = parent.layer.getFrameIndex(window.name);
				parent.layer.close(index);
			})
		})
		
		
	</script>

</m:Content>
</m:ContentPage>
