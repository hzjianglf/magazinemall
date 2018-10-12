<%@ page language="java" isELIgnored="false"
	contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/authorizetag.tld" prefix="px"%>
<%@ taglib uri="/WEB-INF/tlds/jsp-masterpage.tld" prefix="pxkj"%>
<pxkj:ContentPage materPageId="WebMaster">
	<pxkj:Content contentPlaceHolderId="css">
		<style type="text/css">
			.laytable-cell-1-shopping{  /*最后的pic为字段的field*/
				height: 100%;
				max-width: 100%;
			}
			.layui-body{
				overflow-y: scroll;
			}
			.layui-layer-dialog{
				background:#ccc;
			}
		</style>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="content">
		<div class="shopCarList">
			<p class="title">
				<span>全部商品</span>
			</p>
			<div class="shopCarTable">
				<table class="" id="shopCart" lay-filter="tableContent"></table>
				<table style="width:100%;">
					<tfoot>
						<tr>
							<td>
							</td>
							<td>
								<a href="javascript:void(0)" onclick="del(null,null)">删除所选中的商品</a>
							</td>
							<td>
								已选择<span class="selNum">0</span>件商品
							</td>
							<td colspan="2">
								总价<span class="selPrice">￥<span>0.00</span></span>件商品
							</td>
							<td>
								<button style="cursor:pointer" onclick="turnJieSuan()">去结算</button>
							</td>
						</tr>
					</tfoot>
				</table>
			</div>
		</div>
	<script type="text/html" id="shopping">
		<img class="qiKanImg" src="{{d.productpic }}" alt="" />
			<div class="qkCon">
				<h2>{{d.productname}}</h2>
				{{# if (d.producttype == 2) { }}
					<span>纸质期刊</span>
				{{# }else if (d.producttype == 16) { }}
					<span>电子期刊</span>
				{{# } }}
				{{# if (d.subType==1){ }}
					<span>单期</span>
				{{# }else if (d.subType == 2) { }}
					<span>上半年</span>
				{{# }else if (d.subType == 3) { }}
					<span>下半年</span>
				{{# }else if (d.subType == 4) { }}
					<span>全年</span>
				{{# } }}
			</div>
	</script>
	<script type="text/html" id="shopCount">
		<p class="carNum">
			<a href="javascript:void(0)" lay-event="reduce">-</a>
				<span>{{d.count }}</span>
			<a href="javascript:void(0)" lay-event="add">+</a>
		</p>
	</script>
	<script type="text/html" id="sumPrice">
		{{# return (Number(d.count) * Number(d.buyprice)).toFixed(2) }}
	</script>
	<script type="text/html" id="delete">
		<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	</pxkj:Content>
	<pxkj:Content contentPlaceHolderId="js">
		<script type="text/javascript">
			layui.use(['layer', 'table','form'],function(){
				var table = layui.table,
				layer = layui.layer,
				form = layui.form;
				
				var tableData ; 
				var tableIns = table.render({
					id: 'shopCart',
					elem: '#shopCart',
					page: true ,
					url: 'shopcartList', //数据接口
					cols: [
						[ //表头
							{
								type: 'checkbox',
								align: 'center',
							},
							{
								field: 'shopping',
								templet: '#shopping',
								title: '商品',
								width: '26%'
							},
							{
								field: 'buyprice',
								title: '单价',
							}, 
							{
								toolbar: '#shopCount',
								title: '数量',
							},
							{
								templet: '#sumPrice',
								title: '小计',
							},
							{
								toolbar: '#delete',
								title: '操作',
								align: 'center',
							}
						]
					],
					page: true
				});
				
				$(function (){
					tableData = layui.table.cache;
					$(".layui-table-box").css("width","101%");
				})
				
				//监听表格复选框选择
				table.on('checkbox(tableContent)', function(obj){
					var checkStatus = table.checkStatus('shopCart');
					var data = checkStatus.data;
					//选中的个数
					getCheckLength(data);
					//计算总价
					getCheckData(data);
				});
				
				//获选中元素
				function getCheckData(data){
					var jsonData = eval(JSON.stringify(data));
					var sumPrice = 0;
					//循环获取价格和数量
					for(var obj in jsonData){
						sumPrice += Number(jsonData[obj].buyprice) * Number(jsonData[obj].count);
					}
					$('.selPrice>span').html(sumPrice.toFixed(2).toString());
				}
				
				//选取选中的个数
				function getCheckLength(data){
					$('.selNum').html(data.length);
				}
				
				//监听工具条
				table.on('tool(tableContent)', function(obj){
					var data = obj.data;
					var indexes = obj.tr.data('index');
					
					if(obj.event === 'del'){
						layer.confirm('真的删除行么', function(index){
							del(obj,data.id);
							layer.close(index);
						});
					}else if (obj.event == 'add'){
						addShopping(indexes,$(this),data.id)
					}else if (obj.event == 'reduce'){
						reduceShop(indexes,$(this),data.id);
					}
				});
				//购物数量减少
				function reduceShop(index,Obj,id){
					var count = Number(Obj.next().text());
					if(count > 1){
						count--;
						Obj.next().html(count);
					}else{
						layer.msg("不能操作！");
					}
					changeCount(index,count,Obj,id);
				}
				//购物数量增加
				function addShopping(index,Obj,id){
					var count = Number(Obj.prev().text());
					//count > 9999?$(this).prev().html(count + 1):layer.msg("不能操作");
					count++;
					Obj.prev().html(count);
					changeCount(index,count,Obj,id);
				}
				//缓存count数量的变化
				function changeCount(index,count,Obj,id){
					tableData.shopCart[index].count = count;
					//改变小计
					var pic = (Number(count)*Number(tableData.shopCart[index].buyprice)).toFixed(2);
					Obj.parent().parent().parent().next().find('div').html(pic);
					//改变总价1.获取被循环中的集合
					getCheckData(checkboxData());
					//异步修改数据库数据
					change(id,count);
				}
				
				//获取被选中的集合
				function  checkboxData(){
					var checkboxData = [];
					for( var i = 0 ; i < tableData.shopCart.length; i++){
						if(tableData.shopCart[i].LAY_CHECKED){
							checkboxData.push(tableData.shopCart[i]);
						}
					}
					return checkboxData;
				}
				
				//删除数据
				window.del = function(obj,delID){
					var arr = [],
					data = checkboxData();
					if(delID==null){
						for(var i = 0 ; i< data.length ; i++){
							arr.push(data[i].id);
						}
						if(data.length==0){
							layer.msg("请选择要删除的数据！");
							return false;
						}
					}else{
						arr.push(delID);
					}
					var ids=arr.join(",");
					$.ajax({
				        type:"get",
				        url:"/order/delShopCartItem?ids="+ids,
				        datatype:"html",
				        success:function(data){
				        	layer.msg(data.msg);
				        	if(obj!=null){
				        		obj.del();
				        	}else{
				        		//数据重新加载
				        		reload();
				        	}
				        },
				    });
				}
				
				//数据重新加载
				function reload(){
					tableIns.reload({
						where: { //设定异步数据接口的额外参数，任意设
							r:Math.random()
						},
						page: {
							curr: 1 //重新从第 1 页开始
						}
					});
				}
				//修改商品的数量
				function change(id,count){
					if(count==null||count==0){
						return ;
					}
					$.ajax({
				        type:"post",
				        url:"/order/changeShopCart?id="+id+"&count="+count,
				        success:function(data){
				        },
				    });
				}
				
				//跳转结算
				window.turnJieSuan = function(){
					//获取被选中的数据
					var arr = [],
					data = checkboxData();
					for(var i = 0 ; i< data.length ; i++){
						arr.push(data[i].id);
					}
					if(data.length==0){
						layer.msg("请选择要下单的数据！");
						return false;
					}
					window.location.href="/order/turnJieSuan?shoppingIds="+arr;
				}
				
				//layui结尾
			});

	</script>
	</pxkj:Content>
</pxkj:ContentPage>
