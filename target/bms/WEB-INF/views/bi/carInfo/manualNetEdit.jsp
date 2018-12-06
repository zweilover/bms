<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#manualNetEditForm').form({
            url : '${path}/carInfo/manualNetEdit',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                if($("#manualNetEdit_carStatus").val() != '0'){
                	progressClose();
                	$.messager.alert('消息','车辆状态已变更，不允许录入','info');
                	return false;
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
        
        $("#manualNetEdit_isYearCard").val('${carInfo.isYearCard}'); 
        $("#manualNetEdit_inRemark").val("${carInfo.inRemark}"); 
       
    });
  	
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
        <form id="manualNetEditForm" method="post">
            <table class="grid">
            	<tr>
                    <td>运通卡号</td>
                    <td>
                    	<input id="manualNetEdit_cardNo" name="cardNo" type="text" class="easyui-validatebox span2" readonly="readonly" value="${carInfo.cardNo}" />
                    </td>
                </tr> 
                <tr>
                	<input name="id" type="hidden"  value="${carInfo.id}">
                	<input name="location" type="hidden"  value="${carInfo.location}">
                	<input id="manualNetEdit_carStatus" name="carStatus" type="hidden"  value="${carInfo.carStatus}">
                    <td>车牌号</td>
                    <td><input id="manualNetEdit_carNo" name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" readonly="readonly" value="${carInfo.carNo}"></td>
                </tr> 
                <tr>
                    <td>是否年卡</td>
                    <td>
                    	<select id="manualNetEdit_isYearCard" name="isYearCard" class="easyui-combobox" data-options="width:100,editable:false,panelHeight:'auto'" readonly="readonly">
							<option value="0">是</option>
							<option value="1">否</option>
						</select>
                    </td>
                </tr>
                <tr>
                    <td>货物净重(吨)</td>
                    <td><input id="manualNetEdit_manualNetweight" name="manualNetweight" type="text" class="easyui-numberbox span2" data-options="min:0,precision:2,required:true" style="text-align: right;" value="${carInfo.manualNetweight}"></td>
                </tr>  
                <tr>
                	<td>入库说明</td>
                	<td><textarea rows="3" id="manualNetEdit_inRemark" name="inRemark" style="width: 220px;" readonly="readonly"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>