<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
//所属区域下拉选项
$('#matchCcList_location').combobox({
	url : '${path }/dictionary/selectDiByCode',
	queryParams:{
		"code": "CKSZQY"
	},
	valueField : 'code',
	textField : 'name',
	editable : false,
	value : '${location}'
});   

    var matchCcListDataGrid;
    $(function() {
        matchCcListDataGrid = $('#matchCcListDataGrid').datagrid({
        url : '${path}/checkData/queryMatchCcDataList',
        striped : true,
        rownumbers : true,
        pagination : true,
        singleSelect : true,
        checkOnSelect : false,
        idField : 'id',
        // sortName : 'ccsj',
        // sortOrder : 'desc',
        pageSize : 20,
        pageList : [ 10, 20, 30, 40, 50, 100, 200, 300, 400, 500],
        rowStyler : function(index,row){
        	if(row.mttype == null || row.mttype == ''){ //未匹配
        		return 'background-color:#FF0000;';
        	}
        	if(row.mttype == '3'){ //无车匹配
        		return 'background-color:#FFFF00;';
        	}
        	if(row.ch != row.mtcarno && row.mttype == '2'){ //手动匹配车牌号不一致
        		return 'background-color:#32CD32;';
        	}
        },
        columns :[[{
        	title : '海关系统导入信息',
            colspan : 9
        },{
        	title : '计费系统车辆信息',
            colspan : 5
        },{
        	title : '匹配结果',
            colspan : 5
        }],
        //第二列
        [{
        	title : '',
        	field : 'checkbox',
        	checkbox : true
        },{
        	title : 'ID',
        	field : 'id'
        },{
        	title : '车牌号',
        	field : 'ch'
        },{
        	title : '运通卡号',
        	field : 'kh',
        	formatter: function(value,row,index){
            	var str = '';
            	if(null != row.id && row.id != 'undefined'){
        			str = $.formatString('<a href="javascript:void(0)"  onclick="viewImportCcDetail(\'{0}\');" >'+row.kh+'</a>', row.id);
            	}
                return str;
            }
        },{
        	title : '出仓时间',
        	field : 'ccsj'
        },{
        	title : '仓库名称',
        	field : 'ckmc'
        },{
        	title : '车辆类型',
        	field : 'cllx'
        },{
        	title : '运通卡类型',
        	field : 'ytklx'
        },{
        	title : '操作提示',
        	field : 'czts'
        },{
        	title : 'ID',
        	field : 'mtcarid'
        },{
        	title : '车牌号',
        	field : 'mtcarno',
        	formatter: function(value,row,index){
            	var str = '';
            	if(null != row.mtcarid && row.mtcarid != 'undefined'){
        			str = $.formatString('<a href="javascript:void(0)"  onclick="viewCarOutPaymentFun(\'{0}\');" >'+row.mtcarno+'</a>', row.mtcarid);
            	}
                return str;
            }
        },{
        	title : '运通卡号',
        	field : 'cardno'
        },{
        	title : '车辆出库日期',
        	field : 'carouttime'
        },{
        	title : '计费类型',
        	field : 'chargetype'
        },{
        	title : '匹配id',
        	field : 'mtid',
        	hidden : true
        },{
        	title : '匹配类型',
        	field : 'mttype',
        	formatter : function(value, row, index) {
                switch (value) {
                case '1':
                    return '自动匹配';
                case '2':
                    return '手动匹配';
                case '3':
                	return '无车匹配'
                default :
                	return '未匹配';
                }
            }
        },{
        	title : '操作人',
        	field : 'mtusername'
        },{
        	title : '操作日期',
        	field : 'mtupdatetime'
        },{
        	title : '匹配说明',
        	field : 'mtremark'
        }]],
        onLoadSuccess:function(data){
        	var location = '${location}';
        	if(null != location && "" != location){//所属区域不为空时，只能查看用户指定的区域
        		$('#matchCcList_location').combobox({readonly: 'readonly'});
        	}
        	matchCcListDataGrid.datagrid('clearChecked'); //清除选中行
        },
        toolbar : '#matchCcListDataToolbar'
    });
});

/**
 * 出仓数据自动匹配
 * 
 */
function autoMatchCcDataFun() {
	if($('#matchCcListDataGrid').datagrid('getRows').length <= 0){
		$.messager.alert('警告!','请先查询出仓数据！','warning');
		return;
	}
	
	progressLoad();
    $.ajax({
    	type : "get",
    	cache:false, 
    	async:true,//异步
    	dataType:'json',
    	data:{
    		'location' : $('#matchCcList_location').combobox('getValue'),
    		'carNo' : $('#matchCcList_carNo').val(),
    		'busiDate' : $('#matchCcList_busiDate').val()
    	},
    	url:'${path}/checkData/dealAutoMatchCcData',
    	success:function(result, textStatus){
    		progressClose();
    		if (result.success) {
            	matchCcListDataGrid.datagrid('load', $.serializeObject($('#matchCcListDataSearchForm')));
            	$.messager.alert('消息',result.msg,'info');
            } else {
            	$.messager.alert('错误',result.msg,'warning');
            }
    	}
    });
}


/**
 * 出仓数据手动匹配
 */
function manualMatchCcDataFun() {
	var checknodes = matchCcListDataGrid.datagrid('getChecked');
	if(checknodes && checknodes.length > 0){
		if(checknodes.length != 1){
			$.messager.alert('警告!','手动匹配只能选中一行数据！','warning');
			return;
		}
	}else{
		$.messager.alert('警告!','请先选中一行数据！','warning');
		return;
	}
	var location = $('#matchCcList_location').combobox('getValue');
    parent.$.modalDialog({
        title : '出仓数据手动匹配',
        width : 400,
        height : 300,
        href : '${path}/checkData/manualMatchCcDataPage?ccId='+checknodes[0].id+'&ccNo='+checknodes[0].ch+'&mtId='+checknodes[0].mtid+'&ccsj='+checknodes[0].ccsj+'&location='+location,
        buttons : [ {
            text : '确定',
            handler : function() {
                parent.$.modalDialog.openner_dataGrid = matchCcListDataGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                var f = parent.$.modalDialog.handler.find('#manualMatchCcDataForm');
                f.submit();
            }
        } ]
    });
}

/**
 * 清除
 */
function matchCcListDataCleanFun() {
    $('#matchCcListDataSearchForm input').val('');
    $('#matchCcList_location').combobox('setValue','');//所属区域
    matchCcListDataGrid.datagrid('load', {});
}
/**
 * 搜索
 */
function matchCcListDataSearchFun() {
	var location = $('#matchCcList_location').combobox('getValue');
	var busiDate = $('#matchCcList_busiDate').val();
	if(null == location || location == ""){
		$.messager.alert('警告!','所属区域为必输项！','warning');
		return;
	}
	if(null == busiDate || busiDate == ""){
		$.messager.alert('警告!','出仓日期为必输项！','warning');
		return;
	}
	matchCcListDataGrid.datagrid('load', $.serializeObject($('#matchCcListDataSearchForm')));
}

/**
 * 查看出库付款单明细
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
 * 查看出仓导入数据明细
 * @param url
*/
function viewImportCcDetail(id) {
   parent.$.modalDialog({
       title : '查看明细',
       width : 560,
       height : 400,
       href :  '${path}/checkData/viewImportCcDetail?id=' + id
   });
}

</script>

<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'north',border:false" style="height: 45px; overflow: hidden;background-color: #fff">
        <form id="matchCcListDataSearchForm">
            <table>
                <tr>
                    <td>车牌号:</td>
                    <td><input id="matchCcList_carNo" name="carNo" placeholder="请输入车牌号" style="width: 100px;"/>
                    &nbsp;&nbsp;
                                                            所属区域：&nbsp;&nbsp;
                    <select id="matchCcList_location" name="location" style="width: 70px;" data-options="panelHeight:'auto'" class="easyui-combobox"></select>
                   	&nbsp;&nbsp;
                    </td>
                    <td>出仓日期:&nbsp;&nbsp;</td>
                    <td>
                    	<input id="matchCcList_busiDate" name="busiDate" placeholder="" onclick="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" style="width: 90px;" readonly="readonly" value="${busiDate}" />
                		&nbsp;&nbsp;
                                                                       匹配类型：&nbsp;&nbsp;
                        <select id="matchCcList_matchType" name="matchType" style="width: 80px;" data-options="panelHeight:'auto'" class="easyui-combobox">
                        	<option value="">--- 全部 ---</option>
                			<option value="0">未匹配</option>
                			<option value="1">自动匹配</option>
                			<option value="2">手动匹配</option>
                			<option value="3">无车匹配</option>
                        </select>
                                                                       
                    </td>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <td>
                    	&nbsp;&nbsp;&nbsp;
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-magnifying-glass',plain:true" onclick="matchCcListDataSearchFun();">查询</a>
                        <a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'fi-x-circle',plain:true" onclick="matchCcListDataCleanFun();">清空</a>
                    </td>
                </tr>
            </table>
        </form>
     </div>
 
    <div data-options="region:'center',border:false">
        <table id="matchCcListDataGrid" data-options="fit:true,border:false"></table>
    </div>
</div>
<div id="matchCcListDataToolbar" style="display: none;">
    <shiro:hasPermission name="/checkData/matchCcData">
        <a onclick="autoMatchCcDataFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">自动匹配</a>
        <a onclick="manualMatchCcDataFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'fi-page-add'">手动匹配</a>
    </shiro:hasPermission>
    <div align="left">
    	<table width="300" cellspacing="3" style="font-size:14px;border-collapse:collapse" cellspacing="0" cellpadding="0" border="0" bordercolor="#cccccc">
    		<tbody>
    			<tr>
    				<td bgcolor="#FF0000" height="10" width="15"></td>
    				<td>未匹配</td>
    				<td bgcolor="#FFFF00" height="10" width="15"></td>
    				<td>无车匹配</td>
    				<td bgcolor="#32CD32" height="10" width="15"></td>
    				<td>匹配车牌号不一致</td>
    			</tr>
    		</tbody>
    	</table>
    </div>
</div>