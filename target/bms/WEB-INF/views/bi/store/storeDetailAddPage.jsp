<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//所属区域下拉选项
    	$('#storeDetailAdd_location').combobox({
    		url : '${path }/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}'
    	});
    	
    	//库房名称下拉选项
    	$('#storeDetailAdd_storeId').combobox({
    		url : '${path }/store/selectAllStoreInfoList?location='+'${location}',
    		valueField : 'id',
    		textField : 'name',
    		editable : false,
    		onChange : function(newValue, oldValue){
    			$('#storeDetailAdd_storeName').val($('#storeDetailAdd_storeId').combobox('getText'));
    		}
    	});
    	
    	//货物名称下拉选项
    	$('#storeDetailAdd_goodsId').combobox({
    		url : '${path }/store/selectAllGoodsInfoList?location='+'${location}',
    		valueField : 'id',
    		textField : 'name',
    		editable : false,
    		onChange : function(newValue, oldValue){
    			$('#storeDetailAdd_goodsName').val($('#storeDetailAdd_goodsId').combobox('getText'));
    		}
    	});
       
      	//赋值
        var localVal = $('#storeDetailAdd_location').combobox("getValue");
		if(localVal != null && localVal != ""){
			$('#storeDetailAdd_location').combobox({readonly: 'readonly'});
		}
    });
    
    function doSubmit(){
    	var storeId = $('#storeDetailAdd_storeId').combobox('getValue'); //库房名称
    	if(storeId == ""){
    		$.messager.alert('错误','请选择库房名称！','warning');
    		return;
    	}
    	
    	var goodsId = $('#storeDetailAdd_goodsId').combobox('getValue'); //货物名称
    	if(goodsId == ""){
    		$.messager.alert('错误','请选择货物名称！','warning');
    		return;
    	}
    	
    	var location = $('#storeDetailAdd_location').combobox('getValue'); //所属区域
    	if(location == ""){
    		$.messager.alert('错误','请选择所属区域！','warning');
    		return;
    	}
    	
    	var netWeight = $('#storeDetailAdd_netWeight').numberbox('getValue'); //净重
    	if(null == netWeight || netWeight == '' || netWeight <= 0){
    		$.messager.alert('错误','请输入货物净重！','warning');
    		return;
    	}
    	
    	var amount = $('#storeDetailAdd_amount').numberbox('getValue'); //数量
    	if(null == amount || amount == '' || amount <= 0){
    		$.messager.alert('错误','请输入货物数量！','warning');
    		return;
    	}
    	
    	window.parent.storeDetailAddCallback($.serializeObject($('#storeDetailAddForm')));//父窗体的回调函数
    	$('#storeDetailAddPage').window('close');//关闭出入库明细窗体
    }

</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="storeDetailAddForm" method="post">
            <table class="grid">
                <tr>
                	<input name="carId" type="hidden" value="${carId}" />
                    <td>车牌号</td>
                    <td><input name="carNo" type="text" class="easyui-validatebox span2" style="width: 120px;" value="${carNo}" readonly="readonly"></td>
                    <td>运通卡号</td>
                    <td>
                    	<input name="cardNo" type="text" class="easyui-validatebox span2" style="width: 120px;" value="${cardNo}" readonly="readonly">
                    </td>
                </tr> 
                <tr>
                	<td><font color="red">*</font>所属区域</td>
                	<td>
                		<select id="storeDetailAdd_location" name="location" style="width: 100px;" data-options="panelHeight:'auto'" class="easyui-combobox" required="required"></select>
                	</td>
                	<td><font color="red">*</font>库房名称</td>
                	<td>
                		<input id="storeDetailAdd_storeName" name="storeName" type="hidden" />
                		<select id="storeDetailAdd_storeId" name="storeId" style="width: 100px;" data-options="" class="easyui-combobox" required="required"></select>
                	</td>
                </tr>
                <tr>
                	<td><font color="red">*</font>货物净重(吨)</td>
                	<td>
                		<input id="storeDetailAdd_netWeight" name="netWeight" type="text" class="easyui-numberbox span2" data-options="min:0,precision:2" style="width: 100px;text-align: right;">
                	</td>
                	<td><font color="red">*</font>货物数量</td>
                	<td>
                		<input id="storeDetailAdd_amount" name="amount" type="text"  class="easyui-numberbox span2" data-options="min:0,precision:0" style="width: 100px;text-align: right;">
                	</td>
                </tr>
                <tr>
                	<td><font color="red">*</font>货物名称</td>
                	<td>
                		<input id="storeDetailAdd_goodsName" name="goodsName" type="hidden" />
                		<select id="storeDetailAdd_goodsId" name="goodsId" style="width: 100px;" data-options="" class="easyui-combobox" required="required"></select>
                	</td>
                	<td>备注</td>
                	<td><textarea rows="2" id="storeDetailAdd_remark" style="width: 120px;" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
            
            <div style="margin:0 auto;line-height:150px;text-align:center;">
				<a href="#" class="easyui-linkbutton" onclick="javascript:doSubmit()">确定</a>
    		</div>
        </form>
    </div>
</div>
