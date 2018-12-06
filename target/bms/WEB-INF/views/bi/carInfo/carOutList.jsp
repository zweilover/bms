<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#carOutList_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});
    var carOutDataGrid;
    $(function() {
        carOutDataGrid = $('#carOutDataGrid').datagrid({
        url : '${path}/carInfo/dataGrid',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'in_time',
        sortOrder : 'desc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        frozenColumns : [ [ {
            title : 'ID',
            field : 'id'
            // sortable : true
        },{
            title : '车牌号',
            field : 'carNo',
            formatter: function(value,row,index){
            	var str = row.carNo;
            	<shiro:hasPermission name="/carInfo/viewCarOutPay">
        			str = $.formatString('<a href="javascript:void(0)"  onclick="viewCarOutPaymentFun(\'{0}\');" >'+row.carNo+'</a>', row.id);
        		</shiro:hasPermission>
                return str;
            }
        }]], 
        columns :[[{
            title : '运通卡号',
            field : 'cardNo'
        },{
            title : '是否年卡',
            field : 'isYearCard',
            formatter : function(value, row, index) {
                switch (value) {
                case '0':
                    return '是';
                case '1':
                    return '否';
                default :
                	return value;
                }
            }
        },{
            title : '所属区域',
            field : 'locationName'
        },{
            title : '客户名称',
            field : 'customerName'
        },{
            title : '入库时间',
            field : 'inTime'
        },{
            title : '入库办理人',
            field : 'inUserName'
        },{
            title : '入库说明',
            field : 'inRemark'
        },{
            title : '出库时间',
            field : 'outTime'
        },{
            title : '出库办理人',
            field : 'outUserName'
        },{
            title : '出库说明',
            field : 'outRemark'
        },{
            title : '计费项目',
            field : 'chargeTypeName'
        },{
            title : '车辆状态',
            field : 'carStatus',
            formatter : function(value, row, index) {
                switch (value) {
                case '0':
                    return '已入库';
                case '1':
                    return '已出库';
                case '2':
                	return '已删除';
                default :
                	return value;
                }
                
            }
        },{
            field : 'action',
            title : '操作',
            width : '190',
            formatter : function(value, row, index) {
                var str = '';
                if(row.carStatus == '0'){//入库状态
                	<shiro:hasPermission name="/carInfo/carOut">
                    	str += $.formatString('<a href="javascript:void(0)" class="carOut-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="carOutPaymentFun(\'{0}\');" ></a>', row.id);
                	</shiro:hasPermission>
                }else if(row.carStatus == '1'){//出库状态
                	<shiro:hasPermission name="/carInfo/viewCarOutPay">
                		str += $.formatString('<a href="javascript:void(0)" class="carOut-easyui-linkbutton-viewPay" data-options="plain:true,iconCls:\'fi-eye icon-blue\'" onclick="viewCarOutPaymentFun(\'{0}\');" ></a>', row.id);
            		</shiro:hasPermission>
                }
                <shiro:hasPermission name="/carInfo/appendCharge">
        			str += $.formatString('<a href="javascript:void(0)" class="charge4Yundi-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-plus icon-blue\'" onclick="carCharge4YundiFun(\'{0}\');" ></a>', row.id);
        		</shiro:hasPermission>
                <shiro:hasPermission name="/carInfo/sysEdit">
        			str += $.formatString('<a href="javascript:void(0)" class="carSysEdit-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'fi-pencil icon-blue\'" onclick="carSysEdittFun(\'{0}\');" >修改</a>', row.id);
    		    </shiro:hasPermission>
                return str;
            }
        } ] ],
        onBeforeEdit : function(index,row){
        	row.editing = true;
        },
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#carOutList_location').combobox({readonly: 'readonly'});
        	}
            $('.carOut-easyui-linkbutton-edit').linkbutton({text:'出库'});
            $('.charge4Yundi-easyui-linkbutton-edit').linkbutton({text:'运抵/停车'});
            $('.carOut-easyui-linkbutton-viewPay').linkbutton({text:'查看'});
            $('.carSysEdit-easyui-linkbutton-edit').linkbutton({text:'修改'});
        },
        toolbar : '#carOutToolbar'
    });
    
    readCard4CarOutList();//页面加载初始化读卡器
});

/**
 * 出库收费
 * @param url
 */
function carOutPaymentFun(id) {
	parent.$.modalDialog.openner_dataGrid = carOutDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
    parent.$.modalDialog({
        title : '出库收费',
        width : 750,
        height : 530,
        href :  '${path}/carInfo/paymentPage?id=' + id
    });
}
/**
 * 运抵费
 * @param url
 */
function carCharge4YundiFun(id) {
	parent.$.modalDialog.openner_dataGrid = carOutDataGrid;//因为添加成功之后，需要刷新这个dataGrid，所以先预定义好
    parent.$.modalDialog({
        title : '运抵费',
        width : 700,
        height : 350,
        href :  '${path}/carInfo/charge4YundiPage?id=' + id
    });
}

/**
 * 查看出库付款单
 * @param url
 */
function viewCarOutPaymentFun(id) {
    parent.$.modalDialog({
        title : '查看明细',
        width : 750,
        height : 500,
        href :  '${path}/carInfo/viewCarOutPayPage?id=' + id
    });
}

/**
 * 制卡
 * 
 */
function carOutAddFun() {
    parent.$.modalDialog({
        title : '制卡',
        width : 400,
        height : 300,
        href : '${path}/carInfo/addPage',
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = carOutDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#carInfoAddForm');
                f.submit();
            }
        } ]
    });
}

/**
 * 管理员修改
 */
function carSysEdittFun(id){
	if (id == undefined) {
        var rows = carOutDataGrid.datagrid('getSelections');
        id = rows[0].id;
    } else {
    	carOutDataGrid.datagrid('unselectAll').datagrid('uncheckAll');
    }
    
    parent.$.modalDialog({
        title : '修改',
        width : 750,
        height : 500,
        href :  '${path}/carInfo/carSysEditPage?id=' + id,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = carOutDataGrid;//因为修改成功之后，需要刷新这个dataGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#carSysEditForm');
                f.submit();
            }
        } ]
    });
}

/**
 * 清除
 */
function carOutListCleanFun() {
    $('#carOutSearchForm input').val('');
    $('#carOutList_carStatus').combobox('setValue',"");//清空车辆状态
    $('#carOutList_location').combobox('setValue','');//所属区域
    carOutDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function carOutListSearchFun() {
     carOutDataGrid.datagrid('load', $.serializeObject($('#carOutSearchForm')));
}

//读卡器初始化
function readCard4CarOutList(){
	tcom.init(tcom.COMOBJ);
	tcom.COMOBJ.OnDataIn = function (dat){
		if(null != dat.data && dat.data != ""){
			$("#carOutList_cardNo").val(dat.data);
			// tcommClose();//关闭串口
			carOutDataGrid.datagrid('load', $.serializeObject($('#carOutSearchForm')));
		}
	};
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="carOutSearchForm">
            <table>
                <tr>
                    <td>车牌号</td>
                    <td><input name="carNo" placeholder="请输入车牌号" style="width: 100px;" />
                    &nbsp;&nbsp;
                                                            所属区域&nbsp;&nbsp;
                    <select id="carOutList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>&nbsp;&nbsp;&nbsp;车辆状态:</td>
                    <td>
                    	<select id="carOutList_carStatus" name="carStatus" class="easyui-combobox" data-options="width:100,panelHeight:'auto',editable:false">
                			<option value="">---- 全部 ----</option>
                			<option value="0">已入库</option>
                			<option value="1">已出库</option>
                		</select>
                		&nbsp;&nbsp;
                                                                      运通卡号:&nbsp;&nbsp;
                    	<input id="carOutList_cardNo" name="cardNo" style="width: 80px;" readonly="readonly" />
                		&nbsp;&nbsp;
                   		<a class="easyui-linkbutton" href="javascript:void(0)" onclick="javascript:readCard4CarOutList()">读卡</a>
                    </td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="carOutListSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="carOutListCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="carOutDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>

<div id="carOutToolbar" style="display: none;">
    <shiro:hasPermission name="/carInfo/add">
        <a onclick="carOutAddFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">制卡</a>
    </shiro:hasPermission>
</div>