<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
$(function() {
    $('#manualMatchCcDataForm').form({
        url : '${path}/checkData/dealManualMatchCcData',
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
    $("#manualMatchCcData_remark").val("${matchCcData.remark}");
});

/**
 * 未关联车辆时，匹配说明为必输项
 */
function validRemarkRequired(){
	var carId = $("#manualMatchCcData_carId").val();
	var remark = $("#manualMatchCcData_remark").val().replace(/\s+/g,"");
	if((carId == null || carId == "") && remark == ""){
		return true;
	}
	return false;
}

/**
 * 点击选择关联车辆列表
 */
function selectMatchCcPickList(){
	$('#selectManualMatchCcPickList').dialog({    
	    title: '选择关联出库车辆',    
	    width: 700,    
	    height: 500,    
	    closed: false,    
	    cache: false,    
	    href: '${path}/checkData/selectMatchCcPickListPage?ccsj='+'${ccsj}'+'&location='+'${location}',    
	    modal: true   
	});
}

/**
 * 选择关联出库车辆回调函数
 */
function selectMatchCcPickCallback(rowData){
	$('#manualMatchCcData_carId').val(rowData.id);//匹配车辆id
	$('#manualMatchCcData_carNo').val(rowData.car_no);//匹配车牌号
}

/**
 * 清空匹配车辆信息
 */
function clearMatchCcPickData(){
	$('#manualMatchCcData_carId').val('');//匹配车辆id
	$('#manualMatchCcData_carNo').val('');//匹配车牌号
}


    
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="manualMatchCcDataForm" method="post" enctype="multipart/form-data">
            <table class="grid">
                <tr>
                	<input type="hidden" name="id" value="${matchCcData.id}" />
                	<input type="hidden" name="type" value="${matchCcData.type}" />
                	<input type="hidden" name="createUser" value="${matchCcData.createUser}" />
                	<input type="hidden" name="createTime" value="${matchCcData.createTime}" />
                	<input type="hidden" name="updateUser" value="${matchCcData.updateUser}" />
                	<input type="hidden" name="updateTime" value="${matchCcData.updateTime}" />
                	<input type="hidden" name="ccId" value="${ccId}" />
                	<input type="hidden" name="ccsj" value="${ccsj}" />
                	<input type="hidden" name="location" value="${location}" />
                    <td>出仓车牌号</td>
                    <td><input name="ccNo" style="width: 140px;" value="${ccNo}" readonly="readonly" /></td>
                </tr> 
                <tr>
                	<input id="manualMatchCcData_carId" type="hidden" name="carId" value="${matchCcData.carId}" />
                	<td>匹配车牌号</td>
                    <td><input id="manualMatchCcData_carNo" name="carNo" style="width: 140px;" value="${matchCcData.carNo}" readonly="readonly" />
                    <a id="btn_selectManualMatchCcDataList" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:selectMatchCcPickList()">选择</a>
                	<a id="btn_clearManualMatchCcData" class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:clearMatchCcPickData()">清空</a>
                	</td>
                </tr>
                <tr>
                	<td>匹配说明</td>
                	<td><textarea id="manualMatchCcData_remark" rows="4" name="remark" onkeydown="disabledEnterKey(event)" style="width:80%"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>

<div id="selectManualMatchCcPickList"></div>