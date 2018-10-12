<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib  uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="px"%>
<px:ContentPage materPageId="master">
<px:Content contentPlaceHolderId="css">
<style>
	.leftMain .layui-icon {
		margin-right: 5px;
	}
	.layui-layer-title{
		background: 009688;
	}
</style>
</px:Content>
<px:Content contentPlaceHolderId="content">
	<div class="layui-layout layui-layout-admin">
		<div class="layui-header layui-bg-blue">
			<div class="layui-logo" style="color: #fff">${sessionScope.siteInfo.siteName }后台管理系统</div>
			<!-- 头部区域（可配合layui已有的水平导航） -->
			<ul class="layui-nav layui-layout-left">
				<c:forEach items="${treenodes }" var="item">
					<li class="layui-nav-item ${item.treeName==moduleName?'layui-this':'' }"><a href="/${applicationScope.adminprefix }/index?moduleName=${item.treeName}">${item.treeName}</a></li>
				</c:forEach>
			</ul>
			<ul class="layui-nav layui-layout-right">
				<li class="layui-nav-item">
					<a href="javascript:;"> 
						<img src="/manage/images/index/u1052.png" class="layui-nav-img">${username }
					</a>
					<dl class="layui-nav-child">
						<dd>
							<a href="javascript:void(0)" id="upPwd">修改密码</a>
						</dd>
						<dd>
							<a href="/${applicationScope.adminprefix }/login/loginOut">安全退出</a>
						</dd>
					</dl>
				</li>
			</ul>
		</div>

		<div class="layui-side layui-bg-black">
			<div class="layui-side-scroll">
				<!-- 左侧导航区域（可配合layui已有的垂直导航） -->
				<ul class="layui-nav layui-nav-tree leftMain" lay-filter="test">
					<c:forEach items="${erList }" var="item">
						<li class="layui-nav-item layui-nav-itemed">
							<a class="" href="javascript:;">${item.treeName }</a>
							<dl class="layui-nav-child">
								<c:forEach items="${item.chList }" var="items">
									<dd>
										<a class="layui-unselect" href="javascript:void(0);" data-href="/${applicationScope.adminprefix }/${items.url}">
											<i class="layui-icon">${items.icon}</i>${items.treeName}
										</a>
									</dd>
								</c:forEach>
							</dl>
						</li>
					</c:forEach>
				</ul>
			</div>
		</div>

		<div class="layui-body">
			<iframe id="rightMain" src="${url }"
				style="width: 100%; height: 100%; margin-bottom: -20px; border: none;"></iframe>
		</div>
		<!-- <div class="layui-footer">
			底部固定区域
			底部固定区域
		</div> -->
	</div>
</px:Content>
<px:Content contentPlaceHolderId="js">
	<script type="text/javascript">
		//JavaScript代码区域
		layui.use([ 'element', 'layer' ], function() {
			var element = layui.element;
			var layer = layui.layer;
			//一些事件监听
			element.on('tab(demo)', function(data) {
				layer.msg('切换了：' + this.innerHTML);
			});
		});

		$(document).ready(function() {
			$('.leftMain a[data-href]').on("click", function(e) {
				loading(true);
				var href = $(this).data('href');
				var iframe = $('#rightMain').attr("src", href);
			})
			$('#rightMain').load(function(){
            	loading();
            });
		});
		$('#upPwd').click(function(){
			openwindow('/login/toUpPwd',"修改密码",500,300,false,null);
		});
	</script>
</px:Content>
</px:ContentPage>