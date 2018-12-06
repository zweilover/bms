<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var chargeItemDataGrid;
    $(function() {
        chargeItemDataGrid = $('#chargeItemDataGrid').datagrid({
        url : '${path}/chargeItem/dataGrid',
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
            width : '200',
            title : '子项名称',
            field : 'name'
        },{
            width : '60',
            title : '费用类型',
            field : 'typeName'
        },{
            width : '60',
            title : '所属区域',
            field : 'locationName'
        },{
            width : '40',
            title : '排序',
            field : 'seq',
            sortable : true,
            hidden : true
        }, {
        	 width : '60',
             title : '下限值',
             field : 'minValue'
        },{
        	 width : '60',
             title : '上限值',
             field : 'maxValue'
        },{
        	width : '60',
            title : '价格',
            field : 'cost'
        },{
        	width : '80',
            title : '计费参数',
            field : 'itemParamName'
        },{
        	width : '80',
            title : 'js脚本参数',
            field : 'scriptParamName'
        },{
        	width : '200',
            title : 'js脚本',
            field : 'scriptStr',
            hidden : true
        },{
        	width : '300',
            title : '描述',
            field : 'remark' 
        },{
        	width : '130',
            title : '创建时间',
            field : 'createTime'
        },{
        	width : '60',
            title : '状态',
            field : 'status',
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
        },{
            field : 'action',
            title : '操作',
            width : 200,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/chargeItem/edit">
                    str += $.formatString('<a href="javascript:void(0)" class="chargeItem-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="chargeItemEditFun(\'{0}\');" >编辑</a>', row.id);
                </shiro:hasPermission>
                <shiro:hasPermission name="/chargeItem/delete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="chargeItem-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="chargeItemDeleteFun(\'{0}\');" >删除</a>', row.id);
                </shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
            $('.chargeItem-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.chargeItem-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#chargeItemToolbar'
    });
});

/**
 * 添加框
 * @param url
 */
function chargeItemAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 600,
        height : 400,
        href : '${path}/chargeItem/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = chargeItemDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#chargeItemAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function chargeItemEditFun(id) {
    if (id == undefined) {
        var rows = chargeItemDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        chargeItemDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    parent.$.modalDialog({
        title : '编辑',
        width : 600,
        height : 400,
        href :  '${path}/chargeItem/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = chargeItemDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#chargeItemEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function chargeItemDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = chargeItemDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         chargeItemDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前计费子项？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/chargeItem/delete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     chargeItemDataGrid.datagrid('reload');
                 }
                 progressClose();
             }, 'JSON');
         }
     });
}


/**
 * 清除
 */
function chargeItemCleanFun() {
    $('#chargeItemSearchForm input').val('');
    chargeItemDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function chargeItemSearchFun() {
     chargeItemDataGrid.datagrid('load', $.serializeObject($('#chargeItemSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="chargeItemSearchForm">
            <table>
                <tr>
                    <th>子项名称:</th>
                    <td><input name="name" placeholder="搜索条件" style="width: 100px;"/></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="chargeItemSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="chargeItemCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false" style="overflow: hidden;">
        <table id="chargeItemDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="chargeItemToolbar" style="display: none;">
    <shiro:hasPermission name="/chargeItem/add">
        <a onclick="chargeItemAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>