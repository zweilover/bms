<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//脚本下拉选项
    	$('#scriptParamId').combobox({
	        url : '${path }/dictionary/selectDiByCode',
	        queryParams:{
	        	"code": "JFCS"
	        },
	        valueField : 'id',
	        textField : 'name',
	        editable : false
	    });
    	
    	//优惠项目下拉选项
    	$('#itemId').combobox({
	        url : '${path }/chargeItem/allItems',
	        valueField : 'id',
	        textField : 'name',
	        editable : false
	    });
    	
        $('#bigCustomerAddForm').form({
            url : '${path}/bigCustomer/add',
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
                    //之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="bigCustomerAddForm" method="post">
            <table class="grid">
                <tr>
                    <td><font color="red">*</font>客户名称</td>
                    <td><input name="name" type="text" placeholder="请输入客户名称" class="easyui-validatebox span2" data-options="required:true"></td>
                    <td>排序</td>
                    <td>
                    	<input name="seq" value="0" class="easyui-numberspinner"
						style="width: 100px; height: 22px;" required="required"
						data-options="editable:false">
                    </td>
                </tr> 
                <tr>
                	<td>联系方式</td>
                	<td>
                		<input id="telephone" name="telephone" style="width: 140px;" class="easyui-textbox"></input>
                	</td>
                	<td>通信地址</td>
                	<td><input id="address" name="address" style="width: 140px;" class="easyui-textbox"></td>
                </tr>
                <tr>
                	<td><font color="red">*</font>是否支持月结</td>
                	<td>
                		<select name="isCredit" class="easyui-combobox" data-options="width:140,editable:false,panelHeight:'auto'">
							<option value="0">是</option>
							<option value="1" selected="selected">否</option>
						</select>
                	</td>
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
        </form>
    </div>
</div>