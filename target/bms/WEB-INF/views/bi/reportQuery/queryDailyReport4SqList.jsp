<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var dailyReport4SqDataGrid;
    $(function() {
        dailyReport4SqDataGrid = $('#dailyReport4SqDataGrid').datagrid({
        url : '${path}/reportQuery/queryDailyReport4SqList',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        idField : 'carId',
        // sortName : 'out_time',
        // sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'carId',
            field : 'carId',
            sortable : true,
            hidden : true
        },{
            title : '记账日期',
            field : 'dailyDate'
        },{
            title : '车号',
            field : 'carNo',
            formatter: function(value,row,index){
            	var str = '';
            	if(null != row.carId && row.carId != 'undefined'){
        			str = $.formatString('<a href="javascript:void(0)"  onclick="viewCarOutPaymentFun(\'{0}\');" >'+row.carNo+'</a>', row.carId);
            	}
                return str;
            }
        } ] ],
        columns : [ [ {
            title : '出车单号',
            field : 'outStockNo',
            rowspan : 2
        },{
            title : '货位号',
            field : 'goodsStoreNo',
            rowspan : 2
        },{
            title : '客户名称',
            field : 'custName',
            rowspan : 2
        },{
            title : '业务类型',
            field : 'chargeTypeName',
            rowspan : 2
        },{
            title : '货物名称',
            field : 'goodsName',
            rowspan : 2
        },{
            title : '停车天数',
            field : 'parkDays',
            rowspan : 2
        },{
            title : '堆存天数',
            field : 'stockDays',
            rowspan : 2
        },{
            title : '重量(t)',
            field : 'netWeight',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '卫生费(制卡费)',
            field : 'wsfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '管理费(过磅费)',
            field : 'glfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '停车费',
            colspan : 3
        },{
            title : '倒货费',
            field : 'dhfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '运抵费',
            field : 'ydfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '装卸费',
            field : 'zxfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '仓储费',
            colspan : 3
        },{
            title : '转关费',
            colspan : 3
        },{
            title : '客户优惠',
            field : 'khyhfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '其他费用',
            field : 'qtfAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '应收费小计',
            field : 'sumAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '实时收费小计',
            field : 'payedAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '现金收费小计',
            field : 'cashAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '月结欠款小计',
            field : 'nonPayAmount',
            rowspan : 2,
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '收费类型',
            field : 'paymentMode',
            rowspan : 2
        },{
            title : '收费员',
            field : 'userName',
            rowspan : 2
        },{
        	title : '出库说明',
            field : 'outRemark',
            rowspan : 2
        }],
        // 第二列
        [{
        	title : '小计',
        	field : 'tcfAmount',
        	formatter : function(value,row,index){
            	if(null != row.tcfAmount){
            		return (parseFloat(row.tcfAmount).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '月结',
        	field : 'tcfAmount_yj',
        	formatter : function(value,row,index){
            	if(null != row.tcfAmount_yj){
            		return (parseFloat(row.tcfAmount_yj).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '实时',
        	field : 'tcfAmount_ss',
        	formatter : function(value,row,index){
            	if(null != row.tcfAmount_ss){
            		return (parseFloat(row.tcfAmount_ss).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '小计',
        	field : 'ccfAmount',
        	formatter : function(value,row,index){
            	if(null != row.ccfAmount){
            		return (parseFloat(row.ccfAmount).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '月结',
        	field : 'ccfAmount_yj',
        	formatter : function(value,row,index){
            	if(null != row.ccfAmount_yj){
            		return (parseFloat(row.ccfAmount_yj).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '实时',
        	field : 'ccfAmount_ss',
        	formatter : function(value,row,index){
            	if(null != row.ccfAmount_ss){
            		return (parseFloat(row.ccfAmount_ss).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '小计',
        	field : 'zgfAmount',
        	formatter : function(value,row,index){
            	if(null != row.zgfAmount){
            		return (parseFloat(row.zgfAmount).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '月结',
        	field : 'zgfAmount_yj',
        	formatter : function(value,row,index){
            	if(null != row.zgfAmount_yj){
            		return (parseFloat(row.zgfAmount_yj).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
        	title : '实时',
        	field : 'zgfAmount_ss',
        	formatter : function(value,row,index){
            	if(null != row.zgfAmount_ss){
            		return (parseFloat(row.zgfAmount_ss).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        } 
        ]],
        onLoadSuccess:function(data){
        	
        },
        toolbar : '#dailyReport4SqToolbar'
    });
        
    //form提交
    $('#dailyReport4SqSearchForm').form({
       	url : '${path}/reportQuery/exportDailyReport4Sq',
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
  * 查看出库付款单
  * @param url
*/
function viewCarOutPaymentFun(id) {
    parent.$.modalDialog({
        title : '查看明细',
        width : 750,
        height : 500,
        href :  '${path}/carInfo/viewCarOutPayPage?id=' + id
    });
}

/**
 * 导出excel
 * @param url
 */
function exportDailyReport4SqFun() {
	$('#dailyReport4SqSearchForm').submit();
}

/**
 * 清除
 */
function dailyReport4SqCleanFun() {
    $('#dailyReport4SqSearchForm input').val('');
    $('#dailyReport4Sq_dailyDateStart').val('${dailyDateStart}');//默认为当天
	$('#dailyReport4Sq_dailyDateEnd').val('${dailyDateEnd}');
    dailyReport4SqDataGrid.datagrid('load', $.serializeObject($('#dailyReport4SqSearchForm')));
}
/**
 * 搜索
 */
function dailyReport4SqSearchFun() {
     dailyReport4SqDataGrid.datagrid('load', $.serializeObject($('#dailyReport4SqSearchForm')));
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="dailyReport4SqSearchForm">
            <table>
                <tr>
                	<td>客户名称:</td>
                    <td><input name="custName" placeholder="" style="width: 60px;"/>
                    &nbsp;&nbsp;车牌号:
                    <input name="carNo" placeholder="" style="width: 60px;"/>
                    <td>记账日期:</td>
                	<td>
                		<input id="dailyReport4Sq_dailyDateStart" name="dailyDateStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 85px;" readonly="readonly" value="${dailyDateStart}" />
                		&nbsp;-&nbsp;
                		<input id="dailyReport4Sq_dailyDateEnd" name="dailyDateEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 85px;" readonly="readonly" value="${dailyDateEnd}" />
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="dailyReport4SqSearchFun();">查询</a>
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="dailyReport4SqCleanFun();">清空</a>
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="dailyReport4SqDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="dailyReport4SqToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/dailyReport4SqExport">
        <a onclick="exportDailyReport4SqFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>