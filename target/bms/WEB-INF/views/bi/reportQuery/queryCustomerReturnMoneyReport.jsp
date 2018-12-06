<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">

    var customerReturnMoneyDataGrid;
    $(function() {
        customerReturnMoneyDataGrid = $('#customerReturnMoneyDataGrid').datagrid({
        url : '${path}/reportQuery/queryCustomerReturnMoneyList',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        // idField : 'out_time',
        // sortName : 'out_time',
        // sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        rowStyler : function(index,row){
        	if(row.leftDays >=5 && row.leftDays <=10 && row.balanceAmount > 0){ //回款截止日期前5-10天
        		return 'background-color:#32CD32;';
        	}
        	if(row.leftDays >=0 && row.leftDays <=4 && row.balanceAmount > 0){ //回款截止日期前0-4天
        		return 'background-color:#FFFF00;';
        	}
        	if(row.leftDays < 0 && row.balanceAmount > 0){ //逾期
        		return 'background-color:#FF0000;';
        	}
        },
        columns : [ [ {
            title : '客户名称',
            field : 'customerName'
        },{
            title : '回款截止日期',
            field : 'lastDate'
        },{
            title : '月结金额',
            field : 'nonPayAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '已回款金额',
            field : 'backAmount',
            formatter: function(value,row,index){
            	var str = '';
            	if(null != row){
            		str = (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            		if(value > 0 && typeof(row.customerId) != 'undefined'){
            			str = $.formatString('<a href="javascript:void(0)"  onclick="viewReturnMoneyDetailList(\'{0}\',\'{1}\',\'{2}\');" >'+str+'</a>', row.customerId,row.customerName,row.paymentMonth);
            		}
            	}
            	return str;
            }
        },{
            title : '欠款金额',
            field : 'balanceAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '超期回款金额',
            field : 'overAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        }] ],
        onLoadSuccess:function(data){
        	
        },
        toolbar : '#customerReturnMoneyToolbar'
    });
        
    //form提交
    $('#customerReturnMoneySearchForm').form({
       	url : '${path}/reportQuery/exportCustomerReturnMoney',
        onSubmit : function() {
        	// progressLoad();
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
             } else {
                $.messager.alert('错误',result.msg,'warning');
             }
     	}
  	});
});

//客户回款明细
function viewReturnMoneyDetailList(customerId,customerName,paymentMonth){
	 parent.$.modalDialog({
	        title : '查看回款明细',
	        width : 750,
	        height : 500,
	        href :  '${path}/accountDetail/viewReturnMoneyDetailList?customerId=' + customerId +'&customerName='+customerName +'&paymentMonth='+paymentMonth
	    });
}

/**
 * 导出excel
 * @param url
 */
function exportcustomerReturnMoneyFun() {
	$('#customerReturnMoneySearchForm').submit();
}

/**
 * 清除
 */
function customerReturnMoneyCleanFun() {
    $('#customerReturnMoneySearchForm input').val('');
    $('#customerReturnMoney_paymentMonth').val('${paymentMonth}');//默认为当月
    customerReturnMoneyDataGrid.datagrid('load', $.serializeObject($('#customerReturnMoneySearchForm')));
}
/**
 * 搜索
 */
function customerReturnMoneySearchFun() {
     customerReturnMoneyDataGrid.datagrid('load', $.serializeObject($('#customerReturnMoneySearchForm')));
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="customerReturnMoneySearchForm">
            <table>
                <tr>
                	<td>客户名称:</td>
                    <td><input name="custName" placeholder="" style="width: 100px;"/>
                    &nbsp;&nbsp;                                   
                    </td>
                    <td>回款月份:</td>
                	<td>
                		<input id="customerReturnMoney_paymentMonth" name="paymentMonth"  onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM'})" style="width: 60px;" readonly="readonly" value="${paymentMonth}" />
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="customerReturnMoneySearchFun();">查询</a>
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="customerReturnMoneyCleanFun();">清空</a>
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="customerReturnMoneyDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="customerReturnMoneyToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/customerReturnMoneyExport">
        <a onclick="exportcustomerReturnMoneyFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
    <div align="left">
    	<table width="300" cellspacing="3" style="font-size:14px;border-collapse:collapse" cellspacing="0" cellpadding="0" border="0" bordercolor="#cccccc">
    		<tbody>
    			<tr>
    				<td bgcolor="#32CD32" height="10" width="15"></td>
    				<td>回款日期前5-10天</td>
    				<td bgcolor="#FFFF00" height="10" width="15"></td>
    				<td>回款日期前0-4天</td>
    				<td bgcolor="#FF0000" height="10" width="15"></td>
    				<td>逾期</td>
    			</tr>
    		</tbody>
    	</table>
    </div>
</div>