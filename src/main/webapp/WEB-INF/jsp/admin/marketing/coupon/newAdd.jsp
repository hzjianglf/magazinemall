<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
<m:Content contentPlaceHolderId="css">
	<style>
		.layui-input, .layui-textarea{
			width: 92%;
		} 
		.layui-form-label{
			width: 125px;
		}
		.must{
			color: red;
			margin-right: 2%;
			size: 10px;
			font-size: 15px;
		}
		.clear{
			clear:both;
		}
		.ss_biao{
			float: right;
			margin-top: -4%;
			margin-right:3%;
			cursor:pointer;
		}
	</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div style="padding:0 30px" class="layui-anim layui-anim-upbit">
		<div class="layui-field-box" style=" border-color:#666; border-radius:3px; padding:10px;">
			<form class="layui-form">
				<input type="hidden" name="couponId" value="${data.Id }" />
				<input type="hidden" name="type" value="${type}" />
				<input type="hidden" name="alreadyIssued" value="${data.alreadyIssued}" />
            	<div class="layui-form-item">
					<label class="layui-form-label"><span class="must">*</span>优惠券名称：</label>
					<div class="layui-input-block">
						<input type="text" ${type==3?'disabled':'' } name="name" id="name" value="${data.name }" lay-verify="name"  autocomplete="off" class="layui-input" />
					</div>
				</div>
				<div class="layui-inline">
					<input type="hidden" name="timeType" id="timeType" value="0">
					<label class="layui-form-label"><span class="must">*</span>使用规则：&nbsp;满</label>
					<div class="layui-input-inline">
						<input type="text" ${type==3?'disabled':'' } lay-verify="man" value="${data.manprice}" name="manPrice" id="manPrice"  autocomplete="off" class="layui-input" style="width: 170%;">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label" style="margin-left: 17%;">减</label>
				</div>
				<div class="layui-inline">
					<input type="text" ${type==3?'disabled':'' } lay-verify="jian" value="${data.jianprice}" name="jianPrice" id="jianPrice"  autocomplete="off" class="layui-input" style="width: 210%;margin-left: 10%;">
				</div>
				<div class="layui-form-item" id="couponType" style="margin-top: 1%;">
				    <label class="layui-form-label"><span class="must">*</span>类型：</label>
				    <div class="layui-input-block">
				      <input type="radio" ${type==3?'disabled':'' } name="couponType" lay-filter="couponType" value="1" title="品类券" <c:if test="${data.couponType==1 || data.couponType==null}">checked</c:if> >
				      <input type="radio" ${type==3?'disabled':'' } name="couponType" lay-filter="couponType" value="2" title="定向券" <c:if test="${data.couponType==2}">checked</c:if> >
				    </div>
				</div>
				<!-- 品类券 -->
				<div class="layui-form-item" id="typeChexkbox" style="display: ${data.couponType==1 || data.couponType==null?'inline':'none' };">
					<label class="layui-form-label"><span class="must"></label>
					<div class="layui-input-block">
					
					      <input type="checkbox" lay-filter="all"  name="all" id="all" value="0" title="全品类通用券">
					      <input type="checkbox" lay-filter="goodsCheck" name="goodsCheck" id="goodsCheck" value="1" title="商品">
					      <input type="checkbox" lay-filter="qikanCheck" name="qikanCheck" id="qikanCheck" value="2" title="期刊">
					      <input type="checkbox" lay-filter="dianboCheck" name="dianboCheck" id="dianboCheck" value="3" title="点播课程">
					      <input type="checkbox" lay-filter="zhiboCheck" name="zhiboCheck" id="zhiboCheck" value="4" title="直播课程">
					      <input type="hidden" name="goodsTypeCheck" id="goodsTypeCheck" value="${data.pinleiGoodsType}">
				    </div>
				</div>
				<!-- 定向券 -->
				<div class="layui-form-item" id="typeRadio" style="display: ${data.couponType==2?'inline':'none' };"> 
					<label class="layui-form-label"><span class="must"></label>
					 <div class="layui-input-block">
					      <input type="radio" ${type==3?'disabled':'' } name="goodsType" lay-filter="goodsType" value="2" title="指定期刊" <c:if test="${data.dingxiangGoodsType==2 || data.dingxiangGoodsType==null}">checked</c:if> >
					      <input type="radio" ${type==3?'disabled':'' } name="goodsType" lay-filter="goodsType" value="3" title="指定点播课程" <c:if test="${data.dingxiangGoodsType==3}">checked</c:if> >
					      <input type="radio" ${type==3?'disabled':'' } name="goodsType" lay-filter="goodsType" value="4" title="指定直播课程" <c:if test="${data.dingxiangGoodsType==4}">checked</c:if> >
					      <input type="radio" ${type==3?'disabled':'' } name="goodsType" lay-filter="goodsType" value="1" title="指定作家" <c:if test="${data.dingxiangGoodsType==1}">checked</c:if> >
						  <input type="text" ${type==3?'readonly':'' } name="searchGoods" id="searchGoods" value="${data.dingxiangGoodsName}" lay-verify=""  autocomplete="off" class="layui-input" style="width: 30%;float: right;margin-right:2%;"/>
						  <input type="hidden" name="dingxiangId" id="dingxiangId" value="${data.dingxiangGoodsId}">
						  <div class="clear"></div>
						  <img alt="" src="/manage/images/ss_biao.png" class="ss_biao" onclick="search();">					    	
				     </div>
				</div>
				<div class="layui-form-item" style="margin-top: 1%;">
					<label class="layui-form-label"><span class="must">*</span>数量：</label>
					<div class="layui-input-block">
						<input type="text" ${type==3?'readonly':'' } name="totalCount" id="totalCount" value="${data.totalCount }" lay-verify="count"  autocomplete="off" class="layui-input" />
					</div>
				</div>
				<div class="layui-inline">
					<input type="hidden" name="timeType" id="timeType" value="0">
					<label class="layui-form-label"><span class="must">*</span>有效期：</label>
					<div class="layui-input-inline">
						<input type="text" ${type==3?'disabled':'' } value="${data.startDate}" name="startTime" id="startTime"  autocomplete="off" class="layui-input" style="width: 170%;">
					</div>
				</div>
				<div class="layui-inline">
					<label class="layui-form-label" style="margin-left: 8%;">-</label>
				</div>
				<div class="layui-inline">
					<input type="text" ${type==3?'disabled':'' } value="${data.endDate}" name="endTime" id="endTime"  autocomplete="off" class="layui-input" style="width: 210%;margin-left: 10%;">
				</div>
			
				
				<div class="layui-form-item">
				    <label class="layui-form-label"><span class="must">*</span>优惠券状态：</label>
				    <div class="layui-input-block">
				      <input type="radio" ${type==3?'disabled':'' } name="state" value="0" title="启用" <c:if test="${data.state==0 || data.state==null}">checked</c:if> >
				      <input type="radio" ${type==3?'disabled':'' } name="state" value="1" title="暂停" <c:if test="${data.state==1}">checked</c:if> >
				    </div>
				</div>
				
				<div class="layui-form-item" style="text-align: center;">
					<c:if test="${type!=3}">
						<button class="layui-btn" style="width: 50%;margin-top: 60px;" lay-submit="" lay-filter="addEqBtn">提交</button>
					</c:if>
					<c:if test="${type==3}">
						<button class="layui-btn" style="width: 50%;margin-top: 60px;" id="closeWindow">确定</button>
					</c:if>
				</div>
			</form>
		</div>
	</div>
</m:Content>
<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		layui.use(['form','laydate','layedit'], function(){
			var form = layui.form;
			var laydate = layui.laydate;
			laydate.render({
			    elem: '#startTime' //指定元素
			});
			laydate.render({
			    elem: '#endTime' //指定元素
			});
			//监听提交
			form.on('submit(addEqBtn)', function(data){
				if(!check()){
					return false;
				}
				var array = new Array();
				$("input[name='chosen']").each(function(){
					var type = $(this).val();
					var id = $(this).data('id');
					array.push({productType:type,productId:id});
				})
				$("#ids").val(JSON.stringify(array));
				var success = function(response){
					if(response.result){
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
				var postData = $(data.form).serialize();
				ajax('/${applicationScope.adminprefix }/coupon/addCoupon', postData, success, 'post', 'json');
				return false;
			})
			//自定义验证规则
			form.verify({
				name: function(value) {
					if(value.length < 3) {
						return '请填写优惠券名称';
					}
				},
				man:function(value){
					var regPos = /^\d+(\.\d+)?$/;//非负浮点数
					if(value==null || value=='' || !regPos.test(value)){
						return '请填写正确的价格';
					}
				},
				jian:function(value){
					var regPos = /^\d+(\.\d+)?$/;//非负浮点数
					if(value==null || value=='' || !regPos.test(value)){
						return '请填写正确的价格';
					}
				},
				count:function(value){
					var regPos = /^\d+(\.\d+)?$/;//非负浮点数
					if(value==null || value=='' || !regPos.test(value)){
						return '请填写正确的数量';
					}
				}
				
			});
			
			function check(){
				
				var couponType = $("#couponType :radio:checked").val();
				if(couponType=='1'){
					var types = $("#goodsTypeCheck").val();
					if(types==null || types==''){
						layer.msg("请选择品类券类型", {icon: 2});
						return false;
					}
				}else{
					var dingxiangId = $("#dingxiangId").val();
					if(dingxiangId==null || dingxiangId==''){
						layer.msg("请选择定向券对象", {icon: 2});
						return false;
					}
				}
				
				var startTime = $("#startTime").val();
				var endTime = $("#endTime").val();
				var d1 = new Date(startTime.replace(/\-/g, "\/"));  
				var d2 = new Date(endTime.replace(/\-/g, "\/"));  
				if(startTime!=""&&endTime!=""&&d1 >d2){
					 layer.msg("开始时间不能大于结束时间！", {icon: 2});
					 return false;
				}
				
				var youxiaoDate = $("#timeType").val();
				if(youxiaoDate==0){
					if(startTime==null || startTime==''){
						layer.msg("请选择活动开始时间", {icon: 2});
						return false;
					}
					if(endTime==null || endTime==''){
						layer.msg("请选择活动结束时间", {icon: 2});
						return false;
					}
				}else{
					var effectiveDate = $("#effectiveDate").val();
					if(effectiveDate==null || effectiveDate==''){
						layer.msg("请输入优惠券有效日期", {icon: 2});
						return false;
					}
				}
				
				
				return true;
			}
			$("#closeWindow").click(function(){
				closewindow();
			})
			
			form.on('radio(couponType)', function(data){
				var val = data.value; 
				if(val==1){
					$("#typeChexkbox").css("display","inline");
					$("#typeRadio").css("display","none");
				}else{
					$("#typeChexkbox").css("display","none");
					$("#typeRadio").css("display","inline");
				}
				
			});
			form.on('radio(goodsType)', function(data){
				$("#searchGoods").val('');
				$("#dingxiangId").val('');
			});
			//品类券全选操作
			form.on('checkbox()', function(data){
				
				var name = $(this).attr("name");
				var isCheck = $(this).is(":checked");
				
				if(name=="all"){
					if(isCheck){
						$("#typeChexkbox .layui-unselect").each(function(){
							$(this).addClass("layui-form-checked");
						})
						$("#typeChexkbox :checkbox").each(function(){
							$(this).prop("checked",true);
						})
						$("#goodsTypeCheck").val(0);
					}else{
						$("#typeChexkbox .layui-unselect").each(function(){
							$(this).removeClass("layui-form-checked");
						})
						$("#typeChexkbox :checkbox").each(function(){
							$(this).removeAttr("checked");
						})
						$("#goodsTypeCheck").val('');
					}
				}else{
					var result = $("#typeChexkbox :checkbox:checked").not("[name='all']").length;
					if(result==4){
						$("#all").attr("checked",true);
						$("#all").next(".layui-unselect").addClass("layui-form-checked");
					}else{
						//$(this).removeAttr("checked");
						$("#all").next(".layui-unselect").removeClass("layui-form-checked");
					}
					
				}
				
				var types = []
				$("#typeChexkbox .layui-form-checked").each(function(){
					var va = $(this).prev("input").val();
					types.push(va);
				})
				$("#goodsTypeCheck").val(types.join(","));
			});
			
			$(function(){
				var couponType = '${data.couponType}';
				if(couponType=='1'){
					var ids = '${data.pinleiGoodsType}';
					var strs= new Array();
					strs = ids.split(",");
					for(var i = 0;i<strs.length;i++){
						$("#typeChexkbox :checkbox").each(function(){
							if($(this).val()==strs[i]){
								$(this).next(".layui-unselect").addClass("layui-form-checked");
							}
						})
					}
				}
			})
			
		})
		function delHtml(obj){
	 		var id = $(obj).data('id');
	 		$("#"+id+"").remove();
	 	}
		function search(){
			var types = '${type}';
			if(types!='3'){
				var type = $("#typeRadio :radio:checked").val();
				var text = "";
				if(type=='2'){
					text="期刊搜索";
				}else if(type=='3'){
					text="点播课程搜索";
				}else if(type=='4'){
					text="直播课程搜索";
				}else{
					text="专家搜索";
				}
				var searchText = $("#searchGoods").val()
				openwindow("/coupon/getAllGoods?type="+type+"&searchText="+searchText,text,1000,900,false,function(){
					tableIns.reload({
						page: {
							curr: 1
						}
					});
				}); 
			}else{
				tipinfo("不可查询编辑！");
			}
			
		}
	</script>
</m:Content>
</m:ContentPage>