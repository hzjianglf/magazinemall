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
			<h3>打赏</h3>
		</div>
		<div class="jxzf">
			<!--问答支付-->
			<div class="wdzf">
				<p>商品名称：<em class="em1">打赏-${realname }</em></p>
				<P>商品价格：<em class="em2">${money }元</em></P>
				<p class="p1">描述： <em class="em1">${rewardMsg }</em></p>
			</div>
			<div class="jxzf_fs">
				<h3>支付方式：</h3>
				<ul>
					<c:forEach items="${paylist }" var="paylist" varStatus="cw">
						<li>
							<c:if test="${paylist.payType == '账户余额支付' }">
								<c:if test="${money > balance}">
									<a href="/usercenter/mymoney/trunRecharge" class="cz_biao">充 值</a>
								</c:if>
								<c:if test="${balance > money }">
									<span class="radio_box">
				                   		<input type="radio" id="radio_${cw.count }" ${cw.count==1?'checked':'' } name="radio" value="${paylist.id }" data-name="${paylist.methodName }" data-type="${paylist.payType }">
				                   		<label for="radio_${cw.count }"></label>
			                   		</span>
								</c:if>
							</c:if>
							<c:if test="${paylist.payType != '账户余额支付' }">
								<span class="radio_box">
			                   		<input type="radio" id="radio_${cw.count }" name="radio" value="${paylist.id }" data-name="${paylist.methodName }" data-type="${paylist.payType }">
			                   		<label for="radio_${cw.count }"></label>
		                   		</span>
	                   		</c:if>
							<img src="${paylist.picUrl }"> ${paylist.methodName }
							<c:if test="${paylist.payType == '账户余额支付' }">
								<em>￥${balance } ${(balance < money)?'（余额不足）':'' }</em>
							</c:if>
						</li>
					</c:forEach>
				</ul>
			</div>
			<div class="wxts">
				温馨提示：<br><em>商品购买完成后不可退回。</em>
			</div>
			<button class="qr_biao" type="button" onclick="pay('${teacherId}','${money }','${rewardMsg }');">确认支付   ￥${money }</button>
		</div>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript" src="/manage/public/layui/layui.js"></script>
		<script type="text/javascript">
			//确认支付（商品类型,点播课程4，直播课程8）
			function pay(teacherId,money,rewardMsg){
				//获取支付方式id
				var paytype = $("input[type='radio']:checked").val();
				//支付方式类型
				var type = $("input[type='radio']:checked").data('type');
				if(paytype==null || paytype==''){
					tipinfo("请选择支付方式");
					return false;
				}
				$.ajax({
					type:'post',
					data:{"contentId":teacherId,"money":money,"rewardMsg":rewardMsg},
					url:'/pay/RewardTeacher',
					datatype:'json',
					success:function(data){
						if(data.success){
							//跳转等待页面
							window.location.href="/pay/waittingPay?paylogId="+data.paylogId+"&paytype="+paytype+"&typeName="+type;
						}
					},
					error:function(data){
						alert("系统异常,请联系管理员!");
					}
				})
			}
		</script>
	</pxkj:Content>
</pxkj:ContentPage>
