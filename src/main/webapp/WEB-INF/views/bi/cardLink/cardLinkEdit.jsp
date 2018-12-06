<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#cardLinkEditForm').form({
            url : '${path}/cardLink/edit',
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
        
        //赋值
        $("#cardLinkEdit_remark").val("${cardLink.remark}"); 
    });
   
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="cardLinkEditForm" method="post">
        	<div id="errorMsg" style="color:red;"></div>
            <table class="grid">
                <tr>
                    <td>运通卡号</td>
                    <td>
                    	<input name="id" type="hidden"  value="${cardLink.id}">
                    	<input id="cardLinkEdit_cardNo" name="cardNo" type="text" class="easyui-validatebox span2" data-options="required:true" readonly="readonly" value="${cardLink.cardNo}" />
                    </td>
                </tr> 
                <tr>
                    <td>车牌号</td>
                    <td><input name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true" value="${cardLink.carNo}" /></td>
                </tr>
                <tr>
                	<td>备注</td>
                	<td><textarea rows="4" id="cardLinkEdit_remark" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>