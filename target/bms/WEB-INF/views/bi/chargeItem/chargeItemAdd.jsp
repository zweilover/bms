<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//计费子项所属区域下拉选项
    	$('#chargeItemAddLocation').combobox({
	        url : '${path }/dictionary/selectDiByCode',
	        queryParams:{
	        	"code": "CKSZQY"
	        },
	        valueField : 'code',
	        textField : 'name',
	        editable : false
	    });  
    	
    	//费用类型下拉选项
    	$('#chargeItemAdd_type').combobox({
	        url : '${path }/dictionary/selectDiByCode',
	        queryParams:{
	        	"code": "FYLX"
	        },
	        valueField : 'code',
	        textField : 'name',
	        required:true,
	        editable : false
	    });
    	//计费参数下拉选项
    	$('#chargeItemAdd_itemParamId').combobox({
	        url : '${path }/dictionary/selectDiByCode',
	        queryParams:{
	        	"code": "JFCS"
	        },
	        valueField : 'id',
	        textField : 'name',
	        editable : false
	    });
    	//js脚本参数下拉选项
    	$('#chargeItemAdd_itemScriptParamId').combobox({
	        url : '${path }/dictionary/selectDiByCode',
	        queryParams:{
	        	"code": "JFCS"
	        },
	        valueField : 'id',
	        textField : 'name',
	        editable : false
	    });
    	
        $('#chargeItemAddForm').form({
            url : '${path}/chargeItem/add',
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
        <form id="chargeItemAddForm" method="post">
        	<div id="errorMsg" style="color:red;"></div>
            <table class="grid">
                <tr>
                    <td><font color="red">*</font>子项名称</td>
                    <td><input name="name" type="text" placeholder="请输入子项名称" class="easyui-validatebox span2" data-options="required:true" value=""></td>
                    <td><font color="red">*</font>费用类型</td>
                	<td>
                		<select id="chargeItemAdd_type" name="type" style="width: 140px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#chargeItemAdd_type').combobox('setValue','');" >清空</a>
                	</td>
                </tr> 
                <tr>
                	<td>下限值</td>
                	<td>
                		<input name="minValue" type="text" class="easyui-numberbox span2" data-options="required:true" value="0">
                	</td>
                	<td>上限值</td>
                	<td><input name="maxValue" type="text" class="easyui-numberbox span2" data-options="required:true" value="0"></td>
                </tr>
                <tr>
                	<td><font color="red">*</font>价格</td>
                	<td><input name="cost" type="text" placeholder="请输入价格" class="easyui-numberbox span2" data-options="precision:2,required:true" value=""></td>
                	<td>状态</td>
                	<td>
                		<select name="status" class="easyui-combobox" data-options="width:140,editable:false,panelHeight:'auto'">
							<option value="0">正常</option>
							<option value="1">停用</option>
						</select>
					</td>	
                </tr>
                <tr>
                	<td>计费参数</td>
                	<td>
                		<select id="chargeItemAdd_itemParamId" name="itemParam" style="width: 140px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#chargeItemAdd_itemParamId').combobox('setValue','');" >清空</a>
                	</td>
                	<td>js脚本参数</td>
                	<td>
                		<select id="chargeItemAdd_itemScriptParamId" name="scriptParam" style="width: 140px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#chargeItemAdd_itemScriptParamId').combobox('setValue','');" >清空</a>
                	</td>
                </tr>
                <tr>
                	<td>描述</td>
                	<td><textarea rows="4" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                	<td>js脚本</td>
                	<td><textarea rows="4" name="scriptStr" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
                <tr>
                	<td>排序</td>
                    <td><input name="seq" value="0" class="easyui-numberspinner"
						style="width: 140px; " required="required"
						data-options="editable:false"></td>
					<td>所属区域</td>
					<td>
                		<select id="chargeItemAddLocation" name="location" style="width: 140px; " data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#chargeItemAddLocation').combobox('setValue','');" >清空</a>
                	</td>
                </tr>
            </table>
        </form>
    </div>
</div>