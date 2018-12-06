<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
	//所属区域下拉选项
	$('#paymentDaily_location').combobox({
		url : '${path }/dictionary/selectDiByCode',
		queryParams:{
			"code": "CKSZQY"
		},
		valueField : 'code',
		textField : 'name',
		editable : false,
		value : '${location}',
		onChange : function(newValue,OldValue){
			paymentDailyDataGrid.datagrid('load', $.serializeObject($('#paymentDailyForm')));
		}
	});   
   
    var paymentDailyDataGrid;
    $(function() {
        paymentDailyDataGrid = $('#paymentDailyDataGrid').datagrid({
        url : '${path}/paymentDaily/queryPaymentDailyData',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        // idField : 'carId',
        pageSize : 100,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'ID',
            field : 'carId'
            // hidden : true
        },{
            title : '记账日期',
            field : 'billTime'
        },{
            title : '车号',
            field : 'carNo',
            formatter: function(value,row,index){
            	var str = '';
            	if(null != row.carId && row.carId != 'undefined'){
        			str = $.formatString('<a href="javascript:void(0)"  onclick="viewCarOutPaymentFun(\'{0}\');" >'+row.carNo+'</a>', row.carId);
            	}
                return str;
            }
        } ] ],
        columns : [ [ {
            title : '出车单号',
            field : 'outStockNo'
        },{
            title : '货位号',
            field : 'goodsStoreNo'
        },{
            title : '合同号',
            field : 'contractNo'
        },{
            title : '运单号',
            field : 'waybillNo'
        },{
            title : '客户名称',
            field : 'custName'
        },{
            title : '业务类型',
            field : 'chargeTypeName'
        },{
            title : '货物名称',
            field : 'goodsName'
        },{
            title : '停车天数',
            field : 'parkDays'
        },{
            title : '堆存天数',
            field : 'stockDays'
        },{
            title : '数量',
            field : 'goodsQuantity'
        },{
            title : '重量(t)',
            field : 'netWeight',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '卫生费(制卡费)',
            field : 'wsfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '管理费(过磅费)',
            field : 'glfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '停车费',
            field : 'tcfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '倒货费',
            field : 'dhfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '运抵费',
            field : 'ydfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '装卸费',
            field : 'zxfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '仓储费',
            field : 'ccfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '转关费',
            field : 'zgfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '客户优惠',
            field : 'khyhfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '其他费用',
            field : 'qtfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '应收费小计',
            field : 'sumAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '实时收费小计',
            field : 'payedAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '现金收费小计',
            field : 'cashAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '月结欠款小计',
            field : 'nonPayAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '收费类型',
            field : 'paymentMode'
        },{
            title : '收费员',
            field : 'userName'
        }] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#paymentDaily_location').combobox({readonly: 'readonly'});
        	}
        }
    });
        
    //form提交
    $('#paymentDailyForm').form({
       	url : '${path}/paymentDaily/dealPaymentDaily',
        onSubmit : function() {
        	progressLoad();
            var isValid = $(this).form('validate');
            if (!isValid) {
            	progressClose();
            }
            if($("#paymentDaily_billTimeStart").val() == '' || $("#paymentDaily_billTimeEnd").val() == ''){
            	progressClose();
            	$.messager.alert('消息','请确认记账日期！','info');
            	return false;
            }
            if($("#paymentDaily_location").combobox('getValue') == '' ){
            	progressClose();
            	$.messager.alert('消息','请选择所属区域！','info');
            	return false;
            }
            if($("#paymentDaily_dailyDate").val() == null || $("#paymentDaily_dailyDate").val() == '' ){
            	progressClose();
            	$.messager.alert('消息','请确认结转日期！','info');
            	return false;
            }
            if($('#paymentDailyDataGrid').datagrid('getRows').length <= 0 ){
            	progressClose();
            	$.messager.alert('消息','该日期区间无数据！','info');
            	return false;
            }
            return isValid;
       	},
       	success : function(result) {
            progressClose();
            result = $.parseJSON(result);
            if (result.success) {
                $.messager.alert('消息',result.msg,'info');
                $('#paymentDaily_dailyDate').val('');
                paymentDailyDataGrid.datagrid('load', $.serializeObject($('#paymentDailyForm')));
             } else {
                $.messager.alert('错误',result.msg,'warning');
             }
     	}
  	});
});
    
/**
  * 查看出库付款单
  * @param id
*/
function viewCarOutPaymentFun(id) {
    parent.$.modalDialog({
        title : '查看明细',
        width : 750,
        height : 500,
        href :  '${path}/carInfo/viewCarOutPayPage?id=' + id
    });
}

/**
  * 查看结转历史记录
*/
function paymentDailyHistoryFun() {
    parent.$.modalDialog({
        title : '结转历史记录',
        width : 700,
        height : 500,
        href : '${path}/paymentDaily/paymentDailyHistoryPage',
        buttons : [ {
            text : '关闭',
            handler : function() {
            	parent.$.modalDialog.handler.dialog('close')
            }
        } ]
    });
}

/**
 * 清除
 */
function paymentDailyCleanFun() {
    $('#paymentDailyForm input').val('');
    $('#paymentDaily_billTimeStart').val('${billTimeStart}');//默认为当天
	$('#paymentDaily_billTimeEnd').val('${billTimeEnd}');
	$('#paymentDaily_location').val('${location}');
    paymentDailyDataGrid.datagrid('load', $.serializeObject($('#paymentDailyForm')));
}
/**
 * 搜索
 */
function paymentDailySearchFun() {
     paymentDailyDataGrid.datagrid('load', $.serializeObject($('#paymentDailyForm')));
}

/**
 * 确认结转
 */
function doPaymentDaily() {
	$('#paymentDailyForm').submit();
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 65px; overflow: hidden;background-color: #fff">
        <form id="paymentDailyForm">
            <table>
                <tr>
                	<td><font color="red">*</font>所属区域:
                    <select id="paymentDaily_location" name="location" style="width: 60px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                            车牌号:
                    <input name="carNo" style="width: 60px;" />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <font color="red">*</font> 记账日期:
                	<input id="paymentDaily_billTimeStart" name="billTimeStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 115px;" readonly="readonly" value="${billTimeStart}" />
                	&nbsp;-&nbsp;
                	<input id="paymentDaily_billTimeEnd" name="billTimeEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 115px;" readonly="readonly" value="${billTimeEnd}" />
                	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="paymentDailySearchFun();">查询</a>
                    <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="paymentDailyCleanFun();">清空</a>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:void(0);" class="easyui-linkbutton" onclick="paymentDailyHistoryFun();">查看结转记录</a>
                 </td>   	
                </tr>
                <tr>
                	<shiro:hasPermission name="/paymentDaily/dealPaymentDaily">
                	<td><font color="red">*</font>结转日期:
                	<input id="paymentDaily_dailyDate" name="dailyDate"  onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 85px;" readonly="readonly" />
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-clock',plain:true" onclick="javascript:doPaymentDaily();">确认结转</a>
                	</shiro:hasPermission>	
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="paymentDailyDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
