<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<a href="#" class="a2"><img src="/images/fx_biao.png" class="fx_biao"></a>
		</div>
		<div class="ksxq">
			<div class="ksxq_top">
				<img src="${data.picUrl }">
				<div class="ksxq_top_r">
					<h3><em>￥${data.presentPrice }</em>${data.name }</h3>
					<h4>大咖：<em>${data.realname }</em></h4>
					<h5>
						<c:if test="${data.isSubscribe=='0' }">
							<a href="/product/payOndemand?ondemandId=${data.ondemandId }">订阅</a>
						</c:if>
						<c:if test="${data.isSubscribe!='0' }">
							<a href="#">已订阅</a>
						</c:if>
						播放量：${data.hits/10000 }万
					</h5>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
			<div class="ksxq_di">
				<div class="xxk xxk2">
					<ul>
						<li class="on"><span>简介</span></li>
						<li class="li1" onclick="classHout('${data.ondemandId}');"><span>课时（${data.hourCount }）</span></li>
						<li><span>目录</span></li>
					</ul>
				</div>
				<div class="det_content2">
					<div class="jianjie">
						<!-- <h3>大咖简介</h3> -->
						<p>${data.introduce }</p>
					</div>
					<div class="ks_lb hide" id="det_content2">
						<div id="content"></div>
						<div id="Div_Temp" style="display:none"></div>
					</div>
				    <div class="munr hide ">
				    	${data.menu }
				    </div>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			$(function() {
				//样式选中
				$('.xxk').find('li').click(function() {
					$('.xxk').find('li').removeClass('on');
					$(this).addClass('on');
					$('.det_content2').children('div').hide();
					$('.det_content2').children('div').eq($(this).index()).show();
				});
			});
			function classHout(ondemandId){
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
								ondemandId:ondemandId,
								r:Math.random()
							},function(html){
								$("#content,#Div_Temp").html(html);
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
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
