<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#selectMatchCcPick_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});   

var selectMatchCcPickDataGrid;
$(function() {
	selectMatchCcPickDataGrid = $('#selectMatchCcPickDataGrid').datagrid({
    url : '${path}/checkData/selectMatchCcPickList?ccsj='+'${ccsj}'+'&location='+'${location}',
    striped : true,
    rownumbers : true,
    pagination : true,
    singleSelect : true,
    idField : 'id',
    // sortName : 'out_time',
    // sortOrder : 'desc',
    pageSize : 20,
    pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
    columns : [ [{
        title : 'ID',
        field : 'id',
        hidden : true
    },{
        title : '车牌号',
        field : 'car_no'
    },{
        title : '所属区域',
        field : 'location'
    },{
        title : '入库日期',
        field : 'in_time'
    },{
        title : '入库人',
        field : 'in_user_name'
    },{
        title : '出库日期',
        field : 'out_time'
    },{
        title : '出库人',
        field : 'out_user_name'
    },{
        title : '是否年卡',
        field : 'is_year_card',
        formatter : function(value, row, index) {
            switch (value) {
            case '0':
                return '是';
            case '1':
                return '否';
             default :
            	 return value;
            }
        }},{
        	title : '状态',
        	field : 'car_status',
        	sortable : true,
        	formatter : function(value, row, index) {
            	switch (value) {
            	case '0':
                return '已入库';
            case '1':
                return '已出库';
             default :
            	 return value;
            }
        }},{
        	title : '入库描述',
        	field : 'in_remark'
    	},{
        	title : '出库描述',
        	field : 'out_remark'
    	}] ],
    onLoadSuccess:function(data){
       
    },
    onDblClickRow:function(index,row){
    	window.parent.selectMatchCcPickCallback(row);//父窗体的回调函数
    	$('#selectManualMatchCcPickList').window('close'); //关闭当前子窗体
    }});
});

/**
 * 清除
 */
function selectMatchCcPickCleanFun() {
    $('#selectMatchCcPick_carNo').val('');
    selectMatchCcPickDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function selectMatchCcPickSearchFun() {
	selectMatchCcPickDataGrid.datagrid('load', {'carNo' : $('#selectMatchCcPick_carNo').val()});
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="selectMatchCcPickForm">
            <table>
                <tr>
                    <th>车牌号:</th>
                    <td>
                    	<input id="selectMatchCcPick_carNo" name="carNo" style="width: 70px;" />
                    	 &nbsp;&nbsp;
                                                                        所属区域：&nbsp;&nbsp;
                    	<select id="selectMatchCcPick_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox" readonly="readonly"></select>
                   	    &nbsp;&nbsp;
                                                                       出库日期:&nbsp;&nbsp;
                        <input id="selectMatchCcPick_ccsj" name="ccsj" style="width: 90px;" readonly="readonly" value="${ccsj}" />
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="selectMatchCcPickSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="selectMatchCcPickCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="selectMatchCcPickDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
