<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
					<ul>
					<c:forEach var="item" items="${list }">
						<c:if test="${!(item.isbuy>0 && item.status>0)  }">
							<li>
								<a href="/product/turnPublicationDetail?id=${item.id }">
									<img src="${item.picture }">
									<c:if test="${item.sumType eq 4 }">
										<span>合辑</span>
									</c:if>
								<P>${item.name }<br><em></em></P>
								</a>
							</li>
						</c:if>
						<c:if test="${item.isbuy>0 && item.status>0 }">
							<li>
								<a href="/periodical/turnEbook?bookId=${item.id }&pubId=${item.period}"><img src="${item.picture }">
								<P>${item.name }<br><em></em></P>
								</a>
							</li>
						</c:if>
					</c:forEach>
					</ul>
	<input type="hidden" id="Hid_TotalPage" value="${pageTotal}">
