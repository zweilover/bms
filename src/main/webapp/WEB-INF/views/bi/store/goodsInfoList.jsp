<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var goodsInfoListDataGrid;
    $(function() {
    	//所属区域下拉选项
    	$('#goodsInfoList_location').combobox({
    		url : '${path}/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}',
    	});
    	
        goodsInfoListDataGrid = $('#goodsInfoListDataGrid').datagrid({
        url : '${path}/store/goodsInfoList',
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
            title : '货物名称',
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
                <shiro:hasPermission name="/store/goodsInfoEdit">
                    str += $.formatString('<a href="javascript:void(0)" class="goodsInfoList-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="goodsInfoEditFun(\'{0}\');" >编辑</a>', row.id);
                </shiro:hasPermission>
                <shiro:hasPermission name="/store/goodsInfoDelete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="goodsInfoList-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="goodsInfoListDeleteFun(\'{0}\');" >删除</a>', row.id);
                </shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#goodsInfoList_location').combobox({readonly: 'readonly'});
        	}
        	
            $('.goodsInfoList-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.goodsInfoList-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#goodsInfoListToolbar'
    });
        
      
    
});

/**
 * 添加框
 * @param url
 */
function goodsInfoListAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 500,
        height : 300,
        href : '${path}/store/goodsInfoAddPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = goodsInfoListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#goodsInfoAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function goodsInfoEditFun(id) {
    if (id == undefined) {
        var rows = goodsInfoListDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        goodsInfoListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    parent.$.modalDialog({
        title : '编辑',
        width : 500,
        height : 300,
        href :  '${path}/store/goodsInfoEditPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = goodsInfoListDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#goodsInfoEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function goodsInfoListDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = goodsInfoListDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         goodsInfoListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前货物信息？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/store/goodsInfoDelete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     goodsInfoListDataGrid.datagrid('reload');
                 }
                 progressClose();
             }, 'JSON');
         }
     });
}


/**
 * 清除
 */
function goodsInfoListCleanFun() {
    $('#goodsInfoListSearchForm input').val('');
    $('#goodsInfoList_location').combobox("setValue",'');
    goodsInfoListDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function goodsInfoListSearchFun() {
     goodsInfoListDataGrid.datagrid('load', $.serializeObject($('#goodsInfoListSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="goodsInfoListSearchForm">
            <table>
                <tr>
                    <th>货物名称:</th>
                    <td><input name="name" placeholder="搜索条件" style="width: 100px;" />
                                                                        所属区域&nbsp;&nbsp;
                        <select id="goodsInfoList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	    &nbsp;&nbsp;
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="goodsInfoListSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="goodsInfoListCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="goodsInfoListDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="goodsInfoListToolbar" style="display: none;">
    <shiro:hasPermission name="/store/goodsInfoAdd">
        <a onclick="goodsInfoListAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>