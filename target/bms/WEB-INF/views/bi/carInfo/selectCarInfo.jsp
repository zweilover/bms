<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    var selectCarInfoDataGrid;
    $(function() {
        selectCarInfoDataGrid = $('#selectCarInfoDataGrid').datagrid({
        url : '${path}/carInfo/selectCarList4CarOut',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        idField : 'id',
        sortName : 'out_time',
        sortOrder : 'desc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        columns : [ [{
            width : '30',
            title : 'ID',
            field : 'id',
            hidden : true,
            sortable : true
        },{
        	width : '100',
            title : '车牌号',
            field : 'carNo'
        },{
        	width : '60',
            title : '所属区域',
            field : 'location'
        },{
        	width : '120',
            title : '入库日期',
            field : 'inTime'
        },{
        	width : '120',
            title : '出库日期',
            field : 'outTime'
        },{
        	width : '60',
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
        	width : '60',
            title : '状态',
            field : 'carStatus',
            sortable : true,
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
        	width : '100',
            title : '入库描述',
            field : 'inRemark'
        },{
        	width : '100',
            title : '出库描述',
            field : 'outRemark'
        }] ],
        onLoadSuccess:function(data){
           
        },
        onDblClickRow:function(index,row){
        	window.parent.selectCarInfoCallback(row);//父窗体的回调函数
        	$('#selectCarInfo').window('close');//
        }
    });
});

/**
 * 清除
 */
function carInfoCleanFun() {
    $('#carInfoSelectForm input').val('');
    selectCarInfoDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function carInfoSearchFun() {
     selectCarInfoDataGrid.datagrid('load', $.serializeObject($('#carInfoSelectForm')));
}
</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 30px; overflow: hidden;background-color: #fff">
        <form id="carInfoSelectForm">
            <table>
                <tr>
                    <th>车牌号:</th>
                    <td><input name="carNo" placeholder=""/></td>
                    <td>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="carInfoSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="carInfoCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="selectCarInfoDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
