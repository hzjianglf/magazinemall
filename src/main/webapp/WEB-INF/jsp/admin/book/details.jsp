<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
		<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
		<link rel="StyleSheet" href="/manage/select/css/multsel.css" type="text/css" />
		<style type="text/css">
.tpnr {
	width: 122px;
	height: auto;
	margin: 0 8px;
	float: left;
}

.xxk1 li, .xxk2 li {
	cursor: pointer;
}
</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<!-- 内容主体区域 -->
		<div class="cjts">
			<div class="cjts_top">
				<ul>
					<li>
						<a href="#">1.选择类别</a>
					</li>
					<li>
						<img src="/manage/images/index/u102.png" />
					</li>
					<li>
						<a href="#" class="on">2.填写详情</a>
					</li>
					<li>
						<img src="/manage/images/index/u102.png" />
					</li>
					<li>
						<a href="#">3.上传图片</a>
					</li>
					<li>
						<img src="/manage/images/index/u102.png" />
					</li>
					<li>
						<a href="#">4.商品发布</a>
					</li>
				</ul>
			</div>
			<form id="contentInfo">
				<div class="txxx">
					<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#bcbcbc">
						<tr>
							<td class="td1"><strong>商品基本信息</strong></td>
							<td class="td1">&nbsp;</td>
						</tr>
						<tr>
							<td align="right">商品分类：</td>
							<td>书刊杂志 > 期刊</td>
						</tr>
						<tr>
							<td align="right">杂志：</td>
							<td><select style="width: 400px" disabled><option>${perName}${contentMap.perName}</option></select></td>
						</tr>
						<tr>
							<td align="right"><em>*</em>年份：</td>
							<td>
								<!-- 期刊对应的年份 --> 
								<select style="width: 100px" id="Sel_Year" name="year">
									<c:forEach items="${yearList}" var="item">
										<option value="${item}" ${(selYear==item)?'selected':''}>${item}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
						<tr>
							<td align="right"><em>*</em>出版期次：</td>
							<td>
								<div class="xxk1 type">
									<ul>
										<li class="${(empty contentMap.sumType || contentMap.sumType==0)?'on':'' }">单期</li>
										<li class="${(contentMap.sumType>0)?'on':'' }">合集</li>
									</ul>
									<input type="hidden" id="perId" name="perId" value="${perId}" />
								</div>
								<div class="det_content2">
									<div>
										<select style="width: 125px" name="period" id="period">
											<option value="">请选择</option>
											<c:forEach items="${periodList }" var="p">
												<option value="${p.id }" ${p.id==contentMap.period?'selected':'' }>${p.year }年${p.describes}</option>
											</c:forEach>
										</select>
										<c:if test="${empty contentMap.id}">
											<input type="checkbox" id="Chk_All" onclick="selAll('${perId}',this)" />
											<label for="Chk_All">展示全部期次</label>
										</c:if>
									</div>
									<div class="hide">
										<select style="width: 125px" id="sumType" name="sumType">
											<option value="0" ${empty contentMap.sumType||contentMap.sumType==0?'selected':''}>请选择</option>
											<option value="1" ${contentMap.sumType==1?'selected':''}>上半年刊</option>
											<option value="2" ${contentMap.sumType==2?'selected':''}>下半年刊</option>
											<option value="3" ${contentMap.sumType==3?'selected':''}>全年刊</option>
										</select>
										<input   type="checkbox" ${contentMap.isShowAsProduct==null||contentMap.isShowAsProduct==1?'checked':''} id="Chk_isShowAsProduct" />
										<label for="Chk_isShowAsProduct">展示为商品</label>
										<input type="hidden" id="isShowAsProduct" name="isShowAsProduct" value="${contentMap.isShowAsProduct}">
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right"><em>*</em>杂志名称：</td>
							<td><input type="text" class="in1" style="width: 400px" id="name" value="${contentMap.name }" name="name" lay-verify="required" autocomplete="off" /></td>
						</tr>
						<c:if test="${contentMap.id != null && contentMap.id !='' }">
						<tr>
							<td align="right"><em>*</em>分享地址：</td>
							<td>${sharedAddress}/product/turnPublicationDetail?id=${contentMap.id }</td>
						</tr>
						</c:if>
						<tr>
							<td align="right"><em>*</em>原定价：</td>
							<td><input type="text" class="in1" style="width: 100px" name="originalPrice" value="${contentMap.originalPrice }" id="originalPrice" lay-verify="required" autocomplete="off" /> 元</td>
						</tr>
						<tr>
							<td align="right"><em>*</em>商城纸媒版价格：</td>
							<td>
								<input type="text" class="in1" style="width: 100px" name="paperPrice" value="${contentMap.paperPrice }" id="paperPrice" lay-verify="required" autocomplete="off" /> 元 
								<input class="check" style="margin-left: 15px;" type="checkbox" ${contentMap.isSalePaper==0?'checked':''} id="Chk_isSalePaper" /><label for="Chk_isSalePaper">不销售纸媒版</label> 
								<input type="hidden" id="isSalePaper" name="isSalePaper" value="${contentMap.isSalePaper}">
							</td>
						</tr>
						<tr>
							<td align="right"><em>*</em>商城电子版价格：</td>
							<td>
								<input type="text" class="in1" style="width: 100px;" readonly="readonly" name="ebookPrice" value="${contentMap.isSaleEbook==0?'':(contentMap.ebookPrice+'')}" id="ebookPrice" lay-verify="required" autocomplete="off" /> 元 
								<input class="check" style="margin-left: 15px;" type="checkbox" ${contentMap.isSaleEbook==0?'checked':''} id="Chk_isSaleEbook" /><label for="Chk_isSaleEbook">不销售电子版</label> 
								<span id="ebook" style="color: red; margin-left: 20px;">${ebook==1?'有电子书':'无电子书'}</span>
								<input type="hidden" id="isSaleEbook" name="isSaleEbook" value="${contentMap.isSaleEbook}">
							</td>
						</tr>
						<tr>
							<td align="right"><em>*</em>商品主图：</td>
							<td>
								<button type="button" class="layui-btn" id="test1">
									<i class="layui-icon">&#xe67c;</i>上传图片
								</button> <input type="hidden" value="${contentMap.picture }" name="picture" id="picture" />
								<div id="demo2">
									<div class="tpnr">
										<img src="${contentMap.picture==''?'/manage/images/index/u5091.png':contentMap.picture }" class="mrt" id="imgShow" />
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="td1"><strong>商品详情描述</strong></td>
							<td class="td1">&nbsp;</td>
						</tr>
						<tr>
							<td align="right">商品描述：</td>
							<td>
								<script id="editor" type="text/plain" name="describes" style="width: 100%; height: 500px;">
								${contentMap.describes }
								</script>
							</td>
						</tr>
						<tr>
							<td class="td1"><strong>库存设置</strong></td>
							<td class="td1">&nbsp;</td>
						</tr>
						<tr>
							<td align="right"><em>*</em>商品库存：</td>
							<td><input type="text" class="in1" style="width: 125px" name="stock" value="${contentMap.stock }" id="stock" lay-verify="required" autocomplete="off" /></td>
						</tr>
						<tr>
							<td class="td1"><strong>物流价格</strong></td>
							<td class="td1">&nbsp;</td>
						</tr>
						<tr>
							<td align="right">运费设置：</td>
							<td>
								<div class="xxk1 postageType">
									<ul>
										<li data-type="0" class="${(empty contentMap.postageType || contentMap.postageType=='0')?'on':'' }">固定运费</li>
										<li data-type="1" class="${(contentMap.postageType=='1')?'on':'' }">运费模板</li>
									</ul>
								</div> 
								<!-- 运费类型 --> 
								<input type="hidden" name="postageType" id="postageType" value="${(empty contentMap.postageType)?'0':contentMap.postageType }" />
								<div class="det_content2">
									<div class="${(contentMap.postageType=='1')?'hide':'' }">
										<input type="text" class="in1" style="width: 100px;" name="postage" id="postage" value="${contentMap.postage }" /> 元
									</div>
									<div class="${(contentMap.postageType!='1')?'hide':'' }">
										<select style="width: 200px" id="postageTempId" name="postageTempId">
											<option value="0">请选择</option>
											<c:forEach items="${tempList}" var="item">
												<option value="${item.id}" ${contentMap.postageTempId eq item.id?'selected':''} >${item.templateName }</option>
											</c:forEach>
										</select>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td class="td1"><strong>其他设置</strong></td>
							<td class="td1">&nbsp;</td>
						</tr>
						<tr>
							<td align="right">发布时间：</td>
							<td>
							<input type="radio" name="publishType" value="0" ${empty contentMap.publishType  ||contentMap.publishType==0?'checked':''} checked="checked" />立即发布 
							<input type="radio" name="publishType" value="1" ${contentMap.publishType==1?'checked':''}/> 定时发布 
							<input type="text" class="in1 rl_in" style="width: 118px" value="${contentMap.publishType==1?contentMap.publishTime:''}" name="publishTime" id="publishTime" ${empty contentMap.publishType  ||contentMap.publishType==0?'disabled':''} /></td>
						</tr>
						<tr>
							<td align="right">推荐商品：</td>
							<td>
								<div class="xxk2">
									<ul>
										<li class="${(contentMap.isTop=='0' || empty contentMap.isTop)?'on':'' }" data-state="0">不推荐</li>
										<li class="${contentMap.isTop=='1'?'on':'' }" data-state="1">推荐</li>
									</ul>
								</div> <input type="hidden" name="isTop" id="isTop" value="${(empty contentMap.isTop)?'0':contentMap.isTop }" />
							</td>
						</tr>
						<tr>
							<td align="right">标签设置：</td>
							<td>
								<!-- <input type="text" class="in1" style=" width:300px" /> --> <%-- <select style=" width:300px" name="label">
						    		<option>请选择</option>
						    		<c:forEach items="${labelList }" var="labelList">
						    			<option value="${labelList.name }" ${contentMap.label==labelList.name?'selected':'' }>${labelList.name }</option>
						    		</c:forEach>
						    	</select> --%>
	    						<input type="hidden" name="label" id="label" value="${contentMap.label }" />
								<div class="multsel" defval="0" style="width: 45%">
									<span class="view">${(empty contentMap.label)?'请选择...':contentMap.label }</span>
									<div class="selist">
										<c:forEach items="${labelList }" var="item">
											<a class="seitem" value="${item.name }">${item.name }</a>
										</c:forEach>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">展示排序：</td>
							<td><input type="text" class="in1" style="width: 100px;" id="sortNo" name="sortNo" value="${empty contentMap.sortNo?0:contentMap.sortNo}" lay-verify="required" autocomplete="off" /> <span>数值越大排序越靠前</span></td>
						</tr>
					</table>
				</div>
				<input type="hidden" value="${contentMap.id }" name="id">
				<!-- 商品类别 -->
				<input type="hidden" name="protype" id="protype" value="${protype }" />
			</form>
			<input type="button" class="xyb_nr" onclick="submit()" value="下一步">
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.js"></script>
		<script type="text/javascript" src="/manage/select/js/multsel.js"></script>
		<script type="text/javascript">
		$(function(){
			
			$(window).on("resize",function(){
				var height=$(window).height();
				if(height>400){
					$("div.txxx").css({"height": (height-130)+"px"});
				}
				var width=$(window).width();
				if(width<1000){
					$("div.txxx").css({"width": (width-80)+"px"});
				}
				
			}).trigger("resize");
			
			 //样式选中
            $('.postageType').find('li').click(function () {
            	$(this).addClass("on").siblings().removeClass("on");
                var $td=$(this).parents("td:first");
                $('.det_content2',$td).children('div').hide();
                $('.det_content2',$td).children('div').eq($(this).index()).show();
                //获取选中的类型
                var type = $(this).data('type');
                $("#postageType").val(type);
            });
			 
          	//样式选中
            $('.xxk2').find('li').click(function () {
                $('.xxk2').find('li').removeClass('on');
                $(this).addClass('on');
                var va=$(this).data('state');
                $("#isTop").val(va);
            });
			
          	$("#period").on("change",function(){
          		$("#name").val("");
          		var v=$(this).val();
    			if(v==""){
    				tipinfo("请选择刊物期次！");
    				return false;
    			}
    			var text=$(this).find("option:selected").html();
    			$("#name").val('${perName}${contentMap.perName}'+text);
    			//查询当前期次下是否有电子书
    			selectEbook();
          	})
          	$("#sumType").on("change",function(){
          		$("#name").val("");
          		var  v=$(this).val();
          		if(v==''){
          			tipinfo("请选择合集类型！");
          			return false;
          		}
          		var year=$("#Sel_Year").val();
  				var sumType=$("#sumType option:selected").html();
  				$("#name").val('${perName}${contentMap.perName}'+year+"年"+sumType+"合集");
  				//判断有没有电子书
      			checkEbookForSum();
          	})
          	
          	$("div.type li").on("click",function(){
          		$(this).addClass("on").siblings().removeClass("on");
          		var $td=$(this).parents("td:first");
          		if($(this).text()=="单期"){$('#Chk_isSalePaper').attr("checked",false).hide().next().hide();
          		$('#Chk_isSaleEbook').hide().attr("checked","checked").next().css("color","orange").html("要是为0,则是免费")};
          		if($(this).text()=="合集"){$('#Chk_isSalePaper').attr("checked",false).show().next().show();
          		$('#Chk_isSaleEbook').show().attr("checked",false).next().css("color","#000").html("不销售电子版")};
          		$('.det_content2',$td).children('div').hide();
                $('.det_content2',$td).children('div').eq($(this).index()).show();
               /*  $("#Chk_isSalePaper").change();
                $("#Chk_isSaleEbook").change(); */
          	});
          	$("#Chk_isShowAsProduct").on("change",function(){
          		$("#isShowAsProduct").val($(this).is(":checked")?1:0);
          	})
          	$("#Chk_isSalePaper").on("change",function(){
          		if($(this).is(":checked")){
      				$("#paperPrice").val("").attr("readonly","readonly");
      				$("#isSalePaper").val(0);
      			}else{
      				$("#paperPrice").removeAttr("readonly");
      				$("#isSalePaper").val(1);
      			}
          	})
          	$("#Chk_isSaleEbook").on("change",function(){
          		if($(this).is(":checked")){
      				$("#ebookPrice").val("").attr("readonly","readonly");
      				$("#isSaleEbook").val(0);
      			}else{
      				$("#ebookPrice").removeAttr("readonly");
      				$("#isSaleEbook").val(1);
      			}
          	})
          	
           //编辑时自动查找对应的电子书
           var bookId="${contentMap.id }";
           if(bookId!=""){
        	   $("div.type li.on").click();
        	   
        	   var type="${contentMap.sumType}";
        	   if(type==0||type==""){
        		   selectEbook();
        	   }else{
        		   //checkEbookForSum();
        	   }
           }
          	
          	$("#Sel_Year").on("change",function(){
          		var v=$(this).val();
          		if(v==""){
          			$("#period>option:gt(0)").remove();
          		}else{
          			//获取对应年份的期次列表
          			selectIssue(${perId},2,v);
          		}
          	});
          	
			var ebook = '${ebook}';
			if(ebook=='1'){
				$("#ebookPrice").removeAttr('readonly');
			}
			
			multselInit();
			//获取标签值
			var label = $("#label").val();
			var strs = label.split(",");
			//获取所有的标签
			$('a.seitem').each(function(obj){
				for(var i=0;i<strs.length;i++){
					if($(this).attr("value") == strs[i]){
						$(this).addClass("checked");
					}
				}
			})
		})
		layui.use('laydate',function(){
			var laydate=layui.laydate;
			laydate.render({
		   		elem: '#publishTime',
		   		type:'datetime'
		  	});
		})
		$("input[name='publishType']").click(function(){
			var v=$(this).val();
			if(v==1){
				$("#publishTime").removeAttr('disabled');
			}else{
				$("#publishTime").val('');
				$("#publishTime").attr('disabled','disabled');
			}
		})
		function submit(){
			var $year=$("#Sel_Year");
			if($year.val()==""){
				$("#period").focus();
				tipinfo("请选择年份！","#Sel_Year");
				return false;
			}
			
			var index=$(".type li.on").index();
			if(index==0){
				$("#sumType").val(0);
				var $period=$("#period");
				if($period.val()==""){
					$("#period").focus();
					tipinfo("请选择刊物期次！","#period");
					return false;
				}
			}else{
				var $sumType=$("#sumType");
				if($sumType.val()=="0"){
					$("#sumType").focus();
					tipinfo("请选择合集类型！","#sumType");
					return false;
				}
			}
			
			var $name=$("#name");
			if($name.val()==""){
				$("#name").focus();
				tipinfo("请输入杂志名称！","#name");
				return false;
			}
			
			var $originalPrice=$("#originalPrice");
			if($originalPrice.val()==""){
				$("#originalPrice").focus();
				tipinfo("请输入原定价！","#originalPrice");
				return false;
			}
			
			if($("#Chk_isSalePaper").is(":checked")&&$("#Chk_isSaleEbook").is(":checked")){
				tipinfo("请至少销售纸媒版、电子版中一种！");
				$("#Chk_isSalePaper").focus();
				return false;
			}
			
			if(!$("#Chk_isSalePaper").is(":checked")){
				var $paperPrice=$("#paperPrice");
				if($paperPrice.val()==""){
					$("#paperPrice").focus();
					tipinfo("请输入商城纸媒版价格！","#paperPrice");
					return false;
				}
			}
			if(!$("#Chk_isSaleEbook").is(":checked")){
				if(!$("#ebookPrice").attr("readonly")){
					var $ebookPrice=$("#ebookPrice");
					if($ebookPrice.val()==""){
						$("#ebookPrice").focus();
						tipinfo("请输入商城电子版价格！","#ebookPrice");
						return false;
					}
				}
			}
			
			var $picture=$("#picture");
			if($picture.val()==""){
				$("#test1").focus();
				tipinfo("请上传商品主图！","#test1");
				return false;
			}
			
			var $stock=$("#stock");
			if($stock.val()==""){
				$("#stock").focus();
				tipinfo("请输入商品库存！","#stock");
				return false;
			}
		
			loading(true);
			
			$.post("/${applicationScope.adminprefix }/book/adds",$("#contentInfo").serialize(),function(obj){
				loading();
				if(obj.success){
					location.href="/${applicationScope.adminprefix }/book/pic?id="+obj.id;
				}else{
					alertinfo(obj.msg,false);
				}
			},"json").error(function(){
				loading();
				alertinfo("请稍候再试！",false);
			})
			
		}
		
		//查询单期有无电子书
		function selectEbook(){
			var issue=$("#period").val();
			if(issue==''){
				return false;
			}
			$.ajax({
				type:'post',
				url:'/${applicationScope.adminprefix }/book/selectEbook',
				data:{"issue":issue},
				datatype:'json',
				success:function(data){
					if(data.success){
						$("#ebook").text("有电子书");
						$("#ebookPrice").removeAttr('readonly');
					}else{
						$("#ebook").text("无电子书");
						$("#ebookPrice").attr('readonly','readonly');
						$("#ebookPrice").val('');
					}
				},
				error:function(){
					alert("出错了!");
				}
			})
		}
		//检查合集是否有电子书
		function checkEbookForSum(){
			
			var type=$("#sumType").val();
			var year=$("#Sel_Year").val();
			if(type==''||year==''){
				return false;
			}
			
			$.ajax({
				type:'post',
				url:'/${applicationScope.adminprefix }/book/selectEbookForSum',
				data:{
					type:type,
					perId:${perId},
					year:year,
					r:Math.random()
				},
				datatype:'json',
				success:function(data){
					if(data.success){
						$("#ebook").text("有电子书");
						$("#ebookPrice").removeAttr('readonly');
					}else{
						$("#ebook").text("无电子书");
						$("#ebookPrice").attr('readonly','readonly');
						$("#ebookPrice").val('');
					}
				},
				error:function(){
					alert("出错了!");
				}
			})
		}
       /**文本编辑器**/
       //实例化编辑器
       //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
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
				var postData = $(data.form).serialize();
				var num = Math.random();
				ajax('/${applicationScope.adminprefix }/book/adds', postData, success, 'post', 'json');
				return false;
			})

			//执行实例
			var uploadInst = upload.render({
				elem : '#test1', //绑定元素
				url: '/${applicationScope.adminprefix }/book/uploadImg', //上传接口
				field : 'imgUrl',
				before : function(obj) {
					//预读本地文件，如果是多文件，则会遍历。(不支持ie8/9)
					obj.preview(function(index, file, result) {
						//index 得到文件索引  file 得到文件对象  result 得到文件base64编码，比如图片
						$("#imgShow").show();
						$("#imgShow").attr("src", result);
						//这里还可以做一些 append 文件列表 DOM 的操作
						//obj.upload(index, file); //对上传失败的单个文件重新上传，一般在某个事件中使用
						//delete files[index]; //删除列表中对应的文件，一般在某个事件中使用
					});
				},
				done : function(res) {
					//上传完毕回调
					$('#picture').val(res.data);
				},
				error : function() {
					//请求异常回调
				}
			});
		})
		function selAll(perId,obj){
			var check = $(obj).is(":checked");
			var year=$("#Sel_Year").val();
			if(check){
				//显示所有期次
				selectIssue(perId,1,year);
			}else{
				//只显示部分期次
				selectIssue(perId,2,year);
			}
		}
		function selectIssue(perId,type,year){
			$.ajax({
				type:'post',
				url:'/${applicationScope.adminprefix }/book/selectIssue',
				data:{
					"type":type,
					"perId":perId,
					"year":year
					},
				datatype:'json',
				success:function(data){
					//period
					var list=data.list;
					$("#period").empty();
					var html='<option>请选择</option>';
					for(var i=0;i<list.length;i++){
						html+='<option value="'+list[i].id+'">'+list[i].year+'年'+list[i].describes+'</option>';
					}
					$("#period").append(html);
				},
				error:function(){
					alert("出错了!");
				}
			})	
		}
</script>
	</m:Content>
</m:ContentPage>
