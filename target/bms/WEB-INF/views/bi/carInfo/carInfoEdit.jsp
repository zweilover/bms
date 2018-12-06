<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#carInfoEditForm').form({
            url : '${path}/carInfo/edit',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                if($("#carInfoEdit_carStatus").val() != '0'){
                	progressClose();
                	$.messager.alert('消息','车辆状态已变更，不允许编辑','info');
                	return false;
                }
                
                //运通卡号未关联车牌号
                if($("#carInfoEdit_isYearCard").combobox('getValue') == '0' &&
                		$("#carInfoEdit_cardIdTemp").val() == "" &&
                		$("#carInfoEdit_cardNo").val() != "" &&
                		$("#carInfoEdit_carNo").val() != ""){
                	progressClose();
                	if(confirm("该运通卡号未关联该车牌号，是否增加此关联？")){
                		$("#carInfoEdit_isChange").val("1");
                	}else{
                		$("#carInfoEdit_isChange").val("0");
                	}
                	return true;
                }
                
                //运通卡号关联车牌号发生变化
                if($("#carInfoEdit_isYearCard").combobox('getValue') == '0' &&
                		$("#carInfoEdit_cardIdTemp").val() != "" &&
                		$("#carInfoEdit_cardNo").val() == $("#carInfoEdit_cardNoTemp").val() &&
                		$("#carInfoEdit_carNo").val() != $("#carInfoEdit_carNoTemp").val()){
                	progressClose();
                	if(confirm("该运通卡号关联车牌号发生改变，是否更新此关联？")){
                		$("#carInfoEdit_isChange").val("1");
                	}else{
                		$("#carInfoEdit_isChange").val("0");
                	}
                	return true;
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
                    window.parent.readCard4CarInfoList();//调用父窗体函数，初始化父窗体读卡器
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
        
        $("#carInfoEdit_isYearCard").val('${carInfo.isYearCard}'); 
        $("#carInfoEdit_inRemark").val("${carInfo.inRemark}"); 
        
        readCard4CarInfoEdit();//页面加载初始化读卡器
    });
   	//读卡器初始化
    function readCard4CarInfoEdit(){
    	tcom.init(tcom.COMOBJ);
    	tcom.COMOBJ.OnDataIn = function (dat){
    		if(null != dat.data && dat.data != ""){
    			$("#carInfoEdit_cardNo").val(dat.data);
    			getCardLink4CarInfoEdit();
    			// tcommClose();//关闭串口
    		}
    	};
    }
  	//清空卡号
    function clearCardNo4CarInfoEdit(){
    	$("#carInfoEdit_cardNo").val("");//清空运通卡号
    	$("#carInfoEdit_cardIdTemp").val("");//清空已查询的运通卡Id
    	$("#carInfoEdit_cardNoTemp").val("");//清空已查询的运通卡号
		$("#carInfoEdit_carNoTemp").val("");//清空已查询的车牌号
    }
  	
  	//获取已关联的运通卡信息
  	function getCardLink4CarInfoEdit(){
  		$.ajax({
  	    	type : "get",
  	    	cache:false, 
  	    	async:true,//异步
  	    	dataType:'json',
  	    	data:{
  	    		'cardNo' : $("#carInfoEdit_cardNo").val()
  	    	},
  	    	url:'${path}/cardLink/getCardLinkByCardNo',
  	    	success:function(result, textStatus){
  	    		if (result.success) {
  	    			$("#carInfoEdit_cardIdTemp").val(result.obj.id);
  	    			$("#carInfoEdit_cardNoTemp").val(result.obj.cardNo);
  	    			$("#carInfoEdit_carNoTemp").val(result.obj.carNo);
  	    			$("#carInfoEdit_carNo").val(result.obj.carNo);
  	            }else{
  	            	$("#carInfoEdit_cardIdTemp").val("");
  	            	$("#carInfoEdit_cardNoTemp").val("");
  	    			$("#carInfoEdit_carNoTemp").val("");
  	    			$("#carInfoEdit_carNo").val("");
  	            }
  	    	}
  	    });
  	}
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
        <form id="carInfoEditForm" method="post">
            <table class="grid">
            	<tr>
                    <td>运通卡号</td>
                    <td>
                    	<input id="carInfoEdit_cardIdTemp" name="cardLinkId" type="hidden" value="${cardLink.id}" />
                    	<input id="carInfoEdit_cardNoTemp" type="hidden" value="${cardLink.cardNo}" />
                    	<input id="carInfoEdit_carNoTemp" type="hidden" value="${cardLink.carNo}" />
                    	<input id="carInfoEdit_isChange" name="isChange" type="hidden">
                    	
                    	<input id="carInfoEdit_cardNo" name="cardNo" type="text" class="easyui-validatebox span2" readonly="readonly" value="${carInfo.cardNo}" />
                    	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4CarInfoEdit()">读卡</a>
                    	&nbsp;&nbsp;&nbsp;
                    	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:clearCardNo4CarInfoEdit()">清空</a>
                    </td>
                </tr> 
                <tr>
                	<input name="id" type="hidden"  value="${carInfo.id}">
                	<input id="carInfoEdit_carStatus" name="carStatus" type="hidden"  value="${carInfo.carStatus}">
                    <td>车牌号</td>
                    <td><input id="carInfoEdit_carNo" name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true" value="${carInfo.carNo}"></td>
                </tr> 
                <tr>
                    <td>是否年卡</td>
                    <td>
                    	<select id="carInfoEdit_isYearCard" name="isYearCard" class="easyui-combobox" data-options="width:100,editable:false,panelHeight:'auto'">
							<option value="0">是</option>
							<option value="1">否</option>
						</select>
                    </td>
                </tr> 
                <tr>
                	<td>入库说明</td>
                	<td><textarea rows="4" id="carInfoEdit_inRemark" name="inRemark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>