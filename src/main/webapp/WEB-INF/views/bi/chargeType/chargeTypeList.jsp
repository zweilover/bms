<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var chargeTypeDataGrid;
    $(function() {
        chargeTypeDataGrid = $('#chargeTypeDataGrid').datagrid({
        url : '${path}/chargeType/dataGrid',
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
        	width : '40',
            title : 'ID',
            field : 'id',
            sortable : true,
            hidden : true
        } ] ],
        columns : [ [ {
            width : '120',
            title : '计费项目名称',
            field : 'name'
        }, {
        	width : '80',
            title : '所属区域',
            field : 'locationName'
        },{
        	width : '40',
            title : '排序',
            field : 'seq',
            sortable : true,
            hidden : true
        },{
            width : '60',
            title : '状态',
            field : 'status',
            sortable : true,
            formatter : function(value, row, index) {
            	 if (value == '0') {
                     return '正常';
                 } else if(value == '1'){
                     return '停用';
                 }else if(value == '2'){
                 	return '删除';
                 }else {
                 	return '未知状态';
                 }
            }
        }, {
        	 width : '140',
             title : '计费项目描述',
             field : 'description'
        },{
            width : '140',
            title : '创建时间',
            field : 'createTime'
        }, {
        	 width : '140',
             title : '最后更新时间',
             field : 'updateTime'
        },{
            field : 'action',
            title : '操作',
            width : 300,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/chargeType/grant">
                    str += $.formatString('<a href="javascript:void(0)" class="chargeType-easyui-linkbutton-ok" data-options="plain:true,iconCls:\'fi-widget icon-green\'" onclick="grantChargeItemFun(\'{0}\',\'{1}\');" >设置子项</a>', row.id,row.location);
                </shiro:hasPermission>
                <shiro:hasPermission name="/chargeType/viewItems">
                    str += $.formatString('<a href="javascript:void(0)" class="chargeType-easyui-linkbutton-view" data-options="plain:true,iconCls:\'fi-eye icon-blue\'" onclick="viewChargeItemFun(\'{0}\',\'{1}\');" >查看子项</a>', row.id,row.location);
                </shiro:hasPermission>
                <shiro:hasPermission name="/chargeType/edit">
                    str += $.formatString('<a href="javascript:void(0)" class="chargeType-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="chargeTypeEditFun(\'{0}\');" >编辑</a>', row.id);
                </shiro:hasPermission>
                <shiro:hasPermission name="/chargeType/delete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="chargeType-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="chargeTypeDeleteFun(\'{0}\');" >删除</a>', row.id);
                </shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
            $('.chargeType-easyui-linkbutton-ok').linkbutton({text:'设置子项'});
            $('.chargeType-easyui-linkbutton-view').linkbutton({text:'查看子项'});
            $('.chargeType-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.chargeType-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#chargeTypeToolbar'
    });
});

/**
 * 添加框
 * @param url
 */
function chargeTypeAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 600,
        height : 300,
        href : '${path}/chargeType/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = chargeTypeDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#chargeTypeAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function chargeTypeEditFun(id) {
    if (id == undefined) {
        var rows = chargeTypeDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        chargeTypeDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    parent.$.modalDialog({
        title : '编辑',
        width : 600,
        height : 300,
        href :  '${path}/chargeType/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = chargeTypeDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#chargeTypeEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function chargeTypeDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = chargeTypeDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         chargeTypeDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前计费项目？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/chargeType/delete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     chargeTypeDataGrid.datagrid('reload');
                 }
                 progressClose();
             }, 'JSON');
         }
     });
}


/**
 * 清除
 */
function chargeTypeCleanFun() {
    $('#chargeTypeSearchForm input').val('');
    chargeTypeDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function chargeTypeSearchFun() {
     chargeTypeDataGrid.datagrid('load', $.serializeObject($('#chargeTypeSearchForm')));
}

/**
 * 设置计费子项
 */
function grantChargeItemFun(id,location) {
    if (id == undefined) {
        var rows = chargeTypeDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
    	chargeTypeDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '设置子项',
        width : 700,
        height : 500,
        href : '${path }/chargeType/grantPage?id=' + id + '&location=' + location,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = chargeTypeDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#chargeGrantForm');
                f.submit();
            }
        } ]
    });
}

/**
 * 查看计费子项
 */
function viewChargeItemFun(id,location) {
    if (id == undefined) {
        var rows = chargeTypeDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
    	chargeTypeDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '查看子项',
        width : 700,
        height : 500,
        href : '${path }/chargeType/viewItemsPage?id=' + id + '&location=' + location,
        buttons : [ {
            text : '关闭',
            handler : function() {
                parent.$.modalDialog.handler.dialog('close');
            }
        } ]
    });
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="chargeTypeSearchForm">
            <table>
                <tr>
                    <th>计费项目名称:</th>
                    <td><input name="name" placeholder="搜索条件" style="width: 100px;"/></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="chargeTypeSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="chargeTypeCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="chargeTypeDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="chargeTypeToolbar" style="display: none;">
    <shiro:hasPermission name="/chargeType/add">
        <a onclick="chargeTypeAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>