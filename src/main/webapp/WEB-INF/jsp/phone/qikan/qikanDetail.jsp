<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<style type="text/css">
			.cuXiao{
				padding:0.6rem;
				font-size: 0.6rem;
				border-top:1px solid #ddd;
				border-bottom:1px solid #ddd;
			}
			.xxxq_di{
				margin-top:0 !important;
			}
			.song{
				/* padding:0.3rem 1.2rem; */
				font-size: 0.5rem;
				color: red !important;
				line-height: 0.8rem;
				/* margin:0 0.6rem 0 1.2rem; */
				/* border-radius: 1.5rem;
				color:#fff !important;
				background: #EA4C88; */
			}
			.top h3 {
			    font-size: 0.6rem;
			    line-height: 2.25rem;
			    text-align: center;
		    }
			.top a.a3 {
			    position: absolute;
			    top: 0.65rem;
			    right: 1.85rem;
			}
			img {
			max-width: 100%; /*图片自适应宽度*/
			}
			body {
			overflow-y: scroll !important;
			}
			.view {
			word-break: break-all;
			}
			.vote_area {
			display: block;
			}
			.vote_iframe {
			background-color: transparent;
			border: 0 none;
			height: 100%;
			}
			.hj_qr{
				height:2rem;
			}
			.hj_qr a.ljgm_biao{
				width:100% !important;
				line-height:2rem;
			}
	</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<title>杂志详情</title>
		<div class="top">
			<a href="/product/turnPublication" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<%-- <h3>${item.name }</h3> --%>
			<c:if test="${favorite==0 }">
				<a href="javascript:void(0)" onclick="addCollection(${id},1)" class="a2"><img id="img" style="height: 20px" src="/images/c2.png"></a>
			</c:if>
			<c:if test="${favorite!=0 }">
				<a href="javascript:void(0)" onclick="addCollection(${id},2)" class="a2"><img id="img" style="height:20px" src="/images/c.png"></a>
			</c:if>
			<input type="hidden" id="fa" value="${favorite }"><!-- 添加或取消收藏的表示 -->
			<input type="hidden" id="types" value="1"><!-- 纸质或电子书的标识 1纸质2电子-->
			<%-- <a href="javascript:void(0)" onclick="addCart(${id})" class="a2"><img src="/images/gwc_biao.png" class="gwc_biao"></a> --%>
		</div>
		<div class="xxxq">
			<div class="xxxq_top">
				<div class="zjkc_nr zjkc_nr1">
					<img src="${picture}">
					<div class="zjkc_nr_r">
						<h3>${name }</h3>	
						<c:choose>
							<c:when test="${isSalePaper != '1' }">
								<h5>￥${ebookPrice}</h5>
								<c:if test="${yuanEbookPrice != ebookPrice}">
								<h6 style="color:#888;margin-left: 2px;text-decoration:line-through;">￥${yuanEbookPrice}</h6>
								</c:if>
							</c:when>
							<c:otherwise>
								<h5>￥${paperPrice}</h5>
								<c:if test="${yuanPaperPrice != paperPrice}">
								<h6 style="color:#888;margin-left: 2px;text-decoration:line-through;">￥${yuanPaperPrice}</h6>
								</c:if>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="clear"></div>
					<p style="font-size: 0.55rem;color: #666666;text-align:right;line-height: 0.8rem;"><a class="song" href="javascript:void(0)" style="float: left;">${buySendList[0].name }</a>累计销售 &nbsp; ${sales }</p>
				</div>
			</div>
			<%-- <c:if test="${isBuySend > 0 }">
				<div class="cuXiao">
					促销
					<a class="song" href="javascript:void(0)">${buySendList[0].name }</a>
					${buySendList[0].remark }
				</div>
			</c:if> --%>
			<div class="xxxq_di">
				<!-- <div class="xxk xxk2">
					<ul>
						<li class="on"><span>本期内容</span></li>
					</ul>
				</div> -->
				<div class="xxxq_nr" style="padding: 0.5rem 0.5rem 2rem;">
					<c:if test="${describes != 'null' }">
						${describes }
					</c:if>
					<%-- <c:if test="${describes == 'null' }">
						暂时没有数据
					</c:if> --%>
				</div>
			</div>
		</div>

		<div class="hj_qr">
			<!-- <a href="javascript:void(0)" class="ljgm_biao" onClick="showBox(1)">加入购物车</a> -->
			<a href="javascript:void(0)" class="ljgm_biao" onClick="showBox(1)">立即购买</a>
			<!-- <a href="javascript:void(0)" onClick="showBox()" class="ljgm_biao " style="background: #f00;">加入购物车</a> -->
		</div>
		
		
		<!--购物车-->
	<div class="gwc_tk" id="login_box" style="display:none;">
		<div class="cptu">
			<img src="${picture }">
			<p><span >￥<i id="prices"> ${paperPrice}</i></span><br>请选择购买类型和套餐</p>
			<div class="clear"></div>
		</div>
		<div class="lx_mk" id="type1" >
			<h3>类型</h3>
			<a href="javascript:void(0)" class="on" data-va="1" data-price="${paperPrice}">纸媒版</a>
			<a href="javascript:void(0)" data-va="2" data-price="${ebookPrice }">电子版</a>
			<div class="clear"></div>
		</div>
		<div class="lx_mk">
			<h3>套餐分类</h3></div>
		<div class="lx_mk" id="type2">
			<h3></h3>
			<c:choose>
				<c:when test="${sumType eq '1' && isSalePaper>0 }">
					<a href="javascript:void(0)" data-va="2" data-id="${id }" data-name="${name }" data-price="${paperPrice }">上半年</a>
				</c:when>
				<c:when test="${sumType eq '2' && isSalePaper>0 }">
					<a href="javascript:void(0)" data-va="3" data-id="${id }" data-name="${name }" data-price="${paperPrice }">下半年</a>
				</c:when>
				<c:when test="${sumType eq '3' && isSalePaper>0 }">
					<a href="javascript:void(0)" data-va="4" data-id="${id }" data-name="${name }" data-price="${paperPrice }">全年</a>
				</c:when>
				<%-- <c:when test="${bookList[0].isSalePaper > 0 }">
					<a href="javascript:void(0)" data-va="1" data-id="${id }" data-name="${name }" data-price="${paperPrice}">单期</a>
				</c:when> --%>
				<c:when test="${sumType eq '4' && isSalePaper>0  }">
					<a href="javascript:void(0)" data-va="4" data-id="${id }" data-name="${name }" data-price="${paperPrice}">双刊</a>
				</c:when>
				<c:when test="${isSalePaper > 0 }">
					<a href="javascript:void(0)"  data-va="1" data-id="${id }" data-name="${name }" data-price="${paperPrice }">单期</a>
				</c:when>
			</c:choose>
			<c:forEach var="list" items="${bookList }">
				<c:if test="${list.sumType eq '3' && list.isSalePaper>0 }">
					<a href="javascript:void(0)" data-va="4" data-id="${list.id }" data-name="${list.name }" data-price="${list.paperPrice }">全年</a>
				</c:if>
				<c:if test="${list.sumType eq '1' && list.isSalePaper>0 }">
					<a href="javascript:void(0)" data-va="2" data-id="${list.id }" data-name="${list.name }" data-price="${list.paperPrice }">上半年刊</a>
				</c:if>
				<c:if test="${list.sumType eq '2' && list.isSalePaper>0 }">
					<a href="javascript:void(0)" data-va="3" data-id="${list.id }" data-name="${list.name }" data-price="${list.paperPrice }">下半年刊</a>
				</c:if>
			</c:forEach>
			<div class="clear"></div>
		</div>
		<div class="lx_mk" id="type3" style="display:none;">
			<h3></h3>
			<c:choose>
				<c:when test="${sumType eq '1' && isSaleEbook>0 }">
					<a href="javascript:void(0)" data-val="2" data-id="${id }" data-name="${name }" data-price="${paperPrice }">上半年</a>
				</c:when>
				<c:when test="${sumType eq '2' && isSaleEbook>0 }">
					<a href="javascript:void(0)" data-val="3" data-id="${id }" data-name="${name }" data-price="${paperPrice }">下半年</a>
				</c:when>
				<c:when test="${sumType eq '3' && isSaleEbook>0 }">
					<a href="javascript:void(0)" data-val="4" data-id="${id }" data-name="${name }" data-price="${paperPrice }">全年</a>
				</c:when>
				<c:when test="${sumType eq '4' && isSaleEbook>0 }">
					<a href="javascript:void(0)" data-val="4" data-id="${id }" data-name="${name }" data-price="${paperPrice }">双刊</a>
				</c:when>
				<c:when test="${status > 0 }">
					<a href="javascript:void(0)" data-val="1" data-id="${id }" data-name="${name }" data-price="${ebookPrice }">单期</a>
				</c:when>
			</c:choose>
			<c:forEach var="list" items="${bookList }">
				<c:if test="${list.sumType eq '3' && list.ebook>0 }">
					<a href="javascript:void(0)" data-val="4" data-id="${list.id }" data-name="${list.name }" data-price="${list.ebookPrice }">全年</a>
				</c:if>
				<c:if test="${list.sumType eq '1' && list.ebook>0 }">
					<a href="javascript:void(0)" data-val="2" data-id="${list.id }" data-name="${list.name }" data-price="${list.ebookPrice }">上半年刊</a>
				</c:if>
				<c:if test="${list.sumType eq '2' && list.ebook>0 }">
					<a href="javascript:void(0)" data-val="3" data-id="${list.id }" data-name="${list.name }" data-price="${list.ebookPrice }">下半年刊</a>
				</c:if>
			</c:forEach>
			<div class="clear"></div>
		</div>
		<div class="gmsl">
			购买数量
			<div class="cpsl_jj" id="cpsl_jj">
				<a href="javascript:min();">-</a>
				<input type="text" value="1" id="count" onkeyup="if (!(/^[\d]+\.?\d*$/.test(this.value)) ){tipinfo('请输入数字'); this.value='1';this.focus();}"/>
				<a href="javascript:add();">+</a>
			</div>
		</div>
		<a href="javascript:void(0);" onClick="deleteLogin()" class="gb_biao"><img src="/images/gb_biao.png"></a>
        <button type="button" id="Btn_Save" onClick="save()"  class="ljzf_biao">加入购物车</button>
	</div>
	<div class="bg_color" onClick="deleteLogin()" id="bg_filter" style="display: none;"></div>
	<input type="hidden" value=${picture } id="picture">
	<input type="hidden" value=${name } id="perName">
	<input type="hidden" value=${ebookPrice } id="ebookprice">
	<input type="hidden" value=${paperPrice } id="paperPrice">
	<input type="hidden" value=${id } id="productid">
	<input type="hidden" value=${period } id="period">
	<input type="hidden" value=${desc } id="desc">
	<input type="hidden" value="1" id="book">
	<input type="hidden" value="${sumType }" id="type">
	<input type="hidden" value="0" id="pay">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		function min(){
			if($("#count").val()==1){
				return ;
			}
			$("#count").val(Number($("#count").val())-1);
			var type = $("#type1 .on").data("va");
			/* var ids = $("#period").val();
			arr=ids.split(','); */
			var count = $("#count").val(); 
			if(type==1){
				//纸质书
				var paperPrice = $("#paperPrice").val();
				//$("#prices").html((paperPrice*arr.length*count).toFixed(2));
				$("#prices").html((paperPrice*count).toFixed(2));
			}else{
				//电子书
				//$("#prices").html(($("#ebookprice").val()*arr.length*count).toFixed(2));
				$("#prices").html(($("#ebookprice").val()*count).toFixed(2))
			}
		}
		function add(){
			$("#count").val(Number($("#count").val())+1);
			var type = $("#type1 .on").data("va");
			/* var ids = $("#period").val();
			arr=ids.split(','); */
			var count = $("#count").val(); 
			if(type==1){
				//纸质书
				var paperPrice = $("#paperPrice").val();
				//$("#prices").html((paperPrice*arr.length*count).toFixed(2));
				$("#prices").html((paperPrice*count).toFixed(2));
			}else{
				//电子书
				//$("#prices").html(($("#ebookprice").val()*arr.length*count).toFixed(2));
				$("#count").val(1);
				return;
			}
		}
		$("#type1 a").click(function(){
			//清除type1,2的显示
			$('#type2').css("display","none");
			$('#type3').css("display","none");
			//移除type1下的所有a标签的样式
			$(this).siblings().removeClass("on");
			//移除type2，3下所有a标签的样式
			$('#type2').find('a').siblings().removeClass("on");
			$('#type3').find('a').siblings().removeClass("on");
			//点击元素增加样式
			$(this).addClass("on");
			//添加type1,2的默认第一个的样式
			type23();
			$("#book").val($(this).data("va"));
			/* var ids = $("#period").val();
			arr=ids.split(','); */
			var count = $("#count").val();
			if($(this).data("va")==1){
				var price = $('#type2').find('a:first').data("price");
				$('#prices').html(price);
				$('#paperPrice').val(price);
				$('#type2').css("display","");
				var paperPrice = $("#paperPrice").val();
				$("#prices").html((paperPrice*count).toFixed(2));
				//$("#prices").html((paperPrice*arr.length*count).toFixed(2));
			}else{
				$("#count").val(1);
				var price = $('#type3').find('a:first').data("price");
				$('#prices').html(price);
				$('#ebookprice').val(price);
				$('#type3').css("display","");
				//$("#prices").html(($("#ebookprice").val()*arr.length).toFixed(2));
				$("#prices").html(Number($("#ebookprice").val()).toFixed(2));
			}
			//type23Click();
		})
		
		//默认点击纸媒版,第一个类型
		$(function(){
			$('#type1').find('a:first').click();
			type23();
			type23Click();
		});
		function type23Click(){
			$('#type2').find('a:first').click();
			//$('#type3').find('a:first').click();
		}
		
		function type23(){
			$('#type2').find('a:first').addClass("on");
			$('#type3').find('a:first').addClass("on");
		}
		
		$("#type2 a").click(function(){
			var count = $("#count").val(); 
			$(this).siblings().removeClass("on");
			$(this).addClass("on");
			$("#type").val($(this).data("va"));
			$("#perName").val($(this).data("name"));
			var paperPrice = $(this).data("price");
			$('#paperPrice').val(paperPrice);
			$("#prices").html(($('#paperPrice').val()*count).toFixed(2));
			var productid = $(this).data("id");
			$("#productid").val(productid);
		});
		
		$("#type3 a").click(function(){
			var count = $("#count").val(); 
			$(this).siblings().removeClass("on");
			$(this).addClass("on");
			$("#type").val($(this).data("val"));
			$("#perName").val($(this).data("name"));
			var price = $(this).data("price");
			$('#ebookprice').val(price);
			$("#prices").html(($("#ebookprice").val()*arr.length*count).toFixed(2));
			var productid = $(this).data("id");
			$("#productid").val(productid);
		});
		
		function deleteLogin() {
			var del = document.getElementById("login_box");
			var bg_filter = document.getElementById("bg_filter");
			bg_filter.style.display = "none";
			del.style.display = "none";
		}

		function showBox(type) {
			$('#type1').find('a:first').click();
			type23();
			var show = document.getElementById("login_box");
			var bg_filter = document.getElementById("bg_filter");
			show.style.display = "block";
			bg_filter.style.display = "block";
			var text="加入购物车";
			if(type==1){
				text="立即购买";
			}else{
				type=0;
			}
			document.getElementById("Btn_Save").innerText=text;
			document.getElementById("pay").value=type;
		}
		
		function save(){
			var type = $("#pay").val();
			var types = $("#type1 .on").data("va");
			var producttype;
			if(types==1){
				producttype=2;
			}else{
				producttype=16;
			}
			if($("#type2").css("display")=="none"){
				if($("#type3").css("display")=="block"){
					var html = ($("#type3").text()).toString();
					console.log(html.length);
					if(html.length == 48){
						tipinfo("请选择商品！");
						return ;
					}
				}
			}
			if($("#type3").css("display")=="none"){
				if($("#type2").css("display")=="block"){
					var html = ($("#type2").text()).toString();
					console.log(html.length);
					if(html.length == 53){
						tipinfo("请选择商品！");
						return ;
					}
				}
			}
			//加入购物车
			$.ajax({
					type : "POST",
					url : "/periodical/addShopCart",
					async : false,
					data : {
						productid : $("#productid").val(),
						count : $("#count").val(),
						producttype : producttype,
						productpic:$("#picture").val(),
						productname:$("#perName").val(),
						desc:$("#desc").val(),
						type:type,
						subType:$("#type").val()
						},
					success : function(obj) {
						if(obj.result==0&&obj.needLogin){
							tipinfo(obj.msg);
							location.href="/allow/login?redirectUrl="+encodeURI(location.href);
							return false;
						}
						if(type==0){
							if(obj.result==1){
								tipinfo("加入购物车成功");
								deleteLogin();
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
							window.location.href="/order/turnJieSuan?shoppingIds="+id+"&url="+url+"&r="+Math.random();
						}
					},
					error : function(data) {
						tipinfo("出错了!");
					}
			});
		}
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
						$("#img").attr('src',"/images/c.png");
					}
					if(data.type==2){
						$("#fa").val("1");
						$("#img").attr('src',"/images/c2.png"); 
					}
				},
				error : function(data) {
				}
			});
		}
		//跳转购物车
		function addCart(){
			window.location.href="/usercenter/order/buglog";
		}
	</script>
	</pxkj:Content>
</pxkj:ContentPage>
