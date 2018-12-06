<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var custAccountDetailReportQueryDataGrid;
    $(function() {
        custAccountDetailReportQueryDataGrid = $('#custAccountDetailReportQueryDataGrid').datagrid({
        url : '${path}/reportQuery/queryCustAccountDetailReport?custId='+'${custId}'+'&recordTimeStart='+'${recordTimeStart}'+'&recordTimeEnd='+'${recordTimeEnd}',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'id',
        sortOrder : 'desc',
        pageSize : 20,
        pageList : [10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
        	width : '40',
            title : 'id',
            field : 'id',
            sortable : true,
            hidden : true
        } ] ],
        columns : [ [ {
            width : '140',
            title : '客户名称',
            field : 'custName'
        }, {
        	width : '100',
            title : '金额',
            field : 'amount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
         
        },{
        	width : '100',
            title : '记账日期',
            field : 'record_time'
        },{
        	width : '100',
            title : '付款方式',
            field : 'paymentMode'
            
        },{
        	width : '100',
            title : '操作人',
            field : 'createUserName'
            
        },{
        	width : '140',
            title : '备注',
            field : 'remark'
            
        }] ],
        onLoadSuccess:function(data){
        	
        },
        toolbar : '#custAccountDetailReportQueryToolbar'
    });
        
    //form提交
    $('#custAccountDetailReportQuerySearchForm').form({
       	url : '${path}/reportQuery/exportCustAccountDetailReport',
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
 * 导出excel
 * @param url
 */
function exportCustAccountDetailReportFun() {
	$('#custAccountDetailReportQuerySearchForm').submit();
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 50px; overflow: hidden;background-color: #fff">
        <form id="custAccountDetailReportQuerySearchForm">
            <table>
                <tr>
                	<td>客户名称:</td>
                    <td><input name="custName" placeholder="" style="width: 110px;" value="${custName}" readonly="readonly"/>
                    	<input name="custId" type="hidden" value="${custId}">
                    </td>
                    &nbsp;&nbsp;&nbsp;
                    <td>记账日期:</td>
                	<td>
                		<input name="recordTimeStart" style="width: 110px;" value="${recordTimeStart}" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="recordTimeEnd"  style="width: 110px;" value="${recordTimeEnd}" readonly="readonly" />
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="custAccountDetailReportQueryDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="custAccountDetailReportQueryToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/custAccountDetailReportExport">
        <a onclick="exportCustAccountDetailReportFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>