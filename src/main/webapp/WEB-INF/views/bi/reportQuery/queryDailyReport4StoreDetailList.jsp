<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var dailyReport4StoreDetailDataGrid;
    $(function() {
    	//所属区域下拉选项
    	$('#dailyReport4StoreDetail_location').combobox({
    		url : '${path}/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}',
    	});
    	
    	//库房名称下拉选项
    	$('#dailyReport4StoreDetail_storeId').combobox({
    		url : '${path }/store/selectAllStoreInfoList?location='+'${location}',
    		valueField : 'id',
    		textField : 'name',
    		editable : false
    		
    	});
    	
        dailyReport4StoreDetailDataGrid = $('#dailyReport4StoreDetailDataGrid').datagrid({
        url : '${path}/reportQuery/queryDailyReport4StoreDetailList',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        //idField : 'carId',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : '车牌号',
            field : 'carNo'
        } ] ],
        columns : [ [{
            title : '运通卡号',
            field : 'cardNo'
        },{
            title : '客户名称',
            field : 'custName'
        },{
            title : '车辆入库日期',
            field : 'inTime'
        },{
            title : '车辆出库日期',
            field : 'outTime'
        },{
            title : '库房名称',
            field : 'storeName'
        },{
            title : '业务类型',
            field : 'type'
        },{
            title : '货物出/入库日期',
            field : 'busiDate'
        },{
            title : '货物净重(吨)',
            field : 'sumNet',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '货物数量',
            field : 'sumAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '货物名称',
        	field : 'goodsName'
        },{
        	title : '操作人员',
        	field : 'userName'
        }]],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#dailyReport4StoreDetail_location').combobox({readonly: 'readonly'});
        	}
        },
        toolbar : '#dailyReport4StoreDetailToolbar'
    });
        
    //form提交
    $('#dailyReport4StoreDetailSearchForm').form({
       	url : '${path}/reportQuery/exportDailyReport4StoreDetailList',
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
    
    readCard4DailyReportStoreDetailList();//页面加载初始化读卡器
});
    
/**
 * 导出excel
 * @param url
 */
function exportDailyReport4StoreDetailFun() {
	$('#dailyReport4StoreDetailSearchForm').submit();
}

/**
 * 清除
 */
function dailyReport4StoreDetailCleanFun() {
    $('#dailyReport4StoreDetailSearchForm input').val('');
    $('#dailyReport4StoreDetail_busiDateStart').val('${busiDateStart}');//默认为当天
	$('#dailyReport4StoreDetail_busiDateEnd').val('${busiDateEnd}');
	dailyReport4StoreDetailDataGrid.datagrid('load', $.serializeObject($('#dailyReport4StoreDetailSearchForm')));
}
/**
 * 搜索
 */
function dailyReport4StoreDetailSearchFun() {
     dailyReport4StoreDetailDataGrid.datagrid('load', $.serializeObject($('#dailyReport4StoreDetailSearchForm')));
}

//读卡器初始化
function readCard4DailyReportStoreDetailList(){
	tcom.init(tcom.COMOBJ);
	tcom.COMOBJ.OnDataIn = function (dat){
		if(null != dat.data && dat.data != ""){
			$("#dailyReport4StoreDetail_cardNo").val(dat.data);
			// tcommClose();//关闭串口
			dailyReport4StoreDetailDataGrid.datagrid('load', $.serializeObject($('#dailyReport4StoreDetailSearchForm')));
		}
	};
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 90px; overflow: hidden;background-color: #fff">
        <form id="dailyReport4StoreDetailSearchForm">
            <table>
                <tr>
                	<td>
                		车辆入库日期：
                		<input name="inTimeStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="inTimeEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />	
                		&nbsp;&nbsp;
                		车辆出库日期：
                		<input name="outTimeStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="outTimeEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                	<td>
                		货物出/入库日期：
                		<input id="dailyReport4StoreDetail_busiDateStart" name="busiDateStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" value="${busiDateStart}" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input id="dailyReport4StoreDetail_busiDateEnd" name="busiDateEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" value="${busiDateEnd}" readonly="readonly" />	
                		&nbsp;&nbsp;
                		业务类型：&nbsp;&nbsp;
                   	    <select id="dailyReport4StoreDetail_type" name="type" class="easyui-combobox" style="width: 80px;" data-options="width:100,panelHeight:'auto',editable:false">
                			<option value="">-- 全部  --</option>
                			<option value="1">货物出库</option>
                			<option value="2">货物入库</option>
                		</select>
                		&nbsp;&nbsp;
                                                                        库房名称：&nbsp;&nbsp;
                        <select id="dailyReport4StoreDetail_storeId" name="storeId" style="width: 70px;"  class="easyui-combobox"></select>
                   	    &nbsp;&nbsp;
                	</td>
                </tr>
                <tr>
                    <td>
                    	车牌号:<input name="carNo" style="width: 80px;" />
                    	&nbsp;&nbsp;
                    	客户名称：&nbsp;&nbsp;
                   	    <input name="custName" style="width: 80px;" />
                   	    &nbsp;&nbsp;
                                                                        所属区域：&nbsp;&nbsp;
                        <select id="dailyReport4StoreDetail_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	    &nbsp;&nbsp;
                   	   	运通卡号：&nbsp;&nbsp;
                   	    <input id = "dailyReport4StoreDetail_cardNo" name="cardNo" style="width: 80px;" readonly="readonly" />
                   	    &nbsp;&nbsp;
                   		<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4DailyReportStoreDetailList()">读卡</a>
                   		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="dailyReport4StoreDetailSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="dailyReport4StoreDetailCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="dailyReport4StoreDetailDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="dailyReport4StoreDetailToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/exportDailyReport4StoreDetailList">
        <a onclick="exportDailyReport4StoreDetailFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>