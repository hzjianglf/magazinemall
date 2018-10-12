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
					<label class="layui-form-label"><span style="color:red;"></span>启用禁用：</label>
					<div class="layui-input-block">
				    	<input type="radio" name="status" value="1" checked="checked" title="启用" ${status==1?'checked':'' }>
				    	<input type="radio" name="status" value="0" title="暂停" ${status==0?'checked':'' }>
					</div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label">规则 购买商品：</label>
				    <a class="layui-btn layui-btn-normal add1" >添加商品</a>
					<!-- 关联的商品id(,分割) -->
					<input type="hidden" name="ids1" id="ids1" />
					<table style="width: 80%;height: 100%; display: none;margin-left: 150px;margin-top: 20px" id="tables" >
							<tr style="text-align: center;">
								<td style="width:10%"></td>
								<td style="width:18%">商品名称</td>
								<td style="width:18%">类型</td>
								<td style="width:18%">价格(元)</td>
								<td style="width:18%">折扣(%)</td>
								<td style="width:18%">操作</td>
							</tr>
							<c:forEach items="${list }" var="list" varStatus="cw">
								<tr style="text-align: center" id="del1${cw.count }">
									<input type="hidden" name="chosen" value="${list.productType }" data-price="${list.price }" data-id="${list.productId }" />
									<td><img style="width:30px;height:30px;" src="${list.url }"></td>
									<td>${list.name }</td>
									<c:if test="${list.productType==1 }">
										<td>期刊</td>
									</c:if>
									<c:if test="${list.productType==2 }">
										<td>电子期刊</td>
									</c:if>
									<c:if test="${list.productType==3 }">
										<td>点播课程</td>
									</c:if>
									<c:if test="${list.productType==4 }">
										<td>直播课程</td>
									</c:if>
									<td>${list.price }</td>
									<td><input type="text" name="discount" lay-verify="number" onkeyup="onlyNum(this)" maxlength="3" autocomplete="off" value="${list.discount }" lay-verify="required" style="width:45px;margin:0px" /><span style="font-size:18px">%</span></td>
									<td><a onclick="deleteRow(this);" class="delhtml" data-id="del1${cw.count }">
										<i class="layui-icon">&#xe640;</i></a>
									</td>
								</tr>
							</c:forEach>
					</table>
				</div>
				<%-- <div class="layui-form-item">
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
				</div> --%>
				<!-- 关联商品集合 -->
				<input type="hidden" name="shangpin" id="shangpin" />
				<div class="layui-form-item" style="text-align: center;">
					<c:if test="${detail != 'null' && not empty detail}">
						<button class="layui-btn" style="width: 50%;margin-top: 60px;" id="sure">确定</button>
					</c:if>
					<c:if test="${detail == 'null' || empty detail }">
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
		/* var detail = '${type}';
		if(detail==1){
			$("input").attr('disabled','disabled');
			$("textarea").attr('disabled','disabled');
		}
		$("#tables").css("display","block");
		$("#tables2").css("display","block"); */
		var detail = '${detail}';
		if(detail==1){
			$("input").attr('disabled','disabled');
			$(".add1").removeClass("add1");
			$('.delhtml').remove();
		}
		var id = '${id}';
		if(id!=null && id!=''){
			$("#tables").show();
		}
	});
	function onlyNum(Obj){
		//只能是数字
		Obj.value=Obj.value.replace(/\D/g,"");
		//限制大小
		if(Obj.value!=""){
			Number(Obj.value)==0?Obj.value=1:Obj.value;
			Number(Obj.value)<0?Obj.value=1:Obj.value;
			Number(Obj.value)>100?Obj.value=100:Obj.value;
		}
	}
	
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
				$("tr").each(function(){
					var obj = $(this).find('input[name="chosen"]')
					var type = obj.val();
					var price = Number(obj.data('price'));
					var id = obj.data('id');
					var discount = $(this).find('input[name="discount"]').val();
					price = ((Number(discount)/100)*price).toFixed(2);
					if(type != null && obj != '' && id != null && id != ''){
						array.push({productType:type,productId:id,discount:discount,price:price});
					}
				});
				console.log(JSON.stringify(array));
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
				ajax('/${applicationScope.adminprefix }/discount/insUpDiscount', postData, success, 'post', 'json');
				
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
				$("input[name='chosen']").each(function(){
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
							
							var flg = true;
							$("input[name='chosen']").each(function(){
								var id = $(this).data('id');
								var val = $(this).val();
								if(id == list[i].id && val == list[i].type){
									flg = false;
								}
							});
							
							var item=list[i];
							var flag=ishas(item.id,item.type,1);
							if(flag){
								continue;
							}
							if(flg){
								html+='<tr style="text-align: center;" id="del'+ (i+1) +'">';
								html+='<input type="hidden" name="chosen" value="'+ item.type +'" data-price="'+item.price+'" data-id="'+ item.id +'" />';
								html+='<td><img style="width:30px;height:30px;" src="'+ item.url +'"></td>';
								html+='<td>'+ item.name +'</td>';
								html+='<td>'+item.typeName+'</td>';
								html+='<td>'+Number(item.price).toFixed(2) +'</td>';
								html+='<td><input type="text" name="discount" onkeyup="onlyNum(this)" lay-verify="number" autocomplete="off" value="100" lay-verify="required" style="width:50px;margin:0px" /><span style="font-size:18px">%</span></td>';
								html+='<td><a onclick="deleteRow(this);" class="delhtml" data-id="del'+ (i+1) +'"><i class="layui-icon">&#xe640;</i></a></td>';
								html+='</tr>';
							}
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
			/* $(".add2").click(function(){
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
			}) */
			
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