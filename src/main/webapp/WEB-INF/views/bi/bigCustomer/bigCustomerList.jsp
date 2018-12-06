<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var bigCustomerDataGrid;
    $(function() {
        bigCustomerDataGrid = $('#bigCustomerDataGrid').datagrid({
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
        frozenColumns : [ [ {
            width : '60',
            title : 'ID',
            field : 'id',
            sortable : true
        }] ], 
        columns : [ [{
        	width : '120',
            title : '客户名称',
            field : 'name',
            sortable : true
        },{
        	width : '120',
            title : '联系方式',
            field : 'telephone'
        },{
        	width : '120',
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
        	width : '100',
            title : '备注',
            field : 'remark'
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
        }, {
            field : 'action',
            title : '操作',
            width : 200,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/bigCustomer/edit">
                    str += $.formatString('<a href="javascript:void(0)" class="bigCustomer-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="bigCustomerEditFun(\'{0}\');" >编辑</a>', row.id);
                </shiro:hasPermission>
                <shiro:hasPermission name="/bigCustomer/delete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="bigCustomer-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="bigCustomerDeleteFun(\'{0}\');" >删除</a>', row.id);
                </shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
            $('.bigCustomer-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.bigCustomer-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#bigCustomerToolbar'
    });
});

/**
 * 添加框
 * @param url
 */
function bigCustomerAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 600,
        height : 350,
        href : '${path}/bigCustomer/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = bigCustomerDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#bigCustomerAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function bigCustomerEditFun(id) {
    if (id == undefined) {
        var rows = bigCustomerDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        bigCustomerDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    parent.$.modalDialog({
        title : '编辑',
        width : 600,
        height : 500,
        href :  '${path}/bigCustomer/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = bigCustomerDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#bigCustomerEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function bigCustomerDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = bigCustomerDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         bigCustomerDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前客户？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/bigCustomer/delete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     bigCustomerDataGrid.datagrid('reload');
                 }
                 progressClose();
             }, 'JSON');
         }
     });
}


/**
 * 清除
 */
function bigCustomerCleanFun() {
    $('#bigCustomerSearchForm input').val('');
    bigCustomerDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function bigCustomerSearchFun() {
     bigCustomerDataGrid.datagrid('load', $.serializeObject($('#bigCustomerSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="bigCustomerSearchForm">
            <table>
                <tr>
                    <th>客户名称:</th>
                    <td><input name="name" placeholder="搜索条件" style="width: 100px;" /></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="bigCustomerSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="bigCustomerCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="bigCustomerDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="bigCustomerToolbar" style="display: none;">
    <shiro:hasPermission name="/bigCustomer/add">
        <a onclick="bigCustomerAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>