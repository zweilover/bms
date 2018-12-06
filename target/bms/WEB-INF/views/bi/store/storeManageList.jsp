<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var storeManageListDataGrid;
    $(function() {
    	//所属区域下拉选项
    	$('#storeManageList_location').combobox({
    		url : '${path}/dictionary/selectDiByCode',
    		queryParams:{
    			"code": "CKSZQY"
    		},
    		valueField : 'code',
    		textField : 'name',
    		editable : false,
    		value : '${location}',
    	});
    	
        storeManageListDataGrid = $('#storeManageListDataGrid').datagrid({
        url : '${path}/store/storeManageList',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        checkOnSelect : false,
        //idField : 'id',
        //sortName : 'name',
       	//sortOrder : 'asc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
        	title : '',
        	field : 'checkbox',
        	checkbox : true
        },{
            title : '车辆ID',
            field : 'car_id'
        }] ], 
        columns : [ [{
            title : '车牌号',
            field : 'car_no'
        },{
            title : '运通卡号',
            field : 'card_no'
        },{
            title : '车辆状态',
            field : 'car_status',
            formatter : function(value, row, index) {
                switch (value) {
                case '0':
                    return '已入库';
                case '1':
                    return '已出库';
                 default :
                	 return value;
                }
            }
        },{
            title : '客户ID',
            field : 'customer_id',
            hidden : true
        },{
            title : '客户名称',
            field : 'customer_name'
        },{
            title : '车辆入库日期',
            field : 'in_time'
        },{
            title : '车辆出库日期',
            field : 'out_time'
        },{
            title : '入库id',
            field : 'in_st_id',
            hidden : true
        },{
            title : '货物入库日期',
            field : 'goods_in_time'
        },{
            title : '货物入库净重(吨)',
            field : 'goods_in_net',
            formatter : function(value, row, index) {
                var str = '-';
                if(row.goods_in_net > 0){
                	str = $.formatString('<a href="javascript:void(0)"  onclick="viewStoreManageFun(\'{0}\');" >'+row.goods_in_net+'</a>', row.in_st_id);
                }
                return str;
            }
        },{
            title : '货物入库数量',
            field : 'goods_in_amount',
            formatter : function(value, row, index){
            	var str = value;
            	if(value <= 0){
            		str = '-';
            	}
            	return str;
            }
        },{
            title : '出库id',
            field : 'out_st_id',
            hidden : true
        },{
            title : '货物出库日期',
            field : 'goods_out_time'
        },{
            title : '货物出库净重(吨)',
            field : 'goods_out_net',
            formatter : function(value, row, index) {
                var str = '-';
                if(row.goods_out_net > 0){
                	str = $.formatString('<a href="javascript:void(0)"  onclick="viewStoreManageFun(\'{0}\');" >'+row.goods_out_net+'</a>', row.out_st_id);
                }
                return str;
            }
        },{
            title : '货物出库数量',
            field : 'goods_out_amount',
            formatter : function(value, row, index){
            	var str = value;
            	if(value <= 0){
            		str = '-';
            	}
            	return str;
            }
        }] ],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#storeManageList_location').combobox({readonly: 'readonly'});
        	}
        },
        toolbar : '#storeManageListToolbar'
    });
    
    readCard4StoreManageList();//页面加载初始化读卡器
      
});

    
/**
 * 车辆出入库
 */
function storeManageAdd4Car(type){
	var checknodes = storeManageListDataGrid.datagrid('getChecked');
	if(checknodes && checknodes.length > 0){
		if(checknodes.length != 1){
			$.messager.alert('警告!','只能选中一行数据,请确认！','warning');
			return;
		}
	}else{
		$.messager.alert('警告!','请先选中一行数据！','warning');
		return;
	}
	
	if(checknodes[0].car_id == null || checknodes[0].car_id == ""){
		$.messager.alert('警告!','未获取到车辆信息，请确认！','warning');
		return;
	}
	
	var carId = checknodes[0].car_id;
	if(null == carId || typeof(carId) == "undefined" || carId <= 0){
		$.messager.alert('警告!','未获取到车辆信息，请确认！','warning');
		return;
	}

	var title,stId;
	if(type == '1'){
		title = '车辆出库';
		stId = checknodes[0].out_st_id;
		if(null != stId && typeof(stId) != "undefined" && stId != 0){
			$.messager.alert('警告!','所选数据已有出库记录，请重新选择！','warning');
			return;
		}
	}else if(type == '2'){
		title = '车辆入库';
		stId = checknodes[0].in_st_id;
		if(null != stId && typeof(stId) != "undefined" && stId != 0){
			$.messager.alert('警告!','所选数据已有入库记录，请重新选择！','warning');
			return;
		}
	}else{
		$.messager.alert('警告!','未获取到业务类型！','warning');
		return;
	}
	
	parent.$.modalDialog({
        title : title,
        width : 600,
        height : 500,
        href : '${path}/store/storeManageAdd4CarPage?carId='+carId +'&type='+type,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = storeManageListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#storeManageAdd4CarForm');
                f.submit();
            }
        } ]
    });
}

/**
 * 无车出入库
 */
function storeManageAddNoCarFun(type){
	var title;
	if(type == '1'){
		title = '无车出库';
	}else if(type == '2'){
		title = '无车入库';
	}else{
		$.messager.alert('警告!','未获取到业务类型！','warning');
		return;
	}
	
	parent.$.modalDialog({
        title : title,
        width : 600,
        height : 500,
        href : '${path}/store/storeManageAddNoCarPage?type='+type,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = storeManageListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#storeManageAddNoCarForm');
                f.submit();
            }
        } ]
    });
}

/**
 * 出入库编辑
 */
function storeManageEditFun(type){
	var checknodes = storeManageListDataGrid.datagrid('getChecked');
	if(checknodes && checknodes.length > 0){
		if(checknodes.length != 1){
			$.messager.alert('警告!','只能选中一行数据,请确认！','warning');
			return;
		}
	}else{
		$.messager.alert('警告!','请先选中一行数据！','warning');
		return;
	}
	
	var stId,title;
	if(type == '1'){
		title = '出库编辑';
		stId = checknodes[0].out_st_id;
		if(null == stId || typeof(stId) == "undefined" || stId <= 0){
			$.messager.alert('警告!','所选数据没有出库记录，请重新选择！','warning');
			return;
		}
	}else if(type == '2'){
		title = '入库编辑';
		stId = checknodes[0].in_st_id;
		if(null == stId || typeof(stId) == "undefined" || stId <= 0){
			$.messager.alert('警告!','所选数据没有入库记录，请重新选择！','warning');
			return;
		}
	}else{
		$.messager.alert('警告!','未获取到业务类型！','warning');
		return;
	}
	
	parent.$.modalDialog({
        title : title,
        width : 600,
        height : 500,
        href : '${path}/store/storeManageEditPage?stId='+stId,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = storeManageListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#storeManageEditForm');
                f.submit();
            }
        } ]
    });
}

function viewStoreManageFun(stId){
	parent.$.modalDialog({
        title : '查看详情',
        width : 600,
        height : 500,
        href : '${path}/store/storeManageViewPage?stId='+stId,
        buttons : [ {
            text : '关闭',
            handler : function() {
            	parent.$.modalDialog.handler.dialog('close');
            }
        } ]
    });
}

/**
 * 清除
 */
function storeManageListCleanFun() {
    $('#storeManageListSearchForm input').val('');
    $('#storeManageList_location').combobox("setValue",'');
    storeManageListDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function storeManageListSearchFun() {
     storeManageListDataGrid.datagrid('load', $.serializeObject($('#storeManageListSearchForm')));
}

//读卡器初始化
function readCard4StoreManageList(){
	tcom.init(tcom.COMOBJ);
	tcom.COMOBJ.OnDataIn = function (dat){
		if(null != dat.data && dat.data != ""){
			$("#storeManageList_cardNo").val(dat.data);
			// tcommClose();//关闭串口
			storeManageListDataGrid.datagrid('load', $.serializeObject($('#storeManageListSearchForm')));
		}
	};
}


</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 90px; overflow: hidden;background-color: #fff">
        <form id="storeManageListSearchForm">
            <table>
            	<tr>
                	<td>
                		车辆入库日期：
                		<input name="inTimeStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="inTimeEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />	
                		&nbsp;&nbsp;
                		车辆出库日期：
                		<input name="outTimeStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="outTimeEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                	<td>
                		货物入库日期：
                		<input name="goodsInTimeStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="goodsInTimeEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />	
                		&nbsp;&nbsp;
                		货物出库日期：
                		<input name="goodsOutTimeStart" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                		&nbsp;-&nbsp;
                		<input name="goodsOutTimeEnd" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 100px;" readonly="readonly" />
                	</td>
                </tr>
                <tr>
                    <td>
                    	车牌号:<input name="carNo" style="width: 80px;" />
                    	&nbsp;&nbsp;
                                                                        所属区域&nbsp;&nbsp;
                        <select id="storeManageList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	    &nbsp;&nbsp;
                   	            车辆状态&nbsp;&nbsp;
                   	    <select id="storeManageList_carStatus" name="carStatus" class="easyui-combobox" style="width: 80px;" data-options="width:100,panelHeight:'auto',editable:false">
                			<option value="">-- 全部 --</option>
                			<option value="0">已入库</option>
                			<option value="1">已出库</option>
                		</select>
                		&nbsp;&nbsp;
                   	   	运通卡号&nbsp;&nbsp;
                   	    <input id = "storeManageList_cardNo" name="cardNo" style="width: 80px;" readonly="readonly" />
                   	    &nbsp;&nbsp;
                   		<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4StoreManageList()">读卡</a>
                   		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="storeManageListSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="storeManageListCleanFun();">清空</a>
                    </td>
                </tr>
                
            </table>
            
            
        </form>
     </div>
     <div data-options="region:'center',border:false">
       	 <table id="storeManageListDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="storeManageListToolbar" style="display: none;">
    <shiro:hasPermission name="/store/storeInAdd4Car">
        <a onclick="storeManageAdd4Car('2');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">货物入库</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="/store/storeOutAdd4Car">
        <a onclick="storeManageAdd4Car('1');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">货物出库</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="/store/storeInAddNoCar">
        <a onclick="storeManageAddNoCarFun('2');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">无车入库</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="/store/storeOutAddNoCar">
        <a onclick="storeManageAddNoCarFun('1');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">无车出库</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="/store/storeInEdit">
        <a onclick="storeManageEditFun('2');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">入库编辑</a>
    </shiro:hasPermission>
    <shiro:hasPermission name="/store/storeOutEdit">
        <a onclick="storeManageEditFun('1');" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">出库编辑</a>
    </shiro:hasPermission>
</div>