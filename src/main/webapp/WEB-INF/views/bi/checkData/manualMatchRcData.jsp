<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
$(function() {
    $('#manualMatchRcDataForm').form({
        url : '${path}/checkData/dealManualMatchRcData',
        onSubmit : function() {
            progressLoad();
            var isValid = $(this).form('validate');
            if (!isValid) {
                progressClose();
            }
            if(validRemarkRequired()){
            	progressClose();
            	$.messager.alert('警告','未关联车辆，请填写匹配说明！','warning');
            	return false;
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
    $("#manualMatchRcData_remark").val("${MatchRcData.remark}");
});

/**
 * 未关联车辆时，匹配说明为必输项
 */
function validRemarkRequired(){
	var carId = $("#manualMatchRcData_carId").val();
	var remark = $("#manualMatchRcData_remark").val().replace(/\s+/g,"");
	if((carId == null || carId == "") && remark == ""){
		return true;
	}
	return false;
}

/**
 * 点击选择关联车辆列表
 */
function selectMatchRcPickList(){
	$('#selectManualMatchRcPickList').dialog({    
	    title: '选择关联出库车辆',    
	    width: 700,    
	    height: 500,    
	    closed: false,    
	    cache: false,    
	    href: '${path}/checkData/selectMatchRcPickListPage?rcsj='+'${rcsj}'+'&location='+'${location}',    
	    modal: true   
	});
}

/**
 * 选择关联出库车辆回调函数
 */
function selectMatchRcPickCallback(rowData){
	$('#manualMatchRcData_carId').val(rowData.id);//匹配车辆id
	$('#manualMatchRcData_carNo').val(rowData.car_no);//匹配车牌号
}

/**
 * 清空匹配车辆信息
 */
function clearMatchRcPickData(){
	$('#manualMatchRcData_carId').val('');//匹配车辆id
	$('#manualMatchRcData_carNo').val('');//匹配车牌号
}


    
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="manualMatchRcDataForm" method="post" enctype="multipart/form-data">
            <table class="grid">
                <tr>
                	<input type="hidden" name="id" value="${matchRcData.id}" />
                	<input type="hidden" name="type" value="${matchRcData.type}" />
                	<input type="hidden" name="createUser" value="${matchRcData.createUser}" />
                	<input type="hidden" name="createTime" value="${matchRcData.createTime}" />
                	<input type="hidden" name="updateUser" value="${matchRcData.updateUser}" />
                	<input type="hidden" name="updateTime" value="${matchRcData.updateTime}" />
                	<input type="hidden" name="rcId" value="${rcId}" />
                	<input type="hidden" name="rcsj" value="${rcsj}" />
                	<input type="hidden" name="location" value="${location}" />
                    <td>入仓车牌号</td>
                    <td><input name="rcNo" style="width: 140px;" value="${rcNo}" readonly="readonly" /></td>
                </tr> 
                <tr>
                	<input id="manualMatchRcData_carId" type="hidden" name="carId" value="${matchRcData.carId}" />
                	<td>匹配车牌号</td>
                    <td><input id="manualMatchRcData_carNo" name="carNo" style="width: 140px;" value="${matchRcData.carNo}" readonly="readonly" />
                    <a id="btn_selectManualMatchRcDataList" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:selectMatchRcPickList()">选择</a>
                	<a id="btn_clearManualMatchRcData" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:clearMatchRcPickData()">清空</a>
                	</td>
                </tr>
                <tr>
                	<td>匹配说明</td>
                	<td><textarea id="manualMatchRcData_remark" rows="4" name="remark" onkeydown="disabledEnterKey(event)" style="width:80%"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>

<div id="selectManualMatchRcPickList"></div>