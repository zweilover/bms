<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#importRcDataForm').form({
            url : '${path}/checkData/importRcDataExcel',
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
        <form id="importRcDataForm" method="post" enctype="multipart/form-data">
            <table class="grid">
                <tr>
                	<input type="hidden" name="type" value="RCIMP">
                    <td>入仓数据文件</td>
                    <td><input class="easyui-filebox" name="file" data-options="buttonText:'选择文件',prompt:'请选择.xls或.xlsx后缀的文件'" style="width:100%"></td>
                </tr> 
                <tr>
                	<td>出仓导入说明</td>
                	<td><textarea rows="4" name="remark" onkeydown="disabledEnterKey(event)" style="width:80%"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>