<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var selectCustomerDataGrid;
    $(function() {
        selectCustomerDataGrid = $('#selectCustomerDataGrid').datagrid({
        url : '${path}/bigCustomer/dataGrid',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'seq',
        sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        columns : [ [{
            width : '30',
            title : 'ID',
            field : 'id',
            hidden : true,
            sortable : true
        },{
        	width : '120',
            title : '客户名称',
            field : 'name',
            sortable : true
        },{
        	width : '120',
            title : '联系方式',
            field : 'telephone',
            hidden : true
        },{
        	width : '100',
            title : '是否支持月结',
            field : 'isCredit',
            formatter : function(value, row, index) {
                switch (value) {
                case '0':
                    return '是';
                case '1':
                    return '否';
                 default :
                	 return value;
                }
            }
            
        },{
        	width : '40',
            title : '排序',
            field : 'seq'
        },{
        	width : '80',
            title : '状态',
            field : 'status',
            sortable : true,
            formatter : function(value, row, index) {
                switch (value) {
                case '0':
                    return '正常';
                case '1':
                    return '停用';
                 default :
                	 return value;
                }
            }
        }, {
            width : '140',
            title : '创建时间',
            field : 'createTime'
        } ] ],
        onLoadSuccess:function(data){
           
        },
        onDblClickRow:function(index,row){
        	window.parent.selectCustomerCallback(row);//父窗体的回调函数
        	$('#selectBigCustomer').window('close');//
        }
    });
});

/**
 * 清除
 */
function bigCustomerCleanFun() {
    $('#bigCustomerSelectForm input').val('');
    selectCustomerDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function bigCustomerSearchFun() {
     selectCustomerDataGrid.datagrid('load', $.serializeObject($('#bigCustomerSelectForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="bigCustomerSelectForm">
            <table>
                <tr>
                    <th>客户名称:</th>
                    <td><input name="name" placeholder="搜索条件"/></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="bigCustomerSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="bigCustomerCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="selectCustomerDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
