<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
</script>

<div id="Editwin" class="easyui-window" title="制卡" style="width: 400px; height: auto;top:105px" data-options="closed:true,collapsible:false,minimizable:false,maximizable:false"> 
  <div style="margin-top: 30px; margin-bottom: 30px; margin-left: 70px;"> 
    <form id="makeCardForm" method="post"> 
      <table> 
		<tr>
        	<td style="width:60px;">运通卡号</td>
        	<td style="width:100px">
            	<input name="carId" class="mini-textbox" readonly="readonly"/>
        	</td>
   		</tr>
    	<tr>
        	<td>车牌号</td>
        	<td>
            	<input name="carNo" class="mini-textbox" />
        	</td>
    	</tr>
    	<tr>
    		<td>是否临时卡</td>
        	<td>
        		<input name="isTempCard" class="mini-radiobuttonlist" data="[{id: 1, text: '是'}, {id: 2, text: '否'}]"/>
        	</td>
   		</tr>
      </table> 
      <div style="margin-top: 20px;"> 
        <a class="easyui-linkbutton" data-options="iconCls:'icon-ok'" style="margin-left: 10px;" onclick="EditsubmitForm()">确定</a> 
        <a class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" style="margin-left: 60px;" onclick="EditclearForm()">取消</a> 
      </div> 
    </form> 
  </div> 
</div> 


<table border="0" cellpadding="1" cellspacing="2">
    <tr>
        <td style="width:60px;">运通卡号</td>
        <td style="width:100px">
            <input name="carId" class="mini-textbox" readonly="readonly"/>
        </td>
    </tr>
    <tr>
        <td>车牌号</td>
        <td>
            <input name="carNo" class="mini-textbox" />
        </td>
    </tr>
    <tr>
    	<td>是否临时卡</td>
        <td>
        	<input name="isTempCard" class="mini-radiobuttonlist" data="[{id: 1, text: '是'}, {id: 2, text: '否'}]"/>
        </td>
   	</tr>
   	<tr>
   		
   	</tr>
</table>
