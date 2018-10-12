<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<link rel="stylesheet" href="/manage/zTree/css/metro.css" type="text/css"/>
<style>
ul.ztree{
    margin-top: 10px;
    border: 1px solid #ddd;
    background: #F4F7FD;
    min-width: 235px;
    height: 360px;
    overflow-y: scroll;
    overflow-x: auto;
    z-index:99999;
}
.layui-form-label{
	width: 150px;
	margin-left: 10px;
	text-align:left;
}
#bodyId{
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div id="bodyId" style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<input type="hidden" name="id" value="${id }" />
				
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>活动名称：</label>
					 <div class="layui-input-inline">
						<input type="text" name="name" value="${name }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>开始时间：</label>
				    <div class="layui-input-inline">
				      <input type="text" value="${startTime }" name="startTime" id="startTime" lay-verify="required" autocomplete="off" class="layui-input">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>结束时间：</label>
				    <div class="layui-input-inline">
				      <input type="text" value="${endTime }" name="endTime" id="endTime" lay-verify="required"  class="layui-input" >
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">买即送说明：</label>
				     <div class="layui-input-inline">
				      <input type="text" value="${remark }" name="remark"    class="layui-input">
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span style="color:red;">*</span>是否暂停</label>
				    <div class="layui-input-block">
				      <input type="radio" name="isFree" value="1" title="否" ${isFree==1?'checked':'' } checked>
				      <input type="radio" name="isFree" value="0" title="是" ${isFree==0?'checked':'' }>
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">规则 购买商品：</label>
				    <a class="layui-btn layui-btn-normal add1" >添加商品</a>
					<!-- 关联的商品id(,分割) -->
					<input type="hidden" name="ids1" id="ids1" />
					<table style="width: 80%;height: 100%; display: none;margin-left: 150px;margin-top: 20px" id="tables" >
							<tr style="text-align: center;">
								<td>商品名称</td>
								<td>类型</td>
								<td>价格(元)</td>
								<td>操作</td>
							</tr>
							<c:forEach items="${list }" var="list">
								<c:if test="${list.types==1 }">
								<tr style="text-align: center" id="del1${list.id }">
									<input type="hidden" name="chosen1" value="${list.type }" data-id="${list.id }" />
									<td><img style="width:30px;height:30px;" src="${list.url }"></td>
									<td>${list.name }</td>
									<c:if test="${list.type==1 }">
										<td>期刊</td>
									</c:if>
									<c:if test="${list.type==2 }">
										<td>电子期刊</td>
									</c:if>
									<c:if test="${list.type==3 }">
										<td>点播课程</td>
									</c:if>
									<c:if test="${list.type==4 }">
										<td>直播课程</td>
									</c:if>
									<td>${list.price }</td>
									<td><a onclick="deleteRow(this);" class="delhtml" data-id="del1${list.id }">
										<i class="layui-icon">&#xe640;</i></a>
									</td>
								</tr>
								</c:if>
							</c:forEach>
					</table>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">规则 赠送商品：</label>
				    <a class="layui-btn layui-btn-normal add2" >添加商品</a>
					<!-- 关联的商品id(,分割) -->
					<input type="hidden" name="ids2" id="ids2" />
						<table style="width: 60%;height: 100%; display: none;margin-left: 150px;margin-top: 20px" id="tables2" >
							<tr style="text-align: center;">
								<td>商品名称</td>
								<td>类型</td>
								<td>价格(元)</td>
								<td>操作</td>
							</tr>
							<c:forEach items="${list }" var="list">
								<c:if test="${list.types==2 }">
								<tr style="text-align: center" id="dela${list.id }">
									<input type="hidden" name="chosen2" value="${list.type }" data-id="${list.id }" />
									<td><img style="width:30px;height:30px;" src="${list.url }"></td>
									<td>${list.name }</td>
									<c:if test="${list.type==1 }">
										<td>期刊</td>
									</c:if>
									<c:if test="${list.type==2 }">
										<td>电子期刊</td>
									</c:if>
									<c:if test="${list.type==3 }">
										<td>点播课程</td>
									</c:if>
									<c:if test="${list.type==4 }">
										<td>直播课程</td>
									</c:if>
									<td>${list.price }</td>
									<td><a onclick="deleteRow(this);" class="delhtml" data-id="dela${list.id }">
										<i class="layui-icon">&#xe640;</i></a>
									</td>
								</tr>
								</c:if>
							</c:forEach>
					</table>
				</div>
				<!-- 关联商品集合 -->
				<input type="hidden" name="shangpin" id="shangpin" />
				<div class="layui-form-item" style="text-align: center;">
					<c:if test="${type==1 }">
						<button class="layui-btn" style="width: 50%;margin-top: 60px;" id="sure">确定</button>
					</c:if>
					<c:if test="${type!=1 }">
					<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
					</c:if>
				</div>
			</form>
		</div>
	</div>
	<div id="menuContent" class="menuContent" data-target="parentId" style="display:none; position: absolute;z-index:9999">
		<ul id="tree" class="ztree" style="margin-top:0; min-width:200px; height: 300px;"></ul>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script type="text/javascript" src="/manage/zTree/js/jquery.ztree.all.min.js"></script>
	<script type="text/javascript">
	$(function(){
		var detail = '${type}';
		if(detail==1){
			$("input").attr('disabled','disabled');
			$("textarea").attr('disabled','disabled');
		}
		$("#tables").css("display","block");
		$("#tables2").css("display","block");
	})
	
		layui.use(['laypage', 'layer', 'table', 'form', 'laydate'], function(){
			var form = layui.form;
			var laydate = layui.laydate;
			//监听首页展示
			form.on('switch(Isdisplay)', function(obj){
				if(obj.elem.checked){
					$("#weight").show();
				}else{
					$("#weight").hide();
				}
			});
			laydate.render({
				elem: '#startTime'
				,type: 'datetime'
				/* range: true  区间时间选择*/
			});
			laydate.render({
				elem: '#endTime'
				,type: 'datetime'
			});
			//监听提交
			form.on('submit(addEqBtn)', function(data){
				var start = $("#startTime").val();
				var end = $("#endTime").val();
				if(start>=end){
					alert("开始时间不能小于结束时间");
					return false;
				}
				var array = new Array();
				//获取所有的隐藏域（关联商品）
				if($("input[name='chosen1']").length==0){
					alert("请选择购买商品");
					return false;
				}
				if($("input[name='chosen2']").length==0){
					alert("请选择购买商品");
					return false;
				}
				$("input[name='chosen1']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					array.push({productType:type,productId:id,type:1});
				})
				$("input[name='chosen2']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					array.push({productType:type,productId:id,type:2});
				})
				$("#shangpin").val(JSON.stringify(array));
				
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {
							icon: 1
						}, function() {
							var index = parent.layer.getFrameIndex(window.name);
							 parent.layer.close(index)
						});
					}else{
						layer.alert(response.msg, {
							icon: 2
						}, function() {
							layer.closeAll();
						});
					}
				}
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/buyJisong/addOrUp', postData, success, 'post', 'json');
				
				return false;
			})
			$("#sure").click(function(){
				closewindow();
			})
			
				//添加商品
			$(".add1").click(function(){
				if("${type}"==1){
					return ;
				}
				//openwindow("sharesales/toaddProduct","商品选择",600,500,false,callback);
				var array = []
				$("input[name='chosen1']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					array.push(type+"|"+id);
				})
				var ids = array.join(",");
				layer.open({
					type: 2,
					title: ['商品选择', 'font-size:18px;'],
					anim:0,
					maxmin:false,
					shade:[0.5, '#393D49'],
					shadeClose: false,
					area: ['800px', '700px'],
					content: '/${applicationScope.adminprefix }/buyJisong/toaddProduct?type=1&values=ids1&ids='+ids,
					success: function(layero, index) {
						$("#ids1").val('');
					},
					end: function() {
						var v = $("#ids1").val();
						if(v==''||v==null){
							return ;
						}
						var list=JSON.parse(v);
						var html = '';
						for(var i=0;i<list.length;i++){
							var item=list[i];
							var flag=ishas(item.id,item.type,1);
							if(flag){
								continue;
							}
							html+='<tr style="text-align: center;" id="del'+ (i+1) +'">';
							html+='<input type="hidden" name="chosen1" value="'+ item.type +'" data-id="'+ item.id +'" />';
							html+='<td><img style="width:30px;height:30px;" src="'+ item.url +'"></td>';
							html+='<td>'+ item.name +'</td>';
							html+='<td>'+item.typeName+'</td>';
							html+='<td>'+item.price +'</td>';
							html+='<td><a onclick="deleteRow(this);" class="delhtml" data-id="del'+ (i+1) +'"><i class="layui-icon">&#xe640;</i></a></td>';
							html+='</tr>';
						}
						$("#tables").append(html);
						$("#tables").css("display","block");
					}
				});
			})
			function ishas(i,t,d){
				var flag=false;
				$("input[name='chosen"+d+"']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					if(type==t&&i==id){
						flag=true;
						return;
					}
				})
				return flag;
			}
				//添加赠送商品
			$(".add2").click(function(){
				if("${type}"==1){
					return ;
				}
				//openwindow("sharesales/toaddProduct","商品选择",600,500,false,callback);
				var array = []
				$("input[name='chosen2']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					array.push(type+"|"+id);
				})
				var ids = array.join(",");
				layer.open({
					type: 2,
					title: ['商品选择', 'font-size:18px;'],
					anim:0,
					maxmin:false,
					shade:[0.5, '#393D49'],
					shadeClose: false,
					area: ['800px', '700px'],
					content: '/${applicationScope.adminprefix }/buyJisong/toaddProduct?type=2&values=ids2&ids='+ids,
					success: function(layero, index) {
						$("#ids2").val('');
					},
					end: function() { //销毁后触发
						var ids = $("#ids2").val();
						if(ids==''||ids==null){
							return ;
						}
                    	//返回的list
						var list=JSON.parse(ids);
						var html = '';
						for(var i=0;i<list.length;i++){
							var item=list[i];
							var flag=ishas(item.id,item.type,2);
							if(flag){
								continue;
							}
							html+='<tr style="text-align: center;" id="dels'+ (i+1) +'">';
							html+='<input type="hidden" name="chosen2" value="'+ list[i].type +'" data-id="'+ list[i].id +'" />';
							html+='<td><img style="width:30px;height:30px;" src="'+ list[i].url +'"></td>';
							html+='<td>'+ list[i].name +'</td>';
							html+='<td>'+list[i].typeName+'</td>';
							html+='<td>'+ list[i].price +'</td>';
							html+='<td><a onclick="deleteRow(this);" class="delhtml" data-id="dels'+ (i+1) +'"><i class="layui-icon">&#xe640;</i></a></td>';
							html+='</tr>';
						}
						$("#tables2").append(html);
						$("#tables2").css("display","block");
					}
				});
			})
			
		})
		function deleteRow(obj){
			if("${type}"==1){
				return ;
			}
			var id = $(obj).data('id');
			$("#"+ id +"").remove();
		}
	</script>
</m:Content>
</m:ContentPage>