<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//优惠项目下拉选项
    	$('#custItemIdAdd').combobox({
	        url : '${path }/chargeItem/allItems',
	        valueField : 'id',
	        textField : 'name',
	        editable : false
	    });
    	
        $('#customerItemAddForm').form({
            url : '${path}/bigCustomer/addCustItem',
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
                    parent.bigCustomerItemGrid.datagrid('reload');//父页面已经定义好bigCustomerItemGrid对象
                    $('#custItemAddPage').window('close');//关闭当前窗体
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
    });
    
function doSubmit(){
	//var f = parent.$.modalDialog.handler.find('#customerItemAddForm');
	$('#customerItemAddForm').submit();
}
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="customerItemAddForm" method="post">
            <table class="grid">
            	<tr>
            		<input id="customerId" name="customerId" type="hidden"  value="${bigCustomer.id}">
            		<td>客户名称</td>
            		<td>
            			<input id="customerName" name="customerName" type="text" class="easyui-validatebox span2" data-options="required:true" style="width: 140px;" value="${bigCustomer.name}" readonly="readonly">
            		</td>
            	</tr>
                <tr>
                    <td><font color="red">*</font>计费子项</td>
                    <td>
                    	<select id="custItemIdAdd" name="itemId" style="width: 180px; height: 22px;" data-options="required:true" class="easyui-combobox"></select>
                    </td>
                </tr> 
                <tr>
                	<td><font color="red">*</font>优惠价格</td>
                	<td>
                		<input name="price" type="text" placeholder="请输入优惠价格" style="width: 140px;" class="easyui-numberbox span2" data-options="precision:2,required:true">
                	</td>
                </tr>
                <tr>
                	<td>状态</td>
                	<td>
                		<select name="status" class="easyui-combobox" data-options="width:140,editable:false,panelHeight:'auto'">
							<option value="0">正常</option>
							<option value="1">停用</option>
						</select>
                	</td>
                </tr>
                <tr>
                	<td>备注</td>
                	<td><textarea rows="2" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
            <div id="addCustItem_linkbutton" style="margin:0 auto; width:50px;">
    			<a id="doSubmit" href="#" class="easyui-linkbutton" onclick="javascript:doSubmit()">确定</a>
    		</div>
        </form>
    </div>
</div>