<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
$(function(){
  	//textarea赋值 
	$("#importCcDetail_bgdh").val('${detail.bgdh}'); 
	$("#importCcDetail_czts").val('${detail.czts}'); 
});
    
</script>
<form id="importCcDetailForm" method="post">
    <table class="grid" style="width: 550px;table-layout: fixed;">
        <tr>
        	<input id="id" name="id" type="hidden" value="${detail.id}">
            <td width="20%">出仓标识</td>
            <td width="30%">${detail.ccid}</td>
        	<td width="20%">车牌号</td>
        	<td width="30%">${detail.ch}</td>
        </tr> 
        <tr>
            <td width="20%">运通卡类型</td>
            <td width="30%">${detail.ytklx}</td>
        	<td width="20%">运通卡号</td>
        	<td width="30%">${detail.kh}</td>
        </tr> 
        <tr>
            <td width="20%">车辆备案重量(KG)</td>
            <td width="30%">${detail.clbazl}</td>
        	<td width="20%">地磅采集重量(KG)</td>
        	<td width="30%">${detail.dbcjzl}</td>
        </tr> 
        <tr>
            <td width="20%">出仓时间</td>
            <td width="30%">${detail.ccsj}</td>
        	<td width="20%">货物净重(KG)</td>
        	<td width="30%">${detail.hwjz}</td>
        </tr> 
        <tr>
            <td width="20%">电子锁编号1</td>
            <td width="30%">${detail.dzsbh1}</td>
        	<td width="20%">电子锁编号2</td>
        	<td width="30%">${detail.dzsbh2}</td>
        </tr> 
        <tr>
            <td width="20%">车辆类型</td>
            <td width="30%">${detail.cllx}</td>
        	<td width="20%">状态</td>
        	<td width="30%">${detail.zt}</td>
        </tr> 
        <tr>
            <td width="20%">报关单号</td>
            <td width="30%">
            	<textarea style="resize:none;border: 0" rows="2" id="importCcDetail_bgdh"  readonly="readonly"></textarea>
            </td>
        	<td width="20%">操作提示</td>
        	<td width="30%">
        		<textarea style="resize:none;border: 0" rows="2" id="importCcDetail_czts"  readonly="readonly"></textarea>
        	</td>
        </tr> 
        <tr>
            <td width="20%">数据导入人</td>
            <td width="30%">${detail.createUser}</td>
        	<td width="20%">数据导入日期</td>
        	<td width="30%">${detail.createTime}</td>
        </tr> 
    </table>
    <div style="text-align:center;">
    	<a href="#" class="easyui-linkbutton" onclick="javascript:parent.$.modalDialog.handler.dialog('close')">关闭</a>
    </div>
</form>

