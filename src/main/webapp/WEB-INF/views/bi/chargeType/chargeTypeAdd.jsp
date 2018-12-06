<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	//计费项目所属区域下拉选项
    	$('#chargeTypeAddLocation').combobox({
	        url : '${path }/dictionary/selectDiByCode',
	        queryParams:{
	        	"code": "CKSZQY"
	        },
	        valueField : 'code',
	        textField : 'name',
	        editable : false
	    });    	
    	
    	
        $('#chargeTypeAddForm').form({
            url : '${path}/chargeType/add',
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
        <form id="chargeTypeAddForm" method="post">
            <table class="grid">
                <tr>
                    <td>计费项目名称</td>
                    <td><input name="name" type="text" placeholder="请输入计费项目名称" class="easyui-validatebox span2" data-options="required:true" value=""></td>
                	<td>排序</td>
                    <td><input name="seq" value="0" class="easyui-numberspinner"
						style="width: 140px; height: 29px;" required="required"
						data-options="editable:false"></td>
                </tr> 
                <tr>
                	<td>计费项目所属区域</td>
                	<td>
                		<select id="chargeTypeAddLocation" name="location" style="width: 140px; height: 29px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#chargeTypeAddLocation').combobox('setValue','');" >清空</a>
                	</td>
                	<td>状态</td>
                	<td>
                		<select name="status" class="easyui-combobox" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
							<option value="0">正常</option>
							<option value="1">停用</option>
						</select>
                	</td>
                </tr>
                <tr>
                	<td>计费项目描述</td>
                	<td><textarea rows="4" name="description" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>