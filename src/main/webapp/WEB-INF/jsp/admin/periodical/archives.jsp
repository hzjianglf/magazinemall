<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="m"%>
<m:ContentPage materPageId="master">
	<m:Content contentPlaceHolderId="css">
<style type="text/css">
	ul,li{
		margin:0;
		padding:0;
		list-style:none;
	}
	.itemBox{
		width:90%;
		margin-left:5%;
		overflow:hidden;
		margin-top:30px;
	}
	.itemBox .itemList{
		overflow:hidden;
	}
	.itemBox .itemList li{
		width:25%;
		margin:10px 0;
		float:left;
		text-align:center;
	}
	.itemBox .itemList li a{
		color:#fff;
		display:inline-block;
		width:80%;
		background:#09c;
		height:80px;
		line-height:80px;
		text-align:center;
		box-shadow:5px 5px 5px #e9e9e9;
		font-size:18px;
		font-weight:bold;
	}
</style>
</m:Content>
<m:Content contentPlaceHolderId="content">
	<div id="wrapper" class="container" style="height:100%">
		<div class="itemBox">
			<ul class="itemList">
				<li><a href="/${applicationScope.adminprefix }/classtype/list?type=2">商品类别</a></li>
				<li><a href="/${applicationScope.adminprefix }/periodical/list">期刊档案</a></li>
				<li><a href="/${applicationScope.adminprefix }/classtype/list?type=1">课程类别</a></li>
				<li><a href="/${applicationScope.adminprefix }/express/index">快递公司</a></li>
				<li><a href="/${applicationScope.adminprefix }/labels/list">标签管理</a></li>
				<li><a href="/${applicationScope.adminprefix }/classtype/list?type=3">文章分类</a></li>
				<li><a href="/${applicationScope.adminprefix }/system/paymethod/list">支付管理</a></li>
			</ul>
		</div>
	</div>
	</m:Content>
	<m:Content contentPlaceHolderId="js">
	<script type="text/javascript">
    </script>
    </m:Content>
</m:ContentPage>
