<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var returnMoneyDetailDataGrid;
    $(function() {
        returnMoneyDetailDataGrid = $('#returnMoneyDetailDataGrid').datagrid({
        url : '${path}/accountDetail/dataGrid?customerId='+'${customerId}'+'&paymentMonth='+ '${paymentMonth}',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'id',
        sortOrder : 'desc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'ID',
            field : 'id',
            hidden : true
        }]], 
        columns :[[{
            title : '客户名称',
            field : 'customerName'
        },{
            title : '回款金额',
            field : 'amount'
        },{
            title : '回款日期',
            field : 'recordTime'
        },{
        	title : '回款月份',
            field : 'paymentMonth'
        },{
            title : '付款类型',
            field : 'paymentModeName'
        },{
            title : '备注',
            field : 'remark'
        },{
            title : '操作人',
            field : 'createUserName'
        },{
            title : '操作日期',
            field : 'createTime'
        } ] ],
        onLoadSuccess:function(data){
           
        }
    });
});


/**
 * 搜索
 */
function returnMoneyDetailSearchFun() {
     returnMoneyDetailDataGrid.datagrid('load', $.serializeObject($('#returnMoneyDetailSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="returnMoneyDetailSearchForm">
            <table>
                <tr>
                    <td>客户名称</td>
                    <td>
                    	<input name="customerName" placeholder="请输入客户名称" style="width: 100px;" readonly="readonly" value="${customerName}"/>
                    &nbsp;&nbsp;
                                                             回款月份&nbsp;&nbsp;
                    <input name="paymentMonth"  readonly="readonly" style="width: 80px;" value="${paymentMonth}" />
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="returnMoneyDetailDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
