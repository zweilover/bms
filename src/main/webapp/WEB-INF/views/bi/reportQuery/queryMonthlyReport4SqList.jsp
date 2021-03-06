<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    //所属区域下拉选项
    $('#monthlyReport4SqLocation').combobox({
    	url : '${path }/dictionary/selectDiByCode',
    	queryParams:{
    		"code": "CKSZQY"
    	},
    	valueField : 'code',
    	textField : 'name',
    	editable : false,
    	value : '${location}'
	});   

    var monthlyReport4SqDataGrid;
    $(function() {
        monthlyReport4SqDataGrid = $('#monthlyReport4SqDataGrid').datagrid({
        url : '${path}/reportQuery/queryMonthlyReport4SqList',
        striped : true,
        rownumbers : true,
        showFooter : true,
        pagination : true,
        singleSelect : true,
        // idField : 'out_time',
        // sortName : 'out_time',
        // sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        columns : [ [ {
            title : '记账日期',
            field : 'dailyDate'
        },{
            title : '卫生费(制卡费)',
            field : 'wsfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '管理费(过磅费)',
            field : 'glfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '停车费',
            field : 'tcfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '倒货费',
            field : 'dhfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '运抵费',
            field : 'ydfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '装卸费',
            field : 'zxfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '仓储费',
            field : 'ccfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '转关费',
            field : 'zgfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '客户优惠',
            field : 'khyhfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '其他费用',
            field : 'qtfAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '应收费合计',
            field : 'sumAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '森桥收费合计',
            field : 'sqAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '福地收费合计',
            field : 'fdAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '实时收费合计',
            field : 'payedAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '现金收费合计',
            field : 'cashAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        },{
            title : '月结欠款合计',
            field : 'nonPayAmount',
            formatter : function(value,row,index){
            	if(null != row){
            		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
            	}
            }
        }] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#monthlyReport4SqLocation').combobox({readonly: 'readonly'});
        	}
        },
        toolbar : '#monthlyReport4SqToolbar'
    });
        
    //form提交
    $('#monthlyReport4SqSearchForm').form({
       	url : '${path}/reportQuery/exportMonthlyReport4Sq',
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
function exportMonthlyReport4SqFun() {
	$('#monthlyReport4SqSearchForm').submit();
}

/**
 * 清除
 */
function monthlyReport4SqCleanFun() {
    $('#monthlyReport4SqSearchForm input').val('');
    $('#monthlyReport4Sq_dailyDateStart').val('${dailyDateStart}');//默认为当天
	$('#monthlyReport4Sq_dailyDateEnd').val('${dailyDateEnd}');
	$('#monthlyReport4SqLocation').combobox('setValue','');
    monthlyReport4SqDataGrid.datagrid('load', $.serializeObject($('#monthlyReport4SqSearchForm')));
}
/**
 * 搜索
 */
function monthlyReport4SqSearchFun() {
     monthlyReport4SqDataGrid.datagrid('load', $.serializeObject($('#monthlyReport4SqSearchForm')));
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="monthlyReport4SqSearchForm">
            <table>
                <tr>
                	<td>客户名称:</td>
                    <td><input name="custName" placeholder="" style="width: 100px;"/>
                    &nbsp;&nbsp;
                                                            所属区域&nbsp;&nbsp;
                    <select id="monthlyReport4SqLocation" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>记账日期:</td>
                	<td>
                		<input id="monthlyReport4Sq_dailyDateStart" name="dailyDateStart" placeholder="点击选择开始时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM'})" style="width: 60px;" readonly="readonly" value="${dailyDateStart}" />
                		&nbsp;-&nbsp;
                		<input id="monthlyReport4Sq_dailyDateEnd" name="dailyDateEnd" placeholder="点击选择结束时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM'})" style="width: 60px;" readonly="readonly" value="${dailyDateEnd}" />
                		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="monthlyReport4SqSearchFun();">查询</a>
                    	<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="monthlyReport4SqCleanFun();">清空</a>
                	</td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="monthlyReport4SqDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="monthlyReport4SqToolbar" style="display: none;">
    <shiro:hasPermission name="/reportQuery/monthlyReport4SqExport">
        <a onclick="exportMonthlyReport4SqFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-download'">导出Excel</a>
    </shiro:hasPermission>
</div>