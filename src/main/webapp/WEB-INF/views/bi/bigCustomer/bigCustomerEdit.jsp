<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
var bigCustomerItemGrid;
    $(function() {
        $('#bigCustomerEditForm').form({
            url : '${path}/bigCustomer/edit',
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
                    parent.$.modalDialog.openner_dataGrid.datagrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_dataGrid这个对象，是因为user.jsp页面预定义好了
                    parent.$.modalDialog.handler.dialog('close');
                } else {
                	$.messager.alert('错误',result.msg,'warning');
                }
            }
        });
        
        $("#status").val('${bigCustomer.status}'); 
        $("#isCredit").val('${bigCustomer.isCredit}'); 
        $("#remark").val("${bigCustomer.remark}"); 
        
        
        //计费子项列表
        bigCustomerItemGrid = $('#bigCustomerItemGrid').datagrid({
            url : '${path}/bigCustomer/getCustItemsByCustomerId',
            queryParams :{
            	customerId : '${bigCustomer.id}'
            },
            striped : true,
            rownumbers : true,
            singleSelect : true,
            idField : 'id',
            sortName : 'id',
            sortOrder : 'asc',
            frozenColumns : [ [ {
                width : '60',
                title : 'ID',
                field : 'id',
                hidden : true,
                sortable : true
            }] ], 
            columns : [ [{
            	width : '160',
                title : '计费子项名称',
                field : 'itemName',
                sortable : true
            },{
            	width : '70',
                title : '优惠金额',
                field : 'price'
            },{
            	width : '100',
                title : '备注',
                field : 'remark'
            },{
            	width : '60',
                title : '状态',
                field : 'status',
                sortable : true,
                formatter : function(value, row, index) {
                    switch (value) {
                    case '0':
                        return '正常';
                    case '1':
                        return '停用';
                     default :
                    	 return value;
                    }
                }
            }, {
                field : 'action',
                title : '操作',
                width : 150,
                formatter : function(value, row, index) {
                    var str = '';
                    <shiro:hasPermission name="/bigCustomer/editCustItem">
                        str += $.formatString('<a href="javascript:void(0)" class="bigCustomer-easyui-linkbutton-editCustItem" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="customerItemEditFun(\'{0}\');" >编辑</a>', row.id);
                    </shiro:hasPermission>
                    <shiro:hasPermission name="/bigCustomer/deleteCustItem">
                        str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                        str += $.formatString('<a href="javascript:void(0)" class="bigCustomer-easyui-linkbutton-delCustItem" data-options="plain:true,iconCls:\'fi-x icon-red\'" onclick="customerItemDelFun(\'{0}\');" >删除</a>', row.id);
                    </shiro:hasPermission>
                    return str;
                }
            } ] ],
            onLoadSuccess:function(data){
                 $('.bigCustomer-easyui-linkbutton-editCustItem').linkbutton({text:'编辑'});
                 $('.bigCustomer-easyui-linkbutton-delCustItem').linkbutton({text:'删除'});
            },
            toolbar : '#bigCustomerItemToolbar'
        });
        
    });

/**
 * 计费子项添加
 */
function customerItemAddFun(){
	$('#custItemAddPage').dialog({    
	    title: '优惠项目添加',    
	    width: 400,    
	    height: 300,    
	    closed: false,    
	    cache: false,    
	    href: '${path}/bigCustomer/addCustItemPage?customerId='+'${bigCustomer.id}',    
	    modal: true   
	});   
}
/**
 * 计费子项修改
 */
function customerItemEditFun(id){
	// parent.$.modalDialog.openner_dataGrid = bigCustomerItemGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
	$('#custItemEditPage').dialog({    
	    title: '优惠项目修改',    
	    width: 400,    
	    height: 300,    
	    closed: false,    
	    cache: false,    
	    href: '${path}/bigCustomer/editCustItemPage?id='+id,    
	    modal: true   
	});   
}
/**
 * 计费子项删除
 */
function customerItemDelFun(id){
	if (id == undefined) {//点击右键菜单才会触发这个
        var rows = bigCustomerItemGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {//点击操作里面的删除图标会触发这个
    	bigCustomerItemGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    parent.$.messager.confirm('询问', '您是否要删除此优惠项目？', function(b) {
        if (b) {
            progressLoad();
            $.post('${path}/bigCustomer/deleteCustItem', {
                id : id
            }, function(result) {
                if (result.success) {
                	$.messager.alert('消息',result.msg,'info');
                    bigCustomerItemGrid.datagrid('reload');
                }else{
                	$.messager.alert('错误',result.msg,'warning');
                }
                progressClose();
            }, 'JSON');
        }
    });
}
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" title="" style="overflow: hidden;padding: 3px;">
        <form id="bigCustomerEditForm" method="post">
            <table class="grid">
                <tr>
                	<input id="id" name="id" type="hidden"  value="${bigCustomer.id}">
                    <td><font color="red">*</font>客户名称</td>
                    <td><input name="name" type="text" placeholder="请输入客户名称" class="easyui-validatebox span2" data-options="required:true" value="${bigCustomer.name}"></td>
                    <td>排序</td>
                    <td>
                    	<input name="seq" class="easyui-numberspinner" value="${bigCustomer.seq}"
						style="width: 100px; height: 22px;" required="required"
						data-options="editable:false">
                    </td>
                </tr> 
                <tr>
                	<td>联系方式</td>
                	<td>
                		<input id="telephone" name="telephone" style="width: 140px;" class="easyui-textbox" value="${bigCustomer.telephone}"></input>
                	</td>
                	<td>通信地址</td>
                	<td><input id="address" name="address" style="width: 140px;" class="easyui-textbox" value="${bigCustomer.address}"></td>
                </tr>
                <tr>
                	<td><font color="red">*</font>是否支持月结</td>
                	<td>
                		<select id="isCredit" name="isCredit" class="easyui-combobox" data-options="width:140,editable:false,panelHeight:'auto'">
							<option value="0">是</option>
							<option value="1">否</option>
						</select>
                	</td>
                	<td>状态</td>
                	<td>
                		<select id="status" name="status" class="easyui-combobox" data-options="width:140,editable:false,panelHeight:'auto'">
							<option value="0">正常</option>
							<option value="1">停用</option>
						</select>
                	</td>
                </tr>
                <tr>
                	<td>备注</td>
                	<td><textarea rows="2" id="remark" name="remark" onkeydown="disabledEnterKey(event)"></textarea></td>
                </tr>
            </table>
            <div data-options="fit:true,region:'center',border:false">
        		<table id="bigCustomerItemGrid" data-options="border:false"></table>
			</div>
        </form>
    </div>

</div>

<div id="bigCustomerItemToolbar" style="display: none;">
    <shiro:hasPermission name="/bigCustomer/addCustItem">
        <a onclick="customerItemAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">添加优惠项目</a>
    </shiro:hasPermission>
</div>

<div id="custItemAddPage"></div>
<div id="custItemEditPage"></div>