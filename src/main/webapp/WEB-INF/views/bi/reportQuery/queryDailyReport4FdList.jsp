<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var dailyReport4FdDataGrid;
    $(function() {
        dailyReport4FdDataGrid = $('#dailyReport4FdDataGrid').datagrid({
        url : '${path}/reportQuery/queryDailyReport4FdList',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        idField : 'outCarId',
        // sortName : 'out_time',
        // sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'outCarId',
            field : 'outCarId',
            sortable : true,
            hidden : true
        } ] ],
        columns : [ [ {
            title : '进库日期',
            field : 'inTime'
        },{
            title : '进库车号',
            field : 'inCarNo'
        },{
            title : '合同号',
            field : 'contractNo'
        },{
            title : '运单号',
            field : 'waybillNo'
        },{
            title : '货物名称',
            field : 'goodsName'
        },{
            title : '件数/包',
            field : 'goodsQuantity'
        },{
            title : '重量/吨',
            field : 'netWeight',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '货位号',
            field : 'goodsStoreNo'
        },{
            title : '出库车号',
            field : 'outCarNo',
            formatter: function(value,row,index){
            	var str = '';
            	if(null != row.outCarId && row.outCarId != 'undefined'){
        			str = $.formatString('<a href="javascript:void(0)"  onclick="viewCarOutPaymentFun(\'{0}\');" >'+row.outCarNo+'</a>', row.outCarId);
            	}
                return str;
            }
        },{
            title : '记账日期',
            field : 'dailyDate'
        },{
            title : '公司名称',
            field : 'custName'
        },{
            title : '仓储费',
            field : 'ccfAmount',
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
        	
        },
        toolbar : '#dailyReport4FdToolbar'
    });
        
    //form提交
    $('#dailyReport4FdSearchForm').form({
       	url : '${path}/reportQuery/exportDailyReport4Fd',
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

    
/**
 * 查看出库付款单
 * @param url
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
 * 导出excel
 * @param url
 */
function exportDailyReport4FdFun() {
	$('#dailyReport4FdSearchForm').submit();
}

/**
 * 清除
 */
function dailyReport4FdCleanFun() {
    $('#dailyReport4FdSearchForm input').val('');
    $('#dailyReport4Fd_dailyDateStart').val('${dailyDateStart}');//默认为当天
	$('#dailyReport4Fd_dailyDateEnd').val('${dailyDateEnd}');
    dailyReport4FdDataGrid.datagrid('load', $.serializeObject($('#dailyReport4FdSearchForm')));
}
/**
 * 搜索
 */
function dailyReport4FdSearchFun() {
     dailyReport4FdDataGrid.datagrid('load', $.serializeObject($('#dailyReport4FdSearchForm')));
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="dailyReport4FdSearchForm">
            <table>
                <tr>
                	<td>客户名称:</td>
                    <td><input name="custName" placeholder="" style="width: 110px;"/>
                    &nbsp;&nbsp;&nbsp;
                    <td>记账日期:</td>
                	<td>
                		<input id="dailyReport4Fd_dailyDateStart" name="dailyDateStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" value="${dailyDateStart}" />
                		&nbsp;-&nbsp;
                		<input id="dailyReport4Fd_dailyDateEnd" name="dailyDateEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" value="${dailyDateEnd}" />
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="dailyReport4FdSearchFun();">查询</a>
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="dailyReport4FdCleanFun();">清空</a>
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="dailyReport4FdDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="dailyReport4FdToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/dailyReport4FdExport">
        <a onclick="exportDailyReport4FdFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>