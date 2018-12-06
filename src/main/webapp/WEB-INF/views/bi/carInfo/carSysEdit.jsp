<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
var carSysEidtDetailGrid;
$(function(){
	//计费货物名称下拉选项
	$('#carSysEdit_goodsName').combobox({
        url : '${path }/dictionary/selectDiByCode',
        queryParams:{
        	"code": "HWMC"
        },
        valueField : 'id',
        textField : 'name',
        editable : false,
        value : '${carInfo.goodsName}'
    });
	
	//付款方式下拉选项
	$('#carSysEdit_paymentMode').combobox({
        url : '${path }/dictionary/selectDiByCode',
        queryParams:{
        	"code": "FKFS"
        },
        valueField : 'code',
        textField : 'name',
        editable : false,
        value : '${carInfo.paymentMode}'
    });
	
	//计费项目下拉选项
	$('#carSysEdit_chargeType').combobox({
        url : '${path }/chargeType/selectAllChargeType',
        queryParams:{
        	"isAllStatus": true
        },
        valueField : 'id',
        textField : 'name',
        editable : false,
        value : '${carInfo.chargeType}'
    });
	
	//获取付款单明细
	carSysEditDetailGrid = $("#carSysEditDetailGrid").datagrid({
		url : '${path}/carInfo/getPaymentDetailByCarId?id='+'${carInfo.id}',
        striped : true,
        rownumbers : true,
        // pagination : true,
        singleSelect : true,
        showFooter: true,
        idField : 'itemId',
        sortName : 'itemId',
        sortOrder : 'asc',
        // pageSize : 20,
        // pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        columns :[[{
            width : '60',
            title : 'itemId',
            field : 'itemId',
            hidden : true,
            sortable : true
        },{
        	width : '120',
            title : '计费项目名称',
            field : 'itemName'
        },{
        	width : '50',
        	title : '价格',
        	field : 'price'
        },{
        	width : '50',
        	title : '数量',
        	field : 'count'
        },{
        	width : '70',
            title : '总价',
            field : 'amount'
        },{
        	width : '60',
            title : '操作人',
            field : 'createUserName'
        },{
        	width : '100',
            title : '操作日期',
            field : 'billTime'
        },{
        	width : '60',
            title : '付款方式',
            field : 'paymentModeName'
        },{
        	width : '260',
            title : '费用说明',
            field : 'remark'
        }] ],
        onLoadSuccess : function(data){
        	accountTotal();//计算合计
        },
        onLoadError : function(){
        	$.messager.alert('错误','获取计费明细失败，请重试！','warning');
        	$('#carSysEditDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
        	$('#carSysEdit_total').numberbox('setValue','0');//费用总计置0
        }
		
	});
	
	// form提交
	$('#carSysEditForm').form({
        url : '${path}/carInfo/carSysEdit',
        onSubmit : function() {
            progressLoad();
            var isValid = $(this).form('validate');
            if (!isValid) {
                progressClose();
            }
            return isValid;
        },
        success : function(result) {
            progressClose();
            result = $.parseJSON(result);
            if (result.success) {
            	$.messager.alert('消息',result.msg,'info');
                parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为页面预定义好了
                parent.$.modalDialog.handler.dialog('close');
            } else {
            	$.messager.alert('错误',result.msg,'warning');
            }
        }
    });

  	//赋值
    $("#carSysEdit_isYearCard").val('${carInfo.isYearCard}'); 
    $("#carSysEdit_outRemark").val('${carInfo.outRemark}'); 
});
    
//计算合计
function accountTotal() {
	$('#carSysEdit_total').numberbox('setValue',compute("amount"));
}

//指定列求和
function compute(colName) {
	var rows = $('#carSysEditDetailGrid').datagrid('getRows');
	var total = 0;
	var currCell;
	for (var i = 0; i < rows.length; i++) {
		if(isNaN(rows[i][colName]) || null == rows[i][colName] || "" == rows[i][colName]){
			currCell = 0
		}else{
			currCell = parseFloat(rows[i][colName]);
		}
		total += currCell;
	}
	return total;
}

</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;width:750px; height:350px;">
        <form id="carSysEditForm" method="post">
            <table class="grid">
                <tr>
                	<input name="id" type="hidden" value="${carInfo.id}">
                    <td>车牌号</td>
                    <td><input name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true" style="width: 100px;" value="${carInfo.carNo}" />
                     &nbsp;&nbsp;
                                                               是否年卡&nbsp;&nbsp;
                     <select id="carSysEdit_isYearCard" name="isYearCard" class="easyui-combobox" data-options="width:50,editable:false,panelHeight:'auto'" readonly="readonly">
							<option value="0">是</option>
							<option value="1">否</option>
					 </select>
                    </td>
                	<td>计费项目</td>
                	<td>
                		<select id="carSysEdit_chargeType" name="chargeType" style="width: 180px; height: 22px;" class="easyui-combobox" readonly="readonly"></select>
                	</td>
                </tr> 
                <tr>
                	<td>客户名称</td>
                	<td>
                		<input name="customerName" type="text" value="${carInfo.customerName}" style="width: 140px;" readonly="readonly" />
                	</td>
                	<td>货物入库车辆</td>
                	<td>
                		<input name="goodsInCarNo" type="text" value="${carInfo.goodsInCarNo}" style="width: 90px;" readonly="readonly" />
                		<input name="goodsInCarId" value="${carInfo.goodsInCarId}" type="hidden"/>
                	    &nbsp;&nbsp;
                		运单号
                		&nbsp;&nbsp;
                		<input name="waybillNo" type="text" class="easyui-validatebox span2" data-options="" style="width: 60px;text-align: right;" value="${carInfo.waybillNo}" />
                	</td>
                </tr>
                <tr>
                    <td>车辆入库日期</td>
                    <td>
                    	<input name="inTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;" value="${carInfo.inTime}" />
                    </td>
                    <td>车辆出库日期</td>
                	<td>
                		<input name="outTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;" value="${carInfo.outTime}" />
                		&nbsp;&nbsp;停车天数 &nbsp;&nbsp; <input name="parkDays" type="text" class="easyui-numberbox span2" data-options="precision:0" style="width: 35px;" value="${carInfo.parkDays}" readonly="readonly">
                	</td>
                	
                </tr> 
                <tr>
                    <td>商品入库日期</td>
                    <td>
                    	<input name="goodsInTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="${carInfo.goodsInTime}" style="width: 140px;" />
                    </td>
                    <td>商品出库日期</td>
                	<td>
                		<input name="goodsOutTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" value="${carInfo.goodsOutTime}" style="width: 140px;" />
                		&nbsp;&nbsp;堆存天数 &nbsp;&nbsp; <input name="stockDays" type="text" class="easyui-numberbox span2" data-options="precision:0" style="width: 35px;" value="${carInfo.stockDays}" readonly="readonly">
                	</td>
                </tr> 
                <tr>
                <!-- 
                	<td><font color="red">*</font>车辆毛重(t)</td>
                	<td><input name="grossWeight" type="text" placeholder="请输入毛重" class="easyui-numberbox span2" data-options="precision:2" style="width: 140px;text-align: right;"></td>
                 -->
                	<td>货物净重(t)</td>
                	<td><input name="netWeight" type="text" value="${carInfo.netWeight}" class="easyui-numberbox span2" data-options="min:0,precision:2" style="width: 80px;text-align: right;" />
                		&nbsp;&nbsp;
                		件数/包/辆
                		&nbsp;&nbsp;
                		<input name="goodsQuantity" type="text"  class="easyui-numberbox span2" data-options="min:0,precision:0" style="width: 50px;text-align: right;" value="${carInfo.goodsQuantity}" />
                	</td>
                	<td>货物名称</td>
                	<td>
                		<select id="carSysEdit_goodsName" name="goodsName" style="width: 100px; height: 22px;" data-options="panelHeight:'auto'" class="easyui-combobox" ></select>
                		&nbsp;&nbsp;
                		货位号
                		&nbsp;&nbsp;
                		<input name="goodsStoreNo" type="text" value="${carInfo.goodsStoreNo}" class="easyui-validatebox span2" data-options="" style="width: 80px;text-align: right;" />
                	</td>
                </tr>
                <tr>
                	<td>合同号</td>
                	<td><input name="contractNo" type="text" class="easyui-validatebox span2" data-options="" style="width: 75px;text-align: right;" value="${carInfo.contractNo}" />
                		&nbsp;&nbsp;
                		出车单号
                		&nbsp;&nbsp;
                		<input name="outStockNo" type="text" value="${carInfo.outStockNo}" class="easyui-validatebox span2" data-options="" style="width: 75px;text-align: right;" />
                	</td>
                	<td>出库说明</td>
                	<td><textarea rows="2" id="carSysEdit_outRemark" name="outRemark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
            <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;width:750px; height:170px;">
        		<table id="carSysEditDetailGrid" data-options="border:false" style="overflow: hidden;padding: 3px;width:750px; height:170px;"></table>
    		</div>
    		<div align="right">
    		    <select id="carSysEdit_paymentMode" name="paymentMode" class="easyui-combobox" style="height: 22px;" data-options="width:100,height:29,editable:false,panelHeight:'auto'" readonly="readonly"></select>
        		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        		<span stytle="colour:red">
        		费用总计：
        		<input id="carSysEdit_total" name="total" class="easyui-numberbox" value="0" readonly="readonly"
        		 style="width: 100px;text-align: right;" data-options="min:0,precision:2">
        		</span>
        	</div>
        </form>
    </div>
</div>
