<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>web调用comm调试页面</title>
</head>
<body>
<script type="text/javascript">
var tcom=null;
$(function(){
	comlist();
})
function closeCom(){
	if ($("#btnOpen").val() == "关闭串口") {
        $("#btnOpen").val("打开串口");
    }
	tcom.Close(function(){
		//alert("已关闭");
	});
}
function send(){
	if(CUR_SJT!="HEX"){
  		tcom.Send($("#t_sdata").val()+"\r",function(dat){if(dat.STAT==1){alert("发送成功！")}else{alert("发送失败！")}});//往端口发送数据
	}else{
		tcom.Send($("#t_sdata").val(),function(dat){if(dat.STAT==1){alert("发送成功！")}else{alert(dat.STAT+"发送失败！")}});//往端口发送数据
	}
}
function comlist() {
	debugger;
	var objTComm = new TComm("COM1", "9600,N,8,1");
	objTComm.Register("ab441c4f6540cbffb6528b7a52fde693caa15ac1b33595b43b97fc7ec43f232790a650a3817f7b2541971ba70bd8df61ebd5242e8c07fa00d644179918c219037efe85df300381d5", function (dat) {
        if (dat.STAT == 11) {
            objTComm.getComList(function (dat) {
                if(dat.COMS.length>0){
					$(dat.COMS).each(function(i){
					$("<option value='"+dat.COMS[i].PName.substr(3)+"'>"+dat.COMS[i].PName+"("+dat.COMS[i].FName+")"+"</option>").insertBefore($("#COMLI option:first"))
				})
					document.getElementById("COMLI").selectedIndex=0;
				}
            });
        }
	});
}
//选择并打开端口
var CUR_SJT = "";
function selcomport() {//tcom.SelectComm()
    CUR_SJT = $("#ssjt").val();
    var comNo = 0;
    if ($("#COMLI").val() != "-1") {
        comNo = $("#COMLI").val();
    } else {
        //comNo=tcom.SelectComm();
        alert("请选择串口！"); 
        return;
    }
    var comSet = $("#sbtl").val() + "," + $("#sjyw").val() + "," + $("#ssjw").val() + "," + $("#stzw").val();
    if ($("#btnOpen").val() == "关闭串口") {
        closeCom();
        $("#btnOpen").val("打开串口");
        return;
    } else {
        tcom = new TComm(comNo, comSet, $("#ssjt").val(),5);
        tcom.Register("ab441c4f6540cbffb6528b7a52fde693caa15ac1b33595b43b97fc7ec43f232790a650a3817f7b2541971ba70bd8df61ebd5242e8c07fa00d644179918c219037efe85df300381d5", function (dat) {
            if (dat==-99 || dat.STAT == -99) {
                if (confirm("您还没有安装串口插件\n\n现在下载安装吗？")) {
                    location = "http://d.iyanhong.com/files/TComm2.exe";
                }
            } else if (dat.STAT == 11) {
                tcom.init(function (ret) {
                    if (ret.STAT == 1) {
                        $("#btnSend").attr("disabled", false); $("#btnOpen").val("关闭串口");
                    } else {
                        alert("打开串口失败!");
                    }
                });
            } else {
                alert("注册失败,请与您的服务商联系!");
            }
        });
        
        tcom.OnDataIn = function (dat) { //接收串口返回数据
	    	if ($("#t_dataIn").val().length > 10000) {
	    		$("#t_dataIn").val("");
	    	}
        	if (CUR_SJT == "hex") {
            	$("#t_dataIn").val($("#t_dataIn").val() +"\n" + dat.data);
        	} else {
            	$("#t_dataIn").val($("#t_dataIn").val() +"\n" + dat.data);
        	}
	    	if($("#t_dataIn").val().substr($("#t_dataIn").val().length-9)=="0000027A9"){
	    		$("#t_dataIn").val($("#t_dataIn").val()+"\n");
	    	} 
	    	closeCom();
        }
    }
}
</script>

<table width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr><td height="30" style="border-bottom:solid 1px #ccc;"></td></tr>
<tr><td>
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr><td width="200" valign="top">
<table width="100%" cellpadding="0" cellspacing="2">
<tr><td width="80">串口</td><td><select id="COMLI" style="width:130px">
<option value="-1">选择串口</option>
<option value="1">COM1</option>
<option value="2">COM2</option>
<option value="3">COM3</option>
<option value="4">COM4</option>
<option value="5">COM5</option>
<option value="6">COM6</option>
<option value="7">COM7</option>
<option value="8">COM8</option>
<option value="9">COM9</option>
<option value="10">COM10</option>
<option value="11">COM11</option>
<option value="12">COM12</option>
<option value="13">COM13</option>
<option value="14">COM14</option>
</select></td></tr>
<tr><td width="80">波特率：</td><td><select id="sbtl">
		<option value="300">300</option>
		<option value="600">600</option>
		<option value="1200">1200</option>
		<option value="2400">2400</option>
		<option value="4800">4800</option>
		<option value="9600" selected>9600</option>
		<option value="19200">19200</option>
		<option value="38400">38400</option>
		<option value="57600">57600</option>
		<option value="115200">115200</option>
		
	</select></td></tr>
<tr><td>数据位：</td><td><select id="ssjw">
		<option value="5">5</option>
		<option value="6">6</option>
		<option value="7">7</option>
		<option value="8" selected>8</option>
	</select></td></tr>
<tr><td>校验位：</td><td><select id="sjyw">
		<option value="N" selected>None</option>
		<option value="O">Odd</option>
		<option value="E">Even</option>
		<option value="M">Mark</option>
		<option value="S">Space</option>
	</select></td></tr>
<tr><td>停止位：</td><td><select id="stzw">
		<option value="1" selected>1</option>
		<option value="2">2</option>
	</select></td></tr>
<tr><td>格式：</td><td><select id="ssjt">
		<option value="HEX">HEX</option>
		<option value="utf-8" selected>utf-8</option>
		<option value="Unicode">Unicode</option>
	</select></td></tr>
<tr><td></td><td><input type="button" id="btnOpen" value="打开串口" onclick="selcomport()"/></td></tr>
<tr><td></td><td></td></tr>
</table>
</td><td>
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr><td height="100">
<form onsubmit="send();return false;">
<table width="100%" height="100%" cellpadding="0" cellspacing="0">
<tr><td><textarea id="t_sdata" style="width:100%;height:80px;" />41 54 0D</textarea><br />
(41 54 0D为“AT\r”转换为HEX)</td><td width="100" align=center><input type="submit" value="发送" disabled id="btnSend" style="height:60px;width:60px;" /></td></tr>
</table>
</form>
</td></tr>
<tr><td><textarea id="t_dataIn" style="width:90%;height:100%"></textarea></td></tr>
</table>
</td>
</table>
</td></tr>
</table>

</body>
</html>
