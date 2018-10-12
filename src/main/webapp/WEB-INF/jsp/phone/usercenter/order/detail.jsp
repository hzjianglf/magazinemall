<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.gwc_nr_r h4{
				margin-top: 0.5rem;
			}
			.gwc_top_other p{
				font-size:14px;
				color:#888;
				margin-left:15px;
			}
			.vcspan{
				padding-left:10px;
				font-size:12px;
				color:orange;
			}
			.gwc_top_other p{
				margin-top:10px;
				font-size:12px;
				margin-left:12px;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a onclick="fanhui();" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>我的订单</h3>
		</div>
		<div class="gwc">
			<h2>${status }</h2>
			<div class="gwc_lb">
				<c:forEach items="${data[0].itemList }" var="list">
					<!-- 产品类型：实物1，期刊2，点播4，直播8，16电子书 -->
					<c:set var="href">
						<c:choose>
							<c:when test="${list.producttypes==1}">
								<c:out value="/home/index"></c:out>
							</c:when>
							<c:when test="${list.producttypes==2}">
								<c:out value="/product/turnPublicationDetail?id=${list.productid}"></c:out>
							</c:when>
							<c:when test="${list.producttypes==4}">
								<c:out value="/product/classDetail?ondemandId=${list.productid}"></c:out>
							</c:when>
							<c:when test="${list.producttypes==8}">
								<c:out value="/live/liveDetail?ondemandId=${list.productid}"></c:out>
							</c:when>
							<c:when test="${list.producttypes==16}">
								<c:out value="/product/turnPublicationDetail?id=${list.productid}"></c:out>
							</c:when>
						</c:choose>
					</c:set>
					<c:forEach items="${list.buySendList}" var="buySend">
					  <c:set var="href1">
						<c:choose>
							<c:when test="${buySend.producttypes==1}">
								<c:out value="/home/index"></c:out>
							</c:when>
							<c:when test="${buySend.producttypes==2}">
								<c:out value="/product/turnPublicationDetail?id=${buySend.productid}"></c:out>
							</c:when>
							<c:when test="${buySend.producttypes==4}">
								<c:out value="/product/classDetail?ondemandId=${buySend.productid}"></c:out>
							</c:when>
							<c:when test="${buySend.producttypes==8}">
								<c:out value="/live/liveDetail?ondemandId=${buySend.productid}"></c:out>
							</c:when>
							<c:when test="${buySend.producttypes==16}">
								<c:out value="/product/turnPublicationDetail?id=${buySend.productid}"></c:out>
							</c:when>
						</c:choose>
					 </c:set>
					</c:forEach>
					
					<div class="gwc_nr href" data-href="${href}">
						<img src="${list.productpic }">
						<div class="gwc_nr_r">
							<h3>${list.year }${list.productname }</h3>
							<h3>${list.issue }</h3>
							<c:if test="${list.producttypes==2}">
								<h4>纸媒版</h4>
							</c:if>
							<c:if test="${list.producttypes==16}">
								<h4>电子版</h4>
							</c:if>
							<h4><span style="float: left;">数量：${list.count }</span><span style="float: right;color:#F13F30;">￥${list.buyprice }</span></h4>
						</div>
						<div class="clear"></div>
					</div>
					<%-- <div class="gwc_nr href1" data-href="${href1}">
						<c:forEach items="${list.buySendList}" var="buySendList">
								<img src="${buySendList.productpic }">
								<div class="gwc_nr_r">
								<h3>${buySendList.year }${buySendList.productname }</h3>
								<h3>${buySendList.issue }</h3>
								<c:if test="${buySendList.producttypes==2}">
									<h4>纸媒版</h4>
								</c:if>
								<c:if test="${buySendList.producttypes==16}">
									<h4>电子版</h4>
								</c:if>
							    <h4><span style="float: left;">数量：${buySendList.count }</span><span style="float: right;color:#F13F30;">赠品</span></h4>
							    </div>
								<div class="clear"></div>
						</c:forEach>
					</div> --%>
					<div data-ordertype="${data[0].ordertype}" class="gwc_top" style=" background: #fff;display:none;">
					<c:if test="${list.delivername != '' && list.delivername != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }"><p>快递公司：${list.delivername }</p></c:if>
					<c:if test="${list.expressNum != '' && list.expressNum != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }"><p>快递单号：${list.expressNum }</p></c:if>
					</div>
				</c:forEach>
				<div data-ordertype="${data[0].ordertype}" class="gwc_top" style=" background: #fff;display:none;">
					<h4 style="font-weight: 700;"><img src="/images/dw_biao.png">${data[0].receivername }   ${data[0].receiverphone }</h4>
					<P>地址： ${data[0].receiverAddress }</P>
					<c:if test="${data[0].orderno != '' && data[0].orderno != null}"><p>订单编号：${data[0].orderno }</p></c:if>
					<c:if test="${data[0].addtime != '' && data[0].addtime != null}"><p>下单时间：${data[0].addtime }</p></c:if>
					<c:if test="${(data[0].methodName != '' && data[0].methodName != null) || (data[0].jianprice != null ||data[0].voucherPrice != null) }">
					<p>支付方式：<span class="vcspan">${data[0].methodName }</span>
					<c:if test="${data[0].jianprice != null }"><span class="vcspan">优惠券</span></c:if>
					<c:if test="${data[0].voucherPrice != null }"><span class="vcspan">代金券</span></c:if>
					</p></c:if>
					<c:if test="${data[0].payTime != '' && data[0].payTime != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }"><p>支付时间：${data[0].payTime }</p></c:if>
					<%-- <p>快递公司：<c:if test="${data[0].itemList[0].delivername != '' && data[0].orderstatus != 1 && data[0].orderstatus != 6 }">${data[0].itemList[0].delivername }</c:if></p>
					<p>快递单号：<c:if test="${data[0].itemList[0].delivercode != '' && data[0].orderstatus != 1 && data[0].orderstatus != 6 }">${data[0].itemList[0].expressNum }</c:if></p> --%>
				</div>
				<div data-ordertype="${data[0].ordertype}" class="gwc_top_other" style=" background: #fff;display:none;">
					<c:if test="${data[0].orderno != '' }"><p>订单编号：${data[0].orderno }</p></c:if>
					<c:if test="${data[0].addtime != '' }"><p>下单时间：${data[0].addtime }</p></c:if>
					<c:if test="${(data[0].methodName != '' && data[0].methodName != null) || (data[0].jianprice != null ||data[0].voucherPrice != null) }">
					<p>支付方式：<span class="vcspan">${data[0].methodName }</span>
					<c:if test="${data[0].jianprice != null }"><span class="vcspan">优惠券</span></c:if>
					<c:if test="${data[0].voucherPrice != null }"><span class="vcspan">代金券</span></c:if>
					</p></c:if>
					<c:if test="${data[0].payTime != '' && data[0].payTime != null && data[0].orderstatus != 1 && data[0].orderstatus != 6 }"><p>支付时间：${data[0].payTime }</p></c:if>
				</div>
				
				
				<div class="sfje">
					<P>商品总额                                                     <em>￥${data[0].totalprice - data[0].postage }</em></P>
					<P>运费                                                            <em>￥${(empty data[0].postage)?'0':data[0].postage }</em></P>
					<%-- <c:if test="${data[0].jianprice != null }">
					<P>优惠券                                                            <em>￥${data[0].jianprice }</em></P></c:if>
					<c:if test="${data[0].voucherPrice != null }">
					<P>代金券                                                            <em>￥${data[0].voucherPrice }</em></P></c:if> --%>
					<P class="sfk_biao">实付款：<span>￥${status eq "等待买家付款"?0:data[0].payprice }</span></P>
				</div>
			</div>

		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$(function(){
				var $div=$("div.gwc_top");
				var orderType=parseInt($div.data("ordertype"));
				var $divOther=$("div.gwc_top_other");
				if((orderType&2)>0){
					$div.show();
				}else{
					$divOther.show();
				}
				
				$(".href").on("click",function(){
					var href=$(this).data("href");
					location.href=href;
				}) 
				$(".href1").on("click",function(){
					var href1=$(this).data("href");
					location.href=href1;
				})
				
			})
			function fanhui(){
				window.history.go(-1);
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
