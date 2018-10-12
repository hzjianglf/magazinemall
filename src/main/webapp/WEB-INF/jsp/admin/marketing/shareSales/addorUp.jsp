<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<style>
.picUrl{
	width: 100px;
	height:100px;
}
.rightCon>input {
	width: 50px;
	height: 24px;
	line-height: 24px;
	margin-left: 5px;
}

.rightCon>span {
	margin-right: 5px;
	padding: 6px;
	background: #efefef;
	position: relative;
	top: 0;
}
input {
	height: 34px;
	line-height: 34px;
	text-indent: 10px;
	padding: 0;
}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<input type="hidden" name="id" value="${id }" />
            	<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>活动名称：</label>
					<div class="layui-input-block">
						<input type="text" name="name" value="${name }" lay-verify="required" autocomplete="off" class="layui-input" />
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">副标题：</label>
					<div class="layui-input-block">
						<input type="text" name="title" value="${title }"  autocomplete="off" class="layui-input" />
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>开始时间：</label>
					<div class="layui-input-block">
						<input type="text" name="startTime" id="startTime" value="${startTime }" lay-verify="required" autocomplete="off" class="layui-input"/>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>结束时间：</label>
					<div class="layui-input-block">
						<input type="text" name="endTime" id="endTime" value="${endTime }" lay-verify="required" autocomplete="off" class="layui-input" />
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>折扣规则：</label>
					<div class="layui-input-block rightCon">
						每增加一级商品购买单价降低<input type="text" name="cutDown" value="${cutDown }"/><span>%</span> 商品折扣达到
						<input type="text" name="shutDown" value="${shutDown }"/><span>%</span>商品终止转发
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>返佣规则：</label>
					<div class="layui-input-block rightCon">
						每增加一级,上级分支分别获得<input type="text" name="integral" value="${integral }"/><span>积分</span>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">活动图片：</label>
					<div class="layui-input-block">
						<div class="picUrl">
							<img id="imgShow" src="${(empty picUrl)?'/manage/images/index/noImage.jpg':reqMap.picUrl }" style="width: 100%;height: 100%;">
							<input type="hidden" name="picUrl" id="picUrl" value="${picUrl }" />
						</div>
						<c:if test="${detail != '1' }">
							<button type="button" class="layui-btn" id="test1" style="display:block;margin:10px 0;">
								<i class="layui-icon">&#xe67c;</i>上传图片
							</button>
						</c:if>
					</div>
				</div>
				<div class="layui-form-item layui-form-text">
				    <label class="layui-form-label">活动介绍：</label>
				    <div class="layui-input-block">
				      <textarea name="introduce" placeholder="请输入内容" class="layui-textarea">${introduce }</textarea>
				    </div>
				</div>
				<div class="layui-form-item">
				    <label class="layui-form-label"><span class="must">*</span>活动状态:</label>
				    <div class="layui-input-block">
				    	<input type="radio" name="state" value="1" checked="checked" title="启用" ${state==1?'checked':'' }>
				    	<input type="radio" name="state" value="2" title="暂停" ${state==2?'checked':'' }>
				    </div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label"><span style="color:red;">*</span>活动商品：</label>
					<div class="layui-input-block">
						<c:if test="${detail != '1' }">
						<a class="layui-btn layui-btn-normal addproduct">添加商品</a>
						</c:if>
						<!-- 关联的商品id(,分割) -->
						<input type="hidden" name="ids" id="ids" />
						<table style="width: 60%;height: 100%;display: none;" id="tables">
							<tr style="text-align: center;">
								<td></td>
								<td>商品名称</td>
								<td>价格(元)</td>
								<td>操作</td>
							</tr>
							<c:forEach items="${list }" var="list" varStatus="cw">
								<tr style="text-align: center;" id="dela${cw.count }">
									<input type="hidden" name="chosen" value="${list.type }" data-id="${list.id }" />
									<td><img style="width:30px;height:30px;" src="${list.url }"></td>
									<td>${list.name }</td>
									<td>${list.price }</td>
									<td><a onclick="delHtml(this);" class="delhtml" data-id="dela${cw.count }">
										<i class="layui-icon">&#xe640;</i></a>
									</td>
								</tr>
							</c:forEach>
						</table>
					</div>
				</div>
				<!-- 关联商品集合 -->
				<input type="hidden" name="shangpin" id="shangpin" />
				<c:if test="${detail != '1' }">
					<div class="layui-form-item" style="text-align: center;">
						<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
					</div>
				</c:if>
			</form>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		$(function(){
			var detail = '${detail}';
			if(detail==1){
				$("input").attr('disabled','disabled');
				$("textarea").attr('disabled','disabled');
			}
			var id = '${id}';
			if(id!=null && id!=''){
				$("#tables").show();
			}
		})
		layui.use(['layer','form','laydate','upload'], function(){
			var form = layui.form;
			var layer = layui.layer;
			var laydate = layui.laydate;
			var upload = layui.upload;
			laydate.render({
			    elem: '#startTime' //指定元素
			    ,type: 'datetime'
			});
			laydate.render({
			    elem: '#endTime' //指定元素
			    ,type: 'datetime'
			});
			//监听提交
			form.on('submit(addEqBtn)', function(data){
				//判断开始时间不能大于结束时间
				var start = $("#startTime").val();
				var end = $("#endTime").val();
				if(start>=end){
					alert("开始时间不能小于结束时间");
					return false;
				}
				var array = new Array();
				//获取所有的隐藏域（关联商品）
				$("input[name='chosen']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					array.push({productType:type,productId:id});
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
				ajax('/${applicationScope.adminprefix }/sharesales/addOrUp', postData, success, 'post', 'json');
				return false;
			})
			//执行实例
			var uploadInst = upload.render({
				elem: '#test1', //绑定元素
				url: '/${applicationScope.adminprefix }/ondemand/uploadImg', //上传接口
				field: 'imgUrl',
				before: function(obj){
				    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
				    obj.preview(function(index, file, result){
				    	//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
				      	$("#imgShow").attr("src", result);
				      	//这里还可以做一些 append 文件列表 DOM 的操作
				      	//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
				      	//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
				    });
				},
				done: function(res){
					//上传完毕回调
					$('#picUrl').val(res.data);
				},
				error: function(){
					//请求异常回调
				}
			});
		 	//添加商品
			$(".addproduct").click(function(){
				//openwindow("sharesales/toaddProduct","商品选择",600,500,false,callback);
				layer.open({
					type: 2,
					title: ['商品选择', 'font-size:18px;'],
					anim:0,
					maxmin:false,
					shade:[0.5, '#393D49'],
					shadeClose: false,
					area: ['800px', '700px'],
					content: '/${applicationScope.adminprefix }/sharesales/toaddProduct?values=ids',
					success: function(layero, index) {
						
					},
					end: function() { //销毁后触发
						//商品id，数组( var arr=[{type:1,str:1,2,3},{type:2,str:1,2,3}]; )
						var ids = $("#ids").val();
						//调用方法加载以关联的商品
						if(ids!=null && ids.length>0){
							$.ajax({
								type : "POST",
								url : "/${applicationScope.adminprefix }/sharesales/selProducts",
								async : false,
								data : {"ids" : ids},
								success : function(data) {
									$("#tables").show();
									//返回的list
									var list = data.productList;
									var html = '';
									for(var i=0;i<list.length;i++){
										html+='<tr style="text-align: center;" id="del'+ (i+1) +'">';
										html+='<input type="hidden" name="chosen" value="'+ list[i].type +'" data-id="'+ list[i].id +'" />';
										html+='<td><img style="width:30px;height:30px;" src="'+ list[i].url +'"></td>';
										html+='<td>'+ list[i].name +'</td>';
										html+='<td>'+ list[i].price +'</td>';
										html+='<td><a onclick="delHtml(this);" class="delhtml" data-id="del'+ (i+1) +'"><i class="layui-icon">&#xe640;</i></a></td>';
										html+='</tr>';
									}
									$("#tables").append(html);
								},
								error : function(data) {
									layer.alert(data.msg,{icon: 2});
								}
							});
						}
					}
				});
			})
		})
		function delHtml(obj){
	 		var id = $(obj).data('id');
	 		$("#"+id+"").remove();
	 	}
	</script>
</m:Content>
</m:ContentPage>