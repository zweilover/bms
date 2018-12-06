<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var dailyReport4CustomerStoreDataGrid;
    $(function() {
    	//所属区域下拉选项
    	$('#dailyReport4CustomerStore_location').combobox({
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
    	$('#dailyReport4CustomerStore_storeId').combobox({
    		url : '${path }/store/selectAllStoreInfoList?location='+'${location}',
    		valueField : 'id',
    		textField : 'name',
    		editable : false
    		
    	});
    	
        dailyReport4CustomerStoreDataGrid = $('#dailyReport4CustomerStoreDataGrid').datagrid({
        url : '${path}/reportQuery/queryDailyReport4CustomerStoreList',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        //idField : 'carId',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : '库房名称',
            field : 'storeName'
        } ] ],
        columns : [ [{
            title : '客户名称',
            field : 'custName'
        },{
            title : '入库车数',
            field : 'inCount'
        },{
            title : '入库货物净重(吨)',
            field : 'goodsInNet',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '入库货物数量',
            field : 'goodsInAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '入库货物名称',
            field : 'inGoodsName'
        },{
            title : '出库车数',
            field : 'outCount'
        },{
            title : '出库货物净重(吨)',
            field : 'goodsOutNet',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '出库货物数量',
            field : 'goodsOutAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '出库货物名称',
            field : 'outGoodsName'
        }]],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#dailyReport4CustomerStore_location').combobox({readonly: 'readonly'});
        	}
        },
        toolbar : '#dailyReport4CustomerStoreToolbar'
    });
        
    //form提交
    $('#dailyReport4CustomerStoreSearchForm').form({
       	url : '${path}/reportQuery/exportDailyReport4CustomerStoreList',
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
function exportDailyReport4CustomerStoreFun() {
	$('#dailyReport4CustomerStoreSearchForm').submit();
}

/**
 * 清除
 */
function dailyReport4CustomerStoreCleanFun() {
    $('#dailyReport4CustomerStoreSearchForm input').val('');
    $('#dailyReport4CustomerStore_busiDateStart').val('${busiDateStart}');//默认为当天
	$('#dailyReport4CustomerStore_busiDateEnd').val('${busiDateEnd}');
	dailyReport4CustomerStoreDataGrid.datagrid('load', $.serializeObject($('#dailyReport4CustomerStoreSearchForm')));
}
/**
 * 搜索
 */
function dailyReport4CustomerStoreSearchFun() {
     dailyReport4CustomerStoreDataGrid.datagrid('load', $.serializeObject($('#dailyReport4CustomerStoreSearchForm')));
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 60px; overflow: hidden;background-color: #fff">
        <form id="dailyReport4CustomerStoreSearchForm">
            <table>
                <tr>
                	<td>
                		货物出/入库日期：
                		<input id="dailyReport4CustomerStore_busiDateStart" name="busiDateStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" value="${busiDateStart}" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input id="dailyReport4CustomerStore_busiDateEnd" name="busiDateEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" value="${busiDateEnd}" readonly="readonly" />	
                		&nbsp;&nbsp;
                		业务类型：&nbsp;&nbsp;
                   	    <select id="dailyReport4CustomerStore_type" name="type" class="easyui-combobox" style="width: 80px;" data-options="width:100,panelHeight:'auto',editable:false">
                			<option value="">-- 全部  --</option>
                			<option value="1">货物出库</option>
                			<option value="2">货物入库</option>
                		</select>
                	</td>
                </tr>
                <tr>
                    <td>
                    	客户名称：&nbsp;&nbsp;
                   	    <input name="custName" style="width: 80px;" />
                   	    &nbsp;&nbsp;
                                                                        库房名称：&nbsp;&nbsp;
                        <select id="dailyReport4CustomerStore_storeId" name="storeId" style="width: 70px;"  class="easyui-combobox"></select>
                   	    &nbsp;&nbsp;
                                                                        所属区域：&nbsp;&nbsp;
                        <select id="dailyReport4CustomerStore_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="dailyReport4CustomerStoreSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="dailyReport4CustomerStoreCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="dailyReport4CustomerStoreDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="dailyReport4CustomerStoreToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/exportDailyReport4CustomerStoreList">
        <a onclick="exportDailyReport4CustomerStoreFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>