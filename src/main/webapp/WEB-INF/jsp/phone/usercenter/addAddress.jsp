<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="PhoneMaster">
	<pxkj:Content contentPlaceHolderId="css">
	<link rel="stylesheet" href="/manage/public/layui/css/layui.css" />
		<style>
			
			.addressIns>li{
				overflow: hidden;
				width: 15rem;
				margin:0 auto 0.5rem;
			}
			.addressIns{
				padding:0.5rem 0 0;
				background: #fff;
				overflow: hidden;
			}
			.addressIns>li>span{
				display: inline-block;
				width: 3rem;
				font-size: 0.6rem;
				float: left;
				line-height: 1.4rem;
			}
			.addressIns>li>input{
				width: 10.5rem;
				float: left;
				border:none;
				outline: none;
				text-indent: 0.5rem;
				line-height: 1.4rem;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="top">
			<a href="/usercenter/account/turnMyAddress" class="a1"><img src="/images/fh_biao.png" class="fh_biao"></a>
			<h3>创建收货地址</h3>
		</div>
		<div class="wddz_lb">
			<ul class="addressIns">
				<li><span>收件人</span>
					<input type="hidden" id="addressId" value="${Id }">
					<input type="hidden" id=isDefault value="${isDefault }">
					<input type="text" id="receiver" name="receiver" value="${receiver }" placeholder="请输入收件人" />
				</li>
				<li>
					<span>联系电话</span>
					<input type="text" id="phone" name="phone" value="${phone }" placeholder="请输入联系电话" />
				</li>
					<li>
					<span>详细地址</span>
					<input type="text" id="detailedAddress" name="detailedAddress" value="${detailedAddress }" placeholder="请输入详细地址" />
				</li>
				<li>
				<form class="layui-form" style="margin-left: -40px">
						<div class="layui-form-item">
			                <label class="layui-form-label">选择地区</label>
			                <div class="layui-input-inline">
			                    <select name="provid" id="provid" lay-filter="provid" lay-verify="required">
			                        <option value="">请选择省</option>
			                    </select>
			                </div>
			                <div class="layui-input-inline">
			                    <select name="cityid" id="cityid" lay-filter="cityid" lay-verify="required">
			                        <option value="">请选择市</option>
			                    </select>
			                </div>
			                <div class="layui-input-inline">
			                    <select name="areaid" id="areaid" lay-filter="areaid" lay-verify="required">
			                        <option value="">请选择县/区</option>
			                    </select>
			                </div>
			            </div>
	            </form>
				</li>
			
			</ul>
		</div>
		<button class="qr_biao" onclick="save()">保存</button>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script src="/js/swipe.js"></script>
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript" src="/manage/public/layui/mui_use.js"></script>
		<script type="text/javascript" src="/manage/logistics/assets/data.js"></script>
    	<script type="text/javascript" src="/manage/logistics/assets/province.js"></script>
		<script type="text/javascript">
		layui.use('layer', function(){
			var $ = layui.$,
			layer = layui.layer;
		});
		function tipinfo(Obj){
			layer.msg(Obj);
		}
		$(function(){
			$("footer").hide();
			var maxHeight=$(window).height()-$("footer").height()-$(".top").height();
			$(".wddz_lb,.addressIns,.layui-form-item").css("height",maxHeight+"px");
		})
		var defaults = {
	            s1: 'provid',
	            s2: 'cityid',
	            s3: 'areaid',
	            v1: '${province}',
	            v2: '${city}',
	            v3: '${county}'
	        };
		function save(){
			var provid = $("#provid").val();
			var cityid = $("#cityid").val();
			var areaid = $("#areaid").val();
			var receiver = $("#receiver").val();
			var phone = $("#phone").val();
			if(provid==''||provid==null ||cityid==''||cityid==null ||areaid==''||areaid==null ||receiver==''||receiver==null ||phone==''||phone==null){
				tipinfo("请填写数据");
				return false;
			}
			var reg = /^1[0-9]{10}$/;
			if( !reg.test(phone)){
				tipinfo("手机号有误");
				return false;
			}
			$.ajax({
				type : "POST",
				url : "/usercenter/account/saveAddress",
				async : false,
				data : {
					"Id" : $("#addressId").val(),
					"province": $("#provid").val(),
					"city": $("#cityid").val(),
					"county": $("#areaid").val(),
					"receiver":$("#receiver").val() ,
					"phone":$("#phone").val(),
					"detailedAddress":$("#detailedAddress").val(),
					"isDefault":$("#isDefault").val()
				},
				success : function(data) {
					tipinfo(data.msg);
					setTimeout(function(){window.location.href="/usercenter/account/turnMyAddress"},800);
				},
				error : function(data) {

				}
			});
		}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
