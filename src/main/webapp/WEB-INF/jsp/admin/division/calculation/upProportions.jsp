<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<style>
		.layui-layer-title{
			    background-color: #009688 !important;
			    color:#fff !important;
		}
	</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
			<legend>设置分成比例</legend>
		</fieldset>
		<input type="hidden" name="year" value="${year }"/>
		<input type="hidden" name="month" value = "${month }"/>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" id="division" lay-filter="tableContent"></table>
		</div>
		<div style="width:300px;margin:30px auto;">
		 <button class="layui-btn layui-btn-normal" id="btn_startcalc" style="width:300px">开始计算</button>
		</div>
		<script type="text/html" id="Demo">
			<a class="layui-btn layui-btn-xs" lay-event="selectIDs">设置</a>
			{{# if(d.status==0){ }}
				<a class="layui-btn layui-btn-xs" lay-event="enable">启用</a>
			{{# }else{ }}
				<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="disable">禁用</a>
			{{# } }}
		</script>
		<script type="text/html" id="questionRateTemp">
			{{# if(d.questionRate==null){ }}
				<font color="#ccc">未设置</font>
			{{# }else{ }}
				{{ d.questionRate }}
			{{# } }}
		</script>
		<script type="text/html" id="rewardRateTemp">
			{{# if(d.rewardRate==null){ }}
				<font color="#ccc">未设置</font>
			{{# }else{ }}
				{{ d.rewardRate }}
			{{# } }}
		</script>
		<script type="text/html" id="statusTemp">
			{{# if(d.status==0){ }}
				<font color="red">禁用</font>
			{{# }else{ }}
				<font color="green">启用</font>
			{{# } }}
		</script>
		
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script type="text/javascript">
		
			var year=${year};
			var month=${month};
			var tableIns=null;
			layui.use(['laypage', 'layer', 'table', 'form' ,'laydate'], function(){
				var table = layui.table;
				var laypage = layui.laypage;
				var layer = layui.layer;
				var form = layui.form;
				var laydate = layui.laydate;
				
				//绑定表格
				tableIns = table.render({
					id: 'division',
					elem: '#division',
					url: '/${applicationScope.adminprefix }/bill/proportionDataList?year='+${year}+'&month='+${month}, //数据接口
					page: true, //开启分页
					limits: [10, 20, 30, 40, 50],
					cols: [
						[ //表头
							{
								type: 'checkbox',
								align: 'center'
							},
							{
								field: 'userCode',
								title: '用户ID',
								align: 'center'
							}, 
							{
								field: 'realName',
								title: '专栏作家',
								align: 'center'
							}, 
							{
								field: 'userName',
								title: '账号',
								align: 'center'
							},
							{
								field: 'salesCount',
								title: '销售数量',
								align: 'center'
							},
							{
								title: '问答分成(%)',
								align: 'center',
								templet:"#questionRateTemp"
							}, 
							{
								title: '打赏分成(%)',
								align: 'center',
								templet:"#rewardRateTemp"
							}, 
							{
								title: '状态',
								align: 'center',
								templet:"#statusTemp"
							}, 
							{
								title: '操作',
								align: 'center',
								toolbar: '#Demo',
							}
						]
					]
				});
				table.on('tool(tableContent)', function(obj) {
					var data = obj.data; //获得当前行数据
					var layEvent = obj.event; //获得 lay-event 对应的值（也可以是表头的 event 参数对应的值）
					var tr = obj.tr; //获得当前行 tr 的DOM对象
	
					var userId=data.userId;
					
					//设置分润比例
					if(layEvent === 'selectIDs'){ 
				      	openwindow('bill/upUpPro?year='+year+'&month='+month+'&userId='+userId,"设置-分成",740,540,false,null);
				  	}
					//启用
					if(layEvent=="enable"){
						changeUserStatus(userId,1);
					}
					//禁用
					if(layEvent=="disable"){
						changeUserStatus(userId,0);
					}
				});
				
				function reload(){
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							r:Math.random()
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
				}
				
				//更新用户分成状态
				function changeUserStatus(id,type){
					var t="禁用";
					if(type==1){
						t="启用";
					}
					confirminfo("您确定进行"+t+"操作?",function(){
						var url=getUrl("bill/changeUserRuleState");
						$.post(url,{
							year:year,
							month:month,
							userId:id,
							status:type,
							r:Math.random()
						},function(obj){
							tipinfo(obj.msg);
							if(obj.result){
								reload();
							}
						},"json")
					})
				}
			});
			$('#btn_startcalc').click(function(){
				tipinfo("正在计算，请稍后！");
				loading(true);
				$.ajax({
					type : 'post',
					url : 'startcalc?year='+year+'&month='+month,
					datatype : 'json',
					success : function(data) {
						loading();
						tipinfo(data.msg);
						if (data.result) {
							parent.nextConfirm(data.id);
							closewindow();
						}
					},
					error : function() {
						loading();
						tipinfo("出错了!");
					}
				});
			});
			function reflush(){
				if(tableIns==null){
					return false;
				}
				tableIns.reload({
					where: { //设定异步数据接口的额外参数，任意设
						r:Math.random()
					},
					page: {
						curr: 1 //重新从第 1 页开始
					}
				});
			}
		</script>
	</m:Content>
</m:ContentPage>