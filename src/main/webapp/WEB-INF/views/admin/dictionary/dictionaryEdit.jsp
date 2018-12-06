<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
    	$('#dictionaryEditPid').combotree({
	        url : '${path }/dictionary/tree',
	        parentField : 'pid',
	        lines : true,
	        panelHeight : 'auto',
	        value : '${dictionary.pid}'
	    });
    	
        $('#dictionaryEditForm').form({
            url : '${path}/dictionary/edit',
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
                    parent.$.modalDialog.openner_treeGrid.treegrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_treeGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
        
        $("#editStatus").val('${dictionary.status}'); 
        $("#dictionaryEdit_remark").val('${dictionary.remark}'); 
        
    });
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
        <form id="dictionaryEditForm" method="post">
        	<div id="errorMsg" style="color:red;"></div>
            <table class="grid">
				<tr>
					<td>字典名称</td>
					<input name="id" type="hidden"  value="${dictionary.id}" >
					<td><input name="name" type="text" placeholder="请输入字典名称" value="${dictionary.name}"
						class="easyui-validatebox span2" data-options="required:true"></td>
					<td>字典编号</td>
					<td><input name="code" type="text" placeholder="请输入字典编号" value="${dictionary.code}"
						class="easyui-validatebox span2" data-options="required:true"></td>
				</tr>
				<tr>
					<td>字典值</td>
					<td>
						<input name="value" type="text" style="width: 140px" class="easyui-validatebox" value="${dictionary.value}" >
					</td>
					
					<td>上级字典</td>
					<td>
						<select id="dictionaryEditPid" name="pid" style="width: 140px; height: 29px;" class="easyui-validatebox"></select>
						<a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#dictionaryEditPid').combotree('setValue','0');" >清空</a>
					</td>
				</tr>
				<tr>
					<td>排序</td>
					<td><input name="seq" class="easyui-numberspinner" value="${dictionary.seq}"
						style="width: 140px; height: 29px;" required="required"
						data-options="editable:false"></td>
					<td>状态</td>
					<td>
						<select id="editStatus" name="status" class="easyui-combobox" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
							<option value="0">正常</option>
							<option value="1">停用</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>字典说明</td>
					<td><textarea rows="2" id="dictionaryEdit_remark" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
				</tr>
			</table>
			
        </form>
    </div>
</div>