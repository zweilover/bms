<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var viewItemsGrid;
    $(function() {
        viewItemsGrid = $('#viewItemsGrid').datagrid({
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
                    $.each(viewItemsGrid.datagrid('getRows'),function(i,e){
                    	for(var k = 0; k < ids.length; k++){
                    		if(e.id == ids[k]){
                    			viewItemsGrid.datagrid('checkRow',i);
                    		}
                    	}
                    });
                    
                }, 'json');
                progressClose();
            },
            cascadeCheck : false
        });
    });
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
	<form id="viewItemsForm" method="post">
		<input name="id" type="hidden"  value="${id}" readonly="readonly">
		<input id="itemIds" name="itemIds" type="hidden" />
		<table id="viewItemsGrid" style="width:700px;height:400px;overflow: hidden;"></table>
	</form>
</div>