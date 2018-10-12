<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style>
			.hide{
				display:none;
			}
			.yhqType a.active1 {
	    		color: #FF9966;
			}
			.gerenImg{
				width:200px;
				height:150px;
			}
			.charge_win {
				width: 470px;
				height: 393px;
				position: fixed;
				top: 50%;
				left: 50%;
				margin-top: -196px;
				margin-left: -235px;
				background: #f2f2f2;
				z-index: 101;
				display: none;
			}
			.charge_win h1 {
				font-size: 20px;
				font-weight: normal;
				color: #1e1e1e;
				line-height: 60px;
				text-indent: 35px;
			}
			.chargenums {
				text-align: center;
				width: 400px;
				margin: 0 auto;
			}
			.chargenums span {
				width: 68px;
				height: 28px;
				display: inline-block;
				background: #fff;
				border-radius: 5px;
				margin: 0 20px 20px;
				line-height: 28px;
				text-align: center;
				cursor: pointer;
				font-size: 14px;
			}
			.chargenums span.seled {
				border: 1px red solid;
				width: 66px;
				height: 26px;
				line-height: 26px;
			}
			.payway {
				width: 404px;
				height: 116px;
				background: #fff;
				border-radius: 10px;
				margin: 0 auto;
			}
			.payway p {
				text-indent: 5px;
				font-size: 16px;
				color: #6b6b6b;
				line-height: 32px;
			}
			.paywaylist {
				text-align: center;
			}
			.paywaylist span {
				display: inline-block;
				font-size: 16px;
				line-height: 57px;
				margin: 10px;
				width: 158px;
				height: 57px;
				cursor: pointer;
			}
			.paywaylist span img {
				width: 30px;
				height: 30px;
				margin-right: 10px;
				vertical-align: middle;
			}
			.paywaylist span.cur {
				border: 1px red solid;
				border-radius: 10px;
			}
			.pay_btns {
				text-align: center;
				margin-top: 30px;
			}
			.pay_btns input {
				width: 90px;
				height: 35px;
				border: none;
				color: #fff;
				border-radius: 5px;
				font-size: 14px;
				margin: 0 20px;
				cursor: pointer;
				outline: none;
			}
			.btn_pay {
				background: #ff6633;
			}
			.btn_cancel {
				background: #ff9966;
			}
			.close {
				width: 30px;
				height: 30px;
				display: block;
				position: absolute;
				right: 10px;
				top: 10px;
				background: url(/img/close.png) no-repeat;
			}
			.btn_charge {
				position: absolute;
				right: 20px;
				top: 116px;
				width: 50px;
				height: 25px;
				display: block;
				background: #fff;
				border-radius: 5px;
				font-size: 14px;
				font-weight: normal;
				text-align: center;
				line-height: 25px;
				color: #f07c54 !important;
			}
			.shade {
				width: 100%;
				height: 100%;
				background: #000;
				position: fixed;
				top: 0;
				left: 0;
				opacity: 0.5;
				filter: alpha(opacity = 50);
				z-index: 100;
				display: none;
			}
			.dingDan .orderType li.on{
				background:#ff9966;
				color:#fff;
			}
			.layui-form-label{
			      padding: 9px 0;
			    text-align: left;
			    font-size: 16px;
			    width: 100px;
			}
			.layui-form-item .layui-input-inline {
			    float: left;
			    width: 94px;
			    margin-right: 6px;
			}
			.inputAllBox {
			    width: 500px;
			    margin: 30px auto;
			}
			.inputAllBox>.input-item>input{
			        width: 390px;
			}
			.layui-form-item .layui-input-inline{
			      width: 127px;
			}
			
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
	<div id="qrcode"></div>
		<div class="myData">
			<div class="leftSec">
				<ul class="leftSecMenu">
					<li class="active">
						个人中心
						<span>＞</span>
					</li>
					<li>
						收货地址
						<span>＞</span>
					</li>
					<li>
						钱包
						<span>＞</span>
					</li>
					<li>
						订单
						<span>＞</span>
					</li>
					<li>
						已购
						<span>＞</span>
					</li>
					<li>
						收藏
						<span>＞</span>
					</li>
					<li>
						笔记
						<span>＞</span>
					</li>
					<li>
						最近播放
						<span>＞</span>
					</li>
					<li>
						消息
						<span>＞</span>
					</li>
				</ul>
			</div>
			<div class="rightSec">
				<div class="myDataItem show">
					<div class="topIns">
						<table>
							<tbody>
								<tr>
									<td class='centerBox' rowspan="4">
										<c:choose>
											<c:when test="${geren.data.userUrl eq null || geren.data.userUrl eq '' }">
												<img class="gerenImg" src="/img/zuoJiatx.png" alt="" />
											</c:when>
											<c:otherwise>
												<img class="gerenImg" src="${geren.data.userUrl }" alt="头像">
											</c:otherwise>
										</c:choose>
									</td>
									<td>昵称：<span>${geren.data.nickName == null ||geren.data.nickName ==''?'未填写':geren.data.nickName }</span></td>
									<td>学历：<span>${geren.data.education == null ||geren.data.education ==''?'未填写':geren.data.education }</span></td>
									<td>
										<a class="bianJiZiLiao" href="javascript:void(0)">
											<img src="/img/editImg.png" alt="" /> 编辑资料
										</a>
									</td>
								</tr>
								<tr>
									<td>性别：<span>${geren.data.sex == null?'未填写':geren.data.sex==0?'男':'女' }</span></td>
									<td>行业：<span>${geren.data.industry == null ||geren.data.industry ==''?'未填写':geren.data.industry }</span></td>
									<td></td>
								</tr>
								<tr>
									<td>出生年份：<span>${geren.data.birthDate == null ||geren.data.birthDate ==''?'未填写':geren.data.birthDate }</span></td>
									<td>职业：<span>${geren.data.occupation == null ||geren.data.occupation ==''?'未填写':geren.data.occupation }</span></td>
									<td></td>
								</tr>
								<tr>
									<td>简介：<span>${geren.data.synopsis == null ||geren.data.synopsis ==''?'未填写':geren.data.synopsis }</span></td>
									<td></td>
									<td></td>
								</tr>
								<tr>
									<td class='centerBox'><span class="telCon">${geren.data.telenumber == null ||geren.data.telenumber ==''?'未填写':geren.data.telenumber }</span></td>
									<td colspan="3">
										<span class="priceNum">余额：${geren.data.balance }元</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="topIns fansNum">
						<table>
							<tbody>
								<tr>
									<td class='centerBox'>
										<a class="diaItem" data-target="tiwen" href="javascript:void(0)">提问：<span>${geren.data.twCount }</span>人</a>
									</td>
									<td>
										<a class="diaItem" data-target="pangting" href="javascript:void(0)">旁听：<span>${geren.data.ptCount }</span>人</a>
									</td>
									<td>
										<a class="diaItem" data-target="dashang" href="javascript:void(0)">打赏：<span>${geren.data.rewardCount }</span>人</a>
									</td>
									<td>
										<a class="diaItem" data-target="guanzhu" href="javascript:void(0)">关注：<span>${geren.data.followCount }</span>人</a>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="myDataItem">
					<button class="addShouHuoAddress editBtn" data-state="0">新增收货地址</button>
					<form class="layui-form">
					<ul class="addressList">
						<c:forEach items="${shouhuo.list }" var="item">
							<li>
								<p class="title">
									${item.receiver }
									<c:if test="">
										<span style="color:orange">默认地址</span>
									</c:if>
									<c:choose>
										<c:when test="${item.isDefault==1 }">
											<span style="color:orange">默认地址</span>
										</c:when>
										<c:otherwise>
											<a href="javascript:void(0)" onclick="changeAddress(${item.Id })">设为默认</a>
										</c:otherwise>
									</c:choose>
									<a class="addressDel" onclick="del(${item.Id })" href="javascript:void(0)">X</a>
								</p>
								<p>收货人：<span>${item.receiver }</span></p>
								<p>联系电话：<span>${item.phone }</span></p>
								<p>所在地区：<span>${item.province } ${item.city } ${item.county }</span></p>
								<p>
									详细地址：<span>${item.detailedAddress }</span>
									<a class="addressEdit editBtn" data-val="${item.Id }" data-state="1" href="javascript:void(0)">编辑</a>
								</p>
							</li>
						</c:forEach>
					</ul>
					</form>
				</div>
				<!-- 钱包 -->
				<div class="myDataItem">
					<div class="zhanghuIns" style="position: relative;">
						余额
						<p>${geren.data.balance }元</p>
						<a href="javascript:;" class="btn_charge">充值</a>
						<a class="jiaoYiJiLu" href="javascript:void(0)">交易记录</a>
					</div>
					
					<div class="yhqBox">
						<p class="quanType">
							<a href="javascript:void(0)" data-val="0" class="active">优惠券</a>
							<span>|</span>
							<a href="javascript:void(0)" data-val="2" class="">代金券</a>
						</p>
						<p class="yhqType" id="yhqType">
							<a href="javascript:void(0)" data-val="1" class="active1">可使用</a>
							<a href="javascript:void(0)" data-val="2">已使用</a>
							<a href="javascript:void(0)" data-val="0">已过期</a>
						</p>
						<div id="youhuiquan"></div>
						<div id="daijinquan"></div>
					</div>
					<div class="shade"></div>
					<div class="charge_win">
					<a href="javascript:;" class="close"></a>
					<h1>请输入充值金额</h1>
					<div class="chargenums">
						<span class="seled" data-val="10">10元</span>
						<span data-val="20">20元</span>
						<span data-val="50">50元</span>
						<span data-val="100">100元</span>
						<span data-val="200">200元</span>
						<span data-val="500">500元</span>
					</div>
					<div class="payway">
						<p>请选择支付方式</p>
						<div class="paywaylist">
							<span class="cur" data-val="3" ><img src="/img/alipay.png"/>支付宝支付</span>
							<span data-val="7" ><img src="/img/wxpay.png"/>微信支付</span>
						</div>
					</div>
					<div class="pay_btns">
						<input type="button" value="立即支付" class="btn_pay" />
						<input type="button" value="取消" class="btn_cancel" />
					</div>
				</div>
			</div>
			<div class="myDataItem dingDan">
				<!-- 订单内容 -->
				<div>
					<ul class="orderType oh">
						<li class="on" data-status="-1">全部订单</li>
						<li data-status="1">待付款</li>
						<li data-status="5">已完成</li>
						<li data-status="6">已取消</li>						</ul>
					<div class="order-con">
						<table class="orderItem" border="1" cellpadding="0" cellspacing="0">
							<tbody>
								<tr>
									<td class="w500">订单详情</td>
									<!-- <td class="w180">收货人</td> -->
									<td>金额</td>
									<td>状态</td>
									<td>操作</td>
								</tr>
							</tbody>
						</table>
						<div  id="totalOrder">
						</div>
					</div>
				</div>
				<!-- 订单详情 -->
				<div class="orderDetail"  id="personalOrderDetails">
				</div> 
				<!-- 确认收货 -->
				<div class="orderDetail" >
					<!-- <h1 class="title">
						订单详情
					</h1> -->
					<div id="confirmToReceive">
					</div>
			    </div>
				
			</div>
				<!-- 已购 -->
				<div class="myDataItem">
					<ul class="productType productType2 oh">
						<li class="active">商品</li>
						<li class="">电子书</li>
						<li class="">点播课程</li>
						<li>直播课程</li>
					</ul>
					<div class="tabContent tabContent2">
					<!-- 商品 -->
						<div class="productItem oh show" id="selectProduct1">
						</div>
						<!-- 电子书 -->
						<div class="productItem oh" id="selectEbook1">
						</div>
						<!-- 点播课程 -->
						<div class="productItem oh" id="selectOndemand1">
						</div>
						<!-- 直播课程 -->
						<div class="productItem oh">
							<div class="noData">
								暂无数据
							</div>
						</div>
					</div>
				</div>
				<!-- 收藏 -->
				<div class="myDataItem" id="storeList">
				</div>
				<!-- 笔记 -->
				<div class="myDataItem">
					<div class="biJiList" id="notes">
					</div>
				</div>
				<!-- 播放历史 -->
				<div class="myDataItem">
					<p class='title'>历史播放</p>
					<div class="boFangList" id="playHistoryList">
					</div>
				</div>
				<!-- 消息 -->
				<div class="myDataItem">
					<div class="xiaoXiList" id="personalNewList">
						
					</div>
				</div>
				<!--交易记录-->
				<div class="myDataItem jiaoYiBox" style="display:none;">
				<div class="jiaoYiRecord">
					<div class="topSearch oh">
						<input type="text" class="startDate" id="startTime" autocomplete="off" placeholder="yyyy-MM-dd" />
						<span>~</span>
						<input type="text" class="endDate" id="endTime" autocomplete="off" placeholder="yyyy-MM-dd" />
						<button class="searchBtn" style="cursor:pointer;">搜索</button>
					</div>
					<div class="jiaoYiContent">
						<div class="searchTj">
							<span id="timeStar"></span>~<span id="timeEnd"></span>
							
							<p>
								收入<span class="shouRu">0.00</span>
								支出<span class="zhiChu">0.00</span>
							</p>
						</div>
						<div class="jyTab">
							<ul class="jyType oh">
								<li class="active" data-val="2">全部</li>
								<li data-val="1">收入</li>
								<li data-val="0">支出</li>
							</ul>
						</div>
						
						<div class="jyCon">
							<div class="show">
								<table class="titleCon" id="test"></table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div id="dia"></div>
		<!-- 编辑资料弹层 -->
		<div id="ziLiaoBox">
			<img class="closeDia" src="/img/closedia.png" alt="" />
			<img class="touXiang" src="${geren.data.userUrl }" alt="" />
			<div class="formInput">
				<input type="hidden" id="userUrl" value="${geren.data.userUrl }" />
				<div class="forminputItem oh">
					<span>昵称：</span>
					<input type="text" id="nickName" placeholder="请输入" value="${geren.data.nickName }" />
				</div>
				<div class="forminputItem oh">
					<span>性别：</span>
					<input type="radio" value="0" name="gendei" ${geren.data.sex==0?'checked':'' } />男
					<input type="radio" value="1" name="gendei" ${geren.data.sex==1?'checked':'' } />女
				</div>
				<div class="forminputItem oh">
					<span>出生年份：</span>
					<input type="text" id="birthDate" placeholder="请输入" value="${geren.data.birthDate }"  />
				</div>
				<div class="forminputItem oh">
					<span>学历：</span>
					<input type="text" id="education" placeholder="请输入" value="${geren.data.education }" />
				</div>
				<div class="forminputItem oh">
					<span>行业：</span>
					<input type="text" id="industry" placeholder="请输入" value="${geren.data.industry }" />
				</div>
				<div class="forminputItem oh">
					<span>职业：</span>
					<input type="text" id="occupation" placeholder="请输入" value="${geren.data.occupation }" />
				</div>
				<div class="forminputItem oh">
					<span>简介：</span>
					<textarea name="synopsis" rows="" id="synopsis" cols="">${geren.data.synopsis }</textarea>
				</div>
			</div>
			<div class="saveBtn">
				<button onclick="saveInformation()">保存</button>
				<button onclick="cancel()">取消</button>
			</div>
		</div>
		<!-- 提问、旁听、打赏、关注---弹层 -->
		<div id="insDialog">
			<a class="closeThis" href="javascript:void(0)">
				<img src="/img/closedia.png" alt="" />
			</a>
			<div id="tiwen"></div>
			<div id="pangting"></div>
			<div id="dashang"></div>
			<div id="guanzhu"></div>
		</div>
		<div id="dia"></div>
		<div id="addressIns">
			<img class="closeThat" src="/img/closedia.png" alt="" />
			<div class="inputAllBox">
				<div class="input-item oh">
					<span>收件人姓名：</span>
					<input type="text" id="receiver" placeholder="请输入收件人姓名" />
				</div>
				<div class="input-item oh">
					<span>电话：</span>
					<input type="text" id="phone" placeholder="请输入手机号" />
				</div>
				<form class="layui-form">
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
				<div class="input-item oh">
					<span></span>
					<input type="text" id="detailedAddress" placeholder="请输入详细地址" />
				</div>
			</div>
			<div class="handleBtnBox">
				<button class="queDing" onclick="saveAddress()">保存</button>
				<button class="cancel" onclick="closeThat()">取消</button>
			</div>
			<input type="hidden" id="addressId" value="">
			<input type="hidden" id=isDefault value="">
		</div>
	</div>
	<!-- <div class="myDataItem jiaoYiBox" style="display:none;">
		<div class="jiaoYiRecord">
			<div class="topSearch oh">
				<input type="text" class="startDate" id="startTime" autocomplete="off" placeholder="yyyy-MM-dd" />
				<span>~</span>
				<input type="text" class="endDate" id="endTime" autocomplete="off" placeholder="yyyy-MM-dd" />
				<button class="searchBtn" style="cursor:pointer;">搜索</button>
			</div>
			<div class="jiaoYiContent">
				<div class="searchTj">
					<span id="timeStar"></span>~<span id="timeEnd"></span>
					
					<p>
						收入<span class="shouRu">0.00</span>
						支出<span class="zhiChu">150.00</span>
					</p>
				</div>
				<div class="jyTab">
					<ul class="jyType oh">
						<li class="active" data-val="2">全部</li>
						<li data-val="1">收入</li>
						<li data-val="0">支出</li>
					</ul>
				</div>
				
				<div class="jyCon">
					<div class="show">
						<table class="titleCon" id="test"></table>
					</div>
				</div>
			</div>
		</div>
	</div> -->
	<!-- 交易记录  //1--充值 2--提问 3--购买 4--旁听 5--打赏  6--提问退款 7--平台收益-->
	<script type="text/html" id="barDemo1">
		{{# if(d.type == 1){ }}
		充值
		{{# }else if (d.type==2) { }}
		提问
		{{# }else if (d.type==3) { }}
		购买
		{{# }else if (d.type==4) { }}
		旁听
		{{# }else if (d.type==5) { }}
		打赏
		{{# }else if (d.type==6) { }}
		提问退款
		{{# }else if (d.type==7) { }}
		平台收益
		{{# } }}
	</script>
	<script type="text/html" id="barDemo2">
		{{# if(d.status==1){ }}
		+{{d.money}}
		{{# }else if(d.status==0){ }}
		-{{d.money}}
		{{# } }}
	</script>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/js/jquery.js"></script>
		<script type="text/javascript" src="/manage/public/layui/mui_use.js"></script>
		<script type="text/javascript" src="/manage/logistics/assets/data.js"></script>
    	<script type="text/javascript" src="/manage/logistics/assets/province.js"></script>
		<script type="text/javascript">
		layui.use(['table','laydate'], function(){
			var laydate = layui.laydate,
			table = layui.table;
			
			laydate.render({
				elem: '#startTime'
			});
			laydate.render({
				elem: '#endTime'
			});
			
			$('.jyType li').click(function(){
				$(this).addClass('active').siblings().removeClass('active');
				var data = datafunc();
				table.reload('test', {
					where: data
				});
			});
			function datafunc(){
				var status = $('.jyType li[class="active"]').data('val');
				var startTime = $("#startTime").val();
				var endTime = $("#endTime").val();
				var data = { status:status,startTime:startTime,endTime:endTime };
				return data;
			}
			 table.render({
				elem: '#test'
				,url:'/usercenter/mymoney/partialList'
				,page:[10,,20,50,100]
				,cols: [[
					{ field:'time', title: '时间' }
					,{ field:'num', title: '订单号' }
					,{ toolbar: '#barDemo1', title: '财务类型' }
					,{ toolbar: '#barDemo2', title: '收支金额' }
					,{ field:'balance', title: '余额' }
				]]
			 	,done: function(res, curr, count){
			 		var data = res;
			 	    //返回数据总的收入和支出
			 		var consumTotal = data.data[0].consumTotal;
			 		var incomeTotal = data.data[0].incomeTotal;
			 		$('.shouRu').html(Number(incomeTotal).toFixed(2));
			 		$('.zhiChu').html(Number(consumTotal).toFixed(2));
			 	  }
			});
			 $('.searchBtn').click(function(){
				$('#timeStar').html($('#startTime').val());
				$('#timeEnd').html($('#endTime').val());
				var data = datafunc();
				table.reload('test', {
					where: data
				});
			});
		});
		
		$('.jiaoYiJiLu').click(function(){
			$('.myDataItem').removeClass('show');
			$('.jiaoYiBox').show();
		})
		$('.chargenums').children('span').click(function(){
			$(this).addClass('seled').siblings().removeClass('seled');
		})
		$('.paywaylist').children('span').click(function(){
			$(this).addClass('cur').siblings().removeClass('cur');
		})
		$('.btn_charge').click(function(){
			$('.charge_win').show();
			$('.shade').show();
		})
		$('.close').click(function(){
			$('.charge_win').hide();
			$('.shade').hide();
		})
		$('.btn_cancel').click(function(){
			$('.charge_win').hide();
			$('.shade').hide();
		})
			var form;
			layui.use(['laydate','form'], function(){
				  var laydate = layui.laydate;
				  form = layui.form;
				
				  laydate.render({
				    elem: '#birthDate'
				  });
			});
			var wHeight = $(window).height();
			var wWidth = $(window).width();
			
			$(function() {
				$('#ziLiaoBox').css({
					"top": (wHeight - 590) / 2,
					"left": (wWidth - 430) / 2
				})
				$('#insDialog').css({
					"top": (wHeight - 460) / 2,
					"left": (wWidth - 590) / 2
				});
				$('#addressIns').css({
					"top": (wHeight - 300) / 2,
					"left": (wWidth - 600) / 2
				})
				//个人中心已购
				//$('.productType1 li:first').click();
				//已购
				$('.productType2 li:first').click();
				//订单
				$('.orderType li:first').click();
				//钱包
				youhuiList(1);
				//消息
				personalNews();
				//播放历史
				playHistory();
				//笔记
				personalNotes();
				//收藏
				personalStores(1);
				personalStores(2);
				
				//关注
				dataguanzhu(1);
				//打赏
				datadashang(1);
				//旁听
				datapangting(1);
				//提问
				datatiwen(1); 
				
				//编辑用户地址数据回显的方式
				var addTypeRess = '${mapType.type}';
				addTypeRess == '2'?$('.leftSecMenu li').eq(1).click():'';
				addTypeRess == '6'?$('.leftSecMenu li').eq(5).click():'';
			})
			window.onresize = function() {
				var wHeight = $(window).height();
				var wWidth = $(window).width();
				$('#ziLiaoBox').css({
					"top": (wHeight - 590) / 2,
					"left": (wWidth - 430) / 2
				})
				$('#insDialog').css({
					"top": (wHeight - 460) / 2,
					"left": (wWidth - 590) / 2
				})
				$('#addressIns').css({
					"top": (wHeight - 300) / 2,
					"left": (wWidth - 600) / 2
				})
			}
			$('.leftSecMenu li').click(function() {
				
				$(this).addClass('active').siblings().removeClass("active");
				var index = $(this).index();
				$('.rightSec>div:eq(' + index + ')').addClass('show').siblings().removeClass('show');
				$('.jiaoYiBox').hide();
			})
			$('.productType1 li').click(function() {
				$(this).addClass('active').siblings().removeClass("active");
				var index = $(this).index();
				$('.tabContent>div:eq(' + index + ')').addClass('show').siblings().removeClass('show');
				//异步返回html
				var type = $('.tabContent>div:eq(' + index + ')').attr("id");
				if(type == ""){
					return ;
				}
				$.ajax({
					type:'post',
					url:'/usercenter/order/'+type,
					data:{
						page:1,
						pageSize:3
					},
					dataType:'html',
					success:function(html){
						$('#'+type).html(html);
					}
				});
			})
			$('.productType2 li').click(function() {
				$(this).addClass('active').siblings().removeClass("active");
				var index = $(this).index();
				$('.tabContent2>div:eq(' + index + ')').addClass('show').siblings().removeClass('show');
				//异步返回html
				var type = $('.tabContent2>div:eq(' + index + ')').attr("id");
				if(type == ""){
					return ;
				}
				var actualType = type.substring(0,type.length-1);
				$.ajax({
					type:'post',
					url:'/usercenter/order/'+actualType,
					data:{
						page:1,
						pageSize:8
					},
					dataType:'html',
					success:function(html){
						$('#'+type).html(html);
					}
				});
			})
			
			$('.editBtn').click(function(){
				if($(this).attr('data-state') == "0"){
					$("#provid").val("");
					$("#cityid").val("");
					$("#areaid").val("");
					$("#receiver").val("");
					$("#phone").val("");
					$("#detailedAddress").val("");
				}else if($(this).attr('data-state') == "1"){
					//数据回显
					var id = $(this).data('val');
					$.ajax({
						type:'post',
						url:'/usercenter/account/turnAddAddress',
						data:{id:id},
						dataType:'json',
						success:function(data){
							if(data!=null){
								$("#receiver").val(data.receiver);
								$("#phone").val(data.phone);
								$("#addressId").val(data.Id);
								$("#isDefault").val(data.isDefault);
								$("#detailedAddress").val(data.detailedAddress);
								var defaults = {
							            s1: 'provid',
							            s2: 'cityid',
							            s3: 'areaid',
							            v1: data.province,
							            v2: data.city,
							            v3: data.county
							        };
								display(defaults);
							}else{
								tipinfo("获取失败")
							}
						}
					})
				}
				$('#dia').show();
				$('#addressIns').show();
			});
			//加载数据方法
			layui.define(['jquery', 'form'], function () {
				window.display = function(defaults){
					treeSelect(defaults);
				}
			});
			$('.closeThat').click(function(){
				$('#dia').hide();
				$('#addressIns').hide();
			})
			//取消
			function closeThat(){
				$('.closeThat').click();
			}
			function readEBook(pubId,bookId){
				window.location.href="/product/getEBookContent?period="+pubId+"&bookId="+bookId+"&geren=1&type=1&pageNow=1&pageSize=10";
			}
			function openEBookByPc(id){
				window.location.href="/product/turnPublicaDisplay?id="+id;
			}
			$('.orderType li').click(function(){
				$(this).addClass('on').siblings().removeClass('on');
				//获取选中的tab值
				var status = $(this).data('status');
				$('#personalOrderDetails').html("");
				$('#confirmToReceive').html("");
					$.ajax({
						type:'post',
						url:'/usercenter/order/selectPersonalOrders',
						data:{
							page:1,
							pageSize:8,
							orderStatus:status
						},
						dataType:'html',
						success:function(html){
							$('#totalOrder').html(html);
							/* if(status == -1){
								$('#totalOrder').html(html);
							}else if(status == 1){//待付款
								$('#totalOrder').html(html);
							}else if(status == 5){//已完成
								$('#totalOrder').html(html);
							}else if(status == 6){//已取消
								$('#totalOrder').html(html);
							}  */
						}
					});
			})
			//订单详情
			function orderDetail(orderId,orderstatus){
				//获取当前订单
				var status = '';
				if(orderstatus == '1'){
					status = '等待买家付款'
				}else if(orderstatus == 2){
					status = '等待卖家发货';
				}else if(orderstatus == '3'){
					if(orderstatus == '1'){
						status = '卖家已发货';
					}else if(orderstatus == '2'){
						status = '卖家已部分发货';
					}
				}else if(orderstatus == '4'){
					status = '待评价';
				}else if(orderstatus == '5'){
					status = '订单已完成';
				}else if(orderstatus == '6'){
					status = '订单已取消';
				}else if(orderstatus == '7'){
					status = '退款中';
				}
				$('#totalOrder').html("");
				$('#confirmToReceive').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/order/orderDetail',
					data:{
						orderId:orderId,
						status:status
					},
					dataType:'html',
					success:function(html){
						$('#personalOrderDetails').html(html);
						var $div=$("div.gwc_top");
						var orderType=parseInt($div.data("ordertype"));
						var $divOther=$("div.gwc_top_other");
						if((orderType&2)>0){
							$div.show();
						}else{
							$divOther.show();
						}
					}
				});
			}
			
			//确认收货
			function toDetails(status,orderId){
				$('#totalOrder').html("");
				$('#personalOrderDetails').html();
				$.ajax({
					type:'post',
					url:'/usercenter/order/oDetail',
					data:{
						orderId:orderId,
						type:1
					},
					dataType:'html',
					success:function(html){
						$('#confirmToReceive').append(html);
					}
				});
				$.ajax({
					type:'post',
					url:'/usercenter/order/oDetail',
					data:{
						orderId:orderId,
						type:2
					},
					dataType:'html',
					success:function(html){
						$('#confirmToReceive').append(html);
					}
				});
				$.ajax({
					type:'post',
					url:'/usercenter/order/oDetail',
					data:{
						orderId:orderId,
						type:3
					},
					dataType:'html',
					success:function(html){
						$('#confirmToReceive').append(html);
					}
				});
			}
			
			$('.bianJiZiLiao').click(function() {
				$('#dia').show();
				$('#ziLiaoBox').show();
			})
			$('.closeDia').click(function() {
				$('#dia').hide();
				$('#ziLiaoBox').hide();
			});
			//修改个人资料
			function saveInformation(){
				//保存信息
				data = {
						userUrl:$("#userUrl").val(),
						nickName:$("#nickName").val(),
						sex:$("input[name='gendei']:checked").val(),
						birthDate:$("#birthDate").val(),
						education:$("#education").val(),
						industry:$("#industry").val(),
						occupation:$("#occupation").val(),
						synopsis:$("#synopsis").val()
					}
				$.ajax({
					type:'post',
					data:data,
					url:'/usercenter/account/saveUserMsg',
					datatype:'json',
					success:function(data){
						tipinfo(data.msg);
						setTimeout( function(){location.reload();},800);
					},
					error:function(){
						tipinfo("出错了!");
					}
				})
				$('.closeDia').click();
			}
			//取消
			function cancel(){
				$('.closeDia').click();
				location.reload();
			}
			
			$('.diaItem').click(function() {
				var TarName = $(this).attr('data-target');
				$('#insDialog>#'+TarName).addClass('show').siblings().removeClass('show');
				$('#dia').show();
				$('#insDialog').show();
			})
			$('.closeThis').click(function() {
				$('#dia').hide();
				$('#insDialog').hide();
				location.reload();
			});
			$('.quanType>a').click(function(){
				$(this).addClass("active").siblings().removeClass("active");
				if($(this).index()==0){
					$('#youhuiquan').removeClass("hide");
					$('#daijinquan').addClass("hide");
					youhuiList(1);
				}else{
					$('#youhuiquan').addClass("hide");
					$('#daijinquan').removeClass("hide");
					daijinList(1);
				}
			});
			
			$('.yhqType>a').click(function(){
				$(this).addClass("active1").siblings().removeClass("active1");
				if($('.quanType a[class="active"]').data('val') == 0){
					youhuiList($(this).data('val'));
				}else if($('.quanType a[class="active"]').data('val') == 2){
					daijinList($(this).data('val'));
				}
			});
			
			//收藏
			function personalStores(type){
				//$('#storeList').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/storeList',
					data:{
						page:1,
						pageSize:100,
						type:type
					},
					datatype:"html",
					success:function(html){
						$('#storeList').append(html);
						//$('#storeList').html(html);
					}
				});
			}
			
			//取消收藏
			function delCang(ids){
				$.ajax({
			        type:"get",
			        url:"/usercent/favorite/delFavrites?ids="+ids+"&dataType=1",
			        datatype:"html",
			        success:function(data){
			        	tipinfo(data.msg);
			        	setTimeout(function(){ location.href="/usercenter/account/index?type=6"; },800);
			        },
			    });
			}
			
			//点击确认收货
			function confirmToReceiveRight(invoiceId){
				var invoiceIds=[];
				var orderId=0;
				$.each($('input:checkbox:checked'),function(){
					for(var i = 0 ; i<$('input[type=checkbox]:checked').length ; i++ ){
						orderId = $(this).val();
						var v = $(this).data("val");
						if (invoiceIds.indexOf(v) == -1) {
							invoiceIds.push(v);
						}
					}
				});
				var invoiceId = invoiceIds.join(',');
				var orderId = $('#check_5').val();
				console.log(invoiceId)
				if(!$('#check_5').prop("checked")){
					alert("请选择确定商品");
				}else{
					//window.location.href="/phone/usercenter/account/upOStatus?orderId="+orderId+"&invoiceId="+invoiceId;
					$.ajax({
						type:'post',
						url:'/usercenter/order/upOStatus',
						data:{
							"orderId":orderId,
							"invoiceId":invoiceId
						},
						datatype:'json',
						success:function(data){
							if(data.result == 1){
								tipinfo(data.msg);
								//window.location.href="/usercenter/order/selectPersonalOrders?page=1&pageSize=8&orderStatus=-1";
								window.location.href= "/usercenter/account/index";
							}else{
								tipinfo(data.msg);
							}
						},
						error:function(){
							alert("出错了!");
						}
					})
					
					
				}
			}
			
			//笔记
			function personalNotes(){
				$('#notes').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/nodeList',
					data:{
						page:1,
						pageSize:8
					},
					datatype:"html",
					success:function(html){
						$('#notes').html(html);
					}
				});
			}
			//删除笔记
			function cancelNode(obj,id){
				layer.confirm("确定删除此学习记录吗？",function(){
					$.post("/usercenter/node/cancelNode",{
						id:id,
						r:Math.random()
					},function(json){
						tipinfo(json.msg);
						if(json.result){
							$(obj).parent().parent().remove();
						}
					},"json").error(function(){
						tipinfo("删除失败,请稍后再试！");
					});
				})
			}
			
			//播放历史
			function playHistory(){
				$('#playHistoryList').html("");
				var hourIdUrl=localStorage.getItem('hourIdUrl');
				$.ajax({
					type:'post',
					url:"/product/localHourDetail"+hourIdUrl,
					datatype:"html",
					success:function(html){
						$('#playHistoryList').html(html);
					}
				});
			}
			//播放课时	IsBuyOndemand 是否购买了该课程（1是0否） IsAudition 是否是试听课时(1是0否)
			function playVideo(hourId,ondemandId){
				window.location.href="/product/hourDetail?hourId="+hourId+"&ondemandId="+ondemandId;
			}
			//消息
			function personalNews(){
				$('#personalNewList').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/newsList',
					data:{
						page:1,
						pageSize:8
					},
					datatype:"html",
					success:function(html){
						$('#personalNewList').html(html);
					}
				});
			}
			//获取优惠券代金券的列表
			function youhuiList(type){
				$('#youhuiquan').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/youhuiList',
					data:{
						page:1,
						pageSize:8,
						type:type
					},
					datatype:"html",
					success:function(html){
						$('#youhuiquan').html(html);
					}
				});
			}
			function daijinList(type){
				$('#daijinquan').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/daijingList',
					data:{
						page:1,
						pageSize:8,
						type:type
					},
					datatype:"html",
					success:function(html){
						$('#daijinquan').html(html);
					}
				});
			}
			//关注
			function dataguanzhu(state){
				//清空关注
				$('#guanzhu').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/myfollow',
					data:{
						page:1,
						pageSize:8,
						type:state
					},
					datatype:"html",
					success:function(html){
						$('#guanzhu').html(html);
					}
				});
			}
			//取消关注
			function cancelFollow(obj,userId){
				
				layer.confirm('确定取消关注', function(){
					$.ajax({
						type:'post',
						data:{"teacherId":userId},
						url:'/home/cancelFoolow',
						datatype:'json',
						success:function(data){
							tipinfo(data.msg);
							if(data.success){
								$(obj).parent().remove();
							}
						},
						error:function(){
							tipinfo("取消失败,请稍后再试!");
						}
					})
				});
				
			}
			//打赏记录
			function datadashang(state){
				//清空打赏
				$('#dashang').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/RewardlogData',
					data:{
						page:1,
						pageSize:6,
						state:state
					},
					datatype:"html",
					success:function(html){
						$('#dashang').html(html);
					}
				});
			}
			//旁听记录
			function datapangting(state){
				//清空打赏
				$('#pangting').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/myAudit',
					data:{
						page:1,
						pageSize:4,
						state:state
					},
					datatype:"html",
					success:function(html){
						$('#pangting').html(html);
					}
				});
			}
			//提问记录
			function datatiwen(state){
				//清空提问
				$('#tiwen').html("");
				$.ajax({
					type:'post',
					url:'/usercenter/account/myQuizData',
					data:{
						page:1,
						pageSize:3,
						state:state
					},
					datatype:"html",
					success:function(html){
						$('#tiwen').html(html);
					}
				});
			}
			//添加收货地址
			var defaults = {
		            s1: 'provid',
		            s2: 'cityid',
		            s3: 'areaid',
		            v1: '${province}',
		            v2: '${city}',
		            v3: '${county}'
		        };
			function saveAddress(){
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
				data = { Id:$('#addressId').val(),
						province:provid,
						city:cityid,
						county:areaid,
						receiver:receiver,
						phone:phone,
						detailedAddress:$("#detailedAddress").val(),
						isDefault:$('#isDefault').val()
					}
				console.log(data);
				$.ajax({
					type : "POST",
					url : "/usercenter/account/saveAddress",
					async : false,
					data : data,
					success : function(data) {
						tipinfo(data.msg);
						setTimeout(function(){ location.href="/usercenter/account/index?type=2"; },800);
					},
					error : function(data) {

					}
				});
			}
			//删除地址
			function del(id){
				layer.confirm('确定要删除吗？', {
				  btn: ['确定','取消'] //按钮
				}, function(){
					$.ajax({
						type : "POST",
						url : "/usercenter/account/delAddress",
						async : false,
						data : {
							"id" : id
						},
						dataType:"json",
						success : function(data) {
							if(data.success>0){
								tipinfo(data.msg);
								setTimeout(function(){ location.href="/usercenter/account/index?type=2"; },600);
							}
						},
						error : function(data) {
						}
					})
				});
			}
			//设置默认地址
			function changeAddress(id){
				$.ajax({
					type : "POST",
					url : "/usercenter/account/changeAddressDefault",
					async : false,
					data : {
						"id" : id
					},
					success : function(data) {
						tipinfo(data.msg);
						setTimeout(function(){ location.href="/usercenter/account/index?type=2"; },600);
					},
					error : function(data) {

					}
				});
			}
			
			//我的订单列表-去支付按钮
			function turnzhifu(orderId,paylogId,totalprice){
				window.location.href="/order/toCreateOrder?paylogId="+paylogId+"&totalPrice="+totalprice;
			}
			
			//我的订单列表-取消订单
			function updOrderStatus(orderstatus,orderId){
				var data = {orderstatus:orderstatus,orderId:orderId}
				$.post("/usercenter/account/updOrderStatus",data);
				setTimeout(function(){tipinfo("取消成功");$('.orderType li:first').click();}, 800);
			}
			
			$(function(){
				$("img").error(function() {
					$(this).attr("src", "/manage/images/index/noImage.jpg");
				});

				$(document).ajaxSuccess(function() {
					$("img").error(function() {
						$(this).attr("src", "/manage/images/index/noImage.jpg");
					});
				});
			})
			//钱包-充值中的立即支付
			$('.btn_pay').click(function(){
				var rechargeMoney = $('.chargenums span[class="seled"]').data('val');
				if(rechargeMoney ==null || rechargeMoney==''){
					tipinfo("请选择充值金额");
					return ;
				}
				var paytype = $('.paywaylist span[class="cur"]').data('val');
				if(paytype=="" || paytype==undefined){
					tipinfo("请选择支付方式，或该方式还未开放");
					return ;
				}
				$.ajax({
					type : "POST",
					url : "/usercenter/account/createOrder",
					data : {"price" : rechargeMoney,"paytype":paytype},
					success : function(data) {
						if(data.result==1){
							var paylogId = data.paylogId;
							var paytype = data.paytype;
							if(paytype == 3){//支付宝支付
								$.ajax({
									type:'post',
									url:'/pay/waittingPay',
									data:{paylogId:paylogId,paytype:paytype},
									success:function(data){
										console.log(data.payResult.requestData)
										$('#qrcode').html(data.payResult.requestData);
									}
								});
							}else if(paytype == 7){//微信支付
								/* $.ajax({
									type:'post',
									url:'/pay/waittingPay',
									data:{paylogId:paylogId,paytype:paytype},
									success:function(data){
										//tipinfo(data.msg);
										//setTimeout(function(){window.location.href="/home/index"},1000);
										jQuery('#qrcode').qrcode(data.payResult.requestData);
									}
								});
							} */
							//window.location.href="/pay/waittingPay?paylogId="+paylogId+"&paytype="+paytype;
							window.location.href="/pay/wechatcode?code="+data.payResult.requestData+"&paylogId="+paylogId;
						    }
						}else{
							alertinfo(data.msg);
						}
					},
					error : function(data) {
						tipinfo("网络连接失败..")
					}
				});
			});
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
