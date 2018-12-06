<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var accountDetailDataGrid;
    $(function() {
        accountDetailDataGrid = $('#accountDetailDataGrid').datagrid({
        url : '${path}/accountDetail/dataGrid',
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
        },{
            field : 'action',
            title : '操作',
            width : 200,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/accountDetail/edit">
            		str += $.formatString('<a href="javascript:void(0)" class="accountDetail-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="accountDetailEditFun(\'{0}\');" >编辑</a>', row.id);
        		</shiro:hasPermission>
        		<shiro:hasPermission name="/accountDetail/delete">
            		str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
            		str += $.formatString('<a href="javascript:void(0)" class="accountDetail-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="accountDetailDeleteFun(\'{0}\');" >删除</a>', row.id);
        		</shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
            $('.accountDetail-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.accountDetail-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#accountDetailToolbar'
    });
});

/**
 * 添加框
 * @param url
 */
function accountDetailAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 400,
        height : 320,
        href : '${path}/accountDetail/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = accountDetailDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#accountDetailAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function accountDetailEditFun(id) {
    if (id == undefined) {
        var rows = accountDetailDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        accountDetailDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '编辑',
        width : 400,
        height : 320,
        href :  '${path}/accountDetail/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = accountDetailDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#accountDetailEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function accountDetailDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = accountDetailDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         accountDetailDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前回款明细？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/accountDetail/delete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     accountDetailDataGrid.datagrid('reload');
                 }else{
                	 parent.$.messager.alert('警告', result.msg, 'warning');
                 }
                 progressClose();
             }, 'JSON');
         }
     });
}


/**
 * 清除
 */
function accountDetailCleanFun() {
    $('#accountDetailSearchForm input').val('');
    accountDetailDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function accountDetailSearchFun() {
     accountDetailDataGrid.datagrid('load', $.serializeObject($('#accountDetailSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="accountDetailSearchForm">
            <table>
                <tr>
                    <td>客户名称</td>
                    <td>
                    	<input name="customerName" placeholder="请输入客户名称" style="width: 100px;"/>
                    &nbsp;&nbsp;
                                                             回款月份&nbsp;&nbsp;
                    <input name="paymentMonth" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM'})" style="width: 80px;" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="accountDetailSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="accountDetailCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="accountDetailDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="accountDetailToolbar" style="display: none;">
    <shiro:hasPermission name="/accountDetail/add">
        <a onclick="accountDetailAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>