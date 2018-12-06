<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var custAccountReportQueryDataGrid;
    $(function() {
        custAccountReportQueryDataGrid = $('#custAccountReportQueryDataGrid').datagrid({
        url : '${path}/reportQuery/queryCustAccountReport',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        idField : 'custId',
        sortName : 'customer_id',
        sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
        	width : '40',
            title : 'custId',
            field : 'custId',
            sortable : true,
            hidden : true
        } ] ],
        columns : [ [ {
            width : '140',
            title : '客户名称',
            field : 'custName'
        }, {
        	width : '100',
            title : '总额',
            field : 'total',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
         
        },{
        	width : '100',
            title : '未付款',
            field : 'nonpay',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            width : '100',
            title : '已收款',
            field : 'payed',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        }, {
        	 width : '100',
             title : '账户结余',
             field : 'subtotal',
             formatter : function(value,row,index){
             	if(null != row){
             		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
             	}
             }
        },{
        	 field : 'action',
        	 title : '操作',
             width : 100,
             formatter : function(value, row, index) {
            	 if(row.custName == null || row.custName.indexOf("统计：") < 0 ){//统计行去掉操作按钮
            		 <shiro:hasPermission name="/reportQuery/custAccountDetailReport">
            		 	var str = '';
                  		str += $.formatString('<a href="javascript:void(0)" class="custAccountReport-easyui-linkbutton-viewPay" data-options="plain:true,iconCls:\'fi-eye icon-blue\'" onclick="viewCustAccountDetailFun(\'{0}\',\'{1}\');" >查看明细</a>', row.custId,row.custName);
                  		return str;
            	 	 </shiro:hasPermission>
            	 }
             }
        }] ],
        onLoadSuccess:function(data){
        	$('.custAccountReport-easyui-linkbutton-viewPay').linkbutton({text:'查看明细'});
        	<!-- 
        	var rows = $('#custAccountReportQueryDataGrid').datagrid('getRows')//获取当前的数据行
            var sTotal = 0 ;
            var sNonpay = 0;
            var sPayed = 0;
            var sSubtotal = 0;
            for (var i = 0; i < rows.length; i++) {
            	sTotal += rows[i]['total'];
            	sNonpay += rows[i]['nonpay'];
            	sPayed += rows[i]['payed'];
            	sSubtotal += rows[i]['subtotal'];
            }
            // alert(sTotal+" - "+ sNonpay +" - "+sPayed+" - "+sSubtotal);
            //新增一行显示统计信息
            //$('#custAccountReportQueryDataGrid').datagrid('appendRow', { 'custName': '<b>统计：</b>','total':sTotal, 'nonpay': sNonpay , 'payed': sPayed ,'subtotal':sSubtotal  });
            
            /****/
            rows = $('#custAccountReportQueryDataGrid').datagrid('getFooterRows');
            rows[0]['custName'] = '<b>统计：</b>';
            rows[0]['total'] = sTotal;
            rows[0]['nonpay'] = sNonpay;
            rows[0]['payed'] = sPayed;
            rows[0]['subtotal'] = sSubtotal;
            $('#custAccountReportQueryDataGrid').datagrid('reloadFooter');
            -->
        },
        toolbar : '#custAccountReportQueryToolbar'
    });
        
    //form提交
    $('#custAccountReportQuerySearchForm').form({
       	url : '${path}/reportQuery/exportCustAccountReport',
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
function exportCustAccountReportFun() {
	$('#custAccountReportQuerySearchForm').submit();
}

/**
 * 清除
 */
function custAccountReportCleanFun() {
    $('#custAccountReportQuerySearchForm input').val('');
    custAccountReportQueryDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function custAccountSearchFun() {
     custAccountReportQueryDataGrid.datagrid('load', $.serializeObject($('#custAccountReportQuerySearchForm')));
}

/**
 * 查看客户账户信息明细
 * @param url
 */
function viewCustAccountDetailFun(custId,custName) {
	if(custId == 'undefined'){
		custId = "";
	}
	if(custName == 'undefined'){
		custName = "";
	}
	var startDate = $('#custAccountReport_recordTimeStart').val();
	var endtDate = $('#custAccountReport_recordTimeEnd').val();
    parent.$.modalDialog({
        title : '查看明细',
        width : 750,
        height : 550,
        href :  '${path}/reportQuery/custAccountDetailReport?custId=' + custId +'&custName='+encodeURI(custName)+'&recordTimeStart='+startDate+'&recordTimeEnd='+endtDate
    });
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="custAccountReportQuerySearchForm">
            <table>
                <tr>
                	<td>客户名称:</td>
                    <td><input name="custName" placeholder="" style="width: 110px;"/>
                    &nbsp;&nbsp;&nbsp;
                    <td>记账日期:</td>
                	<td>
                		<input id="custAccountReport_recordTimeStart" name="recordTimeStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input id="custAccountReport_recordTimeEnd" name="recordTimeEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 110px;" readonly="readonly" />
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="custAccountSearchFun();">查询</a>
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="custAccountReportCleanFun();">清空</a>
                	
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="custAccountReportQueryDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="custAccountReportQueryToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/custAccountReportExport">
        <a onclick="exportCustAccountReportFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>