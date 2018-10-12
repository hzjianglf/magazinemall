<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-form-mid {
			margin-left: 10px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			代金券
		</blockquote>
		<div class="yw_cx">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">期刊编号：</label>
					<div class="layui-input-inline">
						<input type="text" name="numbers" id="numbers" placeholder="请输入期刊编号" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label">期刊名称：</label>
					<div class="layui-input-inline">
						<input type="text" name="names" id="names" placeholder="请输入期刊名称" autocomplete="off" class="layui-input">
					</div>
				</div>
				<div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
				<!-- <div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" style="background-color: #FF6633" id="reset"><i class="layui-icon">&#xe620;</i>重置</button>
					</div>
				</div> -->
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="buyerList" lay-filter="tableContent"></table>
		</div>
		<div id="demo7"></div>
		<div class="layui-form-item" style="text-align: center;">
			<button class="layui-btn" style="width: 50%;margin-top: 60px;" id="closeWindow" >确定</button>
		</div>
		
	</div>
	<script type="text/html" id="radioCheck">
  		<input type="radio" name="state" value="{{d.id}}" title="">
	</script>

</m:Content>
<m:Content contentPlaceHolderId="js">
	<script src="/manage/public/js/jquery.form.min.js"></script>
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			laydate.render({
				elem: '#startTime',
				/* range: true  区间时间选择*/
			});
			laydate.render({
				elem: '#endTime',
			});
			//绑定文章表格
			var type = '${type}';
			var searchText = '${searchText}';
			var tableIns = table.render({
				id: 'buyerList',
				elem: '#buyerList',
				url: '/${applicationScope.adminprefix }/coupon/getAllGoodsData?type='+type+'&searchText='+searchText, //数据接口
				cellMinWidth: 100,
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[	
						//表头
						{
							width: "5%",
							toolbar: '#radioCheck',
						},
						{
							field: 'name',
							title: '期刊名称',
							width: "31.5%",
						},
						{
							field: 'issn',
							title: 'ISSN',
							width: "31.5%",
						},
						{
							field: 'cycle',
							title: '出版周期',
							width: "31.5%",
						},
					]
				],
				done: function(res, curr, count){
					
				}
			});
			
			//监听锁定操作
			form.on('checkbox(freezeFilter)', function(obj){
				var id = obj.value;
				if(obj.elem.checked){
					unlockOrLock(id, 1);
				}else{
					unlockOrLock(id, 0);
				}
			});
			$("#closeWindow").click(function(){
				var ids = $(".layui-form :radio:checked").val();
				var name = $(".layui-form :radio:checked").parent(".layui-table-cell").parent("td").next("td").find("div").html();//next("td[data-field='name']").child("div").html()
				parent.$('#searchGoods').val(name);
				parent.$('#dingxiangId').val(ids);
				closewindow();
			})
			
			$('#search').click(function() { //搜索，重置表格
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						numbers:$('#numbers').val(),
						names:$('#names').val(),
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			})
			
			
		});
		
	</script>
</m:Content>
</m:ContentPage>
