<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<style type="text/css">
		body {
			background: #f1f0f7;
		}
		
		.yw_cx {
			background: #fff;
			border-radius: 3px;
			padding: 30px 10px;
		}
		
		.layui-form-item .layui-input-inline {
			width: 162px;
			margin-right: 0
		}
		
		.layui-form-label {
			width: inherit
		}
		
		.layui-table th {
			font-weight: 700;
			background: #01AAED;
			color: #fff;
			text-align: center;
		}
		
		.layui-table td {
			text-align: center;
		}
		
		.layui-laypage span {
			background: none
		}
		
		.layui-laypage .layui-laypage-spr {
			background: #fff
		}
		
		.layui-tab-title .layui-this:after {
			border-bottom-color: #f1f0f7
		}
		
		.layui-form-select {
			width: 85.8%;
			float: left;
		}
		
		div.layui-form {
			width: 1150px;
			margin-left: 6%;
			margin-top: 20px;
		}
		
		.layui-form-label {
			width: 120px !important;
		}
		
		.layui-input-block input {
			width: 95%;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
	<div style="padding: 15px;" class="layui-anim layui-anim-upbit">
		<blockquote class="layui-elem-quote layui-bg-blue">
			栏目${type == 'add'?'添加':'修改'}
		</blockquote>
	<form action="/${applicationScope.adminprefix }/column/saveColumnInfo?num=<%=Math.random() %>" id="columnInfo" class="layui-form" method="post">
		<div class="layui-tab">
			<ul class="layui-tab-title">
				<li class="layui-this">基本信息</li>
				<li>栏目设置</li>
				<li>模板设置</li>
			</ul>
			<div class="layui-tab-content" style="background: #FFFFFF;">
			<input type="hidden" name="catId" id="catId" value="${columnMap.catId }"/>
			<input type="hidden" name="imgUrl" id="imgUrl" value=""/>
				<div class="layui-tab-item layui-show" style="position: relative;">
					<div class="layui-form">
						<div class="layui-form-item">
							<label class="layui-form-label">所属栏目：</label>
						    <select name="parentId" id="parentId" lay-search lay-verify="required" lay-filter="columnSel">
						    	<option value="">--请选择--</option>
						    	<c:if test="${type == 'add'}">
						    	 <option value="0" <c:if test="${catId==null }">selected="selected"</c:if>>/</option>
								 <c:forEach items="${columnList }" var="item">
		 							<c:if test="${item.parentId==0 }">
			 							<option value="${item.catId }" <c:if test="${item.catId==catId }">selected="selected"</c:if>>|-${item.catName }</option>
			 							<c:forEach items="${columnList }" var="items">
			 								<c:if test="${item.catId==items.parentId }">
			 									<option value="${items.catId }"  <c:if test="${items.catId==catId }">selected="selected"</c:if>>
			 										<c:if test="${items.parentId!=0 }"></c:if>|-${items.catName }</option>
						    					<c:forEach items="${columnList }" var="itemss">
				    								<c:if test="${items.catId==itemss.parentId }">
	 													<option value="${itemss.catId }" <c:if test="${itemss.catId==catId }">selected="selected"</c:if>>
	 														<c:if test="${items.parentId!=0 }"></c:if>|-${itemss.catName }</option>
				    								</c:if>
							    				</c:forEach>
						    				</c:if>
						    			</c:forEach>
					    			</c:if>
					    		</c:forEach>
					    		</c:if>
					    		<c:if test="${type == 'revise'}">
					    		<option value="0" <c:if test="${columnMap.parentId==0 }">selected="selected"</c:if>>/</option>
		 						<c:forEach items="${columnList }" var="item">
		 							<c:if test="${item.parentId==0 }">
			 							<option value="${item.catId }" <c:if test="${item.catId==columnMap.parentId }">selected="selected"</c:if>>|-${item.catName }</option>
			 							<c:forEach items="${columnList }" var="items">
			 								<c:if test="${item.catId==items.parentId }">
			 									<option value="${items.catId }" <c:if test="${items.catId==columnMap.parentId }">selected="selected"</c:if>>
			 										<c:if test="${items.parentId!=0 }"></c:if>|-${items.catName }</option>
			 									<c:forEach items="${columnList }" var="itemss">
				    								<c:if test="${items.catId==itemss.parentId }">
	 													<option value="${itemss.catId }" <c:if test="${itemss.catId==columnMap.parentId }">selected="selected"</c:if>> 
	 														<c:if test="${itemss.parentId!=0 }"></c:if>|-${itemss.catName }</option>
				    								</c:if>
							    				</c:forEach>
						    				</c:if>
						    			</c:forEach>
						    		</c:if>
					    		</c:forEach>
					    		</c:if>
						    </select>
						</div>
		            	<div class="layui-form-item">
							<label class="layui-form-label">栏目名称：</label>
							<div class="layui-input-block">
								<input type="text" name="catName" value="${columnMap.catName }" lay-verify="required" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目别名：</label>
							<div class="layui-input-block">
								<input type="text" name="catAlias" value="${columnMap.catAlias }" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目网站标题：</label>
							<div class="layui-input-block" >
								 <input type="text" name="titles" value="${columnMap.titles }" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目网站关键字：</label>
							<div class="layui-input-block" >
								 <input type="text" name="keyWord" value="${columnMap.keyWord }" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目网站描述：</label>
							<div class="layui-input-block" >
								 <input type="text" name="description" value="${columnMap.description }" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">展示图：</label>
							<div class="layui-input-block" >
								<button type="button" class="layui-btn" id="test1">
									<i class="layui-icon">&#xe67c;</i>上传图片
								</button>
								<div style="margin-top: 7px;padding: 0;height: 100px;">
	                                <img src="${columnMap.imgUrl }" id="imgShow" width="100px" style="margin-left: 40px;"/>
	                                <input type="hidden" name="oldImgUrl" id="oldImgUrl" value="${columnMap.imgUrl }"/>
	                                <input type="button" value="删除图片" onclick="deleteImg()" id="delImg" style="display: none;margin-top: 10px;width: 90px;" class="layui-btn layui-btn-danger"/>
	                            </div>
							</div>
						</div>
					</div>
				</div>
				<div class="layui-tab-item " style="position: relative;">
					<div class="layui-form">
						<div class="layui-form-item">
							<label class="layui-form-label">栏目打开方式：</label>
						    <select lay-search name="catOpenType" id="catOpenTypes" lay-verify="required">
						    	<option value="">--请选择--</option>
						    	<option value="1" ${columnMap.catOpenType==1?'selected':'' }>本窗口</option>
								<option value="2" ${columnMap.catOpenType==2?'selected':'' }>新窗口</option>
								<option value="3" ${columnMap.catOpenType==3?'selected':'' }>父窗口</option>
						    </select>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目类型：</label>
						    <select lay-search name="catType" id="catType" lay-verify="required">
						    	<option value="">--请选择--</option>
						    	<option value="1" ${columnMap.catType==1?'selected':'' }>普通</option>
								<option value="2" ${columnMap.catType==2?'selected':'' }>单页</option>
								<option value="3" ${columnMap.catType==3?'selected':'' }>跳转</option>
						    </select>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目跳转地址：</label>
							<div class="layui-input-block" >
								 <input type="text" name="linkUrl" value="${columnMap.linkUrl }" lay-verify="title" autocomplete="off" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">是否推荐：</label>
							<div class="layui-input-block">
								<input type="checkbox" name="IsRec" ${columnMap.IsRec==1?'checked':'' } lay-skin="switch" lay-text="是|否">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">是否在导航：</label>
							<div class="layui-input-block">
								<input type="checkbox" name="IsShowOnMenu" ${columnMap.IsShowOnMenu==1?'checked':'' } lay-skin="switch" lay-text="是|否">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">是否在路径：</label>
							<div class="layui-input-block">
								<input type="checkbox" name="IsShowOnPath" ${columnMap.IsShowOnPath==1?'checked':'' } lay-skin="switch" lay-text="是|否">
							</div>
						</div>
					</div>
				</div>
				<div class="layui-tab-item " style="position: relative;">
					<div class="layui-form">
						<div class="layui-form-item">
							<label class="layui-form-label">栏目首页模板：</label>
						    <select lay-search name="DefaultView" id="DefaultView">
						    	<option value="">--请选择--</option>
                                <c:forEach items="${defaultSet }" var="Default">
									<option value="${Default }" ${columnMap.defaultTemplateFile==Default?'selected':'' }>${Default }</option>
								</c:forEach>
						    </select>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目列表模板：</label>
						    <select lay-search name="ListView" id="ListView">
						    	<option value="">--请选择--</option>
                                <c:forEach items="${listSet }" var="list1">
									<option value="${list1 }" ${columnMap.ListView==list1?'selected':'' }>${list1 }</option>
								</c:forEach>
						    </select>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">栏目详情模板：</label>
						    <select lay-search name="ItemView" id="ItemView">
						    	<option value="">--请选择--</option>
                                <c:forEach items="${detailSet }" var="Detail">
									<option value="${Detail }" ${columnMap.ItemView==Detail?'selected':'' }>${Detail }</option>
								</c:forEach>
						    </select>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div>
			<c:if test="${type=='add' }">
			<button class="layui-btn" lay-submit lay-filter="saveBtn">保存栏目信息</button>
			</c:if>
			<c:if test="${type=='revise' }">
			<button class="layui-btn" lay-submit lay-filter="saveBtn">修改栏目信息</button>
			</c:if>
		</div>
	</form>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use(['element', 'layer', 'form', 'laydate'], function() {
			var element = layui.element;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			//一些事件监听
			element.on('tab(demo)', function(data) {
				layer.msg('切换了：' + this.innerHTML);
	
			});
	
			laydate.render({
				elem: '#date'
			});
	
			//自定义验证规则
			form.verify({
				
			});
			
			form.on('select(columnSel)', function(data){
				console.info(data.othis);
			})
			
			//监听提交
			form.on('submit(saveBtn)', function(data) {
				var success = function(response){
					if(response.success){
						alertinfo(response.msg, true,callback);
					}else{
						alertinfo(response.msg, false,callback);
					}
				}
				var postData = $(data.form).serialize();
				ajax('column/saveColumnInfo?num='+Math.random(), postData, success, 'post', 'json');
				return false;
			});
		});
		function callback(){
			window.parent.location.reload();
		}
		
		layui.use('element', function(){
			var $ = layui.jquery, element = layui.element; //Tab的切换功能，切换事件监听等，需要依赖element模块
		});
		
		layui.use('upload', function(){
			var upload = layui.upload;
			//执行实例
			var uploadInst = upload.render({
				elem: '#test1', //绑定元素
				url: '/${applicationScope.adminprefix }/column/uploadImg', //上传接口
				field: 'imgUrl',
				before: function(obj){
				    //预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
				    obj.preview(function(index, file, result){
				    	//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
				    	$("#imgShow").show();
				      	$("#imgShow").attr("src", result);
				      	//这里还可以做一些 append 文件列表 DOM 的操作
				      	//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
				      	//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
				    });
				},
				done: function(res){
					//上传完毕回调
					$('#imgUrl').val(res.data);
				},
				error: function(){
					//请求异常回调
				}
			});
		});
	        
	    $(function(){
			var imgUrl = "${columnMap.imgUrl }";
			if(imgUrl!=""){
				$("#delImg").show();
			}
		})
		
		//删除图片
		function deleteImg(){
			$("#imgShow").attr("src", "");
			$("#imgShow").hide();
			$("#oldImgUrl").val("");
			$("#delImg").hide();
		}
	</script>
</m:Content>
</m:ContentPage>
