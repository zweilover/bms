<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
var storeManageAddNoCarDetailGrid; //明细dataGrid

    $(function() {
    	//所属区域下拉选项
    	$('#storeManageAddNoCar_location').combobox({
    		url : '${path }/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}'
    	});
    	
    	storeManageAddNoCarDetailGrid = $("#storeManageAddNoCarDetailGrid").datagrid({
    		// url : '${path}/store/getStoreDetailByStateId',
    		striped : true,
            rownumbers : true,
            // singleSelect : true,
            checkOnSelect : false,
            // showFooter: true,
            // idField : 'itemId',
            // sortName : 'itemId',
            // sortOrder : 'asc',
            columns :[ [ {
            	title : '',
            	field : 'checkbox',
            	checkbox : true
            },{
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
                width : 60
            },{
            	title : '备注',
                field : 'remark',
                width : 210
            } ] ],
            toolbar : '#storeManageAddNoCarToolbar'
    	});
    	
    	
    	//form提交
        $('#storeManageAddNoCarForm').form({
            url : '${path}/store/storeManageSave',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                //业务日期不能为空
                if($('#storeManageAddNoCar_busiDate').val() == ""){
                	progressClose();
                	$.messager.alert('错误','业务日期不能为空，请输入！','warning');
                	return false;
                }
                
                //明细不能为空
                if($('#storeManageAddNoCarDetailGrid').datagrid('getRows').length <= 0){
                	progressClose();
                	$.messager.alert('错误','明细不能为空，请添加！','warning');
                	return false;
                }
                
                //格式化明细数据
                $('#storeManageAddNoCar_storeDetail').val(JSON.stringify($('#storeManageAddNoCarDetailGrid').datagrid('getRows')));
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
        $("#storeManageAddNoCar_type").val('${type}');
        
        var localVal = $('#storeManageAddNoCar_location').combobox("getValue");
		if(localVal != null && localVal != ""){
			$('#storeManageAddNoCar_location').combobox({readonly: 'readonly'});
		}
    });

    /**
     *  点击选择客户按钮
     */
    function btn_selectCustomer(){
    	$('#selectBigCustomer').dialog({    
    	    title: '选择客户',    
    	    width: 600,    
    	    height: 400,    
    	    closed: false,    
    	    cache: false,    
    	    href: '${path}/bigCustomer/selectCustomerPage?isAllStatus=false',    
    	    modal: true   
    	});
    }
    /**
     * 清空客户信息
     */
    function btn_clearCustomer(){
    	$('#storeManageAddNoCar_selectCustomerName').val('');//客户名称
    	$('#storeManageAddNoCar_selectCustomerId').val('');//客户id
    }

    /**
     * 选择客户回调函数
     */
    function selectCustomerCallback(data){
    	$('#storeManageAddNoCar_selectCustomerName').val(data.name);//客户名称
    	$('#storeManageAddNoCar_selectCustomerId').val(data.id);//客户id
    }
    
    //出入库明细添加页面
    function storeManageAddNoCarAddFun(){
    	$('#storeDetailAddPage').dialog({    
    	    title: '添加明细',    
    	    width: 500,    
    	    height: 300,    
    	    closed: false,    
    	    cache: false,    
    	    href: '${path}/store/storeDetailAddPage?carId='+'${carInfo.id}'+'&carNo='+'${carInfo.carNo}'+'&cardNo='+'${carInfo.cardNo}',    
    	    modal: true   
    	});
    }
    
    //出入库明细回调函数
    function storeDetailAddCallback(data){
    	$('#storeManageAddNoCarDetailGrid').datagrid('appendRow',{
    		'storeId': data.storeId,
    		'storeName': data.storeName,
    		'goodsId': data.goodsId,
    		'goodsName': data.goodsName,
    		'netWeight': data.netWeight,
    		'amount': data.amount,
    		'remark': data.remark,
    	});
    }
    
    //删除
    function storeManageAddNoCarDelFun(){
    	var checknodes = storeManageAddNoCarDetailGrid.datagrid('getChecked');
    	if(checknodes && checknodes.length <= 0){
    		$.messager.alert('警告!','请先选中一行数据！','warning');
    		return;
    	}
    	
    	$.messager.confirm('确认对话框','是否确定删除所选数据?',function(result){
    		if(result){
    			var index;
    			for(var i = 0; i < checknodes.length; i++){
    				index = $("#storeManageAddNoCarDetailGrid").datagrid('getRowIndex', checknodes[i]);
    				$("#storeManageAddNoCarDetailGrid").datagrid('deleteRow',index);
    			}
    		}
    	});
    	
    }
    
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="storeManageAddNoCarForm" method="post">
            <table class="grid">
                <tr>
                	<input name="carId" type="hidden" value="" />
                	
                	<input id="storeManageAddNoCar_storeDetail" name="storeDetail" type="hidden" />
                    <td>车牌号</td>
                    <td><input name="carNo" type="text" class="easyui-validatebox span2" value="" readonly="readonly"></td>
                    <td>运通卡号</td>
                    <td>
                    	<input name="cardNo" type="text" class="easyui-validatebox span2"  value="" readonly="readonly">
                    </td>
                </tr> 
                <tr>
                	<td><font color="red">*</font>所属区域</td>
                	<td>
                		<select id="storeManageAddNoCar_location" name="location" style="width: 100px;" data-options="panelHeight:'auto'" class="easyui-combobox" required="required"></select>
                	</td>
                	<td>客户名称</td>
                	<td>
                		<input id="storeManageAddNoCar_selectCustomerName" name="customerName" type="text" style="width: 140px;" readonly="readonly" />
                		<input id="storeManageAddNoCar_selectCustomerId" name="customerId" type="hidden"/>
                		<a id="btn_selCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_selectCustomer()" >选择</a>
                		<a id="btn_clearCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_clearCustomer()" >清空</a>
                	</td>
                </tr>
                <tr>
                	<td>类型</td>
                	<td>
                		<select id="storeManageAddNoCar_type" name="type" class="easyui-combobox" data-options="width:100,editable:false,panelHeight:'auto'" readonly="readonly">
							<option value="1">出库</option>
							<option value="2">入库</option>
					 </select>
                	</td>
                	<td>业务日期</td>
                	<td>
                		<input id="storeManageAddNoCar_busiDate" name="busiDate" placeholder="点击选择时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;"  required="required" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                	<c:if test="${type == 1}">
                	<td>出车单号</td>
                	<td><input name="outStockNo" type="text" class="easyui-validatebox span2"></td>
                	</c:if>
                	<td>备注</td>
                	<td><textarea rows="2" id="storeManageAddNoCar_remark" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
            <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;width:595px; height:260px;">
        		<table id="storeManageAddNoCarDetailGrid" data-options="border:false" style="overflow: hidden;padding: 3px;width:595px; height:260px;"></table>
    		</div>
        </form>
    </div>
</div>

<div id="storeManageAddNoCarToolbar" style="display: none;">
    <a onclick="storeManageAddNoCarAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加</a>
    <a onclick="storeManageAddNoCarDelFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-delete'">删除</a>
</div>

<div id="selectBigCustomer"></div>
<div id="storeDetailAddPage"></div>