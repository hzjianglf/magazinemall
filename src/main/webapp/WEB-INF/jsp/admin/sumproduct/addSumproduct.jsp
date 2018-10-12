<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/>
	<style type="text/css">
		.layui-form-select {
			width: 85.8%;
			float: left;
		}
		div.layui-form {
			width: 1150px;
			margin-left: 6%;
			margin-top: 20px;
		}
.xxk1 ul li.on, .xxk2 ul li.on {
    background: #1ebd60;
    color: #fff;
    font-weight: 700;
}

.xxk1 ul li, .xxk2 ul li {
    float: left;
    width: 62px;
    height: 25px;
    line-height: 25px;
    text-align: center;
    font-size: 13px;
    background: #a8a8a8;
}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
		<div class="cbjh">
		<br>
			<div class="cjhj_top">
				<div class="cjhj_nr">
					<form class="layui-form" id="form">
					<input type="hidden" name="id" value="${id }" id="edit" />
					<input type="hidden" name="classtypes" value="${classtypes }" id="classtype" />
						<div class="layui-form-item">
							<label class="layui-form-label"><em style="color: #f00;">*</em>合辑名称：</label>
							<div class="layui-input-block">
								<input type="text"  value="${name }"  name="name" id="name" class="layui-input" lay-verify="required" style="width: 288px;">
							</div>

						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"> 合辑价格：</label>
							<div class="layui-input-block">
								<input type="text" value="${presentPrice }" name="xtotalprice" id="xtotalprice" class="layui-input" onkeyup="value=value.replace(/[^\d\.]+?/g,'');";  style=" width: 85px;display: inline-block;" "><span>元</span>
							</div>
							<input type="hidden" id="ytotalprice" name="ytotalprice" value=${originalPrice }/>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"> 合辑类型：</label>
							<div class="layui-input-block">
								<input type="radio" name="classtype" value="0" title="点播课程" lay-filter="type" ${classtype==0?'checked':'' } checked>
								<input type="radio" name="classtype" value="1" title="直播课程" lay-filter="type" ${classtype==1?'checked':'' }>
								<input type="radio" name="classtype" value="2" title="期刊" lay-filter="type" ${classtype==2?'checked':'' }>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label"> 合辑简介：</label>
							<div class="layui-input-block">
								<%-- <textarea placeholder="" name="introduce"  class="layui-textarea">${introduce }${describes }</textarea> --%>
								<script id="editor" type="text/plain" name="introduce" style="width: 100%; height: 500px;">
								${introduce }${describes }
								</script>
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">列表置顶：</label>
							<div class="layui-input-block">
								<input type="radio" name="isTop" value="1" title="是"  ${IsRecommend==1?'checked':'' } checked>
								<input type="radio" name="isTop" value="0" title="否"  ${IsRecommend==0?'checked':'' } >
							</div>
						</div>
						<c:if test="${id != null && id != '' }">
						<div class="layui-form-item " style="display:none">
							<label class="layui-form-label">分享地址：</label>
							<div class="layui-input-block">
								<input type="text" value="${sharedAddress }/product/turnPublicationDetail?id=${id }"class="layui-input" disabled >
							</div>
						</div>
						</c:if>
						<div class="layui-form-item ">
							<label class="layui-form-label">排序号：</label>
							<div class="layui-input-block" style="width: 150px;">
								<input type="text" name='sortNo' id="sortNo" value="${sortNo }"class="layui-input" onkeyup="if (!(/^[\d]+?\d*$/.test(this.value)) ){tipinfo('请输入数字'); this.value='';this.focus();}" >
								数值越大排序越靠前
							</div>
						</div>
						<div class="layui-form-item qikan" style="display:none">
							<label class="layui-form-label">期刊类型：</label>
							<div class="layui-input-block">
								<input type="radio" name="isSale" value="1" title="纸媒版"  ${isSalePaper==1?'checked':'' } checked>
								<input type="radio" name="isSale" value="2" title="电子版"  ${isSalePaper==0?'checked':'' } >
							</div>
						</div>
						
						<div class="layui-form-item qikan" style="display:none">
							<label class="layui-form-label">运费设置：</label>
							<div class="layui-input-block">
								<input type="radio" name="postageType" value="0" lay-filter="postageType" title="固定运费"  ${postageType==0?'checked':'' } checked>
								<input type="radio" name="postageType" value="1" lay-filter="postageType" title="运费模板"  ${postageType==1?'checked':'' } >
							</div>
							<div class="layui-input-inline">
								<div class="postage1 ${(postageType=='1')?'hide':'' }">
											<input type="text" class="in1" style="width: 100px;" name="postage" id="postage" onkeyup="if (!(/^[\d]+?\d*$/.test(this.value)) ){tipinfo('请输入数字'); this.value='';this.focus();}" value="${postage }" /> 元
								</div>
								<div class="postage2   ${(postageType!='1')?'hide':'' }">
									<select class="layui-input" name="postageTempId" id="postageTempId">
										<option value="0">请选择</option>
										<c:forEach items="${tempList}" var="item">
												<option value="${item.id}" ${postageTempId eq item.id?'selected':''} >${item.templateName }</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
						
						<div class="layui-form-item  hasTime">
							<label class="layui-form-label"> 有效期：</label>
							<div class="layui-input-block">
								<input type="text" name="date" id="date" value="${endTime }"  placeholder="yyyy-MM-dd" autocomplete="off" class="layui-input" style="width: 288px; display: inline-block;"><span>留空则表示为长期有效</span>
							</div>
						</div>
						<c:if test="${ondemandId != null && ondemandId != '' }">
						<div class="layui-form-item  hasTime">
							<label class="layui-form-label"> 分享地址：</label>
							<div class="layui-input-block">
								<input type="text" value="${sharedAddress }/product/classDetail?ondemandId=${ondemandId }"class="layui-input" disabled >
							</div>
						</div>
						</c:if>
						<div class="layui-form-item">
							<label class="layui-form-label">状态：</label>
							<div class="layui-input-block">
								<input type="radio" name="open" value="1" title="上架"  ${status==1?'checked':'' } checked>
								<input type="radio" name="open" value="0" title="下架"  ${status==0?'checked':'' } >
							</div>
						</div>
						<input type="hidden" name="shangpin" id="shangpin"/>
						<input type="hidden" name="subType" id="subType"/>
						<input type="hidden" name="picUrl" id="picUrl" value="${picUrl }" />
				</form>
				</div>
			    <div class="hjzp">
			    	<div class="layui-form-item">
							<label class="layui-form-label">合辑图片：</label>
							<div class="layui-upload">
								<img src="${empty picUrl?'/manage/sumproduct/u17231.png':picUrl }" id="picUrlId" style="width: 166px;height: 194px;">
								<div class="xx_div">
									<button id="test1">选择文件</button> <!-- <img src="/manage/sumproduct/u17234.png"> -->
								</div>
							</div>
						</div>
			    </div>
			</div>
            <div class="layui-form-item" style=" padding-top:10px; margin-bottom:0;border-top: 1px solid #ccc;">

				<div class="layui-inline" style="padding-left:10px;">
					<a class="layui-btn layui-btn-normal choose" >选择商品</a>
				</div>
				<div class="layui-inline" style="float: right;">
					<!-- <a class="layui-btn layui-btn-normal set">批量设置优惠价</a> --> <a class="layui-btn layui-btn-normal del">批量移出</a>
					
				</div>
			
				<div style=" clear:both"></div>
			</div>
			
			<div class="hj_lb">
				<table width="100%" border="1" cellspacing="0" cellpadding="0" class="ondemandClass">
					<tr>
						<th><input  type="checkbox" id="box" onclick="changeChecBox()"></th>
						<th>商品编号</th>
						<th>商品名称</th>
						<!-- <th>原价</th> -->
						<!-- <th>优惠价</th> -->
						<th>操作</th>
					</tr>
					<tbody class="tbody">
						<c:forEach items="${list }" var="list">
							<tr style="text-align: center" id="del1${list.id }">
								<td><input type="checkbox" name="subBox" value="${list.ondemandId }"/></td>
								<td>${list.ondemandId }</td>
								<td>${list.name }</td>
								<%-- <td name="price">${list.presentPrice }</td> --%>
								<td><a onclick="deleteRow(this);" class="delhtml" data-id="del1${list.id }">
									<i class="layui-icon">移除</i></a>
								</td>
								<td name=price style="display:none">${list.originalPrice }</td><input type="hidden" name="subType" value="${list.subType }"/>
								<td name="xprice"><input type="hidden" name="xprice" value="${list.xprice }" onkeyup="value=value.replace(/[^\d\.]+?/g,'');" /></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="layui-form-item" style="text-align: center;">
				<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
			</div>
			<br>
				<br>
				<br>
				<br>
				<br>
				<br>
				<br>
				<br>
				<br>
				<br>
				<br>
				<br>
			
		</div>
		<input type="hidden" id="product">
</m:Content>
<m:Content contentPlaceHolderId="js">
		<script>
		$(".del").click(function(){
		/* 	if($("#edit").val()>0){
				return ;
			} */
			var length = $("input[name='subBox']:checked").length;
			if(length==0 || length==null){
				tipinfo("请选择要移除的商品！");
				return false;
			}
			$("input[name='subBox']:checked").each(function(){
				$(this).parents("tr:first").remove();
			})
			calcPrice1()
		})
		$(".set").click(function(){
			var length = $("input[name='subBox']:checked").length;
			if(length==0 || length==null){
				tipinfo("请选择合辑商品！");
				return false;
			}
			layer.prompt({
				  formType: 2,
				  value: 0,
				  title: '请输入价格',
				  area: ['100px', '50px'] //自定义文本域宽高
				}, function(value, index, elem){
					if(!value.match(/^-?\d+(\.\d+)?$/)){
						tipinfo("请输入正确的价格！")
						return false;
					}
					$("input[name='subBox']:checked").each(function(){
						$(this).parents("tr:first").find("input[name='xprice']").val(value);
					})
					calcPrice1()
				  layer.close(index);
				});
		})
		$(".choose").click(function(){
				/* if($("#edit").val()>0){
					return ;
				} */
				var classtype =$(':radio[name="classtype"]:checked').val();
				var array = []
				$("input[name='subBox']").each(function(){
					var ondemandId = $(this).val();
					array.push(ondemandId);
				})
				var ids = array.join(",");
				openwindow("/sumproduct/selOndemandByType?classtype="+classtype+"&ids="+ids,"选择课程",900,700,false,function(){
					var v = $("#product").val();
					if(v==''||v==null){
						return ;
					}
					var list=JSON.parse(v);
					var html = '';
					for(var i=0;i<list.length;i++){
						var item=list[i];
						var flag=ishas(item.ondemandId);
						if(flag){
							continue;
						}
						html+='<tr style="text-align: center;" id="del'+ (i+1) +'">';
						html+='<td><input type="checkbox" name="subBox" value="'+ item.ondemandId +'"/></td>';
						html+='<td>'+ item.ondemandId +'</td>';
						html+='<td>'+ item.name +'</td>';
						html+='<td><a onclick="deleteRow(this);" class="delhtml" data-id="del'+ (i+1) +'"><i class="layui-icon">移除</i></a></td>';
						html+='<td name=price style="display:none">'+item.price +'</td><input type="hidden" name="subType" value="'+item.type+'"/>'
						html+='<td style="display:none"><input type="hidden" name="xprice" value='+item.xprice+'></td>';
						html+='</tr>';
					}
					$(".tbody").append(html);
					//calcPrice1();
				})
			})
			function ishas(i){
				var flag=false;
				$("input[name='subBox']").each(function(){
					var id = $(this).val();
					if(i==id){
						flag=true;
						return;
					}
				})
				return flag;
			}
		
		
		var ue = UE.getEditor('editor', {
			"enterTag":"",
        	"initialFrameWidth":750,
        	"initialFrameHeight": 200,
       	 	"imageActionName": "uploadimage", /* 执行上传图片的action名称 */
       	    "imageFieldName": "upfile", /* 提交的图片表单名称 */
       	    "imageMaxSize": 2048000, /* 上传大小限制，单位B */
       	    "imageAllowFiles": [".png", ".jpg", ".jpeg", ".gif", ".bmp"], /* 上传图片格式显示 */
       	    "imageCompressEnable": false, /* 是否压缩图片,默认是true */
       	    "imageCompressBorder": 1600, /* 图片压缩最长边限制 */
       	    "imageInsertAlign": "none", /* 插入的图片浮动方式 */
       	    "imageUrlPrefix": "", /* 图片访问路径前缀 */
       	    "imagePathFormat": "/upload/content/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
       	                                /* {filename} 会替换成原文件名,配置这项需要注意中文乱码问题 */
       	                                /* {rand:6} 会替换成随机数,后面的数字是随机数的位数 */
       	                                /* {time} 会替换成时间戳 */
       	                                /* {yyyy} 会替换成四位年份 */
       	                                /* {yy} 会替换成两位年份 */
       	                                /* {mm} 会替换成两位月份 */
       	                                /* {dd} 会替换成两位日期 */
       	                                /* {hh} 会替换成两位小时 */
       	                                /* {ii} 会替换成两位分钟 */
       	                                /* {ss} 会替换成两位秒 */
       	                                /* 非法字符 \ : * ? " < > | */
       	                                /* 具请体看线上文档: fex.baidu.com/ueditor/#use-format_upload_filename */
       	                                
   			    	   /* 上传视频配置 */
   			    "videoActionName": "uploadvideo", /* 执行上传视频的action名称 */
   			    "videoFieldName": "upfile", /* 提交的视频表单名称 */
   			    "videoPathFormat": "/upload/content/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
   			    "videoUrlPrefix": "", /* 视频访问路径前缀 */
   			    "videoMaxSize": 1024000000000, /* 上传大小限制，单位B，默认100MB */
   			    "videoAllowFiles": [
   			        ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
   			        ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid"], /* 上传视频格式显示 */
       	        
       	        /* 上传文件配置 */
       	        "fileActionName": "uploadfile", /* controller里,执行上传视频的action名称 */
       	        "fileFieldName": "upfile", /* 提交的文件表单名称 */
       	        "filePathFormat": "/upload/content/{yyyy}{mm}{dd}/{time}{rand:6}", /* 上传保存路径,可以自定义保存路径和文件名格式 */
       	        "fileUrlPrefix": "", /* 文件访问路径前缀 */
       	        "fileMaxSize": 51200000, /* 上传大小限制，单位B，默认50MB */
       	        "fileAllowFiles": [
       	            ".png", ".jpg", ".jpeg", ".gif", ".bmp",
       	            ".flv", ".swf", ".mkv", ".avi", ".rm", ".rmvb", ".mpeg", ".mpg",
       	            ".ogg", ".ogv", ".mov", ".wmv", ".mp4", ".webm", ".mp3", ".wav", ".mid",
       	            ".rar", ".zip", ".tar", ".gz", ".7z", ".bz2", ".cab", ".iso",
       	            ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".pdf", ".txt", ".md", ".xml"
       	        ], /* 上传文件格式显示 */
       	        serverUrl: '/${applicationScope.adminprefix }/periodical/uploadimage'
       });
       
			//实时计算合集价格
		/* 	function calcPrice1(){
				
				$("td [name='xprice']").on("blur",function(){
					var v=$(this).val();

					if(v==""){
						return false;
					}
					
					var xtotalprice=0;
					$("input[name='subBox']").each(function(){
						var id = $(this).val();
						var xprice = $(this).parents("tr:first").find("input[name='xprice']").val();
						if(xprice==""){
							xprice=0;
						}
						xtotalprice+=parseFloat(xprice);
					})
					$("#xtotalprice").val(xtotalprice);
				})
				
			}
			function calcPrice1(){
				var xtotalprice=0;
				$("input[name='subBox']").each(function(){
					var id = $(this).val();
					var xprice = $(this).parents("tr:first").find("input[name='xprice']").val();
					if(xprice==""){
						xprice=0;
					}
					xtotalprice+=parseFloat(xprice);
				})
				$("#xtotalprice").val(xtotalprice);
			} */
			function deleteRow(obj){
			/* 	if($("#edit").val()>0){
					return ;
				} */
				var id = $(obj).data('id');
				$("#"+ id +"").remove();
				calcPrice1();
			}
			function changeChecBox(){
				$("#box").change(function(){
					$("input[name='subBox']").prop("checked",$("#box").val())
				})
			}
			//JavaScript代码区域
			layui.use(['element', 'layer','upload','form', 'laydate'], function() {
				var element = layui.element;
				var layer = layui.layer;
				var form = layui.form;
				var laydate = layui.laydate;
				var upload = layui.upload;
				//一些事件监听
				element.on('tab(demo)', function(data) {
					layer.msg('切换了：' + this.innerHTML);

				});

				laydate.render({
					elem: '#date',
					type: 'datetime'
				});

				 upload.render({
					    elem: '#test1'
					    ,url: '/${applicationScope.adminprefix }/book/uploadImgs'
						,field : 'imgUrl'
					    ,multiple: true
					    ,number : 0
					    ,before: function(obj){
					      //预读本地文件示例，不支持ie8
					      obj.preview(function(index, file, result){
					        /* $('#demo2').append(
				        		'<img src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img">'
			        		) */
					      });
					    }
					    ,done: function(res){
					    	/* $('#xx_div').append(
				        		'<div class="tpnr" id="'+ res.name +'"><img src="'+ res.data +'" class="mrt" onclick="del(\''+res.name+'\')"></div>'
			        		) */
			        		$("#picUrlId").attr("src",res.data);
			        		$("#picUrl").val(res.data);
					      //上传完毕
					    }
					  });

				//监听提交
				form.on('submit(addEqBtn)', function(data) {
					var $name=$("#name");
					var name=$name.val();
					var post = $(":radio[name=postageType]:checked").val();
					var classType = $("#classtype").val();
					if(classtype == '纸质期刊'){
						if(post==1){
							var id = $("select[name=postageTempId]").val();
							if(id<=0||id==''){
								tipinfo("请选择运费模板");
								return false;
							}
						}else{
							var postage = $("#postage").val();
							if(postage==''){
								tipinfo("请填写运费");
								return false;
							}
						}
					}
					if(name==""){
						$name.focus();
						tipinfo("请输入合集名称！",$name);
						return false;
					}
					var sortNo = $("#sortNo").val();
					if(sortNo==null || sortNo==""){
						tipinfo("请填写排序号！");
						return false;
					}
					var pic = $("#picUrl").val();
					if(pic==null || pic==""){
						tipinfo("请选择商品图片！");
						return false;
					}
					var xtotalprice = $("#xtotalprice").val();
					if(xtotalprice==null || xtotalprice==""){
						tipinfo("请填写合集价格");
						return false;
					}
					/* var flag=false;
					$("input[name='xprice']").each(function(){
						var price = $(this).val();
						if(price==""||!price.match(/^-?\d+(\.\d+)?$/)){
							$(this).focus();
							tipinfo("请输入正确的价格！",$(this));
							flsg=true;
							return false;
						}
					})
					if(flag){
						return false;
					} */
					var arr = [];
					var xtotalprice=$("#xtotalprice").val();
					var ytotalprice=0;
					var length = $("input[name='subBox']").length;
					if(length==0 || length==null){
						tipinfo("请选择合辑商品！");
						return false;
					}
					$("input[name='subBox']").each(function(){
						var id = $(this).val();
						var xprice = $(this).parents("tr:first").find("input[name='xprice']").val();
						var yprice = $(this).parents("tr:first").find("[name='price']").html();
						var subType = $(this).parents("tr:first").find("input[name='subType']").val();
						if(xprice==""){
							xprice=0;
						}
						if(yprice==""){
							yprice=0;
						}
						//xtotalprice+=parseFloat(xprice);
						ytotalprice+=parseFloat(yprice);
						arr.push({productId:id,price:xprice,subType:subType}); 
					})
					arr.join(",");
					$("#xtotalprice").val(xtotalprice);
					$("#ytotalprice").val(ytotalprice);
					$("#shangpin").val(JSON.stringify(arr));
					$("#subType").val(arr[0]["subType"]);
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
					ajax('/${applicationScope.adminprefix }/sumproduct/addOrUp',$("#form").serialize(),success, 'post', 'json');
					return false;
				});
				
				form.on('radio(type)', function(data){
					if(data.value==2){
						$(".qikan").css("display","");
						$(".hasTime").css("display","none");
						var post =$(":radio[name=postageType]checked").val();
						if(post==1){
							$(".postage1").css("display","none");
							$(".postage2").css("display","");
						}else{
							$(".postage1").css("display","");
							$(".postage2").css("display","none");
						}
					}else{
						$(".qikan").css("display","none");
						$(".hasTime").css("display","");
					}
					$(".tbody").html("");
					$("#product").val("");
					$("#xtotalprice").val("");
					$("#ytotalprice").val("");
					$("#shangpin").val("");
				});
				form.on('radio(postageType)', function(data){
					if(data.value==0){
						$(".postage1").css("display","");
						$(".postage2").css("display","none");
					}else{
						$(".postage1").css("display","none");
						$(".postage2").css("display","");
					}
				});
			});
			$(function() {	
				var type = $(":radio[name=classtype]:checked").val();
				var post = $(":radio[name=postageType]:checked").val();
				if(post==1){
					$(".postage1").css("display","none");
					$(".postage2").css("display","");
				}else{
					$(".postage1").css("display","");
					$(".postage2").css("display","none");
				}
				if(type==2){
					$(".qikan").css("display","");
					$(".hasTime").css("display","none");
				}else{
					$(".qikan").css("display","none");
					$(".hasTime").css("display","");
				}
			})
		</script>
</m:Content>
</m:ContentPage>
