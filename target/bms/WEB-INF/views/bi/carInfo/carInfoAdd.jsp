<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#carInfoAddForm').form({
            url : '${path}/carInfo/add',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                //运通卡号未关联车牌号
                if($("#carInfoAdd_isYearCard").combobox('getValue') == '0' &&
                		$("#carInfoAdd_cardIdTemp").val() == "" &&
                		$("#carInfoAdd_cardNo").val() != "" &&
                		$("#carInfoAdd_carNo").val() != ""){
                	progressClose();
                	if(confirm("该运通卡号未关联该车牌号，是否增加此关联？")){
                		$("#carInfoAdd_isChange").val("1");
                	}else{
                		$("#carInfoAdd_isChange").val("0");
                	}
                	return true;
                }
                
                //运通卡号关联车牌号发生变化
                if($("#carInfoAdd_isYearCard").combobox('getValue') == '0' &&
                		$("#carInfoAdd_cardIdTemp").val() != "" &&
                		$("#carInfoAdd_cardNo").val() == $("#carInfoAdd_cardNoTemp").val() &&
                		$("#carInfoAdd_carNo").val() != $("#carInfoAdd_carNoTemp").val()){
                	progressClose();
                	if(confirm("该运通卡号关联车牌号发生改变，是否更新此关联？")){
                		$("#carInfoAdd_isChange").val("1");
                	}else{
                		$("#carInfoAdd_isChange").val("0");
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
                    //之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');
                    parent.$.modalDialog.handler.dialog('close');
                    window.parent.readCard4CarInfoList();//调用父窗体函数，初始化父窗体读卡器
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
        
        readCard4CarInfoAdd();//页面加载初始化读卡器
    });
    
    //读卡器初始化
    function readCard4CarInfoAdd(){
    	tcom.init(tcom.COMOBJ);
    	tcom.COMOBJ.OnDataIn = function (dat){
    		if(null != dat.data && dat.data != ""){
    			$("#carInfoAdd_cardNo").val(dat.data);
    			getCardLink4CarInfoAdd();
    			//tcommClose();//关闭串口
    		}
    	};
    }
    
  	//清空卡号
    function clearCardNo4CarInfoAdd(){
    	$("#carInfoAdd_cardNo").val("");//清空运通卡号
    	$("#carInfoAdd_cardIdTemp").val("");//清空已查询的运通卡Id
    	$("#carInfoAdd_cardNoTemp").val("");//清空已查询的运通卡号
		$("#carInfoAdd_carNoTemp").val("");//清空已查询的车牌号
    }
  	
  	//获取已关联的运通卡信息
  	function getCardLink4CarInfoAdd(){
  		$.ajax({
  	    	type : "get",
  	    	cache:false, 
  	    	async:true,//异步
  	    	dataType:'json',
  	    	data:{
  	    		'cardNo' : $("#carInfoAdd_cardNo").val()
  	    	},
  	    	url:'${path}/cardLink/getCardLinkByCardNo',
  	    	success:function(result, textStatus){
  	    		if (result.success) {
  	    			$("#carInfoAdd_cardIdTemp").val(result.obj.id);
  	    			$("#carInfoAdd_cardNoTemp").val(result.obj.cardNo);
  	    			$("#carInfoAdd_carNoTemp").val(result.obj.carNo);
  	    			$("#carInfoAdd_carNo").val(result.obj.carNo);
  	            }else{
  	            	$("#carInfoAdd_cardIdTemp").val("");
  	            	$("#carInfoAdd_cardNoTemp").val("");
  	    			$("#carInfoAdd_carNoTemp").val("");
  	    			$("#carInfoAdd_carNo").val("");
  	            }
  	    	}
  	    });
  	}
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="carInfoAddForm" method="post">
        	<div id="errorMsg" style="color:red;"></div>
            <table class="grid">
            	<tr>
                    <td>运通卡号</td>
                    <td>
                    	<input id="carInfoAdd_cardIdTemp" name="cardLinkId" type="hidden" />
                    	<input id="carInfoAdd_cardNoTemp" type="hidden" />
                    	<input id="carInfoAdd_carNoTemp" type="hidden" />
                    	<input id="carInfoAdd_isChange" name="isChange" type="hidden" />
                    	<input id="carInfoAdd_cardNo" name="cardNo" type="text" class="easyui-validatebox span2" readonly="readonly" />
                    	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4CarInfoAdd()">读卡</a>
                    	&nbsp;&nbsp;&nbsp;
                    	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:clearCardNo4CarInfoAdd()">清空</a>
                    </td>
                </tr> 
                <tr>
                    <td>车牌号</td>
                    <td><input id="carInfoAdd_carNo" name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true"></td>
                </tr> 
                <tr>
                    <td>是否年卡</td>
                    <td>
                    	<select id="carInfoAdd_isYearCard" name="isYearCard" class="easyui-combobox" data-options="width:100,editable:false,panelHeight:'auto'">
							<option value="0">是</option>
							<option value="1">否</option>
						</select>
                    </td>
                </tr> 
                <tr>
                	<td>入库说明</td>
                	<td><textarea rows="4" name="inRemark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>