<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<!-- <link rel="stylesheet" href="/manage/public/css/layui_public/layui_dyx.css"/> -->
	<link href="/manage/public/ondemand/css/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/ondemand/css/index.css" rel="stylesheet" type="text/css" />
	<link rel="StyleSheet" href="/manage/select/css/multsel.css" type="text/css"/>
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-table-cell{
			height:100%;
			max-width: 100%;
		}
		#echoImg img{
			width:100px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
<div class="kc_top">
	<img src="${(empty tMsg.userUrl)?'/manage/public/ondemand/images/1.png':tMsg.userUrl }"  class="tx_img" />
	<P ><span class="p1">课程：${findById.name }</span><br /><span class="p2">教师：${tMsg.realname == null?tMsg.nickName:tMsg.realname }</span></P>
	<c:if test="${findById.status=='-1' }"><span class="wfb_biao"><span>未发布</span></span></c:if>
</div> 
<div class="kc_left">
	<ul>
		<li>
			<h3>课程信息</h3>
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=1&ondemandId=${findById.ondemandId }&classtype=${classtype}" class="on">基本信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=2&ondemandId=${findById.ondemandId }&classtype=${classtype}">详细信息</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=3&ondemandId=${findById.ondemandId }&classtype=${classtype}">课程图片</a> 
			<a href="/${applicationScope.adminprefix }/ondemand/insert?page=4&ondemandId=${findById.ondemandId }&classtype=${classtype}">课时管理</a> 
			<!-- <a href="#">文件管理</a> --> 
		</li>
		<li>
		    <h3>课程设置</h3>
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=6&ondemandId=${findById.ondemandId }&classtype=${classtype}">价格设置</a> 
		    <a href="/${applicationScope.adminprefix }/ondemand/insert?page=7&ondemandId=${findById.ondemandId }&classtype=${classtype}">授课教师</a> 
		</li>
	<!-- 	<li>
		    <h3>课程运营</h3>
		    <a href="#">课程学习数据</a> 
		    <a href="#">课程订单查询</a> 
		</li> -->
	</ul>
</div>
<div class="kc_center">
	<div class="kc_nr">
		<h2>基本信息</h2>
		<form id="saveBasic">
		<input type="hidden" name="release" id="release" />
		<input type="hidden" name="ondemandId" value="${findById.ondemandId }" />
		<!-- 课程类型 -->
		<input type="hidden" name="classtype" id="classtype" value="${classtype }" />
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
		    	<td align="right"><strong>课程名称</strong></td>
		    	<td><input type="text" class="in1" name="name" value="${findById.name }"/></td>
		  	</tr>
		 	<tr>
			    <td align="right"><strong>副标题</strong></td>
			    <td><input type="text" class="in1" name="title" value="${findById.title }"/></td>
		  	</tr>
		  	<tr>
			    <td align="right"><strong>标签</strong></td>
			    <td>
			    	<input type="hidden" name="label" id="label" value="${findById.label }"/>
			    	<div class="multsel" defval="0" style="width:45%">
						<span class="view">${(empty findById.label)?'请选择...':findById.label }</span>
						<div class="selist">
							<c:forEach items="${labelList }" var="labelList">
								<a class="seitem" value="${labelList.name }">${labelList.name }</a>
							</c:forEach>
						</div>
					</div>
					<p>将会应用于按标签搜索课程、相关课程的提取等</p>
			    </td>
		  	</tr>
		  	<c:if test="${ondemandId != null && ondemandId != '' }">
		  	<tr>
			    <td align="right"><strong>分享地址</strong></td>
			    <td>${sharedAddress}/product/classDetail?ondemandId=${ondemandId }</td>
		  	</tr>
		  	</c:if>
		  	<c:if test="${classtype=='0' }">
			  	<tr>
				    <td align="right"><strong>连载状态</strong></td>
				    <td><input type="radio" name="serialState" value="0" ${findById.serialState=='0'?'checked':'' } /> 非连载课程 <input type="radio" name="serialState" value="1" ${findById.serialState=='1'?'checked':'' }/> 更新中
					<input type="radio" name="serialState" value="2" ${findById.serialState=='2'?'checked':'' }/> 已完结</td>
			  	</tr>
		  	</c:if>
		  	<tr>
			    <td align="right"><a href="#">分类</a></td>
			    <td>
			    	<select name="type">
			    		<c:forEach items="${typeList }" var="list">
			    			<option value="${list.id }" ${list.id==findById.type?'selected':'' }>${list.name }</option>
			    		</c:forEach>
			    	</select>
			    </td>
		  	</tr>
		  	<tr>
			    <td align="right"><a href="#">是否统计</a></td>
			    <td>
			    	<select name="isStatistical">
			    		<option value="0" ${findById.isStatistical==0?'selected':'' }>统计</option>
			    		<option value="1" ${findById.isStatistical==1?'selected':'' }>不统计</option>
			    	</select>
			    </td>
		  	</tr>
		  	<tr>
			    <td align="right"><a href="#">展示排序:</a></td>
			    <td>
			    	<input type="text" name="sortNo" style="width: 100px;" class="in1" value="${findById.sortNo }"/> <span>数值越大排序越靠前</span>
			    </td>
		  	</tr>
		  	<tr>
			    <td align="right"><a href="#">上传轮播图</a></td>
			    <td>
			    	<div class="layui-upload">
						<button type="button" class="layui-btn" id="uploadImgs">
							<i class="layui-icon">&#xe67c;</i>多图片上传
						</button>
						<button type="button" class="layui-btn" id="clearImg">
							<i class="layui-icon">&#xe640;</i>清空</button>
						<blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
							 预览图：
							<div class="layui-upload-list" id="echoImg">
								<!-- 数据回显 -->
								<c:forEach var="imgurl"	items="${findById.imgUrls }">
									<img alt="" src="${imgurl }">
								</c:forEach>
							</div>
						</blockquote>
					</div>
			    </td>
		  	</tr>
		  	<tr>
			    <td>&nbsp;</td>
			    <td align="right"><input type="button" value="存草稿" lay-submit lay-filter="draft" class="czg_biao" /><input type="button" lay-submit lay-filter="next" value="下一步" class="xyb_biao" /></td>
		  	</tr>
		</table>
		</form>
	</div>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/select/js/multsel.js"></script>
	<script type="text/javascript">
		$(function(){
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
		//下一步,保存信息
		layui.use(['form','upload','jquery'], function(){
			var form = layui.form,
			upload = layui.upload,
			$ = layui.jquery;
			
			form.on('submit(next)', function(data){
				var success = function(response){
					if(response.success){
						var classtype = $("#classtype").val();
						window.location.href = '/${applicationScope.adminprefix }/ondemand/insert?ondemandId='+response.ondemandId+'&page=2'+'&classtype='+classtype;
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				var str = jQuery.param({imgUrls:JSON.stringify(arrImg).toString()});
				ajax('/${applicationScope.adminprefix }/ondemand/addBasic', postData + "&" + str, success, 'post', 'json');
				return false;
			});
			form.on('submit(draft)', function(data){
				$("#release").val('0');
				var success = function(response){
					if(response.success){
						var classtype = $("#classtype").val();
						window.location.href = '/${applicationScope.adminprefix }/ondemand/list?classtype='+classtype;
					}else{
						layer.alert(response.msg, {icon: 2}, function(){
							layer.closeAll();
						})
					}
				}
				var postData = $(data.form).serialize();
				var str = jQuery.param({imgUrls:JSON.stringify(arrImg).toString()});
				ajax('/${applicationScope.adminprefix }/ondemand/addBasic', postData + "&" + str, success, 'post', 'json');
				return false;
			});
			//回显的数据集合
			var arrImg = [];
			//上传个数的限制
			var imgNum = 4;
			//文件上传
			upload.render({
				elem: '#uploadImgs'
				,url: '/${applicationScope.adminprefix }/book/uploadImg'
				,field : 'imgUrl'
				,multiple: true
				,before: function(obj){
					//预读本地文件示例，不支持ie8 ， 上传文件不能超过4个
					obj.preview(function(index, file, result){
						if($('#echoImg img').length < imgNum){
							$('#echoImg').append('<img src="'+ result +'" alt="'+ file.name +'" class="layui-upload-img">')
						}else{
							layer.msg("上传图片不能超过4张")
						}
					});
				}
				,done: function(res){
					//上传完毕 数据保存到页面中
					var imgUrl = res.data;
					if(arrImg.indexOf(imgUrl)==-1 && arrImg.length < imgNum){
						arrImg.push(imgUrl);
					}
				}
			});
			
			//获取回显的数据下的img路劲
			function pushImgEl(){
				var imgEl = JSON.parse('${findById.imgUrlsEl }');
				for ( var i = 0 ; i <imgEl.length ; i++ ){
					arrImg.push(imgEl[i]);
				}
			}
			
			$(function(){
				//回显的数据放到页面中去
				pushImgEl();
			})
			
			//清空上传的数据
			$('#clearImg').click(function(){
				$('#echoImg').html("");
				arrImg.length= 0;
			});

		})
	</script>
</m:Content>
</m:ContentPage>
