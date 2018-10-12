<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>首页</title>
	</head>
<style>
			body {
				background: #F1F1F7;
				font-family: "微软雅黑";
			}
			
			ul,
			li,
			p {
				margin: 0;
				padding: 0;
				list-style: none;
			}
			
			.topIns {
				margin-top: 30px;
			}
			
			.topIns,
			.topList {
				overflow: hidden;
			}
			
			.topList li {
				width: 21%;
				float: left;
				margin: 0 2%;
				background: #fff;
			}
			
			.topList li .itemCon {
				display: inline-block;
				height: 232px;
				width: 100%;
				line-height: 232px;
				text-align: center;
				font-size: 36px;
				color: #0076C1;
				font-weight: bold;
			}
			
			.topList li .itemTitle {
				display: inline-block;
				width: 100%;
				height: 85px;
				background: #0076C1;
				color: #AABED2;
				text-align: center;
				font-size: 14px;
			}
			
			.topList li .ptitle {
				margin-top: 20px;
				font-size: 18px;
				color: #fff;
				margin-bottom: 5px;
			}
			
			.bottomIns {
				width: 96%;
				margin: 30px 2% 0;
				min-height: 400px;
				overflow: hidden;
			}
			
			.leftChart {
				width: 38%;
				float: left;
			}
			
			.middleList {
				width: 28%;
				min-height: 400px;
				float: left;
				border: 1px solid #ddd;
				border-top: none;
				border-bottom: none;
			}
			
			.middleList ul li.title {
				text-align: center;
				font-weight: normal;
				font-size: 15px;
				line-height: 40px;
			}
			
			.middleList ul li {
				padding: 10px 20px;
				overflow: hidden;
			}
			
			.middleList ul li span {
				display: inline-block;
				float: left;
			}
			
			.middleList ul li p.adress {
				margin-top: 10px;
			}
			
			.middleList ul li img {
				display: inline-block;
				width: 60%;
				text-align: center;
				border-radius: 50%;
			}
			
			span.span60 {
				width: 58%;
				padding-top: 5px;
			}
			
			span.span20 {
				width: 20%;
			}
			
			span.span20.num {
				color: #ff4e00;
				font-size: 20px;
				line-height: 64px;
				text-align: center;
			}
			
			.RightChart {
				width: 30%;
				float: left;
				min-height: 400px;
			}
		</style>
	<body>
		<div id="wrapper" class="container" style="height:100%;">
			<div class="topIns">
				<ul class="topList">
					<li>
						<span class="itemCon">293</span>
						<span class="itemTitle">
							<p class="ptitle">今日资讯量</p>
							<p>(单位:人次)</p>
						</span>
					</li>
					<li>
						<span class="itemCon">${todayBrowse }</span>
						<span class="itemTitle">
							<p class="ptitle">视频咨询数</p>
							<p>(单位:人次)</p>
						</span>
					</li>
					<li>
						<span class="itemCon">${todayCount }</span>
						<span class="itemTitle">
							<p class="ptitle">今日业务量</p>
							<p>(单位:笔)</p>
						</span>
					</li>
					<li>
						<span class="itemCon">${todayPay }</span>
						<span class="itemTitle">
							<p class="ptitle">今日交易</p>
							<p>(单位:元)</p>
						</span>
					</li>
				</ul>
			</div>
			<div class="bottomIns">
				<div class="leftChart">
					<div id="main" style="width: 100%;height:400px;"></div>
				</div>
				<div class="middleList">
					<ul>
						<li class="title">
							客服排行榜
							<img style="width:20px;position: relative;top:5px;" src="img/question.png" alt="" />
						</li>
						<c:forEach items="${thirtyList }" var="thirty">
							<li>
								<span class="span20"><img src="img/user_img.gif" alt="" /></span>
								<span class="span60">
									<b class="name">${thirty.realname }</b>
									<p class="adress">${thirty.name }</p>
								</span>
								<span class="span20 num">${thirty.count }</span>
							</li>
						</c:forEach>
					</ul>
				</div>
				<div class="RightChart">
					<div id="main2" style="width: 100%;height:400px;"></div>
				</div>
			</div>
		</div>

		<script src="/manage/public/js/jquery-1.11.3.js"></script>
		<script type="text/javascript" src="/manage/public/js/echarts.js"></script>
		<script>
			$(function(){
				$.ajax({
					type:"get",
					url:"/${applicationScope.adminprefix }/statistics",
					dataType:"json",
					success:function(data){
						var sevenList = data.sevenList;
						var day = [];
						var count = [];
						$.each(sevenList, function(i){
							day.push(sevenList[i].date);
							count.push(sevenList[i].count);
						})
						initecharts1(day, count);
						var typeList = data.typeList;
						var type = [];
						var count = [];
						$.each(typeList, function(i){
							type.push(typeList[i].typeFirst);
							var data = '{"value":'+typeList[i].percent+',"name":"'+typeList[i].typeFirst+'"}';
							count.push(JSON.parse(data));
						})
						initecharts2(type, count);
					}
				})
			})
			function initecharts1(day, count){
				// 基于准备好的dom，初始化echarts实例
				var myChart = echarts.init(document.getElementById('main'));
				option = {
					title: {
						text: '最近七天咨询量',
						subtext: '(单位:人次)',
					},
					tooltip: {
						trigger: 'axis'
					},
					calculable: true,
					xAxis: [{
						type: 'category',
						data: day
					}],
					yAxis: [{
						type: 'value',
						min: 0,
						max: 400,
					}],
					series: [{
						name: '咨询量',
						type: 'bar',
						itemStyle: {
							normal: {
								color: '#0076C1',
							}
						},
						data: count,
					}]
				};
				// 使用刚指定的配置项和数据显示图表。
				myChart.setOption(option);
				//使图标自适应屏幕的宽度
				window.onresize = myChart.resize;
			}
			
			function initecharts2(type, count){
				// 基于准备好的dom，初始化echarts实例
				var myChart2 = echarts.init(document.getElementById('main2'));
				option2 = {
					title: {
						text: '服务类型分布图',
						x: 'center'
					},
					tooltip: {
						trigger: 'item',
						formatter: "{a} <br/>{b} : {c} ({d}%)"
					},
					legend: {
						orient: 'vertical',
						left: 'left',
						data: type
					},
					series: [{
						name: '服务类型',
						type: 'pie',
						radius: '55%',
						center: ['50%', '64%'],
						data: count,
						itemStyle: {
							emphasis: {
								shadowBlur: 10,
								shadowOffsetX: 0,
								shadowColor: 'rgba(0, 0, 0, 0.5)'
							}
						}
					}]
				};

				// 使用刚指定的配置项和数据显示图表。
				myChart2.setOption(option2);
				//使图标自适应屏幕的宽度
				window.onresize = myChart2.resize;
			}
			
		</script>
		
	</body>
</html>