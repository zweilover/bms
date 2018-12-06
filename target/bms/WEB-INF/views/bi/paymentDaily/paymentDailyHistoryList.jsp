<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#dailyHistory_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});   

    var dailyHistoryDataGrid;
    $(function() {
        dailyHistoryDataGrid = $('#dailyHistoryDataGrid').datagrid({
        url : '${path}/paymentDaily/queryPaymentDailyHistory',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        columns :[[{
        	width : '80',
            title : '结转日期',
            field : 'dailyDate'
        },{
        	width : '60',
            title : '所属区域',
            field : 'locationName'
        }, {
            width : '140',
            title : '结转开始日期',
            field : 'dateStart'
        },{
            width : '140',
            title : '结转截止日期',
            field : 'dateEnd'
        },{
            width : '140',
            title : '操作日期',
            field : 'createTime'
        },{
        	width : '80',
            title : '操作人',
            field : 'createUserName'
        } ] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#dailyHistory_location').combobox({readonly: 'readonly'});
        	}
        }
    });
});

/**
 * 清除
 */
function carInfoCleanFun() {
    $('#dailyHistorySearchForm input').val('');
    $('#dailyHistory_location').combobox('setValue','${location}');//所属区域
    dailyHistoryDataGrid.datagrid('load', $.serializeObject($('#dailyHistorySearchForm')));
}
/**
 * 搜索
 */
function carInfoSearchFun() {
     dailyHistoryDataGrid.datagrid('load', $.serializeObject($('#dailyHistorySearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="dailyHistorySearchForm">
            <table>
                <tr>
                    <td>结转日期:</td>
                    <td><input id="dailyHistory_dailyDate" name="dailyDate" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 85px;" readonly="readonly" />
                    &nbsp;&nbsp;
                                                            所属区域&nbsp;&nbsp;
                    <select id="dailyHistory_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="carInfoSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="carInfoCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="dailyHistoryDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>