<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#manualNetList_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});   

    var manualNetListDataGrid;
    $(function() {
        manualNetListDataGrid = $('#manualNetListDataGrid').datagrid({
        url : '${path}/carInfo/dataGrid?carStatus=0',
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
        },{
            title : '所属区域',
            field : 'locationName'
        },{
            title : '录入净重(t)',
            field : 'manualNetweight',
            formatter : function(value,row,index){
            	var str = '';
            	if(null != row && value != null && value != ''){
            		str = (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            	return str;
            }
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
            width : 100,
            formatter : function(value, row, index) {
                var str = '';
                if(row.carStatus == '0'){//只有已入库状态才允许操作
                	<shiro:hasPermission name="/carInfo/manualNet">
                    	str += $.formatString('<a href="javascript:void(0)" class="manualNetList-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="manualNetEditFun(\'{0}\');" >净重录入</a>', row.id);
                	</shiro:hasPermission>
                }
                return str;
            }
        } ] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#manualNetList_location').combobox({readonly: 'readonly'});
        	}
        	
            $('.manualNetList-easyui-linkbutton-edit').linkbutton({text:'净重录入'});
        }
    });
        
    readCard4ManualNetList();//页面加载初始化读卡器
});

/**
 * 净重录入
 */
function manualNetEditFun(id) {
    if (id == undefined) {
        var rows = manualNetListDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
        manualNetListDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '净重录入',
        width : 400,
        height : 300,
        href :  '${path}/carInfo/manualNetEditPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = manualNetListDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#manualNetEditForm');
                f.submit();
            }
        } ]
    });
}


/**
 * 清除
 */
function manualNetListCleanFun() {
    $('#manualNetListSearchForm input').val('');
    $('#manualNetList_location').combobox('setValue','');//所属区域
    manualNetListDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function manualNetListSearchFun() {
     manualNetListDataGrid.datagrid('load', $.serializeObject($('#manualNetListSearchForm')));
}

//读卡器初始化
function readCard4ManualNetList(){
	tcom.init(tcom.COMOBJ);
	tcom.COMOBJ.OnDataIn = function (dat){
		if(null != dat.data && dat.data != ""){
			$("#manualNetList_cardNo").val(dat.data);
			// tcommClose();//关闭串口
			manualNetListDataGrid.datagrid('load', $.serializeObject($('#manualNetListSearchForm')));
		}
	};
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="manualNetListSearchForm">
            <table>
                <tr>
                    <td>车牌号:</td>
                    <td><input name="carNo" placeholder="请输入车牌号" style="width: 80px;"/>
                    &nbsp;&nbsp;
                                                            所属区域&nbsp;&nbsp;
                    <select id="manualNetList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;运通卡号:</td>
                    <td>
                    	<input id="manualNetList_cardNo" name="cardNo" style="width: 80px;" readonly="readonly" />
                		&nbsp;&nbsp;
                   		<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4ManualNetList()">读卡</a>
                    </td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <td>
                    	&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="manualNetListSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="manualNetListCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="manualNetListDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
