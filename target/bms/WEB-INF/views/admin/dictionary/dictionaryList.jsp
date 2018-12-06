<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var dictionaryTreeGrid;
    $(function() {
        dictionaryTreeGrid = $('#dictionaryTreeGrid').treegrid({
        url : '${path}/dictionary/treeGrid',
        idField : 'id',
        treeField : 'name',
        parentField : 'pid',
        fit : true,
        fitColumns : false,
        border : false,
        frozenColumns : [ [ {
            field : 'id',
            title : 'ID',
            width : 40
        } ] ],
        columns : [ [ {
            field : 'name',
            title : '字典名称',
            width : 200
        }, {
            field : 'code',
            title : '字典编号',
            width : 150
        }, {
            field : 'value',
            title : '字典值',
            width : 150
        },{
            field : 'seq',
            title : '排序',
            width : 60
        }, {
            field : 'remark',
            title : '字典说明',
            width : 200
        }, {
            field : 'status',
            title : '状态',
            width : 60,
            formatter : function(value, row, index) {
                if (value == '0') {
                    return '正常';
                } else if(value == '1'){
                    return '停用';
                }else if(value == '2'){
                	return '删除';
                }
            }
        }, {
            field : 'pid',
            title : '上级字典id',
            width : 100
        }, {
            field : 'createTime',
            title : '创建日期',
            width : 120
        }, {
            field : 'action',
            title : '操作',
            width : 200,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/dictionary/edit">
                    str += $.formatString('<a href="javascript:void(0)" class="dictionary-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="dictionaryEditFun(\'{0}\');" >编辑</a>', row.id);
                </shiro:hasPermission>
                <shiro:hasPermission name="/dictionary/delete">
                    str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    str += $.formatString('<a href="javascript:void(0)" class="dictionary-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="dictionaryDeleteFun(\'{0}\');" >删除</a>', row.id);
                </shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
            $('.dictionary-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.dictionary-easyui-linkbutton-del').linkbutton({text:'删除'});
            $('#dictionaryTreeGrid').treegrid('collapseAll');  //加载成功后折叠
        },
        toolbar : '#dictionaryToolbar'
    });
});

/**
 * 添加框
 * @param url
 */
function dictionaryAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 550,
        height : 350,
        href : '${path}/dictionary/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_treeGrid = dictionaryTreeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#dictionaryAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function dictionaryEditFun(id) {
	if (id == undefined) {//点击右键菜单才会触发这个
        var rows = dictionaryTreeGrid.treegrid('getSelections');
        id = rows[0].id;
    } else {//点击操作里面的删除图标会触发这个
    	dictionaryTreeGrid.treegrid('unselectAll').treegrid('uncheckAll');
    }
	
	parent.$.modalDialog({
        title : '编辑',
        width : 550,
        height : 350,
        href : '${path }/dictionary/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_treeGrid = dictionaryTreeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#dictionaryEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function dictionaryDeleteFun(id) {
	 if (id == undefined) {//点击右键菜单才会触发这个
	 	var rows = dictionaryTreeGrid.treegrid('getSelections');
	   	id = rows[0].id;
	 } else {//点击操作里面的删除图标会触发这个
	  	dictionaryTreeGrid.treegrid('unselectAll').treegrid('uncheckAll');
	 }
	 
	 parent.$.messager.confirm('询问', '您是否要删除当前字典项？', function(b) {
		if (b) {
			progressLoad();
			$.post('${path}/dictionary/delete', {
				id : id
			}, function(result) {
				if (result.success) {
					parent.$.messager.alert('提示', result.msg, 'info');
					dictionaryTreeGrid.treegrid('reload');
					parent.indexMenuZTree.reAsyncChildNodes(null, "refresh");
				}
				progressClose();
			}, 'JSON');
		}
	});
}

	/**
	 * 清除
	 */
	function dictionaryCleanFun() {
		$('#dictionarySearchForm input').val('');
		dictionaryTreeGrid.treegrid('load', {});
	}
	/**
	 * 搜索
	 */
	function dictionarySearchFun() {
		dictionaryTreeGrid.treegrid('load', $
				.serializeObject($('#dictionarySearchForm')));
	}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="dictionarySearchForm">
            <table>
                <tr>
                    <th>字典名称:</th>
                    <td><input name="name" placeholder="请输入字典名称" style="width: 100px;"/></td>
                    <th>字典编码:</th>
                    <td><input name="code" placeholder="请输入字典编码" style="width: 100px;"/></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="dictionarySearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="dictionaryCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="dictionaryTreeGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="dictionaryToolbar" style="display: none;">
    <shiro:hasPermission name="/dictionary/add">
        <a onclick="dictionaryAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-plus icon-green'">添加</a>
    </shiro:hasPermission>
</div>