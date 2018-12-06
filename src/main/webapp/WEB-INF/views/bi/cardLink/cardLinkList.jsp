<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var cardLinkListDataGrid;
    $(function() {
        cardLinkListDataGrid = $('#cardLinkListDataGrid').datagrid({
        url : '${path}/cardLink/dataGrid',
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
            field : 'id'
            // sortable : true
        }]], 
        columns :[[{
            title : '车牌号',
            field : 'carNo'
        },{
            title : '运通卡号',
            field : 'cardNo'
        },{
            title : '备注',
            field : 'remark'
        },{
            title : '创建日期',
            field : 'createTime'
        },{
            title : '创建人',
            field : 'createUser'
        },{
            title : '最后更新日期',
            field : 'updateTime'
        },{
            title : '最后更新人',
            field : 'updateUser'
        },{
            field : 'action',
            title : '操作',
            width : 200,
            formatter : function(value, row, index) {
                var str = '';
                <shiro:hasPermission name="/cardLink/edit">
            		str += $.formatString('<a href="javascript:void(0)" class="cardLinkList-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="cardLinkListEditFun(\'{0}\');" >编辑</a>', row.id);
        		</shiro:hasPermission>
        		<shiro:hasPermission name="/cardLink/delete">
            		str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
            		str += $.formatString('<a href="javascript:void(0)" class="cardLinkList-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="cardLinkListDeleteFun(\'{0}\');" >删除</a>', row.id);
        		</shiro:hasPermission>
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
            $('.cardLinkList-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.cardLinkList-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#cardLinkListToolbar'
    });
        
    readCard4CardLinkList(); //页面加载初始化读卡器
});

/**
 * 添加框
 * @param url
 */
function cardLinkListAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 400,
        height : 300,
        href : '${path}/cardLink/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = cardLinkListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#cardLinkAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function cardLinkListEditFun(id) {
    if (id == undefined) {
        var rows = cardLinkListDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        cardLinkListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '编辑',
        width : 400,
        height : 300,
        href :  '${path}/cardLink/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = cardLinkListDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#cardLinkEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function cardLinkListDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = cardLinkListDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         cardLinkListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前登记车辆？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/cardLink/delete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     cardLinkListDataGrid.datagrid('reload');
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
function cardLinkListCleanFun() {
    $('#cardLinkListSearchForm input').val('');
    $('#cardLinkList_carStatus').combobox('setValue',"");//清空车辆状态
    cardLinkListDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function cardLinkListSearchFun() {
     cardLinkListDataGrid.datagrid('load', $.serializeObject($('#cardLinkListSearchForm')));
}

//运通卡查询列表 - ID读卡器串口读取
function readCard4CardLinkList(){
	tcom.init(tcom.COMOBJ);
	tcom.COMOBJ.OnDataIn = function (dat){
		if(null != dat.data && dat.data != ""){
			$("#cardLinkList_cardNo").val(dat.data);
			// tcommClose();//关闭串口
			cardLinkListDataGrid.datagrid('load', $.serializeObject($('#cardLinkListSearchForm')));
		}
	};
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="cardLinkListSearchForm">
            <table>
                <tr>
                    <td>车牌号:</td>
                    <td><input name="carNo" style="width: 100px;"/>
                    &nbsp;&nbsp;
                                                            运通卡号&nbsp;&nbsp;
                    <input id="cardLinkList_cardNo" name="cardNo" style="width: 80px;" readonly="readonly" />
                   	&nbsp;&nbsp;
                   	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4CardLinkList()">读卡</a>
                    </td>
                    <td>
                    	&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="cardLinkListSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="cardLinkListCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="cardLinkListDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="cardLinkListToolbar" style="display: none;">
    <shiro:hasPermission name="/cardLink/add">
        <a onclick="cardLinkListAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    </shiro:hasPermission>
</div>