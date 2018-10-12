<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
	<div class="top">
			<a href="javascript:history.go(-1)" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>电子书列表</h3>
	</div>
		<c:forEach items="${list}" var="list">
			<div class="zzjx_nr">
				<img src="${list.productpic}">
				<div class="zzjx_nr_r">
					<h2>
						${list.name}
					</h2>
					<h3>
						${list.year }年	${list.describes }
					</h3>
					<span class="yd_biao" onclick="readEBook(${list.id},${list.status })">阅 读</span>
				</div>
				<div class="clear"></div>
			</div>
		</c:forEach>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
		function readEBook(id,status){
			if(status>0){
				window.location.href="/usercenter/order/getEBookContent?pubId="+id+"&geren=1&type=1&pageNow=1"+"&pageSize=1000";
			}else{
				alertinfo("当前期次暂未出版电子书")
			}
		}
		function openEBook(id){
			window.location.href="/usercenter/order/getEbookListById?id="+id;
		}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
