<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<style>
			*{margin:0;padding:0;line-height:100%;font-family:'微软雅黑';
			box-sizing:content-box !important;
			-moz-box-sizing:content-box !important; /* Firefox */
			-webkit-box-sizing:content-box !important; /* Safari */
			}
			a{text-decoration:none;}
			ul li,ol li{list-style:none;}
			b,strong,h1,h2,h3,h4,h5,h6{font-weight:normal;}
			i,em{font-style:normal;}
			img{vertical-align:top;}
			input,select,img {
				outline: none;
			}
			
			#clearfix:after{content:'';display:block;clear:both;}
			#clearfix{zoom:1;}
			.clear{ clear:both;}
			a:link, a:visited, a:active {text-decoration:none; color:#333;}
			a:hover {color: #333; }
			a {cursor: pointer; }
			input {outline: none;}
			.fl {
				float: left;
			}
			.fr {
				float: right;
			}
			html{font-size: 20px;}
			
			
			/*列表*/
			#booklist>div {
				padding: 0.5rem;
				border-bottom: 1px #e5e5e5 solid;
			}
			#booklist>div img {
				width: 3rem;
				height: 4.25rem;
				float: left;
			}
			#booklist>div ul {
				width: 11rem;
				height: 4.25rem;
				float: right;
			}
			#booklist>div ul li {
				line-height: 0.75rem;
				height: 0.75rem;
			}
			#booklist>div ul h1 {
				font-size: 0.45rem;
				color: #333;
				line-height: 0.75rem;
			}	
			#booklist>div ul span {
				font-size: 0.4rem;
				color: #999;
				line-height: 0.75rem;
				margin-right: 0.25rem;
				vertical-align: middle;
			}
			#booklist>div ul p {
				font-size: 0.4rem;
				font-weight: bold;
				color: #dc8d39;
				margin-top: 2rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
		<!-- 	<a href="#" class="a2"><img src="/images/fx_biao.png" class="fx_biao"></a> -->
			<h3>合集详情</h3>
		</div>
		<div class="ksxq">
			<div class="ksxq_top">
				<img src="${data.picUrl }">
				<div class="ksxq_top_r">
					</em>${data.name }</h3>
					
					<div style="height:20px;">
					<c:if test="${data.nickName!=null}">
							<a href="/home/teacherDetail?userId=${data.teacherId }"><h4>${data.nickName}
							<span style="margin-left:20px;"><c:choose>
							<c:when test="${data.hits>10000}">${data.hits/10000}万</c:when>
							<c:otherwise>${data.hits}</c:otherwise>
						</c:choose>人订阅</span>
							</h4></a>
					</c:if>
					</div>
					<h5 style="margin-top: 1rem;">
						<c:if test="${data.isbuy=='0' }">
							<a href="/product/payOndemand?ondemandId=${data.ondemandId }">订阅</a>
						</c:if>
						<c:if test="${data.isbuy!='0' }">
							<a href="#">已订阅</a>
						</c:if>
						<%-- 播放量：
						<c:choose>
							<c:when test="${data.hits>10000}">${data.hits/10000}万</c:when>
							<c:otherwise>${data.hits}</c:otherwise>
						</c:choose> --%>
						<span style="color: #e08500;font-size: 0.8rem;">￥${data.presentPrice }<i style="font-size:0.6rem;color: #999;text-decoration: line-through;margin-left: 15px;">
						<c:if test="${data.presentPrice !=data.yuanPrice }">
							￥${data.yuanPrice }
						</c:if>
						</i></span>
					</h5>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
			<c:if test="${data.isBuySend > 0 }">
				<div class="cuXiao">
					促销
					<a class="song" href="javascript:void(0)">${data.buySendList[0].name }</a>
					${data.buySendList[0].remark }
				</div>
			</c:if>
			<div class="ksxq_di">
				<div class="xxk xxk2">
					<ul>
						<li class="on" style="width:50%;"><span>简介</span></li>
						<%-- <li class="li1" onclick="classHout('${data.ondemandId}',2);"><span>课时（${data.hourCount }）</span></li> --%>
						<li style="width:50%;"><span>目录</span></li>
					</ul>
				</div>
				<div class="det_content2">
					<div class="jianjie">
						<!-- <h3>大咖简介</h3> -->
						<p>${data.introduce }</p>
					</div>
				<%-- 	<div class="ks_lb hide" id="det_content2">
						<div style="height:40px;">
						<h3 style="float: left; width:60%;text-align: left;margin-top: 10px;">
							<c:if test="${data.serialState eq '0' ||data.serialState eq '2' }">
								课程已完结
							</c:if>
							<c:if test="${data.serialState eq '1'}">
								课程连载中
							</c:if>
						</h3>
						<!-- <h3 class="listLeft" style="width:20%" >倒序 </h3>
						<h3 class="listRigth" style="width:20%" >正序</h3> -->
						<img alt="" class="listRigth" style="display: none" src="/images/class_drop.png" onclick="classHout('${data.ondemandId}',2)">
						<img alt="" class="listRigth"  src="/images/class_rise.png" onclick="classHout('${data.ondemandId}',1)">
						</div>
						<div id="content"></div>
						<div id="Div_Temp" style="display:none">
						</div>
					</div> --%>
				  <div class="hide">
				    	<div id="booklist">
					    	<c:forEach var="item" items="${sumList }">
						    	<div id="clearfix" onclick="classDetail('${item.ondemandId}');">
									<img src="${item.picUrl }" />
									<ul>
										<li><h1>${item.name }</h1></li>
										<li><span>${item.nickName }</span><span>${item.studentNum }人订阅</span></li>
										<li><p>￥${item.presentPrice }</p></li>
									</ul>
								</div>
					    	</c:forEach>
				    	</div>
					</div>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				var ondemandId = ${data.ondemandId};
				console.log(ondemandId)
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					$("#content #Div_Temp").html('');
					$('.det_content2').children('div').hide();
					$('.det_content2').children('div').eq($(this).index()).show();
				});
			});
			$(".listRigth").click(function(){
				$(this).css("display","none").siblings().css("display","inline");
			})
			function classHout(ondemandId,num){
				var paixu = "DESC";
				if(num > 1){
					paixu = "ASC";
				}
				$("#content,#Div_Temp").html('');
				layui.use('flow', function(){
					  var flow = layui.flow;
					  flow.load({
					    elem: '#det_content2' //流加载容器 
					    , isAuto: true
		                , isLazyimg: true
					    ,done: function(page, next){ //执行下一页的回调
					    	$.get("/product/selClassHour",{
								page:page,
								pageSize:6,
								paixu:paixu,
								ondemandId:ondemandId,
								r:Math.random()
							},function(html){
								$("#content,#Div_Temp").append(html);
								var totalPage =$("#Div_Temp").find("#Hid_TotalPage").val();
					        	$("#Div_Temp").html("");
								next("", page < totalPage);
							},"html")
					    }
					  });
				});
			}
			//播放课时	IsBuyOndemand 是否购买了该课程（1是0否） IsAudition 是否是试听课时(1是0否)
			function playVideo(hourId,ondemandId,IsBuyOndemand,IsAudition){
				//先判断是否购买了
				if(IsBuyOndemand=='0'){
					//未购买，判断是否是试听课时
					if(IsAudition=='0'){
						//跳转到购买页面
						window.location.href="/product/payOndemand?ondemandId="+ondemandId;
					}else{
						//未购买，但是是试听课时，则跳转播放界面
						window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
					}
				}else{
					//购买了
					window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
				}
			}
			//查询课时文稿	IsBuyOndemand 是否购买了该课程（1是0否） IsAudition 是否是试听课时(1是0否)
			function showArticle(hourId,ondemandId,IsBuyOndemand,IsAudition){
				//先判断是否购买了
				if(IsBuyOndemand=='0'){
					//未购买，判断是否是试听课时
					if(IsAudition=='0'){
						//跳转到购买页面
						window.location.href="/product/payOndemand?ondemandId="+ondemandId;
					}else{
						//未购买，但是是试听课时，则跳转播放界面
						window.location.href="/product/classPresentation?hourId="+hourId+"&ondemandId="+ondemandId;
					}
				}else{
					//购买了
					window.location.href="/product/classPresentation?hourId="+hourId+"&ondemandId="+ondemandId;
				}
				event.stopPropagation(); 
			}
			
			//课程详情
			function classDetail(ondemandId){
				window.location.href="/product/classDetail?ondemandId="+ondemandId;
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
