<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
var genYundiDetailGrid;
var detail;
var itemsObj;//计费子项集合对象
var editRow; //编辑行
$(function(){
	//计费货物名称下拉选项
	$('#charge4Yundi_goodsName').combobox({
        url : '${path }/dictionary/selectDiByCode',
        queryParams:{
        	"code": "HWMC"
        },
        valueField : 'id',
        textField : 'name',
        editable : false
    });
	
	//付款方式下拉选项
	$('#charge4Yundi_paymentMode').combobox({
        url : '${path }/dictionary/selectDiByCode',
        queryParams:{
        	"code": "FKFS"
        },
        valueField : 'code',
        textField : 'name',
        editable : false
    });
	
	//计费项目下拉选项
	$('#charge4Yundi_chargeType').combobox({
		/**
        url : '${path }/chargeType/selectAllChargeType',
        queryParams:{
        	"isAllStatus": false
        },
        **/
        data : [
             {'id':'16','name':'SQ_运抵费'},
             {'id':'31','name':'SQ_卡玛斯重车停车'}
        ],
        valueField : 'id',
        textField : 'name',
        editable : false,
        required:true,
        onChange : function(newValue,OldValue){
        	$('#yundiAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
        	var typeId = $('#charge4Yundi_chargeType').combobox('getValue');
        	$.ajax({
        		url : '${path }/chargeItem/selectItemsByChargeType?typeId='+typeId,
        		success : function(data,textStatus,jqXHR){
        			itemsObj = eval("("+data+")");
        		}
        	});
        }
    });
	
	//生成计费明细
	genYundiDetailGrid = $("#yundiAccountDetailGrid").datagrid({
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
        	width : '120',
            title : '计费项目名称',
            field : 'itemName'
        },{
        	width : '60',
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
        	width : '60',
        	title : '数量',
        	field : 'count',
        	editor :{
        		'type' : 'numberbox',
        		'options' :{
        			precision:2
        		}
        	}
        },{
        	width : '60',
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
        	width : '300',
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
        	$('#yundiAccountDetailGrid').datagrid('endEdit', editRow);//结束编辑行
        	if (rowData.isEditable == true) {
        		$('#yundiAccountDetailGrid').datagrid("beginEdit", index);//开始编辑行
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
            var editors = $('#yundiAccountDetailGrid').datagrid('getEditors', rowIndex);  
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
        	$('#yundiAccountDetailGrid').datagrid('loadData',{total:0,rows:[]});//清空列表
        	$('#charge4Yundi_total').numberbox('setValue','0');//费用总计置0
        	$('#pay_linkbutton').hide();//隐藏支付按钮
        }
	});
	
	//车辆入库日期事件
	$('#charge4Yundi_inTime').blur(function(){
		$('#charge4Yundi_parkDays').numberbox('setValue',dateDifference($('#charge4Yundi_inTime').val(),$('#charge4Yundi_outTime').val()));
	});
	
	//form提交
    $('#charge4YundiForm').form({
        url : '${path}/carInfo/dealPayment?type=yundi',
        onSubmit : function() {
            progressLoad();
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
                parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                parent.$.modalDialog.handler.dialog('close');
            } else {
            	$.messager.alert('错误',result.msg,'warning');
            }
        }
    });
	
  	//赋值
    $("#charge4Yundi_isYearCard").val('${carInfo.isYearCard}'); 
    $('#charge4Yundi_parkDays').val(dateDifference($('#charge4Yundi_inTime').val(),$('#charge4Yundi_outTime').val())); //停车天数
});


/**  
  * 重构行编辑器  
  * @param rowIndex  
  */  
function setEditing(rowIndex, rowData){
	var editors = $('#yundiAccountDetailGrid').datagrid('getEditors', rowIndex);  
	var delEditor = editors[4];// 按钮  
	$(delEditor.target).linkbutton({iconCls:"icon-save"});  
	delEditor.target.bind("click",function(){
	$('#yundiAccountDetailGrid').datagrid('endEdit', rowIndex);
	accountTotal();//计算合计
	});
}  
    
//计算合计
function accountTotal() {
	$('#charge4Yundi_total').numberbox('setValue',compute("amount"));
}

//指定列求和
function compute(colName) {
	var rows = $('#yundiAccountDetailGrid').datagrid('getRows');
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
	$('#yundiAccountDetailGrid').datagrid('endEdit', editRow);//取消编辑行
	accountTotal();//计算费用总计
	
	var chargeType = $('#charge4Yundi_chargeType').combobox('getValue'); //计费项目
	if(chargeType == ""){
		$.messager.alert('错误','请先选择计费项目！','warning');
		return;
	}
	if(!before_doPayCheck()){ //付款提交校验
		return;
	}
	if($('#yundiAccountDetailGrid').datagrid('getRows').length <= 0){ //费用明细
		$.messager.alert('错误','费用明细为空，请先进行费用计算！','warning');
		return;
	}
	var payMode = $('#charge4Yundi_paymentMode').combobox('getValue');//付款方式
	if(payMode == ""){
		$.messager.alert('错误','请选择付款方式！','warning');
		return;
	}
	detail = JSON.stringify($('#yundiAccountDetailGrid').datagrid('getRows'));
	$('#payDetail').val(detail);//付款明细赋值，后台传参
	var f = parent.$.modalDialog.handler.find('#charge4YundiForm');
	f.submit();
}

/**
 * 付款提交前校验 
 */
function before_doPayCheck(){
	var payMode = $('#charge4Yundi_paymentMode').combobox('getValue');//付款方式
	var isCredit = $('#charge4Yundi_selectIsCredit').val();//是否支持月结
	var total = $('#charge4Yundi_total').numberbox('getValue');//费用总计
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
 * 生成计费明细前校验
 */
function before_genDetailCheck(){
	var typeId = $('#charge4Yundi_chargeType').combobox('getValue');
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
 * 校验计费子项是否缺少必要的参数
 */
function itemsCheck(){
	var flag = true;
	if(null != itemsObj && itemsObj != 'undefined'){
		for(var o in itemsObj){
			if(itemsObj[o].itemParamCode == "TCTS" && $('#charge4Yundi_parkDays').numberbox('getValue') == 0){//停车天数
				$.messager.alert('错误','请确认停车天数！','warning');
				flag = false;
			}
		}
	}
	return  flag;
}

/**
 * 生成计费明细
 */
function charge4YundiGenDetailFun() {
	if(!before_genDetailCheck()){//提交前校验
		return;
	}
	genYundiDetailGrid.datagrid('load', $.serializeObject($('#charge4YundiForm')));
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
	$('#charge4Yundi_selectCustomerName').val('');//客户名称
	$('#charge4Yundi_selectCustomerId').val('');//客户id
	$('#charge4Yundi_selectIsCredit').val('');//是否支持月结
}

/**
 * 选择客户回调函数
 */
function selectCustomerCallback(data){
	$('#charge4Yundi_selectCustomerName').val(data.name);//客户名称
	$('#charge4Yundi_selectCustomerId').val(data.id);//客户id
	$('#charge4Yundi_selectIsCredit').val(data.isCredit);//是否支持月结
}
   
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="fit:true,region:'center',border:false" title="" style="overflow: hidden;padding: 3px;width:750px; height:350px;">
        <form id="charge4YundiForm" method="post">
            <table class="grid">
                <tr>
                    <td>车牌号</td>
                    <td><input id="carNo" name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true" style="width: 100px;" value="${carInfo.carNo}" readonly="readonly">
                     &nbsp;&nbsp;
                                                               是否年卡&nbsp;&nbsp;
                     <select id="charge4Yundi_isYearCard" name="isYearCard" class="easyui-combobox" data-options="width:50,editable:false,panelHeight:'auto'" readonly="readonly">
							<option value="0">是</option>
							<option value="1">否</option>
					 </select>
                    </td>
                    <td><font color="red">*</font>计费项目</td>
                	<td>
                		<select id="charge4Yundi_chargeType" name="chargeType" data-options="panelHeight:'auto'" style="width: 140px; height: 22px;" class="easyui-combobox"></select>
                	</td>
                	
                </tr> 
                <tr>
                	<td>客户名称</td>
                	<td>
                		<input id="charge4Yundi_selectCustomerName" name="customerName" type="text" style="width: 120px;" readonly="readonly" />
                		<input id="charge4Yundi_selectCustomerId" name="customerId" type="hidden"/>
                		<input id="charge4Yundi_selectIsCredit" name="isCredit" type="hidden"/>
                		<a id="btn_selCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_selectCustomer()" >选择</a>
                		<a id="btn_clearCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_clearCustomer()" >清空</a>
                	</td>
                	<td>货物名称</td>
                	<td>
                		<select id="charge4Yundi_goodsName" name="goodsName" style="width: 100px; height: 22px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#charge4Yundi_goodsName').combobox('setValue','');" >清空</a>
                		&nbsp;&nbsp;
                		货位号
                		&nbsp;&nbsp;
                		<input id="charge4Yundi_goodsStoreNo" name="goodsStoreNo" type="text"class="easyui-validatebox span2" data-options="" style="width: 40px;text-align: right;">
                	</td>
                </tr>
                <tr>
                    <td>车辆入库日期</td>
                    <td>
                    	<input id="charge4Yundi_inTime" name="inTime" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd HH:mm:ss'})" style="width: 120px;" value="${carInfo.inTime}" readonly="readonly" />
                    </td>
                    <td>车辆出库日期</td>
                	<td>
                		<input id="charge4Yundi_outTime" name="outTime" style="width: 120px;" value="${carInfo.outTime}" readonly="readonly" />
                		&nbsp;&nbsp;停车天数 &nbsp;&nbsp; <input id="charge4Yundi_parkDays" name="parkDays" type="text" class="easyui-numberbox span2" data-options="precision:0" style="width: 35px;" value="" readonly="readonly">
                	</td>
                	
                </tr>
                <tr>
                	<td align="center" colspan="5">
                		<a id="doAccount" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="charge4YundiGenDetailFun()">费用计算</a>
                	</td>
                </tr>
            </table>
            <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;width:700px; height:120px;">
        		<table id="yundiAccountDetailGrid" data-options="border:false" style="overflow: hidden;padding: 3px;width:700px; height:120px;"></table>
    		</div>
    		<div align="right">
        		<span stytle="colour:red">
        		费用总计：
        		<input id="charge4Yundi_total" name="total" class="easyui-numberbox" value="0" readonly="readonly"
        		 style="width: 100px;text-align: right;" data-options="min:0,precision:2">
        		</span>
        	</div>
    		<div>
    			<input id="charge4Yundi_id" name="id" type="hidden"  value="${carInfo.id}">
    			<input id="charge4Yundi_carStatus" name="carStatus" type="hidden"  value="${carInfo.carStatus}">
    			<input id="charge4Yundi_location" name="location" type="hidden"  value="${carInfo.location}">
    			<input id="payDetail" name="payDetail" type="hidden">
    		</div>
    		<div id="pay_linkbutton" style="margin:0 auto; width:200px;display:none ">
    			<font color="red">*</font>
    			<select id="charge4Yundi_paymentMode" name="paymentMode" class="easyui-combobox" style="height: 22px;" data-options="width:100,panelHeight:'auto'"></select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a id="doPay" href="#" class="easyui-linkbutton" onclick="javascript:doPay()">确定</a>
    		</div>
        </form>
    </div>
</div>

<div id="selectBigCustomer"></div>
<div id="selectCarInfo"></div>