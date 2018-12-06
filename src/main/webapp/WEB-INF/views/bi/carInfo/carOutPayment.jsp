<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
var genPayDetailGrid;
var detail;
var itemsObj;//计费子项集合对象
var editRow; //编辑行
$(function(){
	//计费货物名称下拉选项
	$('#carOutPay_goodsName').combobox({
        url : '${path }/dictionary/selectDiByCode',
        queryParams:{
        	"code": "HWMC"
        },
        valueField : 'id',
        textField : 'name',
        editable : false
    });
	
	//付款方式下拉选项
	$('#carOutPay_paymentMode').combobox({
        url : '${path }/dictionary/selectDiByCode',
        queryParams:{
        	"code": "FKFS"
        },
        valueField : 'code',
        textField : 'name',
        editable : false
    });
	
	//计费项目下拉选项
	$('#carOutPay_chargeType').combobox({
        url : '${path }/chargeType/selectAllChargeType',
        queryParams:{
        	"isAllStatus": false
        },
        valueField : 'id',
        textField : 'name',
        editable : false,
        required:true,
        onChange : function(newValue,OldValue){
        	$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
        	var typeId = $('#carOutPay_chargeType').combobox('getValue');
        	$.ajax({
        		url : '${path }/chargeItem/selectItemsByChargeType?typeId='+typeId,
        		success : function(data,textStatus,jqXHR){
        			itemsObj = eval("("+data+")");
        		}
        	});
        }
    });
	
	//生成计费明细
	genPayDetailGrid = $("#doAccountDetailGrid").datagrid({
		url : '${path}/carInfo/genPaymentDetail',
        striped : true,
        rownumbers : true,
        // pagination : true,
        singleSelect : true,
        showFooter: true,
        idField : 'itemId',
        sortName : 'itemId',
        sortOrder : 'asc',
        // pageSize : 20,
        // pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        columns :[[{
            width : '60',
            title : 'itemId',
            field : 'itemId',
            hidden : true,
            sortable : true
        },{
        	width : '180',
            title : '计费项目名称',
            field : 'itemName'
        },{
        	width : '80',
        	title : '价格',
        	field : 'price',
        	editor :{
        		'type' : 'numberbox',
        		'options' :{
        			precision:2,
					onChange : function(newValue,oldValue){
						accountTotal();
        			}
        		}
        	}
        },{
        	width : '70',
        	title : '数量',
        	field : 'count',
        	editor :{
        		'type' : 'numberbox',
        		'options' :{
        			precision:2
        		}
        	}
        },{
        	width : '80',
            title : '总价',
            field : 'amount',
            editor :{
        		'type' : 'numberbox',
        		'options' :{
        			precision:2,
        			readonly : true
        		}
        	}
        }, {
        	width : '260',
            title : '费用说明',
            field : 'remark',
            editor : {
            	'type' : 'textarea',
            	'options' : {
            		onkeydown : function(event){
                		disabledEnterKey(event);
                	}
            	}
            }
        },{
            field : 'action',
            title : '',
            width : 30,
            editor : 'userSaveButton'
        }] ],
        //点击编辑
        onClickRow: function (index, rowData) {
        	$('#doAccountDetailGrid').datagrid('endEdit', editRow);//结束编辑行
        	if (rowData.isEditable == true) {
        		$('#doAccountDetailGrid').datagrid("beginEdit", index);//开始编辑行
             	//屏蔽多行文本框换行
              	$("textarea.datagrid-editable-input").bind('keydown',function(e){
              		disabledEnterKey(e); 
              	});
              	setEditing(index, rowData);//重构行编辑器-增加按钮
        	}
        	editRow = index;
        },
        // 编辑行计算
        onBeginEdit:function(rowIndex){  
            var editors = $('#doAccountDetailGrid').datagrid('getEditors', rowIndex);  
            var n1 = $(editors[0].target);  
            var n2 = $(editors[1].target);  
            var n3 = $(editors[2].target);  
            n1.add(n2).numberbox({  
                onChange:function(){  
                    var cost = n1.numberbox('getValue') * n2.numberbox('getValue');  
                    n3.numberbox('setValue',cost);  
                }  
            })  
        },  
        onLoadSuccess : function(data){
        	if(data.total > 0){
        		accountTotal();//计算合计
        		$('#pay_linkbutton').show();
        	}
        	progressClose();
        },
        onLoadError : function(){
        	$.messager.alert('错误','生成计费明细失败，请核实数据是否有误！','warning');
        	$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
        	$('#carOutPay_total').numberbox('setValue','0');//费用总计置0
        	$('#pay_linkbutton').hide();//隐藏支付按钮
        }
	});
	
	//车辆入库日期事件
	$('#carOutPay_inTime').blur(function(){
		var oldDays = $('#carOutPay_parkDays').numberbox('getValue');
		if($("#carOutPay_location").val() == "FD"){ //福地不按照24小时计算
			$('#carOutPay_parkDays').numberbox('setValue',dateDifference2($('#carOutPay_inTime').val(),$('#carOutPay_outTime').val()));
		}else{
			$('#carOutPay_parkDays').numberbox('setValue',dateDifference($('#carOutPay_inTime').val(),$('#carOutPay_outTime').val()));
		}
		var newDays = $('#carOutPay_parkDays').numberbox('getValue');
		if(oldDays != newDays){//停车天数改变，清空计费列表
			$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
			accountTotal();
		}
	});
	
	//车辆出库日期事件
	$('#carOutPay_outTime').blur(function(){
		var oldDays = $('#carOutPay_parkDays').numberbox('getValue');
		if($("#carOutPay_location").val() == "FD"){ //福地不按照24小时计算
			$('#carOutPay_parkDays').numberbox('setValue',dateDifference2($('#carOutPay_inTime').val(),$('#carOutPay_outTime').val()));
		}else{
			$('#carOutPay_parkDays').numberbox('setValue',dateDifference($('#carOutPay_inTime').val(),$('#carOutPay_outTime').val()));
		}
		var newDays = $('#carOutPay_parkDays').numberbox('getValue');
		if(oldDays != newDays){//停车天数改变，清空计费列表
			$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
			accountTotal();
		}
	});
	
	//商品出库日期事件
	$('#carOutPay_goodsOutTime').blur(function(){
		if($("#carOutPay_location").val() == "FD"){
			$('#carOutPay_stockDays').numberbox('setValue',dateDifference2($('#carOutPay_goodsInTime').val(),$('#carOutPay_goodsOutTime').val()));
		}else{
			$('#carOutPay_stockDays').numberbox('setValue',dateDifference($('#carOutPay_goodsInTime').val(),$('#carOutPay_goodsOutTime').val()));
		}
	});
	//商品入库日期事件
	$('#carOutPay_goodsInTime').blur(function(){
		if($("#carOutPay_location").val() == "FD"){
			$('#carOutPay_stockDays').numberbox('setValue',dateDifference2($('#carOutPay_goodsInTime').val(),$('#carOutPay_goodsOutTime').val()));
		}else{
			$('#carOutPay_stockDays').numberbox('setValue',dateDifference($('#carOutPay_goodsInTime').val(),$('#carOutPay_goodsOutTime').val()));
		}
	});
	
	//净重改变，清空计费列表
	$('#carOutPay_netWeight').numberbox({
		onChange : function(){
			$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
			accountTotal();
		}
	});
	
	//库存天数改变，清空计费列表
	$('#carOutPay_stockDays').numberbox({
		onChange : function(){
			$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
			accountTotal();
		}
	});
	
	//数量改变，清空计费列表
	$('#carOutPay_goodsQuantity').numberbox({
		onChange : function(){
			$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
			accountTotal();
		}
	});
	
	//form提交
    $('#carOutPayForm').form({
        url : '${path}/carInfo/dealPayment?type=carOut',
        onSubmit : function() {
            progressLoad();
            var isValid = $(this).form('validate');
            if (!isValid) {
                progressClose();
            }
            if($("#carOutPay_carStatus").val() != '0'){
            	progressClose();
            	$.messager.alert('消息','车辆状态已变更，不允许操作！','info');
            	return false;
            }
            return isValid;
        },
        success : function(result) {
            progressClose();
            result = $.parseJSON(result);
            if (result.success) {
            	$.messager.alert('消息',result.msg,'info');
                parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                parent.$.modalDialog.handler.dialog('close');
            } else {
            	$.messager.alert('错误',result.msg,'warning');
            	$('#carOutPay_doPaybutton').linkbutton({disabled:false});  //提交失败后启用确定按钮 
            }
        }
    });
	
  	//赋值
    $("#carOutPay_isYearCard").val('${carInfo.isYearCard}'); 
  	if('${carInfo.location}' == "FD"){
  		$('#carOutPay_parkDays').val(dateDifference2($('#carOutPay_inTime').val(),$('#carOutPay_outTime').val())); //停车天数
  	}else{
    	$('#carOutPay_parkDays').val(dateDifference($('#carOutPay_inTime').val(),$('#carOutPay_outTime').val())); //停车天数
  	}
});


/**  
  * 重构行编辑器  
  * @param rowIndex  
  */  
function setEditing(rowIndex, rowData){
	var editors = $('#doAccountDetailGrid').datagrid('getEditors', rowIndex);  
	var delEditor = editors[4];// 按钮  
	$(delEditor.target).linkbutton({iconCls:"icon-save"});  
	delEditor.target.bind("click",function(){
	$('#doAccountDetailGrid').datagrid('endEdit', rowIndex);
	accountTotal();//计算合计
	});
}  
    
//计算合计
function accountTotal() {
	$('#carOutPay_total').numberbox('setValue',compute("amount"));
}

//指定列求和
function compute(colName) {
	var rows = $('#doAccountDetailGrid').datagrid('getRows');
	var total = 0;
	var currCell;
	for (var i = 0; i < rows.length; i++) {
		if(isNaN(rows[i][colName]) || null == rows[i][colName] || "" == rows[i][colName]){
			currCell = 0
		}else{
			currCell = parseFloat(rows[i][colName]);
		}
		total += currCell;
	}
	return total;
}
    
/**
 * 付款提交
 */
function doPay(){
	$('#doAccountDetailGrid').datagrid('endEdit', editRow);//取消编辑行
	accountTotal();//计算费用总计
	
	var chargeType = $('#carOutPay_chargeType').combobox('getValue'); //计费项目
	if(chargeType == ""){
		$.messager.alert('错误','请先选择计费项目！','warning');
		return;
	}
	if(!before_doPayCheck()){ //付款提交校验
		return;
	}
	if($('#doAccountDetailGrid').datagrid('getRows').length <= 0){ //费用明细
		$.messager.alert('错误','费用明细为空，请先进行费用计算！','warning');
		return;
	}
	
	var diDays = dateDifference($('#carOutPay_outTime').val(),'${carInfo.outTime}');
	alert($('#carOutPay_outTime').val());
	alert('${carInfo.outTime}');
	alert(diDays);
	if(diDays > 7){
		$.messager.alert('错误','车辆出库日期与当前日期差距超过7天，请重新选择！','warning');
		return;
	}
	
	var payMode = $('#carOutPay_paymentMode').combobox('getValue');//付款方式
	if(payMode == ""){
		$.messager.alert('错误','请选择付款方式！','warning');
		return;
	}
	detail = JSON.stringify($('#doAccountDetailGrid').datagrid('getRows'));
	$('#payDetail').val(detail);//付款明细赋值，后台传参
	var f = parent.$.modalDialog.handler.find('#carOutPayForm');
	f.submit();
	$('#carOutPay_doPaybutton').linkbutton({disabled:true}); //提交后禁用确定按钮 防止重复提交
}

/**
 * 付款提交前校验 
 */
function before_doPayCheck(){
	var payMode = $('#carOutPay_paymentMode').combobox('getValue');//付款方式
	var isCredit = $('#carOut_selectIsCredit').val();//是否支持月结
	var total = $('#carOutPay_total').numberbox('getValue');//费用总计
	if(payMode == '2' && isCredit != '0'){
		$.messager.alert('错误','当前客户不支持月结付款，请确认！','warning');
		return false;
	}
	if(total > 0 && payMode == '0'){ //费用总额大于0时不允许免费
		$.messager.alert('错误','当前费用总计大于0，不允许免费通行！','warning');
		return false;
	}
	if(payMode == '9'){
		$.messager.alert('错误','付款方式选择错误，请重新选择！','warning');
		return false;
	}
	return true;
}
/**
 * 校验计费子项是否缺少必要的参数
 */
function itemsCheck(){
	if(null != itemsObj && itemsObj != 'undefined'){
		for(var o in itemsObj){
			if(itemsObj[o].itemParamCode == "HWJZ" && $('#carOutPay_netWeight').numberbox('getValue') == ""){//货物净重
				$.messager.alert('错误','净重不能为空！','warning');
				return false;
			}
			if(itemsObj[o].itemParamCode == "TCTS" && $('#carOutPay_parkDays').numberbox('getValue') == 0){//停车天数
				$.messager.alert('错误','请确认停车天数！','warning');
				return false;
			}
			if(itemsObj[o].itemParamCode == "DCTS" && 
					($('#carOutPay_stockDays').numberbox('getValue') == 0 || 
					 $('#carOutPay_goodsInTime').val() == "" || 
					 $('#carOutPay_goodsOutTime').val() == "")){//堆存天数
				$.messager.alert('错误','请确认堆存天数！','warning');
				return false;
			}
			if(itemsObj[o].itemParamCode == "HWSL" && 
					($('#carOutPay_goodsQuantity').numberbox('getValue') == 0 ||
					 $('#carOutPay_goodsQuantity').numberbox('getValue') == '')){ //货物数量
				$.messager.alert('错误','请确认数量！','warning');
				return false;
			}
		}
	}
	return true;
}

/**
 * 生成计费明细前校验
 */
function before_genDetailCheck(){
	var typeId = $('#carOutPay_chargeType').combobox('getValue');
	if(typeId == ''){
		$.messager.alert('错误','请选择计费项目！','warning');
		return false;
	}
	if(!itemsCheck()){
		return false;
	}
	return true;
}

/**
 * 生成计费明细
 */
function carOutGenDetailFun() {
	if(!before_genDetailCheck()){//提交前校验
		return;
	}
	genPayDetailGrid.datagrid('load', $.serializeObject($('#carOutPayForm')));
}

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
	$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
	accountTotal();
	$('#carOut_selectCustomerName').val('');//客户名称
	$('#carOut_selectCustomerId').val('');//客户id
	$('#carOut_selectIsCredit').val('');//是否支持月结
}

/**
 * 选择客户回调函数
 */
function selectCustomerCallback(data){
	var oldValue = $('#carOut_selectCustomerName').val();
	if(data.name != oldValue){
		$('#doAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
		accountTotal();
	}
	$('#carOut_selectCustomerName').val(data.name);//客户名称
	$('#carOut_selectCustomerId').val(data.id);//客户id
	$('#carOut_selectIsCredit').val(data.isCredit);//是否支持月结
}

/**
 *  点击选择入库车辆
 */
function btn_selectGoodsInCar(){
	$('#selectCarInfo').dialog({    
	    title: '选择车辆',    
	    width: 600,    
	    height: 400,    
	    closed: false,    
	    cache: false,    
	    href: '${path}/carInfo/selectCarInfoPage?isAllStatus=false',    
	    modal: true   
	});
}

/**
 * 清空车辆信息
 */
function btn_clearGoodsInCar(){
	$('#carOut_selectGoodsInCarNo').val(''); //车牌号码
	$('#carOut_selectGoodsInCarId').val(''); //车辆id
}

/**
 * 车辆信息回调函数
 */
function selectCarInfoCallback(data){
	$('#carOut_selectGoodsInCarNo').val(data.carNo);// 车牌号
	$('#carOut_selectGoodsInCarId').val(data.id);// 车辆id
	$('#carOut_selectCustomerId').val(data.customerId);// 客户id
	$('#carOut_selectCustomerName').val(data.customerName);// 客户名称
	$('#carOut_selectIsCredit').val(data.customerIsCredit);// 是否支持月结
	$('#carOutPay_goodsInTime').val(data.inTime);// 商品入库日期 = 车辆入库日期
	$('#carOutPay_goodsQuantity').numberbox('setValue',data.goodsQuantity); //件数/包
	$('#carOutPay_netWeight').numberbox('setValue',data.netWeight); //净重
	$('#carOutPay_waybillNo').val(data.waybillNo);//运单号
	$('#carOutPay_contractNo').val(data.contractNo);//合同号
	$('#carOutPay_goodsStoreNo').val(data.goodsStoreNo);//货位号
	$('#carOutPay_goodsName').combobox('setValue',data.goodsName); //货物名称
	if($("#carOutPay_location").val() == "FD"){
		$('#carOutPay_stockDays').numberbox('setValue',dateDifference2($('#carOutPay_goodsInTime').val(),$('#carOutPay_goodsOutTime').val()));
	}else{
		$('#carOutPay_stockDays').numberbox('setValue',dateDifference($('#carOutPay_goodsInTime').val(),$('#carOutPay_goodsOutTime').val()));
	}
}

   
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="fit:true,region:'center',border:false" title="" style="overflow: hidden;padding: 3px;width:750px; height:350px;">
        <form id="carOutPayForm" method="post">
            <table class="grid">
                <tr>
                    <td>车牌号</td>
                    <td><input id="carNo" name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true" style="width: 100px;" value="${carInfo.carNo}" readonly="readonly">
                     &nbsp;&nbsp;
                                                               是否年卡&nbsp;&nbsp;
                     <select id="carOutPay_isYearCard" name="isYearCard" class="easyui-combobox" data-options="width:50,editable:false,panelHeight:'auto'" readonly="readonly">
							<option value="0">是</option>
							<option value="1">否</option>
					 </select>
                    </td>
                    <td><font color="red">*</font>计费项目</td>
                	<td>
                		<select id="carOutPay_chargeType" name="chargeType" style="width: 140px; height: 22px;" class="easyui-combobox"></select>
                	</td>
                	
                </tr> 
                <tr>
                	<td>客户名称</td>
                	<td>
                		<input id="carOut_selectCustomerName" name="customerName" type="text" style="width: 140px;" readonly="readonly" value="${cust.name}" />
                		<input id="carOut_selectCustomerId" name="customerId" type="hidden" value="${cust.id}" />
                		<input id="carOut_selectIsCredit" name="isCredit" type="hidden" value="${cust.isCredit}" />
                		<a id="btn_selCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_selectCustomer()" >选择</a>
                		<a id="btn_clearCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_clearCustomer()" >清空</a>
                	</td>
                	<td>货物入库车辆</td>
                	<td>
                		<input id="carOut_selectGoodsInCarNo" name="goodsInCarNo" type="text" style="width: 90px;" readonly="readonly" />
                		<input id="carOut_selectGoodsInCarId" name="goodsInCarId" type="hidden"/>
                		<a id="btn_selGoodsInCar" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_selectGoodsInCar()" >选择</a>
                		<a id="btn_clearGoodsInCar" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_clearGoodsInCar()" >清空</a>
                	   &nbsp;&nbsp;       
                	           运单号
                		&nbsp;&nbsp;
                		<input id="carOutPay_waybillNo" name="waybillNo" type="text" class="easyui-validatebox span2" data-options="" style="width: 60px;text-align: right;">
                	</td>
                </tr>
                <tr>
                    <td>车辆入库日期</td>
                    <td>
                    	<input id="carOutPay_inTime" name="inTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;" value="${carInfo.inTime}" readonly="readonly" />
                    </td>
                    <td>车辆出库日期</td>
                	<td>
                		<input id="carOutPay_outTime" name="outTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;" value="${carInfo.outTime}" readonly="readonly" />
                		&nbsp;&nbsp;停车天数 &nbsp;&nbsp; <input id="carOutPay_parkDays" name="parkDays" type="text" class="easyui-numberbox span2" data-options="precision:0" style="width: 35px;" value="" readonly="readonly">
                	</td>
                	
                </tr> 
                <tr>
                    <td>商品入库日期</td>
                    <td>
                    	<input id="carOutPay_goodsInTime" name="goodsInTime" placeholder="点击选择时间" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;" readonly="readonly" />
                    </td>
                    <td>商品出库日期</td>
                	<td>
                		<input id="carOutPay_goodsOutTime" name="goodsOutTime" placeholder="点击选择时间" value="${carInfo.outTime}" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 140px;" readonly="readonly" />
                		&nbsp;&nbsp;堆存天数 &nbsp;&nbsp; <input id="carOutPay_stockDays" name="stockDays" type="text" class="easyui-numberbox span2" data-options="precision:0" style="width: 35px;" value="0" readonly="readonly">
                	</td>
                </tr> 
                <tr>
                <!-- 
                	<td><font color="red">*</font>车辆毛重(t)</td>
                	<td><input name="grossWeight" type="text" placeholder="请输入毛重" class="easyui-numberbox span2" data-options="precision:2" style="width: 140px;text-align: right;"></td>
                 -->
                	<td>货物净重(t)</td>
                	<td><input id="carOutPay_netWeight" name="netWeight" type="text" class="easyui-numberbox span2" data-options="min:0,precision:2" style="width: 80px;text-align: right;" value="${netWeight}">
                	    &nbsp;&nbsp;
                		件数/包/辆
                		&nbsp;&nbsp;
                		<input id="carOutPay_goodsQuantity" name="goodsQuantity" type="text"  class="easyui-numberbox span2" data-options="min:0,precision:0" style="width: 50px;text-align: right;">
                	</td>
                	<td>货物名称</td>
                	<td>
                		<select id="carOutPay_goodsName" name="goodsName" style="width: 100px; height: 22px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#carOutPay_goodsName').combobox('setValue','');" >清空</a>
                		&nbsp;&nbsp;
                		货位号
                		&nbsp;&nbsp;
                		<input id="carOutPay_goodsStoreNo" name="goodsStoreNo" type="text"class="easyui-validatebox span2" data-options="" style="width: 80px;text-align: right;">
                	</td>
                </tr>
                <tr>
                	<td>合同号</td>
                	<td><input id="carOutPay_contractNo" name="contractNo" type="text" class="easyui-validatebox span2" data-options="" style="width: 75px;text-align: right;">
                	    &nbsp;&nbsp;
                		出车单号
                		&nbsp;&nbsp;
                		<input name="outStockNo" type="text"  class="easyui-validatebox span2" data-options="" style="width: 75px;text-align: right;" value="${state.outStockNo}">
                	</td>
                	<td>出库说明</td>
                	<td><textarea rows="2" name="outRemark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
                <tr>
                	<td align="center" colspan="5">
                		<a id="doAccount" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="carOutGenDetailFun()">费用计算</a>
                	</td>
                </tr>
            </table>
            <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;width:750px; height:170px;">
        		<table id="doAccountDetailGrid" data-options="border:false" style="overflow: hidden;padding: 3px;width:750px; height:170px;"></table>
    		</div>
    		<div align="right">
        		<span stytle="colour:red">
        		费用总计：
        		<input id="carOutPay_total" name="total" class="easyui-numberbox" value="0" readonly="readonly"
        		 style="width: 100px;text-align: right;" data-options="min:0,precision:2">
        		</span>
        	</div>
    		<div>
    			<input id="carOutPay_id" name="id" type="hidden"  value="${carInfo.id}">
    			<input id="carOutPay_carStatus" name="carStatus" type="hidden"  value="${carInfo.carStatus}">
    			<input id="carOutPay_location" name="location" type="hidden"  value="${carInfo.location}">
    			<input id="payDetail" name="payDetail" type="hidden">
    		</div>
    		<div id="pay_linkbutton" style="margin:0 auto; width:200px;display:none ">
    			<font color="red">*</font>
    			<select id="carOutPay_paymentMode" name="paymentMode" class="easyui-combobox" style="height: 22px;" data-options="width:100,panelHeight:'auto'"></select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="carOutPay_doPaybutton" href="#" class="easyui-linkbutton" onclick="javascript:doPay()">确定</a>
    		</div>
        </form>
    </div>
</div>

<div id="selectBigCustomer"></div>
<div id="selectCarInfo"></div>