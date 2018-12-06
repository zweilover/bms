<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#carInfoList_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});   

    var carInfoDataGrid;
    $(function() {
        carInfoDataGrid = $('#carInfoDataGrid').datagrid({
        url : '${path}/carInfo/dataGrid',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'in_time',
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
            title : '是否年卡',
            field : 'isYearCard',
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
        }, {
            title : '所属区域',
            field : 'locationName'
        },{
            title : '入库时间',
            field : 'inTime'
        },{
            title : '入库办理人',
            field : 'inUserName'
        },{
            title : '入库说明',
            field : 'inRemark'
        },{
            title : '出库时间',
            field : 'outTime'
        },{
            title : '出库办理人',
            field : 'outUserName'
        },{
            title : '出库说明',
            field : 'outRemark'
        },{
            title : '车辆状态',
            field : 'carStatus',
            formatter : function(value, row, index) {
                switch (value) {
                case '0':
                    return '已入库';
                case '1':
                    return '已出库';
                case '2':
                	return '已删除';
                default :
                	return value;
                }
                
            }
        },{
            field : 'action',
            title : '操作',
            width : 150,
            formatter : function(value, row, index) {
                var str = '';
                if(row.carStatus == '0'){//只有已入库状态才允许操作
                	<shiro:hasPermission name="/carInfo/edit">
                    	str += $.formatString('<a href="javascript:void(0)" class="carInfo-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="carInfoEditFun(\'{0}\');" >编辑</a>', row.id);
                	</shiro:hasPermission>
                	<shiro:hasPermission name="/carInfo/delete">
                    	str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                    	str += $.formatString('<a href="javascript:void(0)" class="carInfo-easyui-linkbutton-del" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="carInfoDeleteFun(\'{0}\');" >删除</a>', row.id);
                	</shiro:hasPermission>
                }
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#carInfoList_location').combobox({readonly: 'readonly'});
        	}
        	
            $('.carInfo-easyui-linkbutton-edit').linkbutton({text:'编辑'});
            $('.carInfo-easyui-linkbutton-del').linkbutton({text:'删除'});
        },
        toolbar : '#carInfoToolbar'
    });
        
    readCard4CarInfoList();//页面加载初始化读卡器
});

/**
 * 添加框
 * @param url
 */
function carInfoAddFun() {
    parent.$.modalDialog({
        title : '添加',
        width : 400,
        height : 300,
        href : '${path}/carInfo/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = carInfoDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#carInfoAddForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 编辑
 */
function carInfoEditFun(id) {
    if (id == undefined) {
        var rows = carInfoDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        carInfoDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '编辑',
        width : 400,
        height : 300,
        href :  '${path}/carInfo/editPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = carInfoDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#carInfoEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 删除
 */
 function carInfoDeleteFun(id) {
     if (id == undefined) {//点击右键菜单才会触发这个
         var rows = carInfoDataGrid.datagrid('getSelections');
         id = rows[0].id;
     } else {//点击操作里面的删除图标会触发这个
         carInfoDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
     }
     parent.$.messager.confirm('询问', '您是否要删除当前登记车辆？', function(b) {
         if (b) {
             progressLoad();
             $.post('${path}/carInfo/delete', {
                 id : id
             }, function(result) {
                 if (result.success) {
                     parent.$.messager.alert('提示', result.msg, 'info');
                     carInfoDataGrid.datagrid('reload');
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
function carInfoCleanFun() {
    $('#carInfoSearchForm input').val('');
    $('#carInfoList_carStatus').combobox('setValue',"");//清空车辆状态
    $('#carInfoList_location').combobox('setValue','');//所属区域
    carInfoDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function carInfoSearchFun() {
     carInfoDataGrid.datagrid('load', $.serializeObject($('#carInfoSearchForm')));
}

//读卡器初始化
function readCard4CarInfoList(){
	tcom.init(tcom.COMOBJ);
	tcom.COMOBJ.OnDataIn = function (dat){
		if(null != dat.data && dat.data != ""){
			$("#carInfoList_cardNo").val(dat.data);
			// tcommClose();//关闭串口
			carInfoDataGrid.datagrid('load', $.serializeObject($('#carInfoSearchForm')));
		}
	};
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="carInfoSearchForm">
            <table>
                <tr>
                    <td>车牌号:</td>
                    <td><input name="carNo" placeholder="请输入车牌号" style="width: 80px;"/>
                    &nbsp;&nbsp;
                                                            所属区域&nbsp;&nbsp;
                    <select id="carInfoList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;车辆状态:</td>
                    <td>
                    	<select id="carInfoList_carStatus" name="carStatus" class="easyui-combobox" style="width: 80px;" data-options="width:100,panelHeight:'auto',editable:false">
                			<option value="">-- 全部 --</option>
                			<option value="0">已入库</option>
                			<option value="1">已出库</option>
                		</select>
                		&nbsp;&nbsp;
                                                                      运通卡号:&nbsp;&nbsp;
                    	<input id="carInfoList_cardNo" name="cardNo" style="width: 80px;" readonly="readonly" />
                		&nbsp;&nbsp;
                   		<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4CarInfoList()">读卡</a>
                    </td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <td>
                    	&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="carInfoSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="carInfoCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="carInfoDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="carInfoToolbar" style="display: none;">
    <shiro:hasPermission name="/carInfo/add">
        <a onclick="carInfoAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">制卡</a>
    </shiro:hasPermission>
</div>