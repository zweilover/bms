<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//所属区域下拉选项
    	$('#storeInfoAdd_location').combobox({
    		url : '${path}/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}',
    	});
    	
        $('#storeInfoAddForm').form({
            url : '${path}/store/storeInfoAdd',
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
        
        var localVal = $('#storeInfoAdd_location').combobox("getValue");
		if(localVal != null && localVal != ""){
			$('#storeInfoAdd_location').combobox({readonly: 'readonly'});
		}
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="storeInfoAddForm" method="post">
            <table class="grid">
                <tr>
                    <td><font color="red">*</font>库房名称</td>
                    <td><input name="name" type="text" class="easyui-validatebox span2" data-options="required:true"></td>
                    <td>排序</td>
                    <td>
                    	<input name="seq" value="0" class="easyui-numberspinner"
						style="width: 100px; height: 22px;" required="required"
						data-options="editable:false" />
                    </td>
                </tr> 
                <tr>
                	<td><font color="red">*</font>所属区域</td>
                	<td>
                		<select id="storeInfoAdd_location" name="location" style="width: 100px;" data-options="panelHeight:'auto'" class="easyui-combobox" required="required"></select>
                	</td>
                	<td>状态</td>
                	<td>
                		<select name="status" class="easyui-combobox" data-options="width:100,editable:false,panelHeight:'auto'">
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