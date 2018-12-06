<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
var storeManageViewDetailGrid; //明细dataGrid

    $(function() {
    	//所属区域下拉选项
    	$('#storeManageView_location').combobox({
    		url : '${path }/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${statement.location}'
    	});
    	
    	storeManageViewDetailGrid = $("#storeManageViewDetailGrid").datagrid({
    		url : '${path}/store/getStoreDetailByStateId?stId='+ '${statement.id}',
    		striped : true,
            rownumbers : true,
            checkOnSelect : false,
            columns :[ [ {
            	title : '库房ID',
                field : 'storeId',
                hidden : true
            },{
            	title : '库房名称',
                field : 'storeName',
                width : 80
            },{
            	title : '货物ID',
                field : 'goodsId',
                hidden : true
            },{
            	title : '货物名称',
                field : 'goodsName',
                width : 100
            },{
            	title : '货物净重(吨)',
                field : 'netWeight',
                width : 80,
                formatter : function(value,row,index){
                	if(null != row){
                		return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
                	}
                }
            },{
            	title : '货物数量',
                field : 'amount',
                width : 70
            },{
            	title : '备注',
                field : 'remark',
                width : 230
            } ] ]
    	});
    	
    	//form提交
        $('#storeManageViewForm').form({
            url : '${path}/store/storeManageSave',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                //业务日期不能为空
                if($('#storeManageView_busiDate').val() == ""){
                	progressClose();
                	$.messager.alert('错误','业务日期不能为空，请输入！','warning');
                	return false;
                }
                
                //明细不能为空
                if($('#storeManageViewDetailGrid').datagrid('getRows').length <= 0){
                	progressClose();
                	$.messager.alert('错误','明细不能为空，请添加！','warning');
                	return false;
                }
                
                //格式化明细数据
                $('#storeManageView_storeDetail').val(JSON.stringify($('#storeManageViewDetailGrid').datagrid('getRows')));
                return isValid;
            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                	$.messager.alert('消息',result.msg,'info');
                    //之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
        
      	//赋值
        $("#storeManageView_type").val('${statement.type}');
        $("#storeManageView_remark").val('${statement.remark}');
    });
    
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="storeManageViewForm" method="post">
            <table class="grid">
                <tr>
                	<input name="carId" type="hidden" value="${statement.carId}" />
                	<input name="id" type="hidden" value="${statement.id}" />
                	
                	<input id="storeManageView_storeDetail" name="storeDetail" type="hidden" />
                    <td>车牌号</td>
                    <td><input name="carNo" type="text" class="easyui-validatebox span2" value="${statement.carNo}" readonly="readonly"></td>
                    <td>运通卡号</td>
                    <td>
                    	<input name="cardNo" type="text" class="easyui-validatebox span2"  value="${statement.cardNo}" readonly="readonly">
                    </td>
                </tr> 
                <tr>
                	<td>所属区域</td>
                	<td>
                		<select id="storeManageView_location" name="location" style="width: 100px;" data-options="panelHeight:'auto'" class="easyui-combobox" readonly="readonly"></select>
                	</td>
                	<td>客户名称</td>
                	<td>
                		<input id="storeManageView_selectCustomerName" name="customerName" type="text" style="width: 140px;" readonly="readonly" value="${customer.name}" />
                		<input id="storeManageView_selectCustomerId" name="customerId" type="hidden" value="${statement.customerId}" />
                	</td>
                </tr>
                <tr>
                	<td>类型</td>
                	<td>
                		<select id="storeManageView_type" name="type" class="easyui-combobox" data-options="width:100,editable:false,panelHeight:'auto'" readonly="readonly">
							<option value="1">出库</option>
							<option value="2">入库</option>
					 </select>
                	</td>
                	<td>业务日期</td>
                	<td>
                		<input id="storeManageView_busiDate" name="busiDate" style="width: 140px;" value="${statement.busiDate}" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                	<c:if test="${statement.type == 1}">
                	<td>出车单号</td>
                	<td><input name="outStockNo" type="text" class="easyui-validatebox span2" value="${statement.outStockNo}"></td>
                	</c:if>
                	<td>备注</td>
                	<td><textarea rows="2" id="storeManageView_remark" name="remark" onkeydown="disabledEnterKey(event)" readonly="readonly"></textarea></td>
                </tr>
            </table>
            <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;width:595px; height:260px;">
        		<table id="storeManageViewDetailGrid" data-options="border:false" style="overflow: hidden;padding: 3px;width:595px; height:260px;"></table>
    		</div>
        </form>
    </div>
</div>

