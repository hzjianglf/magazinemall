<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
	<c:forEach var="item" items="${list }">
		<div class="gwc_nr" id="div_${item.id }">
			<span class="check_box">
				<input type="checkbox" id="check_${item.id}" data-price="${item.buyprice }" style="display:none" value="${item.id}">
				<label for="check_${item.id}"></label>
			</span> <img src="${item.productpic }">
			<div class="gwc_nr_r">
				<h3>
					${item.productname }
					<c:if test="${item.subType==1 }">
						${item.names }
					</c:if>
				</h3>
				<h4>
					<c:if test="${item.producttype==16}">
						电子版
					</c:if>
					<c:if test="${item.producttype==2}">
						纸媒版
					</c:if>
					<c:if test="${item.subType==1 }">
						单期
					</c:if>
					<c:if test="${item.subType==2 }">
						上半年刊
					</c:if>
					<c:if test="${item.subType==3 }">
						下半年刊
					</c:if>
					<c:if test="${item.subType==4 }">
						全年
					</c:if>
				</h4>
				<h5>
					<div id="p${item.id}" >￥
						${item.buyprice}
					</div>
					<div class="cpsl_jj">
						<a href="javascript:void(0)" onclick="change(${item.id},-1)">-</a> 
						<input type="text" id="c${item.id }" name="count" value="${item.count }"  onkeyup="if (!(/^[\d]+?\d*$/.test(this.value)) ){tipinfo('请输入数字'); this.value='1';this.focus();}"/>
						<a href="javascript:void(0)" onclick="change(${item.id},1)">+</a>
					</div>
				</h5>
			</div>
			<div class="clear"></div>
		</div>
	</c:forEach>
	<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
