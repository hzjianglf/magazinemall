<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
	<link href="/manage/public/css/layui_public/default.css" rel="stylesheet" type="text/css" />
	<link href="/manage/public/css/layui_public/index.css" rel="stylesheet" type="text/css" />
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<div class="cbjh">
		  <div class="dkyx_jbxx">
		    <h3>作家信息</h3>
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		        <td>ID : ${userCode } </td>
		        <td>姓名 : ${realname } </td>
		        <td>账号 : ${userName } </td>
		        <td>手机 : ${telenumber } </td>
		      </tr>
		    </table>
		  </div>
		  <div class="fc_nr">
		    <table width="100%" border="0" cellspacing="0" cellpadding="0">
		      <tr>
		        <td>问答分成：
		          <input type="text" class="in1" style="width:80px" id="questionRate" name = "questionRate" value="${questionRate }" />
		          <span>%</span></td>
		        <td>打赏分成：
		          <input type="text" class="in1" style="width:80px"  id="rewardRate" name = "rewardRate" value="${rewardRate }"/>
		          <span>%</span></td>
		      </tr>
		    </table>
		  </div>
		<div class="layui-form">
			<table class="layui-table" id="division" lay-filter="tableContent"></table>
		</div>
		<script type="text/html" id="demo">
			<input type="text" style="width:50px" onkeyup="value=value.replace(/[^\d\.]+?/g,'')" class="rate" name = "rate_{{d.ondemandId}}" data-status="{{d.status}}" data-id="{{d.ondemandId}}" value="{{d.rate==null?'':d.rate}}" />%
		</script>
		<script type="text/html" id="status">
			{{# if(d.status==0){ }}
				<font color="red">禁用</font>
			{{# }else{ }}
				<font color="green">启用</font>
			{{# } }}
		</script>
		<div style="margin:20px auto;width:300px;">
		 <button class="layui-btn layui-btn-normal" id="save" style="width:300px;">保存</button>
		</div>
	</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script type="text/javascript">
		var year=${year};
		var month=${month};
		var userId=${userId};
	
		layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
			var table = layui.table;
			var laypage = layui.laypage;
			var layer = layui.layer;
			var form = layui.form;
			var laydate = layui.laydate;
			
			//绑定表格
			var tableIns = table.render({
				id: 'division',
				elem: '#division',
				url: '/${applicationScope.adminprefix }/bill/upUpProList?year='+${year}+'&month='+${month}+'&userId='+userId, //数据接口
				cols: [
					[ //表头
						{
							field: 'ondemandId',
							title: '课程编号',
							align: 'center'
						}, 
						{
							field: 'name',
							title: '课程名称',
							align: 'center'
						}, 
						{
							field: 'presentPrice',
							title: '课程现价',
							align: 'center'
						},
						{
							templet: '#status',
							title: '状态',
							align: 'center'
						},
						{
							templet: '#demo',
							title: '分成比例',
							align: 'center'
						}
					]
				]
			});
		});
		$('#save').click(function(){
			var rewardRate = $('#rewardRate').val();
			var questionRate = $('#questionRate').val();
			var arr =[];
			$(".rate").each(function(){
				var ondemandId = $(this).data('id');
				var rate = $.trim($(this).val());
				var status = $(this).data('status');
				if(rate!=""){
					arr.push({
						ondemandId : ondemandId,
						rate : rate,
						status : status
					})
				}
			});
			var list = JSON.stringify(arr);
			$.ajax({
				type : 'post',
				data :{'rewardRate':rewardRate,'questionRate':questionRate,'list':list , 'year' : year , 'month' : month , 'userId' : userId},
				url : 'saveOndemand',
				datatype : 'json',
				success : function(data) {
					if (data.success) {
						tipinfo(data.msg);
						parent.reflush();
						closewindow();
					}
					tipinfo(data.msg);
				},
				error : function() {
					tipinfo("出错了!");
				}
			});
		});
		</script>
	</m:Content>
</m:ContentPage>