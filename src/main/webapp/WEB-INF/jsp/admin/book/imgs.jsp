<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		.tpnr {
		    width: 122px;
		    height: auto;
		    margin: 0 8px;
		    float: left;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
<div class="cjts">
  <div class="cjts_top">
    <ul>
      <li><a href="#" >1.选择类别</a></li>
      <li><img src="/manage/images/index/u102.png" /></li>
      <li><a href="#" >2.填写详情</a></li>
      <li><img src="/manage/images/index/u102.png" /></li>
      <li><a href="#" class="on">3.上传图片</a></li>
      <li><img src="/manage/images/index/u102.png" /></li>
      <li><a href="#">4.商品发布</a></li>
    </ul>
  </div>
  <div class="sptp">
    <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#bcbcbc">
  <tr>
    <td colspan="5" class="td1"><strong>商品图片</strong> <input type="hidden" value="${id }"></td>
    </tr>
  <tr>
    <td>
    	<!-- <div class="tpnr">
    		<div class="zt_nr">
    			<img src="/manage/images/index/mrt_zt.jpg" />
    			<P><img src="/manage/images/index/mrzt_biao.gif" />默认主图</P>
   			</div>
   			<div class="px">
   				<span>排序：<em>0</em></span>
   				<input type="button" value="上传"  class="sc_biao" />
			</div>
		</div> -->
		<div class="layui-upload">
		  <button type="button" class="layui-btn" id="test1">图片上传</button> 
		  <!-- <blockquote class="layui-elem-quote layui-quote-nm" style="margin-top: 10px;">
		    预览图：
		    <div class="layui-upload-list" id="demo2"></div>
		 </blockquote> -->
		</div>
		<div id="demo2">
			<c:forEach var="d" items="${delList }" varStatus="v">
				<div class="tpnr" id="ds${v.index }">
		  			<img src="${d }" class="mrt" onclick="del('ds${v.index }')"/>
				</div>
			</c:forEach>
		</div>
	</td>
  </tr>
</table>

  </div>
  <form id="contentInfo" class="layui-form" method="post">
  <button id="nextStep" class="xyb_nr" lay-submit lay-filter="saveBtn">下一步,确认商品发布 </button>
  <input type="hidden" name="pictureUrl" id="pictureUrl" value="">
  <input type="hidden" name="id" id="id" value="${id }">
  </form>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script src="/manage/public/js/jquery.js"></script>
<script type="text/javascript">
		function del(id){
			layer.confirm("确定删除当前图片吗？", {icon: 7}, function(){
				layer.alert("删除成功！",{icon: 1});
				$('#'+id).remove();
				
			})
		}
		function sb(){
			$.ajax({
				type:"post",
				data:$("#contentInfo").serialize(),
				url:"/${applicationScope.adminprefix }/book/adds",
				success:function(data){
					if(data.success){
		        		location.href='/${applicationScope.adminprefix }/book/imgs?id='+data.id;
		    		}else{
		    			var txt= data.message;
		    			alertNew(txt,false);
		    		}
				},
				error:function(data){
	    			alertNew("系统异常",false);
				}
			})
		}
	
	
       
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
				var num = Math.random();
				var imgs = $('#demo2 img');
				var arr = [];
				for(var i=0;i<imgs.length;i++){
				   arr.push($(imgs[i]).attr('src'))
				}
				document.getElementById("pictureUrl").value=arr;

				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/book/upPictureUrl', postData, success, 'post', 'json');
				return false;
			})
			//多图片上传
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
			    	$('#demo2').append(
		        		'<div class="tpnr" id="'+ res.name +'"><img src="'+ res.data +'" class="mrt" onclick="del(\''+res.name+'\')"></div>'
	        		)
			      //上传完毕
			    }
			  });
	
		})
</script>
</m:Content>
</m:ContentPage>
