<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.type span,.type1 span,.type2 span{
				cursor:pointer;
			}
			button{
				cursor:pointer;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="qk-detail">
			<div class="qk-img">
				<img src="${picture}" alt="" />
				
				<c:if test="${favorite==0 }">
					<button class="qk-btn collection" onclick="addCollection(${id},1)">加入收藏</button>
				</c:if>
				<c:if test="${favorite!=0 }">
					<button class="qk-btn collection" onclick="addCollection(${id},2)">取消收藏</button>
				</c:if>
			</div>
			<div class="qk-ins">
				<p>
					<span class="qk-name">${name }</span>
					<span class="liulanLiang">${sales }人付款</span>
				</p>
				<span class="qk-price">￥${paperPrice}</span>
				<p class="type" id="type">
					<b>类型:</b>
					<span>纸质版</span>
					<span>电子版</span>
				</p>
				<p class="type1" id="type1">
					<b>套餐分类:</b>
					<c:choose>
						<c:when test="${sumType eq '1' && isSalePaper>0 }">
							<span data-va="2" data-id="${id }" data-name="${name }" data-price="${paperPrice }">上半年</span>
						</c:when>
						<c:when test="${sumType eq '2' && isSalePaper>0 }">
							<span  data-va="3" data-id="${id }" data-name="${name }" data-price="${paperPrice }">下半年</span>
						</c:when>
						<c:when test="${sumType eq '3' && isSalePaper>0 }">
							<span  data-va="4" data-id="${id }" data-name="${name }" data-price="${paperPrice }">全年</span>
						</c:when>
						<c:when test="${bookList[0].isSalePaper > 0 }">
							<span  data-va="1" data-id="${id }" data-name="${name }" data-price="${paperPrice}">单期</span>
						</c:when>
					</c:choose>
					<c:forEach var="list" items="${bookList }">
						<c:if test="${list.sumType eq '3' && list.isSalePaper>0 }">
							<span  data-va="4" data-id="${list.id }" data-name="${list.name }" data-price="${list.paperPrice }">全年</span>
						</c:if>
						<c:if test="${list.sumType eq '1' && list.isSalePaper>0 }">
							<span  data-va="2" data-id="${list.id }" data-name="${list.name }" data-price="${list.paperPrice }">上半年刊</span>
						</c:if>
						<c:if test="${list.sumType eq '2' && list.isSalePaper>0 }">
							<span  data-va="3" data-id="${list.id }" data-name="${list.name }" data-price="${list.paperPrice }">下半年刊</span>
						</c:if>
					</c:forEach>
				</p>
				<p style="display:none;" class="type2" id="type2">
					<b>套餐分类:</b>
					<c:choose>
						<c:when test="${sumType eq '1' && isSaleEbook>0 }">
							<span data-val="2" data-id="${id }" data-name="${name }" data-price="${paperPrice }">上半年</span>
						</c:when>
						<c:when test="${sumType eq '2' && isSaleEbook>0 }">
							<span data-val="3" data-id="${id }" data-name="${name }" data-price="${paperPrice }">下半年</span>
						</c:when>
						<c:when test="${sumType eq '3' && isSaleEbook>0 }">
							<span data-val="4" data-id="${id }" data-name="${name }" data-price="${paperPrice }">全年</span>
						</c:when>
						<c:when test="${status > 0 }">
							<span data-val="1" data-id="${id }" data-name="${name }" data-price="${ebookPrice }">单期</span>
						</c:when>
					</c:choose>
					<c:forEach var="list" items="${bookList }">
						<c:if test="${list.sumType eq '3' && list.ebook>0 }">
							<span data-val="4" data-id="${list.id }" data-name="${list.name }" data-price="${list.ebookPrice }">全年</span>
						</c:if>
						<c:if test="${list.sumType eq '1' && list.ebook>0 }">
							<span data-val="2" data-id="${list.id }" data-name="${list.name }" data-price="${list.ebookPrice }">上半年刊</span>
						</c:if>
						<c:if test="${list.sumType eq '2' && list.ebook>0 }">
							<span data-val="3" data-id="${list.id }" data-name="${list.name }" data-price="${list.ebookPrice }">下半年刊</span>
						</c:if>
					</c:forEach>
				</p>
				<p class="carNum" id="dianzi">
					<b>数量:</b>
					<a href="javascript:void(0)">-</a>
					<span>1</span>
					<a href="javascript:void(0)">+</a>
				</p>
				<p class="carNum">
					<b>数量:</b>
					<a href="javascript:void(0)" onclick="reduce()">-</a>
					<input type="text" value='1' onkeyup="onlyNum(this)" name="number" id="number"/>
					<a href="javascript:void(0)" onclick="add()">+</a>
				</p>
				<div>
					<button class="qk-btn qk-big-btn" onclick="shoppingCart()">加入购物车</button>
					<button class="qk-btn qk-big-btn" onclick="immediatelyBuy()">立即购买</button>
				</div>
			</div>
		</div>
		<div class="qk-list">
			<ul class="oh">
				<c:forEach items="${hejiData }" var="item">
					<c:if test="${not empty item.id}">
						<li onclick="qikanDisplay(${item.publishId})">
							<img src="${item.picture }" alt="" />
							<p>${item.name }</p>
						</li>
					</c:if>
					<c:if test="${empty item.id}">
						<li onclick="qikanNone(${item.id})">
							<img src="/phone/images/noImage.jpg" alt="" />
							<p>${item.year } ${item.publishName }</p>
						</li>
		            </c:if>
				</c:forEach>
			</ul>
		</div>

	<!-- 商品图片 -->
	<input type="hidden" value=${picture } id="picture">
	<!-- 商品名称 -->
	<input type="hidden" value=${name } id="perName">
	<!-- 电子书价格 -->
	<input type="hidden" value="0.00" id="price">
	<!-- 商品ID -->
	<input type="hidden" value=${id } id="productid">
	<!-- 期次 -->
	<input type="hidden" value=${period } id="period">
	<!-- ------------------------------------- -->
	<!-- 商品个数 -->
	<input type="hidden" value="1" id="count">
	<!-- 商品类型 1单 2上 3下 4全 -->
	<input type="hidden" value="1" id="type">
	<!-- 2期刊||16电子书 -->
	<input type="hidden" value="2" id="producttype"/>
	
	<!-- 收藏字段 -->
	<input type="hidden" id="fa" value="${favorite }">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
	<script type="text/javascript" src="/js/jquery.js"></script>
	<script type="text/javascript">
		var layer;
		layui.use('layer',function(){
			layer = layui.layer;
		})
		function tipinfo(obj){
			layer.msg(obj);
		}
		
		$(function(){
			$('#type>span:first').click();
		});

		
		//加入收藏
		function collection(){
			tipinfo("加入收藏");
		}
		
		//加入购物车
		function shoppingCart(){
			//加入购物车 type 0
			saveCommodity(0);
		}
		
		//立即购买
		function immediatelyBuy(){
			//立即购买 type 1
			saveCommodity(1);
		}
		
		//类型切换
		$("#type>span").click(function(){
			$('#type>span').removeClass("active");
			$(this).addClass("active");
			if($(this).text()=="纸质版"){
				$('#type1').show().find('span:first').click().prev();
				$('#type2').hide().next().hide().next().show();
			}else{
				$('#type2').show().find('span:first').click();
				$('#type1').hide().next().next().show().next().hide();
			}
		});
		
		//纸质套餐切换
		$('#type1>span').click(function(){
			$('#type1>span').removeClass("active");
			var arr = [$(this).data('va'),$(this).data('id'),$(this).data('name'),$(this).data('price'),2];
			displyPrice(arr,$(this));
			//特殊，到纸质时需要算一下价格count*price
			displayPrice();
		});
		
		//电子套餐切换
		$('#type2>span').click(function(){
			$('#type2>span').removeClass("active");
			var arr = [$(this).data('val'),$(this).data('id'),$(this).data('name'),$(this).data('price'),16];
			displyPrice(arr,$(this));
		});
		
		//数据放到隐藏域中 
		function inputDataList(arr){
			//修改商品的类型 1.单期 2.上半年 3.下半年 4.全年
			$("#type").val(arr[0]);
			//商品id修改
			$("#productid").val(arr[1]);
			//修改名字
			$("#perName").val(arr[2]);
			//修改价格
			$("#price").val(arr[3]);
			//修改类型 纸质2|电子16
			$("#producttype").val(arr[4]);
		}
		
		//显示金额
		function displyPrice(arr,Obj){
			$('.qk-price').html(arr[3].toFixed(2));
			Obj.addClass("active");
			//存放数据
			inputDataList(arr);
		}
		
		//获取数量的input元素Obj
		function inputObj(){
			var Obj = document.getElementById("number");
			var JQObj = $('input[name="number"]');
			return [Obj,JQObj];
		}
		
		//加
		function add(){
			var obj = inputObj();
			var num = Number(obj[1].val())+1;
			num = num.toString().length>4?(num-1):num;
			obj[1].val(num);onlyNum(obj[0]);
		}
		//减
		function reduce(){
			var obj = inputObj();
			var num = Number(obj[1].val())-1;
			obj[1].val(num);onlyNum(obj[0]);
		}
		//只能是数字
		function onlyNum(Obj){
			Obj.value=Obj.value.replace(/\D/g,"");
			maxmin(Obj);
		}
		//限制大小
		function maxmin(Obj){
			//如果元素内容处理
			if(Obj.value!=""){
				Number(Obj.value)==0?Obj.value=1:Obj.value;
				Number(Obj.value)<0?Obj.value=1:Obj.value;
			}
			Obj.value.length>4?Obj.value=Obj.value.substring(0, 4):Obj.value;
			//把数量放到隐藏域中
			Obj.value==""?$("#count").val(1):$("#count").val(Obj.value);
			//显示金额
			displayPrice();
		}
		
		//显示金额
		function displayPrice(){
			$('.qk-price').html( (Number($('#count').val())*Number($("#price").val())).toFixed(2) );
		}
		//加入 购物车0/立即购买1
		function saveCommodity(type){
			var data = {productid : $("#productid").val(),count : $("#count").val(),producttype : $("#producttype").val(),
					productpic:$("#picture").val(),productname:$("#perName").val(),desc:$("#period").val(),type:type,
					subType:$("#type").val()};
			console.log(data);
			//加入购物车
			$.ajax({
					type : "POST",
					url : "/periodical/addShopCart",
					async : false,
					data : data,
					success : function(obj) {
						if(obj.result==0&&obj.needLogin){
							tipinfo("请先登录");
							return false;
						}
						if(type==0){
							if(obj.result==1){
								tipinfo("加入购物车成功");
							}else{
								tipinfo(obj.msg);
							}
						}else{
							var id=obj.data;
							if(id==null||id<=0){
								tipinfo(obj.msg);
								return false;
							}
							var url = window.location.pathname+window.location.search;
							window.location.href="/order/turnJieSuan?shoppingIds="+id;
						}
					},
					error : function(data) {
						tipinfo("出错了!");
					}
			});
		}
		/**********************************************/
		
		//添加收藏
		function addCollection(dataId,type){
			var value = $("#fa").val();
			if(value!=0 && value!=1){
				type=2;//取消
			}else{
				type=1;
			}
			
			$.ajax({
				type : "POST",
				url : "/product/addCollection",
				async : false,
				data : {"dataId" : dataId, "dataType" : 1, "favoriteType" : 1,"type":type},
				success : function(data) {
					tipinfo(data.msg)
					if(data.type==1){
						$("#fa").val("2");
						$(".collection").html("取消收藏");
					}
					if(data.type==2){
						$("#fa").val("1");
						$(".collection").html("加入收藏"); 
					}
				},
				error : function(data) {
				}
			});
		}
		
		//跳转期刊详情
		function qikanDisplay(id){
			//location.href="/product/turnPublicationDetail?id="+id;
			location.href="/product/getEBookContent?period="+id;
		}
		
		//未出版期刊
		function qikanNone(){
			tipinfo("未出版");
		}
	</script>
	</pxkj:Content>
</pxkj:ContentPage>
