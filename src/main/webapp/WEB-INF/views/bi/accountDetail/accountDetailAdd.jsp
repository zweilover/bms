<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//付款方式下拉选项
    	$('#accountDetailAdd_paymentMode').combobox({
            url : '${path }/dictionary/selectDiByCode',
            queryParams:{
            	"code": "FKFS"
            },
            valueField : 'code',
            textField : 'name',
            editable : false
        });
    	
        $('#accountDetailAddForm').form({
            url : '${path}/accountDetail/add',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                var isCheck = checkData();
                if (!isValid || !isCheck) {
                    progressClose();
                }
                return isValid && isCheck;
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
    });
    
    //提交前自定义校验
    function checkData(){
    	if($('#accountDetailAdd_selectCustomerName').val() == "" ||
    			$('#accountDetailAdd_selectCustomerId').val() == ""){
    		alert("请选择客户！");
    		return false;
    	}
    	if($('#accountDetailAdd_recordTime').val() == ""){
    		alert("请选择回款日期！");
    		return false;
    	}
    	if($('#accountDetailAdd_paymentMonth').val() == ""){
    		alert("请选择及回款月份！");
    		return false;
    	}
    	if($('#accountDetailAdd_paymentMode').combobox('getValue') == ""){
    		alert("请选择付款类型！");
    		return false;
    	}
    	return true;
    }
 
    /**
     *  点击选择客户按钮
     */
    function btn_ad_selectCustomer(){
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
    function btn_ad_clearCustomer(){
    	$('#accountDetailAdd_selectCustomerName').val('');//客户名称
    	$('#accountDetailAdd_selectCustomerId').val('');//客户id
    	// $('#carOut_selectIsCredit').val('');//是否支持月结
    }
    /**
     * 选择客户回调函数
     */
    function selectCustomerCallback(data){
    	$('#accountDetailAdd_selectCustomerName').val(data.name);//客户名称
    	$('#accountDetailAdd_selectCustomerId').val(data.id);//客户id
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="accountDetailAddForm" method="post">
        	<div id="errorMsg" style="color:red;"></div>
            <table class="grid">
                <tr>
                    <td><font color="red">*</font>客户名称</td>
                    <td>
                    	<input id="accountDetailAdd_selectCustomerName" name="customerName" type="text" style="width: 140px;" data-options="required:true" readonly="readonly">
                    	<input id="accountDetailAdd_selectCustomerId" name="customerId" type="hidden"/>
                    	<input name="paymentType" type="hidden" value="2"/>
                    	<a id="btn_ad_selCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_ad_selectCustomer()" >选择</a>
                		<a id="btn_ad_clearCustomer" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:btn_ad_clearCustomer()" >清空</a>
                    </td>
                </tr> 
                <tr>
                    <td><font color="red">*</font>回款金额</td>
                    <td>
                    	<input name="amount" type="text" placeholder="请输入金额" class="easyui-numberbox span2" style="width: 140px;" data-options="precision:2,min:0,required:true">
                    </td>
                </tr> 
                <tr>
                    <td><font color="red">*</font>回款日期</td>
                    <td>
                    	<input id="accountDetailAdd_recordTime" name="recordTime" placeholder="点击选择时间" onclick="WdatePicker({readOnly:true,required:true,dateFmt:'yyyy-MM-dd'})" style="width: 140px;">
                    </td>
                </tr> 
                <tr>
                    <td><font color="red">*</font>回款月份</td>
                    <td>
                    	<input id="accountDetailAdd_paymentMonth" name="paymentMonth" placeholder="" onclick="WdatePicker({readOnly:true,required:true,dateFmt:'yyyy-MM'})" style="width: 140px;">
                    </td>
                </tr> 
                <tr>
                    <td><font color="red">*</font>付款类型</td>
                    <td>
                    	<select id="accountDetailAdd_paymentMode" name="paymentMode" class="easyui-combobox" style="height: 22px;" data-options="width:100,panelHeight:'auto'"></select>
                    </td>
                </tr> 
                <tr>
                	<td>备注</td>
                	<td><textarea rows="3" style="width: 220px;" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>

<div id="selectBigCustomer"></div>