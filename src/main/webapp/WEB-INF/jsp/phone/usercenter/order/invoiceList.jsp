<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<link href="/manage/public/layui/css/layui.css" rel="stylesheet">
		<link href="/css/index.css" rel="stylesheet">
		<link href="/css/base.css" rel="stylesheet">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="#" class="a1" id="goup"><img
				src="/images/fh_biao.png" class="fh_biao"></a>
				<h3>发货单详情</h3>
		</div>
		<div class="djq">
			<div class="det_content2">
				<div class="dqr" id="Div_Temp_1" style="margin-top:15px;">
					<c:forEach items="${data.data }" var="dali">
						<div class="clear"></div>
						<h5 class="js_biao">发货单号：${dali.list[0].expressNum }</h5>
						<h5 class="js_biao">发货日期：${dali.list[0].time }</h5>
					<c:forEach items="${dali.list }" var="list">
						<c:if test="${list.invoiceId eq invoiceId }">
					<div class="wddd_nr wddd_nr1" id="Div_Content_1">
						<div class="clear"></div>
						<div class="ddnr ">
							<img src="images/jxzz_tu.jpg">
							<div class="ddnr_r">
								<h2>${list.name }</h2>
								<h3>数量:${list.count }</h3>
							</div>
							<div class="clear"></div>
						</div>
					</div>
					</c:if>
					</c:forEach>
					</c:forEach>
				</div>
			</div>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			$("#goup").click(function() {
				window.history.go(-1);
			});
		</script>
	</pxkj:Content>
</pxkj:ContentPage>