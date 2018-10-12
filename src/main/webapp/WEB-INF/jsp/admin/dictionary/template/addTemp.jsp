<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
		<link rel="stylesheet" href="/manage/public/css/process_style.css" />
		<style type="text/css">
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
		}
		
		.layui-table td.td1 {
			border-right: 1px solid #e6e6e6
		}
		
		.layui-table tbody tr:hover {
			background: #fff;
		}
		
		.layui-table td input {
			width: 67px;
			height: 22px;
			line-height: 22px;
			text-align: center;
		}
		
		.layui-form td {
			line-height: 30px;
		}
		.inpCss{
			margin-left: -13%;
		}
		.inpCss1{
			margin-left: -10%;
		}
		.inpCss2{
			margin-left: -5%;
		}
		.inpCss3{
			margin-left: -1%;
		}
	</style>
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<!-- 内容主体区域 -->
		<form id="subForm" action="/${applicationScope.adminprefix }/logisticsTemplate/addTemplate" enctype="multipart/form-data">
		<div class="layui-inline" style="margin-top: 1%;margin-left: 4%;">
			<label class="layui-form-label">模板名称：</label>
			<div class="layui-input-inline">
				<input type="text" name="tempName" id="tempName" placeholder="" autocomplete="off" class="layui-input">
			</div>
		</div>
		<div class="layui-form">
			<table class="layui-table" lay-skin="line" style="width: 90%;margin: 3% auto;">
				<thead>
					<tr style="background-color: #C0C0C0;">
						<th width="15%" style="background-color: #9596A0;">配送地区</th>
						<th width="19%" style="background-color: #9596A0;">首件（个）</th>
						<th width="19%" style="background-color: #9596A0;">运费（元）</th>
						<th width="19%" style="background-color: #9596A0;">续件（个）</th>
						<th width="19%" style="background-color: #9596A0;">运费（元）</th>
						<th width="9%"  style="background-color: #9596A0;"></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="6" style="padding: 0;"><div class="" style="min-height: 200px; overflow: auto">
								<table width="100%" border="0" cellspacing="0" cellpadding="0" id="priceTB">
									<tr>
										<td width="15%">
											<a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail" onclick="addressSetUp();">
												<i class="layui-icon" style="font-size: 30px; color: #333333;">&#xe715;</i>
												 设置地区城市
											</a>
										</td>
										<td width="19%"><input type="text" value="" ></td>
										<td width="19%"><input type="text" value="" ></td>
										<td width="19%"><input type="text" value="" ></td>
										<td width="19%"><input type="text" value="" ></td>
										<td width="9%">
											<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
										</td>
									</tr>
								</table>
							</div></td>
					</tr>
					<tr>
						<td colspan="6">未指定的其他地区，采用默认运费：
							首件 <input type="text" name="ortherFirst" id="ortherFirst" value=""> 个，
							运费 <input type="text" name="ortherFPrice" id="ortherFPrice" value=""> 元，
							续件 <input type="text" name="ortherSecond" id="ortherSecond" value=""> 个，
							运费 <input type="text" name="ortherSPrice" id="ortherSPrice" value=""> 元
						</td>
					</tr>
				</tbody>
			</table>
				<input type="hidden" id="priceCount" name="priceCount" value="0">
				<input type="hidden" id="nowNums" name="nowNums">
				<input type="hidden" id="newNums" name="newNums" value="0">
			</form>
			<table>
			</table>
			<div class="btn">
				<input type="button" value="确定" class="btnconfirm" onclick="addTemplate();"/>
				<input type="button" value="取消" class="cancel" onclick="closeTC();"/>
				
			</div>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script type="text/javascript">
			//地区选择页面
			function addressSetUp(){
				openwindow("/logisticsTemplate/addressSetUp?msgId=0&type=1","选择区域",800,750,true);
			}
			//关闭弹窗
			function closeTC(){
				closewindow();
			}
			//移除价格项
			function delPri(num){
				$("#num"+num).remove();
				var priCount = Number($("#priceCount").val());
				var nowCount = priCount-1;
				$("#priceCount").val(nowCount);
				var newNowNums = document.getElementById('nowNums').value.replace(num+",","");
				$("#nowNums").val(newNowNums);
			}
			//提交模板信息
			function addTemplate(){
				if(check()){
					$("#subForm").ajaxSubmit({
						success: function (data) {
							if(data.result){
								alertinfo(data.msg,{icon: 1});
								closewindow();
							}else{
								alertinfo(data.msg,{icon: 2});
							}
					       	
					     }
					})
				}
			}
			//校验信息是否填写完整
			function check(){
				var tempName = $("#tempName").val();
				if(tempName==null || tempName=='' ){
					tipinfo("请输入模板名称！","#tempName");
					return false;
				}
				
				var priceCount = Number($("#priceCount").val());
				if(priceCount==0){
					tipinfo("请先选择城市区域！");
					return false;
				}
				
				var flag=false;
				var priceInfo = [];
				var trLength = Number($("#priceTB").find("tr").length);//tr的长度
				$("#priceTB").find("tr").each(function(item){
					//获取tr 的Id 
					if(item!=trLength-1){
						var $firstGoods=$(this).find("[id^='firstGoods-']");
						if($.trim($firstGoods.val())==""){
							tipinfo("请输入首件个数！",$firstGoods);
							$firstGoods.focus();
							flag=true;
							return false;
						}
						
						var $firstFreight=$(this).find("[id^='firstFreight-']");
						if($.trim($firstFreight.val())==""){
							tipinfo("请输入首件运费！",$firstFreight);
							$firstFreight.focus();
							flag=true;
							return false;
						}
						
						var $secondGoods=$(this).find("[id^='secondGoods-']");
						if($.trim($secondGoods.val())==""){
							tipinfo("请输入续件个数！",$secondGoods);
							$secondGoods.focus();
							flag=true;
							return false;
						}
						
						var $secondFreight=$(this).find("[id^='secondFreight-']");
						if($.trim($secondFreight.val())==""){
							tipinfo("请输入续件运费！",$secondFreight);
							$secondFreight.focus();
							flag=true;
							return false;
						}
					}
					
				})
				
				if(flag){
					return false;
				} 
				
				var ortherFirst = $("#ortherFirst").val();
				var ortherFPrice = $("#ortherFPrice").val();
				var ortherSecond = $("#ortherSecond").val();
				var ortherSPrice = $("#ortherSPrice").val();
				if(ortherFirst==null || ortherFirst==''){
					tipinfo("请输入首件个数！","#ortherFirst");
					$("#ortherFirst").focus();
					return false;
				}
				if(ortherFPrice==null || ortherFPrice==''){
					tipinfo("请输入首件运费！","#ortherFPrice");
					$("#ortherFPrice").focus();
					return false;
				}
				if(ortherSecond==null || ortherSecond==''){
					tipinfo("请输入续件个数！","#ortherSecond");
					$("#ortherSecond").focus();
					return false;
				}
				if(ortherSPrice==null || ortherSPrice==''){
					tipinfo("请输入续件运费！","#ortherSPrice");
					$("#ortherSPrice").focus();
					return false;
				}
				
				return true;
			}
		</script>
	</m:Content>
</m:ContentPage>
