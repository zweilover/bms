<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var storeInfoListDataGrid;
    $(function() {
    	//所属区域下拉选项
    	$('#storeInfoList_location').combobox({
    		url : '${path}/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}',
    	});
    	
        storeInfoListDataGrid = $('#storeInfoListDataGrid').datagrid({
        url : '${path}/store/storeInfoList',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'name',
       	sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'ID',
            field : 'id'
        }] ], 
        columns : [ [{
            title : '库房名称',
            field : 'name',
            sortable : true
        },{
            title : '所属区域',
            field : 'location'
        },{
            title : '状态',
            field : 'status',
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
        },{
            title : '排序',
            field : 'seq'
        },{
            title : '备注',
            field : 'remark'
        },{
            title : '创建人',
            field : 'createUser'
        },{
            title : '创建时间',
            field : 'createTime'
        },{
            title : '最后更新人',
            field : 'updateUser'
        },{
            title : '最后更新时间',
            field : 'updateTime'
        },{
            field : 'action',
            title : '操作',
            width : 200,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/store/storeInfoEdit">
                    str += $.formatString('<a href="javascript:void(0)" class="storeInfoList-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="storeInfoListEditFun(\'{0}\');" >编辑</a>', row.id);
                </shiro:hasPermission>
                <shiro:hasPermission name="/store/storeInfoDelete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="storeInfoList-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="storeInfoListDeleteFun(\'{0}\');" >删除</a>', row.id);
                </shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#storeInfoList_location').combobox({readonly: 'readonly'});
        	}
        	
            $('.storeInfoList-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.storeInfoList-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#storeInfoListToolbar'
    });
        
      
    
});

/**
 * 添加框
 * @param url
 */
function storeInfoListAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 500,
        height : 300,
        href : '${path}/store/storeInfoAddPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = storeInfoListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#storeInfoAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function storeInfoListEditFun(id) {
    if (id == undefined) {
        var rows = storeInfoListDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        storeInfoListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    parent.$.modalDialog({
        title : '编辑',
        width : 500,
        height : 300,
        href :  '${path}/store/storeInfoEditPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = storeInfoListDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#storeInfoEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function storeInfoListDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = storeInfoListDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         storeInfoListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前库房信息？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/store/storeInfoDelete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     storeInfoListDataGrid.datagrid('reload');
                 }
                 progressClose();
             }, 'JSON');
         }
     });
}


/**
 * 清除
 */
function storeInfoListCleanFun() {
    $('#storeInfoListSearchForm input').val('');
    $('#storeInfoList_location').combobox("setValue",'');
    storeInfoListDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function storeInfoListSearchFun() {
     storeInfoListDataGrid.datagrid('load', $.serializeObject($('#storeInfoListSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="storeInfoListSearchForm">
            <table>
                <tr>
                    <th>库房名称:</th>
                    <td><input name="name" placeholder="搜索条件" style="width: 100px;" />
                                                                        所属区域&nbsp;&nbsp;
                        <select id="storeInfoList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	    &nbsp;&nbsp;
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="storeInfoListSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="storeInfoListCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="storeInfoListDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="storeInfoListToolbar" style="display: none;">
    <shiro:hasPermission name="/store/storeInfoAdd">
        <a onclick="storeInfoListAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>