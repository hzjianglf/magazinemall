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
			      <input type="checkbox" name="type" value="1" title="期刊" lay-skin="primary" lay-filter="Choice"/>
			      <input type="checkbox" name="type" value="2" title="电子期刊" lay-skin="primary" lay-filter="Choice"/>
			      <input type="checkbox" name="type" value="3" title="点播课程" lay-skin="primary" lay-filter="Choice"/>
			      <input type="checkbox" name="type" value="4" title="直播课程" lay-skin="primary" lay-filter="Choice"/>
			       <input type="checkbox" name="type" value="5" title="商品" lay-skin="primary" lay-filter="Choice"/>
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
	<script type="text/html" id="nameTemp">
		{{d.name}}
		{{# if(d.type==1 || d.type==2){ }}
			/<font color="red"> {{ d.year}}</font>
		{{# } }}
	</script>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/js/ToolTip.js"></script>
	<script type="text/html" id="type">
		{{# if(d.type==1){ }}
			期刊
		{{# }else if(d.type==2){ }}
			电子期刊
		{{# }else if(d.type==3){ }}
			点播课程
		{{# }else if(d.type==4){ }}
			直播课程
		{{# } }}
	</script>
	<script type="text/javascript">
		var tableData=[];
		var checkedData=[];
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
				url: '/${applicationScope.adminprefix }/buyJisong/selectProduct', //数据接口
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
							title: '商品图片',
							width: "20%"
						},
						{
							title: '商品名称',
							width: "35%",
							templet:'#nameTemp'
						},
						{
							field: 'type',
							title: '商品类型',
							templet:'#type',
							width: "15%"
						},
						{
							field: 'price',
							title: '价格',
							width: "20%"
						}
					]
				],
				done: function(res, curr, count){
				    var data=res.data;
				    tableData=data;
				    $.each(data,function(i,v){
				    	var flag=hasChecked(v.id,v.type);
				    	
				    	if(flag){
				    		
				    		$("tr[data-index='"+i+"'] td:first div.layui-form-checkbox").click();
				    		checkDataChange(v,true);
				    	}
				    	
				    })
				  }
			});
			table.on('checkbox(tableContent)', function(obj){
				
				var type=obj.type;
				var checked=obj.checked;

				var dataArr=[];
				if(type=="one"){
					dataArr.push(obj.data);
				}else if(type=="all"){
					if(checked){
						 var checkStatus = table.checkStatus('product')
					     dataArr = checkStatus.data;
					}else{
						dataArr=tableData;
					}
				}
				checkBoxChange(dataArr,checked);
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
				
				if(checkedData.length == 0){
					layer.msg('请至少选择一项', {icon: 7});
					return false;
				}
				parent.$("#${values}").val(JSON.stringify(checkedData));
				//关闭
				var index = parent.layer.getFrameIndex(window.name);
				parent.layer.close(index);
			})
			
			var select_Arr=[];
			var ids='${ids}';
			if(ids!=''){
				select_Arr=ids.split(",");
			}
			function checkBoxChange(dataArr,checked){
			    if(dataArr.length>0){
			    	$.each(dataArr,function(i,v){
			    		var data=v;
						var item=data.type+"|"+data.id;
						if(checked){
							 if(select_Arr.indexOf(item)==-1){
								 select_Arr.push(item);
								 checkDataChange(v,true);
							 }
						 }else{
							var index=select_Arr.indexOf(item);
							 if(index!=-1){
								 select_Arr.splice(index,1);
								 checkDataChange(v,false);
							 }
						}
			    	})
			    }
			}
			function checkDataChange(data,add){
				if(data!=null){
					
					var typeName="";
					switch(data.type){
						case 1:
							typeName="期刊";
							break;
						case 2:
							typeName="电子期刊";
							break;
						case 3:
							typeName="点播课程";
							break;
						case 4:
							typeName="直播课程";
							break;
					}
					var obj={
							id:data.id,
							name:data.name,
							url:data.url,
							type:data.type,
							typeName:typeName,
							price:data.price
						};

					var index=-1;
					$.each(checkedData,function(i,v){
						if(v.id==obj.id&&v.type==obj.type){
							index=i;
							return;
						}
					})
					
					if(add){
						if(index==-1){
							checkedData.push(obj);
						}
					}else{
						if(index!=-1){
							checkedData.splice(index,1);
						}
					}
				}
			}
			function hasChecked(id,type){
				var data_v=type+"|"+id;
				var flag=false;
				if(select_Arr!=null){
		    		$.each(select_Arr,function(i,v){
		    			if(v!=''&&v==data_v){
		    				flag=true;
		    				return;
		    			}
		    		})
		    	}
			    return flag;
			}
		})
		
		
	</script>

</m:Content>
</m:ContentPage>
