<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {
        $('#cardLinkAddForm').form({
            url : '${path}/cardLink/add',
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
                    window.parent.readCard4CardLinkList();//调用父窗体函数，初始化父窗体读卡器串口
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
        
        readCard4CardLinkAdd(); //页面加载初始化读卡器
    });
    
    //运通卡新增-
    function readCard4CardLinkAdd(){
    	tcom.init(tcom.COMOBJ);
    	tcom.COMOBJ.OnDataIn = function (dat){
    		if(null != dat.data && dat.data != ""){
    			$("#cardLinkAdd_cardNo").val(dat.data);
    			// tcommClose();//关闭串口
    		}
    	};
    	
    }
    //清空卡号
    function clearCardNo4CardLinkAdd(){
    	$("#cardLinkAdd_cardNo").val("");//清空运通卡号
    }
</script>
<div class="easyui-layout" data-options="fit:true,border:false" >
    <div data-options="region:'center',border:false" style="overflow: hidden;padding: 3px;" >
        <form id="cardLinkAddForm" method="post">
        	<div id="errorMsg" style="color:red;"></div>
            <table class="grid">
                <tr>
                    <td>运通卡号</td>
                    <td>
                    	<input id="cardLinkAdd_cardNo" name="cardNo" type="text" class="easyui-validatebox span2" data-options="required:true" readonly="readonly" />
                    	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4CardLinkAdd()" >读卡</a>
                    	&nbsp;&nbsp;&nbsp;
                    	<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:clearCardNo4CardLinkAdd()" >清空</a>
                    </td>
                </tr> 
                <tr>
                    <td>车牌号</td>
                    <td><input name="carNo" type="text" placeholder="请输入车牌号" class="easyui-validatebox span2" data-options="required:true" /></td>
                </tr>
                <tr>
                	<td>备注</td>
                	<td><textarea rows="4" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
        </form>
    </div>
</div>