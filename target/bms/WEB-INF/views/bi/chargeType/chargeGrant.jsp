<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var itemsGrid;
    $(function() {
        itemsGrid = $('#itemsGrid').datagrid({
            url : '${path }/chargeItem/allItems?location='+'${location}',
            rownumbers : true,
            idField : 'id',
            striped : true,
            fitColumns : true,
            checkOnSelect : false,
            columns : [ [ {
                width : '10',
                title : 'id',
                field : 'id',
                hidden : true
            } ,{
            	width : '20',
                title : '选择',
                field : 'ck',
                checkbox : true
            },{
            	width : '180',
                title : '子项名称',
                field : 'name'
            },{
           	 	width : '80',
             	title : '价格',
             	field : 'cost'
        	},{
            	width : '500',
                title : '子项描述',
                field : 'remark'
            }]],
            lines : true,
            checkbox : true,
            onClick : function(node) {},
            onLoadSuccess : function(node, data) {
                progressLoad();
                $.post( '${path }/chargeType/findItemListByTypeId', {
                    id : '${id}'
                }, function(result) {
                    var ids;
                    if (result.success == true && result.obj != undefined) {
                        ids = $.stringToList(result.obj + '');
                    }
                    //遍历选中已有子项
                    $.each(itemsGrid.datagrid('getRows'),function(i,e){
                    	for(var k = 0; k < ids.length; k++){
                    		if(e.id == ids[k]){
                    			itemsGrid.datagrid('checkRow',i);
                    		}
                    	}
                    });
                    
                }, 'json');
                progressClose();
            },
            cascadeCheck : false
        });

        $('#chargeGrantForm').form({
            url : '${path }/chargeType/grant',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                var checknodes = itemsGrid.datagrid('getChecked');
                var ids = [];
                if (checknodes && checknodes.length > 0) {
                    for ( var i = 0; i < checknodes.length; i++) {
                        ids.push(checknodes[i].id);
                    }
                }
                $('#itemIds').val(ids);
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
                	$.messager.alert('消息',result.msg,'info');
                }
            }
        });
    });
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<form id="chargeGrantForm" method="post">
		<input name="id" type="hidden"  value="${id}" readonly="readonly">
		<input id="itemIds" name="itemIds" type="hidden" />
		<table id="itemsGrid" style="width:700px;height:400px;overflow: hidden;"></table>
	</form>
</div>