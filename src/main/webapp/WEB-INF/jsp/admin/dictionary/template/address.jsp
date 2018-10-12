<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="cn.core.AuthorizeTag" prefix="px"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/css/process_style.css" />
	<style>
		
	</style>	
	</m:Content>
	<m:Content contentPlaceHolderId="content">
		<!-- 内容主体区域 -->
		<div class="area_select">
			<div class="arealist">
				<!-- 区域 -->
				<c:forEach items="${list}" var="list">
					<div class="clearfix">
						<span><label><input type="checkbox" class="daqu" data-id="${list.codeid}" <c:if test="${fn:contains(addressIds.regionId,list.codeid)}" >checked</c:if> />${list.cityName}</label></span>
						<!-- 省 -->
						<div class="fr" >
							<c:forEach items="${province}" var="province">
								<c:if test="${province.parentid==list.codeid}">
									<span class="provinceList">
										<label><input type="checkbox" value="${province.cityName}" data-id="${province.codeid}" class="provinceCheck" <c:if test="${fn:contains(addressIds.provinceIds,province.codeid)}" >checked</c:if> />${province.cityName}</label>
										(<i class="cityCount">0</i>)<i class="down"></i>	
										<div class="citylist" style="display: none;">
										<div class="clearfix">
											<!-- 市 -->
											<c:forEach items="${city}" var="city">
												<c:if test="${city.parentid==province.codeid}">
													<label>
														<input type="checkbox" class="cityCheck" value="${city.cityName}" data-id="${city.codeid}" data-area="" <c:if test="${fn:contains(addressIds.cityIds,city.codeid)}" >checked</c:if>/>${city.cityName}    
													</label>
												</c:if>
											</c:forEach>
										</div>
										<a href="#" class="closecity">关闭</a>
										</div>
									</span>
								</c:if>
							</c:forEach>
						</div>
					</div>
				</c:forEach>
				
				<div class="btn">
					<input type="button" value="确定" class="btnconfirm" onclick="subInfo();"/>
					<input type="button" value="取消" class="cancel" onclick="closeTC();"/>
				</div>
				<form id="subForm" action="/${applicationScope.adminprefix }/logisticsTemplate/saveAddress" enctype="multipart/form-data">
					<input type="hidden" value="${addressIds.regionId==''?0:addressIds.regionId}" id="regionIds" name="regionIds" />
					<input type="hidden" value="${addressIds.provinceIds}" id="provinceIds" name="provinceIds" />
					<input type="hidden" value="${addressIds.addressName}" id="provinceName" name="provinceName" />
					<input type="hidden" value="${addressIds.cityIds}" id="cityIds" name="cityIds" />
					<input type="hidden" value="${type}" id="type" name="type">
					<input type="hidden" value="${msgId}" id="msgId" name="msgId">
				</form>
			</div>
		</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
		<script src="/manage/public/js/jquery.form.min.js"></script>
		<script type="text/javascript">
			$(function(){
				var index = $(this).attr('data-index');
				$('#areaIndex').val(index);
				//$('.area_select').find('input[type="checkbox"]').attr('checked', false);
				$('.area_select').find('.cityCount').html(0);
				$('.area_select').find('.cityCount').css('color', 'black');
				$('.area_select').show();
				$('.shade').show();
				
				//重新加载城市的数量
				var type = '${type}';
				if(type==2){
					
					 $(".provinceList input:checkbox.provinceCheck:checked").each(function () {
						var $div=$(this).parents(".provinceList:first");
			            var count = $div.find(".citylist :checkbox.cityCheck:checked").length;
			            $div.find("i.cityCount").css("color","red").html(count);
			         });
					 
				}
				
				
			}) 
			/* 负责展开省级下面的城市 */
			$(document).on('click', '.arealist>div div span i', function() {
				
				var $span=$(this).parents(".provinceList:first");
				var offset_Span=$span.offset();
				
				var span_left=offset_Span.left+$span.width();
				var span_top=offset_Span.top+$span.height();
				
				var $cityDiv=$span.find(".citylist");
				
				var city_height=$cityDiv.height();
				var city_width=$cityDiv.width();
				
				var window_height=$(window).height();
				var window_width=$(window).width();
				
				if(span_top+city_height>window_height){
					var top=window_height-span_top-city_height-10;
					$cityDiv.css({"top":top+"px","left":$span.width()+"px"});
				}
				if(span_left+city_width>window_width){
					$cityDiv.css({"left":-1*city_width-20+"px"});
				}
				
				$(".citylist").not($cityDiv).hide();
				$(".provinceList").not($span).removeClass("selected");
				
				if($(this).parent().hasClass('selected')) {
					$(this).parent().removeClass('selected');
					$(this).next('.citylist').hide();
				} else {
					$(this).parent().addClass('selected');
					$(this).next('.citylist').show();
				}
			})
			/* 负责关闭城市小框 */
			$(document).on('click', '.closecity', function() {
				$(this).parent().hide();
				$(this).parent().parent().removeClass('selected');
			})
			
			/* 选择城市后，控制省级后面的数量加减 */
			$(document).on('click', '.cityCheck', function() {
				var $ch = $(this).parents('.provinceList');
				var i = Number($ch.find('.cityCount').html());
				if ($(this).is(':checked')) {
					i++;
				} else {
					i--;
				}
				if (i<0){
					i=0;
				}
				if(i!=0){
					$ch.find('.cityCount').css('color', 'red');
				} else {
					$ch.find('.cityCount').css('color', 'black');
				}
				$ch.find('.provinceCheck').prop('checked', i == $ch.find('.cityCheck').length);
				var $ch2 = $(this).parents('.clearfix');
				$ch2.find(".daqu").prop("checked", $ch2.find(".provinceCheck").length==$ch2.find(".provinceCheck:checked").length);
				$(this).parents('.provinceList').find('.cityCount').html(i);
				var setNum = Number($('#areaIndex').val());
				
			})
			//部分全选
			$(document).on('click', ':checkbox.provinceCheck',function(){
				var ck=$(this).is(':checked');//只选择省
				var $parent1 = $(this).parents('.provinceList');
				$parent1.find('.cityCheck').prop('checked',ck);
				var num = $parent1.find('.cityCheck:checked').length;
				if(num!=0){
					$parent1.find('.cityCount').css('color', 'red');
				} else {
					$parent1.find('.cityCount').css('color', 'black');
				}
				$parent1.find('.cityCount').html(num);
				var $parent2 = $(this).parents(".clearfix");
				$parent2.find(".daqu").prop("checked", $parent2.find(".provinceCheck").length==$parent2.find(".provinceCheck:checked").length);
				var setNum = Number($('#areaIndex').val());
				
			});
			//全选
			$(".daqu").on("click",function(){
				var ck=$(this).is(":checked");
				var $fix = $(this).parents('.clearfix');
				$fix.find('.provinceCheck').prop("checked",ck);
				$fix.find('.cityCheck').prop("checked",ck);
				var $num = $fix.find('.cityCount');
				$num.each(function(i){
					var numm = $(this).parents('.provinceList').find('.cityCheck:checked').length;
					if(numm != 0){
						$(this).css('color', 'red');
					}else{
						$(this).css('color', 'black');
					}
					$(this).html(numm);
					var setNum = Number($('#areaIndex').val());
					
				})
			});
			
			//给文本域赋值
			$(":checkbox").on("change",function(){
				
				//区id
				var regionIds = [0];
				$('input:checkbox[class="daqu"]:checked').each(function(){
					var regionId = $(this).data('id');
					if(regionIds.indexOf(regionId)==-1){
						regionIds.push(regionId);
					}
				})
				$("#regionIds").val(regionIds.join(","));
				
				//省级id和名称
				var provinceIds = [];
				var names = [];
				$('input:checkbox[class="provinceCheck"]:checked').each(function(){  //multiple checkbox的name  
					
					var Ids = $(this).data('id');	   
					var name = $(this).val();
					if(provinceIds.indexOf(Ids)==-1){
						provinceIds.push(Ids);
					}
					if(names.indexOf(name)==-1){
						names.push(name);
					}
				}); 
				$("#provinceIds").val(provinceIds.join(","));
				$("#provinceName").val(names.join(","));
				//市级id
				var arr=[];
				var cityArr = $("#provinceIds").val();
				var provinceName = $("#provinceName").val();
				$(":checkbox:checked","div.citylist").each(function(){
					var codeId = $(this).data('id');
					if(arr.indexOf(codeId)==-1){
						arr.push(codeId);
					}
					var parentId = $(this).parents(".provinceList").find("input:checkbox.provinceCheck").data("id");
					var parentName = $(this).parents(".provinceList").find("input:checkbox.provinceCheck").val();
					if(cityArr.indexOf(parentId)==-1){
						$("#provinceIds").val(cityArr += ","+parentId);
					}
					if(provinceName.indexOf(parentName)==-1){
						$("#provinceName").val(provinceName += ","+parentName);
					}
				})
				$("#cityIds").val(arr.join(","));
				
				
			})
			
			//保存地址信息
			function subInfo(){
				var type='${type}';
				if(check()){
					$("#subForm").ajaxSubmit({
						success: function (data) {
							 tipinfo(data.msg);
							 if(data.result){
								 closewindow();
								if(data.type==1){
									parentMosaic();
								}
							 }
					       	
					     }
					})
				}
			}
			
			function parentMosaic(){
				
				 var regionIds = $("#regionIds").val();
				 var provinceIds = $("#provinceIds").val();
				 var provinceName = $("#provinceName").val();
				 var cityIds = $("#cityIds").val();
				
				 var num = Number(parent.$('#priceCount').val());//当前添加的运费项的数量
				 var nowNum = Number(num+1);
				 parent.$('#priceCount').val(nowNum);//修改父页面当前添加的运费项的数量
				 
				 var newNums = Number(parent.$('#newNums').val());//最新添加的运费项的num数
				 var nowNewNums = Number(newNums+1);
				 parent.$('#newNums').val(nowNewNums);
				 
				 var html = '<tr data-num='+nowNewNums+' id="num'+nowNewNums+'" >'+
							'<input type="hidden" name="region-'+nowNewNums+'" value="'+regionIds+'">'+	
							'<input type="hidden" name="provinceIds-'+nowNewNums+'" value="'+provinceIds+'">'+	
							'<input type="hidden" name="provinceName-'+nowNewNums+'" value="'+provinceName+'">'+	
							'<input type="hidden" name="cityIds-'+nowNewNums+'" value="'+cityIds+'">'+
				 			'<td width="15%">'+
				 				$("#provinceName").val()+
				 			'</td>'+
				 			'<td width="19%"><input type="text" name="firstGoods-'+nowNewNums+'" id="firstGoods-'+nowNewNums+'" value="" ></td>'+
				 			'<td width="19%"><input type="text" name="firstFreight-'+nowNewNums+'" id="firstFreight-'+nowNewNums+'" value="" ></td>'+
				 			'<td width="19%"><input type="text" name="secondGoods-'+nowNewNums+'" id="secondGoods-'+nowNewNums+'" value="" ></td>'+
				 			'<td width="19%"><input type="text" name="secondFreight-'+nowNewNums+'" id="secondFreight-'+nowNewNums+'" value="" ></td>'+
				 			'<td width="9%">'+
				 				'<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del" onclick="delPri('+nowNewNums+')" >删除</a>'+
				 			'</td></tr>';
				 parent.$('#priceTB').find('tr').eq(0).before(html);
				 
				 var nowNums = parent.$('#nowNums').val();
				 parent.$('#nowNums').val(nowNums += nowNewNums+",");
			}
			
			function check() {
				var cityIds = $("#cityIds").val();
				if (cityIds == '' || cityIds == null) {
					tipinfo("请选择地址！");
					return false;
				}
				return true;
			}

			function closeTC(){
				closewindow();
			}

		</script>
	</m:Content>
</m:ContentPage>
