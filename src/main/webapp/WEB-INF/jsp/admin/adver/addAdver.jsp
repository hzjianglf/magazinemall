<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib  uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="master">
<pxkj:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
	</style>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 10px;" class="layui-anim layui-anim-upbit">
		<%-- <blockquote class="layui-elem-quote layui-bg-blue">
			广告${aDID==null?'添加':'修改' }
		</blockquote> --%>
		<form id="contentInfo" class="layui-form">
		<div class="layui-tab">
			<div class="layui-tab-content" style="background: #FFFFFF;">
				<input type="hidden" value="${aDID }" name="aDID" />
			    <input type="hidden" value="${zoneID }" name="zoneID" />
			    <input type="hidden" value="" name="imgUrl" id="imgUrl" />
			    <input type="hidden" value="${imgUrl }" name="oldImgUrl"/>
			    
			    <input type="hidden" value="${itemId }" name="itemId" id="itemId"/>
			    <input type="hidden" value="${itemType }" name="itemType" id="itemType"/>
			    <input type="hidden" value="${itemSumType }" name="itemSumType" id="itemSumType"/>
			    
				<div class="layui-form">
	            	<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">广告名称：</label>
						<div class="layui-input-inline">
							<input type="text" name="aDName" value="${aDName }" lay-verify="required" autocomplete="off" class="layui-input"  style="width: 240px;"/>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">广告类型：</label>
						<div class="layui-input-block">
							<input type="radio" name="advType" value="1" checked="checked" title="图片"/>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">图片上传：</label>
						<div class="layui-input-block">
							<button type="button" class="layui-btn" id="test1">
								<i class="layui-icon">&#xe67c;</i>上传图片
							</button>
							<div style="margin-top: 7px;padding: 0;height: 100px;">
                                <img src="${imgUrl }" id="imgShow" width="100px" style="width:100px;height:100px" />
                                <input type="button" value="删除图片" onclick="deleteImg()" id="delImg" style="display: none;" class="layui-btn layui-btn-warm"/>
                            </div>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">图片尺寸：</label>
						<div class="layui-input-block">
							宽度：<input type="text" style="width:40px;height:20px" name="imgWidth" id="imgWidth" lay-verify="required" value="${imgWidth }"/>
			    			高度：<input type="text" style="width:40px;height:20px" name="imgHeight" id="imgHeight" lay-verify="required" value="${imgHeight }"/>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">跳转页面：</label>
						<div class="layui-input-block">
							<a class="layui-btn layui-btn-normal turnPage" >跳转页面</a>
							名称：
					        <input type="text" value="${itemName }" name="itemName" id="itemName" style="width:160px;height:30px" readonly="readonly"/>
						</div>
					</div>
					<%-- <div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">链接地址：</label>
						<div class="layui-input-block">
							<input type="text" name="linkUrl" value="${linkUrl }" autocomplete="off" class="layui-input" style="width: 240px;"/>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">链接提示：</label>
						<div class="layui-input-block">
							<input type="text" name="linkAlt" value="${linkAlt }" autocomplete="off" class="layui-input" style="width: 240px;"/>
						</div>
					</div> --%>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">弹出方式：</label>
						<div class="layui-input-block">
							<input type="radio"  name="linkTarget" value="1" title="新窗口"/>
				    		<input type="radio"  name="linkTarget" value="2" title="原窗口"/>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">广告简介：</label>
						<div class="layui-input-block">
							<textarea name="aDIntro" style="width:240px;height:70px">${aDIntro }</textarea>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">广告权重：</label>
						<div class="layui-input-block">
							<input type="text" name="priority" value="${(empty priority)?'0':priority }" autocomplete="off" class="layui-input" style="width: 25px;height: 25px"/>
						</div>
					</div>
					<div class="layui-form-item" style="margin-left: 135px;">
						<label class="layui-form-label">审核状态：</label>
						<div class="layui-input-block">
							<input type="checkbox" name="passed" title="通过审核"  class="layui-input" ${passed==true?'checked="checked"':'' }/>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div>
			<button class="layui-btn" lay-submit lay-filter="saveBtn">保存</button>
		</div>
		</form>
	</div>
</pxkj:Content>
<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript">
	
		$(function() {
			var linkTarget = "${linkTarget}";
			$("input[name='linkTarget']").each(function() {
				if ($(this).val() == linkTarget) {
					$(this).attr("checked", true);
				}
			});
		});
		layui.use([ 'form', 'upload', 'layer' ], function() {
			var form = layui.form;
			var upload = layui.upload;
			var layer = layui.layer;
			
			form.on('submit(saveBtn)', function(data){
				var success = function(response){
					if(response.success){
						layer.alert(response.msg, {icon: 1}, function(){
							var index = parent.layer.getFrameIndex(window.name);
							parent.layer.close(index);
						})
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var itemName = $("#itemName").val();
				if(itemName == null || itemName == "" || itemName == undefined){
					alert("请点击跳转页面选择商品或专家");
					return false;
				}
				var postData = $(data.form).serialize();
				var num = Math.random();
				ajax('/${applicationScope.adminprefix }/adver/addAdver?num='+num, postData, success, 'post', 'json');
				return false;
			})

			//执行实例
			var uploadInst = upload.render({
				elem : '#test1', //绑定元素
				url: '/${applicationScope.adminprefix }/adver/uploadImg', //上传接口
				field : 'imgUrl',
				before : function(obj) {
					//预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
					obj.preview(function(index, file, result) {
						//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
						$("#imgShow").show();
						$("#imgShow").attr("src", result);
						createReader(file, function(w, h) {
							$("#imgWidth").val(w);
							$("#imgHeight").val(h);
						})
						//这里还可以做一些 append 文件列表 DOM 的操作
						//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
						//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
					});
				},
				done : function(res) {
					//上传完毕回调
					$('#imgUrl').val(res.data);
				},
				error : function() {
					//请求异常回调
				}
			});
		})

		createReader = function(file, whenReady) {
			var reader = new FileReader;
			reader.onload = function(evt) {
				var image = new Image();
				image.onload = function() {
					var width = this.width;
					var height = this.height;
					if (whenReady)
						whenReady(width, height);
				};
				image.src = evt.target.result;
			};
			reader.readAsDataURL(file);
		}

		$(function() {
			var imgUrl = "${imgUrl }";
			if (imgUrl != "") {
				$("#delImg").show();
			}
		})

		//删除图片
		function deleteImg() {
			$("#imgShow").attr("src", "");
			$("#imgShow").hide();
			$("#oldPicUrl").val("");
			$("#delImg").hide();
		}
		//跳转页面
		$(".turnPage").click(function(){
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
				content: '/${applicationScope.adminprefix }/adver/adverToAddProduct?type=1&values=ids1&ids='+ids,
				success: function(layero, index) {
					$("#ids1").val('');
				},
				end: function() {
					var v = $("#ids").val();
					if(v==''||v==null){
						return ;
					}
					var list=JSON.parse(v);
					var html = '';
					/* for(var i=0;i<list.length;i++){
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
					*/
				}
			});
		})
		
		
	</script>
</pxkj:Content>
</pxkj:ContentPage>
