<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px" %>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
<link href="/manage/logistics/layui/css/layui.css" rel="stylesheet" />
	
	<style>
		.spanSty {
			display: inline-block;
			width: 25px;
			height: 25px;
			background-color: rgba(215, 215, 215, 1);
			text-align: center;
			line-height: 25px;
			font-size: 14px;
		}
	</style>

</m:Content>
<m:Content contentPlaceHolderId="content">
	<!-- 内容主体区域 -->
<div class="cbjh">
<form id="subForm" action="/${applicationScope.adminprefix }/finance/cents/saveSetUpInfo" enctype="multipart/form-data">
<input type="hidden" name="userId" id="userId" value="${userId}">
  <div class="dkyx_jbxx">
    <h3>作家信息</h3>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>ID : ${userId} </td>
        <td>姓名 : ${realname} </td>
        <td>账号 : ${userName} </td>
        <td>手机 : ${telenumber} </td>
      </tr>
    </table>
  </div>
  <div class="fc_nr">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>问答分成：
          <input type="text" class="in1" id="questionRate" name="questionRate" value="${questionRate}"/>
          <span>%</span>
         </td>
        <td>打赏分成：
          <input type="text" class="in1" id="rewardRate" name="rewardRate" value="${rewardRate}" />
          <span>%</span>
         </td>
      </tr>
    </table>
  </div>
  <div class="layui-form" style="height:298px; overflow:auto" >

  <table class="layui-table" lay-skin="line">
    <colgroup>
      
    </colgroup>
    <thead>
      <tr>
        <th>课程编号</th>
        <th>课程名称</th>
        <th>课程现价</th>
        <th>状态</th>
        <th>分成比例</th>
      </tr> 
    </thead>
    <tbody>
      <c:forEach items="${list}" var="list">
      	 <tr>
	        <td>${list.number}</td>
	        <td>${list.name }</td>
	        <td><span style="color:#FF6633">￥${list.presentPrice}</span></td>
	        <td>${list.status}</td>
	        <td><input type="text" value="${list.rate}" class="in1" id="classinfo_${list.ondemandId}" name="classinfo_${list.ondemandId }" style="width:35px;text-align: center;" /><span class="spanSty">%</span></td>
	      </tr>
      </c:forEach>			
    </tbody>
  </table>
</div>
</form>
<div class="layui-form-item" style="text-align: center;">
	<button class="layui-btn" style="width: 50%;margin-top: 60px;" id="closeWindow" onclick="saveSetUpinfo();">保存</button>
</div>
</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
<script src="/manage/public/js/jquery.form.min.js"></script>
	<script>
		function saveSetUpinfo(){
			$("#subForm").ajaxSubmit({
				success: function (data) {
					if(data.result){
						layer.msg(data.msg,{icon: 1});
						 closewindow();
					}else{
						layer.msg(data.msg,{icon: 2});
					}
			     }
			})
		}
	</script>
</m:Content>
</m:ContentPage>
