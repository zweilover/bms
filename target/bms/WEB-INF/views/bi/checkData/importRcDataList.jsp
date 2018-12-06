<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#importRcList_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});   

    var importRcDataGrid;
    $(function() {
        importRcDataGrid = $('#importRcDataGrid').datagrid({
        url : '${path}/checkData/queryImportRcDataList',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        // sortName : 'rcsj',
        // sortOrder : 'desc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'ID',
            field : 'id',
            hidden : true
            // sortable : true
        },{
        	title : '入仓id',
            field : 'rcid'
        },{
            title : '车牌号',
            field : 'ch'
        }]], 
        columns :[[{
            title : '仓库名称',
            field : 'ckmc'
        },{
            title : '入仓时间',
            field : 'rcsj',
        },{
            title : '运通卡类型',
            field : 'ytklx'
        },{
            title : '卡号',
            field : 'kh'
        },{
            title : '车辆类型',
            field : 'cllx'
        },{
            title : '状态',
            field : 'zt'
        },{
            title : '操作提示',
            field : 'czts'
        },{
            title : '车辆备案重量',
            field : 'clbazl'
        },{
            title : '地磅采集重量',
            field : 'dbcjzl'
        },{
            title : '导入日期',
            field : 'create_time'
        },{
            title : '导入人',
            field : 'user_name'
        }]],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#importRcList_location').combobox({readonly: 'readonly'});
        	}
        	
        },
        toolbar : '#importRcDataToolbar'
    });
});

/**
 * 出仓数据导入
 * @param url
 */
function importRcDataFun() {
    parent.$.modalDialog({
        title : '入仓数据导入',
        width : 400,
        height : 300,
        href : '${path}/checkData/importRcDataPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = importRcDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#importRcDataForm');
                f.submit();
            }
        } ]
    });
}




/**
 * 清除
 */
function importRcDataCleanFun() {
    $('#importRcDataSearchForm input').val('');
    $('#importRcList_location').combobox('setValue','');//所属区域
    importRcDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function importRcDataSearchFun() {
	importRcDataGrid.datagrid('load', $.serializeObject($('#importRcDataSearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="importRcDataSearchForm">
            <table>
                <tr>
                    <td>车牌号:</td>
                    <td><input name="carNo" placeholder="请输入车牌号" style="width: 100px;"/>
                    &nbsp;&nbsp;
                                                            所属区域&nbsp;&nbsp;
                    <select id="importRcList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;入仓日期:</td>
                    <td>
                    	<input id="importRcList_dateStart" name="dateStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" value="${dateStart}" />
                		&nbsp;-&nbsp;
                		<input id="importRcList_dailyDateEnd" name="dateEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" value="${dateEnd}" />
                    </td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <td>
                    	&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="importRcDataSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="importRcDataCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="importRcDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="importRcDataToolbar" style="display: none;">
    <shiro:hasPermission name="/checkData/importRcData">
        <a onclick="importRcDataFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">海关入仓数据导入</a>
    </shiro:hasPermission>
</div>