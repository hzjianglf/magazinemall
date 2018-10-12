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
			<input type="hidden" id="classtype" value="${classtype }">
			<div class="layui-form-item">
			<div class="layui-inline">
				    <label class="layui-form-label">课程类别：</label>
			    	<div class="layui-input-inline">
						<select class="layui-input" name="type" id="type" >
							<c:forEach items="${list }" var="typeList">
								<option value="${typeList }">${typeList }</option>
							</c:forEach>
						</select>
					</div>
			    </div>
			    <div class="layui-inline" id="layerDemo">
						<div class="layui-input-inline">
							<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
						</div>
					</div>
		    </div>
	    </div>
		<%-- <div class="layui-form-item">
			<div class="layui-form-item">
				<div class="layui-inline">
				    <label class="layui-form-label">课程名称：</label>
				    <div class="layui-input-inline">
						<input type="text" name="name" id="name" autocomplete="off" class="layui-input" placeholder="输入商品名称">
					</div>
				</div>
				<div class="layui-inline">    
				    <label class="layui-form-label">专栏作家：</label>
			    	<div class="layui-input-inline">
						<input type="text" name="userName" id="userName" autocomplete="off"  class="layui-input" placeholder="输入作家名称">
					</div>
		    	</div>
				<div class="layui-inline">
				    <label class="layui-form-label">课程类别：</label>
			    	<div class="layui-input-inline">
						<select class="layui-input" name="type" id="type" >
							<option value="">全部</option>
							<c:forEach items="${list }" var="typeList">
								<option value="${typeList.id }">${typeList.name }</option>
							</c:forEach>
						</select>
					</div>
			    </div>
			    <div class="layui-inline" id="layerDemo">
					<div class="layui-input-inline">
						<button class="layui-btn layui-btn-normal" id="search"><i class="layui-icon">&#xe615;</i>搜索</button>
					</div>
				</div>
			</div>
		</div> --%>
			<table class="layui-table" lay-skin="line" id="product" lay-filter="tableContent"></table>
		<div id="demo7"></div>
		<div class="layui-inline" style="margin-left: 40%;">
			<div class="layui-input-inline">
				<button class="layui-btn layui-btn-normal" style="width:100px;" id="Determine">确定</button>
			</div>
		</div>
	</div>
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
				url: '/${applicationScope.adminprefix }/sumproduct/selectProduct?classtype='+$("#classtype").val(), //数据接口
				height:400,
				where: {},
				page: true, //开启分页
				limits: [10, 20, 30, 40, 50],
				cols: [
					[ //表头
						{
							type: 'checkbox',
						},
						{
							field: 'id',
							title: '刊物编号',
						},
						{
							field: 'name',
							title: '刊物名称',
						},
						{
							title: '年份',
							field: 'year'
						}
					]
				],
				done: function(res, curr, count){
				  var data=res.data;
				    $.each(data,function(i,v){
				    	var flag=hasChecked(v.ondemandId);
				    	
				    	if(flag){
				    		
				    		$("tr[data-index='"+i+"'] td:first div.layui-form-checkbox").click();
				    		
				    	}
				    	
				    })
			    }
			});
			
			//搜索，重置表格
			$('#search').click(function() { 
				console.log( $('select[name="type"]').find("option:selected").val());
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						year: $('select[name="type"]').find("option:selected").val(),
						num:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			});
			//点击确定关闭当前弹窗并向父页面赋值
			$("#Determine").click(function(){
				//获取复选框
				var checkStatus = table.checkStatus('product');
				if(checkStatus.data.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				var arr =[];
				$.each(checkStatus.data, function(i,v){
					arr.push({
						ondemandId:v.id,
						name:v.year+'年'+v.name,
						type:v.type,
						xprice:v.year,
					})
				})
				parent.$("#product").val(JSON.stringify(arr));
				//关闭
				var index = parent.layer.getFrameIndex(window.name);
				parent.layer.close(index);
			})
			
			
			function hasChecked(id){
				var ids='${ids}';
				var flag=false;
			    if(ids!=''){
			    	var arr=ids.split(",");
			    	if(arr!=null){
			    		$.each(arr,function(i,v){
			    			if(v!=''&&v==id){
			    				flag=true;
			    				return;
			    			}
			    		})
			    	}
			    }
			    return flag;
			}
		})
		
	</script>

</m:Content>
</m:ContentPage>
