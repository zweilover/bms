<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var carInfoReportQueryDataGrid;
    $(function() {
        carInfoReportQueryDataGrid = $('#carInfoReportQueryDataGrid').datagrid({
        url : '${path}/reportQuery/queryCarInfoReport',
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
        	width : '40',
            title : 'ID',
            field : 'id',
            sortable : true,
            hidden : true
        } ] ],
        columns : [ [ {
            width : '80',
            title : '车牌号',
            field : 'carNo'
        }, {
        	width : '65',
            title : '是否年卡',
            field : 'isYearCard'
        },{
        	width : '120',
            title : '客户名称',
            field : 'customerName',
            sortable : true
        },{
            width : '65',
            title : '车辆状态',
            field : 'carStatus'
        }, {
        	 width : '80',
             title : '入库人员',
             field : 'inUserName'
        },{
            width : '140',
            title : '入库时间',
            field : 'inTime'
        },{
        	 width : '80',
             title : '出库人员',
             field : 'outUserName'
        },{
       	 width : '140',
         title : '出库时间',
         field : 'outTime'
    	}] ],
        onLoadSuccess:function(data){
        	
        },
        toolbar : '#carInfoReportQueryToolbar'
    });
        
    //form提交
    $('#carInfoReportQuerySearchForm').form({
       	url : '${path}/reportQuery/exportCarInfoReport',
        onSubmit : function() {
        	// progressLoad();
            var isValid = $(this).form('validate');
            if (!isValid) {
            	progressClose();
            }
            return isValid;
       	},
       	success : function(result) {
            progressClose();
            result = $.parseJSON(result);
            if (result.success) {
                $.messager.alert('消息',result.msg,'info');
             } else {
                $.messager.alert('错误',result.msg,'warning');
             }
     	}
  	});
});

/**
 * 导出excel
 * @param url
 */
function exportCarInfoReportFun() {
	$('#carInfoReportQuerySearchForm').submit();
}

/**
 * 清除
 */
function carInfoReportCleanFun() {
    $('#carInfoReportQuerySearchForm input').val('');
    $('#carInfoReport_carStatus').combobox('setValue',"");//清空车辆状态
    carInfoReportQueryDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function chargeTypeSearchFun() {
     carInfoReportQueryDataGrid.datagrid('load', $.serializeObject($('#carInfoReportQuerySearchForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 75px; overflow: hidden;background-color: #fff">
        <form id="carInfoReportQuerySearchForm">
            <table>
                <tr>
                    <td>入库时间:</td>
                	<td>
                		<input name="inTimeStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="inTimeEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                	<td>出库时间:</td>
                	<td>
                		<input name="outTimeStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" />
                		&nbsp;-&nbsp; 
                		<input name="outTimeEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                	<td>车牌号:</td>
                    <td><input name="carNo" placeholder="请输入车牌号" style="width: 110px;"/>
                    	&nbsp;&nbsp;&nbsp;
                    	车辆状态:
                    	<select id= "carInfoReport_carStatus" name="carStatus" class="easyui-combobox" data-options="width:80,panelHeight:'auto',editable:false" >
                			<option value="">-- 全部 --</option>
                			<option value="0">已入库</option>
                			<option value="1">已出库</option>
                		</select>
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="chargeTypeSearchFun();">查询</a>
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="carInfoReportCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="carInfoReportQueryDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="carInfoReportQueryToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/carInfoReportExport">
        <a onclick="exportCarInfoReportFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>