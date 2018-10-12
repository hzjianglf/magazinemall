<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		body{
			height: 100%;
		}
		.layui-form-mid {
			margin-left: 10px;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
<div class="cjts">
<form action="/${applicationScope.adminprefix }/book/details" method="post">
  <div class="cjts_top">
    <ul>
      <li><a href="#" class="on">1.选择类别</a></li>
      <li><img src="/manage/images/index/u102.png"/></li>
      <li><a href="#">2.填写详情</a></li>
      <li><img src="/manage/images/index/u102.png" /></li>
      <li><a href="#">3.上传图片</a></li>
      <li><img src="/manage/images/index/u102.png" /></li>
      <li><a href="#">4.商品发布</a></li>
    </ul>
  </div>
  <div class="cjts_di">
    <div class="cjts_xc">
      <div class="cjts_nr">
        <ul class="itemList ul1">
          <li onclick="btshow1(this)">书刊杂志</li>
        </ul>
      </div>
      <div class="cjts_nr">
        <ul class="itemList ul2">
        	<c:forEach items="${fenlei }" var="fenlei">
         		<li onclick="btshow2(this)">${fenlei.name }</li>
            </c:forEach>
        </ul>
      </div>
      <div class="cjts_nr">
        <ul class="itemList ul3">
        	<c:forEach var="list" items="${list }">
         		<li onclick="btshow3(this,${list.id },'${list.name }')">${list.name }</li>
        	</c:forEach>
        </ul>
      </div>
      <div class="clear"></div>
    </div>
    <div class="zx_nr">
      <strong>您当前选择的商品类别是：</strong><span id="s1"></span>  <span id="s2"></span>  <span id="s3"></span>           
    </div>
    <input type="hidden" name="perId" value="" id="perId">
    <input type="hidden" name="name" value="" id="name">
    <!-- 选择的商品类别 -->
    <input type="hidden" name="protype" id="protype" />
    <input type="submit" value="下一步" id="nextStep" class="xyb_nr">
  </div>
  </form>
</div>
<m:Content contentPlaceHolderId="js">
	<script src="/manage/public/js/jquery.js"></script>
<script>
	$(function(){
		$("#nextStep").prop("disabled",true);
	})
	$(".itemList li").click(function(){
		$(this).addClass("on").siblings().removeClass("on");
		if($(".ul3 li.on").length !== 0 && $(".ul2 li.on").length !== 0 && $(".ul1 li.on").length !== 0){
			$("#nextStep").prop("disabled",false);
		}	
	})
	function btshow1(select){
		var value=select.innerText
		document.getElementById("s1").innerHTML=value;
	}
	function btshow2(select){
		var value=select.innerText
		document.getElementById("s2").innerHTML=">"+value;
		//期刊1	 报纸2	 图书3
		if(value == '期刊'){
			$("#protype").val("1");
			$(".ul3").show();
		}else if(value == '报纸'){
			$("#protype").val("2");
			$(".ul3").hide();
		}else{
			$("#protype").val("3");
			$(".ul3").hide();
		}
	}
	function btshow3(select,perId,name){
		var value=select.innerText
		document.getElementById("s3").innerHTML=">"+value;
		document.getElementById("perId").value=perId;
		document.getElementById("name").value=name;
	}
</script>

</m:Content>
</m:Content>
</m:ContentPage>
