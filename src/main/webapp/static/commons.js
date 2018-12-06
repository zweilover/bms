//禁用回车键换行，适用于textarea换行
function disabledEnterKey(e){
	var et=e||window.event;
	var keycode=et.charCode||et.keyCode;
	if(keycode==13){
		if(window.event){
			window.event.returnValue = false;
		}else{
			e.preventDefault();//for firefox
		}
	}
}

/**
 * 获取两个日期之前相差天数
 * @param date1 开始日期
 * @param date2 结束日期
 * @returns 天数，24小时为一天，超过则+1天
 */
function dateDifference(date1,date2){
	var days = 0;
	if(date1 == "" || date1 == null || date2 == "" || date2 == null){//为空时返回0天
		return days;
	}
	var t1 = parserDate(date1.replace(/-/g,"/")).getTime();
	var t2 = parserDate(date2.replace(/-/g,"/")).getTime();
	if(t1 > t2){
		return days;
	}
	days = parseInt((t2-t1)/(1000 * 60 * 60 * 24));
	return days + 1;
}

/**
 * 获取两个日期之前相差天数
 * @param date1 开始日期 转换为YYYY-MM-DD
 * @param date2 结束日期 转换为YYYY-MM-DD
 * @returns 天数
 */
function dateDifference2(date1,date2){
	var days = 0;
	if(date1 == "" || date1 == null || date2 == "" || date2 == null){//为空时返回0天
		return days;
	}
	var t1 = parserDate(date1.substring(0,10).replace(/-/g,"/")).getTime();
	var t2 = parserDate(date2.substring(0,10).replace(/-/g,"/")).getTime();
	if(t1 > t2){
		return days;
	}
	days = parseInt((t2-t1)/(1000 * 60 * 60 * 24));
	return days + 1;
}

/**
 * 格式化日期 格式：YYYY-MM-DD HH:mm:ss / YYYY-MM-DD
 */
var parserDate = function(date) {  
    var t = Date.parse(date);  
    if (!isNaN(t)) {  
        return new Date(Date.parse(date.replace(/-/g, "/")));  
    } else {  
        // return new Date();  
        return "";
    }  
}

/**
 * 获取当前时间，格式YYYY-MM-DD
 * @returns {String}
 */
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = year + seperator1 + month + seperator1 + strDate;
    return currentdate;
}

