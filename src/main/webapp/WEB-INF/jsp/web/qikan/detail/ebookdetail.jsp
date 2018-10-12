<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link rel="stylesheet" href="/css/ebook/pageCss.css"/>
		<link rel="stylesheet" href="/css/ebook/style123.css" />
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
	<div class="shadow"></div>
		<div class="maincon clearfix">

			<div class="left_qk fl">
				<div class="browse_way">
					<ul class="browse_way_tab clearfix">
						<li class="handleItem cur">图文模式</li>
						<li class="handleItem">翻页模式</li>
						<li><a href="/product/turnPublicationDetail?id=${id }">购买纸质</a></li>
					</ul>
					<div class="browse_way_tabcon">
						<div id="main">
							<a class="backMenu" href="javascript:void(0)">目录</a>
							<div class="menu" id="menu">
								<p class="title"><b></b>目录</p>
								<div class="menuCon" style="height:86%;">
									<%-- <c:forEach items="${column }" var="item"> --%>
										<div class="columnStyle" data-target="menu-item">
											<div class="circleBox"  lay-accordion="" style="margin-top:10px;overflow-y: scroll;height:100%;">
											<div class="leftUl main-item main-left" style="width:48%;float:left;">
											
											</div>
											
											<div class="rightUl main-item main-right" style="width:49%;float:right;">
												
											</div>
											
											</div>
										</div>
									<%-- </c:forEach> --%>
								</div>
							</div>
							<div class="Content">
								<div class="menuItem" id="menu-item">
									
								</div>
							</div>
							<a href="javascript:void(0)" id="fullpage" class="full_sc" style="color:red;">全 屏</a>
						</div>
						<div style="display: none;" id="main2" class="main">
							<div id="flipbook">
							</div>
							
							<img class="page-action" id="previous" src="/img/lb_left.png">
							<img class="page-action" id="next" src="/img/lb_right.png">
							<a href="javascript:void(0)" class="page-action" id="fullscreen" style="color:red;">全 屏</a>
							<img id="OratioImg">
							<div class="Articleitem">
								<img class="close" src="/img/del.png">
								<h1 class="Articleitem-title" style="margin:20px 0;"></h1>
								<div class="Articleitem-content">
				
								</div>
							</div>
							
						</div>
						
					</div>
				</div>
				<%-- <div class="qk_info clearfix">
					<p>${detail.PublicationName}</p><p>${detail.Description}</p><span>${detail.PublishDate }</span>
					
					<div class="bdsharebuttonbox2">
						<a href="javascript:void(0)" onclick="collection('${PublicationID}','${IssueID}',1,this);" class="${(detail.isBuy=='0'?'collect':'collected') } fr"></a>
					</div>
					<div class="bdsharebuttonbox">
						<a href="javascript:void(0)" style="margin:20px 15px 0 0;" class="share fr"  data-cmd="more" onclick="share('${detail.IssueID }','${detail.PublicationID }')" ></a>
					</div>
					
				</div> --%>
			</div>
			<div class="right_qk fr">
				<div class="rtcon">
					<h5>期刊简介</h5>
					<p>销售与市场

《销售与市场》杂志创刊于1994年，是中国内地第一

家大型营销专业期刊。秉承“专业性、实战性、权威性

、国际性”的办刊理念，及“反映中国营销主流，引领

中国营销潮流，见证并推动中国营销进步”的办刊宗

旨，创刊以来，以全球化视野，关注中国市场发展

趋势，致力为中国企业指引方向，提供最先进的营

销理念与实务方法工具，不断提炼实战案例，坚持

执着专业研究，成为中国内地财经领域营销媒体的

一面旗帜，被业内誉为“中国营销第一刊”。</p>
				</div>
				<div class="rtcon">
					<h5>基本信息</h5>
					<ul>
						<li>主管单位：<span>销售与市场</span></li>
						<li>主办单位：<span>销售与市场</span></li>
						<li>国内刊号：<span>51-1056/G4</span></li>
						<li>发行周期：<span>月刊</span></li>
						<li>邮发代号：<span>62-101</span></li>
						<li>创刊时间：<span>1994年</span></li>
					</ul>
				</div>
				<div class="rtcon">
					<h5>往期杂志</h5>
					<div class="clearfix">
						<c:forEach items="${datalist }" begin="0" end="3" varStatus="status" >
							<a onclick="/product/turnPublicationDetail?id=${item.id}">
								<img src="${item.picture }" alt="" />
							</a>
							<div class="data-ins">
								<span>${item.name }</span>
								<p>
									<span>${item.year }</span>
									<span>${item.sales }人付款</span>
								</p>
							</div>
						</c:forEach>
					</div>
					<p class="showmore">
						<a href="/product/toQikan">查看更多&gt;&gt;</a>
					</p>					
				</div>
			</div>
		</div>
		<input type="hidden" id="bookData" value='' />
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/ebook/cufon-yui.js" type="text/javascript"></script>
		<!-- <script src="/manage/public/layui/layui.js"></script> -->
		<script src="/js/jquery.js"></script>
		<script type="text/javascript" src="/js/ebook/turn.js"></script>
		<script>
		$("#register2").click(function(){
			openwindow('/login/toRegister2',"注册",360,410,false,function(){
				window.location.reload();
			});
		});
		$("#login2").click(function(){
			openwindow('/login/toLogin2',"登录",340,240,false,function(){
				window.location.reload();
			});
		});
		function tip(obj){
			tipinfo(obj);
		}
		
		var bookTitleTemplete = '<div class="title bookTitle">● {name}</div>';
		var bookSubtitleTemplete = '<div class="title bookSubtitle">{name}</div>';
		/* *********此处注释********** */
		
		var jsonCol;
		var defaultW, defaultH; //初始宽高;
		var isFull = 0; //是否全屏
		var OriginalHtml;//原始数据
		var OriginalData = [];
		var OratioW = 1; //当前宽度系数
		var OratioH = 1; //当前高度系数
		var OriginalW = 1724,
			OriginalH = 2339; //原始图片宽度和高度
		
		window.onresize = function(){
			if(!checkFull()){
			$('#qxfullpage').click();
			$('#qxfullpage2').click();
			}
		}
		function checkFull(){
			var isFull =  document.fullscreenEnabled || window.fullScreen || document.webkitIsFullScreen || document.msFullscreenEnabled;

			//to fix : false || undefined == undefined
			if(isFull === undefined) isFull = false;
			return isFull;
		}
		
		
			/* layui.use(['element', 'layer'], function(){
			  var element = layui.element;
			  var layer = layui.layer;
			  //监听折叠
			  element.on('collapse(test)', function(data){
			    layer.msg('展开状态：'+ data.show);
			  });
			}); */
		</script>
		<script type="text/javascript">
			var rwidth = 900;
			var rheight = 600;
			Cufon.replace('h1,p,.b-counter');
			Cufon.replace('.book_wrapper a', {hover:true});
			Cufon.replace('.title', {textShadow: '1px 1px #C59471', fontFamily:'ChunkFive'});
			Cufon.replace('.reference a', {textShadow: '1px 1px #C59471', fontFamily:'ChunkFive'});
			Cufon.replace('.loading', {textShadow: '1px 1px #000', fontFamily:'ChunkFive'});
			
			$(function() {
				var data = ${columnData };
				jsonCol = data.itemlist;
				GetJsonStr();
				loadContainer();
				initData();
				
				defaultW = $('#main2').width(); //获取容器初始宽度
				defaultH = $('#main2').height(); //获取容器初始高度
				OriginalHtml = $('#flipbook').html();
				$("#flipbook").turn({ //杂志初始化
					width: defaultW,
					height: defaultH,
					autoCenter: true,
					page: 1
				});

				$('#next').click(function() { //下一页
					$("#flipbook").turn("next");
				})

				$('#previous').click(function() { //上一页
					$("#flipbook").turn("previous");
				})

				$('#fullscreen').click(function() { //全屏
					isFullScreen();
				})
				$('.close').click(function() {
				$('.Articleitem').hide()
			})
				$('.flipbook-item').click(function(){
					
//					alert($(this).attr('data-id'));
//					event.preventDefault();　　　
				})

				$(window).keydown(function(event) {
					if(event.keyCode == 27) { //监听ESC按键
						if(isFull == 1) { //判断当前是否为全屏模式
							isFullScreen();
						}
					}
				});
				
				onloadpic();
			})
			
			function pad(num, n) { //数字，位数
			return Array(n > (num.toString()).split('').length ? (n - ('' + num).length + 1) : 0).join(0) + num;
		}

		function initData() {
			/* *********此处注释********** */
			var data = ${DocData };
			var lastImgUrl = "";
			var pageItem = {};
			pageItem.Articles = [];
			for(var i = 0; i < data.data.length; i++) {
				var item = data.data[i];

				var RecPoint = JSON.parse(item.RecPoint)

				for(var j = 0; j < RecPoint.list.length; j++) {
					var Ritem = RecPoint.list[j];

					var thisImgUrl = GetImgUrl(item.FinalPic, Ritem.page);
					if(lastImgUrl != thisImgUrl) {
						if(i != 0) { //判断不是第一个
							OriginalData.push(pageItem);
							pageItem = {};
							pageItem.Articles = [];
						}

						lastImgUrl = thisImgUrl;
						pageItem.pageUrl = thisImgUrl;

					}

					var ArticleItem = {};
					ArticleItem.page = Ritem.page;
					ArticleItem.Title = item.Title;
					ArticleItem.DocID = item.DocID;
					ArticleItem.MainText = item.MainText;
					ArticleItem.RecPoint = Ritem.data;
					pageItem.Articles.push(ArticleItem);

				}
			}

			buildOriginalHtml();

		}

		function buildOriginalHtml() {
			$('#flipbook').empty();
			for(var a = 0; a < OriginalData.length; a++) {
				var OriginalDataItem = OriginalData[a];

				if(a == 0) //获取图片真实宽高
				{
					var oImg = new Image();
					oImg.src = "${urlImg}" + OriginalDataItem.pageUrl + "";
					oImg.onload = function() {
						console.log(oImg.naturalHeight);
						console.log(oImg.naturalWidth);
						OriginalW = oImg.naturalWidth;
						OriginalH = oImg.naturalHeight;
						computeRatio(defaultW, defaultH)
					}
				}

				var templeteHtml = '<div class="flipbook-item" data-id="' + a + '"><img class="bookMain" src="${urlImg}' + OriginalDataItem.pageUrl + '" usemap="#planetmap' + a + '">';
				templeteHtml += '<map name="planetmap' + a + '" id="planetmap' + a + '">';
				for(var b = 0; b < OriginalDataItem.Articles.length; b++) {
					var OArticleItem = OriginalDataItem.Articles[b];
					templeteHtml += "<area shape=\"poly\" class=\"page-item\" onclick=\"openItem(this)\" data-title=\"" + OArticleItem.Title + "\" data-MainText='" + OArticleItem.MainText + "' coords='" + NewRecPoint(OArticleItem.RecPoint) + "'  alt=\"Venus\" />";
				}

				templeteHtml += '</map></div>';

				$('#flipbook').append(templeteHtml)
			}

		}

		function openItem(i) {　
			$('.Articleitem-content').animate({　　　　　　
				scrollTop: 0,
				　　　　
			}, 0)//滚动到顶部
			$('.Articleitem').show();
			$('.Articleitem-title').html($(i).attr('data-title'));
			$('.Articleitem-content').html($(i).attr('data-MainText'));
			//alert($(i).attr('data-title'))
		}

		function GetImgUrl(imgurl, index) {
			/* imgurl = imgurl.substring(2, imgurl.length).replace("_s", "");
			var imgDatas = imgurl.split('_');
			var imgName = imgDatas[1].split('.');

			return imgDatas[0] + "_pages" + pad(index, 4) + "." + imgName[1]  */
			
			var TestImg = imgurl.split('|')[0];
			return TestImg + "_pages" + pad(index, 4) + "_s.jpg";
			
		}
			
			
			
			function isFullScreen() {
			var ratio = defaultW / defaultH;
			var thispage = $("#flipbook").turn("page"); //获取当前页码
			if(isFull == 0) {
				$('#fullscreen').html("退 出");
				var ww = $(window).width() * 0.9;
				var wH = $(window).height() * 0.8;
				$('#main2').addClass('fullbook');
				$('.shadow').show();
				refreshBook(ww, wH, thispage, ratio);
				isFull = 1;
			} else {
				$('#fullscreen').html("全 屏");
				var ww = defaultW;
				var wH = defaultH;
				$('#main2').removeClass('fullbook');
				$('.shadow').hide();
				refreshBook(ww, wH, thispage, ratio);
				isFull = 0;
			}
		}

		function refreshBook(w, h, page, ratio) {

			$('#main2').css('width', w);
			$('#main2').css('height', h);
			$("#flipbook").turn("destroy"); //清空杂志所有内容
			$("#flipbook").attr("style", ""); //清空行内所有样式
			$("#flipbook").html(OriginalHtml);//为容器重新赋值
			$("#flipbook").turn({
				width: (h * ratio),
				height: h,
				autoCenter: true,
				page: page
			});
		}
		function NewRecPoint(s) {
			var RecPoints = s.split(',');
			for(var i = 0; i < RecPoints.length; i++) {
				if(i % 2 == 0) { //判断是否为X轴
					RecPoints[i] = RecPoints[i] * OratioW;
				} else {
					RecPoints[i] = RecPoints[i] * OratioH;
				}
			}
			return RecPoints.join(',');
		}

		function computeRatio(w, h) {
			console.log("宽1:" + w + "|高1:" + h);
			OratioW = w / OriginalW;
			OratioH = h / OriginalH;

			console.log("宽:" + OratioW + "|高:" + OratioH)
		}

		function getImgNaturalDimensions2(oImg) { //获取图片真实宽高
			　　
			var nWidth, nHeight;　　
			if(!oImg.naturalWidth) { // 现代浏览器
				　　
				nWidth = oImg.naturalWidth;　　
				nHeight = oImg.naturalHeight;　　
				return({
					w: nWidth,
					h: nHeight
				});
			} else { // IE6/7/8
				　　　　
				nWidth = oImg.width;　　　　
				nHeight = oImg.height;　　　　
				return({
					w: nWidth,
					h: nHeight
				});　　
			}
		}
			function onloadpic(){
				var imgs = $('.TarImg');
				for(var i = 0; i < imgs.length; i++){
					maxwidth = $(imgs[i]).width();
					maxheight = $(imgs[i]).height();
					$(imgs[i]).siblings('.Main').css("width", maxwidth);
					$(imgs[i]).siblings('.Main').css("height", maxheight);
					require.config({
						packages:[
									{
										name: 'zrender',
										location: '/js/ezine/zrender/src',
										main: 'zrender'
									}
								]
					});
		
					var show = false;
		
					require(
							[
							 "zrender",
							 "zrender/tool/area",
							 'zrender/tool/util',
							 'zrender/tool/color',
							 'zrender/tool/event',
							 'zrender/shape/Polygon',
							 'zrender/shape/Text'
							 ],
							function (zrender, area, util, color, event, PolygonShape, TextShape) {
								var colorIdx = 0;
								// 初始化zrender
								zr = zrender.init(document.getElementById("Main"));
								zr.clear();
								color.customPalette(['red', 'black'])
								//生成路径
								$("area").each(function () {
								//标题
								var text = $(this).attr("title");
								//文章id
								var DocID = $(this).attr("href");
								//热区坐标
								var p = $(this).attr("coords").split(',');
								var pathdata = [];
								
								for (var i = 0; i < p.length; ) {
										pathdata[pathdata.length] = [Number(p[i])*1.85, Number(p[i + 1])*1.8];
										i += 2;
								}
								
								zr.addShape(new PolygonShape({
								style: {
									pointList: pathdata,
									brushType: "stroke",
									strokeColor: color.getColor(0),
									lineWidth: 1,
									text: '',
									textPosition: 'bottom'
								},
								clickable: true,
								draggable: false,
								invisible: true,
								hoverable: false,
								
								onclick: function () {
									//跳转弹窗显示文章详情
									selDoc(DocID,null);
									return true;
								},
								
								onmouseover: function (param) {
									var shape = param.target;
									shape.invisible = false;
									
									zr.modShape(shape.id, shape);
									zr.refresh();
									
									var shapepath = shape.style.pointList;
									
									var x1 = 0, x2 = 0, y1 = 0, y2 = 0;
									
									for (var i = 0; i < shapepath.length; i++) {
										if (i == 0) {
											x1 = shapepath[i][0];
											y1 = shapepath[i][1];
										}
										if (x1 > shapepath[i][0]) {
											x1 = shapepath[i][0];
										}
										
										if (x2 < shapepath[i][0]) {
											x2 = shapepath[i][0];
										
										}
										
										if (y1 > shapepath[i][1]) {
											y1 = shapepath[i][1];
										}
										
										if (y2 < shapepath[i][1]) {
											y2 = shapepath[i][1];
										
										}
									}
									
									var tx = x1 + ((x2 - x1) / 2);
									//var ty=y1+(y2-y1)/2;
									tx+=$("#Main").offset().left;
									var ty = y1;
									ty+=$("#Main").offset().top;
									
									if (!show) {
										$('#test').poshytip({
											content: text,
											className: 'tip-yellowsimple',
											showTimeout: 1,
											alignTo: 'target',
											alignX: 'center',
											offsetY: 5,
											allowTipHover: false,
											showOn: 'none'
										});
										show = true;
									}else {
										$('#test').poshytip("update", text);
									}
									
									$('#test').css("left", (tx-340));
									$('#test').css("top", (ty-100));
									$('#test').poshytip("show");
								},
								onmouseout: function (param) {
									var shape = param.target;
									shape.invisible = true;
									zr.modShape(shape.id, shape);
									zr.refresh();
									
									$('#test').poshytip("hide");
								}
							}));
						});
						zr.render();
					});
				}
			}
			
			function GetJsonStr(){
				var TemplatrJson = [];
				for(var i = 0; i < jsonCol.length; i++){
					var obj1 = new Object();
					obj1["name"] = jsonCol[i].ColumnName;
					obj1["level"] = jsonCol[i].level;
					TemplatrJson.push(obj1);
					var listStr = jsonCol[i].docList;
					for(var j = 0; j < listStr.length; j++){
						var item = listStr[j];
						var obj2 = new Object();
						obj2["name"] = "<a href='javascript:void(0)' onclick='selArticle("+item.DocID+");'>"+item.Title+"</a>";
						obj2["level"] = item.level;
						TemplatrJson.push(obj2);
					}
				}
				console.log("获得数组："+JSON.stringify(TemplatrJson));
				$('#bookData').val(JSON.stringify(TemplatrJson));
				
				Catalog();
			}
			function Catalog() {
				var data = JSON.parse($('#bookData').val());
				console.log("data:"+ data);
				var tH = data.length * 50; //总高度
				var viewM = $('.main').height(); //容器高度
				var type = 1; //类型  
				if(tH > viewM) //数据总高度没有超过容器高度
				{
					type = 2; //类型  
				}

				for(var i = 0; i < data.length; i++) {
					var item = data[i];
					if(type == 1 || (type == 2 && i <= (data.length / 2) && tH >= (viewM * 2)) || (type == 2 && tH < (viewM * 2) && ((i + 1) * 50 <= viewM))) {
						//				if(type == 1 || (type == 2 && i <= (data.length / 2))) {

						$('.main-left').append(getTemplete(item.level).replace('{name}', item.name))
					} else {
						$('.main-right').append(getTemplete(item.level).replace('{name}', item.name))
					}

				}
			}

			function getTemplete(index) {
				var THTML = "";
				if(index == 1) {
					THTML = bookTitleTemplete;
				} else {
					THTML = bookSubtitleTemplete;
				}

				return THTML;
			}
			function loadContainer(){
				var $mybook 		= $('#mybook');
				var $bttn_next		= $('#next_page_button');
				var $bttn_prev		= $('#prev_page_button');
				var $loading		= $('#loading');
				var $mybook_images	= $mybook.find('.b-load>div');
				var cnt_images		= $mybook_images.length;
				var loaded			= 0;
				//preload all the images in the book,
				//and then call the booklet plugin

				$mybook_images.each(function(){
					//加载热区
					loadPoints($(this));
					++loaded;
						if(loaded == cnt_images){
							$loading.hide();
							$bttn_next.show();
							$bttn_prev.show();
							$mybook.show().booklet({
								name:               null,                            // 要在文档标题栏中显示的小册子的名称
								width:              rwidth,                             // 容器宽度
								height:             rheight,                             // 容器高度
								speed:              1000,                             // 页面之间的转换速度
								direction:          'LTR',                           // 的整体内容组织、方向默认LTR，左到右，可以是RTL语言从右至左
								startingPage:       0,                               // 要显示的第一页的索引
								easing:             'easeInOutQuad',                 // 完全缓和的缓和方法
								easeIn:             'easeInQuad',                    // 上半年缓和法
								easeOut:            'easeOutQuad',                   // 缓和过渡后半段法

								closed:             true,                           // 从书“封闭”开始，在书的开头和结尾加上空页。
								closedFrontTitle:   null,                            // 用“封闭式”、“菜单”和“pageselector”，确定空白起始页标题
								closedFrontChapter: null,                            // 用“封闭式”、“菜单”和“chapterselector”，确定章名称空白起始页
								closedBackTitle:    null,                            // 用“封闭式”、“菜单”和“pageselector”，确定空白结束页章的名字
								closedBackChapter:  null,                            // 用“封闭式”、“菜单”和“chapterselector”，确定空白结束页章的名字
								covers:             false,                           // 使用“关闭”，使第一页和最后页成为封面，没有页码（如果启用）

								pagePadding:        10,                              // 每个页面包装器的填充
								pageNumbers:        true,                            // 显示每页上的页码

								hovers:             false,                            // 使pageturn悬停预览动画，显示一个小的预览悬停前或下一页
								overlays:           false,                            // 使导航使用的页大小的叠加，当启用里面的内容将不会被点击的链接
								tabs:               false,                           // 在页面顶部添加制表符
								tabWidth:           60,                              // 设置选项卡的宽度。
								tabHeight:          20,                              // 设置选项卡的高度
								arrows:             false,                           // 添加箭头叠加在书边
								cursor:             'pointer',                       // 侧栏区域的光标CSS设置

								hash:               true,                           // 使导航使用哈希字符串，例如：# /页/ 1，1页的小册子，将影响所有“散列”启用
								keyboard:           true,                            // 启用带箭头键的导航（左：前，右：下一步）
								next:               $bttn_next,          			// 作为下一页的单击触发器使用的元素的选择器
								prev:               $bttn_prev,          			// 作为前一页的单击触发器使用的元素的选择器

								menu:               null,                            // 元素作为菜单区选择，需要的pageselector”
								pageSelector:       false,                           // 启用带有下拉菜单页的导航，需要“菜单”
								chapterSelector:    false,                           // 允许导航的下拉菜单的章节，由“相对”属性决定，需要“菜单”

								shadows:            true,                            // 我们的网页动画显示阴影
								shadowTopFwdWidth:  166,                             // 顶了动画阴影宽度
								shadowTopBackWidth: 166,                             // 对于回到顶部动画阴影宽度
								shadowBtmWidth:     50,                              // 阴影底部的阴影宽度

								before:             function(){},                    // 在每个页面转动画前调用回调
								after:              function(){						 // 每次翻页动画后调用回调
								}                     
							});
							Cufon.refresh();
						}
				});
				
			};
			
			//弹窗显示文章内容
			function selDetail(DocID){
				$.ajax({
					type:'post',
					data:{"DocID":DocID},
					url:'/home/selectPicAndDocID',
					datatype:'json',
					success:function(data){
						openwindow("/home/selDocDetail?DocID="+DocID, "文章内容", 600, 700, false, null);
					},
					error:function(data){
						tipinfo("出错了!");
					}
				})
			}
		</script>
		<script>
			$('.browse_way_tab').find('li.handleItem').click(function(){
				$('.browse_way_tab').find('li').removeClass('cur');
				$(this).addClass('cur');
				$('.browse_way_tabcon').children('div').hide();
				$('.browse_way_tabcon').children('div').eq($(this).index()).show();
				$('#mybook').css("display","none");
				$('#next_page_button').css("display","none");
				$('#prev_page_button').css("display","none");
			})
			//回复评论
			function huifu(id,issueId,publicationId){
				if(${userId==null || userId==''}){
					tipinfo("登录后才可以回复");
					return;
				}
				openwindow("/home/turnHuifu?id="+id+"&issueId="+issueId+"&publicationId="+publicationId,"回复",
					500,350,false,function(){
					flushPage_100();
				});
			}
			//发表评论
			function pinglun(issueId,publicationId){
				if(${userId==null || userId==''}){
					tipinfo("登录后才可以评论");
					return;
				}
				var content = $("#contents").val();
				if(content=='' || content==null){
					tipinfo("请填写评论内容")
					return;
				}
				$.ajax({
					type:"post",
					url:"/home/pinglunSichuan",
					data:{"issueId":issueId,"publicationId":publicationId,"content":content},
					datatype:"html",
					async:true,
					success:function(data){
						tipinfo(data.msg);
						$("#contents").val("");
					},
					error:function(data){
						
					}
					
				});
			}
			
			//分享
			/* window._bd_share_config={"common":{"bdSnsKey":{},"bdText":"","bdMini":"2","bdMiniList":false,"bdPic":"","bdStyle":"0","bdSize":"16"},"share":{},"image":{"viewList":[],"viewText":"分享到：","viewSize":"16"},"selectShare":{"bdContainerClass":null,"bdSelectMiniList":[]}};with(document)0[(getElementsByTagName('head')[0]||body).appendChild(createElement('script')).src='http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion='+~(-new Date()/36e5)];
			function share(issueId,publicationId){
				$.ajax({
					type:"post",
					url:"/home/shareSichuan",
					data:{"issueId":issueId,"publicationId":publicationId},
					datatype:"html",
					async:true,
					success:function(data){
					},
					error:function(data){
						
					}
					
				});
			} */
			
			//收藏
			function collection(qikanId,qiciId,qikanType,obj){
				$.ajax({
					type:"post",
					url:"/home/collectionPublication",
					data:{"qikanId":qikanId,"qiciId":qiciId,"qikanType":qikanType},
					datatype:"html",
					async:true,
					success:function(data){
						if(data.result){
							if(data.type=='0'){
								$(obj).removeClass('collect');
								$(obj).addClass('collected');
							}else if(data.type=='1'){
								$(obj).removeClass('collected');
								$(obj).addClass('collect');
							}
						}
						tipinfo(data.msg);
					},
					error:function(data){
						
					}
					
				});
			}
			//订阅
			function subscribe(PublicationID,IssueID){
				//先判断当前是否登录，未登录状态下不能订阅
				$.ajax({
					type:'get',
					url:'/login/IsLogin',
					datatype:'json',
					success:function(data){
						if(data.success){
							openwindow("/subscribe/PaySichuan?PublicationID="+PublicationID+"&IssueID="+IssueID, "", 500, 400, false, null);
						}else{
							tipinfo("请先登录!");
						}
					},
					error:function(){
					}
				})
			}
			
			$('.menuList li a').click(function() {
				$(this).parents('.menu').hide();
				var id = $(this).parent().attr('data-target');
				$('.Content .menuItem').removeClass('active');
				$('.Content #' + id + '').addClass('active');
			})
			$('.backMenu').click(function() {
				$('.Content .menuItem').removeClass('active');
				$('.menu').show();
				$('#menu-item').css('display','none');
			})
			//全屏
			$('#main').on('click', '#fullpage', function() {
				var elem = document.getElementById("main");
				console.log(elem);
				requestFullScreen(elem);
				$(this).attr('id', 'qxfullpage');
				$(this).html("退 出");
				/*
				 注意这里的样式的设置表示全屏显示之后的样式，
				 退出全屏后样式还在，
				 若要回到原来样式，需在退出全屏里把样式还原回去
				 */
				elem.style.height = '1000px';
				elem.style.width = '1200px';
				
				$('.menu').css('width', '1100px');
				$('.menu').css('height', '900px');
				$('.menuItem').css('width', '840px');
				$('.menuItem').css('height', '940px');
			})
			//全屏
			$('#main2').on('click', '#fullpage2', function() {
				$('#mybookOne').css("display","none");
				$('#next_page_button').css("display","block");
				$('#prev_page_button').css("display","block");
				$('#mybook').css("display","");
				var elem = document.getElementById("main2");
				console.log(elem);
				requestFullScreen(elem);
				$(this).attr('id', 'qxfullpage2');
				$(this).html("退 出");
				/*
				 注意这里的样式的设置表示全屏显示之后的样式，
				 退出全屏后样式还在，
				 若要回到原来样式，需在退出全屏里把样式还原回去
				 */
				elem.style.height = '1000px';
				elem.style.width = '1200px';
				
				$('.book_wrapper').addClass("book_new");
				$('#mybook').addClass("mybook2");
				$('a#next_page_button').css('top','40%');
				$('a#prev_page_button').css('top','40%');
			})
			//取消全屏
			$('#main').on('click', '#qxfullpage', function() {
				$(this).attr('id', 'fullpage');
				var qxfullpage = $(this).html;
				$(this).html("全 屏");
				exitFullscreen();
			})
			//取消全屏
			$('#main2').on('click', '#qxfullpage2', function() {
				$(this).attr('id', 'fullpage2');
				$('#next_page_button').css("display","none");
				$('#prev_page_button').css("display","none");
				$(this).html("全 屏");
				exitFullscreen2();
			})
			/*
  				全屏显示
  			*/
			function requestFullScreen(element) {
				var requestMethod = element.requestFullScreen || element.webkitRequestFullScreen || element.mozRequestFullScreen || element.msRequestFullScreen;
				requestMethod.call(element);
			};
			/*
				全屏退出
			*/
			function exitFullscreen2() {
				var elem = document;
				var elemd = document.getElementById("main2");
				if(elem.webkitCancelFullScreen) {
					elem.webkitCancelFullScreen();
				} else if(elem.mozCancelFullScreen) {
					elemd.mozCancelFullScreen();
				} else if(elem.cancelFullScreen) {
					elem.cancelFullScreen();
				} else if(elem.exitFullscreen) {
					elem.exitFullscreen();
				} else {
					//浏览器不支持全屏API或已被禁用
				};

				/*
				 退出全屏后样式还原
				 */
				 $('#mybookOne').css("display","");
				 $('#mybook').css("display","none");
				elemd.style.height = '600px';
				elemd.style.width = '870px';
				$('a#next_page_button').css('top','50%');
				$('a#prev_page_button').css('top','50%');
				$('.book_wrapper').removeClass("book_new");
			}

			/*
  				全屏退出
  			*/
			function exitFullscreen() {
				var elem = document;
				var elemd = document.getElementById("main");
				if(elem.webkitCancelFullScreen) {
					elem.webkitCancelFullScreen();
				} else if(elem.mozCancelFullScreen) {
					elemd.mozCancelFullScreen();
				} else if(elem.cancelFullScreen) {
					elem.cancelFullScreen();
				} else if(elem.exitFullscreen) {
					elem.exitFullscreen();
				} else {
					//浏览器不支持全屏API或已被禁用
				};

				/*
				 退出全屏后样式还原
				 */
				elemd.style.height = '600px';
				elemd.style.width = '870px'

				$('.menu').css('width', '770px');
				$('.menu').css('height', '500px');
				$('.menuItem').css('width', '440px');
				$('.menuItem').css('height', '540px');
			}
			function selArticle(DocID){
				$.ajax({
					type:'get',
					url:'/usercenter/order/lookArticle',
					data:{"articleId":DocID},
					datatype:'json',
					success:function(data){
						var html='';
						$('#menu').css('display','none');
						$('#menu-item').css('display','block')
						$("#menu-item").empty();
						html+='<p class="title">'+ data.Title +'</p>';
						html+='<div class="content">'+ data.MainText +'</div>';
						html+='<div class="imgContent"></div>';
						$("#menu-item").append(html);
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
			}
		</script>-->
	</pxkj:Content>
</pxkj:ContentPage>
